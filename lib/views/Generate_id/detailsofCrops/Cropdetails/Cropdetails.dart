// ignore: file_names
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gkvk/shared/components/CustomTextButton.dart';
import 'package:gkvk/shared/components/CustomTextFormField.dart';
import 'package:gkvk/shared/components/SelectionButton.dart';
import 'package:gkvk/database/cropdetails_db.dart';
import 'package:gkvk/views/Generate_id/farmersarea/area.dart';

class Cropdetails extends StatefulWidget {
  final int aadharId;
  final int hissaNumber;

  const Cropdetails(
      {required this.aadharId, required this.hissaNumber, super.key});

  @override
  _CropdetailsState createState() => _CropdetailsState();
}

class _CropdetailsState extends State<Cropdetails> {
  final _formKey = GlobalKey<FormState>();
  final _cropNameController = TextEditingController();
  final _cropNumberController = TextEditingController();
  final _areaController = TextEditingController();
  final _surveyHissaController = TextEditingController();
  final _varietyController = TextEditingController();
  final _durationController = TextEditingController();
  final _costController = TextEditingController();
  final _rdfNitrogenController = TextEditingController();
  final _rdfPhosphorousController = TextEditingController();
  final _rdfPotassiumController = TextEditingController();
  final _adjustedrdfNitrogenController = TextEditingController();
  final _adjustedrdfPhosphorousController = TextEditingController();
  final _adjustedrdfPotassiumController = TextEditingController();

  final _organicManureNameController = TextEditingController();
  final _organicManureQuantityController = TextEditingController();
  final _organicManureCostController = TextEditingController();

  final _bioFertilizerNameController = TextEditingController();
  final _bioFertilizerQuantityController = TextEditingController();
  final _bioFertilizerCostController = TextEditingController();

  final TextEditingController _plantProtectionCostController =
      TextEditingController();
  final TextEditingController _ownLabourNumberController =
      TextEditingController();
  final TextEditingController _ownLabourCostController =
      TextEditingController();
  final TextEditingController _hiredLabourNumberController =
      TextEditingController();
  final TextEditingController _hiredLabourCostController =
      TextEditingController();
  final TextEditingController _animalDrawnCostController =
      TextEditingController();
  final TextEditingController _animalMechanizedCostController =
      TextEditingController();
  final TextEditingController _irrigationCostController =
      TextEditingController();
  final TextEditingController _otherProductionCostController =
      TextEditingController();
  final TextEditingController _totalProductionCostController =
      TextEditingController();

  final TextEditingController _mainProductQuantityController =
      TextEditingController();
  final TextEditingController _mainProductPriceController =
      TextEditingController();
  final TextEditingController _mainProductAmountController =
      TextEditingController();
  final TextEditingController _byProductQuantityController =
      TextEditingController();
  final TextEditingController _byProductPriceController =
      TextEditingController();
  final TextEditingController _byProductAmountController =
      TextEditingController();
  final TextEditingController _totalByProductAmountController1 =
      TextEditingController();
  final TextEditingController _totalByProductAmountController2 =
      TextEditingController();
  final TextEditingController _totalByProductAmountController3 =
      TextEditingController();

  final RxString _selectedTypeOfLand = ''.obs;
  final RxString _selectedSeason = ''.obs;
  final RxString _selectedSourceOfIrrigation = ''.obs;
  final RxString _selectedNitrogen = ''.obs;
  final RxString _selectedPhosphorous = ''.obs;
  final RxString _selectedPotassium = ''.obs;
  final RxString _Methodsoffertilizer = ''.obs;

  final List<Map<String, TextEditingController>> chemicalFertilizers = [];
  int fertilizerCount = 0;

  @override
  void initState() {
    super.initState();
    addNewFertilizer();
  }

