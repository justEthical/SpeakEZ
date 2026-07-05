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

  /// Persistent ledger of emails that have already received the welcome bonus.
  /// This collection is intentionally NEVER deleted on account deletion, so a
  /// user cannot re-claim the signup bonus by deleting and recreating their
  /// account.
  static const String welcomeBonusClaimsCollection = 'welcomeBonusClaims';

  static String _normalizeEmail(String email) => email.trim().toLowerCase();

  /// Returns true if this email has already claimed the welcome bonus.
  static Future<bool> hasClaimedWelcomeBonus(String email) async {
    try {
      final doc = await db
          .collection(welcomeBonusClaimsCollection)
          .doc(_normalizeEmail(email))
          .get();
      return doc.exists;
    } catch (e) {
      PostHogService.instance.captureError(
        PostHogEvents.firebaseError,
        errorMessage: 'Error checking welcome bonus claim: $e',
        location: 'FirestoreHelper.hasClaimedWelcomeBonus',
      );
      // Fail open: if we can't verify (e.g. transient network error), treat as
      // not-yet-claimed so a legitimate new user isn't silently denied their
      // bonus. Abuse would require both deleting the account and a Firestore
      // outage at the same time — negligible risk for a client-side guard.
      return false;
    }
  }

  /// Records that this email has claimed the welcome bonus.
  static Future<void> recordWelcomeBonusClaim(String email) async {
    try {
      await db
          .collection(welcomeBonusClaimsCollection)
          .doc(_normalizeEmail(email))
          .set({
        'email': _normalizeEmail(email),
        'claimedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      PostHogService.instance.captureError(
        PostHogEvents.firebaseError,
        errorMessage: 'Error recording welcome bonus claim: $e',
        location: 'FirestoreHelper.recordWelcomeBonusClaim',
      );
    }
  }

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
    // NOTE: We intentionally do NOT delete the user's entry in
    // `welcomeBonusClaims` here — that ledger must survive account deletion to
    // prevent re-claiming the signup bonus.

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
