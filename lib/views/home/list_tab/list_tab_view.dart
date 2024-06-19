import 'package:flutter/material.dart';
import 'package:gkvk/database/farmer_profile_db.dart';
import 'package:gkvk/shared/components/CustomTextButton.dart';
import 'package:gkvk/database/survey_page1_db.dart';
import 'package:gkvk/database/survey_page2_db.dart';
import 'package:gkvk/database/survey_page3_db.dart';
import 'package:gkvk/database/survey_page4_db.dart';
import 'package:gkvk/database/cropdetails_db.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(const MaterialApp(
    home: ListTabView(),
  ));
}

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
    final surveyDataDB1 = SurveyDataDB1();
    final surveyDataDB2 = SurveyDataDB2();
    final surveyDataDB3 = SurveyDataDB3();
    final surveyDataDB4 = SurveyDataDB4();
    final cropdetailsDB = CropdetailsDB();

    try {
      final farmerData = await farmerProfileDB.read(aadharNumber);
      if (farmerData == null) throw Exception('Farmer data not found');

      final surveyData1 = await surveyDataDB1.read(aadharNumber);
      final surveyData2 = await surveyDataDB2.read(aadharNumber);
      final surveyData3 = await surveyDataDB3.read(aadharNumber);
      final surveyData4 = await surveyDataDB4.read(aadharNumber);
      final cropDetailsData = await cropdetailsDB.readByAadharId(aadharNumber);

      final firestore = FirebaseFirestore.instance;
      final batch = firestore.batch();

      final farmerRef = firestore.collection('farmers').doc(aadharNumber.toString());

      batch.set(farmerRef, farmerData);

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
      if (cropDetailsData.isNotEmpty) {
        final cropDetailsRef = farmerRef.collection('cropDetails');
        for (var crop in cropDetailsData) {
          final cropRef = cropDetailsRef.doc();
          batch.set(cropRef, crop);
        }
      }

      await batch.commit();

      await farmerProfileDB.delete(aadharNumber);
      if (surveyData1 != null) await surveyDataDB1.delete(aadharNumber);
      if (surveyData2 != null) await surveyDataDB2.delete(aadharNumber);
      if (surveyData3 != null) await surveyDataDB3.delete(aadharNumber);
      if (surveyData4 != null) await surveyDataDB4.delete(aadharNumber);
      if (cropDetailsData.isNotEmpty) await cropdetailsDB.delete(aadharNumber);

      setState(() {
        _farmersFuture = fetchAllFarmers();
      });
    } catch (e) {
      print('Failed to upload farmer data: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg3.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _farmersFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final farmers = snapshot.data ?? [];
                    if (farmers.isEmpty) {
                      return _buildEmptyListContainer();
                    } else {
                      // Calculate total height needed for the list
                      double listHeight = farmers.length * 80.0; // Assuming each tile is 80.0 in height

                      return Container(
                        height: MediaQuery.of(context).size.height / 2,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF8E0),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount: farmers.length,
                                itemBuilder: (context, index) {
                                  final farmer = farmers[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      child: UploadStatusTile(
                                        aadharNumber: farmer['aadharNumber'],
                                        uploadFunction: uploadFarmerData,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            CustomTextButton(
                              text: 'UPLOAD ALL',
                              buttonColor: const Color(0xFFFB812C),
                              onPressed: () async {
                                final farmers = await _farmersFuture;
                                for (var farmer in farmers) {
                                  await uploadFarmerData(farmer['aadharNumber']);
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    }
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyListContainer() {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      decoration: BoxDecoration(
        color: const Color(0xFFFEF8E0),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'No farmers to upload.',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          CustomTextButton(
            text: 'REFRESH',
            buttonColor: const Color(0xFFFB812C),
            onPressed: () {
              setState(() {
                _farmersFuture = fetchAllFarmers();
              });
            },
          ),
        ],
      ),
    );
  }
}

class UploadStatusTile extends StatelessWidget {
  final int aadharNumber;
  final Function(int) uploadFunction;

  const UploadStatusTile({
    super.key,
    required this.aadharNumber,
    required this.uploadFunction,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
      title: Text('Farmer Id: $aadharNumber'),
      subtitle: const Text('Upload pending'),
      trailing: IconButton(
        icon: const Icon(Icons.cloud_upload, color: Color(0xFFFB812C)),
        onPressed: () async {
          try {
            await uploadFunction(aadharNumber);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Upload successful')));
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
          }
        },
      ),
    );
  }
}
