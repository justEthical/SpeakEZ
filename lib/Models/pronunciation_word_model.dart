
class EnglishVocabLevelModel {
  final String level;
  final String title;
  final String subtitle;
  final Metadata metadata;
  final List<Category> categories;

  EnglishVocabLevelModel({
    required this.level,
    required this.title,
    required this.subtitle,
    required this.metadata,
    required this.categories,
  });

  // Factory to create an instance from JSON map
  factory EnglishVocabLevelModel.fromJson(Map<String, dynamic> json) {
    return EnglishVocabLevelModel(
      level: json['level'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      metadata: Metadata.fromJson(json['metadata'] ?? {}),
      categories: (json['categories'] as List?)
              ?.map((item) => Category.fromJson(item))
              .toList() ?? [],
    );
  }

  // Convert instance back to JSON map
  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'title': title,
      'subtitle': subtitle,
      'metadata': metadata.toJson(),
      'categories': categories.map((e) => e.toJson()).toList(),
    };
  }
}

class Metadata {
  final int totalWords;
  final int totalTopics;
  final int wordsPerTopic;
  final int totalCategories;

  Metadata({
    required this.totalWords,
    required this.totalTopics,
    required this.wordsPerTopic,
    required this.totalCategories,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      totalWords: json['total_words'] ?? 0,
      totalTopics: json['total_topics'] ?? 0,
      wordsPerTopic: json['words_per_topic'] ?? 0,
      totalCategories: json['total_categories'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'total_words': totalWords,
        'total_topics': totalTopics,
        'words_per_topic': wordsPerTopic,
        'total_categories': totalCategories,
      };
}

class Category {
  final String categoryName;
  final List<String> topics;

  Category({
    required this.categoryName,
    required this.topics,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryName: json['category_name'] ?? '',
      topics: List<String>.from(json['topics'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
        'category_name': categoryName,
        'topics': topics,
      };
}