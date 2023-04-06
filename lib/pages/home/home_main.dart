import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:first_app/pages/drawer_items/about_us.dart';
import 'package:first_app/service/auth_service.dart';
import 'package:flutter/material.dart';

import '../../leaderboard/leaderboard.dart';
import '../../helper/helper_function.dart';
import '../../widgets/widget.dart';
import '../drawer_items/profile_page.dart';
import '../levels/level_cards.dart';
import 'home_page.dart';
import '../favorite/favorite.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _quizPoint = 0;
  String userName = "";
  String email = "";
  AudioPlayer audioPlayer = AudioPlayer();
  AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    gettingUserData();
    gettingQuizPointsFromFireStore();
  }

  gettingUserData() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunctions.getUserNameFromSF().then((value) {
      setState(() {
        userName = value!;
      });
    });
  }

  void gettingQuizPointsFromFireStore() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .get();
    setState(() {
      _quizPoint = userSnapshot.data()!['quizPoint'];
    });
  }

  int currentPage = 0;

  List<Widget> pages = const [
    Home(
      description: '',
      englishText: '',
      dzongkhaText: '',
      image: '',
    ),
    LevelsHome(),
    LeaderBoard(),
    Favorite(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 255, 152, 18),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(10.0),
          child: Container(),
        ),
      ),
      body: pages[currentPage],
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: <Widget>[
            Icon(
              Icons.account_circle,
              size: 150,
              color: Colors.grey[700],
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              userName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/point.png',
                        height: 32,
                      ),
                      Text(_quizPoint.toString()),
                    ],
                  ),
                  Row(
                    children: [
                      Image.asset(
                        'assets/coin.png',
                        height: 32,
                      ),
                      const Text("coins"),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Divider(
              height: 2,
            ),
            ListTile(
              onTap: () {},
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.group),
              title: const Text(
                "Home",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () {
                nextScreenReplace(
                    context,
                    ProfilePage(
                      userName: userName,
                      email: email,
                    ));
              },
              selectedColor: Theme.of(context).primaryColor,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.person),
              title: const Text(
                "Profile",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () {
                nextScreenReplace(context, const AboutUs());
              },
              selectedColor: Theme.of(context).primaryColor,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.group),
              title: const Text(
                "About Us",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () async {
                return showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Logout"),
                        content: const Text("Are you sure you want to logout?"),
                        actions: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.cancel),
                            color: Colors.red,
                          ),
                          IconButton(
                            onPressed: () async {
                              await authService.signOut();
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => const HomePage()),
                                  (route) => false);
                            },
                            icon: const Icon(Icons.done),
                            color: Colors.green,
                          ),
                        ],
                      );
                    });
              },
              selectedColor: Theme.of(context).primaryColor,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.exit_to_app),
              title: const Text(
                "Logout",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(Icons.category),
            label: "Level",
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart),
            label: "Leaderboard",
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite),
            label: "Favorite",
          ),
        ],
        onDestinationSelected: (int index) {
          setState(() {
            currentPage = index;
          });
        },
        selectedIndex: currentPage,
      ),
    );
  }
}



      // apiKey: 'AIzaSyA8-WvSPSOqOn87gRu5H_uqJNxgikdasqc',
      // authDomain: 'paytam-490fa.firebaseapp.com',
      // databaseURL: 'https://paytam-490fa-default-rtdb.firebaseio.com',
      // projectId: 'paytam-490fa',
      // storageBucket: 'paytam-490fa.appspot.com',
      // messagingSenderId: '702069271398',
      // appId: '1:702069271398:web:8f1b722ae39f5d0745b6a7',
      // measurementId: 'G-0KBGM51WV2',