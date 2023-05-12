import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'const/colors.dart';
import 'const/images.dart';
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

  var isLoaded = false;

  var optionsList = [];

  var optionsColor = [
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,
  ];

// URI to access this JSON bin:
// https://json.extendsclass.com/bin/fcddd3efa56d

// URI to access this JSON in a text editor:
// https://extendsclass.com/jsonstorage/fcddd3efa56d

  var link = "https://json.extendsclass.com/bin/fcddd3efa56d";

  getQuiz() async {
    var res = await http.get(Uri.parse(link));
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body.toString());
      return data;
    }
  }

  addQuizPoints() {
    CollectionReference usersRef =
        FirebaseFirestore.instance.collection('users');

    FirebaseAuth auth = FirebaseAuth.instance;
    String userUid = auth.currentUser!.uid;

    usersRef.doc(userUid).set({'quizPoint': FieldValue.increment(points)},
        SetOptions(merge: true)).then((value) {
      // print("Quiz point updated for user $userUid");
    }).catchError((error) {
      // print("Failed to update quiz point for user $userUid: $error");
    });
  }

  @override
  void initState() {
    super.initState();
    quiz = getQuiz();
    getCoinAmount();

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

  extendTime() {
    setState(() {
      seconds += 10;
      coinAmount -= 3;
    });

    CollectionReference usersRef =
        FirebaseFirestore.instance.collection('users');

    FirebaseAuth auth = FirebaseAuth.instance;
    String userUid = auth.currentUser!.uid;

    usersRef.doc(userUid).set({'coins': coinAmount}, SetOptions(merge: true));
  }

  resetColors() {
    optionsColor = [
      Colors.white,
      Colors.white,
      Colors.white,
      Colors.white,
      Colors.white,
    ];
  }

  startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          gotoNextQuestion();
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
    var size = MediaQuery.of(context).size;
    return Scaffold(
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
              var data = snapshot.data["results"]
                  .where(
                      (element) => element['difficulty'] == '${widget.index}')
                  .toList();

              if (isLoaded == false) {
                optionsList = data[currentQuestionIndex]["incorrect_answers"];
                optionsList.add(data[currentQuestionIndex]["correct_answer"]);
                optionsList.shuffle();
                isLoaded = true;
              }

              return SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: lightgrey, width: 2),
                          ),
                          child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                CupertinoIcons.xmark,
                                color: Colors.white,
                                size: 28,
                              )),
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            normalText(
                                color: Colors.white,
                                size: 24,
                                text: "$seconds"),
                            SizedBox(
                              width: 80,
                              height: 80,
                              child: CircularProgressIndicator(
                                value: seconds / 60,
                                valueColor:
                                    const AlwaysStoppedAnimation(Colors.white),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: quizBgColorDark,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: quizBgColor, width: 2),
                          ),
                          child: TextButton.icon(
                            onPressed: coinAmount >= 3 ? extendTime : null,
                            icon: const Icon(CupertinoIcons.time,
                                color: Colors.white, size: 18),
                            label: normalText(
                              color: Colors.white,
                              size: 14,
                              text: "Extend Time (-3 coins)",
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Image.asset(ideas, width: 200),
                    const SizedBox(height: 20),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: normalText(
                            color: const Color.fromARGB(255, 39, 35, 35),
                            size: 15,
                            text:
                                "Question ${currentQuestionIndex + 1} of ${data.length}")),
                    const SizedBox(height: 20),
                    normalText(
                      color: Colors.white,
                      size: 15,
                      text: data[currentQuestionIndex]["question"],
                    ),
                    const SizedBox(height: 20),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: optionsList.length,
                      itemBuilder: (BuildContext context, int index) {
                        var answer =
                            data[currentQuestionIndex]["correct_answer"];

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

                              if (currentQuestionIndex < data.length - 1) {
                                Future.delayed(const Duration(seconds: 1), () {
                                  gotoNextQuestion();
                                });
                              } else {
                                Future.delayed(const Duration(seconds: 1), () {
                                  timer!.cancel();

                                  addQuizPoints();

                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Quiz completed"),
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
                                });
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
                                color: blue,
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
    );
  }
}
