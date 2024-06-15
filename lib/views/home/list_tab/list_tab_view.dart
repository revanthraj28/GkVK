import 'package:flutter/material.dart';
import 'package:gkvk/database/farmer_profile_db.dart';
import 'package:gkvk/shared/components/CustomTextButton.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gkvk/database/gkvk_db.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gkvk/database/survey_page1_db.dart';
import 'package:gkvk/database/survey_page2_db.dart';
import 'package:gkvk/database/survey_page3_db.dart';
import 'package:gkvk/database/survey_page4_db.dart';
import 'package:gkvk/database/cropdetails_db.dart'; // Include CropdetailsDB

class ListTabView extends StatefulWidget {
  const ListTabView({super.key});

  @override
  _ListTabViewState createState() => _ListTabViewState();
}

class _ListTabViewState extends State<ListTabView> {
  late Future<List<Map<String, dynamic>>> _farmersFuture;

  @override
  void initState() {
    super.initState();
    _farmersFuture = fetchAllFarmers();
  }

  Future<List<Map<String, dynamic>>> fetchAllFarmers() async {
    return await FarmerProfileDB().readAll();
  }

  Future<void> uploadFarmerData(int aadharNumber) async {
    final farmerProfileDB = FarmerProfileDB();
    final waterShedDB = WaterShedDB();
    final surveyDataDB1 = SurveyDataDB1();
    final surveyDataDB2 = SurveyDataDB2();
    final surveyDataDB3 = SurveyDataDB3();
    final surveyDataDB4 = SurveyDataDB4();
    final cropdetailsDB = CropdetailsDB(); // Initialize CropdetailsDB

    try {
      // Get farmer data
      final farmerData = await farmerProfileDB.read(aadharNumber);
      if (farmerData == null) throw Exception('Farmer data not found');

      // Get watershed data
      final watershedId = farmerData['watershedId'];
      final watershedData = await waterShedDB.read(watershedId);
      if (watershedData == null) throw Exception('Watershed data not found');

      // Get survey data from all databases
      final surveyData1 = await surveyDataDB1.read(aadharNumber);
      final surveyData2 = await surveyDataDB2.read(aadharNumber);
      final surveyData3 = await surveyDataDB3.read(aadharNumber);
      final surveyData4 = await surveyDataDB4.read(aadharNumber);

      // Get crop details data
      final cropDetailsData = await cropdetailsDB.readByAadharId(aadharNumber);

      // Upload to Firebase
      final firestore = FirebaseFirestore.instance;
      final batch = firestore.batch();

      final farmerRef = firestore.collection('farmers').doc(aadharNumber.toString());
      final watershedRef = firestore.collection('watersheds').doc(watershedId.toString());

      batch.set(farmerRef, farmerData);
      batch.set(watershedRef, watershedData);

      // Upload survey data if available
      if (surveyData1 != null) {
        final survey1Ref = farmerRef.collection('surveyData1').doc('survey1');
        batch.set(survey1Ref, surveyData1);
      }

      if (surveyData2 != null) {
        final survey2Ref = farmerRef.collection('surveyData2').doc('survey2');
        batch.set(survey2Ref, surveyData2);
      }

      if (surveyData3 != null) {
        final survey3Ref = farmerRef.collection('surveyData3').doc('survey3');
        batch.set(survey3Ref, surveyData3);
      }

      if (surveyData4 != null) {
        final survey4Ref = farmerRef.collection('surveyData4').doc('survey4');
        batch.set(survey4Ref, surveyData4);
      }

      // Upload crop details data if available
      if (cropDetailsData.isNotEmpty) {
        final cropDetailsRef = farmerRef.collection('cropDetails');
        for (var crop in cropDetailsData) {
          final cropRef = cropDetailsRef.doc(); // Create a new document for each crop detail
          batch.set(cropRef, crop);
        }
      }

      await batch.commit();

      // Delete local data after successful upload
      await farmerProfileDB.delete(aadharNumber);
      if (surveyData1 != null) await surveyDataDB1.delete(aadharNumber);
      if (surveyData2 != null) await surveyDataDB2.delete(aadharNumber);
      if (surveyData3 != null) await surveyDataDB3.delete(aadharNumber);
      if (surveyData4 != null) await surveyDataDB4.delete(aadharNumber);
      if (cropDetailsData.isNotEmpty) await cropdetailsDB.delete(aadharNumber);

      // Refresh the farmer list after upload
      setState(() {
        _farmersFuture = fetchAllFarmers();
      });
    } catch (e) {
      print('Failed to upload farmer data: $e');
      rethrow; // Rethrow to handle in UI
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg1.png', // Replace with your image asset path
              fit: BoxFit.cover,
            ),
          ),
          // Foreground content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: _farmersFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No farmers to upload.'));
                      } else {
                        final farmers = snapshot.data!;
                        return ListView.builder(
                          itemCount: farmers.length,
                          itemBuilder: (context, index) {
                            final farmer = farmers[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0), // Adjusted padding to reduce height
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: UploadStatusTile(
                                  aadharNumber: farmer['aadharNumber'],
                                  uploadFunction: uploadFarmerData, // Pass the function here
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
                CustomTextButton(
                  text: 'UPLOAD ALL',
                  onPressed: () async {
                    final farmers = await _farmersFuture;
                    for (var farmer in farmers) {
                      await uploadFarmerData(farmer['aadharNumber']);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UploadStatusTile extends StatelessWidget {
  final int aadharNumber;
  final Function(int) uploadFunction; // New parameter

  const UploadStatusTile({super.key,
    required this.aadharNumber,
    required this.uploadFunction, // Added parameter
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16.0),
      title: Text('Farmer Id: $aadharNumber'),
      subtitle: const Text('Upload pending'),
      trailing: IconButton(
        icon: const Icon(Icons.cloud_upload, color: Color(0xFF8DB600)),
        onPressed: () async {
          try {
            await uploadFunction(aadharNumber); // Call the function passed from ListTabView
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Upload successful')));
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
          }
        },
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: ListTabView(),
  ));
}
