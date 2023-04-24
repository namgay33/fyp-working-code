import 'package:firebase_auth/firebase_auth.dart';

import '../helper/helper_function.dart';
import 'database_service.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // login
  Future<String?> loginWithUserNameAndPassword(
      String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;
      return null; // return null if login successful
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          return 'Invalid email address.';
        case 'user-disabled':
          return 'Your account has been disabled.';
        case 'network-request-failed':
          return 'Network error. Please check your internet connection.';
        case 'user-not-found':
          return 'This user is not registered. Please register first.';
        case 'wrong-password':
          return 'Incorrect email or password.';
        default:
          return 'An error occurred while signing in. Please try again later.';
      }
    }
  }

  // register
  Future registerUserWithEmailAndPassword(
      String fullName, String email, String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;
      await DatabaseService(uid: user.uid).savingUserData(fullName, email);
      return true;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // signout
  Future signOut() async {
    try {
      await HelperFunctions.saveUserLoggedInStatus(false);
      await HelperFunctions.saveUserEmailSF("");
      await HelperFunctions.saveUserNameSF("");
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }
}
