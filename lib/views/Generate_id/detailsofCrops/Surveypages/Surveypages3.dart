import 'dart:convert'; // Add this import
import 'package:flutter/material.dart';
import 'package:gkvk/models/data_model.dart';
import 'package:gkvk/constants/surveydata.dart';
import 'package:gkvk/shared/components/CustomTextButton.dart';
import 'package:gkvk/views/Generate_id/detailsofCrops/Surveypages/Surveypages4.dart';
import 'package:gkvk/database/survey_page3_db.dart'; // Import the database class
import 'package:gkvk/shared/components/Question/question_container.dart';  // Import your new component

class Surveypages3 extends StatefulWidget {
  final int aadharId;

  const Surveypages3({super.key, required this.aadharId});

  @override
  _Surveypages3 createState() => _Surveypages3();
}

class _Surveypages3 extends State<Surveypages3> {
  List<String?> selectedOptions = List<String?>.filled(questionsPage3.length, null);

  void _handleOptionChange(int index, String? value) {
    setState(() {
      selectedOptions[index] = value;
    });
  }

  Widget buildQuestion(Question question, int index) {
    return QuestionContainer(
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

      // Upload the aadharId and jsonString to SurveyDataDB3
      final surveyDataDB3 = SurveyDataDB3();
      await surveyDataDB3.create(
        aadharId: widget.aadharId,
        surveyData: jsonString,
      );

      // Navigate to the next page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Surveypages4(aadharId: widget.aadharId), // Pass the aadharId to the next page
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
            backgroundColor: Colors.white,
            elevation: 2,
            centerTitle: true,
            title: const Text(
              'SURVEY PAGE 3',
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
                      itemCount: questionsPage3.length + 1,  // Increase item count by 1
                      itemBuilder: (context, index) {
                        if (index == questionsPage3.length) {
                          return const SizedBox(height: 60);  // Add SizedBox at the end
                        }
                        return buildQuestion(questionsPage3[index], index);
                      },
                    ),
                  ),
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
        )
    );
  }
}
