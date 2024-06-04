import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gkvk/shared/components/CustomTextButton.dart';
import 'package:gkvk/shared/components/CustomTextFormField.dart';
import 'package:gkvk/shared/components/SelectionButton.dart';
import 'package:gkvk/views/generateid/GenerateFarmersId_view.dart';

class WatershedView extends StatelessWidget {
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _talukController = TextEditingController();
  final TextEditingController _hobliController = TextEditingController();
  final TextEditingController _subWatershedNameController = TextEditingController();
  final TextEditingController _subWatershedCodeController = TextEditingController();
  final TextEditingController _villageController = TextEditingController();
  
  final RxString _selectedCategory = ''.obs;

  WatershedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        title: const Text(
          'ENTER WATER-SHED DETAILS',
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
                        labelText: "District",
                        controller: _districtController,
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: CustomTextFormField(
                        labelText: "Taluk",
                        controller: _talukController,
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                CustomTextFormField(
                  labelText: "Hobli",
                  controller: _hobliController,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 20.0),
                CustomTextFormField(
                  labelText: "Sub-Watershed Name",
                  controller: _subWatershedNameController,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 20.0),
                CustomTextFormField(
                  labelText: "Sub-Watershed Code",
                  controller: _subWatershedCodeController,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 20.0),
                CustomTextFormField(
                  labelText: "Village",
                  controller: _villageController,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 10.0),
                Obx(() => SelectionButton(
                  label: "Treatment",
                  options: const ['T1', 'T2', 'T3', 'T4'],
                  selectedOption: _selectedCategory.value.isEmpty ? null : _selectedCategory.value,
                  onPressed: (option) {
                    _selectedCategory.value = option ?? '';
                  },
                )),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: CustomTextButton(
          text: 'DONE',
          onPressed: () {
            if (_districtController.text.isEmpty ||
                _talukController.text.isEmpty ||
                _hobliController.text.isEmpty ||
                _subWatershedNameController.text.isEmpty ||
                _subWatershedCodeController.text.isEmpty ||
                _villageController.text.isEmpty ||
                _selectedCategory.value.isEmpty) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Error'),
                    content: Text('All fields must be filled and a treatment option selected.'),
                    actions: [
                      TextButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GenerateFarmersIdPage()),
              );
            }
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
