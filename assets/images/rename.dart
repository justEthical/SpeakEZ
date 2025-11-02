import 'dart:io';

void main() async {
  // Change this path to your folder path
  final directoryPath = '/Users/ash/47/SpeakEZ/assets/images/scenario-icons';
  final dir = Directory(directoryPath);

  if (!await dir.exists()) {
    print('❌ Directory does not exist.');
    return;
  }

  final files = dir.listSync(recursive: false);

  for (var entity in files) {
    if (entity is File) {
      final oldPath = entity.path;
      final fileName = oldPath.split(Platform.pathSeparator).last;

      // Replace spaces and unwanted characters with underscore, but keep '.'
      final sanitizedName = fileName
          .toLowerCase()
          .replaceAll(RegExp(r'[^\w\s.-]'), '') // keep . and -
          .replaceAll(RegExp(r'\s+'), '_'); // replace spaces with underscores

      final newPath = '${dir.path}${Platform.pathSeparator}$sanitizedName';

      if (oldPath != newPath) {
        await entity.rename(newPath);
        print('✅ Renamed: $fileName → $sanitizedName');
      }
    }
  }

  print('🎉 All files renamed successfully!');
}
