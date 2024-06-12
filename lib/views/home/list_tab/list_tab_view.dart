import 'package:flutter/material.dart';
import 'package:gkvk/database/farmer_profile_db.dart';
import 'package:gkvk/shared/components/CustomTextButton.dart';

class ListTabView extends StatelessWidget {
  const ListTabView({super.key});

  Future<List<Map<String, dynamic>>> fetchAllFarmers() async {
    return await FarmerProfileDB().readAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchAllFarmers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No farmers to upload.'));
                  } else {
                    final farmers = snapshot.data!;
                    return ListView.builder(
                      itemCount: farmers.length,
                      itemBuilder: (context, index) {
                        final farmer = farmers[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0), // Adjusted padding to reduce height
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: UploadStatusTile(
                              aadharNumber: farmer['aadharNumber'],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            CustomTextButton(
              text: 'UPLOAD ALL',
              onPressed: () {
                // Handle upload all action
              },
            ),
          ],
        ),
      ),
    );
  }
}

class UploadStatusTile extends StatelessWidget {
  final int aadharNumber;

  UploadStatusTile({required this.aadharNumber});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16.0), // Adjusted padding to reduce height
      title: Text('Farmer Id: $aadharNumber'),
      subtitle: Text('Upload pending'),
      trailing: const Icon(Icons.cloud_upload, color: Color(0xFF8DB600)),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ListTabView(),
  ));
}
