import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'main.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  bool animate = false;

  final VideoPlayerController _controller =
      VideoPlayerController.asset('assets/videos/logo.mp4');

  @override
  void initState() {
    super.initState();
    _controller.initialize().then((_) {
      // Play the video
      _controller.play();
      // After playing the video, navigate to the next screen
      Timer(const Duration(seconds: 4), () {
        _controller.pause();
        _controller.setLooping(false);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const MyHomePage(
                    title: '',
                  )),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bgcolor.PNG"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: null,
            body: Center(
              child: SizedBox(
                width: 350,
                height: 350,
                child: VideoPlayer(_controller),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
