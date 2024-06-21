import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gkvk/shared/components/CustomAlertDialog.dart';
import 'package:gkvk/shared/components/CustomTextButton.dart';
import 'package:gkvk/views/login/Login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ForgotpasswordPage(),
    );
  }
}

class ForgotpasswordPage extends StatefulWidget {
  const ForgotpasswordPage({super.key});

  @override
  State<ForgotpasswordPage> createState() => _ForgotpasswordPageState();
}

Future<void> preloadImage(BuildContext context) async {
  await precacheImage(const AssetImage('assets/images/bg2.png'), context);
}

class _ForgotpasswordPageState extends State<ForgotpasswordPage> {
  final TextEditingController forgotemailController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> sendPasswordResetEmail() async {
    final email = forgotemailController.text.trim();
    // print('Email entered: $email');  // Debug statement

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      // print('Password reset email sent successfully to $email');

      // Show success message and navigate to login page
      showDialog(
        context: context,
        builder: (context) => CustomAlertDialog(
          title: 'Password Reset',
          content: 'Password reset email sent successfully.',
          onPressed: () {
            Navigator.of(context).pop(); // Close the success dialog
            Navigator.pushReplacement( // Navigate to login page
              context,
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
            );
          },
        ),
      );
    } on FirebaseAuthException catch (e) {
      // Handle specific error messages
      String errorMessage = 'An unexpected error occurred. Please try again later.';
      if (e.code == 'invalid-email') {
        errorMessage = 'Invalid email format. Please enter a valid email address.';
      } else if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      }

      // print('Error sending password reset email: $e');
      showDialog(
        context: context,
        builder: (context) => CustomAlertDialog(
          title: 'Error',
          content: errorMessage,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      );
    } catch (e) {
      // Handle unexpected errors
      // print('Error sending password reset email: $e');
      showDialog(
        context: context,
        builder: (context) => CustomAlertDialog(
          title: 'Error',
          content: 'An unexpected error occurred. Please try again later.',
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      );
    }
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    }
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!regex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: preloadImage(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                // Background Image
                Image.asset(
                  'assets/images/bg2.png',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: IntrinsicHeight(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF8E0),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.agriculture,
                              size: 100,
                              color: Color(0xFF8DB600),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Password Reset',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF8DB600),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: forgotemailController,
                              decoration: const InputDecoration(
                                labelText: 'Email ID',
                                border: OutlineInputBorder(),
                                fillColor: Colors.white,
                                filled: true,
                              ),
                              validator: validateEmail,
                            ),
                            const SizedBox(height: 20),
                            CustomTextButton(
                              text: "Send Email",
                              buttonColor: const Color(0xFFFB812C),
                              onPressed: () async {
                                if (validateEmail(forgotemailController.text) == null) {
                                  // Call sendPasswordResetEmail only if email is valid
                                  await sendPasswordResetEmail();
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) => CustomAlertDialog(
                                      title: 'Invalid Email',
                                      content: 'Please enter a valid email address.',
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Scaffold(
              backgroundColor: Color(0xFFFEF8E0),
              body: Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFFB812C),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
