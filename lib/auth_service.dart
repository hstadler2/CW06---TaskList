import 'package:firebase_auth/firebase_auth.dart';

// A simple service class to wrap Firebase Authentication methods.
class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Registers a user with email and password.
  static Future<bool> registerWithEmail(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      print('Error in registerWithEmail: $e');
      return false;
    }
  }

  // Signs in a user with email and password.
  static Future<bool> signInWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      print('Error in signInWithEmail: $e');
      return false;
    }
  }

  // Signs out the current user.
  static Future<void> signOut() async {
    await _auth.signOut();
  }

  // Changes the current user's password.
  static Future<bool> changePassword(String newPassword) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updatePassword(newPassword);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error in changePassword: $e');
      return false;
    }
  }
}
