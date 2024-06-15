import 'package:flutter/material.dart';

final textButtonStyle = TextButton.styleFrom(
  backgroundColor:  Color(0xFF8DB600), // Button background color Color(0xFF438E06)
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5.0), // Updated to circular radius
  ),
);

const textStyle = TextStyle(
  color: Colors.white, // Button text color
  fontSize: 18,
  fontWeight: FontWeight.w500, // Changed to medium
);

class CustomTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomTextButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Make the button occupy the full width
      child: TextButton(
        onPressed: onPressed,
        style: textButtonStyle, // Apply the predefined style
        child: Text(
          text,
          style: textStyle,
        ),
      ),
    );
  }
}
