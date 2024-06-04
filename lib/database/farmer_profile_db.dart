import 'package:sqflite/sqflite.dart';
import 'package:gkvk/database/database_service.dart';
class FarmerProfileDB {
  final tableName = 'farmer_profile_table';

  Future<void> createTable(Database database) async {
    await database.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        "farmerName" TEXT NOT NULL,
        "fatherName" TEXT NOT NULL,
        "pincode" TEXT NOT NULL,
        "schooling" TEXT NOT NULL,
        "gender" TEXT NOT NULL,
        "category" TEXT NOT NULL,
        "landHolding" TEXT NOT NULL,
        "aadharNumber" TEXT NOT NULL,
        "fruitsId" TEXT NOT NULL,
        "fertilizerSource" TEXT NOT NULL,
        "fertilizerAddress" TEXT NOT NULL,
        "salesOfProduce" TEXT NOT NULL,
        "lriReceived" TEXT NOT NULL
      );
    ''');
  }

  Future<int> create({
    required String farmerName,
    required String fatherName,
    required String pincode,
    required String schooling,
    required String gender,
    required String category,
    required String landHolding,
    required String aadharNumber,
    required String fruitsId,
    required String fertilizerSource,
    required String fertilizerAddress,
    required String salesOfProduce,
    required String lriReceived,
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
    });
  }

  Future<List<Map<String, dynamic>>> readAll() async {
    final database = await DatabaseService().database;
    return await database.query(tableName);
  }

  Future<int> update({
    required int id,
    required String farmerName,
    required String fatherName,
    required String pincode,
    required String schooling,
    required String gender,
    required String category,
    required String landHolding,
    required String aadharNumber,
    required String fruitsId,
    required String fertilizerSource,
    required String fertilizerAddress,
    required String salesOfProduce,
    required String lriReceived,
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
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> delete(int id) async {
    final database = await DatabaseService().database;
    return await database.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}