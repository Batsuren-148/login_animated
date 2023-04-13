import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_animated/screen/home.dart';
import 'package:login_animated/screen/register.dart';
import 'package:page_transition/page_transition.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text controller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _errorMessage = '';
  bool _errorChangeColor = false;

  // sign in req
  Future signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // user database
      final user = FirebaseAuth.instance.currentUser!;
      final userData = {
        'uid': user.uid,
        'email': user.email,
        'username': user.email,
        'profile':
            'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png',
      };

      DocumentSnapshot userData1 = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userData1.exists) {
        // ignore: avoid_print
        print("User UID: ${userData['uid']}");
        // ignore: avoid_print
        print("User Email: ${userData['email']}");
      } else {
        // ignore: avoid_print
        print("User documents added by new");
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set(userData);
      }

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User signed successfully!'),
        ),
      );
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        PageTransition(
          child: const HomePage(),
          type: PageTransitionType.rightToLeft,
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          _errorMessage = 'Email or password is wrong !';
          _errorChangeColor = !_errorChangeColor;
        });
      } else if (e.code == 'wrong-password') {
        setState(() {
          _errorMessage = 'Email or password is wrong !!';
          _errorChangeColor = !_errorChangeColor;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
                      duration: const Duration(milliseconds: 800),
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
                      "Login",
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
                              prefixIconColor: _errorChangeColor
                                  ? Colors.red
                                  : Colors.deepPurple,
                              fillColor: Colors.grey[100],
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide(
                                  color: _errorChangeColor
                                      ? Colors.red
                                      : Colors.deepPurple.shade400,
                                ),
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
                        const SizedBox(height: 20),
                        FadeIn(
                          delay: const Duration(milliseconds: 2000),
                          child: TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock_outline),
                              prefixIconColor: _errorChangeColor
                                  ? Colors.red
                                  : Colors.deepPurple,
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
                                  color: _errorChangeColor
                                      ? Colors.red
                                      : Colors.deepPurple.shade400,
                                ),
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

                  // error message
                  const SizedBox(height: 5),
                  Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),

                  // forgot password
                  const SizedBox(height: 5),
                  SizedBox(
                    width: double.infinity,
                    child: FadeIn(
                      delay: const Duration(milliseconds: 2200),
                      child: const Text(
                        "Forgot Password?",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

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
                        onPressed: signIn,
                        child: const Text(
                          "Log In",
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

                  const SizedBox(height: 25),
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
                              "Don't have an account? ",
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
                                    child: const RegisterPage(),
                                    type: PageTransitionType.rightToLeft,
                                  ),
                                );
                              },
                              child: const Text(
                                "Sign Up",
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
