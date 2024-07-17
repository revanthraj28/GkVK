import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_core/firebase_core.dart';

// Import your views and controllers
import 'package:gkvk/views/login/Login.dart';
import 'package:gkvk/views/login/main_login/main_page.dart';
import 'controllers/user_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Request necessary permissions
  await Permission.camera.request();
  await Permission.photos.request();
  await Permission.storage.request(); // Request storage permission for gallery access

  // Initialize Firebase
  await Firebase.initializeApp();

  // Setup Crashlytics error handling
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // Initialize GetStorage
  await GetStorage.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final UserController userController = Get.put(UserController());

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
