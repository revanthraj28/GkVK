import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gkvk/shared/components/CustomTextButton.dart';
import 'package:gkvk/shared/components/CustomTextFormField.dart';
import 'package:gkvk/shared/components/SelectionButton.dart';
import 'package:gkvk/database/farmer_profile_db.dart';
import 'package:gkvk/views/Generate_id/farmersarea/area.dart';
import '../../detailsofCrops/Cropdetails/Cropdetails.dart';

class GenerateFarmersIdPage extends StatelessWidget {
  final int waterShedId;
  final _formKey = GlobalKey<FormState>(); // Add form key for validation

  final TextEditingController _farmerNameController = TextEditingController();
  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _schoolingController = TextEditingController();
  final TextEditingController _aadharController = TextEditingController();
  final TextEditingController _fruitsIdController = TextEditingController();
  final TextEditingController _fertilizerAddressController = TextEditingController();

  final RxString _selectedGender = ''.obs;
  final RxString _selectedCategory = ''.obs;
  final RxString _selectedLandHolding = ''.obs;
  final RxString _selectedFertilizerSource = ''.obs;
  final RxString _selectedSalesOfProduce = ''.obs;
  final RxString _selectedLRIReceived = ''.obs;

  GenerateFarmersIdPage({required this.waterShedId, super.key});

