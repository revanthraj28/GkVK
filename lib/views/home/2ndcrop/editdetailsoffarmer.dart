import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gkvk/shared/components/CustomAlertDialog.dart';
import 'package:gkvk/shared/components/CustomTextButton.dart';
import 'package:gkvk/shared/components/CustomTextFormField.dart';

class Editdetailsoffarmer extends StatefulWidget {
  const Editdetailsoffarmer({super.key});

  @override
  State<Editdetailsoffarmer> createState() => _EditdetailsoffarmerState();
}

class _EditdetailsoffarmerState extends State<Editdetailsoffarmer> {
  final _formKey = GlobalKey<FormState>();
  final farmerAadhaarNumberController = TextEditingController();

  Map<String, dynamic>? farmerDetails;
  Map<String, dynamic>? watershedData;
  List<Map<String, TextEditingController>> cropDetailsControllers = [];
  final Map<String, TextEditingController> controllers = {};

  Future<Map<String, dynamic>?> getFarmerDetailsByAadhaar(
      String aadhaarNumber) async {
    try {
      final int aadhaarNumberAsInt = int.parse(aadhaarNumber);
      final farmersCollection =
          FirebaseFirestore.instance.collection('farmers');
      final querySnapshot = await farmersCollection
          .where('aadharNumber', isEqualTo: aadhaarNumberAsInt)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final farmerDoc = querySnapshot.docs.first;
        final Map<String, dynamic> farmerData = farmerDoc.data();
        farmerData['id'] = farmerDoc.id;

        final docReference = farmersCollection.doc(farmerDoc.id);
        final watershedCollection =
            await docReference.collection('watershed').get();
        final cropDetailsCollection =
            await docReference.collection('cropDetails').get();

        // Initialize watershed data
        if (watershedCollection.docs.isNotEmpty) {
          watershedData = watershedCollection.docs.first.data();
          watershedData!['id'] = watershedCollection.docs.first.id;
        }

        // Initialize crop details
        if (cropDetailsCollection.docs.isNotEmpty) {
          cropDetailsControllers = []; // Clear previous controllers
          for (var doc in cropDetailsCollection.docs) {
            final cropData = doc.data();
            cropData['id'] = doc.id;
            cropDetailsControllers.add({
              // Text fields
              "SURVEY": TextEditingController(
                  text: cropData['survey']?.toString() ?? ''),
              "HISSA": TextEditingController(
                  text: cropData['Hissa']?.toString() ?? ''),
              "CROPNAME":
                  TextEditingController(text: cropData['cropName'] ?? ''),
              "CROPYEAR": TextEditingController(
                  text: cropData['cropYear']?.toString() ?? ''),
              "AREA": TextEditingController(
                  text: cropData['area']?.toString() ?? ''),
              "SEASON": TextEditingController(text: cropData['season'] ?? ''),
              "TYPEOFLAND":
                  TextEditingController(text: cropData['typeOfLand'] ?? ''),
              "SOURCEOFIRRIGATION": TextEditingController(
                  text: cropData['sourceOfIrrigation'] ?? ''),
              "COSTOFSEED": TextEditingController(
                  text: cropData['cost']?.toString() ?? ''),
              "ORGANICMANURENAME": TextEditingController(
                  text: cropData['organicManureName'] ?? ''),
              "ORGANICMANUREQUANTITY": TextEditingController(
                  text: cropData['organicManureQuantity']?.toString() ?? ''),
              "ORGANICMANURECOST": TextEditingController(
                  text: cropData['organicManureCost']?.toString() ?? ''),

              // Chemical Fertilizer fields (looping for multiple entries)
              "CHEMICALFERTILIZERNAME0": TextEditingController(
                  text: cropData['chemicalFertilizerName0'] ?? ''),
              "CHEMICALFERTILIZERBASAL0": TextEditingController(
                  text: cropData['chemicalFertilizerBasal0']?.toString() ?? ''),
              "CHEMICALFERTILIZERTOPDRESS0": TextEditingController(
                  text: cropData['chemicalFertilizerTopDress0']?.toString() ??
                      ''),
              "CHEMICALFERTILIZERTOTALQUANTITY0": TextEditingController(
                  text: cropData['chemicalFertilizerTotalQuantity0']
                          ?.toString() ??
                      ''),
              "CHEMICALFERTILIZERTOTALCOST0": TextEditingController(
                  text: cropData['chemicalFertilizerTotalCost0']?.toString() ??
                      ''),

              "CHEMICALFERTILIZERNAME1": TextEditingController(
                  text: cropData['chemicalFertilizerName1'] ?? ''),
              "CHEMICALFERTILIZERBASAL1": TextEditingController(
                  text: cropData['chemicalFertilizerBasal1']?.toString() ?? ''),
              "CHEMICALFERTILIZERTOPDRESS1": TextEditingController(
                  text: cropData['chemicalFertilizerTopDress1']?.toString() ??
                      ''),
              "CHEMICALFERTILIZERTOTALQUANTITY1": TextEditingController(
                  text: cropData['chemicalFertilizerTotalQuantity1']
                          ?.toString() ??
                      ''),
              "CHEMICALFERTILIZERTOTALCOST1": TextEditingController(
                  text: cropData['chemicalFertilizerTotalCost1']?.toString() ??
                      ''),
              "CHEMICALFERTILIZERNAME2": TextEditingController(
                  text: cropData['chemicalFertilizerName2'] ?? ''),
              "CHEMICALFERTILIZERBASAL2": TextEditingController(
                  text: cropData['chemicalFertilizerBasal2']?.toString() ?? ''),
              "CHEMICALFERTILIZERTOPDRESS2": TextEditingController(
                  text: cropData['chemicalFertilizerTopDress2']?.toString() ??
                      ''),
              "CHEMICALFERTILIZERTOTALQUANTITY2": TextEditingController(
                  text: cropData['chemicalFertilizerTotalQuantity2']
                          ?.toString() ??
                      ''),
              "CHEMICALFERTILIZERTOTALCOST2": TextEditingController(
                  text: cropData['chemicalFertilizerTotalCost2']?.toString() ??
                      ''),
              "CHEMICALFERTILIZERNAME3": TextEditingController(
                  text: cropData['chemicalFertilizerName3'] ?? ''),
              "CHEMICALFERTILIZERBASAL3": TextEditingController(
                  text: cropData['chemicalFertilizerBasal3']?.toString() ?? ''),
              "CHEMICALFERTILIZERTOPDRESS3": TextEditingController(
                  text: cropData['chemicalFertilizerTopDress3']?.toString() ??
                      ''),
              "CHEMICALFERTILIZERTOTALQUANTITY3": TextEditingController(
                  text: cropData['chemicalFertilizerTotalQuantity3']
                          ?.toString() ??
                      ''),
              "CHEMICALFERTILIZERTOTALCOST3": TextEditingController(
                  text: cropData['chemicalFertilizerTotalCost3']?.toString() ??
                      ''),
              // Other production costs
              "PLANTPROTECTIONCOST": TextEditingController(
                  text: cropData['plantProtectionCost']?.toString() ?? ''),
              "OWNLABOURNUMBER": TextEditingController(
                  text: cropData['ownLabourNumber']?.toString() ?? ''),
              "OWNLABOURTOTALCOST": TextEditingController(
                  text: cropData['ownLabourCost']?.toString() ?? ''),
              "HIREDLABOURNUMBER": TextEditingController(
                  text: cropData['hiredLabourNumber']?.toString() ?? ''),
              "HIREDLABOURCOST": TextEditingController(
                  text: cropData['hiredLabourCost']?.toString() ?? ''),
              "ANIMALDRAWNCOST": TextEditingController(
                  text: cropData['animalDrawnCost']?.toString() ?? ''),
              "ANIMALMECHANIZEDCOST": TextEditingController(
                  text: cropData['animalMechanizedCost']?.toString() ?? ''),
              "IRRIGATIONCOST": TextEditingController(
                  text: cropData['irrigationCost']?.toString() ?? ''),
              "OTHERPRODUCTIONCOST": TextEditingController(
                  text: cropData['otherProductionCost']?.toString() ?? ''),
              "TOTALPRODUCTIONCOST": TextEditingController(
                  text: cropData['totalProductionCost']?.toString() ?? ''),

              // Product returns
              "MAINPRODUCTQUANTITY": TextEditingController(
                  text: cropData['mainProductQuantity']?.toString() ?? ''),
              "MAINPRODUCTPRICE": TextEditingController(
                  text: cropData['mainProductPrice']?.toString() ?? ''),
              "TOTALMAINPRODUCTAMOUNT": TextEditingController(
                  text: cropData['totalProductAmount']?.toString() ?? ''),
              "BYPRODUCTQUANTITY": TextEditingController(
                  text: cropData['byProductQuantity']?.toString() ?? ''),
              "BYPRODUCTPRICE": TextEditingController(
                  text: cropData['byProductPrice']?.toString() ?? ''),
              "TOTALBYPRODUCTAMOUNT": TextEditingController(
                  text: cropData['totalByProductAmount']?.toString() ?? ''),
              "TOTALRETURNS": TextEditingController(
                  text: cropData['totalAmount']?.toString() ?? ''),
            });
          }
        }

        // Update UI with fetched data
        setState(() {
          farmerDetails = farmerData;

          // Initialize farmer details controllers
          controllers['farmerName'] =
              TextEditingController(text: farmerDetails!['farmerName']);
          controllers['email'] =
              TextEditingController(text: farmerDetails!['User'] ?? '');
          controllers['category'] =
              TextEditingController(text: farmerDetails!['category']);
          controllers['totalland'] = TextEditingController(
              text: farmerDetails!['totalland'].toString());
          controllers['landHolding'] =
              TextEditingController(text: farmerDetails!['landHolding']);
          controllers['fruitsId'] =
              TextEditingController(text: farmerDetails!['fruitsId']);

          // Initialize watershed controllers
          if (watershedData != null) {
            controllers['watershed_DISTRICT'] =
                TextEditingController(text: watershedData!['district']);
            controllers['watershed_SELECTEDCATEGORY'] =
                TextEditingController(text: watershedData!['selectedCategory']);
          }
        });

        return farmerData;
      } else {
        showDialog(
          context: context,
          builder: (context) => CustomAlertDialog(
            title: 'Error',
            content: "No farmer found for Aadhaar Number",
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        );
        // CustomAlertDialog
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text('No farmer found for Aadhaar Number')),
        // );
        return null;
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => CustomAlertDialog(
          title: 'Error',
          content: "'Error fetching farmer details: $e'",
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      );
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Error fetching farmer details: $e')),
      // );
      return null;
    }
  }

