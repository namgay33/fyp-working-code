import 'dart:async';
import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _score = 0;
  int _coins = 0;
  int _currentQuestionIndex = 0;
  Timer? _timer;
  final int _timeLimit = 60; // in seconds
  final List<Map<String, dynamic>> _quizQuestions = [
    {
      'question': 'What is the capital of France?',
      'answers': ['Paris', 'London', 'New York', 'Tokyo'],
      'correctAnswer': 'Paris',
    },
    {
      'question': 'What is the tallest mountain in the world?',
      'answers': ['Everest', 'K2', 'Kilimanjaro', 'Denali'],
      'correctAnswer': 'Everest',
    },
    {
      'question': 'What is the largest animal on Earth?',
      'answers': ['Elephant', 'Blue Whale', 'Giraffe', 'Hippopotamus'],
      'correctAnswer': 'Blue Whale',
    },
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer(Duration(seconds: _timeLimit), () {
      _endQuiz();
    });
  }

  void _endQuiz() {
    _timer?.cancel();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Quiz Over'),
          content: Text('Your score is $_score and you earned $_coins coins.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _checkAnswer(String answer) {
    if (_quizQuestions[_currentQuestionIndex]['correctAnswer'] == answer) {
      setState(() {
        _score++;
        _coins += 10;
      });
    }
  }

  void _nextQuestion() {
    if (_currentQuestionIndex == _quizQuestions.length - 1) {
      _endQuiz();
    } else {
      setState(() {
        _currentQuestionIndex++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Question ${_currentQuestionIndex + 1}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              _quizQuestions[_currentQuestionIndex]['question'],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ...(_quizQuestions[_currentQuestionIndex]['answers']
                    as List<String>)
                .map((answer) {
              return ElevatedButton(
                onPressed: () {
                  _checkAnswer(answer);
                  _nextQuestion();
                },
                child: Text(answer),
              );
            }).toList(),
            const SizedBox(height: 20),
            Text(
              'Time left: ${_timer?.tick ?? _timeLimit} seconds',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              'Score: $_score',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              'Coins: $_coins',
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
