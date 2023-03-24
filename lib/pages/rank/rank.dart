import 'package:first_app/pages/rank/quiz.dart';
import 'package:flutter/material.dart';

const int itemCOunt = 10;

class Rank extends StatelessWidget {
  const Rank({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: itemCOunt,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            elevation: 4,
            child: ListTile(
              title: Text('Level ${(index + 1)}'),
              leading: const Icon(Icons.lock),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QuizScreen()),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
