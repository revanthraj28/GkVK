import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:gkvk/shared/components/CustomTextButton.dart';
import 'package:gkvk/shared/components/CustomTextFormField.dart';
import 'package:gkvk/shared/components/SelectionButton.dart';
import 'package:gkvk/views/home/2ndcrop/newseason/surverypages2ndtime/surverypage.dart';
import 'package:intl/intl.dart';

class EnterCropDetails extends StatefulWidget {
  const EnterCropDetails({super.key});

  @override
  State<EnterCropDetails> createState() => _EnterCropDetailsState();
}

class _EnterCropDetailsState extends State<EnterCropDetails> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController farmerAadhaarNumberController =
      TextEditingController();
  final TextEditingController _cropNameController = TextEditingController();
  bool showDetailsButtons = false;

  final hissaController = TextEditingController();
  final SurveyNumber = TextEditingController();
  final _cropNumberController = TextEditingController();
  final _areaController = TextEditingController();
  final _varietyController = TextEditingController();
  final _durationController = TextEditingController();
  final _costController = TextEditingController();
  final _rdfNitrogenController = TextEditingController();
  final _rdfPhosphorousController = TextEditingController();
  final _rdfPotassiumController = TextEditingController();
  final _adjustedrdfNitrogenController = TextEditingController();
  final _adjustedrdfPhosphorousController = TextEditingController();
  final _adjustedrdfPotassiumController = TextEditingController();

  final _organicManureNameController = TextEditingController();
  final _organicManureQuantityController = TextEditingController();
  final _organicManureCostController = TextEditingController();

  final _bioFertilizerNameController = TextEditingController();
  final _bioFertilizerQuantityController = TextEditingController();
  final _bioFertilizerCostController = TextEditingController();

  final TextEditingController _plantProtectionCostController =
      TextEditingController();
  final TextEditingController _ownLabourNumberController =
      TextEditingController();
  final TextEditingController _ownLabourCostController =
      TextEditingController();
  final TextEditingController _hiredLabourNumberController =
      TextEditingController();
  final TextEditingController _hiredLabourCostController =
      TextEditingController();
  final TextEditingController _animalDrawnCostController =
      TextEditingController();
  final TextEditingController _animalMechanizedCostController =
      TextEditingController();
  final TextEditingController _irrigationCostController =
      TextEditingController();
  final TextEditingController _otherProductionCostController =
      TextEditingController();
  final TextEditingController _totalProductionCostController =
      TextEditingController();

  final TextEditingController _mainProductQuantityController =
      TextEditingController();
  final TextEditingController _mainProductPriceController =
      TextEditingController();
  // final TextEditingController _mainProductAmountController =
  //     TextEditingController();
  final TextEditingController _byProductQuantityController =
      TextEditingController();
  final TextEditingController _byProductPriceController =
      TextEditingController();
  final TextEditingController _totalByProductAmountController =
      TextEditingController();
  final TextEditingController _totalByProductAmountController1 =
      TextEditingController();
  final TextEditingController _totalByProductAmountController2 =
      TextEditingController();

  final RxString _selectedTypeOfLand = ''.obs;
  final RxString _selectedSeason = ''.obs;
  final RxString _selectedSourceOfIrrigation = ''.obs;
  final RxString _selectedNitrogen = ''.obs;
  final RxString _selectedPhosphorous = ''.obs;
  final RxString _selectedPotassium = ''.obs;
  final RxString _Methodsoffertilizer = ''.obs;

  final List<Map<String, TextEditingController>> chemicalFertilizers = [];
  int fertilizerCount = 0;

  @override
  void initState() {
    super.initState();
    addNewFertilizer();
  }

  void addNewFertilizer() {
    setState(() {
      fertilizerCount++;
      TextEditingController indexController = TextEditingController();
      indexController.text = fertilizerCount.toString(); // Set the text value
      chemicalFertilizers.add({
        "index": indexController, // Use TextEditingController for index
        "name": TextEditingController(),
        "basal": TextEditingController(),
        "topDress": TextEditingController(),
        "totalQuantity": TextEditingController(),
        "totalCost": TextEditingController(),
      });
    });
  }

  void _handleTypeOfLandSelection(String option) {
    _selectedTypeOfLand.value = option;
    if (option == 'Rain-fed') {
      _selectedSourceOfIrrigation.value = 'None';
    }
  }

  void _adjustRDFValues() {
    final adjustmentValues = {
      'Very low': 1.67,
      'Low': 1.33,
      'Medium': 1.0,
      'High': 0.67,
      'Very high': 0.33,
    };
    // Nitrogen adjustment
    if (_selectedNitrogen.value.isNotEmpty &&
        _rdfNitrogenController.text.isNotEmpty) {
      final nitrogenAdjustment =
          adjustmentValues[_selectedNitrogen.value] ?? 1.0;
      final rdfNitrogen = double.tryParse(_rdfNitrogenController.text) ?? 0.0;
      _adjustedrdfNitrogenController.text =
          (rdfNitrogen * nitrogenAdjustment).toStringAsFixed(2);
    }

    // Phosphorous adjustment
    if (_selectedPhosphorous.value.isNotEmpty &&
        _rdfPhosphorousController.text.isNotEmpty) {
      final phosphorousAdjustment =
          adjustmentValues[_selectedPhosphorous.value] ?? 1.0;
      final rdfPhosphorous =
          double.tryParse(_rdfPhosphorousController.text) ?? 0.0;
      _adjustedrdfPhosphorousController.text =
          (rdfPhosphorous * phosphorousAdjustment).toStringAsFixed(2);
    }

    // Potassium adjustment
    if (_selectedPotassium.value.isNotEmpty &&
        _rdfPotassiumController.text.isNotEmpty) {
      final potassiumAdjustment =
          adjustmentValues[_selectedPotassium.value] ?? 1.0;
      final rdfPotassium = double.tryParse(_rdfPotassiumController.text) ?? 0.0;
      _adjustedrdfPotassiumController.text =
          (rdfPotassium * potassiumAdjustment).toStringAsFixed(2);
    }
  }

  bool _validateControllers(BuildContext context) {
    List<String> emptyFields = [];

    // Check if all text controllers have non-empty values
    if (_cropNameController.text.isEmpty) {
      emptyFields.add('Crop Name');
    }
    if (_cropNumberController.text.isEmpty) {
      emptyFields.add('Crop Year');
    }
    if (_cropNumberController.text.length != 4) {
      emptyFields.add('Crop Year must be 4 digits');
    }
    if (_areaController.text.isEmpty) {
      emptyFields.add('Area');
    }
    if (_varietyController.text.isEmpty) {
      emptyFields.add('Variety');
    }
    if (_durationController.text.isEmpty) {
      emptyFields.add('Duration');
    }
    if (_costController.text.isEmpty) {
      emptyFields.add('Cost');
    }
    if (_rdfNitrogenController.text.isEmpty) {
      emptyFields.add('RDF Nitrogen');
    }
    if (_rdfPhosphorousController.text.isEmpty) {
      emptyFields.add('RDF Phosphorous');
    }
    if (_rdfPotassiumController.text.isEmpty) {
      emptyFields.add('RDF Potassium');
    }
    if (_adjustedrdfNitrogenController.text.isEmpty) {
      emptyFields.add('Adjusted RDF Nitrogen');
    }
    if (_adjustedrdfPhosphorousController.text.isEmpty) {
      emptyFields.add('Adjusted RDF Phosphorous');
    }
    if (_adjustedrdfPotassiumController.text.isEmpty) {
      emptyFields.add('Adjusted RDF Potassium');
    }
    if (_plantProtectionCostController.text.isEmpty) {
      emptyFields.add('Plant Protection Cost');
    }
    if (_ownLabourNumberController.text.isEmpty) {
      emptyFields.add('Own Labour Number');
    }
    if (_ownLabourCostController.text.isEmpty) {
      emptyFields.add('Own Labour Cost');
    }
    if (_hiredLabourNumberController.text.isEmpty) {
      emptyFields.add('Hired Labour Number');
    }
    if (_hiredLabourCostController.text.isEmpty) {
      emptyFields.add('Hired Labour Cost');
    }
    if (_animalDrawnCostController.text.isEmpty) {
      emptyFields.add('Animal Drawn Cost');
    }
    if (_animalMechanizedCostController.text.isEmpty) {
      emptyFields.add('Animal Mechanized Cost');
    }
    if (_irrigationCostController.text.isEmpty) {
      emptyFields.add('Irrigation Cost');
    }
    if (_otherProductionCostController.text.isEmpty) {
      emptyFields.add('Other Production Cost');
    }
    if (_totalProductionCostController.text.isEmpty) {
      emptyFields.add('Total Production Cost');
    }
    if (_mainProductPriceController.text.isEmpty) {
      emptyFields.add('Main Product Price');
    }
    if (_byProductQuantityController.text.isEmpty) {
      emptyFields.add('By-Product Quantity');
    }
    if (_byProductPriceController.text.isEmpty) {
      emptyFields.add('By-Product Price');
    }
    if (_totalByProductAmountController.text.isEmpty) {
      emptyFields.add('Total main amount');
    }
    if (_totalByProductAmountController1.text.isEmpty) {
      emptyFields.add('Total By-Product Amount');
    }
    if (_totalByProductAmountController2.text.isEmpty) {
      emptyFields.add('Total Amount');
    }

    // Check if any field is empty, if yes, show alert and return false
    if (emptyFields.isNotEmpty) {
      _showEmptyFieldsAlert(context, emptyFields);
      return false;
    }

    return true;
  }

  bool _validateForm() {
    // Check if the form fields are valid
    if (!_formKey.currentState!.validate()) {
      return false;
    }

    // Check if dropdowns are selected
    if (_selectedSeason.value.isEmpty ||
        _selectedTypeOfLand.value.isEmpty ||
        _selectedSourceOfIrrigation.value.isEmpty ||
        _selectedNitrogen.value.isEmpty ||
        _selectedPhosphorous.value.isEmpty ||
        _selectedPotassium.value.isEmpty ||
        _Methodsoffertilizer.value.isEmpty) {
      return false;
    }

    return true;
  }

  void calculateTotal() {
    double total = 0.0;
    total += double.tryParse(_costController.text) ?? 0.0;
    total += double.tryParse(_organicManureCostController.text) ?? 0.0;
    total += double.tryParse(_bioFertilizerCostController.text) ?? 0.0;
    total += double.tryParse(_plantProtectionCostController.text) ?? 0.0;
    total += double.tryParse(_ownLabourCostController.text) ?? 0.0;
    total += double.tryParse(_hiredLabourCostController.text) ?? 0.0;
    total += double.tryParse(_animalDrawnCostController.text) ?? 0.0;
    total += double.tryParse(_animalMechanizedCostController.text) ?? 0.0;
    total += double.tryParse(_irrigationCostController.text) ?? 0.0;
    total += double.tryParse(_otherProductionCostController.text) ?? 0.0;

    for (var fertilizer in chemicalFertilizers) {
      total += double.tryParse(fertilizer['totalCost']!.text) ?? 0.0;
    }

    // Update the total production cost controller
    _totalProductionCostController.text = total.toStringAsFixed(2);
  }

  void _updateTotalMainProductAmount() {
    final quantity = double.tryParse(_mainProductPriceController.text) ?? 0.0;
    final price = double.tryParse(_mainProductQuantityController.text) ?? 0.0;
    final total = quantity * price;
    _totalByProductAmountController.text = total.toStringAsFixed(2);
    _updateTotalReturns();
  }

  void _updateTotalByProductAmount() {
    final quantity = double.tryParse(_byProductQuantityController.text) ?? 0.0;
    final price = double.tryParse(_byProductPriceController.text) ?? 0.0;
    final total = quantity * price;
    _totalByProductAmountController1.text = total.toStringAsFixed(2);
    _updateTotalReturns();
  }

  void _updateTotalReturns() {
    final mainProductTotal =
        double.tryParse(_totalByProductAmountController.text) ?? 0.0;
    final byProductTotal =
        double.tryParse(_totalByProductAmountController1.text) ?? 0.0;
    final totalReturns = mainProductTotal + byProductTotal;
    _totalByProductAmountController2.text = totalReturns.toStringAsFixed(2);
  }

  void _showEmptyFieldsAlert(BuildContext context, List<String> emptyFields) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          backgroundColor: const Color(0xFFFEF8E0),
          title: const Text(
            'Alert',
            style: TextStyle(
              color: Color(0xFFFB812C),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'The following fields must be filled:\n${emptyFields.join('\n')}',
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
          actions: [
            TextButton(
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Color(0xFFFB812C),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  final List<String> cropNames = [
    "banana",
    "chickpea",
    "cotton",
    "chilli",
    "groundnut",
    "ragi",
    "pigeonpea",
    "soyabean",
    "pigeonpea_soyabean",
    "sunflower",
    "tomato",
    "turmeric",
  ];

  List<Map<String, dynamic>> _cropDetails = [];
  Map<String, dynamic> watershedDetails = {};

  // Fetch crop details for a farmer based on Aadhaar number
  Future<List<Map<String, dynamic>>> getCropDetails(
      String aadhaarNumber) async {
    try {
      // Query the farmer's document by Aadhaar number
      QuerySnapshot farmerSnapshot = await FirebaseFirestore.instance
          .collection('farmers')
          .where('aadharNumber', isEqualTo: int.parse(aadhaarNumber))
          .get();

      if (farmerSnapshot.docs.isEmpty) {
        throw Exception("Farmer not found.");
      }

      // Get the farmer's document ID
      DocumentSnapshot farmerDoc = farmerSnapshot.docs.first;
      String farmerId = farmerDoc.id;

      // Print farmer details
      Map<String, dynamic> farmerData =
          farmerDoc.data() as Map<String, dynamic>;
      // Get farmer document and ID
      QuerySnapshot watershedSnapshot = await FirebaseFirestore.instance
          .collection('farmers')
          .doc(farmerId)
          .collection('watershed')
          .get();

      // _setFarmerDetailsToControllers(farmerDoc);

      // 5. Set Watershed Details into Controllers
      // _setWatershedDetailsToControllers(watershedDetails);
      if (watershedSnapshot.docs.isNotEmpty) {
        watershedDetails =
            watershedSnapshot.docs.first.data() as Map<String, dynamic>;
      }

      // Fetch cropDetails from the subcollection
      QuerySnapshot cropDetailsSnapshot = await FirebaseFirestore.instance
          .collection('farmers')
          .doc(farmerId)
          .collection('cropDetails')
          .get();

      return cropDetailsSnapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();
    } catch (e) {
      throw Exception("Error fetching crop details: $e");
    }
  }

  String formatDate(DateTime dateTime) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(dateTime);
  }

  // Function to add a new crop detail
  Future<void> addNewCropDetail(String aadhaarNumber) async {
    try {
      // Query the farmer's document by Aadhaar number
      QuerySnapshot farmerSnapshot = await FirebaseFirestore.instance
          .collection('farmers')
          .where('aadharNumber', isEqualTo: int.parse(aadhaarNumber))
          .get();

      if (farmerSnapshot.docs.isEmpty) {
        throw Exception("Farmer not found.");
      }

      // Get the farmer's document ID
      String farmerId = farmerSnapshot.docs.first.id;
      String formattedTimestamp = formatDate(DateTime.now());

      // Prepare the crop detail data
      Map<String, dynamic> newCropDetail = {
        'createdAt': formattedTimestamp,
        'cropName': _cropNameController.text.trim(),
        'cropYear': int.tryParse(_cropNumberController.text) ?? 0,
        'area': double.tryParse(_areaController.text) ?? 0.0,
        'Hissa': hissaController.text.trim(), //
        'survey': SurveyNumber.text.trim(), //
        'variety': _varietyController.text.trim(),
        'duration': int.tryParse(_durationController.text) ?? 0,
        'season': _selectedSeason.value,
        'newSeason': 2,
        'typeOfLand': _selectedTypeOfLand.value, //
        'sourceOfIrrigation': _selectedSourceOfIrrigation.value,
        'cost': int.tryParse(_costController.text) ?? 0,
        'nitrogen': _selectedNitrogen.value,
        'phosphorous': _selectedPhosphorous.value,
        'potassium': _selectedPotassium.value,
        'rdfNitrogen': double.tryParse(_rdfNitrogenController.text) ?? 0.0,
        'rdfPhosphorous':
            double.tryParse(_rdfPhosphorousController.text) ?? 0.0,
        'rdfPotassium': double.tryParse(_rdfPotassiumController.text) ?? 0.0,
        'adjustedrdfNitrogen':
            double.tryParse(_adjustedrdfNitrogenController.text) ?? 0.0,
        'adjustedrdfPhosphorous':
            double.tryParse(_adjustedrdfPhosphorousController.text) ?? 0.0,
        'adjustedrdfPotassium':
            double.tryParse(_adjustedrdfPotassiumController.text) ?? 0.0,
        'organicManureName': _organicManureNameController.text.trim(),
        'organicManureQuantity':
            double.tryParse(_organicManureQuantityController.text) ?? 0.0,
        'organicManureCost':
            double.tryParse(_organicManureCostController.text) ?? 0.0,
        'bioFertilizerName': _bioFertilizerNameController.text.trim(),
        'bioFertilizerQuantity':
            double.tryParse(_bioFertilizerQuantityController.text) ?? 0.0,
        'bioFertilizerCost':
            double.tryParse(_bioFertilizerCostController.text) ?? 0.0,
        'plantProtectionCost':
            double.tryParse(_plantProtectionCostController.text) ?? 0.0,
        'ownLabourNumber': int.tryParse(_ownLabourNumberController.text) ?? 0,
        'ownLabourCost': double.tryParse(_ownLabourCostController.text) ?? 0.0,
        'hiredLabourNumber':
            int.tryParse(_hiredLabourNumberController.text) ?? 0,
        'hiredLabourCost':
            double.tryParse(_hiredLabourCostController.text) ?? 0.0,
        'animalDrawnCost':
            double.tryParse(_animalDrawnCostController.text) ?? 0.0,
        'animalMechanizedCost':
            double.tryParse(_animalMechanizedCostController.text) ?? 0.0,
        'irrigationCost':
            double.tryParse(_irrigationCostController.text) ?? 0.0,
        'otherProductionCost':
            double.tryParse(_otherProductionCostController.text) ?? 0.0,
        'totalProductionCost':
            double.tryParse(_totalProductionCostController.text) ?? 0.0,
        'mainProductQuantity':
            double.tryParse(_mainProductQuantityController.text) ?? 0.0,
        'mainProductPrice':
            double.tryParse(_mainProductPriceController.text) ?? 0.0,
        'totalProductAmount':
            double.tryParse(_totalByProductAmountController.text) ?? 0.0,
        'byProductQuantity':
            double.tryParse(_byProductQuantityController.text) ?? 0.0,
        'byProductPrice':
            double.tryParse(_byProductPriceController.text) ?? 0.0,
        'totalByProductAmount':
            double.tryParse(_totalByProductAmountController1.text) ?? 0.0,
        'totalAmount':
            double.tryParse(_totalByProductAmountController2.text) ?? 0.0,
        'methodsoffertilizer': _Methodsoffertilizer.value,
      };

      // Add chemical fertilizers details
      for (var i = 0; i < chemicalFertilizers.length; i++) {
        newCropDetail['chemicalFertilizerName$i'] =
            chemicalFertilizers[i]['name']?.text.trim() ?? '';
        newCropDetail['chemicalFertilizerBasal$i'] =
            double.tryParse(chemicalFertilizers[i]['basal']?.text ?? '') ?? 0.0;
        newCropDetail['chemicalFertilizerTopDress$i'] =
            double.tryParse(chemicalFertilizers[i]['topDress']?.text ?? '') ??
                0.0;
        newCropDetail['chemicalFertilizerTotalQuantity$i'] = double.tryParse(
                chemicalFertilizers[i]['totalQuantity']?.text ?? '') ??
            0.0;
        newCropDetail['chemicalFertilizerTotalCost$i'] =
            double.tryParse(chemicalFertilizers[i]['totalCost']?.text ?? '') ??
                0.0;
      }

      // Add the new crop detail to the farmer's cropDetails subcollection
      await FirebaseFirestore.instance
          .collection('farmers')
          .doc(farmerId)
          .collection('cropDetails')
          .add(newCropDetail);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Crop detail added successfully!")),
      );

      // Clear the input fields
      _cropNameController.clear();
      hissaController.clear();
      _areaController.clear();
      _cropNumberController.clear();
      SurveyNumber.clear();
      _varietyController.clear();
      _durationController.clear();
      _selectedSeason.value = "";
      _selectedTypeOfLand.value = "";
      _selectedSourceOfIrrigation.value = "";
      _costController.clear();
      _rdfNitrogenController.clear();
      _rdfPhosphorousController.clear();
      _rdfPotassiumController.clear();
      _adjustedrdfNitrogenController.clear();
      _adjustedrdfPhosphorousController.clear();
      _adjustedrdfPotassiumController.clear();
      _organicManureNameController.clear();
      _organicManureQuantityController.clear();
      _organicManureCostController.clear();
      _bioFertilizerNameController.clear();
      _bioFertilizerQuantityController.clear();
      _bioFertilizerCostController.clear();
      _plantProtectionCostController.clear();
      _ownLabourNumberController.clear();
      _ownLabourCostController.clear();
      _hiredLabourNumberController.clear();
      _hiredLabourCostController.clear();
      _animalDrawnCostController.clear();
      _animalMechanizedCostController.clear();
      _irrigationCostController.clear();
      _otherProductionCostController.clear();
      _totalProductionCostController.clear();
      _mainProductQuantityController.clear();
      _mainProductPriceController.clear();
      _totalByProductAmountController.clear();
      _byProductQuantityController.clear();
      _byProductPriceController.clear();
      _totalByProductAmountController1.clear();
      _totalByProductAmountController2.clear();

      for (var i = 0; i < chemicalFertilizers.length; i++) {
        chemicalFertilizers[i]['name']?.clear();
        chemicalFertilizers[i]['basal']?.clear();
        chemicalFertilizers[i]['topDress']?.clear();
        chemicalFertilizers[i]['totalQuantity']?.clear();
        chemicalFertilizers[i]['totalCost']?.clear();
      }
      // Refresh the crop details
      List<Map<String, dynamic>> cropDetails =
          await getCropDetails(aadhaarNumber);
      setState(() {
        _cropDetails = cropDetails;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error adding crop detail: $e")),
      );
    }
  }

  // Function to display crop details in an alert dialog
  void showCropDetailsDialog(
      BuildContext context, Map<String, dynamic> cropData) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Crop Detail"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: cropData.entries
                  .map((entry) => Text("${entry.key}: ${entry.value}"))
                  .toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  dynamic getFarmerDetails(String aadhaarNumber) async {
    try {
      QuerySnapshot farmerSnapshot = await FirebaseFirestore.instance
          .collection('farmers')
          .where('aadharNumber', isEqualTo: int.parse(aadhaarNumber))
          .get();

      if (farmerSnapshot.docs.isEmpty) {
        return null; // No farmer found
      }

      // Return the farmer document data
      return farmerSnapshot.docs.first.data();
    } catch (e) {
      throw Exception("Error fetching farmer details: \$e");
    }
  }

// Show Farmer Details Dialog
  void showFarmerDetailsDialog(
      BuildContext context, Map<String, dynamic> farmerDetails) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Farmer Details"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: farmerDetails.entries
                  .map((entry) => Text("${entry.key}: ${entry.value}"))
                  .toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> getWatershedDetails(
      String aadhaarNumber) async {
    try {
      QuerySnapshot farmerSnapshot = await FirebaseFirestore.instance
          .collection('farmers')
          .where('aadharNumber', isEqualTo: int.parse(aadhaarNumber))
          .get();

      if (farmerSnapshot.docs.isEmpty) {
        throw Exception("Farmer not found.");
      }

      // Get the farmer's document ID
      String farmerId = farmerSnapshot.docs.first.id;

      // Fetch watershed details
      QuerySnapshot watershedSnapshot = await FirebaseFirestore.instance
          .collection('farmers')
          .doc(farmerId)
          .collection('watershed')
          .get();

      return watershedSnapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();
    } catch (e) {
      throw Exception("Error fetching watershed details: \$e");
    }
  }

// Show Watershed Details Dialog
  void showWatershedDetailsDialog(
      BuildContext context, List<Map<String, dynamic>> watershedDetails) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Watershed Details"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: watershedDetails.map((detail) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: detail.entries
                        .map((entry) => Text("${entry.key}: ${entry.value}"))
                        .toList(),
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
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
            'Crop Details',
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
                  CustomTextButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            showDetailsButtons = true;
                          });
                          try {
                            List<Map<String, dynamic>> cropDetails =
                                await getCropDetails(
                              farmerAadhaarNumberController.text,
                            );

                            if (cropDetails.isEmpty) {
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("No crop details found.")),
                              );
                            } else {
                              setState(() {
                                _cropDetails = cropDetails; // Save details
                              });
                            }
                          } catch (e) {
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }
                        }
                      },
                      text: 'Search Farmer'
                      //child: const Text('Search Farmer'),
                      ),
                  const SizedBox(height: 20),
                  if (showDetailsButtons) ...[
                    CustomTextButton(
                      onPressed: () async {
                        try {
                          dynamic farmerDetails = await getFarmerDetails(
                              farmerAadhaarNumberController.text);

                          if (farmerDetails == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Farmer not found.")),
                            );
                          } else {
                            showFarmerDetailsDialog(context, farmerDetails);
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())),
                          );
                        }
                      },
                      text: 'Show Farmer Details',
                    ),
                    const SizedBox(height: 20),
                    CustomTextButton(
                      onPressed: () async {
                        try {
                          List<Map<String, dynamic>> watershedDetails =
                              await getWatershedDetails(
                                  farmerAadhaarNumberController.text);

                          if (watershedDetails.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("No watershed details found.")),
                            );
                          } else {
                            showWatershedDetailsDialog(
                                context, watershedDetails);
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())),
                          );
                        }
                      },
                      text: 'Show Watershed Details',
                    ),
                  ],
                  const SizedBox(height: 20),
                  if (_cropDetails.isNotEmpty)
                    Column(
                      children: _cropDetails.asMap().entries.map((entry) {
                        int index = entry.key;
                        Map<String, dynamic> crop = entry.value;

                        String cropName = crop['cropName'] ?? 'Unknown';

                        return CustomTextButton(
                          onPressed: () {
                            // Populate the text fields directly
                            _cropNameController.text =
                                crop['cropName']?.toString() ?? '';
                            print(_cropNameController.text);
                            hissaController.text =
                                crop['Hissa']?.toString() ?? '';
                            SurveyNumber.text =
                                crop['survey']?.toString() ?? '';
                            _selectedNitrogen.value =
                                crop['nitrogen']?.toString() ?? '';
                            _selectedPhosphorous.value =
                                crop['phosphorous']?.toString() ?? '';
                            _selectedPotassium.value =
                                crop['potassium']?.toString() ?? '';
                            _rdfNitrogenController.text =
                                crop['rdfNitrogen']?.toString() ?? '';
                            _rdfPhosphorousController.text =
                                crop['rdfPhosphorous']?.toString() ?? '';
                            _rdfPotassiumController.text =
                                crop['rdfPotassium']?.toString() ?? '';
                            _adjustedrdfNitrogenController.text =
                                crop['adjustedrdfNitrogen']?.toString() ?? '';
                            _adjustedrdfPhosphorousController.text =
                                crop['adjustedrdfPhosphorous']?.toString() ??
                                    '';
                            _adjustedrdfPotassiumController.text =
                                crop['adjustedrdfPotassium']?.toString() ?? '';
                          },
                          text: ("Crop: $cropName"),
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 20),
                  const Text(
                    "Add New Crop Detail",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFB812C),
                    ),
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Crop Name",
                      border: OutlineInputBorder(),
                    ),
                    items: cropNames.map((String crop) {
                      return DropdownMenuItem<String>(
                        value: crop,
                        child: Text(crop),
                      );
                    }).toList(),
                    onChanged: (value) {
                      _cropNameController.text = value ?? '';
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please select a crop";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    labelText: "Hissa",
                    controller: hissaController,
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    labelText: "SurveyNumber",
                    controller: SurveyNumber,
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  CustomTextFormField(
                    labelText: "Crop Year",
                    controller: _cropNumberController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please provide details";
                      }
                      if (value.length != 4) {
                        return "4 digits only";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextFormField(
                    labelText: "Total cultivated land in Guntas",
                    controller: _areaController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "1 acre is 40 Guntas";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextFormField(
                    labelText: "Variety of crop",
                    controller: _varietyController,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please provide details";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextFormField(
                    labelText: "Duration ",
                    controller: _durationController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please provide in days";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  Obx(() => SelectionButton(
                        label: "Season",
                        options: const ['Kharif', 'Rabi', 'Summer'],
                        selectedOption: _selectedSeason.value.isEmpty
                            ? null
                            : _selectedSeason.value,
                        onPressed: (option) {
                          _selectedSeason.value = option;
                        },
                        errorMessage: _selectedSeason.value.isEmpty
                            ? 'Please select (Kharif/ Rabi/ Summer)'
                            : null,
                      )),
                  const SizedBox(height: 20.0),
                  Obx(() => SelectionButton(
                        label: "Type of land",
                        options: const ['Rain-fed', 'Irrigated'],
                        selectedOption: _selectedTypeOfLand.value.isEmpty
                            ? null
                            : _selectedTypeOfLand.value,
                        onPressed: (option) {
                          _handleTypeOfLandSelection(option);
                        },
                        errorMessage: _selectedTypeOfLand.value.isEmpty
                            ? 'Please select (Rainfed/irrigated)'
                            : null,
                      )),
                  const SizedBox(height: 20.0),
                  Obx(() => SelectionButton(
                        label: "Source of irrigation",
                        options: _selectedTypeOfLand.value == 'Rain-fed'
                            ? const ['None']
                            : const ['Borewell', 'Tank', 'Canal', 'Others'],
                        selectedOption:
                            _selectedSourceOfIrrigation.value.isEmpty
                                ? null
                                : _selectedSourceOfIrrigation.value,
                        onPressed: (option) {
                          _selectedSourceOfIrrigation.value = option;
                        },
                        errorMessage: _selectedSourceOfIrrigation.value.isEmpty
                            ? 'Please select (borewell/ tank/ canal/ others)'
                            : null,
                      )),
                  const SizedBox(height: 20.0),
                  CustomTextFormField(
                    labelText: "Cost of seed (including own seed)(in Rs.)",
                    controller: _costController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please provide details";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    'Fertility status according to LRI card',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20.0),
                  Obx(() => SelectionButton(
                        label: 'Nitrogen',
                        options: const [
                          'Very low',
                          'Low',
                          'Medium',
                          'High',
                          'Very high'
                        ],
                        selectedOption: _selectedNitrogen.value.isEmpty
                            ? null
                            : _selectedNitrogen.value,
                        onPressed: (option) {
                          _selectedNitrogen.value = option;
                          _adjustRDFValues();
                        },
                        errorMessage: _selectedNitrogen.value.isEmpty
                            ? 'Please select(very low/low/medium/high/very high)'
                            : null,
                      )),
                  const SizedBox(height: 20.0),
                  Obx(() => SelectionButton(
                        label: 'Phosphorous',
                        options: const [
                          'Very low',
                          'Low',
                          'Medium',
                          'High',
                          'Very high'
                        ],
                        selectedOption: _selectedPhosphorous.value.isEmpty
                            ? null
                            : _selectedPhosphorous.value,
                        onPressed: (option) {
                          _selectedPhosphorous.value = option;
                          _adjustRDFValues();
                        },
                        errorMessage: _selectedPhosphorous.value.isEmpty
                            ? 'Please select (very low/low/medium/high/very high)'
                            : null,
                      )),
                  const SizedBox(height: 20.0),
                  Obx(() => SelectionButton(
                        label: 'Potassium',
                        options: const [
                          'Very low',
                          'Low',
                          'Medium',
                          'High',
                          'Very high'
                        ],
                        selectedOption: _selectedPotassium.value.isEmpty
                            ? null
                            : _selectedPotassium.value,
                        onPressed: (option) {
                          _selectedPotassium.value = option;
                          _adjustRDFValues();
                        },
                        errorMessage: _selectedPotassium.value.isEmpty
                            ? 'Please select(very low/low/medium/high/very high)'
                            : null,
                      )),
                  const SizedBox(height: 20.0),
                  const Text(
                    'RDF of crop',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextFormField(
                    labelText: "Nitrogen",
                    controller: _rdfNitrogenController,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      _adjustRDFValues();
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please provide details (kg/ac)";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextFormField(
                    labelText: "Phosphorous",
                    controller: _rdfPhosphorousController,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      _adjustRDFValues();
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please provide details (kg/ac)";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextFormField(
                    labelText: "Potassium",
                    controller: _rdfPotassiumController,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      _adjustRDFValues();
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please provide details (kg/ac)";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    'Adjusted RDF of crop',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextFormField(
                    labelText: "Nitrogen",
                    controller: _adjustedrdfNitrogenController,
                    keyboardType: TextInputType.number,
                    enabled: false,
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextFormField(
                    labelText: "Phosphorous",
                    controller: _adjustedrdfPhosphorousController,
                    keyboardType: TextInputType.number,
                    enabled: false,
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextFormField(
                    labelText: "Potassium",
                    controller: _adjustedrdfPotassiumController,
                    keyboardType: TextInputType.number,
                    enabled: false,
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    'Manures and fertilizers',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    'Organic manures',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFB812C)),
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextFormField(
                    labelText: "Name",
                    controller: _organicManureNameController,
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextFormField(
                    labelText: "Quantity (in tonnes)",
                    controller: _organicManureQuantityController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextFormField(
                    labelText: "Cost (in Rs.)",
                    controller: _organicManureCostController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    'Bio-fertilizers',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFB812C)),
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextFormField(
                    labelText: "Name",
                    controller: _bioFertilizerNameController,
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextFormField(
                    labelText: "Quantity (in kgs)",
                    controller: _bioFertilizerQuantityController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextFormField(
                    labelText: "Cost (in Rs.)",
                    controller: _bioFertilizerCostController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    'Chemical fertilizers',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  ...chemicalFertilizers.asMap().entries.map((entry) {
                    int index = entry.key + 1; // Index starts from 1
                    Map<String, TextEditingController> fertilizer = entry.value;
                    return Column(
                      children: [
                        Text(
                          'Fertilizer $index', // Displaying the index
                          style: const TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        CustomTextFormField(
                          labelText: "Name",
                          controller: fertilizer['name']!,
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(height: 20.0),
                        CustomTextFormField(
                          labelText: "Basal dose (in kgs)",
                          controller: fertilizer['basal']!,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 20.0),
                        CustomTextFormField(
                          labelText: "Top dress (in kgs)",
                          controller: fertilizer['topDress']!,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 20.0),
                        CustomTextFormField(
                          labelText: "Total quantity (in kgs)",
                          controller: fertilizer['totalQuantity']!,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 20.0),
                        CustomTextFormField(
                          labelText: "Total cost (in Rs.)",
                          controller: fertilizer['totalCost']!,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 20.0),
                      ],
                    );
                  }),
                  CustomTextButton(
                    text: "Add new fertilizer",
                    buttonColor: Colors.black,
                    onPressed: addNewFertilizer,
                  ),
                  const SizedBox(height: 20.0),
                  Obx(() => SelectionButton(
                        label: 'Method of application of fertilizers',
                        options: const ['Broadcasting', 'line', 'band', 'spot'],
                        selectedOption: _Methodsoffertilizer.value.isEmpty
                            ? null
                            : _Methodsoffertilizer.value,
                        onPressed: (option) {
                          _Methodsoffertilizer.value = option;
                        },
                        errorMessage: _Methodsoffertilizer.value.isEmpty
                            ? 'Please select (broadcasting/ line/ band/ spot)'
                            : null,
                      )),
                  const SizedBox(height: 20.0),
                  CustomTextFormField(
                    labelText: "Plant Protection Cost",
                    controller: _plantProtectionCostController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please provide details (in Rs.)";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    'Labour Details',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextFormField(
                    labelText: "Own Labour",
                    controller: _ownLabourNumberController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please provide details (in number)";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextFormField(
                    labelText: "Cost ",
                    controller: _ownLabourCostController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please provide details (in Rs.)";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextFormField(
                    labelText: "Hired Labour",
                    controller: _hiredLabourNumberController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please provide details (in number)";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextFormField(
                    labelText: "Cost ",
                    controller: _hiredLabourCostController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please provide details (in Rs.)";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextFormField(
                    labelText: "Cost of animal drawn work",
                    controller: _animalDrawnCostController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please provide details (Rs.)";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextFormField(
                    labelText: "Cost of mechanized works",
                    controller: _animalMechanizedCostController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please provide details (Rs.)";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextFormField(
                    labelText: "Irrigation cost ",
                    controller: _irrigationCostController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please provide details(in Rs.)";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextFormField(
                    labelText: "Other production cost, if any ",
                    controller: _otherProductionCostController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please provide details(Rs.)";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextButton(
                      text: "TOTAL",
                      buttonColor: Colors.black,
                      onPressed: calculateTotal),
                  const SizedBox(height: 20.0),
                  CustomTextFormField(
                    labelText: "Total cost of production",
                    controller: _totalProductionCostController,
                    keyboardType: TextInputType.number,
                    enabled: false, // Make it non-editable
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please provide details";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    'Returns',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextFormField(
                    labelText: "Quantity of main product",
                    controller: _mainProductQuantityController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please provide details (in quintal)";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _updateTotalMainProductAmount();
                    },
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextFormField(
                    labelText: "Price/unit ",
                    controller: _mainProductPriceController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please provide details (in Rs.)";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _updateTotalMainProductAmount();
                    },
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextFormField(
                    labelText: "Total main product amount(in quintal)",
                    controller: _totalByProductAmountController,
                    keyboardType: TextInputType.number,
                    enabled: false, // Make this field non-editable
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextFormField(
                    labelText: "Quantity of By-products",
                    controller: _byProductQuantityController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please provide details (in tons)";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _updateTotalByProductAmount();
                    },
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextFormField(
                    labelText: "Price/unit ",
                    controller: _byProductPriceController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please provide details (in Rs.)";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _updateTotalByProductAmount();
                    },
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextFormField(
                    labelText: "Total By-product amount(in Rs.)",
                    controller: _totalByProductAmountController1,
                    keyboardType: TextInputType.number,
                    enabled: false, // Make this field non-editable
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextFormField(
                    labelText: "Total returns(Rs.)",
                    controller: _totalByProductAmountController2,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please provide details";
                      }
                      return null;
                    },
                    enabled: false,
                  ),
                  const SizedBox(height: 20),
                  CustomTextButton(
                    onPressed: () {
                      // Perform both validations
                      if (_validateControllers(context) && _validateForm()) {
                        // Both validations passed, proceed to send data to Firebase
                        if (_formKey.currentState!.validate()) {
                          addNewCropDetail(
                            farmerAadhaarNumberController.text,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Crop details added successfully!')),
                          );
                        }
                      } else {
                        // If validation fails, show an error message
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Please fill all required fields correctly.')),
                        );
                      }
                    },
                    buttonColor: const Color(0xFFFB812C),
                    text: "Add Crop Detail",
                  ),
                  CustomTextButton(
                    text: "Proceed to Survey",
                    buttonColor: const Color(0xFFFB812C),
                    onPressed: () {
                      // Validate the Aadhaar Number
                      String aadharNumber =
                          farmerAadhaarNumberController.text.trim();

                      if (aadharNumber.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Please provide Aadhaar number")),
                        );
                        return;
                      }

                      if (aadharNumber.length != 12) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text("Aadhaar number must be 12 digits")),
                        );
                        return;
                      }

                      // Navigate to SurveyUploadPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SurveyPage1(aadharId: int.parse(aadharNumber)),
                        ),
                      );
                    },
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
