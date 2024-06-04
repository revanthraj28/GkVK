import 'package:flutter/material.dart';
import 'package:gkvk/models/data_model.dart';
import 'package:gkvk/constants/surveydata.dart';

class SurveyPage2 extends StatefulWidget {
  const SurveyPage2({super.key});

  @override
  State<SurveyPage2> createState() => _SurveyPage2State();
}

class _SurveyPage2State extends State<SurveyPage2> {
  void _handleOptionChange(int index, String? value) {
    setState(() {
      questionsPage2[index].selectedOption = value!;
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
        backgroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        title: const Text(
          'SURVEY PAGE 2',
          style: TextStyle(
            color: Color(0xFF8DB600),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: questionsPage2.length,
              itemBuilder: (context, index) {
                return buildQuestion(questionsPage2[index], index);
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
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF8DB600), // Button color
                  ),
                  child: const Text('PREVIOUS'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Logic for the next button if needed
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF8DB600), // Button color
                  ),
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
              margin: const EdgeInsets.only(top: 8.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
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
                        activeColor: Color(0xFF8DB600), // Radio color when selected
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
