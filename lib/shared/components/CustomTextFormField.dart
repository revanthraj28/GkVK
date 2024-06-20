import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final String labelText;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool enabled;

  const CustomTextFormField({
    super.key,
    required this.labelText,
    this.obscureText = false,
    required this.keyboardType,
    required this.controller,
    this.validator,
    this.enabled = true, // Default value is true
  });

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  String? _errorText;

  @override
  void initState() {
    super.initState();
    // Remove initial validation
    // Add a listener to the controller to validate on text change
    widget.controller.addListener(_validate);
  }

  @override
  void dispose() {
    // Remove the listener when the widget is disposed
    widget.controller.removeListener(_validate);
    super.dispose();
  }

  void _validate() {
    setState(() {
      _errorText = widget.validator != null ? widget.validator!(widget.controller.text) : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: !widget.enabled,
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        enabled: widget.enabled, // Enable/disable the TextFormField based on widget.enabled
        decoration: InputDecoration(
          labelText: _errorText == null ? widget.labelText : null, // Show labelText only if no error
          hintText: _errorText != null ? widget.labelText : null, // Show labelText as hint when error
          labelStyle: const TextStyle(color: Colors.black45),
          filled: true,
          fillColor: Colors.white,
          errorText: _errorText,
          errorStyle: const TextStyle(color: Colors.red),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.transparent), // Transparent border
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.transparent), // Transparent border
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.transparent), // Transparent border
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.transparent), // Transparent border
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        ),
      ),
    );
  }
}
