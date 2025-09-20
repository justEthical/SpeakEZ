import 'dart:convert';
import 'dart:io';

/// ====== CONFIG ======
const String folderPath = '/Users/ash/47/SpeakEZ/assets/lessons/B1'; // <- change if needed
const int minPerPool = 5;

/// If you want to enforce certain pool names exist, list them here.
/// Leave empty to simply validate whatever pools are present.
const List<String> requiredPools = [
  // 'vocabulary', 'sentence', 'listening', 'speaking',
];

Future<void> main() async {
  final dir = Directory(folderPath);

  if (!await dir.exists()) {
    stderr.writeln("❌ Folder not found: $folderPath");
    exit(1);
  }

  final files = dir
      .listSync(recursive: false, followLinks: false)
      .whereType<File>()
      .where((f) => f.path.toLowerCase().endsWith('.json'))
      .toList();

  if (files.isEmpty) {
    print("⚠️ No JSON files in $folderPath");
    return;
  }

  int ok = 0, fail = 0;

  for (final file in files) {
    final path = file.path;
    try {
      // Read and strip potential UTF-8 BOM
      var raw = await file.readAsString();
      if (raw.isNotEmpty && raw.codeUnitAt(0) == 0xFEFF) {
        raw = raw.substring(1);
      }

      final data = jsonDecode(raw);
      if (data is! Map || data['question_pools'] is! Map) {
        print("❌ $path → invalid structure: 'question_pools' must be a Map");
        fail++;
        continue;
      }

      final qp = data['question_pools'] as Map;

      // Check required pools (if any)
      final missingRequired = <String>[];
      if (requiredPools.isNotEmpty) {
        for (final pool in requiredPools) {
          if (!qp.containsKey(pool)) missingRequired.add(pool);
        }
      }

      final problems = <String>[];

      if (missingRequired.isNotEmpty) {
        problems.add("Missing required pools: ${missingRequired.join(', ')}");
      }

      // Validate every present pool (or just the required ones if you prefer)
      for (final entry in qp.entries) {
        final poolName = entry.key.toString();
        final value = entry.value;

        if (value is! List) {
          problems.add("Pool '$poolName' is not a List (found ${value.runtimeType})");
          continue;
        }

        final count = value.length;
        if (count < minPerPool) {
          problems.add("Pool '$poolName' has only $count items (min $minPerPool)");
        }
      }

      if (problems.isEmpty) {
        print("✅ $path → All pools have ≥ $minPerPool items");
        ok++;
      } else {
        print("❌ $path →");
        for (final p in problems) {
          print("   - $p");
        }
        fail++;
      }
    } catch (e) {
      print("❌ $path → Error: $e");
      fail++;
    }
  }

  print("\n—— Summary ——");
  print("✅ OK: $ok");
  print("❌ Fail: $fail");

  if (fail > 0) exitCode = 2;
}
