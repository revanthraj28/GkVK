import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gkvk/views/home/home_view.dart';
import 'package:gkvk/views/login/Login.dart';

class ThirdPage extends StatefulWidget {
  const ThirdPage({super.key});

  @override
  _ThirdPageState createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();

    Timer(const Duration(seconds: 3), () {
      _checkAuthState();
    });
  }

  Future<void> _checkAuthState() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // User is signed in
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false, // This makes sure all other routes are removed from the stack
      );
    } else {
      // User is not signed in

      // Request permissions
      await _requestPermissions();

      // Navigate to login page
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const LoginPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    }
  }

  Future<void> _requestPermissions() async {
    // Request camera permission
    // if (await Permission.storage.request().isDenied) {
    //   // Handle camera permission denied
    //   showDialog(
    //     context: context,
    //     builder: (context) => AlertDialog(
    //       title: const Text('Permission Required'),
    //       content: const Text('permission is required for this app to function correctly.'),
    //       actions: [
    //         TextButton(
    //           onPressed: () => Navigator.of(context).pop(),
    //           child: const Text('OK'),
    //         ),
    //       ],
    //     ),
    //   );
    // }
     if (await Permission.camera.request().isDenied) {
      // Handle camera permission denied
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Permission Required'),
          content: const Text('Camera permission is required for this app to function correctly.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }

    // Request photo library permission
    if (await Permission.photos.request().isDenied) {
      // Handle photo library permission denied
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Permission Required'),
          content: const Text('Photo library permission is required for this app to function correctly.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF8E0),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/LRIFA.png',
                width: 300,
                height: 300,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
