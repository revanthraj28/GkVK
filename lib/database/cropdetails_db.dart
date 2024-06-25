import 'package:sqflite/sqflite.dart';
import 'package:gkvk/database/database_service.dart';

class CropdetailsDB {
  final tableName = 'cropdetails_table';

  Future<void> createTable(Database database) async {
    await database.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        "aadharId" INTEGER NOT NULL,
        "cropName" TEXT,
        "cropYear" INTEGER,
        "area" REAL,
        "Hissa" REAL NOT NULL,
        "survey" INTEGER NOT NULL,
        "variety" TEXT,
        "duration" INTEGER,
        "season" TEXT,
        "typeOfLand" TEXT,
        "sourceOfIrrigation" TEXT,
        "cost" INTEGER,
        "nitrogen" TEXT,
        "phosphorous" TEXT,
        "potassium" TEXT,
        "rdfNitrogen" INTEGER,
        "rdfPhosphorous" INTEGER,
        "rdfPotassium" INTEGER,
        "adjustedrdfNitrogen" INTEGER,
        "adjustedrdfPhosphorous" INTEGER,
        "adjustedrdfPotassium" INTEGER,
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
        "otherProductionCost" REAL,
        "totalProductionCost" REAL,
        "mainProductQuantity" REAL,
        "mainProductPrice" REAL,
        "totalProductAmount" REAL,
        "byProductQuantity" REAL,
        "byProductPrice" REAL,
        "totalByProductAmount" REAL,
        "totalAmount" REAL,
        "methodsoffertilizer" TEXT,
        ${List.generate(5, (i) => '''
          "chemicalFertilizerName$i" TEXT,
          "chemicalFertilizerBasal$i" TEXT,
          "chemicalFertilizerTopDress$i" TEXT,
          "chemicalFertilizerTotalQuantity$i" REAL,
          "chemicalFertilizerTotalCost$i" REAL
        ''').join(',')}
      );
    ''');
  }

  Future<int> create(Map<String, dynamic> data) async {
    final database = await DatabaseService().database;
    return await database.insert(tableName, data);
  }

  Future<List<Map<String, dynamic>>> readByAadharId(int aadharId) async {
    final database = await DatabaseService().database;
    return await database.query(
      tableName,
      where: 'aadharId = ?',
      whereArgs: [aadharId],
    );
  }

  Future<int> update(Map<String, dynamic> data, int aadharId) async {
    final database = await DatabaseService().database;
    return await database.update(
      tableName,
      data,
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

  Future<int> saveCropDetails(Map<String, dynamic> data) async {
    final database = await DatabaseService().database;
    return await database.insert(tableName, data);
  }
}
