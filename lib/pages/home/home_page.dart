import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/pages/home/detailed_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:share_plus/share_plus.dart';

import '../auth/login_page.dart';

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
  late CollectionReference favoritesRef;

  //
  // List<dynamic> _innerValues = [];

  final List<dynamic> _outerValues = [];
  List<Map<String, dynamic>> favoriteItems = [];
  late List<bool> isFavoritedList;
  late bool isFavorite;

  @override
  void initState() {
    super.initState();

    // Check if the user is logged in
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Load favorites and set up favoritesRef
      loadFavorites();
      // setFavorites();

      final String userId = getUserId();

      favoritesRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favorites');
    }

    // Always get data from the API
    getDataFromAPI();
  }

  String getUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User is not logged in');
    }
    return user.uid;
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

  Future<void> loadFavorites() async {
    // Load favorites from Firestore
    final user = FirebaseAuth.instance.currentUser;
    final favoritesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('favorites');
    final querySnapshot = await favoritesRef.get();
    setState(() {
      favoriteItems = querySnapshot.docs.map((doc) => doc.data()).toList();
      isFavoritedList = List.filled(_outerValues.length, false);
      for (var i = 0; i < _outerValues.length; i++) {
        final isFavorite = favoriteItems
            .any((item) => item['dzongkha'] == _outerValues[i]['dzongkha']);
        if (isFavorite) {
          isFavoritedList[i] = true;
        }
      }
    });
  }

  Future<void> _handleRefresh() async {
    return await Future.delayed(
        const Duration(seconds: 2), () => loadFavorites());
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: _outerValues.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : LiquidPullToRefresh(
              onRefresh: _handleRefresh,
              color: Colors.orange,
              animSpeedFactor: 4,
              height: 100,
              showChildOpacityTransition: true,
              child: ListView.builder(
                itemCount: 10,
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
                                        debugPrint(
                                            _outerValues[index]['audio']);
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
                                      onPressed: () async {
                                        if (user == null) {
                                          // Show login dialog
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text(
                                                    "Login required"),
                                                content: const Text(
                                                    "Please log in to add to favorites."),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: const Text("Cancel"),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: const Text("Log in"),
                                                    onPressed: () {
                                                      // Navigate to login screen
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const LoginPage()),
                                                      );
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        } else {
                                          // Perform favorite or share action
                                          loadFavorites();
                                          isFavorite = favoriteItems.any(
                                              (item) =>
                                                  item['dzongkha'] ==
                                                  _outerValues[index]
                                                      ['dzongkha']);
                                          if (!isFavorite) {
                                            await favoritesRef.add({
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
                                            });
                                            await loadFavorites();
                                          } else {
                                            QuerySnapshot querySnapshot =
                                                await favoritesRef
                                                    .where('dzongkha',
                                                        isEqualTo:
                                                            _outerValues[index]
                                                                ['dzongkha'])
                                                    .get();
                                            for (var doc
                                                in querySnapshot.docs) {
                                              doc.reference.delete();
                                            }
                                            loadFavorites();
                                          }
                                        }
                                      },
                                      icon: Icon(
                                        favoriteItems.any((item) =>
                                                item['dzongkha'] ==
                                                _outerValues[index]['dzongkha'])
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: favoriteItems.any((item) =>
                                                item['dzongkha'] ==
                                                _outerValues[index]['dzongkha'])
                                            ? Colors.red
                                            : Colors.black,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        if (user == null) {
                                          // Show login dialog
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text(
                                                    "Login required"),
                                                content: const Text(
                                                    "Please log in to share."),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: const Text("Cancel"),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: const Text("Log in"),
                                                    onPressed: () {
                                                      // Navigate to login screen
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const LoginPage()),
                                                      );
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        } else {
                                          // Perform share action
                                          final String text =
                                              "PROVERBS FOR YOU FROM DRUKPEYTAM \n\n\n${_outerValues[index]['dzongkha']} \n ${_outerValues[index]['english']}";
                                          Share.share(text);
                                        }
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
            ),
    );
  }
}
