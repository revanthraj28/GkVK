import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gkvk/constants/surveydata.dart';
import 'package:gkvk/models/data_model.dart';
import 'package:gkvk/shared/components/CustomTextButton.dart';
import 'package:gkvk/shared/components/Question/question_container.dart';
import 'package:gkvk/views/home/home_view.dart';

class SurveyPage4 extends StatefulWidget {
  final int aadharId;
  const SurveyPage4({required this.aadharId, super.key});

  @override
  State<SurveyPage4> createState() => _SurveyPage4State();
}

class _SurveyPage4State extends State<SurveyPage4> {
  List<String?> selectedOptions = List<String?>.filled(questionsPage4.length, null);
  List<String?> errors = List<String?>.filled(questionsPage4.length, null);
  bool _isSubmitting = false;

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
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  Future<void> _saveToFirestore() async {
    try {
      String surveyResponsesString = jsonEncode(selectedOptions.map((e) => e ?? "").toList());
      final farmerRef = FirebaseFirestore.instance.collection("farmers").doc(widget.aadharId.toString());
      QuerySnapshot existingSurveys = await farmerRef.collection("surveyData4").get();
      int nextSurveyNumber = existingSurveys.docs.length + 1;
      String newDocumentName = "Season$nextSurveyNumber";

      await farmerRef.collection("surveyData4").doc(newDocumentName).set({
        "aadharId": widget.aadharId,
        "surveyData": surveyResponsesString,
        "timestamp": formatDate(DateTime.now()),
        "season": nextSurveyNumber,
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$newDocumentName saved successfully!")));
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Future<void> _validateAndProceed() async {
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);

    bool allAnswered = true;
    for (int i = 0; i < selectedOptions.length; i++) {
      if (selectedOptions[i] == null) {
        setState(() => errors[i] = 'Please select an option');
        allAnswered = false;
      }
    }

    if (allAnswered) {
      await _saveToFirestore();
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          backgroundColor: const Color(0xFFFEF8E0),
          title: const Text('Incomplete Survey', style: TextStyle(color: Color(0xFFFB812C), fontWeight: FontWeight.bold)),
          content: const Text('Please answer all questions before proceeding.', style: TextStyle(color: Colors.black)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK', style: TextStyle(color: Color(0xFFFB812C))),
            ),
          ],
        ),
      );
    }

    setState(() => _isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFFEF8E0),
          centerTitle: true,
          title: const Text('KNOWLEDGE ON LRI', style: TextStyle(color: Color(0xFFFB812C), fontSize: 18, fontWeight: FontWeight.bold)),
          iconTheme: const IconThemeData(color: Color(0xFFFB812C)),
        ),
        body: SafeArea(
          child: Container(
            color: const Color(0xFFFEF8E0),
            child: ListView.builder(
              itemCount: questionsPage4.length + 1,
              itemBuilder: (context, index) {
                if (index == questionsPage4.length) return const SizedBox(height: 60);
                return buildQuestion(questionsPage4[index], index);
              },
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          height: 75,
          color: const Color(0xFFFEF8E0),
          child: CustomTextButton(
            text: _isSubmitting ? 'SUBMITTING...' : 'NEXT',
            buttonColor: const Color(0xFFFB812C),
            onPressed: _validateAndProceed,
          ),
        ),
      ),
    );
  }
}