  Future<void> updateFarmerData() async {
    try {
      if (farmerDetails == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please search for a farmer first')),
        );
        return;
      }

      final farmerId = farmerDetails!['id'];
      final farmersCollection =
          FirebaseFirestore.instance.collection('farmers');
      final updatedFarmerData = {
        'farmerName': controllers['farmerName']?.text,
        'User': controllers['email']?.text,
        'totalland': double.tryParse(controllers['totalland']?.text ?? '0'),
        'landHolding': controllers['landHolding']?.text,
        'fruitsId': controllers['fruitsId']?.text,
      };

      // Update main farmer document
      await farmersCollection.doc(farmerId).update(updatedFarmerData);

      // Update watershed subcollection
      if (watershedData != null) {
        final watershedId = watershedData!['id']?.toString() ?? '';
        final updatedWatershedData = {
          'district': controllers['watershed_DISTRICT']?.text,
          'selectedCategory': controllers['watershed_SELECTEDCATEGORY']?.text,
        };

        await farmersCollection
            .doc(farmerId)
            .collection('watershed')
            .doc(watershedId)
            .update(updatedWatershedData);
      }

      // Update cropDetails subcollection
      final cropDetailsCollection =
          farmersCollection.doc(farmerId).collection('cropDetails');
      final cropDetailsSnapshot = await cropDetailsCollection.get();

      for (int i = 0; i < cropDetailsSnapshot.docs.length; i++) {
        final cropController = cropDetailsControllers[i];
        final cropId = cropDetailsSnapshot.docs[i].id;

        final updatedCropData = {
          "survey": int.tryParse(cropController['SURVEY']?.text ?? '0'),
          "Hissa": double.tryParse(cropController['HISSA']?.text ?? '0'),
          "cropArea": cropController['CROPNAME']?.text,
          "cropYear": int.tryParse(cropController['CROPYEAR']?.text ?? '0'),
          "area": double.tryParse(cropController['AREA']?.text ?? '0'),
          "season": cropController['SEASON']?.text,
          "typeOfLand": cropController['TYPEOFLAND']?.text,
          "sourceOfIrrigation": cropController['SOURCEOFIRRIGATION']?.text,
          "cost": int.tryParse(cropController['COSTOFSEED']?.text ?? '0'),
          "organicManureName": cropController['ORGANICMANURENAME']?.text,
          "organicManureQuantity": double.tryParse(
              cropController['ORGANICMANUREQUANTITY']?.text ?? '0'),
          "organicManureCost":
              double.tryParse(cropController['ORGANICMANURECOST']?.text ?? '0'),
          "chemicalFertilizerName0":
              cropController['CHEMICALFERTILIZERNAME0']?.text,
          "chemicalFertilizerBasal0": double.tryParse(
              cropController['CHEMICALFERTILIZERBASAL0']?.text ?? '0'),
          "chemicalFertilizerTopDress0": double.tryParse(
              cropController['CHEMICALFERTILIZERTOPDRESS0']?.text ?? '0'),
          "chemicalFertilizerTotalQuantity0": double.tryParse(
              cropController['CHEMICALFERTILIZERTOTALQUANTITY0']?.text ?? '0'),
          "chemicalFertilizerTotalCost0": double.tryParse(
              cropController['CHEMICALFERTILIZERTOTALCOST0']?.text ?? '0'),
          "chemicalFertilizerName1":
              cropController['CHEMICALFERTILIZERNAME1']?.text,
          "chemicalFertilizerBasal1": double.tryParse(
              cropController['CHEMICALFERTILIZERBASAL1']?.text ?? '0'),
          "chemicalFertilizerTopDress1": double.tryParse(
              cropController['CHEMICALFERTILIZERTOPDRESS1']?.text ?? '0'),
          "chemicalFertilizerTotalQuantity1": double.tryParse(
              cropController['CHEMICALFERTILIZERTOTALQUANTITY1']?.text ?? '0'),
          "chemicalFertilizerTotalCost1": double.tryParse(
              cropController['CHEMICALFERTILIZERTOTALCOST1']?.text ?? '0'),
          "chemicalFertilizerName2":
              cropController['CHEMICALFERTILIZERNAME2']?.text,
          "chemicalFertilizerBasal2": double.tryParse(
              cropController['CHEMICALFERTILIZERBASAL2']?.text ?? '0'),
          "chemicalFertilizerTopDress2": double.tryParse(
              cropController['CHEMICALFERTILIZERTOPDRESS2']?.text ?? '0'),
          "chemicalFertilizerTotalQuantity2": double.tryParse(
              cropController['CHEMICALFERTILIZERTOTALQUANTITY2']?.text ?? '0'),
          "chemicalFertilizerTotalCost2": double.tryParse(
              cropController['CHEMICALFERTILIZERTOTALCOST2']?.text ?? '0'),
          "chemicalFertilizerName3":
              cropController['CHEMICALFERTILIZERNAME3']?.text,
          "chemicalFertilizerBasal3": double.tryParse(
              cropController['CHEMICALFERTILIZERBASAL3']?.text ?? '0'),
          "chemicalFertilizerTopDress3": double.tryParse(
              cropController['CHEMICALFERTILIZERTOPDRESS3']?.text ?? '0'),
          "chemicalFertilizerTotalQuantity3": double.tryParse(
              cropController['CHEMICALFERTILIZERTOTALQUANTITY3']?.text ?? '0'),
          "chemicalFertilizerTotalCost3": double.tryParse(cropController[
                      'chemicalFCHEMICALFERTILIZERTOTALCOST3ertilizerTotalCost3Controller']
                  ?.text ??
              '0'),
          "plantProtectionCost": double.tryParse(
              cropController['PLANTPROTECTIONCOST']?.text ?? '0'),
          "ownLabourNumber":
              int.tryParse(cropController['OWNLABOURNUMBER']?.text ?? '0'),
          "ownLabourCost": double.tryParse(
              cropController['OWNLABOURTOTALCOST']?.text ?? '0'),
          "hiredLabourNumber":
              int.tryParse(cropController['HIREDLABOURNUMBER']?.text ?? '0'),
          "hiredLabourCost":
              double.tryParse(cropController['HIREDLABOURCOST']?.text ?? '0'),
          "animalDrawnCost":
              double.tryParse(cropController['ANIMALDRAWNCOST']?.text ?? '0'),
          "animalMechanizedCost": double.tryParse(
              cropController['ANIMALMECHANIZEDCOST']?.text ?? '0'),
          "irrigationCost":
              double.tryParse(cropController['IRRIGATIONCOST']?.text ?? '0'),
          "otherProductionCost": double.tryParse(
              cropController['OTHERPRODUCTIONCOST']?.text ?? '0'),
          "totalProductionCost": double.tryParse(
              cropController['TOTALPRODUCTIONCOST']?.text ?? '0'),
          "mainProductQuantity": double.tryParse(
              cropController['MAINPRODUCTQUANTITY']?.text ?? '0'),
          "mainProductPrice":
              double.tryParse(cropController['MAINPRODUCTPRICE']?.text ?? '0'),
          "totalProductAmount": double.tryParse(
              cropController['TOTALMAINPRODUCTAMOUNT']?.text ?? '0'),
          "byProductQuantity":
              double.tryParse(cropController['BYPRODUCTQUANTITY']?.text ?? '0'),
          "byProductPrice":
              double.tryParse(cropController['BYPRODUCTPRICE']?.text ?? '0'),
          "totalByProductAmount": double.tryParse(cropController[
                      'totalByProTOTALBYPRODUCTAMOUNTductAmountController']
                  ?.text ??
              '0'),
          "totalAmount":
              double.tryParse(cropController['TOTALRETURNS']?.text ?? '0'),
        };

        await cropDetailsCollection.doc(cropId).update(updatedCropData);
      }
      showDialog(
        context: context,
        builder: (context) => CustomAlertDialog(
          title: 'Done',
          content: "Farmer details updated successfully",
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => CustomAlertDialog(
          title: 'Error',
          content: "Error updating farmer details: $e",
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      );
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Error updating farmer details: $e')),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFEF8E0),
        appBar: AppBar(
          backgroundColor: const Color(0xFFFEF8E0),
          centerTitle: true,
          title: const Text(
            'Edit Farmer Details',
            style: TextStyle(
              color: Color(0xFFFB812C),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          iconTheme: const IconThemeData(color: Color(0xFFFB812C)),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextFormField(
                    labelText: "Aadhaar Number",
                    keyboardType: TextInputType.number,
                    controller: farmerAadhaarNumberController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please provide Aadhaar number";
                      }
                      if (value.length != 12) {
                        return "12 digits only";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await getFarmerDetailsByAadhaar(
                            farmerAadhaarNumberController.text);
                      }
                    },
                    child: const Text('Search Farmer'),
                  ),
                  const SizedBox(height: 20),
                  if (farmerDetails != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Watershed Details',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        if (watershedData != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextFormField(
                                labelText: 'District',
                                keyboardType: TextInputType.text,
                                controller: controllers['watershed_DISTRICT']!,
                              ),
                              const SizedBox(height: 10),
                              CustomTextFormField(
                                labelText: 'Selected Category',
                                keyboardType: TextInputType.text,
                                controller:
                                    controllers['watershed_SELECTEDCATEGORY']!,
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        const Text(
                          'Farmer Details',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        CustomTextFormField(
                          labelText: 'Farmer Name',
                          keyboardType: TextInputType.text,
                          controller: controllers['farmerName']!,
                        ),
                        const SizedBox(height: 10),
                        CustomTextFormField(
                          labelText: 'Email',
                          keyboardType: TextInputType.emailAddress,
                          controller: controllers['email']!,
                        ),
                        const SizedBox(height: 10),
                        CustomTextFormField(
                          labelText: 'Category',
                          keyboardType: TextInputType.text,
                          controller: controllers['category']!,
                        ),
                        const SizedBox(height: 10),
                        CustomTextFormField(
                          labelText: 'Total Land',
                          keyboardType: TextInputType.number,
                          controller: controllers['totalland']!,
                        ),
                        const SizedBox(height: 10),
                        CustomTextFormField(
                          labelText: 'Land Holding',
                          keyboardType: TextInputType.text,
                          controller: controllers['landHolding']!,
                        ),
                        const SizedBox(height: 10),
                        CustomTextFormField(
                          labelText: 'Fruits ID',
                          keyboardType: TextInputType.text,
                          controller: controllers['fruitsId']!,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Crop Details',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        if (cropDetailsControllers.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:
                                cropDetailsControllers.map((cropController) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 20),
                                  CustomTextFormField(
                                    labelText: 'Crop Name',
                                    keyboardType: TextInputType.text,
                                    controller: cropController['CROPNAME'] ??
                                        TextEditingController(),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextFormField(
                                    labelText: 'Survey',
                                    keyboardType: TextInputType.text,
                                    controller: cropController['SURVEY'] ??
                                        TextEditingController(),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextFormField(
                                    labelText: 'Hissa',
                                    keyboardType: TextInputType.text,
                                    controller: cropController['HISSA'] ??
                                        TextEditingController(),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextFormField(
                                    labelText: 'Crop Area',
                                    keyboardType: TextInputType.number,
                                    controller: cropController['AREA'] ??
                                        TextEditingController(),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextFormField(
                                    labelText: 'Crop Year',
                                    keyboardType: TextInputType.number,
                                    controller: cropController['CROPYEAR'] ??
                                        TextEditingController(),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextFormField(
                                    labelText: 'Season',
                                    keyboardType: TextInputType.text,
                                    controller: cropController['SEASON'] ??
                                        TextEditingController(),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextFormField(
                                    labelText: 'Type of Land',
                                    keyboardType: TextInputType.text,
                                    controller: cropController['TYPEOFLAND'] ??
                                        TextEditingController(),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextFormField(
                                    labelText: 'Source of Irrigation',
                                    keyboardType: TextInputType.text,
                                    controller:
                                        cropController['SOURCEOFIRRIGATION'] ??
                                            TextEditingController(),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextFormField(
                                    labelText: 'Cost of Seed',
                                    keyboardType: TextInputType.number,
                                    controller: cropController['COSTOFSEED'] ??
                                        TextEditingController(),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextFormField(
                                    labelText: 'Organic Manure Name',
                                    keyboardType: TextInputType.text,
                                    controller:
                                        cropController['ORGANICMANURENAME'] ??
                                            TextEditingController(),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextFormField(
                                    labelText: 'Organic Manure Quantity',
                                    keyboardType: TextInputType.number,
                                    controller: cropController[
                                            'ORGANICMANUREQUANTITY'] ??
                                        TextEditingController(),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextFormField(
                                    labelText: 'Organic Manure Cost',
                                    keyboardType: TextInputType.number,
                                    controller:
                                        cropController['ORGANICMANURECOST'] ??
                                            TextEditingController(),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextFormField(
                                    labelText: 'Chemical Fertilizer Name 0',
                                    keyboardType: TextInputType.text,
                                    controller: cropController[
                                            'CHEMICALFERTILIZERNAME0'] ??
                                        TextEditingController(),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextFormField(
                                    labelText: 'Chemical Fertilizer Basal 0',
                                    keyboardType: TextInputType.number,
                                    controller: cropController[
                                            'CHEMICALFERTILIZERBASAL0'] ??
                                        TextEditingController(),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextFormField(
                                    labelText:
                                        'Chemical Fertilizer Top Dress 0',
                                    keyboardType: TextInputType.number,
                                    controller: cropController[
                                            'CHEMICALFERTILIZERTOPDRESS0'] ??
                                        TextEditingController(),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextFormField(
                                    labelText:
                                        'Chemical Fertilizer Total Quantity 0',
                                    keyboardType: TextInputType.number,
                                    controller: cropController[
                                            'CHEMICALFERTILIZERTOTALQUANTITY0'] ??
                                        TextEditingController(),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextFormField(
                                    labelText:
                                        'Chemical Fertilizer Total Cost 0',
                                    keyboardType: TextInputType.number,
                                    controller: cropController[
                                            'CHEMICALFERTILIZERTOTALCOST0'] ??
                                        TextEditingController(),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextFormField(
                                    labelText: 'Chemical Fertilizer Name 1',
                                    keyboardType: TextInputType.text,
                                    controller: cropController[
                                            'CHEMICALFERTILIZERNAME1'] ??
                                        TextEditingController(),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextFormField(
                                    labelText: 'Chemical Fertilizer Basal 1',
                                    keyboardType: TextInputType.number,
                                    controller: cropController[
                                            'CHEMICALFERTILIZERBASAL1'] ??
                                        TextEditingController(),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextFormField(
                                    labelText:
                                        'Chemical Fertilizer Top Dress 1',
                                    keyboardType: TextInputType.number,
                                    controller: cropController[
                                            'CHEMICALFERTILIZERTOPDRESS1'] ??
                                        TextEditingController(),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextFormField(
                                    labelText:
                                        'Chemical Fertilizer Total Quantity 1',
                                    keyboardType: TextInputType.number,
                                    controller: cropController[
                                            'CHEMICALFERTILIZERTOTALQUANTITY1'] ??
                                        TextEditingController(),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextFormField(
                                    labelText:
                                        'Chemical Fertilizer Total Cost 1',
                                    keyboardType: TextInputType.number,
                                    controller: cropController[
                                            'CHEMICALFERTILIZERTOTALCOST1'] ??
                                        TextEditingController(),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextFormField(
                                    labelText: 'Chemical Fertilizer Name 2',
                                    keyboardType: TextInputType.text,
                                    controller: cropController[
                                            'CHEMICALFERTILIZERNAME2'] ??
                                        TextEditingController(),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextFormField(
                                    labelText: 'Chemical Fertilizer Basal 2',
                                    keyboardType: TextInputType.number,
                                    controller: cropController[
                                            'CHEMICALFERTILIZERBASAL2'] ??
                                        TextEditingController(),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextFormField(
                                    labelText:
                                        'Chemical Fertilizer Top Dress 2',
                                    keyboardType: TextInputType.number,
                                    controller: cropController[
                                            'CHEMICALFERTILIZERTOPDRESS2'] ??
                                        TextEditingController(),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextFormField(
                                    labelText:
                                        'Chemical Fertilizer Total Quantity 2',
                                    keyboardType: TextInputType.number,
                                    controller: cropController[
                                            'CHEMICALFERTILIZERTOTALQUANTITY2'] ??
                                        TextEditingController(),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextFormField(
                                    labelText:
                                        'Chemical Fertilizer Total Cost 2',
                                    keyboardType: TextInputType.number,
                                    controller: cropController[
                                            'CHEMICALFERTILIZERTOTALCOST2'] ??
                                        TextEditingController(),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextFormField(
                                    labelText: 'Chemical Fertilizer Name 3',
                                    keyboardType: TextInputType.text,
                                    controller: cropController[
                                            'CHEMICALFERTILIZERNAME3'] ??
                                        TextEditingController(),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextFormField(
                                    labelText: 'Chemical Fertilizer Basal 3',
                                    keyboardType: TextInputType.number,
                                    controller: cropController[
                                            'CHEMICALFERTILIZERBASAL3'] ??
                                        TextEditingController(),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextFormField(
                                    labelText:
                                        'Chemical Fertilizer Top Dress 3',
                                    keyboardType: TextInputType.number,
                                    controller: cropController[
                                            'CHEMICALFERTILIZERTOPDRESS3'] ??
                                        TextEditingController(),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextFormField(
                                    labelText:
                                        'Chemical Fertilizer Total Quantity 3',
                                    keyboardType: TextInputType.number,
                                    controller: cropController[
                                            'CHEMICALFERTILIZERTOTALQUANTITY3'] ??
                                        TextEditingController(),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextFormField(
                                    labelText:
                                        'Chemical Fertilizer Total Cost 3',
                                    keyboardType: TextInputType.number,
                                    controller: cropController[
                                            'CHEMICALFERTILIZERTOTALCOST3'] ??
                                        TextEditingController(),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextFormField(
                                    labelText: 'Plant Protection Cost',
                                    keyboardType: TextInputType.number,
                                    controller:
                                        cropController['PLANTPROTECTIONCOST'] ??
                                            TextEditingController(),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextFormField(
                                    labelText: 'Own Labour Number',
                                    keyboardType: TextInputType.text,
                                    controller:
                                        cropController['OWNLABOURNUMBER'] ??
                                            TextEditingController(),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextFormField(
                                    labelText: 'Own Labour Cost',
                                    keyboardType: TextInputType.number,
                                    controller:
                                        cropController['OWNLABOURTOTALCOST'] ??
                                            TextEditingController(),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextFormField(
                                    labelText: 'Hired Labour Number',
                                    keyboardType: TextInputType.number,
                                    controller:
                                        cropController['HIREDLABOURNUMBER'] ??
                                            TextEditingController(),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextFormField(
                                    labelText: 'Hired Labour Cost',
                                    keyboardType: TextInputType.number,
                                    controller:
                                        cropController['HIREDLABOURCOST'] ??
                                            TextEditingController(),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextFormField(
                                    labelText: 'Animal Drawn Cost',
                                    keyboardType: TextInputType.number,
                                    controller:
                                        cropController['ANIMALDRAWNCOST'] ??
                                            TextEditingController(),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextFormField(
                                    labelText: 'Animal Mechanized Cost',
                                    keyboardType: TextInputType.number,
                                    controller: cropController[
                                            'ANIMALMECHANIZEDCOST'] ??
                                        TextEditingController(),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextFormField(
                                    labelText: 'Irrigation Cost',
                                    keyboardType: TextInputType.number,
                                    controller:
                                        cropController['IRRIGATIONCOST'] ??
                                            TextEditingController(),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextFormField(
                                    labelText: 'Other Production Cost',
                                    keyboardType: TextInputType.number,
                                    controller:
                                        cropController['OTHERPRODUCTIONCOST'] ??
                                            TextEditingController(),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextFormField(
                                    labelText: 'Total Production Cost',
                                    keyboardType: TextInputType.number,
                                    controller:
                                        cropController['TOTALPRODUCTIONCOST'] ??
                                            TextEditingController(),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextFormField(
                                    labelText: 'Main Product Quantity',
                                    keyboardType: TextInputType.number,
                                    controller:
                                        cropController['MAINPRODUCTQUANTITY'] ??
                                            TextEditingController(),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextFormField(
                                    labelText: 'Main Product Price',
                                    keyboardType: TextInputType.number,
                                    controller:
                                        cropController['MAINPRODUCTPRICE'] ??
                                            TextEditingController(),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextFormField(
                                    labelText: 'Total Product Amount',
                                    keyboardType: TextInputType.number,
                                    controller: cropController[
                                            'TOTALMAINPRODUCTAMOUNT'] ??
                                        TextEditingController(),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextFormField(
                                    labelText: 'By Product Quantity',
                                    keyboardType: TextInputType.number,
                                    controller:
                                        cropController['BYPRODUCTQUANTITY'] ??
                                            TextEditingController(),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextFormField(
                                    labelText: 'By Product Price',
                                    keyboardType: TextInputType.number,
                                    controller:
                                        cropController['BYPRODUCTPRICE'] ??
                                            TextEditingController(),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextFormField(
                                    labelText: 'Total By Product Amount',
                                    keyboardType: TextInputType.number,
                                    controller: cropController[
                                            'TOTALBYPRODUCTAMOUNT'] ??
                                        TextEditingController(),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextFormField(
                                    labelText: 'Total Returns',
                                    keyboardType: TextInputType.number,
                                    controller:
                                        cropController['TOTALRETURNS'] ??
                                            TextEditingController(),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        const SizedBox(height: 20),
                        CustomTextButton(
                          text: 'Update Farmer Details',
                          buttonColor: const Color(0xFFFB812C),
                          onPressed: updateFarmerData,
                        )
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
