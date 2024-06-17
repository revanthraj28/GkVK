import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gkvk/models/data_model.dart';
import 'package:gkvk/constants/surveydata.dart';
import 'package:gkvk/views/Generate_id/detailsofCrops/Surveypages/Surveypages3.dart';
import 'package:gkvk/shared/components/CustomTextButton.dart';
import 'package:gkvk/database/survey_page2_db.dart';
import 'package:gkvk/shared/components/Question/question_container.dart';

class SurveyPage2 extends StatefulWidget {
  final int aadharId;
  const SurveyPage2({super.key, required this.aadharId});

  @override
  State<SurveyPage2> createState() => _SurveyPage2State();
}

class _SurveyPage2State extends State<SurveyPage2> {
  List<String?> selectedOptions = List<String?>.filled(questionsPage2.length, null);
  List<String?> errors = List<String?>.filled(questionsPage2.length, null); // Track errors for each question

  void _handleOptionChange(int index, String? value) {
    setState(() {
      selectedOptions[index] = value;
      errors[index] = null; // Clear error when an option is selected
    });
  }

  Widget buildQuestion(Question question, int index) {
    return QuestionContainer(
      key: Key('question_$index'), // Example key usage
      question: question,
      onChanged: (value) {
        _handleOptionChange(index, value);
      },
      selectedOption: selectedOptions[index],
      errorText: errors[index], // Pass errorText based on errors list
    );
  }

  Future<void> _validateAndProceed() async {
    bool allAnswered = true;

    // Validate if all questions are answered
    for (int i = 0; i < selectedOptions.length; i++) {
      if (selectedOptions[i] == null) {
        setState(() {
          errors[i] = 'Please select an option'; // Set error message for unanswered questions
        });
        allAnswered = false;
      }
    }

    if (allAnswered) {
      // Convert the selected options to a JSON string
      String jsonString = jsonEncode(selectedOptions);
      print('Selected options JSON: $jsonString'); // Print the JSON string

      // Upload the aadharId and jsonString to SurveyDataDB2
      final surveyDataDB2 = SurveyDataDB2();
      await surveyDataDB2.create(
        aadharId: widget.aadharId,
        surveyData: jsonString,
      );

      // Navigate to the next page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Surveypages3(aadharId: widget.aadharId),
        ),
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

  Future<void> _showExitConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Exit'),
          content: const Text('Do you want to return to the home page?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _showExitConfirmationDialog(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFFEF8E0),
          centerTitle: true,
          title: const Text(
            'SURVEY PAGE 2',
            style: TextStyle(
              color: Color(0xFFFB812C),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          iconTheme: const IconThemeData(color: Color(0xFFFB812C)),
        ),
        body: SafeArea(
          child: Container(
            color: const Color(0xFFFEF8E0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: questionsPage2.length + 1,
                    itemBuilder: (context, index) {
                      if (index == questionsPage2.length) {
                        return const SizedBox(height: 60);
                      }
                      return buildQuestion(questionsPage2[index], index);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          height: 75,
          color: const Color(0xFFFEF8E0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextButton(
                text: 'NEXT',
                buttonColor: const Color(0xFFFB812C),
                onPressed: _validateAndProceed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
