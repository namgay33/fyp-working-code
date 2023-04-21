import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:first_app/pages/home/detailed_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

class Home extends StatefulWidget {
  final String dzongkhaText;
  final String englishText;
  final String description;
  final String image;

  const Home(
      {super.key,
      required this.dzongkhaText,
      required this.englishText,
      required this.description,
      required this.image});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final audioUrl = '';
  AudioPlayer audioPlayer = AudioPlayer();

  //
  // List<dynamic> _innerValues = [];
  final List<dynamic> _outerValues = [];

  @override
  void initState() {
    super.initState();
    getDataFromAPI();
  }

  Future<void> getDataFromAPI() async {
    const url =
        'https://paytam-490fa-default-rtdb.firebaseio.com/DrukPaytam.json';
    final response = await http.get(Uri.parse(url));
    final responseData = json.decode(response.body);

    responseData.forEach((outerKey, outerValue) {
      // debugPrint('Outer Key: $outerKey');

      setState(() {
        _outerValues.add(outerValue);
      });
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _outerValues.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _outerValues.length,
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
                                      _outerValues[index]['dzongkha'],
                                      style: const TextStyle(height: 1.7),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.volume_up,
                                      color: Colors.black,
                                    ),
                                    onPressed: () async {
                                      await audioPlayer.play(UrlSource(
                                          _outerValues[index]['audio']));
                                      debugPrint(_outerValues[index]['audio']);
                                    },
                                  ),
                                ],
                              ),
                              Text(
                                _outerValues[index]['english'],
                                style: const TextStyle(height: 1.5),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  IconButton(
                                    onPressed: () {
                                      setState(() {});
                                    },
                                    icon: const Icon(
                                      Icons.favorite_border,
                                      color: Colors.black,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      // setState(() {});
                                      final String text =
                                          "PROVERBS FOR YOU FROM DRUKPEYTAM \n\n\n${_outerValues[index]['dzongkha']} \n ${_outerValues[index]['english']}";
                                      Share.share(text);
                                    },
                                    icon: const Icon(
                                      Icons.share,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
