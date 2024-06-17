import 'package:flutter/material.dart';

class FarmerAreaPage extends StatefulWidget {
  @override
  _FarmerAreaPageState createState() => _FarmerAreaPageState();
}

class _FarmerAreaPageState extends State<FarmerAreaPage> {
  List<Widget> forms = [];

  @override
  void initState() {
    super.initState();
    forms.add(FarmerForm()); // Add the initial form
  }

  void addNewForm() {
    setState(() {
      forms.add(FarmerForm());
    });
  }

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
        ],
      ),
    );
  }
}

class FarmerForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Hissa number',
              ),
            ),
            SizedBox(height: 10),
            Text(
              'crop 1',
              style: TextStyle(fontSize: 16.0, color: Colors.grey),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Handle crop details action
              },
              child: Text('Enter crop details'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
