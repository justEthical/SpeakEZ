class UserProfileModel {
  String uid;
  String currentEnglishLevel;
  int currentEnglishLevelProgress;
  int currentStreak;
  int wordLearned;
  final String displayName;
  bool isShownCustomReviewDialogOnce;
  OnDeviceTranscriptionDetails? isSupportsOndeviceTranscription;

  final String? photoUrl;
  final String email;
  DateTime lastActive;

  String userType;
  String motivation;
  String confidence;
  String preferredPractice;
  String motherTongue;
  String notificationToken;
  DateTime? unlockTestLastTime;
  int gems;
  WeekDaysStreak weekDaysStreak;

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
    required this.isShownCustomReviewDialogOnce,
    required this.notificationToken,
    required this.gems,
    this.unlockTestLastTime,
    this.isSupportsOndeviceTranscription,
    required this.weekDaysStreak,
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
      isShownCustomReviewDialogOnce:
          map['isShownCustomReviewDialogOnce'] ?? false,
      notificationToken: map['notificationToken'] ?? '',
      unlockTestLastTime:
          map['unlockTestLastTime'] != null
              ? DateTime.fromMillisecondsSinceEpoch(map['unlockTestLastTime'])
              : null,
      isSupportsOndeviceTranscription: map['isSupportsOndeviceTranscription'] != null ?
          OnDeviceTranscriptionDetails.fromMap(map['isSupportsOndeviceTranscription']) : null,
          gems: map['gems'] ?? 0,
      weekDaysStreak: map['weekDaysStreak'] != null ? WeekDaysStreak.fromMap(map['weekDaysStreak']) : WeekDaysStreak.fromMap({}),
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
      'isShownCustomReviewDialogOnce': isShownCustomReviewDialogOnce,
      'notificationToken': notificationToken,
      'unlockTestLastTime': unlockTestLastTime?.millisecondsSinceEpoch,
      'isSupportsOndeviceTranscription': isSupportsOndeviceTranscription?.toMap(),
      'gems': gems,
      'weekDaysStreak': weekDaysStreak.toMap(),
    };
  }
}

class OnDeviceTranscriptionDetails {
  bool isSupportsOndeviceTranscription;
  int timeTookFor10SecTranscription;
  OnDeviceTranscriptionDetails({
    required this.isSupportsOndeviceTranscription,
    required this.timeTookFor10SecTranscription,
  });

  Map<String, dynamic> toMap() {
    return {
      'isSupportsOndeviceTranscription': isSupportsOndeviceTranscription,
      'timeTookFor10SecTranscription': timeTookFor10SecTranscription,
    };
  }

  factory OnDeviceTranscriptionDetails.fromMap(Map<String, dynamic> map) {
    return OnDeviceTranscriptionDetails(
      isSupportsOndeviceTranscription:
          map['isSupportsOndeviceTranscription'] ?? false,
      timeTookFor10SecTranscription:
          map['timeTookFor10SecTranscription'] ?? 0,
    );
  }
}

class WeekDaysStreak{
  
  bool monday;
  bool tuesday;
  bool wednesday;
  bool thursday;
  bool friday;
  bool saturday;
  bool sunday;
  WeekDaysStreak({
    
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
    required this.sunday,
  });
  
  factory WeekDaysStreak.fromMap(Map<String, dynamic> map) {
    return WeekDaysStreak(
      monday: map['monday'] ?? false,
      tuesday: map['tuesday'] ?? false,
      wednesday: map['wednesday'] ?? false,
      thursday: map['thursday'] ?? false,
      friday: map['friday'] ?? false,
      saturday: map['saturday'] ?? false,
      sunday: map['sunday'] ?? false
    );
  }
  
   Map<String, bool> toMap() {
    return {
      'monday': monday,
      'tuesday': tuesday,
      'wednesday': wednesday,
      'thursday': thursday,
      'friday': friday,
      'saturday': saturday,
      'sunday': sunday,
    };
  }
}