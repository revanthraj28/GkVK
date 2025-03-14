import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gkvk/constants/surveydata.dart';
import 'package:gkvk/models/data_model.dart';
import 'package:gkvk/shared/components/CustomTextButton.dart';
import 'package:gkvk/shared/components/Question/question_container.dart';
import 'package:gkvk/views/home/2ndcrop/newseason/surverypages2ndtime/surverypage2.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class SurveyPage1 extends StatefulWidget {
  final int aadharId;
  const SurveyPage1({required this.aadharId, super.key});

  @override
  State<SurveyPage1> createState() => _SurveyPage1State();
}

class _SurveyPage1State extends State<SurveyPage1> {
  List<String?> selectedOptions =
      List<String?>.filled(questionsPage1.length, null);
  List<String?> errors = List<String?>.filled(questionsPage1.length, null);

  // Handles option change for each question
  void _handleOptionChange(int index, String? value) {
    setState(() {
      selectedOptions[index] = value;
      errors[index] = null; // Reset error when an option is selected
    });
  }

  // Builds a single question widget
  Widget buildQuestion(Question question, int index) {
    return QuestionContainer(
      question: question,
      onChanged: (value) => _handleOptionChange(index, value),
      selectedOption: selectedOptions[index],
      errorText: errors[index], // Show error if question is unanswered
    );
  }

  String formatDate(DateTime dateTime) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(dateTime);
  }

  Future<void> _saveToFirestore() async {
    try {
      // Ensure all options are non-null
      setState(() {
        selectedOptions =
            selectedOptions.map((option) => option ?? "").toList();
      });

      // Convert the list to a JSON string
      String surveyResponsesString = jsonEncode(selectedOptions);

      final farmerRef = FirebaseFirestore.instance
          .collection("farmers")
          .doc(widget.aadharId.toString());

      // Get existing survey documents
      QuerySnapshot existingSurveys =
          await farmerRef.collection("surveyData1").get();

      // Determine the next survey number
      int nextSurveyNumber = existingSurveys.docs.length + 1;
      String newDocumentName = "Season$nextSurveyNumber";

      String formattedTimestamp = formatDate(DateTime.now());
      // Prepare the document data
      Map<String, dynamic> documentData = {
        "aadharId": widget.aadharId,
        "surveyData": surveyResponsesString, // JSON string format
        "timestamp": formattedTimestamp,
        "season": nextSurveyNumber
      };

      // Save the document
      await farmerRef
          .collection("surveyData1")
          .doc(newDocumentName)
          .set(documentData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$newDocumentName saved successfully!")),
      );

      // Navigate to the next page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SurveyPage2(aadharId: widget.aadharId),
        ),
      );
    } catch (e) {
      print("Error saving survey data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  // Validate answers and save data
  Future<void> _validateAndProceed() async {
    bool allAnswered = true;

    for (int i = 0; i < selectedOptions.length; i++) {
      if (selectedOptions[i] == null) {
        setState(() {
          errors[i] = 'Please select an option';
        });
        allAnswered = false;
      }
    }

    if (allAnswered) {
      await _saveToFirestore();
    } else {
      // Alert for incomplete answers
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
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
              style: TextStyle(color: Colors.black),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'OK',
                  style: TextStyle(color: Color(0xFFFB812C)),
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
    return WillPopScope(
      onWillPop: () async {
        // Show a confirmation dialog if needed
        return await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Are you sure you want to go back?'),
                  content: const Text(
                      'Your progress on the survey will be lost if you go back.'),
                  actions: [
                    TextButton(
                      onPressed: () =>
                          Navigator.of(context).pop(false), // Stay on page
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.of(context).pop(true), // Go back
                      child: const Text('Yes'),
                    ),
                  ],
                );
              },
            ) ??
            false; // Default to false if dialog is dismissed without a response
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
            child: ListView.builder(
              itemCount: questionsPage1.length + 1,
              itemBuilder: (context, index) {
                if (index == questionsPage1.length) {
                  return const SizedBox(
                      height: 60); // Extra space at the bottom
                }
                return buildQuestion(questionsPage1[index], index);
              },
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          height: 75,
          color: const Color(0xFFFEF8E0),
          child: CustomTextButton(
            text: 'NEXT',
            buttonColor: const Color(0xFFFB812C),
            onPressed: _validateAndProceed,
          ),
        ),
      ),
    );
  }
}
