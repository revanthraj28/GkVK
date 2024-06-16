import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? buttonColor; // Optional parameter for button background color

  const CustomTextButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.buttonColor, // Optional button color parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultButtonColor = const Color(0xFF8DB600); // Default button color if not provided

    return SizedBox(
      width: double.infinity, // Make the button occupy the full width
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: buttonColor ?? defaultButtonColor, // Use provided color or default
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0), // Updated to circular radius
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white, // Button text color
            fontSize: 18,
            fontWeight: FontWeight.w500, // Changed to medium
          ),
        ),
      ),
    );
  }
}
