import 'package:flutter/material.dart';

class AppbarWidget extends StatelessWidget  implements PreferredSizeWidget {
  const AppbarWidget({super.key});


  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white24, // Set the app bar color to white
      centerTitle: true,
      title: Image.asset(
        'assets/images/gkvk_icon.png',
        height: 40,),
    );
  }
}