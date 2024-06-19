import 'package:flutter/material.dart';

class FarmerAreaPage extends StatefulWidget {
  @override
  _FarmerAreaPageState createState() => _FarmerAreaPageState();
}

class _FarmerAreaPageState extends State<FarmerAreaPage> {
  final List<Map<String, TextEditingController>> FarmerForm = [];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    addNewForm();
  }

  void addNewForm() {
    setState(() {
      FarmerForm.add({
        "hissaNumber": TextEditingController(),
      });
    });
    print('New form added. Total forms: ${FarmerForm.length}');
  }

  // Future<void> _submitData(BuildContext context) async {
  //   final FarmersareaDb = FarmerareaDb();
  //   Map<String, dynamic> data = {
  //     "aadharId": widget.aadharId,
  //     "hissaNumbers": FarmerForm.map((form) => int.tryParse(form['hissaNumber']?.text ?? '') ?? 0).toList(),
  //   };

  //   // Add your data submission logic here
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: const Color(0xFFFEF8E0),
            centerTitle: true,
            title: const Text(
              'FARMERS AREA',
              style: TextStyle(
                color: Color(0xFFFB812C),
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            iconTheme: const IconThemeData(color: Color(0xFFFB812C),),
          ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          ...forms,
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: addNewForm,
            child: Text('Add area'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Handle MCQ action
            },
            child: Text('Fill MCQ'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 75,
        color: const Color(0xFFFEF8E0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextButton(
              text: "Fill MCQ",
              buttonColor: const Color(0xFFFB812C),
              onPressed: () {
                // Handle crop details action
              },
            ),
          ],
        ),
      ),
    );
  }
}
