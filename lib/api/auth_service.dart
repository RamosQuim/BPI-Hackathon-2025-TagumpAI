import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // null means success
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return 'No user found for that email.';
        case 'wrong-password':
          return 'Incorrect password.';
        case 'invalid-email':
          return 'Invalid email format.';
        case 'user-disabled':
          return 'This user has been disabled.';
        default:
          return 'Authentication failed. ${e.message}';
      }
    } catch (e) {
      return 'An unexpected error occurred. Please try again.';
    }
  }

  Future<String?> signup({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = result.user;

      if (user != null) {
        AppUser newUser = AppUser(
          uid: user.uid,
          firstName: firstName,
          lastName: lastName,
          email: email,
        );

        await _firestore.collection('users').doc(user.uid).set(newUser.toMap());
      }

      return null; // null means success
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return 'The email address is already in use.';
        case 'invalid-email':
          return 'The email address is invalid.';
        case 'weak-password':
          return 'The password is too weak.';
        default:
          return 'Signup failed. ${e.message}';
      }
    } catch (e) {
      return 'An unexpected error occurred. Please try again.';
    }
  }

  Future<String?> signUpWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return 'Sign up cancelled';

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      final user = userCredential.user;
      if (user == null) return 'User information not available';

      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) return 'Account already exists. Please sign in instead.';

      await _firestore.collection('users').doc(user.uid).set({
        'firstName': user.displayName?.split(' ').first ?? '',
        'lastName': user.displayName?.split(' ').last ?? '',
        'email': user.email,
        'createdAt': FieldValue.serverTimestamp(),
        'authProvider': 'google',
      });

      return null; // Success
    } catch (e) {
      return 'Something went wrong. Please try again.';
    }
  }

  Future<String?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return 'Sign in cancelled';

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      return null; // Success
    } catch (e) {
      return 'Failed to sign in. Please try again.';
    }
  }

  Future<void> logout() async {
    final currentUser = _auth.currentUser;

    // Sign out from Google if the user signed in with Google
    for (final info in currentUser?.providerData ?? []) {
      if (info.providerId == 'google.com') {
        await GoogleSignIn().signOut();
        break;
      }
    }

    // Sign out from Firebase (works for both email/password and Google)
    await _auth.signOut();
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
