import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Models/user_profile.dart';
import 'package:speak_ez/Services/posthog_service.dart';
import 'package:speak_ez/Constants/posthog_events.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static User? user;

  static Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the Google Sign-In process
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null; // User canceled the sign-in
      }

      // Get authentication details from the Google account
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential for Firebase using the Google authentication details
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credentials
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      // Return the authenticated user
      return userCredential;
    } catch (e) {
      PostHogService.instance.captureError(
        PostHogEvents.authenticationError,
        errorMessage: 'Error during Google sign-in: $e',
        location: 'AuthService.signInWithGoogle',
      );
      globalController.showSnackbarWithGetX(
        'Error',
        'Error during Google sign-in: $e',
      );
      debugPrint("Error during Google sign-in: $e");
      return null;
    }
  }

  static Future<UserCredential?> signUpWithEmail(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      debugPrint('Signup successful: ${userCredential.user?.email}');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      PostHogService.instance.captureError(
        PostHogEvents.authenticationError,
        errorMessage: 'Signup error: ${e.code} - ${e.message}',
        location: 'AuthService.signUpWithEmail',
        additionalProperties: {'error_code': e.code},
      );
      if (e.code == 'weak-password') {
        globalController.showSnackbarWithGetX(
          'Error',
          'The password provided is too weak.',
        );
        debugPrint('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        globalController.showSnackbarWithGetX(
          'Error',
          'The account already exists for that email.',
        );
        debugPrint('The account already exists for that email.');
      } else {
        globalController.showSnackbarWithGetX(
          'Error',
          'Signup error: ${e.message}',
        );
        debugPrint('Signup error: ${e.message}');
      }
    } catch (e) {
      PostHogService.instance.captureError(
        PostHogEvents.authenticationError,
        errorMessage: 'Unexpected error: $e',
        location: 'AuthService.signUpWithEmail',
      );
      globalController.showSnackbarWithGetX('Error', 'Unexpected error: $e');
      debugPrint('Unexpected error: $e');
    }
    return null;
  }

  static Future<UserCredential?> loginWithEmail(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      debugPrint('Login successful: ${userCredential.user?.email}');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      PostHogService.instance.captureError(
        PostHogEvents.authenticationError,
        errorMessage: 'Login error: ${e.code} - ${e.message}',
        location: 'AuthService.loginWithEmail',
        additionalProperties: {'error_code': e.code},
      );
      if (e.code == 'user-not-found') {
        globalController.showSnackbarWithGetX(
          'Error',
          'No user found for that email.',
        );
        debugPrint('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        debugPrint('Wrong password provided for that user.');
      } else {
        globalController.showSnackbarWithGetX(
          'Error',
          'Login error: ${e.message}',
        );
        debugPrint('Login error: ${e.message}');
      }
    } catch (e) {
      PostHogService.instance.captureError(
        PostHogEvents.authenticationError,
        errorMessage: 'Unexpected error: $e',
        location: 'AuthService.loginWithEmail',
      );
      globalController.showSnackbarWithGetX('Error', 'Unexpected error: $e');
      debugPrint('Unexpected error: $e');
    }
    return null;
  }

  static Future<void> logout() async {
    try {
      globalController.userProfile.value = UserProfileModel.fromMap({});
      await _googleSignIn.signOut();
      await _googleSignIn.disconnect();
      await _auth.signOut();
    } catch (e) {
      PostHogService.instance.captureError(
        PostHogEvents.authenticationError,
        errorMessage: 'Error during Google sign-out: $e',
        location: 'AuthService.logout',
      );
      debugPrint("Error during Google sign-out: $e");
    }
  }

  static Future<bool> reAuthenticateGoogleLogin() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    if (user == null) {
      debugPrint("No user is currently signed in.");
      globalController.showSnackbarWithGetX(
        "Error",
        "No user is currently signed in.",
      );
      return false;
    }

    try {
      // Step 1: Trigger Google Sign-In flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        debugPrint("Google Sign-In cancelled by user.");
        globalController.showSnackbarWithGetX(
          "Error",
          "Google Sign-In cancelled by user.",
        );
        return false;
      }

      // Step 2: Get auth details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Step 3: Create Firebase credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      // Step 4: Reauthenticate
      await user.reauthenticateWithCredential(credential);
      debugPrint("Reauthentication successful.");
      return true;
    } catch (e) {
      PostHogService.instance.captureError(
        PostHogEvents.authenticationError,
        errorMessage: 'Reauthentication failed: $e',
        location: 'AuthService.reAuthenticateGoogleLogin',
      );
      globalController.showSnackbarWithGetX(
        'Error',
        'Reauthentication failed: $e',
      );
      debugPrint("Reauthentication failed: $e");
      return false;
    }
  }

  static Future<bool> reAuthenticateWithEmail({
    required String email,
    required String password,
  }) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    if (user == null) {
      debugPrint("No user is currently signed in.");
      globalController.showSnackbarWithGetX(
        "Error",
        "No user is currently signed in.",
      );
      return false;
    }

    try {
      // Step 1: Create email credential
      final AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );

      // Step 2: Reauthenticate
      await user.reauthenticateWithCredential(credential);

      debugPrint("Reauthentication successful.");
      return true;
    } on FirebaseAuthException catch (e) {
      PostHogService.instance.captureError(
        PostHogEvents.authenticationError,
        errorMessage: 'Reauthentication failed: ${e.code} - ${e.message}',
        location: 'AuthService.reAuthenticateWithEmail',
        additionalProperties: {'error_code': e.code},
      );
      globalController.showSnackbarWithGetX(
        "Error",
        "Reauthentication failed: ${e.message}",
      );
      debugPrint("FirebaseAuthException: ${e.code} - ${e.message}");
      // Handle error: wrong-password, user-mismatch, etc.
    } catch (e) {
      PostHogService.instance.captureError(
        PostHogEvents.authenticationError,
        errorMessage: 'Error during reauthentication: $e',
        location: 'AuthService.reAuthenticateWithEmail',
      );
      globalController.showSnackbarWithGetX(
        "Error",
        "Error during reauthentication: $e",
      );
      debugPrint("Error during reauthentication: $e");
    }
    return false;
  }
}
