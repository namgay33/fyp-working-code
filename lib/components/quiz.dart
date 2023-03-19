import 'package:flutter/material.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
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
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Row(children: <Widget>[
              const Text('Time: '),
              Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(5),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                        padding:
                            MaterialStateProperty.all(const EdgeInsets.all(10)),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white70),
                        minimumSize:
                            MaterialStateProperty.all(const Size(30, 30)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ))),
                    child: const Text(
                      '+30s',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  )),
            ]),
            const Text('Question I: '),
            Container(
              margin: const EdgeInsets.all(10),
              child: const Text('---------question---------'),
            ),
            Container(
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(5),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(10)),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.white),
                      minimumSize:
                          MaterialStateProperty.all(const Size(300, 20)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ))),
                  child: const Text(
                    'A Option',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                )),
            Container(
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(5),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(10)),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.white),
                      minimumSize:
                          MaterialStateProperty.all(const Size(300, 20)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ))),
                  child: const Text(
                    'B Option',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                )),
            Container(
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(5),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(10)),
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      minimumSize:
                          MaterialStateProperty.all(const Size(300, 20)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ))),
                  child: const Text(
                    'C Option',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                )),
            Container(
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(5),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(10)),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.white),
                      minimumSize:
                          MaterialStateProperty.all(const Size(300, 20)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ))),
                  child: const Text(
                    'D Option',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                )),
            Container(
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(5),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(10)),
                      backgroundColor:
                          MaterialStateProperty.all(const Color.fromARGB(255, 255, 187, 131)),
                      minimumSize:
                          MaterialStateProperty.all(const Size(180, 20)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ))),
                  child: const Text(
                    'NEXT',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
