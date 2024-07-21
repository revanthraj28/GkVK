import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gkvk/controllers/tab_index_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gkvk/views/login/animationpages/ThirdPage.dart';
// Import HomeBodyWidget

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser;
  final TabIndexController navController = Get.put(TabIndexController());

  void _signOutAndNavigateToLogin() async {
    await FirebaseAuth.instance.signOut();
    navController.selectedBodyIndex = 0; // Reset tab index to 0
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const ThirdPage(),
      ),
    );
  }

  Future<void> preloadImage(BuildContext context) async {
    await precacheImage(const AssetImage('assets/images/bg3.png'), context);
  }

  String getUsernameFromEmail(String? email) {
    if (email == null || email.isEmpty) return 'Name not available';
    return email.split('@')[0];
  }

  // Future<int> getFarmerCount() async {
  //   if (user == null) return 0;
  //   final doc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
  //   return doc.exists ? doc['farmerCount'] ?? 0 : 0  ;
  // }
  //  Future<int> getdealerCount() async {
  //   if (user == null) return 0;
  //   final doc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
  //   return doc.exists ? doc['dealerCount'] ?? 0 : 0  ;
  // }

  @override
  Widget build(BuildContext context) {
    final userEmail = user?.email ?? '';

    return Scaffold(
      body: FutureBuilder(
        future: preloadImage(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                // Background Image
                Image.asset(
                  'assets/images/bg3.png', // Replace with your image asset path
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
                            CircleAvatar(
                              radius: 50,
                              child: user?.photoURL != null
                                  ? ClipOval(
                                      child: Image.network(
                                        user!.photoURL!,
                                        fit: BoxFit.cover,
                                        width: 100,
                                        height: 100,
                                      ),
                                    )
                                  : Icon(
                                      Icons.person,
                                      size: 50,
                                      color: Colors.grey[700],
                                    ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              getUsernameFromEmail(user?.email),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              user?.email ?? 'Email not available',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[700],
                              ),
                            ),
                            // const SizedBox(height: 32),
                            // FutureBuilder<int>(
                            //   future: getFarmerCount(),
                            //   builder: (context, snapshot) {
                            //     if (snapshot.connectionState == ConnectionState.waiting) {
                            //       return const CircularProgressIndicator();
                            //     } else if (snapshot.hasError) {
                            //       return Text('Error: ${snapshot.error}');
                            //     } else {
                            //       return Text(
                            //         'Farmers Uploaded: ${snapshot.data}',
                            //         style: const TextStyle(
                            //           fontSize: 18,
                            //           fontWeight: FontWeight.bold,
                            //         ),
                            //       );
                            //     }
                            //   },
                            // ),
                            //   const SizedBox(height: 32),
                            // FutureBuilder<int>(
                            //   future: getdealerCount(),
                            //   builder: (context, snapshot) {
                            //     if (snapshot.connectionState == ConnectionState.waiting) {
                            //       return const CircularProgressIndicator();
                            //     } else if (snapshot.hasError) {
                            //       return Text('Error: ${snapshot.error}');
                            //     } else {
                            //       return Text(
                            //         'Dealer Uploaded: ${snapshot.data}',
                            //         style: const TextStyle(
                            //           fontSize: 18,
                            //           fontWeight: FontWeight.bold,
                            //         ),
                            //       );
                            //     }
                            //   },
                            // ),
                            const SizedBox(height: 32),
                            MaterialButton(
                              onPressed: _signOutAndNavigateToLogin,
                              color: const Color(0xFFFB812C),
                              child: const Text(
                                'Sign Out',
                                style: TextStyle(color: Colors.white),
                              ),
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
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: ProfilePage(),
  ));
}
