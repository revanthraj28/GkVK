import 'package:flutter/material.dart';
import 'package:gkvk/models/data_model.dart';
import 'package:gkvk/constants/surveydata.dart';
import 'package:gkvk/views/detailsofCrops/Surveypages/Surveypages2.dart';

class SurveyPage1 extends StatefulWidget {
  const SurveyPage1({super.key});

  @override
  State<SurveyPage1> createState() => _SurveyPage1State();
}

class _SurveyPage1State extends State<SurveyPage1> {
  void _handleOptionChange(int index, String? value) {
    setState(() {
      questionsPage1[index].selectedOption = value!;
    });
  }

  Widget buildQuestion(Question question, int index) {
    return QuestionCard(
      question: question,
      onChanged: (value) {
        _handleOptionChange(index, value);
      },
    );
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Survey Page 1'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: questionsPage1.length,
              itemBuilder: (context, index) {
                return buildQuestion(questionsPage1[index], index);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Logic for the previous button if needed
                  },
                  child: const Text('PREVIOUS'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SurveyPage2()),
                    );
                  },
                  child: const Text('NEXT'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class QuestionCard extends StatelessWidget {
  final Question question;
  final ValueChanged<String?> onChanged;

  const QuestionCard({super.key, required this.question, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.questionText,
              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Container(
              margin: const EdgeInsets.only(top: 4.0),
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(3.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: question.options.map((option) {
                  return Row(
                    children: [
                      Radio<String>(
                        value: option,
                        groupValue: question.selectedOption,
                        onChanged: onChanged,
                        activeColor: const Color(0xFF8DB600), // Radio color when selected
                      ),
                      Text(option),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
