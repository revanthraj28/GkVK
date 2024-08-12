import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
import 'package:gkvk/database/dealer_db.dart';
import 'package:gkvk/database/surveypage1forfer_db.dart';
import 'package:gkvk/database/surveypage2forfer_db.dart';
import 'package:gkvk/database/surveypage3forfer_db.dart';
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
  late Future<List<Map<String, dynamic>>> _dealersFuture;
  final bool _isUploading = false; // Loading flag

  @override
  void initState() {
    super.initState();
    _farmersFuture = fetchAllFarmers();
    _dealersFuture = fetchAllDealers();
  }

  Future<List<Map<String, dynamic>>> fetchAllFarmers() async {
    return await FarmerProfileDB().readAll();
  }

  Future<List<Map<String, dynamic>>> fetchAllDealers() async {
    return await DealerDb().readAll();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 1,
          backgroundColor: const Color(0xFFFEF8E0),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Farmers'),
              Tab(text: 'Dealers'),
            ],
          ),
          iconTheme: const IconThemeData(color: Color(0xFFFB812C)),
        ),
        body: const TabBarView(
          children: [
            FarmersTab(),
            DealersTab(),
          ],
        ),
      ),
    );
  }
}

class FarmersTab extends StatefulWidget {
  const FarmersTab({super.key});

  @override
  _FarmersTabState createState() => _FarmersTabState();
}

class _FarmersTabState extends State<FarmersTab> {
  late Future<List<Map<String, dynamic>>> _farmersFuture;
  bool _isUploading = false;

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

      final farmerRef =
          firestore.collection('farmers').doc(aadharNumber.toString());

