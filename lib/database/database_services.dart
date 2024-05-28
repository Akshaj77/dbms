import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._();

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'village.db');

    // Make sure the parent directory exists
    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (_) {}

    // Try to load the database from the assets and copy it to the app's private storage
    try {
      ByteData data = await rootBundle.load(join('assets', 'village.db'));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } catch (e) {
      print("Creating new database");

      // Create the database
      await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE Products (
            Product_ID INT PRIMARY KEY,
            Product_Name VARCHAR(255),
            Price DECIMAL(10, 2)
          )
        ''');
        await db.execute('''
          CREATE TABLE Inventory (
            Product_ID INTEGER PRIMARY KEY,
            Quantity_Available INT,
            FOREIGN KEY (Product_ID) REFERENCES Products(Product_ID)
          )
        ''');
      });
    }

    // open the database
    return await openDatabase(path, readOnly: false);
  }
}