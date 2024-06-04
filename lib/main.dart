import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:gkvk/views/home/home_view.dart';
// ignore: unused_import
import 'package:gkvk/views/login/Login.dart';
import 'controllers/user_controller.dart';
import 'models/user_model.dart';

void main() async {
  await GetStorage.init();
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {

  UserController userController = Get.put(UserController());

  MyApp({super.key});

  // This widget is the root of our application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GKVK',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      home: starter(),
    );
  }

  Widget starter() {

    return Obx(() {
      // ignore: unused_local_variable
      UserModel user = userController.user;
      return const HomeScreen();
        });
  }

}
