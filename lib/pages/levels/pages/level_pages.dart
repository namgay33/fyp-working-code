import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:first_app/pages/levels/quiz.dart';
import 'package:first_app/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../helper/helper_function.dart';
import '../../auth/login_page.dart';
import '../../home/detailed_screen.dart';

class LevelPages extends StatefulWidget {
  final int index;
  const LevelPages({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  State<LevelPages> createState() => _LevelPagesState();
}

class _LevelPagesState extends State<LevelPages> {
  final audioUrl = '';
  AudioPlayer audioPlayer = AudioPlayer();

  final List<dynamic> _outerValues = [];
  bool _isSignedIn = false;

  @override
  void initState() {
    super.initState();
    getDataFromAPI();
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

  Future<void> getDataFromAPI() async {
    const url =
        'https://paytam-490fa-default-rtdb.firebaseio.com/DrukPaytam.json';
    final response = await http.get(Uri.parse(url));
    final responseData = json.decode(response.body);

    responseData.forEach((outerKey, outerValue) {
      setState(() {
        _outerValues.add(outerValue);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> items;
    if (widget.index == 1) {
      items = _outerValues.length >= 2
          ? _outerValues.sublist(0, 5).cast<Map<String, dynamic>>()
          : [];
    } else if (widget.index == 2) {
      items = _outerValues.length >= 4
          ? _outerValues.sublist(1, 2).cast<Map<String, dynamic>>()
          : [];
    } else if (widget.index == 3) {
      items = _outerValues.length >= 4
          ? _outerValues.sublist(2, 3).cast<Map<String, dynamic>>()
          : [];
    } else if (widget.index == 4) {
      items = _outerValues.length >= 4
          ? _outerValues.sublist(3, 4).cast<Map<String, dynamic>>()
          : [];
    } else if (widget.index == 5) {
      items = _outerValues.length >= 5
          ? _outerValues.sublist(4, 5).cast<Map<String, dynamic>>()
          : [];
    } else if (widget.index == 6) {
      items = _outerValues.length >= 6
          ? _outerValues.sublist(5, 6).cast<Map<String, dynamic>>()
          : [];
    } else {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: const Center(
          child: SizedBox(
            width: 50.0,
            height: 50.0,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 242, 243, 243)),
              strokeWidth: 5.0,
              backgroundColor: Color.fromARGB(255, 255, 152, 18),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 255, 152, 18),
        title: Text("Level ${widget.index}"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  elevation: 2,
                  borderOnForeground: true,
                  shadowColor: const Color.fromARGB(0, 89, 89, 91),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(
                            dzongkhaText: _outerValues[index]['dzongkha'],
                            englishText: _outerValues[index]['english'],
                            description: _outerValues[index]['description'],
                            image: _outerValues[index]['image'],
                            audio: _outerValues[index]['audio'],
                          ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 0,
                      child: ListTile(
                        title: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(
                                    child: Text(
                                      items[index]['dzongkha'],
                                      style: const TextStyle(height: 1.7),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.volume_up,
                                      color: Colors.black,
                                    ),
                                    onPressed: () async {
                                      await audioPlayer.play(
                                          UrlSource(items[index]['audio']));
                                      debugPrint(items[index]['audio']);
                                    },
                                  ),
                                ],
                              ),
                              Text(
                                items[index]['english'],
                                style: const TextStyle(height: 1.5),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
            child: ElevatedButton(
              onPressed: () {
                _isSignedIn
                    ? nextScreen(context, QuizScreen(index: widget.index))
                    : Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 238, 172, 59),
                minimumSize: Size(MediaQuery.of(context).size.width / 2, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Attempt Quiz'),
            ),
          )
        ],
      ),
    );
  }
}
