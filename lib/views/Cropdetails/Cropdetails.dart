import 'package:flutter/material.dart';
import 'package:gkvk/shared/components/CustomTextButton.dart';
import 'package:gkvk/shared/components/CustomTextFormField.dart';
import 'package:gkvk/shared/components/SelectionButton.dart';
import 'package:gkvk/views/Cropdetails/custominputfield.dart';
import 'package:gkvk/views/Cropdetails/customradiogroup.dart';
import 'package:gkvk/views/Cropdetails/FertilizerForm.dart';
import 'package:gkvk/views/Surveypages/Surveypages1.dart';

class Cropdetails extends StatefulWidget {
  const Cropdetails({super.key});

  @override
  _CropdetailsState createState() => _CropdetailsState();
}

class _CropdetailsState extends State<Cropdetails> {
  String? _selectedCategory1;
  String? _selectedCategory2;
  String? _selectedCategory3;
  String? _selectedCategory4;

  Map<String, String?> selectedValues = {
    'Nitrogen': null,
    'Phosphorous': null,
    'Potassium': null,
  };

  final List<String> options = ['very low', 'Low', 'Medium', 'High', 'Very high'];

  final List<TextEditingController> _controllers = List.generate(
    24,  // Adjusted the number of controllers to cover all fields
    (index) => TextEditingController(),
  );

  List<Widget> fertilizerForms = [];

  @override
  void initState() {
    super.initState();
    fertilizerForms.add(FertilizerForm(index: 1));
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
        selectedValues['Potassium'] == null ||
        _selectedCategory1 == null ||
        _selectedCategory2 == null ||
        _selectedCategory3 == null ||
        _selectedCategory4 == null) {
      return false;
    }
    return true;
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('All fields must be filled and a selection made in each category.'),
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
                        controller: _controllers[0],
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: CustomTextFormField(
                        labelText: "Area in acres",
                        controller: _controllers[1],
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
                        controller: _controllers[2],
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: CustomTextFormField(
                        labelText: "Variety of crop",
                        controller: _controllers[3],
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                CustomTextFormField(
                  labelText: "Duration(in days)",
                  controller: _controllers[4],
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10.0),
                SelectionButton(
                  label: "Type of land",
                  options: const ['Rain-fed', 'Irrigated'],
                  selectedOption: _selectedCategory1,
                  onPressed: (option) {
                    setState(() {
                      _selectedCategory1 = option;
                    });
                  },
                ),
                const SizedBox(height: 10.0),
                SelectionButton(
                  label: "Season",
                  options: const ['Khrif', 'Rabi', 'Summer'],
                  selectedOption: _selectedCategory2,
                  onPressed: (option) {
                    setState(() {
                      _selectedCategory2 = option;
                    });
                  },
                ),
                const SizedBox(height: 10.0),
                SelectionButton(
                  label: "Source of Irrigation",
                  options: const ['Borewell', 'Tank', 'Canal', 'Others'],
                  selectedOption: _selectedCategory3,
                  onPressed: (option) {
                    setState(() {
                      _selectedCategory3 = option;
                    });
                  },
                ),
                const SizedBox(height: 20.0),
                CustomTextFormField(
                  labelText: "Sub-Watershed Name",
                  controller: _controllers[5],
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 20.0),
                CustomTextFormField(
                  labelText: "Cost of seed(including own seed(in Rs))",
                  controller: _controllers[6],
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20.0),
                CustomTextFormField(
                  labelText: "Village",
                  controller: _controllers[7],
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 20.0),
                const Text('Fertility status according to LRI card',
                    style: TextStyle(fontSize: 18)),
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
                    style: TextStyle(fontSize: 18)),
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
                  'Organic manures\n(compost / FYM / green manure / tank silt / others)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'Name',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'Quantity',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'Cost',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
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
                const Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'Name',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'Quantity',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'Cost',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
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
                  selectedOption: _selectedCategory4,
                  onPressed: (option) {
                    setState(() {
                      _selectedCategory4 = option;
                    });
                  },
                ),
                const SizedBox(height: 20.0),
                CustomTextFormField(
                  labelText: "Cost of plant protection chemicals (in Rs.)",
                  controller: _controllers[8],
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
                        controller: _controllers[9],
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: CustomTextFormField(
                        labelText: "Cost (in Rs.)",
                        controller: _controllers[10],
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
                        controller: _controllers[11],
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: CustomTextFormField(
                        labelText: "Cost (in Rs.)",
                        controller: _controllers[12],
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                CustomTextFormField(
                  labelText: "Cost of Animal drawn work (in Rs.)",
                  controller: _controllers[13],
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10.0),
                CustomTextFormField(
                  labelText: "Cost of Animal mechanized work (in Rs.)",
                  controller: _controllers[14],
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10.0),
                CustomTextFormField(
                  labelText:
                      "Irrigation cost (if purchased/ repairs during crop season/ fuel cost/ electricity) (in Rs.)",
                  controller: _controllers[15],
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20.0),
                const Text('Returns', style: TextStyle(fontSize: 18)),
                const SizedBox(height: 10.0),
                CustomTextFormField(
                  labelText: "Quantity of main product (in quintal)",
                  controller: _controllers[16],
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10.0),
                CustomTextFormField(
                  labelText: "Price/unit (in Rs.)",
                  controller: _controllers[17],
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10.0),
                CustomTextFormField(
                  labelText: "Total main product amount (in quintal)",
                  controller: _controllers[18],
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10.0),
                CustomTextFormField(
                  labelText: "Quantity of By-products (in tons)",
                  controller: _controllers[19],
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10.0),
                CustomTextFormField(
                  labelText: "Price/unit (in Rs.)",
                  controller: _controllers[20],
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10.0),
                CustomTextFormField(
                  labelText: "Total By-product amount (in Rs.)",
                  controller: _controllers[21],
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
        child: CustomTextButton(
          text: 'Done',
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SurveyPage1()),
              );
            // if (_validateForm()) {
             
            // } else {
            //   // _showErrorDialog();
            // }
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
