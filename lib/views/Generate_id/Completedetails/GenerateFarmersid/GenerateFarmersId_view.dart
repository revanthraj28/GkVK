import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gkvk/shared/components/CustomTextButton.dart';
import 'package:gkvk/shared/components/CustomTextFormField.dart';
import 'package:gkvk/shared/components/SelectionButton.dart';
import 'package:gkvk/database/farmer_profile_db.dart';
import 'package:gkvk/views/Generate_id/detailsofCrops/Cropdetails/components/FertilizerForm.dart';
import 'package:gkvk/views/Generate_id/detailsofCrops/Surveypages/Surveypages1.dart';

class GenerateFarmersIdPage extends StatelessWidget {
  final int waterShedId; // Accept waterShedId as a required parameter
  final _farmerNameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _schoolingController = TextEditingController();
  final _aadharController = TextEditingController();
  final _fruitsIdController = TextEditingController();
  final _fertilizerAddressController = TextEditingController();

  final RxString _selectedGender = ''.obs;
  final RxString _selectedCategory = ''.obs;
  final RxString _selectedLandHolding = ''.obs;
  final RxString _selectedFertilizerSource = ''.obs;
  final RxString _selectedSalesOfProduce = ''.obs;
  final RxString _selectedLRIReceived = ''.obs;

  GenerateFarmersIdPage({required this.waterShedId, super.key}); // Update constructor to accept waterShedId

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
          builder: (context) => SurveyPage1(aadharId: int.parse(_aadharController.text),),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        title: const Text(
          'ENTER FARMER DETAILS',
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
                CustomTextFormField(
                  labelText: "Farmer's Name",
                  controller: _farmerNameController,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 20.0),
                CustomTextFormField(
                  labelText: "Father's/Husband Name",
                  controller: _fatherNameController,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        labelText: "Pincode",
                        controller: _pincodeController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: CustomTextFormField(
                        labelText: "Year's of Schooling",
                        keyboardType: TextInputType.number,
                        controller: _schoolingController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Obx(() => SelectionButton(
                  label: "Gender",
                  options: const ['Male', 'Female'],
                  selectedOption: _selectedGender.value.isEmpty
                      ? null
                      : _selectedGender.value,
                  onPressed: (option) {
                    _selectedGender.value = option ?? '';
                  },
                )),
                const SizedBox(height: 10.0),
                Obx(() => SelectionButton(
                  label: "Category of Farmer - Social Class",
                  options: const ['SC', 'ST', 'OBC', 'GENERAL'],
                  selectedOption: _selectedCategory.value.isEmpty
                      ? null
                      : _selectedCategory.value,
                  onPressed: (option) {
                    _selectedCategory.value = option ?? '';
                  },
                )),
                const SizedBox(height: 10.0),
                Obx(() => SelectionButton(
                  label: "Category of Farmer - Land Holding",
                  options: const ['MF', 'SF', 'BF'],
                  selectedOption: _selectedLandHolding.value.isEmpty
                      ? null
                      : _selectedLandHolding.value,
                  onPressed: (option) {
                    _selectedLandHolding.value = option ?? '';
                  },
                )),
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        labelText: "Aadhaar Number",
                        controller: _aadharController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: CustomTextFormField(
                        labelText: "Fruits ID Number",
                        controller: _fruitsIdController,
                        keyboardType: TextInputType.number,
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
                    _selectedFertilizerSource.value = option ?? '';
                  },
                )),
                const SizedBox(height: 20.0),
                CustomTextFormField(
                  labelText: "Address of dealers, society, FPO or others",
                  controller: _fertilizerAddressController,
                  keyboardType: TextInputType.streetAddress,
                ),
                const SizedBox(height: 10.0),
                Obx(() => SelectionButton(
                  label: "Sales of produce holding",
                  options: const [
                    'Open Market',
                    'APMC',
                    'Middle Men',
                    'Others'
                  ],
                  selectedOption: _selectedSalesOfProduce.value.isEmpty
                      ? null
                      : _selectedSalesOfProduce.value,
                  onPressed: (option) {
                    _selectedSalesOfProduce.value = option ?? '';
                  },
                )),
                const SizedBox(height: 10.0),
                Obx(() => SelectionButton(
                  label: "LRI Card Received",
                  options: const ['Yes', 'No'],
                  selectedOption: _selectedLRIReceived.value.isEmpty
                      ? null
                      : _selectedLRIReceived.value,
                  onPressed: (option) {
                    _selectedLRIReceived.value = option ?? '';
                  },
                )),
                const SizedBox(height: 60.0),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: CustomTextButton(
          text: 'CREATE',
          onPressed: () {
            if (_farmerNameController.text.isEmpty ||
                _fatherNameController.text.isEmpty ||
                _pincodeController.text.isEmpty ||
                _schoolingController.text.isEmpty ||
                _aadharController.text.isEmpty ||
                _fruitsIdController.text.isEmpty ||
                _fertilizerAddressController.text.isEmpty ||
                _selectedGender.value.isEmpty ||
                _selectedCategory.value.isEmpty ||
                _selectedLandHolding.value.isEmpty ||
                _selectedFertilizerSource.value.isEmpty ||
                _selectedSalesOfProduce.value.isEmpty ||
                _selectedLRIReceived.value.isEmpty) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Error'),
                    content: const Text(
                        'All fields must be filled and a selection made in each category.'),
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
            } else {
              _uploadData(context);
            }
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
