import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gkvk/shared/components/CustomTextButton.dart';
import 'package:gkvk/shared/components/CustomTextFormField.dart';
import 'package:gkvk/shared/components/SelectionButton.dart';
import 'package:gkvk/views/Generate_id/detailsofCrops/Cropdetails/components/CustomInputField.dart';
import 'package:gkvk/views/Generate_id/detailsofCrops/Cropdetails/components/customradiogroup.dart';
import 'package:gkvk/views/Generate_id/detailsofCrops/Cropdetails/components/FertilizerForm.dart';
import 'package:gkvk/views/Generate_id/detailsofCrops/Surveypages/Surveypages3.dart';

class Cropdetails extends StatefulWidget {
  const Cropdetails({super.key});

  @override
  _CropdetailsState createState() => _CropdetailsState();
}

class _CropdetailsState extends State<Cropdetails> {
  // final int aadharId;
  // const Cropdetails({required this.aadharId, super.key});

  final TextEditingController _cropNameController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _surveyHissaController = TextEditingController();
  final TextEditingController _cropVarietyController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _seedCostController = TextEditingController();

  final TextEditingController _manureNameController = TextEditingController();
  final TextEditingController _manureQuantityController =
      TextEditingController();
  final TextEditingController _manureCostController = TextEditingController();

  final TextEditingController _bioFertilizerNameController =
      TextEditingController();
  final TextEditingController _bioFertilizerQuantityController =
      TextEditingController();
  final TextEditingController _bioFertilizerCostController =
      TextEditingController();

  final TextEditingController _chemFertilizerNameController =
      TextEditingController();
  final TextEditingController _chemFertilizerQuantityController =
      TextEditingController();
  final TextEditingController _chemFertilizerCostController =
      TextEditingController();

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

  final TextEditingController _mainProductQuantityController =
      TextEditingController();
  final TextEditingController _mainProductPriceController =
      TextEditingController();

  final TextEditingController _Otherproductioncost = TextEditingController();
  final TextEditingController _mainTotalcostproduction =
      TextEditingController();
  final TextEditingController _mainProductTotalController =
      TextEditingController();
  final TextEditingController _byProductQuantityController =
      TextEditingController();
  final TextEditingController _byProductPriceController =
      TextEditingController();
  final TextEditingController _byProductTotalController =
      TextEditingController();

  final RxString _selectedCategory1 = ''.obs;
  final RxString _selectedCategory2 = ''.obs;
  final RxString _selectedCategory3 = ''.obs;
  final RxString _selectedCategory4 = ''.obs;

  Map<String, String?> selectedValues = {
    'Nitrogen': null,
    'Phosphorous': null,
    'Potassium': null,
  };

  final List<String> options = [
    'very low',
    'Low',
    'Medium',
    'High',
    'Very high'
  ];

  final List<TextEditingController> _controllers = List.generate(
    24, // Adjusted the number of controllers to cover all fields
    (index) => TextEditingController(),
  );

  List<Widget> fertilizerForms = [];

  @override
  void initState() {
    super.initState();
    fertilizerForms.add(const FertilizerForm(index: 1));
  }

  void addFertilizerForm() {
    setState(() {
      fertilizerForms.add(FertilizerForm(index: fertilizerForms.length + 1));
    });
  }

  bool _validateForm() {
    for (var controller in _controllers) {
      if (controller.text.isEmpty) {
        return false;
      }
    }
    if (selectedValues['Nitrogen'] == null ||
        selectedValues['Phosphorous'] == null ||
        selectedValues['Potassium'] == null) {
      return false;
    }
    return true;
  }

