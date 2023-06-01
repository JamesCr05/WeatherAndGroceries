import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class Ingredient {
  final int id;
  final double amount;
  final String unit;
  final String item;

  Ingredient({
    required this.id,
    required this.amount,
    required this.unit,
    required this.item,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'unit': unit,
      'item': item,
    };
  }

  @override
  String toString() {
    return 'Ingredient{id: $id, amount: $amount, unit: $unit, item: $item}';
  }
}

class IngredientsDatabaseHelper {
  static const dbName = 'ingredients.db';
  static const dbVersion = 1;
  static const tableName = 'ingredients';
  static const colId = 'id';
  static const colAmount = 'amount';
  static const colUnit = 'units';
  static const colItem = 'item';
  static final IngredientsDatabaseHelper instance = IngredientsDatabaseHelper();
  static Database? ingredientsDb;

  Future<Database?> get db async {
    ingredientsDb ??= await _initDb();
    return ingredientsDb;
  }

  _initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, dbName);
    return await openDatabase(path, version: dbVersion, onCreate: _onCreate);
  }

  _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $tableName(
    $colId INTEGER PRIMARY KEY AUTOINCREMENT,
    $colAmount REAL NOT NULL,
    $colUnit TEXT NOT NULL,
    $colItem TEXT NOT NULL)''');
  }

  Future<int> insertIngredient(Map<String, dynamic> row) async {
    Database? db = await instance.db;
    return await db!.insert(tableName, row);
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    Database? db = await instance.db;
    return await db!.query(tableName);
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database? db = await instance.db;
    int id = row[colId];
    return await db!
        .update(tableName, row, where: '$colId = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database? db = await instance.db;
    return await db!.delete(tableName, where: '$colId = ?', whereArgs: [id]);
  }

  Future close() async {
    Database? db = await instance.db;
    db!.close();
  }
}
