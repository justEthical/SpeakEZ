class UserProfileModel {
  String uid;
  final String currentEnglishLevel;
  int currentEnglishLevelProgress;
  final int currentStreak;
  final int wordLearned;
  final String displayName;

  final String? photoUrl;
  final String email;
  final DateTime lastActive;

  String userType;
  String motivation;
  String confidence;
  String preferredPractice;
  String motherTongue;

  UserProfileModel({
    required this.uid,
    required this.currentEnglishLevel,
    required this.currentEnglishLevelProgress,
    required this.currentStreak,
    required this.wordLearned,
    required this.displayName,
    required this.photoUrl,
    required this.email,
    required this.lastActive,
    required this.userType,
    required this.motivation,
    required this.confidence,
    required this.preferredPractice,
    required this.motherTongue,
  });

  // Factory constructor: handles Firestore Timestamp to DateTime
  factory UserProfileModel.fromMap(Map<String, dynamic> map) {
    return UserProfileModel(
      uid: map['uid'] ?? '',
      currentEnglishLevel: map['current_english_level'] ?? '',
      currentEnglishLevelProgress: map['current_english_level_progress'] ?? 0,
      currentStreak: map['current_streak'] ?? 0,
      wordLearned: map['word_learned'] ?? 0,
      displayName: map['display_name'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      email: map['email'] ?? '',
      lastActive: DateTime.fromMillisecondsSinceEpoch(
        map['last_active'] ?? 174998967000,
      ),
      userType: map['userType'] ?? '',
      motivation: map['motivation'] ?? '',
      confidence: map['confidence'] ?? '',
      preferredPractice: map['preferredPractice'] ?? '',
      motherTongue: map['motherTongue'] ?? '',
    );
  }

  // Convert to Map for Firestore (stores as Timestamp)
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'current_english_level': currentEnglishLevel,
      'current_english_level_progress': currentEnglishLevelProgress,
      'current_streak': currentStreak,
      'word_learned': wordLearned,
      'display_name': displayName,
      'photoUrl': photoUrl,
      'email': email,
      'last_active': lastActive.millisecondsSinceEpoch,
      'userType': userType,
      'motivation': motivation,
      'confidence': confidence,
      'preferredPractice': preferredPractice,
      'motherTongue': motherTongue,
    };
  }
}
