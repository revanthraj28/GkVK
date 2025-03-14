import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gkvk/database/DealerDB/surveypage2forfer_db.dart';
import 'package:gkvk/models/data_model.dart';
import 'package:gkvk/constants/surveydata.dart';
import 'package:gkvk/shared/components/CustomTextButton.dart';

import 'package:gkvk/shared/components/Question/question_container.dart';
import 'package:gkvk/views/Surveypages/surveypagefordealers/Surveypages3forfer.dart';


class surveypage2forfer extends StatefulWidget {
  final int aadharId;
  const surveypage2forfer({required this.aadharId, super.key});

  @override
  State<surveypage2forfer> createState() => _surveypage2forferState();
}

class _surveypage2forferState extends State<surveypage2forfer> {
  List<String?> selectedOptions = List<String?>.filled(statementAcceptance.length, null);
  List<String?> errors = List<String?>.filled(statementAcceptance.length, null); // Track errors

  void _handleOptionChange(int index, String? value) {
    setState(() {
      selectedOptions[index] = value;
      errors[index] = null; // Reset error when option is selected
    });
  }

  Widget buildQuestion(Question question, int index) {
    return QuestionContainer(
      question: question,
      onChanged: (value) {
        _handleOptionChange(index, value);
      },
      selectedOption: selectedOptions[index],
      errorText: errors[index], // Pass error text to QuestionContainer
    );
  }

  Future<void> _validateAndProceed() async {
    bool allAnswered = true;

    for (int i = 0; i < selectedOptions.length; i++) {
      if (selectedOptions[i] == null) {
        setState(() {
          errors[i] = 'Please select an option'; // Set error message
        });
        allAnswered = false;
      }
    }

    if (allAnswered) {
      // Convert the selected options to a JSON string
      String jsonString = jsonEncode(selectedOptions);
      // print('Selected options JSON: $jsonString'); // Print the JSON string

      // Save to SurveyDataDB
      final surveyDataDB = SurveyDataDBforfer2();

      // Check if the survey data already exists
      final existingSurveyData = await surveyDataDB.read(widget.aadharId);

      if (existingSurveyData != null) {
        // Update the existing survey data
        await surveyDataDB.update(
          aadharId: widget.aadharId,
          surveyData: jsonString,
        );
      } else {
        // Create new survey data
        await surveyDataDB.create(
          aadharId: widget.aadharId,
          surveyData: jsonString,
        );
      }

      // Navigate to the next page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Surveypages5(aadharId: widget.aadharId)),
      );
    } else {
      // Show an alert dialog if not all questions are answered
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            backgroundColor: const Color(0xFFFEF8E0),
            title: const Text(
              'Incomplete Survey',
              style: TextStyle(
                color: Color(0xFFFB812C),
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const Text(
              'Please answer all questions before proceeding.',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'OK',
                  style: TextStyle(
                    color: Color(0xFFFB812C),
                  ),
                ),
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
        backgroundColor: const Color(0xFFFEF8E0),
        centerTitle: true,
        title: const Text(
          'ACCEPTANCE LEVEL OF LRI',
          style: TextStyle(
            color: Color(0xFFFB812C),
            fontSize: 18,
            fontWeight: FontWeight.bold,
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
                  itemCount: statementAcceptance.length + 1,  // Increase item count by 1
                  itemBuilder: (context, index) {
                    if (index == statementAcceptance.length) {
                      return const SizedBox(height: 60);  // Add SizedBox at the end
                    }
                    return buildQuestion(statementAcceptance[index], index);
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
    );
  }
}