      // Upload image to Firebase Storage
      final imagePath = farmerData['image'];
      if (imagePath != null && imagePath.isNotEmpty) {
        final file = File(imagePath);
        if (file.existsSync()) {
          final storageRef = FirebaseStorage.instance
              .ref()
              .child('farmer_images/$aadharNumber.jpg');
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

  Future<void> incrementUserCounter(String counterField) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final firestore = FirebaseFirestore.instance;
    final userRef = firestore.collection('userCounts').doc(user.uid);

    await firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(userRef);

      if (snapshot.exists) {
        transaction.update(userRef, {
          counterField: FieldValue.increment(1),
        });
      } else {
        transaction.set(userRef, {
          counterField: 1,
          'email': user.email,
        });
      }
    });
  }
  
  Future<void> addFarmerToUserCollection(String userEmail, int aadharNumber) async {
    final firestore = FirebaseFirestore.instance;
    final userRef = firestore.collection('users').doc(userEmail);

    final farmerRef = userRef.collection('farmers').doc(aadharNumber.toString());

    await farmerRef.set({
      'aadharNumber': aadharNumber,
    });
  }

  Future<void> uploadAllData() async {
    setState(() {
      _isUploading = true; // Start loading
    });

    final farmers = await _farmersFuture;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    for (var farmer in farmers) {
      await uploadFarmerData(farmer['aadharNumber']);
      await addFarmerToUserCollection(user.email!, farmer['aadharNumber']);
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
    return Stack(
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
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              spreadRadius: 2,
                                              blurRadius: 5,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: UploadStatusTile(
                                          aadharNumber: farmer['aadharNumber'],
                                          uploadFunction: uploadFarmerData,
                                          isFarmersTab: true,
                                        ),
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
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(0xFFFB812C)),
                                ),
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

class DealersTab extends StatefulWidget {
  const DealersTab({super.key});

  @override
  _DealersTabState createState() => _DealersTabState();
}

class _DealersTabState extends State<DealersTab> {
  late Future<List<Map<String, dynamic>>> _dealersFuture;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _dealersFuture = fetchAllDealers();
  }

  Future<void> uploadDealerData(int aadharNumber) async {
    final dealerDB = DealerDb();
    final surveyDataDBforfer = SurveyDataDBforfer();
    final surveyDataDBforfer2 = SurveyDataDBforfer2();
    final surveyDataDBforfer3 = SurveyDataDBforfer3();
    final waterShedDB = WaterShedDB();

    try {
      // Fetch dealer data
      final dealerData = await dealerDB.read(aadharNumber);
      if (dealerData == null) throw Exception('Dealer data not found');

      // Create a mutable copy of dealerData
      final mutableDealerData = Map<String, dynamic>.from(dealerData);

      print('Dealer Data: $mutableDealerData');

      // Fetch survey data
      final surveyDataDBforfer01 = await surveyDataDBforfer.read(aadharNumber);
      final surveyDataDBforfer02 = await surveyDataDBforfer2.read(aadharNumber);
      final surveyDataDBforfer03 = await surveyDataDBforfer3.read(aadharNumber);

      // Fetch watershed data
      final watershedId = dealerData['watershedId'];
      final watershedData = await waterShedDB.read(watershedId);
      if (watershedData == null) throw Exception('Watershed data not found');

      // Initialize Firebase batch operation
      final firestore = FirebaseFirestore.instance;
      final batch = firestore.batch();

      final dealerRef =
          firestore.collection('dealers').doc(aadharNumber.toString());

      // Upload image to Firebase Storage
      final imagePath = dealerData['image'];
      if (imagePath != null && imagePath.isNotEmpty) {
        final file = File(imagePath);
        if (file.existsSync()) {
          final storageRef = FirebaseStorage.instance
              .ref()
              .child('dealer_images/$aadharNumber.jpg');
          final uploadTask = storageRef.putFile(file);
          final snapshot = await uploadTask.whenComplete(() => null);
          final downloadUrl = await snapshot.ref.getDownloadURL();
          print('Image URL: $downloadUrl');

          // Update mutableDealerData with imageUrl
          mutableDealerData['imageUrl'] = downloadUrl;
        } else {
          print('Error: Image file does not exist at path: $imagePath');
        }
      }

      print('Updated Dealer Data: $mutableDealerData');

      // Add dealer data to batch
      batch.set(dealerRef, mutableDealerData);

      // Add survey data to batch if available
      if (surveyDataDBforfer01 != null) {
        final surveyRef = dealerRef.collection('surveyData').doc('surveyDataDBforfer01');
        batch.set(surveyRef, surveyDataDBforfer01);
      }

      if (surveyDataDBforfer02 != null) {
        final survey2Ref = dealerRef.collection('surveyData').doc('surveyDataDBforfer02');
        batch.set(survey2Ref, surveyDataDBforfer02);
      }

      if (surveyDataDBforfer03 != null) {
        final survey3Ref = dealerRef.collection('surveyData').doc('surveyDataDBforfer03');
        batch.set(survey3Ref, surveyDataDBforfer03);
      }

      // Add watershed data to batch
      final watershedRef = dealerRef.collection('watershed').doc('watershed');
      batch.set(watershedRef, watershedData);

      // Commit the batch operation
      await batch.commit();

      // Delete local data if upload is successful
      await dealerDB.delete(aadharNumber);
      if (surveyDataDBforfer01 != null) await surveyDataDBforfer.delete(aadharNumber);
      if (surveyDataDBforfer02 != null) await surveyDataDBforfer2.delete(aadharNumber);
      if (surveyDataDBforfer03 != null) await surveyDataDBforfer3.delete(aadharNumber);

      // Update UI after successful upload
      setState(() {
        _dealersFuture = fetchAllDealers();
      });
    } catch (e, s) {
      print('Error: $e stacktrace : $s');
      rethrow;
    }
  }
  Future<void> addDealersToUserCollection(String userEmail, int aadharNumber) async {
    final firestore = FirebaseFirestore.instance;
    final userRef = firestore.collection('users').doc(userEmail);

    final dealerRef = userRef.collection('dealers').doc(aadharNumber.toString());

    await dealerRef.set({
      'aadharNumber': aadharNumber,
    });
  }
  Future<List<Map<String, dynamic>>> fetchAllDealers() async {
    return await DealerDb().readAll();
  }
  
  Future<void> uploadAllData() async {
    setState(() {
      _isUploading = true;
    });
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final dealers = await _dealersFuture;
    for (final dealer in dealers) {
      final aadharNumber = dealer['aadharNumber'];
      await uploadDealerData(aadharNumber);
      await addDealersToUserCollection(user.email!, dealer['aadharNumber']);
    }
    final remainingFarmers = await fetchAllDealers();
    if (remainingFarmers.isEmpty) {
      final waterShedDB = WaterShedDB();
      await waterShedDB.deleteAll();
    }
    setState(() {
      _isUploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
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
              future: _dealersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final Dealers = snapshot.data ?? [];
                  if (Dealers.isEmpty) {
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
                                  itemCount: Dealers.length,
                                  itemBuilder: (context, index) {
                                    final Dealer = Dealers[index];
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
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              spreadRadius: 2,
                                              blurRadius: 5,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: UploadStatusTile(
                                          aadharNumber: Dealer['aadharNumber'],
                                          uploadFunction: uploadDealerData,
                                          isFarmersTab: false,
                                        ),
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
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(0xFFFB812C)),
                                ),
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
            'No Dealers to upload.',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          CustomTextButton(
            text: 'REFRESH',
            buttonColor: const Color(0xFFFB812C),
            onPressed: () {
              setState(() {
                _dealersFuture = fetchAllDealers();
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
  final bool isFarmersTab;
  const UploadStatusTile({
    super.key,
    required this.aadharNumber,
    required this.uploadFunction,
    required this.isFarmersTab,
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
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Upload successful')));
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
    String tileTitle;
    if (widget.isFarmersTab) {
      tileTitle = 'Farmers Id: ${widget.aadharNumber}';
    } else {
      tileTitle = 'Dealers Id: ${widget.aadharNumber}';
    }

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
      title: Text(tileTitle),
      subtitle: const Text('Upload pending'),
    );
  }
}
