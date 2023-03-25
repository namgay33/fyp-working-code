// import 'package:first_app/pages/levels/quiz.dart';
// import 'package:flutter/material.dart';

// import '../../helper/helper_function.dart';
// import '../auth/login_page.dart';
// import '../../shared/constant.dart';

// class LevelHome extends StatefulWidget {
//   const LevelHome({super.key});

//   @override
//   State<LevelHome> createState() => _LevelHomeState();
// }

// class _LevelHomeState extends State<LevelHome> {
//   bool _isSignedIn = false;
//   @override
//   void initState() {
//     super.initState();
//     getUserLoggedInStatus();
//   }

//   getUserLoggedInStatus() async {
//     await HelperFunctions.getUserLoggedInStatus().then((value) {
//       if (value != null) {
//         setState(() {
//           _isSignedIn = value;
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primaryColor: Constants().primaryColor,
//         scaffoldBackgroundColor: Colors.white,
//       ),
//       home: _isSignedIn ? const QuizScreen() : const LoginPage(),
//     );
//   }
// }
