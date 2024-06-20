import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onPressed;

  const CustomAlertDialog({
    required this.title,
    required this.content,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      backgroundColor: const Color(0xFFFEF8E0),
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xFFFB812C),
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        content,
        style: const TextStyle(
          color: Colors.black,
        ),
      ),
      actions: [
        TextButton(
          onPressed: onPressed,
          child: const Text(
            'OK',
            style: TextStyle(
              color: Color(0xFFFB812C),
            ),
          ),
        ),
      ],
    );
  }
}
