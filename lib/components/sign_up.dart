import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/components/about_us.dart';
import 'package:first_app/components/quiz.dart';
import 'package:flutter/material.dart';

//class SIgnUp {
class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _emailTextController = TextEditingController();

  final _passwordTextController = TextEditingController();
  bool pwVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Padding(
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
                    margin: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: _emailTextController,
                      decoration: InputDecoration(
                          hintText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                          )),
                    )),
                Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      obscureText: pwVisible,
                      controller: _passwordTextController,
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
                        ),
                      ),
                    )),
                Container(
                    margin: const EdgeInsets.fromLTRB(5, 0, 5, 15),
                    padding: const EdgeInsets.all(5),
                    child: ElevatedButton(
                      onPressed: () {
                        FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: _emailTextController.text,
                                password: _passwordTextController.text)
                            .then((value) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AboutUs(),
                              ));
                        });
                      },
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.all(3)),
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
                Container(
                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 10),
                  child: const Text('-----------OR-----------'),
                ),
                Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(5),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const QuizScreen(),
                            ));
                      },
                      icon: const Icon(Icons.g_mobiledata_outlined,
                          color: Colors.blue, size: 40),
                      label: const Text(
                        'Sign Up with Google',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                        ),
                      ),
                      style: ButtonStyle(
                        padding:
                            MaterialStateProperty.all(const EdgeInsets.all(3)),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white70),
                        minimumSize:
                            MaterialStateProperty.all(const Size(300, 40)),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ],
      )),
    ));
  }
}
//}