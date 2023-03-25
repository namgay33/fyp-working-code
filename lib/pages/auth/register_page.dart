import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../helper/helper_function.dart';
import '../../service/auth_service.dart';
import '../../widgets/widget.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String fullName = "";

  AuthService authService = AuthService();

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
                          'Druk Pey Tam',
                          style: TextStyle(
                              fontSize: 40, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Create your account to explore and learn more!',
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
                            labelText: "Full Name",
                            prefixIcon: const Icon(
                              Icons.person,
                              color: Color(0xFFFFCC33),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              fullName = value;
                            });
                          },
                          validator: (value) {
                            if (value!.isNotEmpty) {
                              return null;
                            } else {
                              return "Name cannot be empty!";
                            }
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
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
                              register();
                            },
                            child: const Text(
                              "Register",
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
                            text: "Already have an account?",
                            style: const TextStyle(
                                color: Colors.black, fontSize: 14),
                            children: <TextSpan>[
                              TextSpan(
                                text: " Login now",
                                style: const TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    nextScreen(context, const LoginPage());
                                  },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      await authService
          .registerUserWithEmailAndPassword(fullName, email, password)
          .then(
        (value) async {
          if (value == true) {
            // saving the shared preference state
            await HelperFunctions.saveUserLoggedInStatus(true);
            await HelperFunctions.saveUserNameSF(fullName);
            await HelperFunctions.saveUserEmailSF(email);

            nextScreenReplace(
              context,
              const LoginPage(),
            );
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
