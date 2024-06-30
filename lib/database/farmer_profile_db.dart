import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:gkvk/database/database_service.dart';

class FarmerProfileDB {
  final tableName = 'farmer_profile_table';

  // Create the table with the required columns, including the image column
  Future<void> createTable(Database database) async {
    await database.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        "farmerName" TEXT NOT NULL,
        "fatherName" TEXT NOT NULL,
        "pincode" INTEGER NOT NULL CHECK (pincode > 0),
        "schooling" INTEGER NOT NULL CHECK (schooling > 0),
        "gender" TEXT NOT NULL,
        "category" TEXT NOT NULL,
        "landHolding" TEXT NOT NULL,
        "aadharNumber" INTEGER NOT NULL PRIMARY KEY CHECK (aadharNumber > 0),
        "fruitsId" TEXT NOT NULL,
        "fertilizerSource" TEXT NOT NULL,
        "fertilizerAddress" TEXT NOT NULL,
        "salesOfProduce" TEXT NOT NULL,
        "lriReceived" TEXT NOT NULL,
        "watershedId" INTEGER NOT NULL,
        "totalland" INTEGER NOT NULL,
        "timestamp" DATETIME DEFAULT CURRENT_TIMESTAMP,
        "image" TEXT,
        FOREIGN KEY ("watershedId") REFERENCES "water_shed_table" ("watershedId")
      );
    ''');
  }

  // Insert a new farmer profile
  Future<int> create({
    required String farmerName,
    required String fatherName,
    required int pincode,
    required int schooling,
    required String gender,
    required String category,
    required String landHolding,
    required int aadharNumber,
    required String fruitsId,
    required int totalland,
    required String fertilizerSource,
    required String fertilizerAddress,
    required String salesOfProduce,
    required String lriReceived,
    required int watershedId,
    String? image, // Add image parameter here
  }) async {
    final database = await DatabaseService().database;
    return await database.insert(tableName, {
      'farmerName': farmerName,
      'fatherName': fatherName,
      'pincode': pincode,
      'schooling': schooling,
      'gender': gender,
      'category': category,
      'landHolding': landHolding,
      'aadharNumber': aadharNumber,
      'fruitsId': fruitsId,
      'fertilizerSource': fertilizerSource,
      'fertilizerAddress': fertilizerAddress,
      'salesOfProduce': salesOfProduce,
      'lriReceived': lriReceived,
      'watershedId': watershedId,
      'totalland': totalland,
      'image': image, // Include image here
    });
  }

  // Read all farmer profiles
  Future<List<Map<String, dynamic>>> readAll() async {
    final database = await DatabaseService().database;
    return await database.query(tableName);
  }

  // Read a single farmer profile by aadharNumber
  Future<Map<String, dynamic>?> read(int aadharNumber) async {
    final database = await DatabaseService().database;
    final List<Map<String, dynamic>> results = await database.query(
      tableName,
      where: 'aadharNumber = ?',
      whereArgs: [aadharNumber],
    );
    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  // Update an existing farmer profile
  Future<int> update({
    required String farmerName,
    required String fatherName,
    required int pincode,
    required int schooling,
    required String gender,
    required String category,
    required String landHolding,
    required int aadharNumber,
    required String fruitsId,
    required int totalland,
    required String fertilizerSource,
    required String fertilizerAddress,
    required String salesOfProduce,
    required String lriReceived,
    required int watershedId,
    String? image, // Add image parameter here
  }) async {
    final database = await DatabaseService().database;
    return await database.update(
      tableName,
      {
        'farmerName': farmerName,
        'fatherName': fatherName,
        'pincode': pincode,
        'schooling': schooling,
        'gender': gender,
        'category': category,
        'landHolding': landHolding,
        'aadharNumber': aadharNumber,
        'fruitsId': fruitsId,
        'fertilizerSource': fertilizerSource,
        'fertilizerAddress': fertilizerAddress,
        'salesOfProduce': salesOfProduce,
        'lriReceived': lriReceived,
        'watershedId': watershedId,
        'totalland': totalland,
        'image': image, // Include image here
      },
      where: 'aadharNumber = ?',
      whereArgs: [aadharNumber],
    );
  }

  // Delete a farmer profile by aadharNumber
  Future<int> delete(int aadharNumber) async {
    final database = await DatabaseService().database;
    return await database.delete(
      tableName,
      where: 'aadharNumber = ?',
      whereArgs: [aadharNumber],
    );
  }

  // Example method to demonstrate using intl for date formatting
  String formatDate(DateTime dateTime) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(dateTime);
  }
}
