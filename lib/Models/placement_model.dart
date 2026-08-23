class PlacementBand {
  final String key;
  final String title;
  final String subtitle;
  final List<String> words; // real, scored words
  final List<String> pseudowords; // fake words — over-claim control
  final List<String> displayWords; // words + pseudowords, shuffled once

  PlacementBand({
    required this.key,
    required this.title,
    required this.subtitle,
    required this.words,
    required this.pseudowords,
    required this.displayWords,
  });

  factory PlacementBand.fromJson(Map<String, dynamic> json) {
    final words = (json['words'] as List).map((e) => e.toString()).toList();
    final pseudowords =
        (json['pseudowords'] as List? ?? []).map((e) => e.toString()).toList();
    final display = [...words, ...pseudowords]..shuffle();
    return PlacementBand(
      key: json['key']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      subtitle: json['subtitle']?.toString() ?? '',
      words: words,
      pseudowords: pseudowords,
      displayWords: display,
    );
  }
}

class PlacementWordBank {
  final List<PlacementBand> bands;

  PlacementWordBank({required this.bands});

  factory PlacementWordBank.fromJson(Map<String, dynamic> json) {
    final bands = (json['bands'] as List? ?? [])
        .map((e) => PlacementBand.fromJson(e as Map<String, dynamic>))
        .toList();
    return PlacementWordBank(bands: bands);
  }
}
