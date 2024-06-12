import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gkvk/controllers/tab_index_controller.dart';

class HomeBottomTabWidget extends StatelessWidget {
  final selectedLabel = const TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 14,
    letterSpacing: 0.30,
  );

  final unselectedLabel = const TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 14,
    letterSpacing: 0.30,
  );

  final TabIndexController navController = Get.put(TabIndexController());

  HomeBottomTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: navController.selectedBodyIndex,
        selectedItemColor: const Color(0xFF8DB600), // Setting the selected icon and label color
        unselectedItemColor: Colors.grey, // Optionally, set the color for unselected items
        unselectedLabelStyle: unselectedLabel,
        selectedLabelStyle: selectedLabel,
        onTap: (index) {
          navController.selectedBodyIndex = index;
        },
      ),
    );
  }
}