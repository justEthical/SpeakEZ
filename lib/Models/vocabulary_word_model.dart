class Word {
  final String word;
  final String translation;
  final String usage;
  final List<UserType> targetUsers; // List of user types this word is suitable for

  Word({
    required this.word,
    required this.translation,
    required this.usage,
    required this.targetUsers,
  });

  // Factory constructor to create from JSON
  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      word: json['word'],
      translation: json['translation'],
      usage: json['usage'],
      targetUsers: (json['targetUsers'] as List)
          .map((user) => UserTypeExtension.fromString(user))
          .toList(),
    );
  }

  // To JSON (if you want to save back)
  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'translation': translation,
      'usage': usage,
      'targetUsers': targetUsers.map((user) => user.toShortString()).toList(),
    };
  }
}

// Enum for user types
enum UserType {
  CorporateEmployee,
  GovtExamAspirant,
  SchoolUniversityStudent,
  StudyAbroad,
  JustForFun,
}

// Helper extension for serialization
extension UserTypeExtension on UserType {
  static UserType fromString(String userType) {
    switch (userType) {
      case 'CorporateEmployee':
        return UserType.CorporateEmployee;
      case 'GovtExamAspirant':
        return UserType.GovtExamAspirant;
      case 'SchoolUniversityStudent':
        return UserType.SchoolUniversityStudent;
      case 'StudyAbroad':
        return UserType.StudyAbroad;
      case 'JustForFun':
        return UserType.JustForFun;
      default:
        throw Exception('Unknown UserType: $userType');
    }
  }

  String toShortString() {
    return toString().split('.').last;
  }
}
