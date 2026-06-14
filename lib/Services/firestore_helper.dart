import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:speak_ez/Models/user_profile.dart';
import 'package:speak_ez/Models/vocab_topic_progress.dart';
import 'package:speak_ez/Services/posthog_service.dart';
import 'package:speak_ez/Constants/posthog_events.dart';

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

  static Future<void> updateUserField(Map<String, dynamic> value) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    // throw Exception('No user is currently signed in.');
    PostHogService.instance.captureError(
      PostHogEvents.firebaseError,
      errorMessage: 'No user is currently signed in.',
      location: 'FirestoreHelper.updateUserField',
    );
    return;
  }

  await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .update(value);
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

  static Future<bool> deleteCurrentUser() async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    final user = auth.currentUser;

    if (user == null) {
      throw FirebaseAuthException(code: 'no-user', message: 'No user is currently signed in.');
    }

    final uid = user.uid;

    // Step 1: Delete Firestore document
    await firestore.collection('users').doc(uid).delete();

    // Step 2: Delete Firebase Auth user
    await user.delete();
    debugPrint("✅ User deleted from Firebase Auth and Firestore.");
    return true;
  } on FirebaseAuthException catch (e) {
    PostHogService.instance.captureError(
      PostHogEvents.firebaseError,
      errorMessage: 'FirebaseAuthException: ${e.code} - ${e.message}',
      location: 'FirestoreHelper.deleteCurrentUser',
      additionalProperties: {'error_code': e.code},
    );
    if (e.code == 'requires-recent-login') {
      debugPrint("⚠️ The user needs to re-authenticate before deleting the account.");
      // You should prompt the user to re-login and then try again.
    } else {
      debugPrint("❌ FirebaseAuthException: ${e.code} - ${e.message}");
    }
  } catch (e) {
    PostHogService.instance.captureError(
      PostHogEvents.firebaseError,
      errorMessage: 'Error deleting user: $e',
      location: 'FirestoreHelper.deleteCurrentUser',
    );
    debugPrint("❌ Error deleting user: $e");
  }
  return false; 
}

static Future<Map<String, VocabTopicResult>?> fetchVocabProgress() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      PostHogService.instance.captureError(
        PostHogEvents.firebaseError,
        errorMessage: 'No user is currently signed in.',
        location: 'FirestoreHelper.fetchVocabProgress',
      );
      return null;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('vocabProgress')
          .doc('data')
          .get();

      if (doc.exists && doc.data() != null) {
        final topics = doc.data()!['topics'] as Map<String, dynamic>? ?? {};
        return topics.map(
          (key, value) => MapEntry(
            key,
            VocabTopicResult.fromMap(value as Map<String, dynamic>),
          ),
        );
      }
      return null;
    } catch (e) {
      PostHogService.instance.captureError(
        PostHogEvents.firebaseError,
        errorMessage: 'Error fetching vocab progress: $e',
        location: 'FirestoreHelper.fetchVocabProgress',
      );
      return null;
    }
  }

  static Future<void> saveVocabTopicResult(
    String topicKey,
    VocabTopicResult result,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      PostHogService.instance.captureError(
        PostHogEvents.firebaseError,
        errorMessage: 'No user is currently signed in.',
        location: 'FirestoreHelper.saveVocabTopicResult',
      );
      return;
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('vocabProgress')
        .doc('data')
        .set({
      'topics': {topicKey: result.toMap()},
    }, SetOptions(merge: true));
  }

static Future<Map?> fetchRemoteConfig()async{
  final doc =
        await FirebaseFirestore.instance
            .collection('config')
            .doc('lesson_versions')
            .get();

    if (doc.exists && doc.data() != null) {
      return doc.data()!;
    } else {
      // Return null or throw an exception if you prefer
      return null;
    }
}
}
