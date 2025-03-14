import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:gkvk/shared/components/CustomAlertDialog.dart';
import 'package:gkvk/shared/components/CustomTextButton.dart';
import 'package:gkvk/shared/components/CustomTextFormField.dart';
import 'package:gkvk/shared/components/SelectionButton.dart';
import 'package:gkvk/views/home/2ndcrop/newseason/surverypages2ndtime/dealerssurvey/surverypagedel.dart';

class Dealerssurvery extends StatefulWidget {
  const Dealerssurvery({super.key});

  @override
  State<Dealerssurvery> createState() => _DealerssurveryState();
}

class _DealerssurveryState extends State<Dealerssurvery> {
  final _formKey = GlobalKey<FormState>();
  final dealersAadhaarNumberController = TextEditingController();

  // Text Editing Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _piacadreController = TextEditingController();
  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _aadharNumberController = TextEditingController();
  final TextEditingController _educationStatusController =
      TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _watershedIdController = TextEditingController();
  final TextEditingController _timestampController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _userController = TextEditingController();

  final RxString _durationControllerupdate = ''.obs;
  final RxString _Category = ''.obs;

  Map<String, dynamic>? dealersDetails;

  Future<void> getdealersDetailsByAadhaar(String aadhaarNumber) async {
    try {
      final int aadhaarNumberAsInt = int.parse(aadhaarNumber);
      final dealersCollection =
          FirebaseFirestore.instance.collection('dealers');
      final querySnapshot = await dealersCollection
          .where('aadharNumber', isEqualTo: aadhaarNumberAsInt)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final dealerDoc = querySnapshot.docs.first;
        final Map<String, dynamic> dealerData = dealerDoc.data();

        // Populate controllers
        setState(() {
          _nameController.text = dealerData['Name'] ?? '';
          _categoryController.text = dealerData['Category'] ?? '';
          _piacadreController.text = dealerData['PIACadre'] ?? '';
          _fatherNameController.text = dealerData['fatherName'] ?? '';
          _genderController.text = dealerData['gender'] ?? '';
          _phoneNumberController.text =
              dealerData['phonenumber']?.toString() ?? '';
          _emailController.text = dealerData['email'] ?? '';
          _aadharNumberController.text =
              dealerData['aadharNumber']?.toString() ?? '';
          _educationStatusController.text = dealerData['educationStatus'] ?? '';
          _durationController.text = dealerData['Duration'] ?? '';
          _placeController.text = dealerData['Place'] ?? '';
          _watershedIdController.text =
              dealerData['watershedId']?.toString() ?? '';
          _timestampController.text = dealerData['timestamp']?.toString() ?? '';
          _imageController.text = dealerData['image'] ?? '';
          _userController.text = dealerData['User'] ?? '';

          // Sync _durationControllerupdate with _durationController
          _durationControllerupdate.value = _durationController.text;
        });

        print("Dealer details fetched and controllers updated!");
      } else {
        showDialog(
          context: context,
          builder: (context) => CustomAlertDialog(
            title: 'Error',
            content: "No Dealer found for Aadhaar Number",
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => CustomAlertDialog(
          title: 'Error',
          content: "Error fetching Dealers details: $e",
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      );
    }
  }

  Future<void> updateDealerDuration(
      String aadhaarNumber, String newDuration) async {
    try {
      final dealersCollection =
          FirebaseFirestore.instance.collection('dealers');

      // Query the document based on Aadhaar Number
      final querySnapshot = await dealersCollection
          .where('aadharNumber', isEqualTo: int.parse(aadhaarNumber))
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the document ID of the first matching dealer
        final docId = querySnapshot.docs.first.id;

        // Update the Duration field
        await dealersCollection.doc(docId).update({
          'Duration': newDuration,
        });

        // Reflect the update in the text controller
        setState(() {
          _durationController.text = newDuration;
        });

        // Success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Duration updated successfully!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DealerSurveyPage1(dealerId: int.parse(aadhaarNumber)),
          ),
        );
      } else {
        // Show error if no dealer is found
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("No dealer found with the provided Aadhaar Number."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error updating duration: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFEF8E0),
        appBar: AppBar(
          backgroundColor: const Color(0xFFFEF8E0),
          centerTitle: true,
          title: const Text(
            'Edit Dealer Details',
            style: TextStyle(
              color: Color(0xFFFB812C),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          iconTheme: const IconThemeData(color: Color(0xFFFB812C)),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Aadhaar Number Field
                  CustomTextFormField(
                    labelText: "Aadhaar Number",
                    keyboardType: TextInputType.number,
                    controller: _aadharNumberController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please provide Aadhaar number";
                      }
                      if (value.length != 12) {
                        return "12 digits only";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Search Button
                  CustomTextButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await getdealersDetailsByAadhaar(
                          _aadharNumberController.text,
                        );
                      }
                    },
                    text: ('Search Dealer'),
                  ),
                  const SizedBox(height: 20),

                  // Name Field
                  CustomTextFormField(
                    labelText: "Name",
                    keyboardType: TextInputType.text,
                    controller: _nameController,
                    enabled: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please provide Name";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Category Field
                  CustomTextFormField(
                    enabled: false,
                    labelText: "Category",
                    keyboardType: TextInputType.text,
                    controller: _categoryController,
                  ),
                  const SizedBox(height: 20),

                  // PIA Cadre Field
                  CustomTextFormField(
                    enabled: false,
                    labelText: "PIA Cadre",
                    keyboardType: TextInputType.text,
                    controller: _piacadreController,
                  ),
                  const SizedBox(height: 20),

                  // Father's Name Field
                  CustomTextFormField(
                    enabled: false,
                    labelText: "Father's Name",
                    keyboardType: TextInputType.text,
                    controller: _fatherNameController,
                  ),
                  const SizedBox(height: 20),

                  // Gender Field
                  CustomTextFormField(
                    enabled: false,
                    labelText: "Gender",
                    keyboardType: TextInputType.text,
                    controller: _genderController,
                  ),
                  const SizedBox(height: 20),

                  // Phone Number Field
                  CustomTextFormField(
                    enabled: false,
                    labelText: "Phone Number",
                    keyboardType: TextInputType.number,
                    controller: _phoneNumberController,
                  ),
                  const SizedBox(height: 20),

                  // Email Field
                  CustomTextFormField(
                    enabled: false,
                    labelText: "Email",
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                  ),
                  const SizedBox(height: 20),

                  // Education Status Field
                  CustomTextFormField(
                    enabled: false,
                    labelText: "Education Status",
                    keyboardType: TextInputType.text,
                    controller: _educationStatusController,
                  ),
                  const SizedBox(height: 20),

                  // Duration Field
                  CustomTextFormField(
                    enabled: false,
                    labelText: "Duration",
                    keyboardType: TextInputType.text,
                    controller: _durationController,
                  ),
                  const SizedBox(height: 20),
                  Obx(() => SelectionButton(
                        label: _Category.value == 'Fertilizer Dealer'
                            ? "Duration of Fertilizer sales"
                            : "Duration with REWARD",
                        options: _Category.value == 'Fertilizer Dealer'
                            ? const [
                                '< 2 Years',
                                '2-5 Years',
                                'above 5 Years',
                              ]
                            : const [
                                '< 6 Months',
                                '1 Year',
                                '1.5 Years',
                                '2 Years',
                                'Above 2 Years'
                              ],
                        selectedOption: _durationControllerupdate.value.isEmpty
                            ? null
                            : _durationControllerupdate.value,
                        onPressed: (option) {
                          _durationControllerupdate.value = option;

                          // Sync with _durationController
                          _durationController.text = option;
                        },
                        errorMessage: _durationControllerupdate.value.isEmpty
                            ? 'Please specify the duration'
                            : null,
                      )),
                  const SizedBox(height: 20),

                  // Place Field
                  CustomTextFormField(
                    enabled: false,
                    labelText: "Place",
                    keyboardType: TextInputType.text,
                    controller: _placeController,
                  ),
                  const SizedBox(height: 20),

                  // Watershed ID Field
                  CustomTextFormField(
                    enabled: false,
                    labelText: "Watershed ID",
                    keyboardType: TextInputType.number,
                    controller: _watershedIdController,
                  ),
                  const SizedBox(height: 20),

                  // Timestamp Field
                  CustomTextFormField(
                    enabled: false,
                    labelText: "Timestamp",
                    keyboardType: TextInputType.text,
                    controller: _timestampController,
                  ),
                  const SizedBox(height: 20),

                  // Image URL Field
                  CustomTextFormField(
                    enabled: false,
                    labelText: "Image URL",
                    keyboardType: TextInputType.text,
                    controller: _imageController,
                  ),
                  const SizedBox(height: 20),

                  // User Field
                  CustomTextFormField(
                    enabled: false,
                    labelText: "User",
                    keyboardType: TextInputType.text,
                    controller: _userController,
                  ),
                  const SizedBox(height: 30),

                  // Update Duration Button
                  CustomTextButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        String aadharNumber =
                            _aadharNumberController.text.trim();
                        if (_aadharNumberController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please enter Aadhaar Number"),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        if (_durationControllerupdate.value.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text("Please enter a new Duration value"),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        // Update duration in Firestore
                        await updateDealerDuration(
                          _aadharNumberController.text,
                          _durationControllerupdate.value,
                        );
                      }
                    },
                    text: "Update Duration",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
