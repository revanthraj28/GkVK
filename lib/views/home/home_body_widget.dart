import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gkvk/controllers/tab_index_controller.dart';
import 'package:gkvk/views/home/home_tab/home_tab_view.dart';
import 'package:gkvk/views/home/list_tab/list_tab_view.dart';
import 'package:gkvk/views/home/profile_tab/profile_tab_view.dart';
class HomeBodyWidget extends StatelessWidget {

  List<Widget> bodyList = [
    const HomeTabView(),
    const ListTabView(),
    const ProfileTabView(),
  ];

  final TabIndexController navController = Get.put(TabIndexController());

  HomeBodyWidget({ super.key });

  @override
  Widget build(BuildContext context) {
    return Obx(() =>
    bodyList.elementAt(navController.selectedBodyIndex));
  }
}
