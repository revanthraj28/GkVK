import 'package:gkvk/database/DealerDB/surveypage1forfer_db.dart';
import 'package:gkvk/database/DealerDB/surveypage3forfer_db.dart';
import 'package:gkvk/database/DealerDB/surveypage2forfer_db.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:gkvk/database/farmerDB/gkvk_db.dart';
import 'package:gkvk/database/farmerDB/farmer_profile_db.dart';
import 'package:gkvk/database/farmerDB/cropdetails_db.dart';
import 'package:gkvk/database/farmerDB/survey_page1_db.dart';
import 'package:gkvk/database/farmerDB/survey_page2_db.dart';
import 'package:gkvk/database/farmerDB/survey_page3_db.dart';
import 'package:gkvk/database/farmerDB/survey_page4_db.dart';

import 'DealerDB/dealer_db.dart';

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
    await CropdetailsDB().createTable(database);
    await SurveyDataDB1().createTable(database);
    await SurveyDataDB2().createTable(database);
    await SurveyDataDB3().createTable(database);
    await SurveyDataDB4().createTable(database);
    await DealerDb().createTable(database);
    await SurveyDataDBforfer().createTable(database);
    await SurveyDataDBforfer2().createTable(database);
    await SurveyDataDBforfer3().createTable(database);
  }
}
