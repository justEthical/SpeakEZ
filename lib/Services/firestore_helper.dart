import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:speak_ez/Models/user_profile.dart';

class FirestoreHelper {
  static final db = FirebaseFirestore.instance;
  static const String usersCollection = 'users';

   static Future<void> saveCurrentUserProfile(UserProfileModel userProfile) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('No user is currently signed in.');
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set(userProfile.toMap(), SetOptions(merge: true));
  }

  static Future<void> updateUserField(String field, dynamic value) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    throw Exception('No user is currently signed in.');
  }

  await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .update({field: value});
}


  static Future<UserProfileModel?> fetchCurrentUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('No user is currently signed in.');
    }

    final doc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

    if (doc.exists && doc.data() != null) {
      return UserProfileModel.fromMap(doc.data()!);
    } else {
      // Return null or throw an exception if you prefer
      return null;
    }
  }
}
