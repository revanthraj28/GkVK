import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gkvk/constants/surveydata.dart';
import 'package:gkvk/models/data_model.dart';
import 'package:gkvk/shared/components/CustomTextButton.dart';
import 'package:gkvk/shared/components/Question/question_container.dart';
import 'package:gkvk/views/home/2ndcrop/newseason/surverypages2ndtime/dealerssurvey/surverypagedel1.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class DealerSurveyPage1 extends StatefulWidget {
  final int dealerId;
  const DealerSurveyPage1({required this.dealerId, super.key});

  @override
  State<DealerSurveyPage1> createState() => _DealerSurveyPage1State();
}

class _DealerSurveyPage1State extends State<DealerSurveyPage1> {
  List<String?> selectedOptions =
      List<String?>.filled(questionsPage1.length, null);
  List<String?> errors = List<String?>.filled(questionsPage1.length, null);

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

      final dealerRef = FirebaseFirestore.instance
          .collection("dealers")
          .doc(widget.dealerId.toString());
      String surveyResponsesString = jsonEncode(selectedOptions);

      // Get existing survey documents
      QuerySnapshot existingSurveys =
          await dealerRef.collection("surveyData1").get();

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

      // Save the document
      await dealerRef
          .collection("Season2")
          .doc(newDocumentName)
          .set(documentData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$newDocumentName saved successfully!")),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DealerSurveyPage2(dealerId: widget.dealerId),
        ),
      );
    } catch (e) {
      print("Error saving survey data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

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
        onWillPop: () async =>
            false, // Prevents the back button from functioning
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
            automaticallyImplyLeading: false,
            iconTheme: const IconThemeData(color: Color(0xFFFB812C)),
          ),
          body: SafeArea(
            child: Container(
              color: const Color(0xFFFEF8E0),
              child: ListView.builder(
                itemCount: questionsPage1.length + 1,
                itemBuilder: (context, index) {
                  if (index == questionsPage1.length) {
                    return const SizedBox(height: 60);
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
        ));
  }
}