  void addNewFertilizer() {
    setState(() {
      fertilizerCount++;
      TextEditingController indexController = TextEditingController();
      indexController.text = fertilizerCount.toString(); // Set the text value
      chemicalFertilizers.add({
        "index": indexController, // Use TextEditingController for index
        "name": TextEditingController(),
        "basal": TextEditingController(),
        "topDress": TextEditingController(),
        "totalQuantity": TextEditingController(),
        "totalCost": TextEditingController(),
      });
    });
  }

  void calculateTotal() {
    double total = 0.0;
    total += double.tryParse(_costController.text) ?? 0.0;
    total += double.tryParse(_organicManureCostController.text) ?? 0.0;
    total += double.tryParse(_bioFertilizerCostController.text) ?? 0.0;
    total += double.tryParse(_plantProtectionCostController.text) ?? 0.0;
    total += double.tryParse(_ownLabourCostController.text) ?? 0.0;
    total += double.tryParse(_hiredLabourCostController.text) ?? 0.0;
    total += double.tryParse(_animalDrawnCostController.text) ?? 0.0;
    total += double.tryParse(_animalMechanizedCostController.text) ?? 0.0;
    total += double.tryParse(_irrigationCostController.text) ?? 0.0;
    total += double.tryParse(_otherProductionCostController.text) ?? 0.0;

    for (var fertilizer in chemicalFertilizers) {
      total += double.tryParse(fertilizer['totalCost']!.text) ?? 0.0;
    }

    // Update the total production cost controller
    _totalProductionCostController.text = total.toStringAsFixed(2);
  }

