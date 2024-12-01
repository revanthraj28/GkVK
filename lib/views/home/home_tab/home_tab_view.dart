import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gkvk/views/home/2ndcrop/editdetailsoffarmer.dart';
import 'dart:async';
import '../../Watersheddetails/watersheddetails.dart';

class HomeTabView extends StatelessWidget {
  const HomeTabView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure status bar is transparent and content extends beneath it
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Transparent status bar
      statusBarIconBrightness: Brightness.dark, // Dark icons for status bar
      statusBarBrightness: Brightness.dark, // Dark content behind status bar
    ));

    return FutureBuilder<void>(
      future: _preloadResources(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFFFEF8E0), // Set background color
            body: Center(
              child: CircularProgressIndicator(
                color: Color(
                    0xFFFB812C), // Set the color of the progress indicator
              ),
            ),
          );
        } else {
          return Scaffold(
            backgroundColor:
                Colors.transparent, // Make Scaffold background transparent
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
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
                        padding: const EdgeInsets.only(
                            top: 50,
                            left: 20,
                            right: 20), // Adjust top padding for status bar
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Your content here
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF8E0),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'LRIFA',
                                      style: TextStyle(
                                        // fontFamily: 'Quando', // Use the Quando font family
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFFFB812C),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Positioned Grid of Containers at the Bottom
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 125,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: _buildMenuBox(
                                          'Create',
                                          'Farmer Profile',
                                          Icons.person_add,
                                          Colors.black, () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => WatershedView(
                                                Category: 1,
                                              )),
                                    );
                                  })),
                                  const SizedBox(width: 10),
                                  Expanded(
                                      child: _buildMenuBox(
                                          'Edit',
                                          'Farmer Profile',
                                          Icons.edit,
                                          Colors.black, () {
                                    // Handle Edit Farmer Profile tap
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const Editdetailsoffarmer()),
                                    );
                                  })),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: _buildMenuBox(
                                          'Create',
                                          'PIA / Dealer Profile',
                                          Icons.person_add,
                                          Colors.black, () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => WatershedView(
                                                Category: 2,
                                              )),
                                    );
                                  })),
                                  const SizedBox(width: 10),
                                  Expanded(
                                      child: _buildMenuBox(
                                          'Enter',
                                          'Crop Details',
                                          Icons.grain,
                                          Colors.black, () {
                                    // Handle Enter Crop Details tap
                                  })),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Future<void> _preloadResources() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  Widget _buildMenuBox(String firstLine, String secondLine, IconData icon,
      Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFEF8E0),
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(icon, size: 25, color: color),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      firstLine,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFB812C),
                      ),
                    ),
                    Text(
                      secondLine,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: HomeTabView(),
  ));
}
