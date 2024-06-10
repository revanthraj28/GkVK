import 'package:flutter/material.dart';
import 'package:gkvk/shared/components/CustomTextButton.dart';
import 'package:gkvk/shared/components/SelectionButton.dart';

class Surveypages3 extends StatefulWidget {
  const Surveypages3({super.key});

  @override
  _Surveypages3 createState() => _Surveypages3();
}

class _Surveypages3 extends State<Surveypages3> {
  String? _selectedOption1;
  String? _selectedOption2;
  String? _selectedOption3;
  String? _selectedOption4;
  String? _selectedOption5;

  String? selectedCategoryOfFarmer;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        title: const Text(
          'Survey Page 3',
          style: TextStyle(
            color: Color(0xFF8DB600),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              ' Status of application of fertilizers as per LRI',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                height: 0,
              )
            ),

              const SizedBox(height: 10.0),
                SelectionButton(
                  label: "1. Whose advice do you seek to decide the type and quantity of fertilizers?",
                  options: const ['a. On my Own', 
                  'b. Fertilizer dealer', 
                  'c. RSK Staff', 
                  'd. Neighbours'],
                  selectedOption: _selectedOption1, 
                  onPressed: (option) {
                    setState(() {
                      _selectedOption1 = option;
                    });
                  },
                ),

              const SizedBox(height: 10.0),
                SelectionButton(
                  label: "2. What is the most appropriate information source to decide required quantities of fertilizers for the crops?",
                  options: const ['A. Own experience', 
                  'B. Package of practices', 
                  'C. Soil test report', 
                  'D. LRI card'],
                  selectedOption: _selectedOption2,
                  onPressed: (option) {
                    setState(() {
                      _selectedOption2 = option;
                    });
                  },
                ),

              const SizedBox(height: 10.0),
                SelectionButton(
                  label: "3. Have you applied fertilizers as per LRI card?",
                  options: const [
                    'A. No',
                    'B. Not aware',
                    'C. Not skillful to use LRI information',
                    'D. Yes'
                    ],
                  selectedOption: _selectedOption3,
                  onPressed: (option) {
                    setState(() {
                      _selectedOption3 = option;
                    });
                  },
                ),

              const SizedBox(height: 10.0),
                SelectionButton(
                  label: "4. If you have applied fertilizers as per LRI card, what is your opinion?",
                  options: const [    
                    'A. Cannot differentiate the benefits ',
                    'B. Able to save fertilizer cost',
                    'C. Able to get more yield',
                    'D. Option B and C',
                      ],
                  selectedOption: _selectedOption4,
                  onPressed: (option) {
                    setState(() {
                      _selectedOption4 = option;
                    });
                  },
                ),

              const SizedBox(height: 10.0),
                SelectionButton(
                  label: "'5. If you are trained on the use of LRI cards, will you follow LRI based fertilizer application?",
                  options: const [
                    'A. No',
                    'B. Try this season in smaller area',
                     'C. Try next season/ year',
                     'D. Try this season for all the crops'
                    ],
                  selectedOption: _selectedOption5,
                  onPressed: (option) {
                    setState(() {
                      _selectedOption5 = option;
                    });
                  },
                ),
          
          ]
        )
      ),
    floatingActionButton: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: CustomTextButton(
          text: 'Next',
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}