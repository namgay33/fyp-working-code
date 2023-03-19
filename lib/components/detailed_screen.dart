import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({
    super.key,
    required this.dzongkhaText,
    required this.englishText,
    required this.description,
  });

  final String dzongkhaText;
  final String englishText;
  final String description;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
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
            children: [
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
                    icon: const Icon(Icons.mic_sharp),
                    onPressed: () {},
                  ),
                ],
              ),
              Text(
                widget.englishText,
                style:
                    const TextStyle(height: 1.5, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Image.network(
                  'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif',
                ),
              ),
              Text(widget.description, style: const TextStyle(height: 1.5)),
            ],
          ),
        ),
      ),
    );
  }
}
