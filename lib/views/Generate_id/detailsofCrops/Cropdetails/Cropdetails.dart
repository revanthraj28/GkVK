import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gkvk/shared/components/CustomTextButton.dart';
import 'package:gkvk/shared/components/CustomTextFormField.dart';
import 'package:gkvk/shared/components/SelectionButton.dart';
import 'package:gkvk/views/Generate_id/detailsofCrops/Cropdetails/components/customradiogroup.dart';
import 'package:gkvk/views/Generate_id/detailsofCrops/Cropdetails/components/FertilizerForm.dart';
import 'package:gkvk/views/Generate_id/detailsofCrops/Surveypages/Surveypages1.dart';

class Cropdetails extends StatefulWidget {
    final int aadharId;
  const Cropdetails({required this.aadharId, super.key});

  @override
  _CropdetailsState createState() => _CropdetailsState();
}

class _CropdetailsState extends State<Cropdetails> {
  final TextEditingController _cropNameController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _surveyHissaController = TextEditingController();
  final TextEditingController _cropVarietyController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _seedCostController = TextEditingController();
  final TextEditingController _manureNameController = TextEditingController();
  final TextEditingController _manureQuantityController = TextEditingController();
  final TextEditingController _manureCostController = TextEditingController();
  final TextEditingController _bioFertilizerNameController = TextEditingController();
  final TextEditingController _bioFertilizerQuantityController = TextEditingController();
  final TextEditingController _bioFertilizerCostController = TextEditingController();
  final TextEditingController _chemFertilizerNameController = TextEditingController();
  final TextEditingController _chemFertilizerQuantityController = TextEditingController();
  final TextEditingController _chemFertilizerCostController = TextEditingController();
  final TextEditingController _plantProtectionCostController = TextEditingController();
  final TextEditingController _ownLabourNumberController = TextEditingController();
  final TextEditingController _ownLabourCostController = TextEditingController();
  final TextEditingController _hiredLabourNumberController = TextEditingController();
  final TextEditingController _hiredLabourCostController = TextEditingController();
  final TextEditingController _animalDrawnCostController = TextEditingController();
  final TextEditingController _animalMechanizedCostController = TextEditingController();
  final TextEditingController _irrigationCostController = TextEditingController();
  final TextEditingController _Otherproductioncost = TextEditingController();
  final TextEditingController _mainProductQuantityController = TextEditingController();
  final TextEditingController _mainProductPriceController = TextEditingController();
  final TextEditingController _mainProductTotalController = TextEditingController();
  final TextEditingController _byProductQuantityController = TextEditingController();
  final TextEditingController _byProductPriceController = TextEditingController();
  final TextEditingController _byProductTotalController = TextEditingController();

  final RxString _selectedCategory1 = ''.obs;
  final RxString _selectedCategory2 = ''.obs;
  final RxString _selectedCategory3 = ''.obs;
  final RxString _selectedCategory4 = ''.obs;

  RxMap<String, String?> selectedValues = {
  'Nitrogen': null,
  'Phosphorous': null,
  'Potassium': null,
}.obs;


  final List<String> options = ['very low', 'Low', 'Medium', 'High', 'Very high'];

  List<Widget> fertilizerForms = [];

  @override
  void initState() {
    super.initState();
    fertilizerForms.add(const FertilizerForm(index: 1));
  }

  void addFertilizerForm() {
    setState(() {
      fertilizerForms.add(FertilizerForm(index: fertilizerForms.length + 1));
    });
  }

