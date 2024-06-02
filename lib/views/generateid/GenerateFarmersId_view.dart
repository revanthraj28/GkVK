import 'package:flutter/material.dart';
import 'package:gkvk/shared/components/CustomTextButton.dart';
import 'package:gkvk/shared/components/CustomTextFormField.dart';
import 'package:gkvk/shared/components/SelectionButton.dart';

class GenerateFarmersIdPage extends StatelessWidget{

  final _farmerNameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _schoolingController = TextEditingController();
  final _aadharController = TextEditingController();
  final _fruitsIdController = TextEditingController();
  final _fertilizerAddressController = TextEditingController();

  String? _selectedGender;
  String? _selectedCategory;
  String? _selectedLandHolding;
  String? _selectedFertilizerSource;
  String? _selectedSalesOfProduce;
  String? _selectedLRIReceived;

  GenerateFarmersIdPage({super.key});

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
                SelectionButton(
                  label: "Gender",
                  options: const ['Male', 'Female'],
                  selectedOption: _selectedGender,
                  onPressed: (option) {
                    // setState(() {
                    //   _selectedGender = option;
                    // });
                  },
                ),
                const SizedBox(height: 10.0),
                SelectionButton(
                  label: "Category of Farmer - Social Class",
                  options: const ['SC', 'ST', 'OBC', 'GENERAL'],
                  selectedOption: _selectedCategory,
                  onPressed: (option) {
                    // setState(() {
                    //   _selectedCategory = option;
                    // });
                  },
                ),
                const SizedBox(height: 10.0),
                SelectionButton(
                  label: "Category of Farmer - Land Holding",
                  options: const ['MF', 'SF', 'BF'],
                  selectedOption: _selectedLandHolding,
                  onPressed: (option) {
                    // setState(() {
                    //   _selectedLandHolding = option;
                    // });
                  },
                ),
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
                SelectionButton(
                  label: "Source of Purchase of Fertilizers",
                  options: const ['Dealers', 'Society', 'FPO', 'Others'],
                  selectedOption: _selectedFertilizerSource,
                  onPressed: (option) {
                    // setState(() {
                    //   _selectedFertilizerSource = option;
                    // });
                  },
                ),
                const SizedBox(height: 20.0),
                CustomTextFormField(
                  labelText: "Address of dealers, society, FPO or others",
                  controller: _fertilizerAddressController,
                  keyboardType: TextInputType.streetAddress,
                ),
                const SizedBox(height: 10.0),
                SelectionButton(
                  label: "Sales of produce holding",
                  options: const ['Open Market', 'APMC', 'Middle Men', 'Others'],
                  selectedOption: _selectedSalesOfProduce,
                  onPressed: (option) {
                    // setState(() {
                    //   _selectedSalesOfProduce = option;
                    // });
                  },
                ),
                const SizedBox(height: 10.0),
                SelectionButton(
                  label: "LRI Card Received",
                  options: const ['Yes', 'No'],
                  selectedOption: _selectedLRIReceived,
                  onPressed: (option) {
                    // setState(() {
                    //   _selectedLRIReceived = option;
                    // });
                  },
                ),
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
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}