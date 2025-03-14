import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gkvk/constants/surveydata.dart';
import 'package:gkvk/models/data_model.dart';
import 'package:gkvk/shared/components/CustomTextButton.dart';
import 'package:gkvk/shared/components/Question/question_container.dart';
import 'package:gkvk/views/home/home_view.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class DealerSurveyPage3 extends StatefulWidget {
  final int dealerId;
  const DealerSurveyPage3({required this.dealerId, super.key});

  @override
  State<DealerSurveyPage3> createState() => _DealerSurveyPage3State();
}

class _DealerSurveyPage3State extends State<DealerSurveyPage3> {
  List<String?> selectedOptions =
      List<String?>.filled(questionsPage5.length, null);
  List<String?> errors = List<String?>.filled(questionsPage5.length, null);

  void _handleOptionChange(int index, String? value) {
    setState(() {
      selectedOptions[index] = value;
      errors[index] = null;
    });
  }

  Widget buildQuestion(Question question, int index) {
    return QuestionContainer(
      question: question,
      onChanged: (value) => _handleOptionChange(index, value),
      selectedOption: selectedOptions[index],
      errorText: errors[index],
    );
  }

  String formatDate(DateTime dateTime) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(dateTime);
  }

  Future<void> _saveToFirestore() async {
    try {
      List<String> surveyResponses =
          selectedOptions.map((e) => e ?? "").toList();
      String surveyResponsesString = jsonEncode(surveyResponses);

      final dealerRef = FirebaseFirestore.instance
          .collection("dealers")
          .doc(widget.dealerId.toString());

      // Get existing survey documents in the third page's collection
      QuerySnapshot existingSurveys =
          await dealerRef.collection("Season2").get();

      // Determine the next survey number
      int nextSurveyNumber = existingSurveys.docs.length + 1;
      String newDocumentName = "Survey$nextSurveyNumber";
      String formattedTimestamp = formatDate(DateTime.now());

      // Prepare the document data
      Map<String, dynamic> documentData = {
        "dealerId": widget.dealerId,
        "surveyData": surveyResponsesString,
        "timestamp": formattedTimestamp,
        "Season": 2
      };

      // Save the new document
      await dealerRef
          .collection("Season2")
          .doc(newDocumentName)
          .set(documentData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$newDocumentName saved successfully!")),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) =>
            false, // This makes sure all other routes are removed from the stack
      );
    } catch (e) {
      print("Error saving survey data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  Future<void> _validateAndSubmit() async {
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
              'Please answer all questions before submitting.',
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
        onWillPop: () async =>
            false, // Prevents the back button from functioning
        child: Scaffold(
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
            automaticallyImplyLeading: false,
            iconTheme: const IconThemeData(color: Color(0xFFFB812C)),
          ),
          body: SafeArea(
            child: Container(
              color: const Color(0xFFFEF8E0),
              child: ListView.builder(
                itemCount: questionsPage5.length + 1,
                itemBuilder: (context, index) {
                  if (index == questionsPage5.length) {
                    return const SizedBox(height: 60);
                  }
                  return buildQuestion(questionsPage5[index], index);
                },
              ),
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            height: 75,
            color: const Color(0xFFFEF8E0),
            child: CustomTextButton(
              text: 'SUBMIT',
              buttonColor: const Color(0xFFFB812C),
              onPressed: _validateAndSubmit,
            ),
          ),
        ));
  }
}
