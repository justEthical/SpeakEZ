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
      globalController.showSnackbarWithGetX('Error', 'Error during Google sign-in: $e');
      print("Error during Google sign-in: $e");
      return null;
    }
  }

  static Future<UserCredential?> signUpWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      print('Signup successful: ${userCredential.user?.email}');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      await Future.delayed(Duration(milliseconds: 100));
      if (e.code == 'weak-password') {
        globalController.showSnackbarWithGetX('Error', 'The password provided is too weak.');
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        globalController.showSnackbarWithGetX('Error', 'The account already exists for that email.');
        print('The account already exists for that email.');
      } else {
        globalController.showSnackbarWithGetX('Error', 'Signup error: ${e.message}');
        print('Signup error: ${e.message}');
      }
    } catch (e) {
      globalController.showSnackbarWithGetX('Error', 'Unexpected error: $e');
      print('Unexpected error: $e');
    }
    return null;
  }

  static Future<UserCredential?> loginWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      print('Login successful: ${userCredential.user?.email}');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        globalController.showSnackbarWithGetX('Error', 'No user found for that email.');  
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      } else {
        globalController.showSnackbarWithGetX('Error', 'Login error: ${e.message}');
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
}
