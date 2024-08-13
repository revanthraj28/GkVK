import 'package:sqflite/sqflite.dart';
import 'package:gkvk/database/database_service.dart';

class SurveyDataDBforfer2 {
  final tableName = 'survey_data_table2forfer';

  Future<void> createTable(Database database) async {
    await database.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        "aadharId" INTEGER PRIMARY KEY,
        "surveyData" TEXT NOT NULL
      );
    ''');
  }

  Future<int> create({
    required int aadharId,
    required String surveyData,
  }) async {
    final database = await DatabaseService().database;
    return await database.insert(tableName, {
      'aadharId': aadharId,
      'surveyData': surveyData,
    });
  }

  Future<Map<String, dynamic>?> read(int aadharId) async {
    final database = await DatabaseService().database;
    List<Map<String, dynamic>> results = await database.query(
      tableName,
      where: 'aadharId = ?',
      whereArgs: [aadharId],
    );
    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> readAll() async {
    final database = await DatabaseService().database;
    return await database.query(tableName);
  }

  Future<int> update({
    required int aadharId,
    required String surveyData,
  }) async {
    final database = await DatabaseService().database;
    return await database.update(
      tableName,
      {
        'surveyData': surveyData,
      },
      where: 'aadharId = ?',
      whereArgs: [aadharId],
    );
  }

  Future<int> delete(int aadharId) async {
    final database = await DatabaseService().database;
    return await database.delete(
      tableName,
      where: 'aadharId = ?',
      whereArgs: [aadharId],
    );
  }
}
