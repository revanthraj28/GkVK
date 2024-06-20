import 'package:flutter/material.dart';
import 'package:gkvk/shared/components/CustomTextButton.dart';
import 'package:gkvk/shared/components/CustomTextFormField.dart';
import 'package:gkvk/views/Generate_id/detailsofCrops/Cropdetails/Cropdetails.dart';
import 'package:gkvk/views/Generate_id/detailsofCrops/Surveypages/Surveypages1.dart';

class FarmerAreaPage extends StatefulWidget {
  final int aadharId;

  FarmerAreaPage({required this.aadharId, super.key});
  @override
  _FarmerAreaPageState createState() => _FarmerAreaPageState();
}

class _FarmerAreaPageState extends State<FarmerAreaPage> {
  final List<Map<String, TextEditingController>> FarmerForm = [];
  final Set<int> submittedHissaNumbers = {};
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    addNewForm();
  }

  void addNewForm() {
    setState(() {
      FarmerForm.add({
        "hissaNumber": TextEditingController(),
      });
    });
    print('New form added. Total forms: ${FarmerForm.length}');
  }

  Future<bool> _onWillPop(BuildContext context) async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        backgroundColor: const Color(0xFFFEF8E0),
        title: const Text(
          'Confirm Exit',
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
        actions: [
          TextButton(
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Color(0xFFFB812C),
              ),
            ),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: const Text(
              'OK',
              style: TextStyle(
                color: Color(0xFFFB812C),
              ),
            ),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    )) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        backgroundColor: const Color(0xFFFEF8E0),
        appBar: AppBar(
          backgroundColor: const Color(0xFFFEF8E0),
          centerTitle: true,
          title: const Text(
            'FARMERS AREA',
            style: TextStyle(
              color: Color(0xFFFB812C),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          iconTheme: const IconThemeData(
            color: Color(0xFFFB812C),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Container(
                color: const Color(0xFFFEF8E0),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20.0),
                    ...FarmerForm.asMap().entries.map((entry) {
                      int index = entry.key;
                      Map<String, TextEditingController> formEntry = entry.value;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ' Area ${index + 1}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFB812C),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          CustomTextFormField(
                            labelText: "Hissa Number",
                            controller: formEntry['hissaNumber']!,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter Hissa Number";
                              }
                              if (int.tryParse(value) == null) {
                                return "Please enter a valid number";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20.0),
                          CustomTextButton(
                            text: "Enter Crop Details",
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                final hissaNumber = int.tryParse(formEntry['hissaNumber']?.text ?? '');
                                if (hissaNumber != null) {
                                  if (submittedHissaNumbers.contains(hissaNumber)) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('This Hissa Number has already been submitted.'),
                                      ),
                                    );
                                  } else {
                                    submittedHissaNumbers.add(hissaNumber);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Cropdetails(
                                          aadharId: widget.aadharId,
                                          hissaNumber: hissaNumber,
                                        ),
                                      ),
                                    );
                                    print("Enter Another Crop Detail + button tapped");
                                  }
                                } else {
                                  print("Invalid Hissa Number");
                                }
                              }
                            },
                          ),
                          const SizedBox(height: 20.0),
                        ],
                      );
                    }).toList(),
                    CustomTextButton(
                      text: "Add area",
                      onPressed: addNewForm,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: const Color(0xFFFEF8E0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextButton(
                text: "Fill MCQ",
                buttonColor: const Color(0xFFFB812C),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SurveyPage1(aadharId: widget.aadharId)
                    ),
                  );
                  print('clicked on Fill MCQ');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
