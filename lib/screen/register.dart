import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text controller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _errorMessage = '';

  Future signUp() async {
    if (passwordConfirmed()) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User created successfully!'),
          ),
        );
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          PageTransition(
            child: const LoginPage(),
            type: PageTransitionType.leftToRight,
          ),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          setState(() {
            _errorMessage = 'The password length must be 6.';
          });
        } else if (e.code == 'email-already-in-use') {
          setState(() {
            _errorMessage = 'The account already exists for that email.';
          });
        }
      } catch (e) {
        // ignore: avoid_print
        print(e.toString());
      }
    }
  }

  bool passwordConfirmed() {
    if (_passwordController.text.trim() ==
        _confirmPasswordController.text.trim()) {
      return true;
    } else {
      // ignore: avoid_print
      setState(() {
        _errorMessage = 'Password is not matched';
      });
      return false;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.45;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: height,
              child: Stack(
                children: [
                  Positioned(
                    top: -40,
                    height: height,
                    width: width,
                    child: FadeInDown(
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/background.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    height: height,
                    width: width + 20,
                    child: FadeInDown(
                      delay: const Duration(milliseconds: 1200),
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/background-2.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // login
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeIn(
                    delay: const Duration(milliseconds: 1600),
                    child: const Text(
                      "Register",
                      style: TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                        fontSize: 30,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Column(
                      children: [
                        FadeIn(
                          delay: const Duration(milliseconds: 1800),
                          child: TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              hintText: "Username",
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple.shade200,
                              ),
                              prefixIcon: const Icon(Icons.person),
                              prefixIconColor: Colors.deepPurple,
                              fillColor: Colors.grey[100],
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide(
                                    color: Colors.deepPurple.shade400),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: const BorderSide(
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        FadeIn(
                          delay: const Duration(milliseconds: 2000),
                          child: TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock_outline),
                              prefixIconColor: Colors.deepPurple,
                              hintText: "Password",
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple.shade200,
                              ),
                              fillColor: Colors.grey[100],
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide(
                                    color: Colors.deepPurple.shade400),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: const BorderSide(
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // confirm password
                        const SizedBox(height: 10),
                        FadeIn(
                          delay: const Duration(milliseconds: 2200),
                          child: TextField(
                            controller: _confirmPasswordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock_outline),
                              prefixIconColor: Colors.deepPurple,
                              hintText: "Confirm Password",
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple.shade200,
                              ),
                              fillColor: Colors.grey[100],
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide(
                                    color: Colors.deepPurple.shade400),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: const BorderSide(
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _errorMessage,
                    style: const TextStyle(
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // button
                  FadeIn(
                    delay: const Duration(milliseconds: 2400),
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 60),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.deepPurple,
                      ),
                      child: TextButton(
                        onPressed: signUp,
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Center(
                      child: FadeIn(
                        delay: const Duration(milliseconds: 2600),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "You have an account?",
                              style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    child: const LoginPage(),
                                    type: PageTransitionType.leftToRight,
                                  ),
                                );
                              },
                              child: const Text(
                                "Sign In",
                                style: TextStyle(
                                  color: Colors.deepPurple,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
