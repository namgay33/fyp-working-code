import 'package:first_app/pages/rank/rank.dart';
import 'package:flutter/material.dart';

import '../../helper/helper_function.dart';
import '../auth/login_page.dart';
import '../../shared/constant.dart';

class RankHome extends StatefulWidget {
  const RankHome({super.key});

  @override
  State<RankHome> createState() => _RankHomeState();
}

class _RankHomeState extends State<RankHome> {
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Constants().primaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: _isSignedIn ? const Rank() : const LoginPage(),
    );
  }
}
