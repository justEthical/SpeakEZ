class UserProfileModel {
  final String uid;
  final String name;
  final String email;
  final String imageUrl;
  final String userType;
  final String motivation;
  final String confidence;
  final String preferredPractice;
  final String motherTongue;

  UserProfileModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.imageUrl,
    required this.userType,
    required this.motivation,
    required this.confidence,
    required this.preferredPractice,
    required this.motherTongue,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      userType: json['userType'] ?? '',
      motivation: json['motivation'] ?? '',
      confidence: json['confidence'] ?? '',
      preferredPractice: json['preferredPractice'] ?? '',
      motherTongue: json['motherTongue'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': uid,
      'name': name,
      'email': email,
      'imageUrl': imageUrl,
      'userType': userType,
      'motivation': motivation,
      'confidence': confidence,
      'preferredPractice': preferredPractice,
      'motherTongue': motherTongue,
    };
  }
}

