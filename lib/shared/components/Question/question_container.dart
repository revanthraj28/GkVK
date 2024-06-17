import 'package:flutter/material.dart';
import 'option_button_group.dart';
import 'package:gkvk/models/data_model.dart';

class QuestionContainer extends StatelessWidget {
  final Question question;
  final ValueChanged<String?> onChanged;
  final String? selectedOption;
  final String? errorText; // Add errorText parameter

  const QuestionContainer({
    super.key,
    required this.question,
    required this.onChanged,
    this.selectedOption,
    this.errorText, // Include errorText as an optional parameter
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8, right: 8),
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8.0),
        // border: Border.all(
        //   color: errorText != null ? Colors.red : Colors.transparent, // Highlight border if errorText is not null
        //   width: 2.0,
        // ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question.questionText,
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8.0),
          OptionButtonGroup(
            options: question.options,
            selectedOption: selectedOption,
            onPressed: onChanged,
          ),
          if (errorText != null) // Display error text if provided
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                errorText!,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 12.0,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
