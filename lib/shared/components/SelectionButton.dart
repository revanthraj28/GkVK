import 'package:flutter/material.dart';

class SelectionButton extends StatelessWidget {
  final String label;
  final List<String> options;
  final String? selectedOption;
  final Function(String) onPressed;
  final Function(String?)? onChanged;
  final String? errorMessage;

  const SelectionButton({
    super.key,
    required this.label,
    required this.options,
    required this.selectedOption,
    required this.onPressed,
    this.onChanged,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(height: 10.0),
        Wrap(
          spacing: 10.0,
          runSpacing: 10.0,
          children: options
              .map(
                (option) => SizedBox(
              width: (MediaQuery.of(context).size.width - 50) / 2,
              child: ElevatedButton(
                onPressed: () => onPressed(option),
                style: ElevatedButton.styleFrom(
                  backgroundColor: option == selectedOption
                      ?  Colors.black
                      : Colors.white,
                  foregroundColor:
                  option == selectedOption ? Colors.white : Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  option,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          )
              .toList(),
        ),
        if (errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(left: 5.0, top: 5.0),
            child: Text(
              'Please provide details',
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
