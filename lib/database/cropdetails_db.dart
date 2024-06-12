import 'package:sqflite/sqflite.dart';
import 'package:gkvk/database/database_service.dart';

class CropDetailsDB {
  final tableName = 'crop_details';

  Future<void> createTable(Database database) async {
    await database.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        "id" INTEGER PRIMARY KEY AUTOINCREMENT,
        "aadharId" INTEGER NOT NULL,
        "cropName" TEXT NOT NULL,
        "area" REAL NOT NULL,
        "surveyHissaNo" TEXT NOT NULL,
        "cropVariety" TEXT NOT NULL,
        "duration" INTEGER NOT NULL,
        "season" TEXT NOT NULL,
        "landType" TEXT NOT NULL,
        "irrigationSource" TEXT NOT NULL,
        "seedCost" REAL NOT NULL,
        "nitrogen" TEXT NOT NULL,
        "phosphorous" TEXT NOT NULL,
        "potassium" TEXT NOT NULL,
        "manureName" TEXT,
        "manureQuantity" REAL,
        "manureCost" REAL,
        "bioFertilizerName" TEXT,
        "bioFertilizerQuantity" REAL,
        "bioFertilizerCost" REAL,
        "chemFertilizerName" TEXT,
        "chemFertilizerQuantity" REAL,
        "chemFertilizerCost" REAL,
        "plantProtectionCost" REAL,
        "ownLabourNumber" INTEGER,
        "ownLabourCost" REAL,
        "hiredLabourNumber" INTEGER,
        "hiredLabourCost" REAL,
        "animalDrawnCost" REAL,
        "animalMechanizedCost" REAL,
        "irrigationCost" REAL,
        "mainProductQuantity" REAL,
        "mainProductPrice" REAL,
        "otherProductionCost" REAL,
        "mainTotalCostProduction" REAL,
        "mainProductTotal" REAL,
        "byProductQuantity" REAL,
        "byProductPrice" REAL,
        "byProductTotal" REAL,
        "fertilizerApplicationMethod" TEXT
      );
    ''');
  }

  Future<int> create({
    required int aadharId,
    required String cropName,
    required double area,
    required String surveyHissaNo,
    required String cropVariety,
    required int duration,
    required String season,
    required String landType,
    required String irrigationSource,
    required double seedCost,
    required String nitrogen,
    required String phosphorous,
    required String potassium,
    String? manureName,
    double? manureQuantity,
    double? manureCost,
    String? bioFertilizerName,
    double? bioFertilizerQuantity,
    double? bioFertilizerCost,
    String? chemFertilizerName,
    double? chemFertilizerQuantity,
    double? chemFertilizerCost,
    double? plantProtectionCost,
    int? ownLabourNumber,
    double? ownLabourCost,
    int? hiredLabourNumber,
    double? hiredLabourCost,
    double? animalDrawnCost,
    double? animalMechanizedCost,
    double? irrigationCost,
    double? mainProductQuantity,
    double? mainProductPrice,
    double? otherProductionCost,
    double? mainTotalCostProduction,
    double? mainProductTotal,
    double? byProductQuantity,
    double? byProductPrice,
    double? byProductTotal,
    String? fertilizerApplicationMethod,
  }) async {
    final database = await DatabaseService().database;
    return await database.insert(tableName, {
      'aadharId': aadharId,
      'cropName': cropName,
      'area': area,
      'surveyHissaNo': surveyHissaNo,
      'cropVariety': cropVariety,
      'duration': duration,
      'season': season,
      'landType': landType,
      'irrigationSource': irrigationSource,
      'seedCost': seedCost,
      'nitrogen': nitrogen,
      'phosphorous': phosphorous,
      'potassium': potassium,
      'manureName': manureName,
      'manureQuantity': manureQuantity,
      'manureCost': manureCost,
      'bioFertilizerName': bioFertilizerName,
      'bioFertilizerQuantity': bioFertilizerQuantity,
      'bioFertilizerCost': bioFertilizerCost,
      'chemFertilizerName': chemFertilizerName,
      'chemFertilizerQuantity': chemFertilizerQuantity,
      'chemFertilizerCost': chemFertilizerCost,
      'plantProtectionCost': plantProtectionCost,
      'ownLabourNumber': ownLabourNumber,
      'ownLabourCost': ownLabourCost,
      'hiredLabourNumber': hiredLabourNumber,
      'hiredLabourCost': hiredLabourCost,
      'animalDrawnCost': animalDrawnCost,
      'animalMechanizedCost': animalMechanizedCost,
      'irrigationCost': irrigationCost,
      'mainProductQuantity': mainProductQuantity,
      'mainProductPrice': mainProductPrice,
      'otherProductionCost': otherProductionCost,
      'mainTotalCostProduction': mainTotalCostProduction,
      'mainProductTotal': mainProductTotal,
      'byProductQuantity': byProductQuantity,
      'byProductPrice': byProductPrice,
      'byProductTotal': byProductTotal,
      'fertilizerApplicationMethod': fertilizerApplicationMethod,
    });
  }

  Future<List<Map<String, dynamic>>> readAll() async {
    final database = await DatabaseService().database;
    return await database.query(tableName);
  }

  Future<int> update({
    required int id,
    required int aadharId,
    required String cropName,
    required double area,
    required String surveyHissaNo,
    required String cropVariety,
    required int duration,
    required String season,
    required String landType,
    required String irrigationSource,
    required double seedCost,
    required String nitrogen,
    required String phosphorous,
    required String potassium,
    String? manureName,
    double? manureQuantity,
    double? manureCost,
    String? bioFertilizerName,
    double? bioFertilizerQuantity,
    double? bioFertilizerCost,
    String? chemFertilizerName,
    double? chemFertilizerQuantity,
    double? chemFertilizerCost,
    double? plantProtectionCost,
    int? ownLabourNumber,
    double? ownLabourCost,
    int? hiredLabourNumber,
    double? hiredLabourCost,
    double? animalDrawnCost,
    double? animalMechanizedCost,
    double? irrigationCost,
    double? mainProductQuantity,
    double? mainProductPrice,
    double? otherProductionCost,
    double? mainTotalCostProduction,
    double? mainProductTotal,
    double? byProductQuantity,
    double? byProductPrice,
    double? byProductTotal,
    String? fertilizerApplicationMethod,
  }) async {
    final database = await DatabaseService().database;
    return await database.update(
      tableName,
      {
        'aadharId': aadharId,
        'cropName': cropName,
        'area': area,
        'surveyHissaNo': surveyHissaNo,
        'cropVariety': cropVariety,
        'duration': duration,
        'season': season,
        'landType': landType,
        'irrigationSource': irrigationSource,
        'seedCost': seedCost,
        'nitrogen': nitrogen,
        'phosphorous': phosphorous,
        'potassium': potassium,
        'manureName': manureName,
        'manureQuantity': manureQuantity,
        'manureCost': manureCost,
        'bioFertilizerName': bioFertilizerName,
        'bioFertilizerQuantity': bioFertilizerQuantity,
        'bioFertilizerCost': bioFertilizerCost,
        'chemFertilizerName': chemFertilizerName,
        'chemFertilizerQuantity': chemFertilizerQuantity,
        'chemFertilizerCost': chemFertilizerCost,
        'plantProtectionCost': plantProtectionCost,
        'ownLabourNumber': ownLabourNumber,
        'ownLabourCost': ownLabourCost,
        'hiredLabourNumber': hiredLabourNumber,
        'hiredLabourCost': hiredLabourCost,
        'animalDrawnCost': animalDrawnCost,
        'animalMechanizedCost': animalMechanizedCost,
        'irrigationCost': irrigationCost,
        'mainProductQuantity': mainProductQuantity,
        'mainProductPrice': mainProductPrice,
        'otherProductionCost': otherProductionCost,
        'mainTotalCostProduction': mainTotalCostProduction,
        'mainProductTotal': mainProductTotal,
        'byProductQuantity': byProductQuantity,
        'byProductPrice': byProductPrice,
        'byProductTotal': byProductTotal,
        'fertilizerApplicationMethod': fertilizerApplicationMethod,
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

// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// class DatabaseHelper {
//   static final DatabaseHelper instance = DatabaseHelper._init();
//   static Database? _database;

//   DatabaseHelper._init();

//   Future<Database> get database async {
//     if (_database != null) return _database!;

//     _database = await _initDB('cropdetails.db');
//     return _database!;
//   }

//   Future<Database> _initDB(String filePath) async {
//     final dbPath = await getDatabasesPath();
//     final path = join(dbPath, filePath);

//     return await openDatabase(path, version: 1, onCreate: _createDB);
//   }

//   Future _createDB(Database db, int version) async {
//     await db.execute('''
//       CREATE TABLE crop_details (
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         aadharId INTEGER,
//         cropName TEXT,
//         area REAL,
//         surveyHissa TEXT,
//         cropVariety TEXT,
//         duration INTEGER,
//         season TEXT,
//         landType TEXT,
//         irrigationSource TEXT,
//         seedCost REAL,
//         nitrogen TEXT,
//         phosphorous TEXT,
//         potassium TEXT,
//         manureName TEXT,
//         manureQuantity REAL,
//         manureCost REAL,
//         bioFertilizerName TEXT,
//         bioFertilizerQuantity REAL,
//         bioFertilizerCost REAL,
//         chemFertilizerName TEXT,
//         chemFertilizerQuantity REAL,
//         chemFertilizerCost REAL,
//         fertilizerMethod TEXT,
//         plantProtectionCost REAL,
//         ownLabourNumber INTEGER,
//         ownLabourCost REAL,
//         hiredLabourNumber INTEGER,
//         hiredLabourCost REAL,
//         animalDrawnCost REAL,
//         animalMechanizedCost REAL,
//         irrigationCost REAL,
//         otherProductionCost REAL,
//         totalProductionCost REAL,
//         mainProductTotal REAL,
//         byProductQuantity REAL,
//         byProductPrice REAL,
//         byProductTotal REAL
//       )
//     ''');
//   }

//   Future<int> insertCropDetails(Map<String, dynamic> row) async {
//     final db = await instance.database;
//     return await db.insert('crop_details', row);
//   }

//   Future close() async {
//     final db = await instance.database;
//     db.close();
//   }
// }
