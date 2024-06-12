import 'package:flutter/material.dart';
import 'package:gkvk/shared/components/CustomTextButton.dart';
import 'package:gkvk/views/Generate_id/Completedetails/Watersheddetails/watersheddetails.dart';

class HomeTabView extends StatelessWidget {
  const HomeTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: const Color(0xFFF3F3F3),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  CustomTextButton(
                    text: 'GENERATE NEW ID',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WatershedView()),
                      );
                    },
                  ),
                  CustomTextButton(
                    text: "EDIT FARMER'S ID",
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => GenerateFarmersIdPage()),
                      // );
                    },
                  ),
                  CustomTextButton(
                    text: 'ENTER CROP DETAILS',
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => GenerateFarmersIdPage()),
                      // );
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/gkvk_background.png', // Replace with the correct path to your image
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}