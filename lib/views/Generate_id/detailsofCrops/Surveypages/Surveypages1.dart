import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gkvk/database/cropdetails_db.dart';
import 'package:gkvk/database/farmer_profile_db.dart';
import 'package:gkvk/models/data_model.dart';
import 'package:gkvk/constants/surveydata.dart';
import 'package:gkvk/views/Generate_id/detailsofCrops/Surveypages/Surveypages2.dart';
import 'package:gkvk/shared/components/CustomTextButton.dart';
import 'package:gkvk/database/survey_page1_db.dart';
import 'package:gkvk/shared/components/Question/question_container.dart';

class SurveyPage1 extends StatefulWidget {
  final int aadharId;
  const SurveyPage1({required this.aadharId, super.key});

  @override
  State<SurveyPage1> createState() => _SurveyPage1State();
}

class _SurveyPage1State extends State<SurveyPage1> {
  List<String?> selectedOptions = List<String?>.filled(questionsPage1.length, null);
  List<String?> errors = List<String?>.filled(questionsPage1.length, null); // Track errors

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

  Future<void> _showExitConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          backgroundColor: const Color(0xFFFEF8E0),
          title: const Text(
            'Exit',
            style: TextStyle(
              color: Color(0xFFFB812C),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Do you want to return to the home page?',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Color(0xFFFB812C),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Color(0xFFFB812C),
                ),
              ),
              onPressed: () async {
                try {
                  final farmerProfileDB = FarmerProfileDB(); // Assuming FarmerProfileDB uses a singleton pattern
                  await farmerProfileDB.delete(widget.aadharId);
                  final cropdetailsDB = CropdetailsDB();
                  await cropdetailsDB.delete(widget.aadharId);

                  Navigator.of(context).popUntil((route) => route.isFirst);
                } catch (error) {
                  // print("Failed to delete farmer profile: $error");
                  // Optionally show an error message to the user
                }
              }
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
            'ATTITUDE TOWARDS LRI',
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
                    itemCount: questionsPage1.length + 1,  // Increase item count by 1
                    itemBuilder: (context, index) {
                      if (index == questionsPage1.length) {
                        return const SizedBox(height: 60);  // Add SizedBox at the end
                      }
                      return buildQuestion(questionsPage1[index], index);
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
