import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
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
  final TextEditingController _subWatershedNameController = TextEditingController();
  final TextEditingController _subWatershedCodeController = TextEditingController();
  final TextEditingController _villageController = TextEditingController();

  final RxString _selectedCategory = ''.obs;

  WatershedView({super.key});

  Future<void> _uploadData(BuildContext context) async {
    final WaterShedDB db = WaterShedDB();
    final Database database = await DatabaseService().database;

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
      print('Data uploaded successfully with ID: $id');
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
    print('Data uploaded successfully with ID: $latestId');
    if (latestId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GenerateFarmersIdPage(waterShedId: latestId),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('No previous watershed data found.'),
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

  Future<bool> _onWillPop(BuildContext context) async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Exit'),
        content: const Text('Do you want to return to the home page?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
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
                  const SizedBox(height: 110.0),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomTextButton(
                text: 'NEXT',
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
                          title: const Text('Error'),
                          content: const Text('All fields must be filled and a treatment option selected.'),
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
            const SizedBox(height: 10.0),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomTextButton(
                text: 'PREVIOUS WATERSHED',
                onPressed: () {
                  _navigateWithLatestWaterShedId(context);
                },
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}