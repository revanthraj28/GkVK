import 'package:sqflite/sqflite.dart';
import 'package:gkvk/database/database_service.dart';

class CropdetailsDB {
  final tableName = 'cropdetails_table';

  Future<void> createTable(Database database) async {
    await database.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        "aadharId" INTEGER NOT NULL,
        "cropName" TEXT NOT NULL,
        "area" REAL NOT NULL,
        "surveyHissa" TEXT,
        "variety" TEXT,
        "duration" INTEGER,
        "season" TEXT,
        "typeOfLand" TEXT,
        "sourceOfIrrigation" TEXT,
        "cost" INTEGER,
        "nitrogen" TEXT,
        "phosphorous" TEXT,
        "potassium" TEXT,
        "rdfNitrogen" TEXT,
        "rdfPhosphorous" TEXT,
        "rdfPotassium" TEXT,
        "adjustedrdfNitrogen" TEXT,
        "adjustedrdfPhosphorous" TEXT,
        "adjustedrdfPotassium" TEXT,
        "organicManureName" TEXT,
        "organicManureQuantity" REAL,
        "organicManureCost" REAL,
        "bioFertilizerName" TEXT,
        "bioFertilizerQuantity" REAL,
        "bioFertilizerCost" REAL,
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
        "mainProductAmount" REAL,
        "byProductQuantity" REAL,
        "byProductPrice" REAL,
        "byProductAmount" REAL,
        "totalByProductAmount1" REAL,
        "totalByProductAmount2" REAL,
        "totalByProductAmount3" REAL,
        "methodsoffertilizer" TEXT,
        ${List.generate(5, (i) => '''
          "chemicalFertilizerName$i" TEXT,
          "chemicalFertilizerBasal$i" TEXT,
          "chemicalFertilizerTopDress$i" TEXT,
          "chemicalFertilizerTotalQuantity$i" REAL,
          "chemicalFertilizerTotalCost$i" REAL
        ''').join(',')},
        PRIMARY KEY ("aadharId", "cropName")
      );
    ''');
  }

  Future<int> create(Map<String, dynamic> data) async {
    final database = await DatabaseService().database;
    return await database.insert(tableName, data);
  }

  Future<List<Map<String, dynamic>>> readAll() async {
    final database = await DatabaseService().database;
    return await database.query(tableName);
  }

  Future<int> update(Map<String, dynamic> data, int aadharId, String cropName) async {
    final database = await DatabaseService().database;
    return await database.update(
      tableName,
      data,
      where: 'aadharId = ? AND cropName = ?',
      whereArgs: [aadharId, cropName],
    );
  }

  Future<int> delete(int aadharId, String cropName) async {
    final database = await DatabaseService().database;
    return await database.delete(
      tableName,
      where: 'aadharId = ? AND cropName = ?',
      whereArgs: [aadharId, cropName],
    );
  }
}
