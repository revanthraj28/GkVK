import 'package:flutter/material.dart';
import 'package:gkvk/models/data_model.dart';
import 'package:gkvk/constants/surveydata.dart';
// import 'package:gkvk/views/Generate_id/detailsofCrops/Surveypages/Surveypages3.dart';
import 'package:gkvk/shared/components/CustomTextButton.dart';
import 'package:gkvk/views/Generate_id/detailsofCrops/Surveypages/Surveypages4.dart';

class SurveyPage2 extends StatefulWidget {
  final List<String?> page1SelectedOptions;
  const SurveyPage2({super.key, required this.page1SelectedOptions});

  @override
  State<SurveyPage2> createState() => _SurveyPage2State();
}

class _SurveyPage2State extends State<SurveyPage2> {
  List<String?> selectedOptions = List<String?>.filled(questionsPage2.length, null);

  void _handleOptionChange(int index, String? value) {
    setState(() {
      selectedOptions[index] = value;
    });
  }

  Widget buildQuestion(Question question, int index) {
    return QuestionCard(
      question: question,
      onChanged: (value) {
        _handleOptionChange(index, value);
      },
      selectedOption: selectedOptions[index],
    );
  }

  void _validateAndProceed() {
    bool allAnswered = true;

    for (int i = 0; i < selectedOptions.length; i++) {
      if (selectedOptions[i] == null) {
        allAnswered = false;
        break;
      }
    }

    if (allAnswered) {
      // Print the selected options
      for (int i = 0; i < selectedOptions.length; i++) {
        print('Question ${i + 1}: ${selectedOptions[i]}');
      }

      // Navigate to the next page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Surveypages3()),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        title: const Text(
          'SURVEY PAGE 2',
          style: TextStyle(
            color: Color(0xFF8DB600),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: questionsPage2.length,
              itemBuilder: (context, index) {
                return buildQuestion(questionsPage2[index], index);
              },
            ),
          ),
          const SizedBox(height: 60,)
        ],
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
    );
  }
}

class QuestionCard extends StatelessWidget {
  final Question question;
  final ValueChanged<String?> onChanged;
  final String? selectedOption;

  const QuestionCard({super.key, required this.question, required this.onChanged, this.selectedOption});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.questionText,
              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Container(
              margin: const EdgeInsets.only(top: 8.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: question.options.map((option) {
                  return Row(
                    children: [
                      Radio<String>(
                        value: option,
                        groupValue: selectedOption,
                        onChanged: onChanged,
                        activeColor: const Color(0xFF8DB600), // Radio color when selected
                      ),
                      Flexible(
                        child: Text(option),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Surveypages3 extends StatefulWidget {
  const Surveypages3({super.key});

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
    return QuestionCard(
      question: question,
      onChanged: (value) {
        _handleOptionChange(index, value);
      },
      selectedOption: selectedOptions[index],
    );
  }

  void _validateAndProceed() {
    bool allAnswered = true;

    for (int i = 0; i < selectedOptions.length; i++) {
      if (selectedOptions[i] == null) {
        allAnswered = false;
        break;
      }
    }

    if (allAnswered) {
      // Print the selected options
      for (int i = 0; i < selectedOptions.length; i++) {
        print('Question ${i + 1}: ${selectedOptions[i]}');
      }

       Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Surveypages4()),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: questionsPage3.length,
              itemBuilder: (context, index) {
                return buildQuestion(questionsPage3[index], index);
              },
            ),
          ),
          const SizedBox(height: 60,)
        ],
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
    );
  }
}
