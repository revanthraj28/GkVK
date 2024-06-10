import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextEditingController controller;
  // final FormFieldValidator<String>? validator; // Add validator property

  const CustomTextFormField({
    super.key, // Add Key parameter
    required this.labelText,
    this.obscureText = false,
    required this.keyboardType,
    required this.controller,
    // this.validator, // Initialize validator property
  }); // Set key parameter to super constructor

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.black45),
        filled: true, // Set to true to enable background fill
        fillColor: Colors.white, // Set background color to white
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide.none, // Remove the focused border
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide.none, // Remove the enabled border
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide.none, // Remove the error border
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide.none, // Remove the disabled border
        ),
        contentPadding:
        const EdgeInsets.symmetric(vertical: 10, horizontal: 15), // Adjust the padding for better appearance
      ),
      // validator: validator, // Assign validator property
    );
  }
}
