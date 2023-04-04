import 'package:audioplayers/audioplayers.dart';
import 'package:first_app/pages/drawer_items/about_us.dart';
import 'package:first_app/service/auth_service.dart';
import 'package:flutter/material.dart';

import '../../helper/helper_function.dart';
import '../../widgets/widget.dart';
import '../auth/login_page.dart';
import '../categories/categories.dart';
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
  String userName = "";
  String email = "";
  AudioPlayer audioPlayer = AudioPlayer();
  AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    gettingUserData();
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

  int currentPage = 0;

  List<Widget> pages = const [
    Home(
      description: '',
      englishText: '',
      dzongkhaText: '',
      image: '',
    ),
    LevelsHome(),
    Categories(),
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
        actions: [
          IconButton(
            icon: const Icon(Icons.attach_money),
            onPressed: () {
              debugPrint("Pressed on Coin");
              // Do something when the search icon is tapped
            },
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.flag),
            onPressed: () {
              // Do something when the more_vert icon is tapped
            },
          ),
          const SizedBox(width: 16),
        ],
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