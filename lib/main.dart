import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

// ignore: unused_import
import 'package:gkvk/views/login/Login.dart';
import 'package:gkvk/views/login/main_login/main_page.dart';
import 'controllers/user_controller.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  UserController userController = Get.put(UserController());

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GKVK',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      home: const MainPage(),
    );
  }
}

//   Widget starter() {
//     return Obx(() {
//       // ignore: unused_local_variable
//       UserModel user = userController.user;
//       return const MainPage();
//     });
//   }
// }
