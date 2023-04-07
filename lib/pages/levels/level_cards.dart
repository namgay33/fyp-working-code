import 'package:first_app/pages/levels/quiz.dart';
import 'package:flutter/material.dart';

import '../../helper/helper_function.dart';
import '../auth/login_page.dart';

const int itemCOunt = 10;

class LevelsHome extends StatefulWidget {
  const LevelsHome({super.key});

  @override
  State<LevelsHome> createState() => _LevelsHomeState();
}

class _LevelsHomeState extends State<LevelsHome> {
  bool _isSignedIn = false;
  @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
  }

  getUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          _isSignedIn = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Image.asset(
          //   'assets/bgcolor.PNG',
          //   fit: BoxFit.cover,
          //   width: double.infinity,
          //   height: double.infinity,
          // ),
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
                    leading: const Icon(Icons.lock),
                    onTap: () {
                      _isSignedIn
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const QuizScreen()),
                            )
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()));
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
