import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gkvk/views/Generate_id/Completedetails/Watersheddetails/watersheddetails.dart';// Import services.dart for SystemChrome

class HomeTabView extends StatelessWidget {
  const HomeTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ensure status bar is transparent and content extends beneath it
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Transparent status bar
      statusBarIconBrightness: Brightness.dark, // Dark icons for status bar
      statusBarBrightness: Brightness.dark, // Dark content behind status bar
    ));

    return Scaffold(
      backgroundColor: Colors.transparent, // Make Scaffold background transparent
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background Image
                Image.asset(
                  'assets/images/bg4.png', // Replace with your image asset path
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.only(top: 50, left: 20, right: 20), // Adjust top padding for status bar
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Your content here
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Color(0xFFFEF8E0),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                'AgriConnect',
                                style: TextStyle(
                                  fontFamily: 'Quando', // Use the Quando font family
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.green[600],
                                ),
                              ),
                            ),
                            Positioned(
                              left: 0,
                              child: Image.asset(
                                'assets/images/gkvk_icon.png', // Replace with your logo asset path
                                height: 30,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: _buildMenuBox('Create', 'Farmer Profile', Icons.person_add, Colors.green, () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => WatershedView()),
                              );
                            })),
                            SizedBox(width: 10),
                            Expanded(child: _buildMenuBox('Edit', 'Farmer Profile', Icons.edit, Colors.orange, () {
                              // Handle Edit Farmer Profile tap
                            })),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: _buildMenuBox('Add', 'Farmer Land', Icons.landscape, Colors.brown, () {
                              // Handle Add Farmer Land tap
                            })),
                            SizedBox(width: 10),
                            Expanded(child: _buildMenuBox('Enter', 'Crop Details', Icons.grain, Colors.yellow, () {
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

  Widget _buildMenuBox(String firstLine, String secondLine, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFFEF8E0),
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(icon, size: 25, color: color),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      firstLine,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.green[600],
                      ),
                    ),
                    Text(
                      secondLine,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green[400],
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
