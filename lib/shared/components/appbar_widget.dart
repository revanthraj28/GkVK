import 'package:flutter/material.dart';

class AppbarWidget extends StatelessWidget  implements PreferredSizeWidget {
  const AppbarWidget({super.key});


  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFFEF8E0),
      // Set the app bar color to white
      // centerTitle: true,
      title: Row(
        children: [
          Icon(
            Icons.agriculture,
            size: 30,
            color: Colors.green[600],
          ),
          const SizedBox(width: 20,),
          Text(
            'AgriConnect',
            style: TextStyle(
              // fontFamily: 'Quando', // Use the Quando font family
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.green[600],
            ),
          ),
        ],
      ),
    );
  }
}