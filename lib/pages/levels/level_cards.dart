import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'pages/level_pages.dart';

const int itemCount = 10;

class LevelsHome extends StatefulWidget {
  const LevelsHome({Key? key}) : super(key: key);

  @override
  State<LevelsHome> createState() => _LevelsHomeState();
}

class _LevelsHomeState extends State<LevelsHome> {
  int userScore = 0;
  int unlockedLevels = 1; // Assuming 1 level is initially unlocked

  @override
  void initState() {
    super.initState();
    checkAndIncrementUnlockedLevels(); // Check and unlock levels initially
  }

  Future<void> checkAndIncrementUnlockedLevels() async {
    String? userUid = FirebaseAuth.instance.currentUser?.uid;
    if (userUid != null) {
      for (int level = 2; level <= itemCount; level++) {
        int previousLevel = level - 1;
        int previousLevelScore = await getUserScore(userUid, previousLevel);

        // Check if the user's score for the previous level is greater than or equal to 24
        if (previousLevelScore >= 24 && level > unlockedLevels) {
          debugPrint("Unlocked Levels: $unlockedLevels");
          setState(() {
            unlockedLevels = level;
          });
        } else {
          // If the current unlocked level is less than or equal to the previous level,
          // break the loop and stop unlocking further levels
          if (unlockedLevels <= previousLevel) {
            break;
          }
        }
      }
    }
  }

  Future<int> getUserScore(String userUid, int level) async {
    // Retrieve the user's score for the specified level from Firestore
    DocumentSnapshot levelSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('quizPoints')
        .doc('level$level')
        .get();

    if (levelSnapshot.exists) {
      // If the level document exists, extract the score
      Map<String, dynamic> data = levelSnapshot.data() as Map<String, dynamic>;
      userScore = data['points'] ?? 0;
    }

    return userScore;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView.builder(
            itemCount: itemCount,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(40.0, 10, 40, 0),
                child: Card(
                  elevation: 4,
                  child: ListTile(
                    leading: Icon(
                      index < unlockedLevels ? Icons.lock_open : Icons.lock,
                    ),
                    title: Center(
                      child: Text('Level ${(index + 1)}'),
                    ),
                    onTap: () {
                      if (index < unlockedLevels) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LevelPages(index: index + 1),
                          ),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Level Locked'),
                              content: const Text(
                                  'You need to clear the previous levels to unlock this level.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
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
