import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'const/colors.dart';
import 'const/text_styles.dart';

class QuizScreen extends StatefulWidget {
  final int index;
  const QuizScreen({Key? key, required this.index}) : super(key: key);
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  var currentQuestionIndex = 0;
  int seconds = 60;
  Timer? timer;
  late Future quiz;

  int points = 0;
  int coinAmount = 0;
  late int userPoints;
  late FirebaseAuth auth;
  late String userUid;

  var isLoaded = false;

  var dataShuffled = [];

  var optionsList = [];
  List<dynamic> quizData = [];

  var optionsColor = [
    const Color(0xFFFFCC33),
    const Color(0xFFFFCC33),
    const Color(0xFFFFCC33),
    const Color(0xFFFFCC33),
  ];

// URI to access this JSON bin:
// https://json.extendsclass.com/bin/fcddd3efa56d

// URI to access this JSON in a text editor:
// https://extendsclass.com/jsonstorage/fcddd3efa56d

  var link = "https://json.extendsclass.com/bin/fcddd3efa56d";
  // var link = "https://json.extendsclass.com/bin/28d963e9580c";

  getQuiz() async {
    var res = await http.get(Uri.parse(link));
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body.toString());
      setState(() {
        quizData = data["results"]
            .where((element) => element['difficulty'] == '${widget.index}')
            .toList();
        quizData.shuffle(Random());
      });
      return quizData;
    }
  }

  Future<void> addQuizPoints(int level, int points) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    String? userUid = auth.currentUser?.uid;

    if (userUid != null) {
      // Add the quiz points for the specified level as a field in the "quizPoints" collection
      CollectionReference quizPointsRef =
          firestore.collection('users').doc(userUid).collection('quizPoints');
      await quizPointsRef.doc('level$level').set({
        'points': FieldValue.increment(points),
      });

      // Retrieve the quiz points for all levels
      final querySnapshot = await quizPointsRef.get();
      final quizPoints = querySnapshot.docs
          .map((doc) =>
              (doc.data() as Map<String, dynamic>)['points'] as int? ?? 0)
          .toList();

      // Calculate the total points
      int totalPoints = quizPoints.fold(0, (sum, points) => sum + points);

      // Store the total points in the "users" collection
      CollectionReference usersRef = firestore.collection('users');
      await usersRef.doc(userUid).set({
        'quizPoint': totalPoints,
      }, SetOptions(merge: true));
    }
  }

  // update score on reattempt in each level
  Future<void> updateScore(String userUid, int level, int newScore) async {
    int level = widget.index;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('quizPoints')
        .doc('level$level')
        .set({'points': newScore});
  }

  // Function to retrieve the previous score from Firestore
  Future<int> getPreviousScore(String userUid, int level) async {
    int level = widget.index;

    DocumentSnapshot levelSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('quizPoints')
        .doc('level$level')
        .get();

    if (levelSnapshot.exists) {
      // If the level document exists, extract the previous score
      Map<String, dynamic> data = levelSnapshot.data() as Map<String, dynamic>;
      return data['points'] ?? 0;
    } else {
      return 0; // If the level document doesn't exist, assume previous score as 0
    }
  }

  void handleQuizCompletion(int level, int reattemptScore) async {
    String? userUid = FirebaseAuth.instance.currentUser?.uid;
    if (userUid != null) {
      int previousScore = await getPreviousScore(userUid, level);
      if (reattemptScore > previousScore) {
        updateScore(userUid, level, reattemptScore);
        addQuizPoints(level, points);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    quiz = getQuiz();
    getCoinAmount();
    getUserPoints();

    startTimer();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  getCoinAmount() async {
    CollectionReference usersRef =
        FirebaseFirestore.instance.collection('users');

    FirebaseAuth auth = FirebaseAuth.instance;
    String userUid = auth.currentUser!.uid;

    var userData = await usersRef.doc(userUid).get();
    Map<String, dynamic> userDataMap = userData.data() as Map<String, dynamic>;
    if (userData.exists) {
      setState(() {
        coinAmount = userDataMap['coins'] ?? 0;
      });
    }
  }

  void getUserPoints() async {
    auth = FirebaseAuth.instance;
    userUid = auth.currentUser!.uid;
    int level = widget.index;
    DocumentSnapshot levelPointSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('quizPoints')
        .doc('level$level')
        .get();

    userPoints = levelPointSnapshot['points'];
  }

  extendTime() {
    setState(() {
      seconds += 20;
      coinAmount -= 2;
    });

    CollectionReference usersRef =
        FirebaseFirestore.instance.collection('users');

    FirebaseAuth auth = FirebaseAuth.instance;
    String userUid = auth.currentUser!.uid;

    usersRef.doc(userUid).set({'coins': coinAmount}, SetOptions(merge: true));
  }

  resetColors() {
    optionsColor = [
      const Color(0xFFFFCC33),
      const Color(0xFFFFCC33),
      const Color(0xFFFFCC33),
      const Color(0xFFFFCC33),
    ];
  }

//if last index, should not call gotoNextQuestion()
  startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (seconds > 0) {
          seconds--;

          while (seconds == 0) {
            if (currentQuestionIndex < quizData.length - 1) {
              gotoNextQuestion();
            }
          }
        }
      });
    });
  }

  gotoNextQuestion() {
    isLoaded = false;

    currentQuestionIndex++;
    resetColors();
    timer!.cancel();
    seconds = 60;
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Quit Quiz"),
                content: const Text(
                    "Are you sure you want to quit the quiz? \n Penalty: 3 coins deduction"),
                actions: <Widget>[
                  TextButton(
                    child: const Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop(
                          false); // Close the dialog and resume the QuizScreen
                    },
                  ),
                  TextButton(
                      child: const Text("Quit"),
                      onPressed: () {
                        if (coinAmount < 3) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Not Enough Coins'),
                                content: const Text(
                                    'You do not have enough coins to quit the quiz.'),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                      Navigator.of(context).pop(true);
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          Navigator.of(context).pop(true);
                          Navigator.of(context).pop(true);
                        }
                      }),
                ],
              );
            },
          ).then((value) {
            if (value == true) {
              if (coinAmount >= 3) {
                coinAmount -= 3;
                CollectionReference usersRef =
                    FirebaseFirestore.instance.collection('users');
                FirebaseAuth auth = FirebaseAuth.instance;
                String userUid = auth.currentUser!.uid;
                usersRef
                    .doc(userUid)
                    .set({'coins': coinAmount}, SetOptions(merge: true));
              } else {
                // Not enough coins, user cannot go back
                return false;
              }

              // Continue with the quiz
              return true;
            } else {
              // Resume the QuizScreen
              return false;
            }
          });
        },
        child: Scaffold(
          body: SafeArea(
              child: Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [quizBgColor, quizBgColorDark],
            )),
            child: FutureBuilder(
              future: quiz,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  dataShuffled = quizData.take(10).toList();

                  if (isLoaded == false) {
                    optionsList =
                        dataShuffled[currentQuestionIndex]["incorrect_answers"];
                    optionsList.add(
                        dataShuffled[currentQuestionIndex]["correct_answer"]);
                    optionsList.shuffle();
                    isLoaded = true;
                  }

                  return SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // IconButton(
                            //     onPressed: () {
                            //       Navigator.pop(context);
                            //     },
                            //     icon: const Icon(
                            //       CupertinoIcons.xmark,
                            //       color: Colors.red,
                            //       size: 20,
                            //     )),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                normalText(
                                    color: Colors.black,
                                    size: 24,
                                    text: "$seconds"),
                                SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: CircularProgressIndicator(
                                    value: seconds / 60,
                                    valueColor: const AlwaysStoppedAnimation(
                                        Colors.green),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFCC33),
                                  borderRadius: BorderRadius.circular(16),
                                  border:
                                      Border.all(color: Colors.black, width: 2),
                                ),
                                child: TextButton.icon(
                                  onPressed: () {
                                    if (coinAmount >= 3) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Deduct Coins'),
                                            content: const Text(
                                                'Deduction: 2 coins'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('No'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  extendTime();
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Yes'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          showCloseIcon: true,
                                          closeIconColor: Colors.white,
                                          backgroundColor: Colors.red,
                                          content: Center(
                                            child: Text(
                                              'No Enough Coins',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  icon: const Icon(CupertinoIcons.time,
                                      color: Colors.black, size: 18),
                                  label: normalText(
                                    color: Colors.black,
                                    size: 14,
                                    text: "+20s",
                                  ),
                                )),
                          ],
                        ),
                        const SizedBox(height: 40),
                        // Image.asset(ideas, width: 200),
                        const SizedBox(height: 20),
                        Align(
                            alignment: Alignment.center,
                            child: normalText(
                                color: const Color.fromARGB(255, 39, 35, 35),
                                size: 15,
                                text:
                                    "Question ${currentQuestionIndex + 1} of ${dataShuffled.length}")),
                        const Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                        const SizedBox(height: 20),
                        normalText(
                          color: Colors.black,
                          size: 15,
                          text: dataShuffled[currentQuestionIndex]["question"],
                        ),

                        const SizedBox(height: 40),

                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: optionsList.length,
                          itemBuilder: (BuildContext context, int index) {
                            var answer = dataShuffled[currentQuestionIndex]
                                ["correct_answer"];

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (answer.toString() ==
                                      optionsList[index].toString()) {
                                    optionsColor[index] = Colors.green;
                                    points = points + 3;
                                  } else {
                                    optionsColor[index] = Colors.red;
                                  }

                                  if (currentQuestionIndex <
                                      dataShuffled.length - 1) {
                                    Future.delayed(const Duration(seconds: 1),
                                        () {
                                      gotoNextQuestion();
                                    });
                                  } else {
                                    Future.delayed(
                                      const Duration(seconds: 1),
                                      () {
                                        timer!.cancel();

                                        if (userPoints == 0) {
                                          addQuizPoints(widget.index, points);
                                        } else {
                                          handleQuizCompletion(
                                              widget.index, points);
                                        }

                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title:
                                                  const Text("Quiz completed"),
                                              content: Text(
                                                  "Congratulations! You have completed the quiz.\n \n SCORE: $points/30"),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: const Text("OK"),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    Navigator.of(context).pop();
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    );
                                  }
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                alignment: Alignment.center,
                                width: 200,
                                height: 50,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: optionsColor[index],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  optionsList[index].toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontFamily:
                                        'Roboto', // replace with the desired font family
                                    fontWeight: FontWeight
                                        .normal, // replace with the desired font weight
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  );
                }
              },
            ),
          )),
        ));
  }
}
