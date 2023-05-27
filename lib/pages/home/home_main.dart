import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/pages/auth/login_page.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:first_app/pages/drawer_items/about_us.dart';
import 'package:first_app/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../leaderboard/leaderboard.dart';
import '../../helper/helper_function.dart';
import '../../widgets/widget.dart';
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
  int _coinPoints = 0;
  String userName = "";
  String email = "";

  bool _isSignedIn = false;
  bool hasCollectedCoin = false;
  bool _showCoinNotification = false;
  bool isReminderEnabled = false;

  AudioPlayer audioPlayer = AudioPlayer();
  AuthService authService = AuthService(uid: '');

  @override
  void initState() {
    super.initState();
    gettingUserData();
    gettingQuizPointsAndCoinsFromFireStore();
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

  void gettingQuizPointsAndCoinsFromFireStore() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .get();
    setState(() {
      _quizPoint = userSnapshot.data()!['quizPoint'];
      _coinPoints = userSnapshot.data()!['coins'];
    });
  }

  int currentPage = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      currentPage = index;
    });
  }

  List<Widget> pages = const [
    Home(
      description: '',
      englishText: '',
      dzongkhaText: '',
      image: '',
      audio: '',
    ),
    LevelsHome(),
    Leaderboard(),
    Favorite(
      dzongkhaText: '',
      englishText: '',
      description: '',
      image: '',
      audio: '',
    ),
  ];

  Future<void> _handleRefresh() async {
    return await Future.delayed(const Duration(seconds: 2),
        () => gettingQuizPointsAndCoinsFromFireStore());
  }

// Function to retrieve the last collection time from local settings
  Future<DateTime?> getLastCollectionTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? timestamp = prefs.getInt('lastCollectionTime');
    if (timestamp != null) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    }
    return null;
  }

// Function to store the last collection time in local settings
  Future<void> setLastCollectionTime(DateTime time) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastCollectionTime', time.millisecondsSinceEpoch);
  }

  void checkRewardReady() async {
    DateTime now = DateTime.now();
    DateTime? lastCollectionTime = await getLastCollectionTime();

    if (lastCollectionTime == null ||
        lastCollectionTime.day != now.day ||
        lastCollectionTime.month != now.month ||
        lastCollectionTime.year != now.year) {
      setState(() {
        _showCoinNotification = true;
      });
    }
  }

// Example usage
  void collectDailyReward() async {
    if (_isSignedIn) {
      DateTime now = DateTime.now();
      DateTime? lastCollectionTime = await getLastCollectionTime();

      if (lastCollectionTime == null ||
          lastCollectionTime.day != now.day ||
          lastCollectionTime.month != now.month ||
          lastCollectionTime.year != now.year) {
        // Calculate the new coin balance
        int newCoinBalance = _coinPoints + 3;

        debugPrint(newCoinBalance.toString());

        // Update the coin balance in local settings

        final currentUser = FirebaseAuth.instance.currentUser;

        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser!.uid)
            .update({
          'coins': newCoinBalance,
        });

        // Update the last collection time in local settings
        await setLastCollectionTime(now);

        // Show a success message or perform any other necessary actions
        //
        Navigator.of(context).pop();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            showCloseIcon: true,
            closeIconColor: Colors.white,
            backgroundColor: Colors.red,
            content: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Image(
                    image: AssetImage('assets/coin.png'),
                    height: 25,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Reward Collected',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        // Delay the removal of the coin notification for better visual effect
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            _showCoinNotification = false;
          });
        });
      } else {
        // Show a message informing the user that they have already collected the reward today
        Navigator.of(context).pop();

        setState(() {
          _showCoinNotification = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            showCloseIcon: true,
            closeIconColor: Colors.white,
            backgroundColor: Colors.red,
            content: Center(
              child: Text(
                'You have already collected your daily reward today!',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }
    } else {
      // Prompt the user to log in before collecting the reward
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          showCloseIcon: true,
          closeIconColor: Colors.white,
          backgroundColor: Colors.red,
          content: Center(
            child: Text(
              'Please log in to collect your daily reward.',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 255, 152, 18),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/peytamlogo.PNG',
              height: 40,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              "DrukPeytam",
              style: GoogleFonts.oswald(
                textStyle: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  // color: Colors.grey.shade700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: pages[currentPage],
      endDrawer: LiquidPullToRefresh(
        onRefresh: _handleRefresh,
        color: Colors.orange,
        animSpeedFactor: 4,
        height: 100,
        showChildOpacityTransition: true,
        child: Drawer(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 50),
            children: <Widget>[
              (FirebaseAuth.instance.currentUser != null)
                  ? Icon(
                      Icons.account_circle,
                      size: 100,
                      color: Colors.grey[700],
                    )
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(50.0, 0, 50, 0),
                      child: ElevatedButton(
                        onPressed: () {
                          nextScreen(context, const LoginPage());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 238, 172, 59),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                          child: Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          'assets/point.png',
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                          child: Text(
                            _quizPoint.toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'assets/coin.png',
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                          child: Text(
                            _coinPoints.toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 1, horizontal: 20),
                child: Divider(
                  height: 4,
                  color: Colors.black,
                ),
              ),
              ListTile(
                onTap: () {
                  setState(() {
                    isReminderEnabled = !isReminderEnabled;
                  });
                },
                selectedColor: Theme.of(context).primaryColor,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                leading: const Icon(Icons.timelapse),
                title: const Text(
                  "Daily Reminder",
                  style: TextStyle(color: Colors.black),
                ),
                trailing: Switch(
                  value: isReminderEnabled,
                  onChanged: (value) {
                    setState(() {
                      isReminderEnabled = value;
                    });
                  },
                ),
              ),
              ListTile(
                onTap: () async {
                  collectDailyReward();
                },
                selectedColor: Theme.of(context).primaryColor,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                leading: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Image(
                      image: AssetImage('assets/coin.png'),
                      height: 25,
                    ),
                    if (_showCoinNotification == true && _isSignedIn)
                      Positioned(
                        bottom: 10,
                        left: 10,
                        child: Container(
                          width: 15,
                          height: 15,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text(
                              '3',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                title: const Text(
                  "Daily Reward",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              ListTile(
                onTap: () {
                  nextScreen(context, const AboutUs());
                },
                selectedColor: Theme.of(context).primaryColor,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                leading: const Icon(Icons.group),
                title: const Text(
                  "About Us",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              _isSignedIn
                  ? ListTile(
                      onTap: () async {
                        return showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Logout"),
                                content: const Text(
                                    "Are you sure you want to logout?"),
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
                                              builder: (context) =>
                                                  const HomePage()),
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
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      leading: const Icon(Icons.exit_to_app),
                      title: const Text(
                        "Logout",
                        style: TextStyle(color: Colors.black),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            // borderRadius: BorderRadius.only(
            //   topLeft: Radius.circular(40),
            //   topRight: Radius.circular(40),
            // ),
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 1)
            ]),
        // color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
          child: GNav(
            selectedIndex: currentPage,
            // backgroundColor: Colors.white,
            color: Colors.grey.shade700,
            activeColor: Colors.white,
            tabBackgroundColor: const Color(0xFFFFCC33),
            gap: 8,
            onTabChange: _navigateBottomBar,
            padding: const EdgeInsets.all(5),
            tabs: const [
              GButton(
                icon: Icons.home,
                text: "Home",
              ),
              GButton(
                icon: Icons.area_chart_rounded,
                text: "Level",
              ),
              GButton(
                icon: Icons.leaderboard_rounded,
                text: "Leaderboard",
              ),
              GButton(
                icon: Icons.favorite_rounded,
                text: "Favorites",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
