import 'package:sqflite/sqflite.dart';
import 'package:gkvk/database/database_service.dart';

class WaterShedDB {
  final tableName = 'water_shed_table';

  Future<void> createTable(Database database) async {
    await database.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        "watershedId" INTEGER PRIMARY KEY AUTOINCREMENT,
        "district" TEXT NOT NULL,
        "taluk" TEXT NOT NULL,
        "hobli" TEXT NOT NULL,
        "subWatershedName" TEXT NOT NULL,
        "subWatershedCode" TEXT NOT NULL,
        "village" TEXT NOT NULL,
        "selectedCategory" TEXT NOT NULL
      );
    ''');
  }

  Future<int> create({
    required String district,
    required String taluk,
    required String hobli,
    required String subWatershedName,
    required String subWatershedCode,
    required String village,
    required String selectedCategory,
  }) async {
    final database = await DatabaseService().database;
    return await database.insert(tableName, {
      'district': district,
      'taluk': taluk,
      'hobli': hobli,
      'subWatershedName': subWatershedName,
      'subWatershedCode': subWatershedCode,
      'village': village,
      'selectedCategory': selectedCategory,
    });
  }

  Future<List<Map<String, dynamic>>> readAll() async {
    final database = await DatabaseService().database;
    return await database.query(tableName);
  }

  Future<Map<String, dynamic>?> read(int watershedId) async {
    final database = await DatabaseService().database;
    final List<Map<String, dynamic>> results = await database.query(
      tableName,
      where: 'watershedId = ?',
      whereArgs: [watershedId],
    );
    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<int> update({
    required int watershedId,
    required String district,
    required String taluk,
    required String hobli,
    required String subWatershedName,
    required String subWatershedCode,
    required String village,
    required String selectedCategory,
  }) async {
    final database = await DatabaseService().database;
    return await database.update(
      tableName,
      {
        'district': district,
        'taluk': taluk,
        'hobli': hobli,
        'subWatershedName': subWatershedName,
        'subWatershedCode': subWatershedCode,
        'village': village,
        'selectedCategory': selectedCategory,
      },
      where: 'watershedId = ?',
      whereArgs: [watershedId],
    );
  }

  Future<int> delete(int watershedId) async {
    final database = await DatabaseService().database;
    return await database.delete(
      tableName,
      where: 'watershedId = ?',
      whereArgs: [watershedId],
    );
  }
}

