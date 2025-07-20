import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:speak_ez/Controllers/global_controller.dart';

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
      globalController.showSnackbarWithGetX(
        'Error',
        'Error during Google sign-in: $e',
      );
      print("Error during Google sign-in: $e");
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

      print('Signup successful: ${userCredential.user?.email}');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        globalController.showSnackbarWithGetX(
          'Error',
          'The password provided is too weak.',
        );
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        globalController.showSnackbarWithGetX(
          'Error',
          'The account already exists for that email.',
        );
        print('The account already exists for that email.');
      } else {
        globalController.showSnackbarWithGetX(
          'Error',
          'Signup error: ${e.message}',
        );
        print('Signup error: ${e.message}');
      }
    } catch (e) {
      globalController.showSnackbarWithGetX('Error', 'Unexpected error: $e');
      print('Unexpected error: $e');
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

      print('Login successful: ${userCredential.user?.email}');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        globalController.showSnackbarWithGetX(
          'Error',
          'No user found for that email.',
        );
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      } else {
        globalController.showSnackbarWithGetX(
          'Error',
          'Login error: ${e.message}',
        );
        print('Login error: ${e.message}');
      }
    } catch (e) {
      globalController.showSnackbarWithGetX('Error', 'Unexpected error: $e');
      print('Unexpected error: $e');
    }
    return null;
  }

  static Future<void> signOutGoogle() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      print("Error during Google sign-out: $e");
    }
  }

  static Future<bool> reAuthenticateGoogleLogin() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    if (user == null) {
      print("No user is currently signed in.");
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
        print("Google Sign-In cancelled by user.");
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
      print("Reauthentication successful.");
      return true;
    } catch (e) {
      globalController.showSnackbarWithGetX(
        'Error',
        'Reauthentication failed: $e',
      );
      print("Reauthentication failed: $e");
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
      print("No user is currently signed in.");
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

      print("Reauthentication successful.");
      return true;
    } on FirebaseAuthException catch (e) {
      globalController.showSnackbarWithGetX(
        "Error",
        "Reauthentication failed: ${e.message}",
      );
      print("FirebaseAuthException: ${e.code} - ${e.message}");
      // Handle error: wrong-password, user-mismatch, etc.
    } catch (e) {
      globalController.showSnackbarWithGetX(
        "Error",
        "Error during reauthentication: $e",
      );
      print("Error during reauthentication: $e");
    }
    return false;
  }
}
