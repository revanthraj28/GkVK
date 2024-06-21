import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gkvk/shared/components/CustomTextButton.dart';
import 'package:gkvk/shared/components/CustomTextFormField.dart';
import 'package:gkvk/shared/components/SelectionButton.dart';
import 'package:gkvk/database/farmer_profile_db.dart';
import 'package:gkvk/views/Generate_id/farmersarea/area.dart';

class GenerateFarmersIdPage extends StatelessWidget {
  final int waterShedId;
// Add form key for validation

  final TextEditingController _farmerNameController = TextEditingController();
  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _schoolingController = TextEditingController();
  final TextEditingController _aadharController = TextEditingController();
  final TextEditingController _fruitsIdController = TextEditingController();
  final TextEditingController _fertilizerAddressController =
      TextEditingController();
  final TextEditingController _farmerlandController = TextEditingController();
  final RxString _selectedGender = ''.obs;
  final RxString _selectedCategory = ''.obs;
  final RxString _selectedLandHolding = ''.obs;
  final RxString _selectedFertilizerSource = ''.obs;
  final RxString _selectedSalesOfProduce = ''.obs;
  final RxString _selectedLRIReceived = ''.obs;
  final _formKey = GlobalKey<FormState>();

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
        fruitsId: _fruitsIdController.text,
        totalland:int.parse(_farmerlandController.text),
        fertilizerSource: _selectedFertilizerSource.value,
        fertilizerAddress: _fertilizerAddressController.text,
        salesOfProduce: _selectedSalesOfProduce.value,
        lriReceived: _selectedLRIReceived.value,
        watershedId: waterShedId,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FarmerAreaPage(
            aadharId: int.parse(_aadharController.text),
          ),
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to upload data'),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          backgroundColor: const Color(0xFFFEF8E0),
          title: const Text(
            'Exit',
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
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Color(0xFFFB812C),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Color(0xFFFB812C),
                ),
              ),
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        );
      },
    );
  }

  bool _validateform() {
    if (!_formKey.currentState!.validate()) {
      return false;
    }
    if (_selectedGender.value.isEmpty ||
        _selectedCategory.value.isEmpty ||
        _selectedLandHolding.value.isEmpty ||
        _selectedFertilizerSource.value.isEmpty ||
        _selectedSalesOfProduce.value.isEmpty ||
        _selectedLRIReceived.value.isEmpty) {
      return false;
    }
    return true;
  }

  bool _validateFarmerControllers(BuildContext context) {
    List<String> emptyFields = [];

    // Check if all farmer-related controllers have non-empty values
    if (_farmerNameController.text.isEmpty) {
      emptyFields.add('Farmer Name');
    }
    if (_fatherNameController.text.isEmpty) {
      emptyFields.add('Father Name');
    }
    if (_aadharController.text.isEmpty) {
      emptyFields.add('Aadhar');
    }
    if (_schoolingController.text.isEmpty) {
      emptyFields.add('Schooling');
    }
    if (_pincodeController.text.isEmpty) {
      emptyFields.add('Pincode');
    }
    if (_fruitsIdController.text.isEmpty) {
      emptyFields.add('Fruits ID');
    }
    if (_farmerlandController.text.isEmpty) {
      emptyFields.add('land holding');
    }
    if (_fertilizerAddressController.text.isEmpty) {
      emptyFields.add('Fertilizer Address');
    }

    // Check if any field is empty, if yes, show alert and return false
    if (emptyFields.isNotEmpty) {
      _showEmptyFieldsAlert(context, emptyFields);
      // print('Empty fields: $emptyFields');
      return false;
    }

    return true;
  }

  void _showEmptyFieldsAlert(BuildContext context, List<String> emptyFields) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          backgroundColor: const Color(0xFFFEF8E0),
          title: const Text(
            'Alert',
            style: TextStyle(
              color: Color(0xFFFB812C),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'The following fields must be filled:\n${emptyFields.join('\n')}',
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
          actions: [
            TextButton(
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Color(0xFFFB812C),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
            backgroundColor: const Color(0xFFFEF8E0),
            centerTitle: true,
            title: const Text(
              'ENTER FARMER DETAILS',
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
                            return "Please provide details";
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
                            return "Please provide details";
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
                                  return "Please provide details";
                                }
                                if (value.length != 6) {
                                  return "6 digits only";
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: CustomTextFormField(
                              labelText: "Schooling year's",
                              keyboardType: TextInputType.number,
                              controller: _schoolingController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please provide details";
                                }
                                int? yearsOfSchooling = int.tryParse(value);
                                if (yearsOfSchooling == null ||
                                    yearsOfSchooling > 20) {
                                  return "Less than 20 Only";
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
                            errorMessage: _selectedGender.value.isEmpty
                                ? 'Please select gender'
                                : null,
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
                            errorMessage: _selectedCategory.value.isEmpty
                                ? 'Please select category'
                                : null,
                          )),
                      const SizedBox(height: 10.0),
                      Obx(() => SelectionButton(
                            label: "Land holding",
                            options: const [
                              'Marginal',
                              'Small',
                              'Semi-Medium',
                              'Medium',
                              'Large'
                            ],
                            selectedOption: _selectedLandHolding.value.isEmpty
                                ? null
                                : _selectedLandHolding.value,
                            onPressed: (option) {
                              _selectedLandHolding.value = option;
                            },
                            errorMessage: _selectedLandHolding.value.isEmpty
                                ? 'Please select land holding'
                                : null,
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
                                  return "Please provide details";
                                }
                                if (value.length != 12) {
                                  return "12 digits only";
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
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please provide details";
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      CustomTextFormField(
                        labelText: "Total land in Guntas(1 acres is 40 Guntas)",
                        controller: _farmerlandController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please provide details";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10.0),
                      Obx(() => SelectionButton(
                            label: "Source of Purchase of Fertilizers",
                            options: const [
                              'Dealers',
                              'Society',
                              'FPO',
                              'Others'
                            ],
                            selectedOption:
                                _selectedFertilizerSource.value.isEmpty
                                    ? null
                                    : _selectedFertilizerSource.value,
                            onPressed: (option) {
                              _selectedFertilizerSource.value = option;
                            },
                            errorMessage:
                                _selectedFertilizerSource.value.isEmpty
                                    ? 'Please select source'
                                    : null,
                          )),
                      const SizedBox(height: 20.0),
                      CustomTextFormField(
                        labelText: "Address of dealers, society, FPO or others",
                        controller: _fertilizerAddressController,
                        keyboardType: TextInputType.streetAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please provide details";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10.0),
                      Obx(() => SelectionButton(
                            label: "Sales of produce holding",
                            options: const ['Mandi', 'Village', 'Other'],
                            selectedOption:
                                _selectedSalesOfProduce.value.isEmpty
                                    ? null
                                    : _selectedSalesOfProduce.value,
                            onPressed: (option) {
                              _selectedSalesOfProduce.value = option;
                            },
                            errorMessage: _selectedSalesOfProduce.value.isEmpty
                                ? 'Please select sales option'
                                : null,
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
                            errorMessage: _selectedLRIReceived.value.isEmpty
                                ? 'Please select LRI option'
                                : null,
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
            color: const Color(0xFFFEF8E0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextButton(
                  text: 'NEXT',
                  buttonColor: const Color(0xFFFB812C),
                  onPressed: () {
                    bool isFormValid = _validateform();
                    bool areControllersValid =
                        _validateFarmerControllers(context);

                    // print(
                    //     'Form valid: $isFormValid, Controllers valid: $areControllersValid');

                    if (isFormValid && areControllersValid) {
                      try {
                        _uploadData(context);
                      } catch (e) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              backgroundColor: const Color(0xFFFEF8E0),
                              title: const Text(
                                'Error',
                                style: TextStyle(
                                  color: Color(0xFFFB812C),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: const Text(
                                'Failed to upload data. Please check your input and try again.',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: const Text(
                                    'OK',
                                    style: TextStyle(
                                      color: Color(0xFFFB812C),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    } else if (!areControllersValid) {
                      // The alert for invalid controllers will already have been shown, so do nothing here
                    } else {
                      // If form is invalid, show a generic alert
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            backgroundColor: const Color(0xFFFEF8E0),
                            title: const Text(
                              'Alert',
                              style: TextStyle(
                                color: Color(0xFFFB812C),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            content: const Text(
                              'All the details must be filled.',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            actions: [
                              TextButton(
                                child: const Text(
                                  'OK',
                                  style: TextStyle(
                                    color: Color(0xFFFB812C),
                                  ),
                                ),
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