  void _showErrorDialog() {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        title: const Text(
          'Enter the Crop details',
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
                        labelText: "Crop Name",
                        controller: _cropNameController,
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: CustomTextFormField(
                        labelText: "Area in acres",
                        controller: _areaController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        labelText: "Survey and Hissa No",
                        controller: _surveyHissaController,
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: CustomTextFormField(
                        labelText: "Variety of crop",
                        controller: _cropVarietyController,
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                CustomTextFormField(
                  labelText: "Duration(in days)",
                  controller: _durationController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10.0),
                SelectionButton(
                  label: "Season",
                  options: const ['Khrif', 'Rabi', 'Summer'],
                  selectedOption: _selectedCategory2.value.isEmpty
                      ? null
                      : _selectedCategory2.value,
                  onPressed: (option) {
                    setState(() {
                      _selectedCategory2.value = option ?? '';
                    });
                  },
                ),
                const SizedBox(height: 10.0),
                SelectionButton(
                  label: "Type of land",
                  options: const ['Rain-fed', 'Irrigated'],
                  selectedOption: _selectedCategory1.value.isEmpty
                      ? null
                      : _selectedCategory1.value,
                  onPressed: (option) {
                    setState(() {
                      _selectedCategory1.value = option ?? '';
                    });
                  },
                ),
                const SizedBox(height: 10.0),
                SelectionButton(
                  label: "Source of Irrigation",
                  options: const ['Borewell', 'Tank', 'Canal', 'Others'],
                  selectedOption: _selectedCategory3.value.isEmpty
                      ? null
                      : _selectedCategory3.value,
                  onPressed: (option) {
                    setState(() {
                      _selectedCategory3.value = option ?? '';
                    });
                  },
                ),
                const SizedBox(height: 20.0),
                CustomTextFormField(
                  labelText: "Cost of seed(including own seed(in Rs))",
                  controller: _seedCostController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20.0),
                const Text('Fertility status according to LRI card',
                    style: TextStyle(
                      fontSize: 18,
                    )),
                const SizedBox(height: 10.0),
                CustomRadioGroup(
                  title: 'Nitrogen',
                  options: options,
                  groupValue: selectedValues['Nitrogen'],
                  onChanged: (value) {
                    setState(() {
                      selectedValues['Nitrogen'] = value;
                    });
                  },
                ),
                const SizedBox(height: 10.0),
                CustomRadioGroup(
                  title: 'Phosphorous',
                  options: options,
                  groupValue: selectedValues['Phosphorous'],
                  onChanged: (value) {
                    setState(() {
                      selectedValues['Phosphorous'] = value;
                    });
                  },
                ),
                const SizedBox(height: 10.0),
                CustomRadioGroup(
                  title: 'Potassium',
                  options: options,
                  groupValue: selectedValues['Potassium'],
                  onChanged: (value) {
                    setState(() {
                      selectedValues['Potassium'] = value;
                    });
                  },
                ),
                const SizedBox(height: 20.0),
                const Text('RDF of crop (kg/ac)',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8.0),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomInputField(label: 'N', subLabel: 'Nitrogen'),
                    CustomInputField(label: 'P', subLabel: 'Phosphorous'),
                    CustomInputField(label: 'K', subLabel: 'Potassium'),
                  ],
                ),
                const SizedBox(height: 20.0),
                const Text('Adjusted RDF of crop according to LRI card (kg/ac)',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8.0),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomInputField(label: 'N', subLabel: 'Nitrogen'),
                    CustomInputField(label: 'P', subLabel: 'Phosphorous'),
                    CustomInputField(label: 'K', subLabel: 'Potassium'),
                  ],
                ),
                const SizedBox(height: 20.0),
                const Text(
                  'Manures and fertilizers',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Organic manures',
                  // \n(compost / FYM / green manure / tank silt / others)
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: _manureNameController,
                            decoration: const InputDecoration(
                              labelText: 'Name',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: TextField(
                            controller: _manureQuantityController,
                            decoration: const InputDecoration(
                              labelText: 'Quantity',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: TextField(
                            controller: _manureCostController,
                            decoration: const InputDecoration(
                              labelText: 'Cost',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Row(
                      children: [
                        Expanded(flex: 2, child: SizedBox.shrink()), // Spacer
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('(in tons)',
                                style: TextStyle(fontSize: 12)),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('(in Rs.)',
                                style: TextStyle(fontSize: 12)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Bio-Fertilizers',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: _bioFertilizerNameController,
                            decoration: const InputDecoration(
                              labelText: 'Name',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: TextField(
                            controller: _bioFertilizerQuantityController,
                            decoration: const InputDecoration(
                              labelText: 'Quantity',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: TextField(
                            controller: _bioFertilizerCostController,
                            decoration: const InputDecoration(
                              labelText: 'Cost',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Row(
                      children: [
                        Expanded(flex: 2, child: SizedBox.shrink()), // Spacer
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('(in tons)',
                                style: TextStyle(fontSize: 12)),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('(in Rs.)',
                                style: TextStyle(fontSize: 12)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Chemical fertilizers',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Column(
                  children: fertilizerForms,
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: addFertilizerForm,
                  icon: const Icon(Icons.add),
                  label: const Text('Add new fertilizer'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 10.0),
                SelectionButton(
                  label: "Methods of fertilizer application",
                  options: const ['Broadcasting', 'Line', 'Band', 'Spot'],
                  selectedOption: _selectedCategory4.value.isEmpty
                      ? null
                      : _selectedCategory4.value,
                  onPressed: (option) {
                    setState(() {
                      _selectedCategory4.value = option ?? '';
                    });
                  },
                ),
                const SizedBox(height: 20.0),
                CustomTextFormField(
                  labelText: "Cost of plant protection chemicals (in Rs.)",
                  controller: _plantProtectionCostController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20.0),
                const Text('Labour Details', style: TextStyle(fontSize: 18)),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        labelText: "Own Labour (number)",
                        controller: _ownLabourNumberController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: CustomTextFormField(
                        labelText: "Cost (in Rs.)",
                        controller: _ownLabourCostController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        labelText: "Hired Labour (number)",
                        controller: _hiredLabourNumberController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: CustomTextFormField(
                        labelText: "Cost",
                        controller: _hiredLabourCostController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                CustomTextFormField(
                  labelText: "Cost of Animal drawn work",
                  controller: _animalDrawnCostController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10.0),
                CustomTextFormField(
                  labelText: "Cost of Animal mechanized work ",
                  controller: _animalMechanizedCostController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10.0),
                CustomTextFormField(
                  labelText:
                      "Irrigation cost (if purchased/ repairs during crop season/ fuel cost/ electricity) (in Rs.)",
                  controller: _controllers[15],
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10.0),
                CustomTextFormField(
                  labelText: "Other production cost, if any (Rs.)",
                  // (if purchased/ repairs during crop  \n season/ fuel cost/ electricity) (in Rs.)
                  controller: _Otherproductioncost,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10.0),
                CustomTextFormField(
                  labelText: "Total cost of production",
                  // (if purchased/ repairs during crop  \n season/ fuel cost/ electricity) (in Rs.)
                  controller: _mainTotalcostproduction,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20.0),
                const Text('Returns', style: TextStyle(fontSize: 18)),
                const SizedBox(height: 10.0),
                CustomTextFormField(
                  labelText: "Total main product amount(in quintal)",
                  controller: _mainProductTotalController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10.0),
                CustomTextFormField(
                  labelText: "Quantity of By-products(in tons)",
                  controller: _byProductQuantityController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10.0),
                CustomTextFormField(
                  labelText: "Price/unit)",
                  controller: _byProductPriceController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10.0),
                CustomTextFormField(
                  labelText: "Total By-product amount",
                  controller: _byProductTotalController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 60.0),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        // child: CustomTextButton(
        //   text: 'Done',
        //   // onPressed: () {
        //   //   Navigator.push(
        //   //       context,
        //   //       MaterialPageRoute(builder: (context) => const Surveypages3()),
        //   //     );
        //   //   // if (_validateForm()) {

        //   //   // } else {
        //   //   //   // _showErrorDialog();
        //   //   // }
        //   // },
        // ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}             
// // labelText: "Quantity of main product (in quintal)",
//                 //   controller: _controllers[16],
//                 //   keyboardType: TextInputType.number,
//                 // ),
//                 // const SizedBox(height: 10.0),
//                 // CustomTextFormField(
//                 //   labelText: "Price/unit",
//                 //   controller: _controllers[17],
//                 //   keyboardType: TextInputType.number,
//                 // ),
//                 // const SizedBox(height: 10.0),
//                 // CustomTextFormField(
  
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:gkvk/shared/components/CustomTextButton.dart';
// // import 'package:gkvk/shared/components/CustomTextFormField.dart';
// // import 'package:gkvk/shared/components/SelectionButton.dart';
// // import 'package:gkvk/views/Generate_id/detailsofCrops/Cropdetails/components/CustomInputField.dart';
// // import 'package:gkvk/views/Generate_id/detailsofCrops/Cropdetails/components/customradiogroup.dart';
// // import 'package:gkvk/views/Generate_id/detailsofCrops/Cropdetails/components/FertilizerForm.dart';
// // import 'package:gkvk/views/Generate_id/detailsofCrops/Surveypages/Surveypages3.dart';

// // class Cropdetails extends StatefulWidget {
// //   const Cropdetails({super.key});

// //   @override
// //   _CropdetailsState createState() => _CropdetailsState();
// // }

// // class _CropdetailsState extends State<Cropdetails> {
// //   final TextEditingController _cropNameController = TextEditingController();
// //   final TextEditingController _areaController = TextEditingController();
// //   final TextEditingController _surveyHissaController = TextEditingController();
// //   final TextEditingController _cropVarietyController = TextEditingController();
// //   final TextEditingController _durationController = TextEditingController();
// //   final TextEditingController _seedCostController = TextEditingController();
// //   final TextEditingController _manureNameController = TextEditingController();
// //   final TextEditingController _manureQuantityController = TextEditingController();
// //   final TextEditingController _manureCostController = TextEditingController();
// //   final TextEditingController _bioFertilizerNameController = TextEditingController();
// //   final TextEditingController _bioFertilizerQuantityController = TextEditingController();
// //   final TextEditingController _bioFertilizerCostController = TextEditingController();
// //   final TextEditingController _chemFertilizerNameController = TextEditingController();
// //   final TextEditingController _chemFertilizerQuantityController = TextEditingController();
// //   final TextEditingController _chemFertilizerCostController = TextEditingController();
// //   final TextEditingController _plantProtectionCostController = TextEditingController();
// //   final TextEditingController _ownLabourNumberController = TextEditingController();
// //   final TextEditingController _ownLabourCostController = TextEditingController();
// //   final TextEditingController _hiredLabourNumberController = TextEditingController();
// //   final TextEditingController _hiredLabourCostController = TextEditingController();
// //   final TextEditingController _animalDrawnCostController = TextEditingController();
// //   final TextEditingController _animalMechanizedCostController = TextEditingController();
// //   final TextEditingController _irrigationCostController = TextEditingController();
// //   final TextEditingController _mainProductQuantityController = TextEditingController();
// //   final TextEditingController _mainProductPriceController = TextEditingController();
// //   final TextEditingController _mainProductTotalController = TextEditingController();
// //   final TextEditingController _byProductQuantityController = TextEditingController();
// //   final TextEditingController _byProductPriceController = TextEditingController();
// //   final TextEditingController _byProductTotalController = TextEditingController();

// //   final RxString _selectedCategory1 = ''.obs;
// //   final RxString _selectedCategory2 = ''.obs;
// //   final RxString _selectedCategory3 = ''.obs;
// //   final RxString _selectedCategory4 = ''.obs;

// //   final RxMap<String, String?> selectedValues = {
// //     'Nitrogen': null,
// //     'Phosphorous': null,
// //     'Potassium': null,
// //   }.obs;

// //   final List<String> options = ['very low', 'Low', 'Medium', 'High', 'Very high'];

// //   List<Widget> fertilizerForms = [];

// //   @override
// //   void initState() {
// //     super.initState();
// //     fertilizerForms.add(const FertilizerForm(index: 1));
// //   }

// //   void addFertilizerForm() {
// //     setState(() {
// //       fertilizerForms.add(FertilizerForm(index: fertilizerForms.length + 1));
// //     });
// //   }

// //   bool _validateForm() {
// //     List<TextEditingController> _controllers = [
// //       _cropNameController,
// //       _areaController,
// //       _surveyHissaController,
// //       _cropVarietyController,
// //       _durationController,
// //       _seedCostController,
// //       _manureNameController,
// //       _manureQuantityController,
// //       _manureCostController,
// //       _bioFertilizerNameController,
// //       _bioFertilizerQuantityController,
// //       _bioFertilizerCostController,
// //       _chemFertilizerNameController,
// //       _chemFertilizerQuantityController,
// //       _chemFertilizerCostController,
// //       _plantProtectionCostController,
// //       _ownLabourNumberController,
// //       _ownLabourCostController,
// //       _hiredLabourNumberController,
// //       _hiredLabourCostController,
// //       _animalDrawnCostController,
// //       _animalMechanizedCostController,
// //       _irrigationCostController,
// //       _mainProductQuantityController,
// //       _mainProductPriceController,
// //       _mainProductTotalController,
// //       _byProductQuantityController,
// //       _byProductPriceController,
// //       _byProductTotalController,
// //     ];

// //     for (var controller in _controllers) {
// //       if (controller.text.isEmpty) {
// //         return false;
// //       }
// //     }
// //     if (selectedValues['Nitrogen'] == null ||
// //         selectedValues['Phosphorous'] == null ||
// //         selectedValues['Potassium'] == null ||
// //         _selectedCategory1.value.isEmpty ||
// //         _selectedCategory2.value.isEmpty ||
// //         _selectedCategory3.value.isEmpty ||
// //         _selectedCategory4.value.isEmpty) {
// //       return false;
// //     }
// //     return true;
// //   }

// //   void _showErrorDialog() {
// //     showDialog(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return AlertDialog(
// //           title: const Text('Error'),
// //           content: const Text('All fields must be filled and a selection made in each category.'),
// //           actions: [
// //             TextButton(
// //               child: const Text('OK'),
// //               onPressed: () {
// //                 Navigator.of(context).pop();
// //               },
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         backgroundColor: Colors.white,
// //         elevation: 2,
// //         centerTitle: true,
// //         title: const Text(
// //           'Enter the Crop details',
// //           style: TextStyle(
// //             color: Color(0xFF8DB600),
// //             fontSize: 18,
// //             fontWeight: FontWeight.w500,
// //           ),
// //         ),
// //         iconTheme: const IconThemeData(color: Colors.black),
// //       ),
// //       body: SafeArea(
// //         child: SingleChildScrollView(
// //           child: Container(
// //             color: const Color(0xFFF3F3F3),
// //             padding: const EdgeInsets.all(20.0),
// //             child: Column(
// //               children: [
// //                 const SizedBox(height: 20.0),
// //                 Row(
// //                   children: [
// //                     Expanded(
// //                       child: CustomTextFormField(
// //                         labelText: "Crop Name",
// //                         controller: _cropNameController,
// //                         keyboardType: TextInputType.text,
// //                       ),
// //                     ),
// //                     const SizedBox(width: 10.0),
// //                     Expanded(
// //                       child: CustomTextFormField(
// //                         labelText: "Area in acres",
// //                         controller: _areaController,
// //                         keyboardType: TextInputType.number,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 20.0),
// //                 Row(
// //                   children: [
// //                     Expanded(
// //                       child: CustomTextFormField(
// //                         labelText: "Survey and Hissa No",
// //                         controller: _surveyHissaController,
// //                         keyboardType: TextInputType.text,
// //                       ),
// //                     ),
// //                     const SizedBox(width: 10.0),
// //                     Expanded(
// //                       child: CustomTextFormField(
// //                         labelText: "Variety of crop",
// //                         controller: _cropVarietyController,
// //                         keyboardType: TextInputType.text,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 20.0),
// //                 CustomTextFormField(
// //                   labelText: "Duration(in days)",
// //                   controller: _durationController,
// //                   keyboardType: TextInputType.number,
// //                 ),
// //                 const SizedBox(height: 10.0),
// //                 Obx(() => SelectionButton(
// //                   label: "Season",
// //                   options: const ['Khrif', 'Rabi', 'Summer'],
// //                   selectedOption: _selectedCategory2.value,
// //                   onPressed: (option) {
// //                     _selectedCategory2.value = option ??'';
// //                   },
// //                 )),
// //                 const SizedBox(height: 10.0),
// //                 Obx(() => SelectionButton(
// //                   label: "Type of land",
// //                   options: const ['Rain-fed', 'Irrigated'],
// //                   selectedOption: _selectedCategory1.value,
// //                   onPressed: (option) {
// //                     _selectedCategory1.value = option?? '';
// //                   },
// //                 )),
// //                 const SizedBox(height: 10.0),
// //                 Obx(() => SelectionButton(
// //                   label: "Source of Irrigation",
// //                   options: const ['Borewell', 'Tank', 'Canal', 'Others'],
// //                   selectedOption: _selectedCategory3.value,
// //                   onPressed: (option) {
// //                     _selectedCategory3.value = option?? '';
// //                   },
// //                 )),
// //                 const SizedBox(height: 20.0),
// //                 CustomTextFormField(
// //                   labelText: "Cost of seed(including own seed(in Rs.)",
// //                   controller: _seedCostController,
// //                   keyboardType: TextInputType.number,
// //                 ),
// //                 const SizedBox(height: 20.0),
// //                 const SizedBox(height: 20.0),
// //                 CustomInputField(
// //                 selectedValues: selectedValues,
// //                 options: options,
// //                 ),
// //                 const SizedBox(height: 20.0),
// //                 Obx(() => SelectionButton(
// //                   label: "Method of sowing",
// //                   options: const [
// //                     'Broadcasting',
// //                     'Transplanting',
// //                     'Drilling',
// //                     'Others'
// //                   ],
// //                   selectedOption: _selectedCategory4.value,
// //                   onPressed: (option) {
// //                     _selectedCategory4.value = option ?? "";
// //                   },
// //                 )),
// //                 const SizedBox(height: 20.0),
// //                 CustomTextFormField(
// //                   labelText: "Name of Manure",
// //                   controller: _manureNameController,
// //                   keyboardType: TextInputType.text,
// //                 ),
// //                 const SizedBox(height: 10.0),
// //                 Row(
// //                   children: [
// //                     Expanded(
// //                       child: CustomTextFormField(
// //                         labelText: "Quantity of Manure(in Kgs)",
// //                         controller: _manureQuantityController,
// //                         keyboardType: TextInputType.number,
// //                       ),
// //                     ),
// //                     const SizedBox(width: 10.0),
// //                     Expanded(
// //                       child: CustomTextFormField(
// //                         labelText: "Cost of Manure(in Rs)",
// //                         controller: _manureCostController,
// //                         keyboardType: TextInputType.number,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 20.0),
// //                 CustomTextFormField(
// //                   labelText: "Name of Bio-Fertilizer",
// //                   controller: _bioFertilizerNameController,
// //                   keyboardType: TextInputType.text,
// //                 ),
// //                 const SizedBox(height: 10.0),
// //                 Row(
// //                   children: [
// //                     Expanded(
// //                       child: CustomTextFormField(
// //                         labelText: "Quantity of Bio-Fertilizer(in Kgs)",
// //                         controller: _bioFertilizerQuantityController,
// //                         keyboardType: TextInputType.number,
// //                       ),
// //                     ),
// //                     const SizedBox(width: 10.0),
// //                     Expanded(
// //                       child: CustomTextFormField(
// //                         labelText: "Cost of Bio-Fertilizer(in Rs)",
// //                         controller: _bioFertilizerCostController,
// //                         keyboardType: TextInputType.number,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 20.0),
// //                 CustomTextFormField(
// //                   labelText: "Name of Chemical Fertilizer",
// //                   controller: _chemFertilizerNameController,
// //                   keyboardType: TextInputType.text,
// //                 ),
// //                 const SizedBox(height: 10.0),
// //                 Row(
// //                   children: [
// //                     Expanded(
// //                       child: CustomTextFormField(
// //                         labelText: "Quantity of Chemical Fertilizer(in Kgs)",
// //                         controller: _chemFertilizerQuantityController,
// //                         keyboardType: TextInputType.number,
// //                       ),
// //                     ),
// //                     const SizedBox(width: 10.0),
// //                     Expanded(
// //                       child: CustomTextFormField(
// //                         labelText: "Cost of Chemical Fertilizer(in Rs)",
// //                         controller: _chemFertilizerCostController,
// //                         keyboardType: TextInputType.number,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 20.0),
// //                 CustomTextFormField(
// //                   labelText: "Cost of Plant Protection Chemical(in Rs.)",
// //                   controller: _plantProtectionCostController,
// //                   keyboardType: TextInputType.number,
// //                 ),
// //                 const SizedBox(height: 10.0),
// //                 Row(
// //                   children: [
// //                     Expanded(
// //                       child: CustomTextFormField(
// //                         labelText: "No. of Own Labour",
// //                         controller: _ownLabourNumberController,
// //                         keyboardType: TextInputType.number,
// //                       ),
// //                     ),
// //                     const SizedBox(width: 10.0),
// //                     Expanded(
// //                       child: CustomTextFormField(
// //                         labelText: "Cost of Own Labour(in Rs)",
// //                         controller: _ownLabourCostController,
// //                         keyboardType: TextInputType.number,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 20.0),
// //                 Row(
// //                   children: [
// //                     Expanded(
// //                       child: CustomTextFormField(
// //                         labelText: "No. of Hired Labour",
// //                         controller: _hiredLabourNumberController,
// //                         keyboardType: TextInputType.number,
// //                       ),
// //                     ),
// //                     const SizedBox(width: 10.0),
// //                     Expanded(
// //                       child: CustomTextFormField(
// //                         labelText: "Cost of Hired Labour(in Rs)",
// //                         controller: _hiredLabourCostController,
// //                         keyboardType: TextInputType.number,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 20.0),
// //                 Row(
// //                   children: [
// //                     Expanded(
// //                       child: CustomTextFormField(
// //                         labelText: "Cost of Animal Drawn Labour(in Rs)",
// //                         controller: _animalDrawnCostController,
// //                         keyboardType: TextInputType.number,
// //                       ),
// //                     ),
// //                     const SizedBox(width: 10.0),
// //                     Expanded(
// //                       child: CustomTextFormField(
// //                         labelText: "Cost of Mechanical Labour(in Rs)",
// //                         controller: _animalMechanizedCostController,
// //                         keyboardType: TextInputType.number,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 20.0),
// //                 CustomTextFormField(
// //                   labelText: "Cost of Irrigation(in Rs)",
// //                   controller: _irrigationCostController,
// //                   keyboardType: TextInputType.number,
// //                 ),
// //                 const SizedBox(height: 10.0),
// //                 CustomTextFormField(
// //                   labelText: "Quantity of Main Product",
// //                   controller: _mainProductQuantityController,
// //                   keyboardType: TextInputType.number,
// //                 ),
// //                 const SizedBox(height: 10.0),
// //                 CustomTextFormField(
// //                   labelText: "Price of Main Product(in Rs)",
// //                   controller: _mainProductPriceController,
// //                   keyboardType: TextInputType.number,
// //                 ),
// //                 const SizedBox(height: 10.0),
// //                 CustomTextFormField(
// //                   labelText: "Total Cost of Main Product(in Rs)",
// //                   controller: _mainProductTotalController,
// //                   keyboardType: TextInputType.number,
// //                 ),
// //                 const SizedBox(height: 10.0),
// //                 CustomTextFormField(
// //                   labelText: "Quantity of By Product",
// //                   controller: _byProductQuantityController,
// //                   keyboardType: TextInputType.number,
// //                 ),
// //                 const SizedBox(height: 10.0),
// //                 CustomTextFormField(
// //                   labelText: "Price of By Product(in Rs)",
// //                   controller: _byProductPriceController,
// //                   keyboardType: TextInputType.number,
// //                 ),
// //                 const SizedBox(height: 10.0),
// //                 CustomTextFormField(
// //                   labelText: "Total Cost of By Product(in Rs)",
// //                   controller: _byProductTotalController,
// //                   keyboardType: TextInputType.number,
// //                 ),
// //                 const SizedBox(height: 20.0),
// //                 CustomTextButton(
// //                   text: "Next",
// //                   onPressed: () {
// //                     if (_validateForm()) {
// //                       Navigator.push(
// //                         context,
// //                         MaterialPageRoute(
// //                           builder: (context) => const Surveypages3(),
// //                         ),
// //                       );
// //                     } else {
// //                       _showErrorDialog();
// //                     }
// //                   },
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gkvk/shared/components/CustomTextButton.dart';
// import 'package:gkvk/shared/components/CustomTextFormField.dart';
// import 'package:gkvk/shared/components/SelectionButton.dart';
// import 'package:gkvk/views/Generate_id/detailsofCrops/Cropdetails/components/CustomInputField.dart';
// import 'package:gkvk/views/Generate_id/detailsofCrops/Cropdetails/components/customradiogroup.dart';
// import 'package:gkvk/views/Generate_id/detailsofCrops/Cropdetails/components/FertilizerForm.dart';
// import 'package:gkvk/views/Generate_id/detailsofCrops/Surveypages/Surveypages3.dart';

// class Cropdetails extends StatefulWidget {
//   const Cropdetails({super.key});

//   @override
//   _CropdetailsState createState() => _CropdetailsState();
// }

// class _CropdetailsState extends State<Cropdetails> {
//   final TextEditingController _cropNameController = TextEditingController();
//   final TextEditingController _areaController = TextEditingController();
//   final TextEditingController _surveyHissaController = TextEditingController();
//   final TextEditingController _cropVarietyController = TextEditingController();
//   final TextEditingController _durationController = TextEditingController();
//   final TextEditingController _seedCostController = TextEditingController();
//   final TextEditingController _manureNameController = TextEditingController();
//   final TextEditingController _manureQuantityController = TextEditingController();
//   final TextEditingController _manureCostController = TextEditingController();
//   final TextEditingController _bioFertilizerNameController = TextEditingController();
//   final TextEditingController _bioFertilizerQuantityController = TextEditingController();
//   final TextEditingController _bioFertilizerCostController = TextEditingController();
//   final TextEditingController _chemFertilizerNameController = TextEditingController();
//   final TextEditingController _chemFertilizerQuantityController = TextEditingController();
//   final TextEditingController _chemFertilizerCostController = TextEditingController();
//   final TextEditingController _plantProtectionCostController = TextEditingController();
//   final TextEditingController _ownLabourNumberController = TextEditingController();
//   final TextEditingController _ownLabourCostController = TextEditingController();
//   final TextEditingController _hiredLabourNumberController = TextEditingController();
//   final TextEditingController _hiredLabourCostController = TextEditingController();
//   final TextEditingController _animalDrawnCostController = TextEditingController();
//   final TextEditingController _animalMechanizedCostController = TextEditingController();
//   final TextEditingController _irrigationCostController = TextEditingController();
//   final TextEditingController _mainProductQuantityController = TextEditingController();
//   final TextEditingController _mainProductPriceController = TextEditingController();
//   final TextEditingController _Otherproductioncost = TextEditingController();
//   final TextEditingController _mainTotalcostproduction = TextEditingController();
//   final TextEditingController _mainProductTotalController = TextEditingController();
//   final TextEditingController _byProductQuantityController = TextEditingController();
//   final TextEditingController _byProductPriceController = TextEditingController();
//   final TextEditingController _byProductTotalController = TextEditingController();

//   final RxString _selectedCategory1 = ''.obs;
//   final RxString _selectedCategory2 = ''.obs;
//   final RxString _selectedCategory3 = ''.obs;
//   final RxString _selectedCategory4 = ''.obs;

//   Map<String, String?> selectedValues = {
//     'Nitrogen': null,
//     'Phosphorous': null,
//     'Potassium': null,
//   };

//   final List<String> options = ['very low', 'Low', 'Medium', 'High', 'Very high'];

//   final List<TextEditingController> _controllers = List.generate(
//     24,
//     (index) => TextEditingController(),
//   );

//   List<Widget> fertilizerForms = [];

//   @override
//   void initState() {
//     super.initState();
//     fertilizerForms.add(const FertilizerForm(index: 1));
//   }

//   void addFertilizerForm() {
//     setState(() {
//       fertilizerForms.add(FertilizerForm(index: fertilizerForms.length + 1));
//     });
//   }

//   bool _validateForm() {
//     for (var controller in _controllers) {
//       if (controller.text.isEmpty) {
//         return false;
//       }
//     }
//     if (selectedValues['Nitrogen'] == null ||
//         selectedValues['Phosphorous'] == null ||
//         selectedValues['Potassium'] == null ||
//         _selectedCategory1.value.isEmpty ||
//         _selectedCategory2.value.isEmpty ||
//         _selectedCategory3.value.isEmpty ||
//         _selectedCategory4.value.isEmpty) {
//       return false;
//     }
//     return true;
//   }

//   void _showErrorDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Error'),
//           content: const Text('All fields must be filled and a selection made in each category.'),
//           actions: [
//             TextButton(
//               child: const Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 2,
//         centerTitle: true,
//         title: const Text(
//           'Enter the Crop details',
//           style: TextStyle(
//             color: Color(0xFF8DB600),
//             fontSize: 18,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         iconTheme: const IconThemeData(color: Colors.black),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Container(
//             color: const Color(0xFFF3F3F3),
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               children: [
//                 const SizedBox(height: 20.0),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: CustomTextFormField(
//                         labelText: "Crop Name",
//                         controller: _cropNameController,
//                         keyboardType: TextInputType.text,
//                       ),
//                     ),
//                     const SizedBox(width: 10.0),
//                     Expanded(
//                       child: CustomTextFormField(
//                         labelText: "Area in acres",
//                         controller: _areaController,
//                         keyboardType: TextInputType.number,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20.0),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: CustomTextFormField(
//                         labelText: "Survey and Hissa No",
//                         controller: _surveyHissaController,
//                         keyboardType: TextInputType.text,
//                       ),
//                     ),
//                     const SizedBox(width: 10.0),
//                     Expanded(
//                       child: CustomTextFormField(
//                         labelText: "Variety of crop",
//                         controller: _cropVarietyController,
//                         keyboardType: TextInputType.text,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20.0),
//                 CustomTextFormField(
//                   labelText: "Duration(in days)",
//                   controller: _durationController,
//                   keyboardType: TextInputType.number,
//                 ),
//                 const SizedBox(height: 10.0),
//                 Obx(() => SelectionButton(
//                   label: "Season",
//                   options: const ['Khrif', 'Rabi', 'Summer'],
//                   selectedOption: _selectedCategory2.value.isEmpty ? null : _selectedCategory2.value,
//                   onPressed: (option) {
//                     _selectedCategory2.value = option ?? '';
//                   },
//                 )),
//                 const SizedBox(height: 10.0),
//                 Obx(() => SelectionButton(
//                   label: "Type of land",
//                   options: const ['Rain-fed', 'Irrigated'],
//                   selectedOption: _selectedCategory1.value.isEmpty ? null : _selectedCategory1.value,
//                   onPressed: (option) {
//                     _selectedCategory1.value = option ?? '';
//                   },
//                 )),
//                 const SizedBox(height: 10.0),
//                 Obx(() => SelectionButton(
//                   label: "Source of Irrigation",
//                   options: const ['Borewell', 'Tank', 'Canal', 'Others'],
//                   selectedOption: _selectedCategory3.value.isEmpty ? null : _selectedCategory3.value,
//                   onPressed: (option) {
//                     _selectedCategory3.value = option ?? '';
//                   },
//                 )),
//                 const SizedBox(height: 20.0),
//                 CustomTextFormField(
//                   labelText: "Cost of seed(including own seed(in Rs))",
//                   controller: _seedCostController,
//                   keyboardType: TextInputType.number,
//                 ),
//                 const SizedBox(height: 20.0),
//                 const Text('Fertility status according to LRI card',
//                     style: TextStyle(fontSize: 18)),
//                 const SizedBox(height: 10.0),
//                 Obx(() => CustomRadioGroup(
//                   title: 'Nitrogen',
//                   options: options,
//                   groupValue: selectedValues['Nitrogen'],
//                   onChanged: (value) {
//                     selectedValues['Nitrogen'] = value;
//                   },
//                 )),
//                 const SizedBox(height: 10.0),
//                 Obx(() => CustomRadioGroup(
//                   title: 'Phosphorous',
//                   options: options,
//                   groupValue: selectedValues['Phosphorous'],
//                   onChanged: (value) {
//                     selectedValues['Phosphorous'] = value;
//                   },
//                 )),
//                 const SizedBox(height: 10.0),
//                 Obx(() => CustomRadioGroup(
//                   title: 'Potassium',
//                   options: options,
//                   groupValue: selectedValues['Potassium'],
//                   onChanged: (value) {
//                     selectedValues['Potassium'] = value;
//                   },
//                 )),
//                 const SizedBox(height: 20.0),
//                 Obx(() => SelectionButton(
//                   label: "RDF of crop (kg/ac)",
//                   options: const [
//                     'Option 1',
//                     'Option 2',
//                     'Option 3'
//                   ], 
//                   selectedOption: _selectedCategory4.value.isEmpty ? null : _selectedCategory4.value,
//                   onPressed: (option) {
//                     _selectedCategory4.value = option ?? '';
//                   },
//                 )),
//                 const SizedBox(height: 20.0),
//                 const Text('Adjusted RDF of crop according to LRI card (kg/ac)',
//                     style: TextStyle(fontSize: 18)),
//                 const SizedBox(height: 20.0),
//                 const Text('Manures and fertilizers', style: TextStyle(fontSize: 18)),
//                 const SizedBox(height: 10.0),
//                 CustomTextFormField(
//                   labelText: "Name of Organic Manures",
//                   controller: _manureNameController,
//                   keyboardType: TextInputType.text,
//                 ),
//                 const SizedBox(height: 10.0),
//                 CustomTextFormField(
//                   labelText: "Quantity of Manures",
//                   controller: _manureQuantityController,
//                   keyboardType: TextInputType.number,
//                 ),
//                 const SizedBox(height: 10.0),
//                 CustomTextFormField(
//                   labelText: "Cost of Manures",
//                   controller: _manureCostController,
//                   keyboardType: TextInputType.number,
//                 ),
//                 const SizedBox(height: 10.0),
//                 CustomTextFormField(
//                   labelText: "Name of Bio-Fertilizers",
//                   controller: _bioFertilizerNameController,
//                   keyboardType: TextInputType.text,
//                 ),
//                 const SizedBox(height: 10.0),
//                 CustomTextFormField(
//                   labelText: "Quantity of Bio-Fertilizers",
//                   controller: _bioFertilizerQuantityController,
//                   keyboardType: TextInputType.number,
//                 ),
//                 const SizedBox(height: 10.0),
//                 CustomTextFormField(
//                   labelText: "Cost of Bio-Fertilizers",
//                   controller: _bioFertilizerCostController,
//                   keyboardType: TextInputType.number,
//                 ),
//                 const SizedBox(height: 10.0),
//                 CustomTextFormField(
//                   labelText: "Name of Chemical Fertilizers",
//                   controller: _chemFertilizerNameController,
//                   keyboardType: TextInputType.text,
//                 ),
//                 const SizedBox(height: 10.0),
//                 CustomTextFormField(
//                   labelText: "Quantity of Chemical Fertilizers",
//                   controller: _chemFertilizerQuantityController,
//                   keyboardType: TextInputType.number,
//                 ),
//                 const SizedBox(height: 10.0),
//                 CustomTextFormField(
//                   labelText: "Cost of Chemical Fertilizers",
//                   controller: _chemFertilizerCostController,
//                   keyboardType: TextInputType.number,
//                 ),
//                 const SizedBox(height: 20.0),
//                 const Text('Cost of cultivation:', style: TextStyle(fontSize: 18)),
//                 const SizedBox(height: 10.0),
//                 CustomTextFormField(
//                   labelText: "Cost of Plant Protection",
//                   controller: _plantProtectionCostController,
//                   keyboardType: TextInputType.number,
//                 ),
//                 const SizedBox(height: 10.0),
//                 CustomTextFormField(
//                   labelText: "No. of Own Labour",
//                   controller: _ownLabourNumberController,
//                   keyboardType: TextInputType.number,
//                 ),
//                 const SizedBox(height: 10.0),
//                 CustomTextFormField(
//                   labelText: "Cost of Own Labour",
//                   controller: _ownLabourCostController,
//                   keyboardType: TextInputType.number,
//                 ),
//                 const SizedBox(height: 10.0),
//                 CustomTextFormField(
//                   labelText: "No. of Hired Labour",
//                   controller: _hiredLabourNumberController,
//                   keyboardType: TextInputType.number,
//                 ),
//                 const SizedBox(height: 10.0),
//                 CustomTextFormField(
//                   labelText: "Cost of Hired Labour",
//                   controller: _hiredLabourCostController,
//                   keyboardType: TextInputType.number,
//                 ),
//                 const SizedBox(height: 10.0),
//                 CustomTextFormField(
//                   labelText: "Cost of Animal Drawn Labour",
//                   controller: _animalDrawnCostController,
//                   keyboardType: TextInputType.number,
//                 ),
//                 const SizedBox(height: 10.0),
//                 CustomTextFormField(
//                   labelText: "Cost of Animal and Mechanized Labour",
//                   controller: _animalMechanizedCostController,
//                   keyboardType: TextInputType.number,
//                 ),
//                 const SizedBox(height: 10.0),
//                 CustomTextFormField(
//                   labelText: "Cost of Irrigation",
//                   controller: _irrigationCostController,
//                   keyboardType: TextInputType.number,
//                 ),
//                 const SizedBox(height: 10.0),
//                 CustomTextFormField(
//                   labelText: "Cost of Other production cost",
//                   controller: _Otherproductioncost,
//                   keyboardType: TextInputType.number,
//                 ),
//                 const SizedBox(height: 20.0),
//                 const Text('Production:', style: TextStyle(fontSize: 18)),
//                 const SizedBox(height: 10.0),
//                 CustomTextFormField(
//                   labelText: "Quantity of main Product(Quintal)",
//                   controller: _mainProductQuantityController,
//                   keyboardType: TextInputType.number,
//                 ),
//                 const SizedBox(height: 10.0),
//                 CustomTextFormField(
//                   labelText: "Price of main Product(Rs/Quintal)",
//                   controller: _mainProductPriceController,
//                   keyboardType: TextInputType.number,
//                 ),
//                 const SizedBox(height: 10.0),
//                 CustomTextFormField(
//                   labelText: "Total cost of main production",
//                   controller: _mainTotalcostproduction,
//                   keyboardType: TextInputType.number,
//                 ),
//                 const SizedBox(height: 10.0),
//                 CustomTextFormField(
//                   labelText: "Total of main Product",
//                   controller: _mainProductTotalController,
//                   keyboardType: TextInputType.number,
//                 ),
//                 const SizedBox(height: 10.0),
//                 CustomTextFormField(
//                   labelText: "Quantity of By Product",
//                   controller: _byProductQuantityController,
//                   keyboardType: TextInputType.number,
//                 ),
//                 const SizedBox(height: 10.0),
//                 CustomTextFormField(
//                   labelText: "Price of By Product",
//                   controller: _byProductPriceController,
//                   keyboardType: TextInputType.number,
//                 ),
//                 const SizedBox(height: 10.0),
//                 CustomTextFormField(
//                   labelText: "Total of By Product",
//                   controller: _byProductTotalController,
//                   keyboardType: TextInputType.number,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           if (_validateForm()) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const Surveypages3()),
//             );
//           } else {
//             _showErrorDialog();
//           }
//         },
//         child: const Icon(Icons.arrow_forward),
//         backgroundColor: Color(0xFF8DB600),
//       ),
//     );
//   }
// }