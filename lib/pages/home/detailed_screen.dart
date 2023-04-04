import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({
    super.key,
    required this.dzongkhaText,
    required this.englishText,
    required this.description,
    required this.image,
    required this.audio,
  });

  final String dzongkhaText;
  final String englishText;
  final String description;
  final String image;
  final String audio;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  AudioPlayer audioPlayer = AudioPlayer();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 152, 18),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(10.0),
          child: Container(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Wrap(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Flexible(
                    child: Text(
                      widget.dzongkhaText,
                      style: const TextStyle(
                          height: 1.7, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.volume_up),
                    onPressed: () async {
                      await audioPlayer.play(UrlSource(widget.audio));
                      debugPrint(widget.audio);
                    },
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.englishText,
                    style: const TextStyle(
                        height: 1.5, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: (widget.image).isNotEmpty
                        ? Center(
                            child: Image.network(
                              widget.image,
                              height: 500,
                            ),
                          )
                        : const Center(child: CircularProgressIndicator()),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(widget.description, style: const TextStyle(height: 1.5)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
