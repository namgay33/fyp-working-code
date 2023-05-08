import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/pages/home/detailed_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

class Home extends StatefulWidget {
  final String dzongkhaText;
  final String englishText;
  final String description;
  final String image;
  final String audio;

  const Home({
    super.key,
    required this.dzongkhaText,
    required this.englishText,
    required this.description,
    required this.image,
    required this.audio,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final audioUrl = '';
  AudioPlayer audioPlayer = AudioPlayer();

  late CollectionReference _favoritesRef;

  //
  // List<dynamic> _innerValues = [];

  final List<dynamic> _outerValues = [];
  late List<bool> isFavoritedList;

  @override
  void initState() {
    super.initState();
    getDataFromAPI();
    setFavorites();
    final String userId = getUserId();
    _favoritesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('favorites');
  }

  String getUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User is not logged in');
    }
    return user.uid;
  }

  setFavorites() async {
    final userRef =
        FirebaseFirestore.instance.collection('users').doc(getUserId());
    final docSnapshot = await userRef.get();
    if (!docSnapshot.exists || docSnapshot.get('favorites') == null) {
      await userRef.set({'favorites': []}, SetOptions(merge: true));
    }
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
    isFavoritedList = List.filled(_outerValues.length, false);
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
                                      _favoritesRef.add({
                                        'favorites': FieldValue.arrayUnion([
                                          {
                                            'dzongkha': _outerValues[index]
                                                ['dzongkha'],
                                            'english': _outerValues[index]
                                                ['english'],
                                            'description': _outerValues[index]
                                                ['description'],
                                            'image': _outerValues[index]
                                                ['image'],
                                            'audio': _outerValues[index]
                                                ['audio'],
                                          }
                                        ])
                                      }).then((value) {
                                        setState(() {
                                          isFavoritedList[index] = true;
                                        });
                                      });
                                    },
                                    icon: Icon(
                                      isFavoritedList[
                                              index] // Use the favorite status of the item at the given index to set the icon color
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: isFavoritedList[
                                              index] // Use the favorite status of the item at the given index to set the icon color
                                          ? Colors.red
                                          : Colors.black,
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
