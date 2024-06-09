import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gkvk/views/login/Login.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser;

  void _signOutAndNavigateToLogin() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              onPressed: _signOutAndNavigateToLogin,
              color: Color(0xFF8DB600),
              child: Text('Sign Out'),
            )
          ],
        ),
      ),
    );
  }
}
