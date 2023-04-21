import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'pages/level_pages.dart';

const int itemCOunt = 10;

class LevelsHome extends StatefulWidget {
  const LevelsHome({super.key});

  @override
  State<LevelsHome> createState() => _LevelsHomeState();
}

class _LevelsHomeState extends State<LevelsHome> {
  // int _quizPoint = 0;

  @override
  void initState() {
    super.initState();
  }

  // void gettingQuizPointsFromFireStore() async {
  //   final currentUser = FirebaseAuth.instance.currentUser;
  //   final userSnapshot = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(currentUser!.uid)
  //       .get();
  //   setState(() {
  //     _quizPoint = userSnapshot.data()!['quizPoint'];
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView.builder(
            itemCount: itemCOunt,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(40.0, 10, 40, 0),
                child: Card(
                  elevation: 4,
                  child: ListTile(
                    title: Center(
                      child: Text('Level ${(index + 1)}'),
                    ),
                    // leading: const Icon(Icons.lock),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LevelPages(index: index + 1)),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
