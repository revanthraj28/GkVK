import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:gkvk/database/database_service.dart';

class DealerDb {
  final tableName = 'Dealer_profile_table';

  Future<void> createTable(Database database) async {
    await database.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        "dealerName" TEXT NOT NULL,
        "fatherName" TEXT NOT NULL,
        "pincode" TEXT NOT NULL CHECK (LENGTH(pincode) > 0),
        "gender" TEXT NOT NULL,
        "educationStatus" TEXT NOT NULL,
        "PIACadre" TEXT NOT NULL,
        "durationReward" TEXT NOT NULL,
        "rskStaffCadre" TEXT NOT NULL,
        "RSKname" TEXT NOT NULL,
        "email" TEXT NOT NULL,
        "FertilizerDealer" TEXT NOT NULL,
        "DurationSales" TEXT NOT NULL,
        "DealerPlace" TEXT NOT NULL,
        "aadharNumber" INTEGER NOT NULL PRIMARY KEY CHECK (aadharNumber > 0),
        "phonenumber" INTEGER NOT NULL CHECK (phonenumber > 0),
        "watershedId" INTEGER NOT NULL,
        "timestamp" DATETIME DEFAULT CURRENT_TIMESTAMP,
        "image" TEXT,
        FOREIGN KEY ("watershedId") REFERENCES "water_shed_table" ("watershedId")
      );
    ''');
  }

  Future<int> create({
    required String dealerName,
    required String fatherName,
    required String gender,
    required String educationStatus,
    required String PIACadre,
    required String durationReward,
    required String rskStaffCadre,
    required String RSKname,
    required String email,
    required String FertilizerDealer,
    required String DurationSales,
    required String DealerPlace,
    required String pincode, // Add pincode field
    required int aadharNumber,
    required int phonenumber,
    required int watershedId,
    required String image,
  }) async {
    final database = await DatabaseService().database;
    return await database.insert(tableName, {
      'dealerName': dealerName,
      'fatherName': fatherName,
      'gender': gender,
      'educationStatus': educationStatus,
      'PIACadre': PIACadre,
      'durationReward': durationReward,
      'rskStaffCadre': rskStaffCadre,
      'RSKname': RSKname,
      'email': email,
      'FertilizerDealer': FertilizerDealer,
      'DurationSales': DurationSales,
      'DealerPlace': DealerPlace,
      'pincode': pincode, // Include pincode in the insert map
      'aadharNumber': aadharNumber,
      'phonenumber': phonenumber,
      'watershedId': watershedId,
      'image': image,
    });
  }

  Future<int> update({
    required String dealerName,
    required String fatherName,
    required String gender,
    required String pincode,
    required String educationStatus,
    required String PIACadre,
    required String durationReward,
    required String rskStaffCadre,
    required String RSKname,
    required String email,
    required String FertilizerDealer,
    required String DurationSales,
    required String DealerPlace,
    required int aadharNumber,
    required int phonenumber,
    required int watershedId,
    required String? image,
  }) async {
    final database = await DatabaseService().database;
    return await database.update(
      tableName,
      {
        'dealerName': dealerName,
        'fatherName': fatherName,
        'gender': gender,
        'educationStatus': educationStatus,
        'PIACadre': PIACadre,
        'durationReward': durationReward,
        'rskStaffCadre': rskStaffCadre,
        'RSKname': RSKname,
        'email': email,
        'pincode': pincode,
        'FertilizerDealer': FertilizerDealer,
        'DurationSales': DurationSales,
        'DealerPlace': DealerPlace,
        'phonenumber': phonenumber,
        'watershedId': watershedId,
        'image': image,
      },
      where: 'aadharNumber = ?',
      whereArgs: [aadharNumber],
    );
  }

  Future<List<Map<String, dynamic>>> readAll() async {
    final database = await DatabaseService().database;
    return await database.query(tableName);
  }

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

  Future<int> delete(int aadharNumber) async {
    final database = await DatabaseService().database;
    return await database.delete(
      tableName,
      where: 'aadharNumber = ?',
      whereArgs: [aadharNumber],
    );
  }

  String formatDate(DateTime dateTime) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(dateTime);
  }
}
