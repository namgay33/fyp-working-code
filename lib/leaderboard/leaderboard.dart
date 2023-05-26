import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({super.key});

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class User {
  String id = '';
  String name = '';
  int points = 0;

  User({required this.id, required this.points, required this.name});
}

class _LeaderboardState extends State<Leaderboard> {
  List<User> _users = [];

  @override
  void initState() {
    super.initState();
    _getUsers();
  }

  void _getUsers() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .orderBy('quizPoint', descending: true)
        .limit(50)
        .get();
    final users = querySnapshot.docs
        .map(
          (doc) => User(
            id: doc.id,
            name: doc.data()['fullName']?.toString() ?? '',
            points: doc.data()['quizPoint']?.toInt() ?? 0,
          ),
        )
        .toList();
    setState(() {
      _users = users;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/leaderboardbg.PNG"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: null,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Image.asset(
                        'assets/point.png',
                        height: 60,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'LEADERBOARD',
                        style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                                fontSize: 25,
                                color: Colors.black,
                                shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.5),
                                offset: const Offset(2, 2),
                                blurRadius: 4,
                              )
                            ])),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Card(
                        elevation: 5,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.5,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: SizedBox(
                            child: ListView.builder(
                              itemCount: _users.length,
                              itemBuilder: (context, index) {
                                final user = _users[index];
                                Widget leadingWidget;

                                // Check if the current index is within the top 3
                                if (index == 0) {
                                  leadingWidget = Image.asset(
                                    'assets/first.png',
                                    width: 25,
                                    height: 25,
                                  );
                                } else if (index == 1) {
                                  leadingWidget = Image.asset(
                                    'assets/second.png',
                                    width: 25,
                                    height: 25,
                                  );
                                } else if (index == 2) {
                                  leadingWidget = Image.asset(
                                    'assets/third.png',
                                    width: 25,
                                    height: 25,
                                  );
                                } else {
                                  leadingWidget = Text(
                                    '${index + 1}',
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  );
                                }

                                return ListTile(
                                  leading: leadingWidget,
                                  title: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.account_circle),
                                      const SizedBox(width: 4),
                                      Text(user.name),
                                    ],
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        'assets/point.png',
                                        width: 20,
                                        height: 20,
                                      ),
                                      const SizedBox(width: 4),
                                      Text('${user.points}'),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
