import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:gkvk/database/database_service.dart';

class DealerDb {
  final tableName = 'Dealer_profile_table';

  Future<void> createTable(Database database) async {
    await database.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        "Name" TEXT NOT NULL,
        "Category" TEXT NOT NULL,
        "PIACadre" TEXT ,
        "fatherName" TEXT NOT NULL,
        "gender" TEXT NOT NULL,
        "phonenumber" INTEGER NOT NULL CHECK (phonenumber > 0),
        "email" TEXT NOT NULL,
        "aadharNumber" INTEGER NOT NULL PRIMARY KEY CHECK (aadharNumber > 0),
        "educationStatus" TEXT NOT NULL,
        "Duration" TEXT ,
        "Place" TEXT , 
        "watershedId" INTEGER NOT NULL,
        "timestamp" DATETIME DEFAULT CURRENT_TIMESTAMP,
        "image" TEXT,
        "User" TEXT,
        FOREIGN KEY ("watershedId") REFERENCES "water_shed_table" ("watershedId")
      );
    ''');
  }

  Future<int> create({
    required String Name,
    required String Category,
    String? PIACadre,
    required String fatherName,
    required String gender,
    required int phonenumber,
    required String email,
    required int aadharNumber,
    required String educationStatus,
    required String Duration,
    required String Place,
    required int watershedId,
    required String image,
    required String User,
  }) async {
    final database = await DatabaseService().database;
    return await database.insert(tableName, {
      'Name': Name,
      'Category': Category,
      'PIACadre': PIACadre ?? '', // Use null-coalescing operator to handle null values
      'fatherName': fatherName,
      'gender': gender,
      'phonenumber': phonenumber,
      'email': email,
      'educationStatus': educationStatus,
      'Duration': Duration,
      'Place': Place,
      'watershedId': watershedId,
      'image': image,
      'aadharNumber': aadharNumber,
      'User': User,
    });
  }

  Future<int> update({
    required String Name,
    required String Category,
    String? PIACadre,
    required String fatherName,
    required String gender,
    required int phonenumber,
    required String email,
    required int aadharNumber,
    required String educationStatus,
    required String Duration,
    required String Place,
    required int watershedId,
    required String image,
    required String User,
  }) async {
    final database = await DatabaseService().database;
    return await database.update(
      tableName,
      {
        'Name': Name,
        'Category': Category,
        'PIACadre': PIACadre ?? '', // Use null-coalescing operator to handle null values
        'fatherName': fatherName,
        'gender': gender,
        'phonenumber': phonenumber,
        'email': email,
        'educationStatus': educationStatus,
        'Duration': Duration,
        'Place': Place,
        'watershedId': watershedId,
        'image': image,
        'aadharNumber': aadharNumber,
        'User': User,
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