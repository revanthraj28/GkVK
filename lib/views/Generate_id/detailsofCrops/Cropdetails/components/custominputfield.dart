import 'package:flutter/material.dart';

class CustomInputField extends StatefulWidget {
  final String label;
  final String subLabel;

  const CustomInputField({super.key, required this.label, required this.subLabel});

  @override
  _CustomInputFieldState createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.label, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Focus(
          onFocusChange: (hasFocus) {
            setState(() {
              _isFocused = hasFocus;
            });
          },
          child: SizedBox(
            width: 60,
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: _isFocused ? const Color(0xFF8DB600) : Colors.grey), // Change color based on focus
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(widget.subLabel),
      ],
    );
  }
}
