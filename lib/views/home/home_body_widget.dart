import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gkvk/controllers/tab_index_controller.dart';
import 'package:gkvk/views/home/home_tab/home_tab_view.dart';
import 'package:gkvk/views/home/list_tab/list_tab_view.dart';
import 'package:gkvk/views/home/profile_tab/profile_tab_view.dart';

class HomeBodyWidget extends StatelessWidget {
  final TabIndexController navController = Get.put(TabIndexController());

  // Initialize all tab views upfront
  final List<Widget> bodyList = [
    const HomeTabView(),
    const ListTabView(),
    const ProfilePage(),
  ];

  HomeBodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return IndexedStack(
        index: navController.selectedBodyIndex,
        children: bodyList,
      );
    });
  }
}
