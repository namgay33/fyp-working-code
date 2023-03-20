import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'components/home_main.dart';
import 'package:flutter/foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      name: "Druk Peytam",
      options: const FirebaseOptions(
        apiKey: 'AIzaSyA8-WvSPSOqOn87gRu5H_uqJNxgikdasqc',
        authDomain: 'paytam-490fa.firebaseapp.com',
        databaseURL: 'https://paytam-490fa-default-rtdb.firebaseio.com',
        projectId: 'paytam-490fa',
        storageBucket: 'paytam-490fa.appspot.com',
        messagingSenderId: '702069271398',
        appId: '1:702069271398:web:8f1b722ae39f5d0745b6a7',
        measurementId: 'G-0KBGM51WV2',
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(
    //     const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => SplashScreenState();
}

class SplashScreenState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();

    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomePage())));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.yellow,
        child: FractionallySizedBox(
          widthFactor: 0.70,
          child: Image.asset(
            'assets/logo.png',
          ),
        ));
  }
}
