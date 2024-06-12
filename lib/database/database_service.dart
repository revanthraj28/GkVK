import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:gkvk/database/gkvk_db.dart';
import 'package:gkvk/database/farmer_profile_db.dart';
import 'package:gkvk/database/survey_page1_db.dart';
import 'package:gkvk/database/survey_page2_db.dart';
import 'package:gkvk/database/survey_page3_db.dart';
import 'package:gkvk/database/survey_page4_db.dart';

class DatabaseService {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initialize();
    return _database!;
  }

  Future<String> get fullPath async {
    const name = "gkvk.db";
    final path = await getDatabasesPath();
    return join(path, name);
  }

  Future<Database> _initialize() async {
    final path = await fullPath;
    var database = await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
      singleInstance: true,
    );
    return database;
  }

  Future<void> _createDb(Database database, int version) async {
    await WaterShedDB().createTable(database);
    await FarmerProfileDB().createTable(database);
    await SurveyDataDB1().createTable(database);
    await SurveyDataDB2().createTable(database);
    await SurveyDataDB3().createTable(database);
    await SurveyDataDB4().createTable(database);
  }
}