import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/pages/auth/login_page.dart';
import 'package:first_app/pages/home/detailed_screen.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:share_plus/share_plus.dart';

class Favorite extends StatefulWidget {
  final String dzongkhaText;
  final String englishText;
  final String description;
  final String image;
  final String audio;

  const Favorite({
    super.key,
    required this.dzongkhaText,
    required this.englishText,
    required this.description,
    required this.image,
    required this.audio,
  });

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  late final String? userId;
  late final CollectionReference? _collectionReference;

  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      userId = getUserId();
      _collectionReference = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favorites');
    }
  }

  String getUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User is not logged in');
    }
    return user.uid;
  }

  Future<void> _handleRefresh() async {
    return await Future.delayed(const Duration(seconds: 2), () => getUserId());
  }

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text("Log In to view the favorites"),
              const Padding(padding: EdgeInsets.all(8)),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                },
                style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(
                      const Size(200, 50),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.orange)),
                child: const Text('Log In'),
              )
            ],
          ),
        ),
      ); // return empty scaffold if user is not logged in
    } else {
      return LiquidPullToRefresh(
        onRefresh: _handleRefresh,
        color: Colors.orange,
        animSpeedFactor: 4,
        height: 100,
        showChildOpacityTransition: true,
        child: StreamBuilder<QuerySnapshot>(
          stream: _collectionReference?.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data!.size,
              itemBuilder: (BuildContext context, int index) {
                final document = snapshot.data!.docs[index];
                return InkWell(
                  onTap: () {
                    if (document.exists) {
                      Map<String, dynamic>? data =
                          document.data() as Map<String, dynamic>?;
                      if (data != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(
                                dzongkhaText: data['dzongkha'] ?? '',
                                englishText: data['englishText'] ?? '',
                                description: data['description'] ?? '',
                                image: data['image'] ?? '',
                                audio: data['audio'] ?? ''),
                          ),
                        );
                      }
                    }
                  },
                  child: Card(
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Flexible(
                                  child: Text(
                                    document['dzongkha'],
                                    style: const TextStyle(height: 1.7),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.volume_up,
                                    color: Colors.black,
                                  ),
                                  onPressed: () async {
                                    await audioPlayer
                                        .play(UrlSource(document['audio']));
                                    debugPrint(document['audio']);
                                  },
                                ),
                              ],
                            ),
                            Text(
                              document['english'],
                              style: const TextStyle(height: 1.5),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                IconButton(
                                  onPressed: () async {
                                    // collection reference is already stored in `_collectionReference`, proceeding further:

                                    final docIdToDelete = document.id;
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Confirm Deletion'),
                                          content: const Text(
                                              'Are you sure you want to remove this from favorites?'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(); // Close the dialog
                                              },
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                // Delete the document from Firestore
                                                await _collectionReference
                                                    ?.doc(docIdToDelete)
                                                    .delete();
                                                setState(() {
                                                  // Call setState to update the UI after deleting the document
                                                });
                                                Navigator.of(context)
                                                    .pop(); // Close the dialog
                                              },
                                              child: const Text('Yes'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    // setState(() {});
                                    final String text =
                                        "PROVERBS FOR YOU FROM DRUKPEYTAM \n\n\n${document['dzongkha']} \n ${document['english']}";
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
                );
              },
            );
          },
        ),
      );
    }
  }
}
