class VocabularyTopicModel {
  final String level;
  final LevelMetadata metadata;
  final List<Category> categories;

  VocabularyTopicModel({
    required this.level,
    required this.metadata,
    required this.categories,
  });

  factory VocabularyTopicModel.fromJson(Map<String, dynamic> json) {
    return VocabularyTopicModel(
      level: json['level'] as String,
      metadata: LevelMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
      categories: (json['categories'] as List)
          .map((category) => Category.fromJson(category as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'metadata': metadata.toJson(),
      'categories': categories.map((category) => category.toJson()).toList(),
    };
  }
}

class LevelMetadata {
  final int totalWords;
  final int totalTopics;
  final int wordsPerTopic;
  final int totalCategories;

  LevelMetadata({
    required this.totalWords,
    required this.totalTopics,
    required this.wordsPerTopic,
    required this.totalCategories,
  });

  factory LevelMetadata.fromJson(Map<String, dynamic> json) {
    return LevelMetadata(
      totalWords: json['total_words'] as int,
      totalTopics: json['total_topics'] as int,
      wordsPerTopic: json['words_per_topic'] as int,
      totalCategories: json['total_categories'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_words': totalWords,
      'total_topics': totalTopics,
      'words_per_topic': wordsPerTopic,
      'total_categories': totalCategories,
    };
  }
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
      categoryName: json['category_name'] as String,
      topics: (json['topics'] as List).map((topic) => topic as String).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_name': categoryName,
      'topics': topics,
    };
  }
}