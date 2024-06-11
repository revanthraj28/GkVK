import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gkvk/models/data_model.dart';
import 'package:gkvk/constants/surveydata.dart';
import 'package:gkvk/views/Generate_id/detailsofCrops/Surveypages/Surveypages2.dart';
import 'package:gkvk/shared/components/CustomTextButton.dart';
import 'package:gkvk/database/survey_page1_db.dart';

class SurveyPage1 extends StatefulWidget {
  final int aadharId;
  SurveyPage1({required this.aadharId, super.key});

  @override
  State<SurveyPage1> createState() => _SurveyPage1State();
}

class _SurveyPage1State extends State<SurveyPage1> {
  List<String?> selectedOptions = List<String?>.filled(questionsPage1.length, null);

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

      // Save to SurveyDataDB
      final surveyDataDB = SurveyDataDB1();
      await surveyDataDB.create(
        aadharId: widget.aadharId,
        surveyData: jsonString,
      );

      // Navigate to the next page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SurveyPage2(aadharId: widget.aadharId)),
      );
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
          'Survey Page 1',
          style: TextStyle(
            color: Color(0xFF8DB600),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: Container(
          color: const Color(0xFFF3F3F3),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: questionsPage1.length,
                  itemBuilder: (context, index) {
                    return buildQuestion(questionsPage1[index], index);
                  },
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: CustomTextButton(
          text: 'NEXT',
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
                        groupValue: selectedOption,
                        onChanged: onChanged,
                        activeColor: const Color(0xFF8DB600),
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