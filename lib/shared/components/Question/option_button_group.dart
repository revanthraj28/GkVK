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
      runSpacing: 0,
      children: options
          .map(
            (option) => SizedBox(
          width: MediaQuery.of(context).size.width - 40,
          child: ElevatedButton(
            onPressed: () => onPressed(option),
            style: ElevatedButton.styleFrom(
              backgroundColor: option == selectedOption ? Colors.black : Colors.white,
              foregroundColor: option == selectedOption ? Colors.white : Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              elevation: 0,
            ),
            child: Center(
              child: Text(
                option,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      )
          .toList(),
    );
  }
}
