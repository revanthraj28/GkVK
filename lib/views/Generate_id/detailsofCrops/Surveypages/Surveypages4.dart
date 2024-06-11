import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gkvk/models/data_model.dart';
import 'package:gkvk/constants/surveydata.dart';
import 'package:gkvk/shared/components/CustomTextButton.dart';
import 'package:gkvk/database/survey_page4_db.dart';

class Surveypages4 extends StatefulWidget {
  final int aadharId;

  const Surveypages4({super.key, required this.aadharId});

  @override
  _Surveypages4 createState() => _Surveypages4();
}

class _Surveypages4 extends State<Surveypages4> {
  List<String?> selectedOptions = List<String?>.filled(questionsPage4.length, null);

  void _handleOptionChange(int index, String? value) {
    setState(() {
      selectedOptions[index] = value;
    });
  }

  Widget buildQuestion(Question question, int index) {
    return QuestionCard(
      question: question,
      onChanged: (value) {
        _handleOptionChange(index, value);
      },
      selectedOption: selectedOptions[index],
    );
  }

  Future<void> _validateAndProceed() async {
    bool allAnswered = true;

    for (int i = 0; i < selectedOptions.length; i++) {
      if (selectedOptions[i] == null) {
        allAnswered = false;
        break;
      }
    }

    if (allAnswered) {
      // Convert the selected options to a JSON string
      String jsonString = jsonEncode(selectedOptions);
      print('Selected options JSON: $jsonString'); // Print the JSON string

      // Upload the aadharId and jsonString to SurveyDataDB4
      final surveyDataDB4 = SurveyDataDB4();
      await surveyDataDB4.create(
        aadharId: widget.aadharId,
        surveyData: jsonString,
      );

      // Navigate back to the initial page, clearing the navigation stack
      Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    } else {
      // Show an alert dialog if not all questions are answered
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Incomplete Survey'),
            content: const Text('Please answer all questions before proceeding.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        title: const Text(
          'SURVEY PAGE 4',
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
              itemCount: questionsPage4.length,
              itemBuilder: (context, index) {
                return buildQuestion(questionsPage4[index], index);
              },
            ),
          ),
          const SizedBox(height: 60,)
        ],
      ),
      floatingActionButton: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: CustomTextButton(
          text: 'DONE',
          onPressed: _validateAndProceed,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class QuestionCard extends StatelessWidget {
  final Question question;
  final ValueChanged<String?> onChanged;
  final String? selectedOption;

  const QuestionCard({super.key, required this.question, required this.onChanged, this.selectedOption});

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
                        groupValue: selectedOption,
                        onChanged: onChanged,
                        activeColor: const Color(0xFF8DB600), // Radio color when selected
                      ),
                      Flexible(
                        child: Text(option),
                      ),
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