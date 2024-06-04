import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:gkvk/database/gkvk_db.dart';
import 'package:gkvk/database/farmer_profile_db.dart';

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
    await GkvkDB().createTable(database);
    await FarmerProfileDB().createTable(database);
  }
}