  Future<void> _submitData(BuildContext context) async {
    final cropDetailsDB = CropdetailsDB();

    Map<String, dynamic> data = {
      'aadharId': widget.aadharId,
      'cropName': _cropNameController.text,
      'cropNumber': int.tryParse(_cropNumberController.text),
      'area': double.tryParse(_areaController.text),
      'surveyHissa': widget.hissaNumber,
      'variety': _varietyController.text,
      'duration': int.tryParse(_durationController.text),
      'season': _selectedSeason.value,
      'typeOfLand': _selectedTypeOfLand.value,
      'sourceOfIrrigation': _selectedSourceOfIrrigation.value,
      'cost': int.tryParse(_costController.text),
      'nitrogen': _selectedNitrogen.value,
      'phosphorous': _selectedPhosphorous.value,
      'potassium': _selectedPotassium.value,
      'rdfNitrogen': _rdfNitrogenController.text,
      'rdfPhosphorous': _rdfPhosphorousController.text,
      'rdfPotassium': _rdfPotassiumController.text,
      'adjustedrdfNitrogen': _adjustedrdfNitrogenController.text,
      'adjustedrdfPhosphorous': _adjustedrdfPhosphorousController.text,
      'adjustedrdfPotassium': _adjustedrdfPotassiumController.text,
      'organicManureName': _organicManureNameController.text,
      'organicManureQuantity':
          double.tryParse(_organicManureQuantityController.text),
      'organicManureCost': double.tryParse(_organicManureCostController.text),
      'bioFertilizerName': _bioFertilizerNameController.text,
      'bioFertilizerQuantity':
          double.tryParse(_bioFertilizerQuantityController.text),
      'bioFertilizerCost': double.tryParse(_bioFertilizerCostController.text),
      'plantProtectionCost':
          double.tryParse(_plantProtectionCostController.text),
      'ownLabourNumber': int.tryParse(_ownLabourNumberController.text),
      'ownLabourCost': double.tryParse(_ownLabourCostController.text),
      'hiredLabourNumber': int.tryParse(_hiredLabourNumberController.text),
      'hiredLabourCost': double.tryParse(_hiredLabourCostController.text),
      'animalDrawnCost': double.tryParse(_animalDrawnCostController.text),
      'animalMechanizedCost':
          double.tryParse(_animalMechanizedCostController.text),
      'irrigationCost': double.tryParse(_irrigationCostController.text),
      'otherProductionCost':
          double.tryParse(_otherProductionCostController.text),
      'totalProductionCost':
          double.tryParse(_totalProductionCostController.text),
      'mainProductQuantity':
          double.tryParse(_mainProductQuantityController.text),
      'mainProductPrice': double.tryParse(_mainProductPriceController.text),
      'mainProductAmount': double.tryParse(_mainProductAmountController.text),
      'byProductQuantity': double.tryParse(_byProductQuantityController.text),
      'byProductPrice': double.tryParse(_byProductPriceController.text),
      'byProductAmount': double.tryParse(_byProductAmountController.text),
      'totalByProductAmount1':
          double.tryParse(_totalByProductAmountController1.text),
      'totalByProductAmount2':
          double.tryParse(_totalByProductAmountController2.text),
      'totalByProductAmount3':
          double.tryParse(_totalByProductAmountController3.text),
      'methodsoffertilizer': _Methodsoffertilizer.value,
    };

    // Add chemical fertilizers details
    for (var i = 0; i < chemicalFertilizers.length; i++) {
      data['chemicalFertilizerName$i'] = chemicalFertilizers[i]['name']!.text;
      data['chemicalFertilizerBasal$i'] = chemicalFertilizers[i]['basal']!.text;
      data['chemicalFertilizerTopDress$i'] =
          chemicalFertilizers[i]['topDress']!.text;
      data['chemicalFertilizerTotalQuantity$i'] =
          double.tryParse(chemicalFertilizers[i]['totalQuantity']!.text);
      data['chemicalFertilizerTotalCost$i'] =
          double.tryParse(chemicalFertilizers[i]['totalCost']!.text);
    }

    await cropDetailsDB.create(data);

    if (kDebugMode) {
      print('Data submitted successfully');
    }
    Navigator.pop(
      context,
      MaterialPageRoute(
        builder: (context) => FarmerAreaPage(aadharId: widget.aadharId),
      ),
    );
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

  void _handleTypeOfLandSelection(String option) {
    _selectedTypeOfLand.value = option;
    if (option == 'Rain-fed') {
      _selectedSourceOfIrrigation.value = 'None';
    }
  }

  bool _validateForm() {
    // Check if the form fields are valid
    if (!_formKey.currentState!.validate()) {
      return false;
    }

    // Check if dropdowns are selected
    if (_selectedSeason.value.isEmpty ||
        _selectedTypeOfLand.value.isEmpty ||
        _selectedSourceOfIrrigation.value.isEmpty ||
        _selectedNitrogen.value.isEmpty ||
        _selectedPhosphorous.value.isEmpty ||
        _selectedPotassium.value.isEmpty ||
        _Methodsoffertilizer.value.isEmpty) {
      return false;
    }

    // Check if chemical fertilizers fields are filled
    for (var fertilizer in chemicalFertilizers) {
      if (fertilizer['name']!.text.isEmpty ||
          fertilizer['basal']!.text.isEmpty ||
          fertilizer['topDress']!.text.isEmpty ||
          fertilizer['totalQuantity']!.text.isEmpty ||
          fertilizer['totalCost']!.text.isEmpty) {
        return false;
      }
    }

    return true;
  }

  bool _validatecontrollers() {
    List<String> emptyFields = [];

    // Check if all text controllers have non-empty values
    if (_cropNameController.text.isEmpty) {
      emptyFields.add('Crop Name');
    }
    if (_areaController.text.isEmpty) {
      emptyFields.add('Area');
    }
    if (_surveyHissaController.text.isEmpty) {
      emptyFields.add('Survey Hissa');
    }
    if (_varietyController.text.isEmpty) {
      emptyFields.add('Variety');
    }
    if (_durationController.text.isEmpty) {
      emptyFields.add('Duration');
    }
    if (_costController.text.isEmpty) {
      emptyFields.add('Cost');
    }
    if (_rdfNitrogenController.text.isEmpty) {
      emptyFields.add('RDF Nitrogen');
    }
    if (_rdfPhosphorousController.text.isEmpty) {
      emptyFields.add('RDF Phosphorous');
    }
    if (_rdfPotassiumController.text.isEmpty) {
      emptyFields.add('RDF Potassium');
    }
    if (_adjustedrdfNitrogenController.text.isEmpty) {
      emptyFields.add('Adjusted RDF Nitrogen');
    }
    if (_adjustedrdfPhosphorousController.text.isEmpty) {
      emptyFields.add('Adjusted RDF Phosphorous');
    }
    if (_adjustedrdfPotassiumController.text.isEmpty) {
      emptyFields.add('Adjusted RDF Potassium');
    }
    if (_organicManureNameController.text.isEmpty) {
      emptyFields.add('Organic Manure Name');
    }
    if (_organicManureQuantityController.text.isEmpty) {
      emptyFields.add('Organic Manure Quantity');
    }
    if (_organicManureCostController.text.isEmpty) {
      emptyFields.add('Organic Manure Cost');
    }
    if (_bioFertilizerNameController.text.isEmpty) {
      emptyFields.add('Bio-Fertilizer Name');
    }
    if (_bioFertilizerQuantityController.text.isEmpty) {
      emptyFields.add('Bio-Fertilizer Quantity');
    }
    if (_bioFertilizerCostController.text.isEmpty) {
      emptyFields.add('Bio-Fertilizer Cost');
    }
    if (_plantProtectionCostController.text.isEmpty) {
      emptyFields.add('Plant Protection Cost');
    }
    if (_ownLabourNumberController.text.isEmpty) {
      emptyFields.add('Own Labour Number');
    }
    if (_ownLabourCostController.text.isEmpty) {
      emptyFields.add('Own Labour Cost');
    }
    if (_hiredLabourNumberController.text.isEmpty) {
      emptyFields.add('Hired Labour Number');
    }
    if (_hiredLabourCostController.text.isEmpty) {
      emptyFields.add('Hired Labour Cost');
    }
    if (_animalDrawnCostController.text.isEmpty) {
      emptyFields.add('Animal Drawn Cost');
    }
    if (_animalMechanizedCostController.text.isEmpty) {
      emptyFields.add('Animal Mechanized Cost');
    }
    if (_irrigationCostController.text.isEmpty) {
      emptyFields.add('Irrigation Cost');
    }
    if (_otherProductionCostController.text.isEmpty) {
      emptyFields.add('Other Production Cost');
    }
    if (_totalProductionCostController.text.isEmpty) {
      emptyFields.add('Total Production Cost');
    }
    if (_mainProductQuantityController.text.isEmpty) {
      emptyFields.add('Main Product Quantity');
    }
    if (_mainProductPriceController.text.isEmpty) {
      emptyFields.add('Main Product Price');
    }
    if (_mainProductAmountController.text.isEmpty) {
      emptyFields.add('Main Product Amount');
    }
    if (_byProductQuantityController.text.isEmpty) {
      emptyFields.add('By-Product Quantity');
    }
    if (_byProductPriceController.text.isEmpty) {
      emptyFields.add('By-Product Price');
    }
    if (_byProductAmountController.text.isEmpty) {
      emptyFields.add('By-Product Amount');
    }
    if (_totalByProductAmountController1.text.isEmpty) {
      emptyFields.add('Total By-Product Amount 1');
    }
    if (_totalByProductAmountController2.text.isEmpty) {
      emptyFields.add('Total By-Product Amount 2');
    }

    // Check if any field is empty, if yes, print and return false
    if (emptyFields.isNotEmpty) {
      _showEmptyFieldsAlert(context, emptyFields);
      print('Empty fields: $emptyFields');
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
        FocusScope.of(context).unfocus();
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
              'Enter the Crop details',
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
                key: _formKey,
                child: Container(
                  color: const Color(0xFFFEF8E0),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomTextFormField(
                        labelText: "Crop Name",
                        controller: _cropNameController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter Crop Name";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      CustomTextFormField(
                        labelText: "Crop Number",
                        controller: _cropNumberController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter Crop Name";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      CustomTextFormField(
                        labelText: "Area in acres",
                        controller: _areaController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter Area";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      CustomTextFormField(
                        labelText: "Survey and Hissa no.",
                        controller: _surveyHissaController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter Survey and Hissa no";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      CustomTextFormField(
                        labelText: "Variety of crop",
                        controller: _varietyController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter Variety of crop";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      CustomTextFormField(
                        labelText: "Duration (in days)",
                        controller: _durationController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter Duration";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      Obx(() => SelectionButton(
                            label: "Season",
                            options: const ['Kharif', 'Rabi', 'Summer'],
                            selectedOption: _selectedSeason.value.isEmpty
                                ? null
                                : _selectedSeason.value,
                            onPressed: (option) {
                              _selectedSeason.value = option;
                            },
                            errorMessage: _selectedSeason.value.isEmpty
                                ? 'Please select a season'
                                : null,
                          )),
                      const SizedBox(height: 20.0),
                      Obx(() => SelectionButton(
                            label: "Type of land",
                            options: const ['Rain-fed', 'Irrigated'],
                            selectedOption: _selectedTypeOfLand.value.isEmpty
                                ? null
                                : _selectedTypeOfLand.value,
                            onPressed: (option) {
                              _handleTypeOfLandSelection(option);
                            },
                            errorMessage: _selectedTypeOfLand.value.isEmpty
                                ? 'Please select a type of land'
                                : null,
                          )),
                      const SizedBox(height: 20.0),
                      Obx(() => SelectionButton(
                            label: "Source of irrigation",
                            options: _selectedTypeOfLand.value == 'Rain-fed'
                                ? const ['None']
                                : const ['Borewell', 'Tank', 'Canal', 'Others'],
                            selectedOption:
                                _selectedSourceOfIrrigation.value.isEmpty
                                    ? null
                                    : _selectedSourceOfIrrigation.value,
                            onPressed: (option) {
                              _selectedSourceOfIrrigation.value = option;
                            },
                            errorMessage:
                                _selectedSourceOfIrrigation.value.isEmpty
                                    ? 'Please select a source of irrigation'
                                    : null,
                          )),
                      const SizedBox(height: 20.0),
                      CustomTextFormField(
                        labelText: "Cost of seed (including own seed)(in Rs.)",
                        controller: _costController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter Cost of seed";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      const Text(
                        'Fertility status according to LRI card',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20.0),
                      Obx(() => SelectionButton(
                            label: 'Nitrogen',
                            options: const [
                              'Very low',
                              'Low',
                              'Medium',
                              'High',
                              'Very high'
                            ],
                            selectedOption: _selectedNitrogen.value.isEmpty
                                ? null
                                : _selectedNitrogen.value,
                            onPressed: (option) {
                              _selectedNitrogen.value = option;
                            },
                            errorMessage: _selectedNitrogen.value.isEmpty
                                ? 'Please select a nitrogen level'
                                : null,
                          )),
                      const SizedBox(height: 20.0),
                      Obx(() => SelectionButton(
                            label: 'Phosphorous',
                            options: const [
                              'Very low',
                              'Low',
                              'Medium',
                              'High',
                              'Very high'
                            ],
                            selectedOption: _selectedPhosphorous.value.isEmpty
                                ? null
                                : _selectedPhosphorous.value,
                            onPressed: (option) {
                              _selectedPhosphorous.value = option;
                            },
                            errorMessage: _selectedPhosphorous.value.isEmpty
                                ? 'Please select a phosphorous level'
                                : null,
                          )),
                      const SizedBox(height: 20.0),
                      Obx(() => SelectionButton(
                            label: 'Potassium',
                            options: const [
                              'Very low',
                              'Low',
                              'Medium',
                              'High',
                              'Very high'
                            ],
                            selectedOption: _selectedPotassium.value.isEmpty
                                ? null
                                : _selectedPotassium.value,
                            onPressed: (option) {
                              _selectedPotassium.value = option;
                            },
                            errorMessage: _selectedPotassium.value.isEmpty
                                ? 'Please select a potassium level'
                                : null,
                          )),
                      const SizedBox(height: 20.0),
                      const Text(
                        'RDF of crop (kg/ac)',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20.0),
                      CustomTextFormField(
                        labelText: "Nitrogen",
                        controller: _rdfNitrogenController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter Nitrogen";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      CustomTextFormField(
                        labelText: "Phosphorous",
                        controller: _rdfPhosphorousController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter Phosphorous";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      CustomTextFormField(
                        labelText: "Potassium",
                        controller: _rdfPotassiumController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter Potassium";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      const Text(
                        'Adjusted RDF of crop (kg/ac)',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20.0),
                      CustomTextFormField(
                        labelText: "Nitrogen",
                        controller: _adjustedrdfNitrogenController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter Nitrogen";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      CustomTextFormField(
                        labelText: "Phosphorous",
                        controller: _adjustedrdfPhosphorousController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter Phosphorous";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      CustomTextFormField(
                        labelText: "Potassium",
                        controller: _adjustedrdfPotassiumController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter Potassium";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      const Text(
                        'Manures and fertilizers',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20.0),
                      const Text(
                        'Organic manures',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFFB812C)),
                      ),
                      const SizedBox(height: 20.0),
                      CustomTextFormField(
                        labelText: "Name",
                        controller: _organicManureNameController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter Name";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      CustomTextFormField(
                        labelText: "Quantity (in tonnes)",
                        controller: _organicManureQuantityController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter Quantity";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      CustomTextFormField(
                        labelText: "Cost (in Rs.)",
                        controller: _organicManureCostController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter Cost";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      const Text(
                        'Bio-fertilizers',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFB812C)),
                      ),
                      const SizedBox(height: 20.0),
                      CustomTextFormField(
                        labelText: "Name",
                        controller: _bioFertilizerNameController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter Name";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      CustomTextFormField(
                        labelText: "Quantity (in kgs)",
                        controller: _bioFertilizerQuantityController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter Quantity";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      CustomTextFormField(
                        labelText: "Cost (in Rs.)",
                        controller: _bioFertilizerCostController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter Cost";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      const Text(
                        'Chemical fertilizers',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      ...chemicalFertilizers.asMap().entries.map((entry) {
                        int index = entry.key + 1; // Index starts from 1
                        Map<String, TextEditingController> fertilizer =
                            entry.value;
                        return Column(
                          children: [
                            Text(
                              'Fertilizer $index', // Displaying the index
                              style: const TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            CustomTextFormField(
                              labelText: "Name",
                              controller: fertilizer['name']!,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter Name";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20.0),
                            CustomTextFormField(
                              labelText: "Basal dose (in kgs)",
                              controller: fertilizer['basal']!,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter Basal dose";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20.0),
                            CustomTextFormField(
                              labelText: "Top dress (in kgs)",
                              controller: fertilizer['topDress']!,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter Top dress";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20.0),
                            CustomTextFormField(
                              labelText: "Total quantity (in kgs)",
                              controller: fertilizer['totalQuantity']!,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter Total quantity";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20.0),
                            CustomTextFormField(
                              labelText: "Total cost (in Rs.)",
                              controller: fertilizer['totalCost']!,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter Total cost";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20.0),
                          ],
                        );
                      }),
                      CustomTextButton(
                        text: "Add new fertilizer",
                        buttonColor: Colors.black,
                        onPressed: addNewFertilizer,
                      ),
                      const SizedBox(height: 20.0),
                      const Text(
                        'Method of application of fertilizers',
                        style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.w500),
                      ),
                      Obx(() => SelectionButton(
                            label: '',
                            options: const [
                              'Broadcasting',
                              'line',
                              'band',
                              'spot'
                            ],
                            selectedOption: _Methodsoffertilizer.value.isEmpty
                                ? null
                                : _Methodsoffertilizer.value,
                            onPressed: (option) {
                              _Methodsoffertilizer.value = option;
                            },
                            errorMessage: _Methodsoffertilizer.value.isEmpty
                                ? 'Please select a method of application'
                                : null,
                          )),
                      const SizedBox(height: 20.0),
                      CustomTextFormField(
                        labelText: "Plant Protection Cost (in Rs.)",
                        controller: _plantProtectionCostController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter Plant Protection Cost";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      const Text(
                        'Labour Details',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w500),
                      ),
                      CustomTextFormField(
                        labelText: "Own Labour(number)",
                        controller: _ownLabourNumberController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter Own Labour";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      CustomTextFormField(
                        labelText: "Cost (in Rs.)",
                        controller: _ownLabourCostController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter Cost";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      CustomTextFormField(
                        labelText: "Hired Labour(number)",
                        controller: _hiredLabourNumberController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter Hired Labour(number)";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      CustomTextFormField(
                        labelText: "Cost (in Rs.)",
                        controller: _hiredLabourCostController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter Cost";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      CustomTextFormField(
                        labelText: "Cost of animal drawn work (Rs.)",
                        controller: _animalDrawnCostController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter Cost of animal drawn work";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      CustomTextFormField(
                        labelText: "Cost of mechanized works (Rs.)",
                        controller: _animalMechanizedCostController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter mechanized works ";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      CustomTextFormField(
                        labelText: "Irrigation cost (in Rs.)",
                        controller: _irrigationCostController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter Irrigation cost";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      CustomTextFormField(
                        labelText: "Other production cost, if any (Rs.)",
                        controller: _otherProductionCostController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter Other production cost";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      CustomTextButton(
                          text: "TOTAL", buttonColor: Colors.black, onPressed: calculateTotal),
                      const SizedBox(height: 20.0),
                      CustomTextFormField(
                        labelText: "Total cost of production",
                        controller: _totalProductionCostController,
                        keyboardType: TextInputType.number,
                        enabled: false, // Make it non-editable
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter Total cost of production";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      const Text(
                        'Returns',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 20.0),
                      CustomTextFormField(
                        labelText: "Quantity of main product",
                        controller: _mainProductQuantityController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter Quantity of main product";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      CustomTextFormField(
                        labelText: "Quantity of main product(in quintal)",
                        controller: _mainProductPriceController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter Quantity of main product";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      CustomTextFormField(
                        labelText: "Price/unit (in Rs.)",
                        controller: _mainProductAmountController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter Price/unit";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      CustomTextFormField(
                        labelText: "Total main product amount(in quintal)",
                        controller: _byProductQuantityController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Total main product amount";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      CustomTextFormField(
                        labelText: "Quantity of By-products(in tons)",
                        controller: _byProductPriceController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter Quantity of By-product";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      CustomTextFormField(
                        labelText: "Price/unit (in Rs.)",
                        controller: _byProductAmountController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter Price/unit";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      CustomTextFormField(
                        labelText: "Total By-product amount(in Rs.)",
                        controller: _totalByProductAmountController1,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter Total By-product amount";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      CustomTextFormField(
                        labelText: "Total returns(Rs.)",
                        controller: _totalByProductAmountController2,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter Total returns";
                          }
                          return null;
                        },
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
                  text: 'NEXT',
                  buttonColor: const Color(0xFFFB812C),
                  onPressed: () {
                    bool isFormValid = _validateForm();
                    bool areControllersValid = _validatecontrollers();

                    print(
                        'Form valid: $isFormValid, Controllers valid: $areControllersValid');

                    if (isFormValid && areControllersValid) {
                      try {
                        _submitData(context);
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
