import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  Future<void> logout() async {
    await _auth.signOut();
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
