import 'package:flutter/material.dart';
import 'package:gkvk/shared/components/CustomTextButton.dart';
import 'package:gkvk/shared/components/CustomTextFormField.dart';
import 'package:gkvk/views/Generate_id/detailsofCrops/Cropdetails/Cropdetails.dart';
import 'package:gkvk/views/Generate_id/detailsofCrops/Surveypages/Surveypages1.dart';

class FarmerAreaPage extends StatefulWidget {
  final int aadharId;

  const FarmerAreaPage({required this.aadharId, super.key});
  @override
  _FarmerAreaPageState createState() => _FarmerAreaPageState();
}

class _FarmerAreaPageState extends State<FarmerAreaPage> {
  final List<Map<String, TextEditingController>> FarmerForm = [];
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

  // Future<void> _submitData(BuildContext context) async {
  //   final FarmersareaDb = FarmerareaDb();
  //   Map<String, dynamic> data = {
  //     "aadharId": widget.aadharId,
  //     "hissaNumbers": FarmerForm.map((form) => int.tryParse(form['hissaNumber']?.text ?? '') ?? 0).toList(),
  //   };

  //   // Add your data submission logic here
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFEF8E0),
        centerTitle: true,
        title: const Text(
          'FARMERS AREA',
          style: TextStyle(
            color: Color(0xFFFB812C),
            fontSize: 18,
            fontWeight: FontWeight.w500,
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
                  const Text(
                    'Farmers Area',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  ...FarmerForm.map((formEntry) {
                    return Column(
                      children: [
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
                          text: "ADD Crop Detail +",
                          onPressed: () {
                            final hissaNumber = int.tryParse(formEntry['hissaNumber']?.text ?? '');
                            if (hissaNumber != null) {
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
                            } else {
                              print("Invalid Hissa Number");
                            }
                          },
                        ),
                        const SizedBox(height: 20.0),
                      ],
                    );
                  }),
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
        height: 75,
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
    );
  }
}
