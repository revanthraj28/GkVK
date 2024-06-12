import 'package:flutter/material.dart';

class ListTabView extends StatelessWidget {
  const ListTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Status'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  UploadStatusTile(farmerId: '24FGVK0001', status: 'Uploaded'),
                  UploadStatusTile(farmerId: '24FGVK0002', status: 'Uploaded'),
                  UploadStatusTile(farmerId: '24FGVK0003', status: 'Waiting for Connection'),
                  UploadStatusTile(farmerId: '24FGVK0004', status: 'Upload pending'),
                  UploadStatusTile(farmerId: '24FGVK0005', status: 'Upload pending'),
                  UploadStatusTile(farmerId: '24FGVK0005', status: 'Upload pending'),
                  UploadStatusTile(farmerId: '24FGVK0005', status: 'Upload pending'),
                  UploadStatusTile(farmerId: '24FGVK0005', status: 'Upload pending'),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle upload all action
                },
                child: Text('Upload all'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UploadStatusTile extends StatelessWidget {
  final String farmerId;
  final String status;

  UploadStatusTile({required this.farmerId, required this.status});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color iconColor;

    switch (status) {
      case 'Uploaded':
        icon = Icons.check_circle;
        iconColor = Colors.green;
        break;
      case 'Waiting for Connection':
        icon = Icons.cloud_off;
        iconColor = Colors.yellow;
        break;
      case 'Upload pending':
        icon = Icons.cloud_upload;
        iconColor = Colors.blue;
        break;
      default:
        icon = Icons.error;
        iconColor = Colors.red;
    }

    return ListTile(
      title: Text(farmerId),
      subtitle: Text(status),
      trailing: Icon(icon, color: iconColor),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ListTabView(),
  ));
}
