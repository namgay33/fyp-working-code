import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  // reference for our collections
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  // saving the userdata
  Future savingUserData(String fullName, String email) async {
    return await userCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "groups": [],
      "profilePic": "",
      'uid': uid,
      'coins': 20,
      'quizPoint': 0,
      'lastCollection': DateTime.now(),
    });
  }

  // getting user data
  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }
}

// class DatabaseService {
//   final String? uid;
//   DatabaseService({this.uid});

//   final CollectionReference userCollection =
//       FirebaseFirestore.instance.collection("users");

//   Future<void> savingUserData(String fullName, String email) async {
//     try {
//       await userCollection.doc(uid).set({
//         "fullName": fullName,
//         "email": email,
//         "groups": [],
//         "profilePic": "",
//         'uid': uid,
//         'coins': 20,
//         'quizPoint': 0,
//         'lastCollection': DateTime.now(),
//       });
//     } catch (error) {
//       debugPrint('Error saving user data to Firestore: $error');
//       rethrow;
//     }
//   }

//   Future<QuerySnapshot> gettingUserData(String email) async {
//     try {
//       final QuerySnapshot snapshot =
//           await userCollection.where("email", isEqualTo: email).get();
//       return snapshot;
//     } catch (error) {
//       debugPrint('Error getting user data from Firestore: $error');
//       rethrow;
//     }
//   }
// }
