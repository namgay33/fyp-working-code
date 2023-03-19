import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/components/quiz.dart';
import 'package:flutter/material.dart';

import 'sign_up.dart';

//class LogIn {
class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _emailControllerText = TextEditingController();

  final _passwordControllerText = TextEditingController();

  bool pwVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(10, 30, 10, 30),
            child: Column(
              children: <Widget>[
                Container(
                    padding: const EdgeInsets.all(10),
                    child: FractionallySizedBox(
                      widthFactor: 0.30,
                      child: Image.asset('assets/logo.png'),
                    )),
                Container(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 20),
                    child: const Text('Learn Proverbs for Free. Forever.')),
                Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: const Text('Login to Continue')),
                Container(
                    margin: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                    child: TextFormField(
                      controller: _emailControllerText,
                      decoration: InputDecoration(
                          hintText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                          )),
                    )),
                Container(
                    margin: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                    child: TextField(
                      controller: _passwordControllerText,
                      obscureText: pwVisible,
                      decoration: InputDecoration(
                          hintText: 'password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50)),
                          suffixIcon: InkWell(
                            child: Icon(pwVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onTap: () {
                              setState(() {
                                pwVisible = !pwVisible;
                              });
                            },
                          )),
                    )),
                Container(
                    padding: const EdgeInsets.all(5),
                    child: ElevatedButton(
                      onPressed: () {
                        FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: _emailControllerText.text,
                                password: _passwordControllerText.text)
                            .then((value) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const QuizScreen(),
                              ));
                        });
                      },
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.all(2)),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.yellow[700]),
                          minimumSize:
                              MaterialStateProperty.all(const Size(300, 40)),
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ))),
                      child: const Text(
                        'Log In',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                        ),
                      ),
                    )),
                Container(
                  padding: const EdgeInsets.fromLTRB(5, 20, 5, 5),
                  child: const Text('Forgot Password?'),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: const Text('-----------OR-----------'),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                  child: const Text("Don't have an account?"),
                ),
                Container(
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(5),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUp(),
                            ));
                      },
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.all(5)),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.yellow[700]),
                          minimumSize:
                              MaterialStateProperty.all(const Size(300, 40)),
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ))),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                        ),
                      ),
                    )),
              ],
            )),
      ),
    );
  }
}
//}