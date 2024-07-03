import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gkvk/database/farmer_profile_db.dart';
import 'package:gkvk/database/survey_page1_db.dart';
import 'package:gkvk/database/survey_page2_db.dart';
import 'package:gkvk/database/survey_page3_db.dart';
import 'package:gkvk/database/survey_page4_db.dart';
import 'package:gkvk/database/cropdetails_db.dart';
// import 'package:gkvk/database/watershed_db.dart';
import 'package:gkvk/database/gkvk_db.dart';
import 'package:gkvk/shared/components/CustomTextButton.dart';

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
  bool _isUploading = false; // Loading flag

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
  final waterShedDB = WaterShedDB();

  try {
    final farmerData = await farmerProfileDB.read(aadharNumber);
    if (farmerData == null) throw Exception('Farmer data not found');

    // Create a mutable copy of farmerData
    final mutableFarmerData = Map<String, dynamic>.from(farmerData);

    print('Farmer Data: $mutableFarmerData');

    final surveyData1 = await surveyDataDB1.read(aadharNumber);
    final surveyData2 = await surveyDataDB2.read(aadharNumber);
    final surveyData3 = await surveyDataDB3.read(aadharNumber);
    final surveyData4 = await surveyDataDB4.read(aadharNumber);
    final cropDetailsData = await cropdetailsDB.readByAadharId(aadharNumber);

    final watershedId = farmerData['watershedId'];
    final watershedData = await waterShedDB.read(watershedId);
    if (watershedData == null) throw Exception('Watershed data not found');

    final firestore = FirebaseFirestore.instance;
    final batch = firestore.batch();

    final farmerRef = firestore.collection('farmers').doc(aadharNumber.toString());

    // Upload image to Firebase Storage
    final imagePath = farmerData['image'];
    if (imagePath != null && imagePath.isNotEmpty) {
      final file = File(imagePath);
      if (file.existsSync()) {
        final storageRef = FirebaseStorage.instance.ref().child('farmer_images/$aadharNumber.jpg');
        final uploadTask = storageRef.putFile(file);
        final snapshot = await uploadTask.whenComplete(() => null);
        final downloadUrl = await snapshot.ref.getDownloadURL();
        print('Image URL: $downloadUrl');

        // Update mutableFarmerData with imageUrl
        mutableFarmerData['imageUrl'] = downloadUrl;
      } else {
        print('Error: Image file does not exist at path: $imagePath');
      }
    }

    print('Updated Farmer Data: $mutableFarmerData');

    batch.set(farmerRef, mutableFarmerData);

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

    final watershedRef = farmerRef.collection('watershed').doc('watershed');
    batch.set(watershedRef, watershedData);

    // Update farmerCount for the current user
    // Update farmerCount for the current user
final currentUser = FirebaseAuth.instance.currentUser;
if (currentUser != null) {
  final userRef = firestore.collection('users').doc(currentUser.uid);
  batch.update(userRef, {
    'farmerCount': FieldValue.increment(1),
    'aadharNumber': aadharNumber.toString(), // Add Aadhar card number here
  });
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
    print('Error: $e');
    rethrow;
  }
}


  Future<void> uploadAllData() async {
    setState(() {
      _isUploading = true; // Start loading
    });

    final farmers = await _farmersFuture;
    for (var farmer in farmers) {
      await uploadFarmerData(farmer['aadharNumber']);
    }

    final remainingFarmers = await fetchAllFarmers();
    if (remainingFarmers.isEmpty) {
      final waterShedDB = WaterShedDB();
      await waterShedDB.deleteAll();
    }

    setState(() {
      _isUploading = false; // Stop loading
    });
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
                      return Stack(
                        children: [
                          Container(
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
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                spreadRadius: 2,
                                                blurRadius: 5,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          // child: UploadStatusTile(
                                          //   aadharNumber: farmer['aadharNumber'],
                                          //   uploadFunction: uploadFarmerData,
                                          // ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 10),
                                CustomTextButton(
                                  text: 'Upload All',
                                  buttonColor: const Color(0xFFFB812C),
                                  onPressed: () async {
                                    await uploadAllData();
                                  },
                                ),
                              ],
                            ),
                          ),
                          if (_isUploading)
                            Positioned.fill(
                              child: Container(
                                color: Colors.black54,
                                child: const Center(
                                  child: CircularProgressIndicator( valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFB812C)),),
                                ),
                              ),
                            ),
                        ],
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

class UploadStatusTile extends StatefulWidget {
  final int aadharNumber;
  final Future<void> Function(int) uploadFunction;

  const UploadStatusTile({
    super.key,
    required this.aadharNumber,
    required this.uploadFunction,
  });

  @override
  _UploadStatusTileState createState() => _UploadStatusTileState();
}

class _UploadStatusTileState extends State<UploadStatusTile> {
  bool _isLoading = false;

  void _startUpload() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await widget.uploadFunction(widget.aadharNumber);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Upload successful')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Upload failed: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
      title: Text('Farmer Id: ${widget.aadharNumber}'),
      subtitle: const Text('Upload pending'),
      trailing: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFB812C)),
              ),
            )
          : IconButton(
              icon: const Icon(Icons.cloud_upload, color: Color(0xFFFB812C)),
              onPressed: _startUpload,
            ),
    );
  }
}
