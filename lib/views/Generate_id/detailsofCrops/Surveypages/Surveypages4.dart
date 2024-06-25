import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gkvk/database/cropdetails_db.dart';
import 'package:gkvk/database/farmer_profile_db.dart';
import 'package:gkvk/database/survey_page1_db.dart';
import 'package:gkvk/database/survey_page2_db.dart';
import 'package:gkvk/database/survey_page3_db.dart';
import 'package:gkvk/database/survey_page4_db.dart';
import 'package:gkvk/models/data_model.dart';
import 'package:gkvk/constants/surveydata.dart';
import 'package:gkvk/shared/components/CustomTextButton.dart';
import 'package:gkvk/shared/components/Question/question_container.dart';
import 'package:gkvk/views/home/home_view.dart';

class Surveypages4 extends StatefulWidget {
  final int aadharId;

  const Surveypages4({super.key, required this.aadharId});

  @override
  _Surveypages4State createState() => _Surveypages4State();
}

class _Surveypages4State extends State<Surveypages4> {
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

      // Upload the aadharId and jsonString to SurveyDataDB4
      final surveyDataDB4 = SurveyDataDB4();

      // Check if the survey data already exists
      final existingSurveyData = await surveyDataDB4.read(widget.aadharId);

      if (existingSurveyData != null) {
        // Update the existing survey data
        await surveyDataDB4.update(
          aadharId: widget.aadharId,
          surveyData: jsonString,
        );
      } else {
        // Create new survey data
        await surveyDataDB4.create(
          aadharId: widget.aadharId,
          surveyData: jsonString,
        );
      }

      // Navigate back to the initial page, clearing the navigation stack
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false, // This makes sure all other routes are removed from the stack
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
  //                 final farmerProfileDB = FarmerProfileDB();
  //                 await farmerProfileDB.delete(widget.aadharId);
  //                 final cropdetailsDB = CropdetailsDB();
  //                 await cropdetailsDB.delete(widget.aadharId);
  //                 final surveyDataDB1 = SurveyDataDB1();
  //                 await surveyDataDB1.delete(widget.aadharId);
  //                 final surveyDataDB2 = SurveyDataDB2();
  //                 await surveyDataDB2.delete(widget.aadharId);
  //                 final surveyDataDB3 = SurveyDataDB3();
  //                 await surveyDataDB3.delete(widget.aadharId);
  //                 final surveyDataDB4 = SurveyDataDB4();
  //                 await surveyDataDB4.delete(widget.aadharId);
  //
  //                 Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  //               } catch (error) {
  //                 // print("Failed to delete farmer profile: $error");
  //               }
  //             },
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
          'KNOWLEDGE ON LRI',
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
        color: const Color(0xFFFEF8E0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextButton(
              text: 'DONE',
              buttonColor: const Color(0xFFFB812C),
              onPressed: _validateAndProceed,
            ),
          ],
        ),
      ),
    );
  }
}
