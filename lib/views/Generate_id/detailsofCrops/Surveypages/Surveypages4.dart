import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gkvk/models/data_model.dart';
import 'package:gkvk/constants/surveydata.dart';
import 'package:gkvk/shared/components/CustomTextButton.dart';
import 'package:gkvk/database/survey_page4_db.dart';
import 'package:gkvk/shared/components/Question/question_container.dart'; // Import your new component

class Surveypages4 extends StatefulWidget {
  final int aadharId;

  const Surveypages4({super.key, required this.aadharId});

  @override
  _Surveypages4 createState() => _Surveypages4();
}

class _Surveypages4 extends State<Surveypages4> {
  List<String?> selectedOptions = List<String?>.filled(questionsPage4.length, null);
  List<String?> errors = List<String?>.filled(questionsPage4.length, null);

  void _handleOptionChange(int index, String? value) {
    setState(() {
      selectedOptions[index] = value;
      errors[index] = null;
    });
  }

  Widget buildQuestion(Question question, int index) {
    return QuestionContainer(
      question: question,
      onChanged: (value) {
        _handleOptionChange(index, value);
      },
      selectedOption: selectedOptions[index],
      errorText: errors[index],
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
          backgroundColor: Color(0xFFFEF8E0),
          centerTitle: true,
          title: const Text(
            'SURVEY PAGE 4',
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
                    itemCount: questionsPage4.length + 1, // Increase item count by 1
                    itemBuilder: (context, index) {
                      if (index == questionsPage4.length) {
                        return const SizedBox(height: 60); // Add SizedBox at the end
                      }
                      return buildQuestion(questionsPage4[index], index);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          height: 75,
          color: Color(0xFFFEF8E0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            CustomTextButton(
            text: 'DONE',
            buttonColor: Color(0xFFFB812C),
            onPressed: _validateAndProceed,
          ),
            ],
          ),
        ),

      ),
    );
  }
}
