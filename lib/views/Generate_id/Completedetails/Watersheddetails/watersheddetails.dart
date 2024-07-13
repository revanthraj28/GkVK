import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' show Obx, RxString, StringExtension;
import 'package:gkvk/database/database_service.dart';
import 'package:gkvk/database/gkvk_db.dart';
import 'package:gkvk/shared/components/CustomTextButton.dart';
import 'package:gkvk/shared/components/CustomTextFormField.dart';
import 'package:gkvk/shared/components/SelectionButton.dart';
import 'package:gkvk/views/Generate_id/Completedetails/GenerateFarmersid/GenerateFarmersId_view.dart';

class WatershedView extends StatelessWidget {
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _talukController = TextEditingController();
  final TextEditingController _hobliController = TextEditingController();
  final TextEditingController _subWatershedNameController =
      TextEditingController();
  final TextEditingController _subWatershedCodeController =
      TextEditingController();
  final TextEditingController _villageController = TextEditingController();
  final RxString _selectedCategory = ''.obs;
  final _formKey = GlobalKey<FormState>();

  WatershedView({super.key});

  Future<void> _uploadData(BuildContext context) async {
    final WaterShedDB db = WaterShedDB();

    try {
      int id = await db.create(
        district: _districtController.text,
        taluk: _talukController.text,
        hobli: _hobliController.text,
        subWatershedName: _subWatershedNameController.text,
        subWatershedCode: _subWatershedCodeController.text,
        village: _villageController.text,
        selectedCategory: _selectedCategory.value,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GenerateFarmersIdPage(waterShedId: id),
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

  Future<int?> _getLatestWaterShedId() async {
    final database = await DatabaseService().database;
    final List<Map<String, dynamic>> result = await database.query(
      'water_shed_table',
      orderBy: 'watershedId DESC',
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first['watershedId'] as int?;
    }
    return null;
  }

  void _navigateWithLatestWaterShedId(BuildContext context) async {
    final latestId = await _getLatestWaterShedId();
    if (kDebugMode) {
      // print('Data uploaded successfully with ID: $latestId');
    }
    if (latestId != null) {
      final database = await DatabaseService().database;
      final List<Map<String, dynamic>> result = await database.query(
        'water_shed_table',
        where: 'watershedId =?',
        whereArgs: [latestId],
      );

      if (result.isNotEmpty) {
        final watershedDetails = result.first;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              backgroundColor: const Color(0xFFFEF8E0),
              title: const Text(
                'Confirm',
                style: TextStyle(
                  color: Color(0xFFFB812C),
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                      'Do you want to continue with the latest watershed details?'),
                  const SizedBox(height: 20),
                  Text('District: ${watershedDetails['district']}'),
                  Text('Taluk: ${watershedDetails['taluk']}'),
                  Text('Hobli: ${watershedDetails['hobli']}'),
                  Text(
                      'Sub-Watershed Name: ${watershedDetails['subWatershedName']}'),
                  Text(
                      'Sub-Watershed Code: ${watershedDetails['subWatershedCode']}'),
                  Text('Village: ${watershedDetails['village']}'),
                  Text(
                      'Selected Category: ${watershedDetails['selectedCategory']}'),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: const Text(
                          'Continue',
                          style: TextStyle(
                            color: Color(0xFFFB812C),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  GenerateFarmersIdPage(waterShedId: latestId),
                            ),
                          );
                        },
                      ),
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
                    ],
                  ),
                ],
              ),
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              backgroundColor: const Color(0xFFFEF8E0),
              title: const Text(
                'ALERT',
                style: TextStyle(
                  color: Color(0xFFFB812C),
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: const Text(
                'No previous watershed data found.',
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
    } else {
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
              'No previous watershed data found.',
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
        )) ??
        false;
  }

  bool _validate() {
    if (!_formKey.currentState!.validate()) {
      return false;
    }
    if (_selectedCategory.value.isEmpty) {
      return false;
    }
    return true;
  }

  bool _validateLocationControllers(BuildContext context) {
    List<String> emptyFields = [];

    // Check if all location controllers have non-empty values
    if (_districtController.text.isEmpty) {
      emptyFields.add('District');
    }
    if (_talukController.text.isEmpty) {
      emptyFields.add('Taluk');
    }
    if (_hobliController.text.isEmpty) {
      emptyFields.add('Hobli');
    }
    if (_subWatershedNameController.text.isEmpty) {
      emptyFields.add('Sub-Watershed Name');
    }
    if (_subWatershedCodeController.text.isEmpty) {
      emptyFields.add('Sub-Watershed Code');
    }
    if (_villageController.text.isEmpty) {
      emptyFields.add('Village');
    }

    // Check if any field is empty, if yes, print and return false
    if (emptyFields.isNotEmpty) {
      // _showEmptyFieldsAlert(context, emptyFields);
      // print('Empty fields: $emptyFields');
      return false;
    }

    return true;
  }

  // void _showEmptyFieldsAlert(BuildContext context, List<String> emptyFields) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(15.0),
  //         ),
  //         backgroundColor: const Color(0xFFFEF8E0),
  //         title: const Text(
  //           'Alert',
  //           style: TextStyle(
  //             color: Color(0xFFFB812C),
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //         content: Text(
  //           'The following fields must be filled:\n${emptyFields.join('\n')}',
  //           style: const TextStyle(
  //             color: Colors.black,
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //             child: const Text(
  //               'OK',
  //               style: TextStyle(
  //                 color: Color(0xFFFB812C),
  //               ),
  //             ),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Dismiss keyboard on tap outside
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFEF8E0),
        appBar: AppBar(
          backgroundColor: const Color(0xFFFEF8E0),
          centerTitle: true,
          title: const Text(
            'WATER-SHED DETAILS',
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
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextFormField(
                            labelText: "District",
                            controller: _districtController,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please provide details';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: CustomTextFormField(
                            labelText: "Taluk",
                            controller: _talukController,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please provide details';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    CustomTextFormField(
                      labelText: "Hobli",
                      controller: _hobliController,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please provide details';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    CustomTextFormField(
                      labelText: "Sub-Watershed Name",
                      controller: _subWatershedNameController,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please provide details';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    CustomTextFormField(
                      labelText: "Sub-Watershed Code",
                      controller: _subWatershedCodeController,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please provide details';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    CustomTextFormField(
                      labelText: "Village",
                      controller: _villageController,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please provide details';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10.0),
                    Obx(() => SelectionButton(
                          label: "Treatment",
                          options: const ['T1', 'T2', 'T3', 'T4'],
                          selectedOption: _selectedCategory.value.isEmpty
                              ? null
                              : _selectedCategory.value,
                          onPressed: (option) {
                            _selectedCategory.value = option;
                          },
                          errorMessage: _selectedCategory.value.isEmpty
                              ? 'Please select Treatment option'
                              : null,
                        )),
                    const SizedBox(height: 110.0),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          height: 130,
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextButton(
                text: 'PREVIOUS WATERSHED',
                buttonColor: const Color(0xFFFB812C),
                onPressed: () {
                  _navigateWithLatestWaterShedId(context);
                },
              ),
              CustomTextButton(
                text: 'NEXT',
                buttonColor: const Color(0xFFFB812C),
                onPressed: () {
                  bool isFormValid = _validate();
                  bool areControllersValid = _validateLocationControllers(context);

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
    );
  }
}
