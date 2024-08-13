import 'package:flutter/material.dart';

class OptionButtonGroup extends StatelessWidget {
  final List<String> options;
  final String? selectedOption;
  final Function(String?) onPressed;

  const OptionButtonGroup({
    super.key,
    required this.options,
    required this.selectedOption,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 5,
      runSpacing: 8,
      children: options.map((option) {
        return SizedBox(
          width: MediaQuery.of(context).size.width -
              40, // Keep the width as before
          child: IntrinsicHeight(
            // Ensures the height is adjusted based on content
            child: ElevatedButton(
              onPressed: () => onPressed(option),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    option == selectedOption ? Colors.black : Colors.white,
                foregroundColor:
                    option == selectedOption ? Colors.white : Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                elevation: 0,
                padding: const EdgeInsets.all(16.0),
              ),
              child: Text(
                option,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