  bool _validateForm() {
    List<TextEditingController> _controllers = [
      _cropNameController,
      _areaController,
      _surveyHissaController,
      _cropVarietyController,
      _durationController,
      _seedCostController,
      _manureNameController,
      _manureQuantityController,
      _manureCostController,
      _bioFertilizerNameController,
      _bioFertilizerQuantityController,
      _bioFertilizerCostController,
      _chemFertilizerNameController,
      _chemFertilizerQuantityController,
      _chemFertilizerCostController,
      _plantProtectionCostController,
      _ownLabourNumberController,
      _ownLabourCostController,
      _hiredLabourNumberController,
      _hiredLabourCostController,
      _animalDrawnCostController,
      _animalMechanizedCostController,
      _irrigationCostController,
      _mainProductQuantityController,
      _mainProductPriceController,
      _mainProductTotalController,
      _byProductQuantityController,
      _byProductPriceController,
      _byProductTotalController,
    ];

    for (var controller in _controllers) {
      if (controller.text.isEmpty) {
        return false;
      }
    }
    if (selectedValues['Nitrogen'] == null ||
        selectedValues['Phosphorous'] == null ||
        selectedValues['Potassium'] == null ||
        _selectedCategory1.value.isEmpty ||
        _selectedCategory2.value.isEmpty ||
        _selectedCategory3.value.isEmpty ||
        _selectedCategory4.value.isEmpty) {
      return false;
    }
    return true;
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text('All fields must be filled and a selection made in each category.'),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        title: const Text(
          'Enter the Crop details',
          style: TextStyle(
            color: Color(0xFF8DB600),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: const Color(0xFFF3F3F3),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        labelText: "Crop Name",
                        controller: _cropNameController,
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: CustomTextFormField(
                        labelText: "Area in acres",
                        controller: _areaController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        labelText: "Survey and Hissa No",
                        controller: _surveyHissaController,
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: CustomTextFormField(
                        labelText: "Variety of crop",
                        controller: _cropVarietyController,
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                CustomTextFormField(
                  labelText: "Duration(in days)",
                  controller: _durationController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10.0),
                Obx(() => SelectionButton(
                  label: "Season",
                  options: const ['Khrif', 'Rabi', 'Summer'],
                  selectedOption: _selectedCategory2.value.isEmpty ? null : _selectedCategory2.value,
                  onPressed: (option) {
                    _selectedCategory2.value = option ?? '';
                  },
                )),
                const SizedBox(height: 10.0),
                Obx(() => SelectionButton(
                  label: "Type of land",
                  options: const ['Rain-fed', 'Irrigated'],
                  selectedOption: _selectedCategory1.value.isEmpty ? null : _selectedCategory1.value,
                  onPressed: (option) {
                    _selectedCategory1.value = option ?? '';
                  },
                )),
                const SizedBox(height: 10.0),
                Obx(() => SelectionButton(
                  label: "Source of Irrigation",
                  options: const ['Borewell', 'Tank', 'Canal', 'Others'],
                  selectedOption: _selectedCategory3.value.isEmpty ? null : _selectedCategory3.value,
                  onPressed: (option) {
                    _selectedCategory3.value = option ?? '';
                  },
                )),
                const SizedBox(height: 20.0),
                CustomTextFormField(
                  labelText: "Cost of seed(including own seed(in Rs))",
                  controller: _seedCostController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20.0),
                const Text('Fertility status according to LRI card',
                    style: TextStyle(fontSize: 18)),
                const SizedBox(height: 10.0),
                Obx(() => CustomRadioGroup(
                  title: 'Nitrogen',
                  options: options,
                  groupValue: selectedValues['Nitrogen'],
                  onChanged: (value) {
                    selectedValues['Nitrogen'] = value;
                  },
                )),
                const SizedBox(height: 10.0),
                Obx(() => CustomRadioGroup(
                  title: 'Phosphorous',
                  options: options,
                  groupValue: selectedValues['Phosphorous'],
                  onChanged: (value) {
                    selectedValues['Phosphorous'] = value;
                  },
                )),
                const SizedBox(height: 10.0),
                Obx(() => CustomRadioGroup(
                  title: 'Potassium',
                  options: options,
                  groupValue: selectedValues['Potassium'],
                  onChanged: (value) {
                    selectedValues['Potassium'] = value;
                  },
                )),
                const SizedBox(height: 20.0),
                Obx(() => SelectionButton(
                  label: "RDF of crop (kg/ac)",
                  options: const [
                    'Option 1',
                    'Option 2',
                    'Option 3'
                  ], 
                  selectedOption: _selectedCategory4.value.isEmpty ? null : _selectedCategory4.value,
                  onPressed: (option) {
                    _selectedCategory4.value = option ?? '';
                  },
                )),
                const SizedBox(height: 20.0),
                const Text('Adjusted RDF of crop according to LRI card (kg/ac)',
                    style: TextStyle(fontSize: 18)),
                const SizedBox(height: 20.0),
                const Text('Manures and fertilizers', style: TextStyle(fontSize: 18)),
                const SizedBox(height: 10.0),
                CustomTextFormField(
                  labelText: "Name of Organic Manures",
                  controller: _manureNameController,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 10.0),
                CustomTextFormField(
                  labelText: "Quantity of Manures",
                  controller: _manureQuantityController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10.0),
                CustomTextFormField(
                  labelText: "Cost of Manures",
                  controller: _manureCostController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10.0),
                CustomTextFormField(
                  labelText: "Name of Bio-Fertilizers",
                  controller: _bioFertilizerNameController,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 10.0),
                CustomTextFormField(
                  labelText: "Quantity of Bio-Fertilizers",
                  controller: _bioFertilizerQuantityController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10.0),
                CustomTextFormField(
                  labelText: "Cost of Bio-Fertilizers",
                  controller: _bioFertilizerCostController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10.0),
                CustomTextFormField(
                  labelText: "Name of Chemical Fertilizers",
                  controller: _chemFertilizerNameController,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 10.0),
                CustomTextFormField(
                  labelText: "Quantity of Chemical Fertilizers",
                  controller: _chemFertilizerQuantityController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10.0),
                CustomTextFormField(
                  labelText: "Cost of Chemical Fertilizers",
                  controller: _chemFertilizerCostController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20.0),
                const Text('Cost of cultivation:', style: TextStyle(fontSize: 18)),
                const SizedBox(height: 10.0),
                CustomTextFormField(
                  labelText: "Cost of Plant Protection",
                  controller: _plantProtectionCostController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10.0),
                CustomTextFormField(
                  labelText: "No. of Own Labour",
                  controller: _ownLabourNumberController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10.0),
                CustomTextFormField(
                  labelText: "Cost of Own Labour",
                  controller: _ownLabourCostController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10.0),
                CustomTextFormField(
                  labelText: "No. of Hired Labour",
                  controller: _hiredLabourNumberController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10.0),
                CustomTextFormField(
                  labelText: "Cost of Hired Labour",
                  controller: _hiredLabourCostController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10.0),
                CustomTextFormField(
                  labelText: "Cost of Animal Drawn Labour",
                  controller: _animalDrawnCostController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10.0),
                CustomTextFormField(
                  labelText: "Cost of Animal and Mechanized Labour",
                  controller: _animalMechanizedCostController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10.0),
                CustomTextFormField(
                  labelText: "Cost of Irrigation",
                  controller: _irrigationCostController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10.0),
                CustomTextFormField(
                  labelText: "Cost of Other production cost",
                  controller: _Otherproductioncost,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20.0),
                const Text('Production:', style: TextStyle(fontSize: 18)),
                const SizedBox(height: 10.0),
                CustomTextFormField(
                  labelText: "Quantity of main Product(Quintal)",
                  controller: _mainProductQuantityController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10.0),
                CustomTextFormField(
                  labelText: "Price of main Product(Rs/Quintal)",
                  controller: _mainProductPriceController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10.0),
                CustomTextFormField(
                  labelText: "Total cost of main production",
                  controller: _mainProductTotalController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10.0),
                CustomTextFormField(
                  labelText: "Total of main Product",
                  controller: _mainProductTotalController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10.0),
                CustomTextFormField(
                  labelText: "Quantity of By Product",
                  controller: _byProductQuantityController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10.0),
                CustomTextFormField(
                  labelText: "Price of By Product",
                  controller: _byProductPriceController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10.0),
                CustomTextFormField(
                  labelText: "Total of By Product",
                  controller: _byProductTotalController,
                  keyboardType: TextInputType.number,
                ),
                 const SizedBox(height: 60.0),
              ],
            ),
          ),
        ),
      ),
         floatingActionButton: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: CustomTextButton(
          text: 'Done',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SurveyPage1(aadharId: widget.aadharId),
              ),
            );
            //   // if (_validateForm()) {

            //   // } else {
            //   //   // _showErrorDialog();
            //   // }
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}