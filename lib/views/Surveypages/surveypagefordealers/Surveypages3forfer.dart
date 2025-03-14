import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gkvk/database/DealerDB/surveypage3forfer_db.dart';
import 'package:gkvk/models/data_model.dart';
import 'package:gkvk/constants/surveydata.dart';
import 'package:gkvk/shared/components/CustomTextButton.dart';
import 'package:gkvk/shared/components/Question/question_container.dart';
import 'package:gkvk/views/home/home_view.dart';

class Surveypages5 extends StatefulWidget {
  final int aadharId;

  const Surveypages5({super.key, required this.aadharId});

  @override
  _Surveypages5State createState() => _Surveypages5State();
}

class _Surveypages5State extends State<Surveypages5> {
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
      final surveyDataDB5 = SurveyDataDBforfer3();

      // Check if the survey data already exists
      final existingSurveyData = await surveyDataDB5.read(widget.aadharId);

      if (existingSurveyData != null) {
        // Update the existing survey data
        await surveyDataDB5.update(
          aadharId: widget.aadharId,
          surveyData: jsonString,
        );
      } else {
        // Create new survey data
        await surveyDataDB5.create(
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
                  itemCount: questionsPage5.length + 1, // Increase item count by 1
                  itemBuilder: (context, index) {
                    if (index == questionsPage5.length) {
                      return const SizedBox(height: 60); // Add SizedBox at the end
                    }
                    return buildQuestion(questionsPage5[index], index);
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
