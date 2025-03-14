import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gkvk/constants/surveydata.dart';
import 'package:gkvk/models/data_model.dart';
import 'package:gkvk/shared/components/CustomTextButton.dart';
import 'package:gkvk/shared/components/Question/question_container.dart';
import 'package:gkvk/views/home/2ndcrop/newseason/surverypages2ndtime/surverypage3.dart';
import 'package:intl/intl.dart';

class SurveyPage2 extends StatefulWidget {
  final int aadharId;
  const SurveyPage2({required this.aadharId, super.key});

  @override
  State<SurveyPage2> createState() => _SurveyPage2State();
}

class _SurveyPage2State extends State<SurveyPage2> {
  List<String?> selectedOptions =
      List<String?>.filled(questionsPage2.length, null);
  List<String?> errors = List<String?>.filled(questionsPage2.length, null);

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
          await farmerRef.collection("surveyData2").get();

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
          .collection("surveyData2")
          .doc(newDocumentName)
          .set(documentData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$newDocumentName saved successfully!")),
      );

      // Navigate to the next page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SurveyPage3(aadharId: widget.aadharId),
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
      onWillPop: () async => false, // Prevents the back button from functioning
      child:Scaffold(
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
        automaticallyImplyLeading: false, // Hides the back button
        iconTheme: const IconThemeData(color: Color(0xFFFB812C)),
      ),
      body: SafeArea(
        child: Container(
          color: const Color(0xFFFEF8E0),
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
    )
    );
  }
}
