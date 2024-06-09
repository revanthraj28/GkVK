import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gkvk/views/home/home_view.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!value.contains('@')) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  Future<void> login() async {
    // Add your login logic here
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: AppBar(
              title: const Text('Hello! Welcome to the GKVK App!'),
              automaticallyImplyLeading: false,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 100),
                    const Icon(
                      Icons.agriculture,
                      size: 100,
                      color: Color(0xFF8DB600),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8DB600),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email ID',
                        border: OutlineInputBorder(),
                      ),
                      validator: validateEmail,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      validator: validatePassword,
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (validateEmail(emailController.text) == null &&
                              validatePassword(passwordController.text) ==
                                  null) {
                            try {
                              await login();
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => HomeScreen(),
                                ),
                              );
                            } catch (e) {
                              // Handle login errors
                              print('Login failed: $e');
                            }
                          } else {
                            // Show error alert message
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Login Error'),
                                content: const Text(
                                    'Please enter valid email and password.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF8DB600),
                          minimumSize: Size(150, 50),
                        ),
                        child: const Text('Login'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
