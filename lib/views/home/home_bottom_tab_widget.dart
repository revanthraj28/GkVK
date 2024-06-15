import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gkvk/controllers/tab_index_controller.dart';

class HomeBottomTabWidget extends StatelessWidget {
  final TabIndexController navController = Get.put(TabIndexController());

  HomeBottomTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashFactory: NoSplash.splashFactory, // Disable the ripple effect
      ),
      child: Obx(
            () => BottomNavigationBar(
          type: BottomNavigationBarType.fixed, // Disable animation
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home', // Label is required but will be hidden
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'List', // Label is required but will be hidden
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile', // Label is required but will be hidden
            ),
          ],
          currentIndex: navController.selectedBodyIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
          backgroundColor: const Color(0xFFFB812C),//const Color(0xFFE66A16)
          // showUnselectedLabels: false, // Hides the labels
          // showSelectedLabels: false, // Hides the labels
          selectedIconTheme: const IconThemeData(
            size: 30, // Increase the size of the selected icon
            color: Colors.white, // Ensure the color is still white
          ),
          unselectedIconTheme: const IconThemeData(
            size: 24, // Keep the size of the unselected icons smaller
            color: Colors.white, // Ensure the color is still white
          ),
          onTap: (index) {
            navController.selectedBodyIndex = index;
          },
        ),
      ),
    );
  }
}
