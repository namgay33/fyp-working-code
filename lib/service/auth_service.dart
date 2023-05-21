import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../helper/helper_function.dart';
import 'database_service.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  final String uid;
  AuthService({required this.uid});

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  // Check if user exists in the database
  Future<bool> checkUserExists() async {
    DocumentSnapshot doc = await usersCollection.doc(uid).get();
    return doc.exists;
  }

  // login
  Future loginWithUserNameAndPassword(String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;

      return true;
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

      // Check if user already exists in the database
      bool userExists = await AuthService(uid: user.uid).checkUserExists();

      // If user does not exist, add 5 coins to their account
      if (!userExists) {
        await AuthService(uid: user.uid).addLevels();
      }

      await DatabaseService(uid: user.uid).savingUserData(fullName, email);
      return true;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // // Add coins to user's account on register
  // Future<void> addCoins() async {
  //   final userRef = FirebaseFirestore.instance.collection('users').doc(uid);

  //   await userRef.set({'coins': 5}, SetOptions(merge: true));
  // }

// add levels on register
  Future<void> addLevels() async {
    CollectionReference usersRef =
        FirebaseFirestore.instance.collection('users');

    for (int level = 1; level <= 10; level++) {
      usersRef
          .doc(uid)
          .collection('quizPoints')
          .doc('level$level')
          .set({'points': 0});
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
