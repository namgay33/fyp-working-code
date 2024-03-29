import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../helper/helper_function.dart';
import '../../service/auth_service.dart';
import '../../service/database_service.dart';
import '../../widgets/widget.dart';
import '../home/home_main.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool _isLoading = false;

  AuthService authService = AuthService(uid: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).primaryColor,
      // ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                child: Center(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Druk PeyTam',
                          style: TextStyle(
                              fontSize: 40, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Log in learn and explore more!',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(height: 50),
                        // Image.asset(
                        //   "assets/bg.png",
                        //   height: 200,
                        // ),
                        // const SizedBox(height: 50),
                        TextFormField(
                          style: const TextStyle(height: 0.5),
                          decoration: textInputDecoration.copyWith(
                            labelText: "Email",
                            prefixIcon: const Icon(
                              Icons.email,
                              color: Color(0xFFFFCC33),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              email = value;
                            });
                          },
                          validator: (value) {
                            return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value!)
                                ? null
                                : "Please enter a valid email!";
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          style: const TextStyle(height: 0.5),
                          obscureText: true,
                          decoration: textInputDecoration.copyWith(
                            labelText: "Password",
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Color(0xFFFFCC33),
                            ),
                          ),
                          validator: (value) {
                            if (value!.length < 8) {
                              return "Password must be at least 8 characters";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) {
                            setState(() {
                              password = value;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFCC33),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: () {
                              login();
                            },
                            child: const Text(
                              "Sign in",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text.rich(
                          TextSpan(
                            text: "Don't have an account?",
                            style: const TextStyle(
                                color: Colors.black, fontSize: 14),
                            children: <TextSpan>[
                              TextSpan(
                                text: " Register here",
                                style: const TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    nextScreen(context, const RegisterPage());
                                  },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      await authService.loginWithUserNameAndPassword(email, password).then(
        (value) async {
          if (value == true) {
            QuerySnapshot snapshot = await DatabaseService(
                    uid: FirebaseAuth.instance.currentUser!.uid)
                .gettingUserData(email);

            // saving the value to our SF
            await HelperFunctions.saveUserLoggedInStatus(true);
            await HelperFunctions.saveUserEmailSF(email);
            await HelperFunctions.saveUserNameSF(snapshot.docs[0]["fullName"]);

            nextScreen(context, const HomePage());
          } else {
            showSnackBar(context, Colors.red, value);
            setState(() {
              _isLoading = false;
            });
          }
        },
      );
    }
  }
}
