import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gkvk/models/data_model.dart';
import 'package:gkvk/constants/surveydata.dart';
import 'package:gkvk/shared/components/CustomTextButton.dart';
import 'package:gkvk/database/farmerDB/survey_page2_db.dart';
import 'package:gkvk/shared/components/Question/question_container.dart';

import 'Surveypages3.dart';

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
      // print('Selected options JSON: $jsonString'); // Print the JSON string

      // Upload the aadharId and jsonString to SurveyDataDB2
      final surveyDataDB2 = SurveyDataDB2();

      // Check if the survey data already exists
      final existingSurveyData = await surveyDataDB2.read(widget.aadharId);

      if (existingSurveyData != null) {
        // Update the existing survey data
        await surveyDataDB2.update(
          aadharId: widget.aadharId,
          surveyData: jsonString,
        );
      } else {
        // Create new survey data
        await surveyDataDB2.create(
          aadharId: widget.aadharId,
          surveyData: jsonString,
        );
      }

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


  // Future<void> _showExitConfirmationDialog(BuildContext context) async {
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: true,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(15.0),
  //         ),
  //         backgroundColor: const Color(0xFFFEF8E0),
  //         title: const Text(
  //           'Exit',
  //           style: TextStyle(
  //             color: Color(0xFFFB812C),
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //         content: const Text(
  //           'Do you want to return to the home page?',
  //           style: TextStyle(
  //             color: Colors.black,
  //           ),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text(
  //               'Cancel',
  //               style: TextStyle(
  //                 color: Color(0xFFFB812C),
  //               ),
  //             ),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           TextButton(
  //             child: const Text(
  //               'OK',
  //               style: TextStyle(
  //                 color: Color(0xFFFB812C),
  //               ),
  //             ),
  //             onPressed: () async {
  //               try {
  //                 final farmerProfileDB = FarmerProfileDB(); // Assuming FarmerProfileDB uses a singleton pattern
  //                 await farmerProfileDB.delete(widget.aadharId);
  //                 final cropdetailsDB = CropdetailsDB();
  //                 await cropdetailsDB.delete(widget.aadharId);
  //                 final surveyDataDB1 = SurveyDataDB1();
  //                 await surveyDataDB1.delete(widget.aadharId);
  //
  //                 Navigator.of(context).popUntil((route) => route.isFirst);
  //               } catch (error) {
  //                 // print("Failed to delete farmer profile: $error");
  //                 // Optionally show an error message to the user
  //               }
  //             }
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }


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
    );
  }
}