  Future<void> _uploadData(BuildContext context) async {
    final FarmerProfileDB farmerProfileDB = FarmerProfileDB();
    try {
      await farmerProfileDB.create(
        farmerName: _farmerNameController.text,
        fatherName: _fatherNameController.text,
        pincode: int.parse(_pincodeController.text),
        schooling: int.parse(_schoolingController.text),
        gender: _selectedGender.value,
        category: _selectedCategory.value,
        landHolding: _selectedLandHolding.value,
        aadharNumber: int.parse(_aadharController.text),
        fruitsId: int.parse(_fruitsIdController.text),
        fertilizerSource: _selectedFertilizerSource.value,
        fertilizerAddress: _fertilizerAddressController.text,
        salesOfProduce: _selectedSalesOfProduce.value,
        lriReceived: _selectedLRIReceived.value,
        watershedId: waterShedId,
      );
      print('Data uploaded successfully');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FarmerAreaPage(),
          // Cropdetails(aadharId: int.parse(_aadharController.text))
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to upload data: $e'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _showExitConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Exit'),
          content: const Text('Do you want to return to the home page?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        );
      },
    );
  }

  bool _validateForm() {
    bool isValid = _formKey.currentState?.validate() ?? false;

    if (_selectedGender.value.isEmpty ||
        _selectedCategory.value.isEmpty ||
        _selectedLandHolding.value.isEmpty ||
        _selectedFertilizerSource.value.isEmpty ||
        _selectedSalesOfProduce.value.isEmpty ||
        _selectedLRIReceived.value.isEmpty) {
      isValid = false;
    }

    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Dismiss keyboard on tap outside
      },
      child: WillPopScope(
        onWillPop: () async {
          _showExitConfirmationDialog(context);
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFFFEF8E0),
            centerTitle: true,
            title: const Text(
              'ENTER FARMER DETAILS',
              style: TextStyle(
                color: Color(0xFFFB812C),
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            iconTheme: const IconThemeData(color: Color(0xFFFB812C)),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey, // Add form key
                child: Container(
                  color: const Color(0xFFFEF8E0),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      CustomTextFormField(
                        labelText: "Farmer's Name",
                        controller: _farmerNameController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter farmer's name";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      CustomTextFormField(
                        labelText: "Father's/Husband Name",
                        controller: _fatherNameController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter father's/husband name";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextFormField(
                              labelText: "Pincode",
                              controller: _pincodeController,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter pincode";
                                }
                                if (value.length != 6) {
                                  return "Pincode must be 6 digits";
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: CustomTextFormField(
                              labelText: "Year's of Schooling",
                              keyboardType: TextInputType.number,
                              controller: _schoolingController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter years of schooling";
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Obx(() => SelectionButton(
                        label: "Gender",
                        options: const ['Male', 'Female', 'Other'],
                        selectedOption: _selectedGender.value.isEmpty
                            ? null
                            : _selectedGender.value,
                        onPressed: (option) {
                          _selectedGender.value = option;
                        },
                        errorMessage: _selectedGender.value.isEmpty ? 'Please select gender' : null,
                      )),
                      const SizedBox(height: 10.0),
                      Obx(() => SelectionButton(
                        label: "Category",
                        options: const ['General', 'OBC', 'SC', 'ST'],
                        selectedOption: _selectedCategory.value.isEmpty
                            ? null
                            : _selectedCategory.value,
                        onPressed: (option) {
                          _selectedCategory.value = option;
                        },
                        errorMessage: _selectedCategory.value.isEmpty ? 'Please select category' : null,
                      )),
                      const SizedBox(height: 10.0),
                      Obx(() => SelectionButton(
                        label: "Land holding",
                        options: const ['Marginal', 'Small', 'Semi-Medium', 'Medium', 'Large'],
                        selectedOption: _selectedLandHolding.value.isEmpty
                            ? null
                            : _selectedLandHolding.value,
                        onPressed: (option) {
                          _selectedLandHolding.value = option;
                        },
                        errorMessage: _selectedLandHolding.value.isEmpty ? 'Please select land holding' : null,
                      )),
                      const SizedBox(height: 20.0),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextFormField(
                              labelText: "Aadhar Number",
                              controller: _aadharController,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter Aadhar number";
                                }
                                if (value.length != 12) {
                                  return "Aadhar number must be 12 digits";
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: CustomTextFormField(
                              labelText: "Fruits ID Number",
                              controller: _fruitsIdController,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter Fruits ID number";
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Obx(() => SelectionButton(
                        label: "Source of Purchase of Fertilizers",
                        options: const ['Dealers', 'Society', 'FPO', 'Others'],
                        selectedOption: _selectedFertilizerSource.value.isEmpty
                            ? null
                            : _selectedFertilizerSource.value,
                        onPressed: (option) {
                          _selectedFertilizerSource.value = option;
                        },
                        errorMessage: _selectedFertilizerSource.value.isEmpty ? 'Please select source' : null,
                      )),
                      const SizedBox(height: 20.0),
                      CustomTextFormField(
                        labelText: "Address of dealers, society, FPO or others",
                        controller: _fertilizerAddressController,
                        keyboardType: TextInputType.streetAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter address";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10.0),
                      Obx(() => SelectionButton(
                        label: "Sales of produce holding",
                        options: const ['Mandi', 'Village', 'Other'],
                        selectedOption: _selectedSalesOfProduce.value.isEmpty
                            ? null
                            : _selectedSalesOfProduce.value,
                        onPressed: (option) {
                          _selectedSalesOfProduce.value = option;
                        },
                        errorMessage: _selectedSalesOfProduce.value.isEmpty ? 'Please select sales option' : null,
                      )),
                      const SizedBox(height: 10.0),
                      Obx(() => SelectionButton(
                        label: "LRI received or not?",
                        options: const ['YES', 'NO'],
                        selectedOption: _selectedLRIReceived.value.isEmpty
                            ? null
                            : _selectedLRIReceived.value,
                        onPressed: (option) {
                          _selectedLRIReceived.value = option;
                        },
                        errorMessage: _selectedLRIReceived.value.isEmpty ? 'Please select LRI option' : null,
                      )),
                      const SizedBox(height: 30.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            height: 75,
            color: Color(0xFFFEF8E0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextButton(
                  text: 'NEXT',
                  buttonColor: Color(0xFFFB812C),
                  onPressed: () {
                    if (_validateForm()) {
                      try {
                        _uploadData(context);
                      } catch (e) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Error'),
                              content: const Text('Failed to upload data. Please check your input and try again.'),
                              actions: [
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Alert!'),
                            content: const Text('Fill the fields properly'),
                            actions: [
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
