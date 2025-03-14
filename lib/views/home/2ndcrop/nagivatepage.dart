import 'package:flutter/material.dart';
import 'package:gkvk/shared/components/CustomTextButton.dart';
import 'package:gkvk/views/home/2ndcrop/newseason/Dealerssurvery.dart';
import 'package:gkvk/views/home/2ndcrop/newseason/entercropdetails.dart';

class Nagivatepage extends StatefulWidget {
  const Nagivatepage({super.key});

  @override
  State<Nagivatepage> createState() => _NagivatepageState();
}

class _NagivatepageState extends State<Nagivatepage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
            backgroundColor: const Color(0xFFFEF8E0),
            appBar: AppBar(
              backgroundColor: const Color(0xFFFEF8E0),
              centerTitle: true,
              title: const Text(
                'Navigate',
                style: TextStyle(
                  color: Color(0xFFFB812C),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              iconTheme: const IconThemeData(color: Color(0xFFFB812C)),
            ),
            body: SafeArea(
                child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CustomTextButton(
                            text: 'Farmers',
                            buttonColor: const Color(0xFFFB812C),
                            onPressed: () {
                              // Corrected Navigator.push with proper syntax
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EnterCropDetails(),
                                ),
                              );
                            }, // Your update function here
                          ),
                          const SizedBox(height: 30.0),
                          CustomTextButton(
                            text: 'Dealers',
                            buttonColor: const Color(0xFFFB812C),
                            onPressed: () {
                              // Corrected Navigator.push with proper syntax
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Dealerssurvery(),
                                ),
                              );
                            }, // Your update function here
                          )
                        ])))));
  }
}
