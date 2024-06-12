import 'package:flutter/material.dart';
import 'option_button_group.dart';
import 'package:gkvk/models/data_model.dart';

class QuestionContainer extends StatelessWidget {
  final Question question;
  final ValueChanged<String?> onChanged;
  final String? selectedOption;

  const QuestionContainer({super.key, required this.question, required this.onChanged, this.selectedOption});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8, right: 8),
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8.0),
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
        ],
      ),
    );
  }
}
