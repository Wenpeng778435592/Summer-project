import 'dart:io';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'FoodEntry.dart';
import 'Meal.dart';
import 'WeightEntry.dart';

class DatabaseHelper {

  static final _dbName = "LocalData.db";
  static final _dbVersion = 1;

  static final _foodHistoryTable = "FoodHistory";
  static final _weightHistoryTable = "WeightHistory";

  static final _id = "id";

  static final _foodNameCol = "name";
  static final _mealCol = "meal";
  static final _caloriesCol = "calories";
  static final _carbsCol = "carbs";
  static final _fatCol = "fat";
  static final _proteinCol = "protein";
  static final _dateCol = "date";

  static final _weightCol = "weight";
  static final _userIDCol = "userID";

  static Database _database;
  static DatabaseHelper _databaseHelper; //SINGLETON DBHELPER
  DatabaseHelper._createInstance(); //NAMED CONST TO CREATE INSTANCE OF THE DBHELPER

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper =
          DatabaseHelper._createInstance(); //EXEC ONLY ONCE (SINGLETON OBJ)
    }

    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    //Get path to store database file
    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = directory.path + _dbName;
    var database = await openDatabase(
        dbPath, version: _dbVersion, onCreate: _createDb);

    return database;
  }

  void _createDb(Database db, int newVersion) async {
    //Create food table
    await db
        .execute(
        "CREATE TABLE $_foodHistoryTable ($_id INTEGER PRIMARY KEY AUTOINCREMENT, $_foodNameCol TEXT,"
            +
            "$_mealCol TEXT, $_fatCol INTEGER, $_carbsCol INTEGER, $_proteinCol INTEGER, "
            + "$_caloriesCol INTEGER, $_userIDCol INTEGER, $_dateCol TEXT)"
    );
    //Create weight table
    await db
        .execute(
        "CREATE TABLE $_weightHistoryTable ($_id INTEGER PRIMARY KEY AUTOINCREMENT, $_weightCol INTEGER,"
            + "$_userIDCol INTEGER, $_dateCol TEXT)"
    );
  }

/*
  Helper functions
 */

  //Food history functions

  Future<List<FoodEntry>> getAllFoodHistory() async {
    final Database db = await this.database;

    print("db awaited");

    List<Map> queryResults = await db.rawQuery('SELECT * FROM $_foodHistoryTable');

    return _convertToFoodObjectList(queryResults);
  }

  Future<List<FoodEntry>> getFoodHistoryForDay(DateTime date) async {
    Database db = await this.database;
    String day = date.day.toString();

    print("day; " + day);

    List<Map> queryResults = await db.query(
        _foodHistoryTable,
        where: '$_dateCol LIKE ?',
        whereArgs: [day]
    );

    return _convertToFoodObjectList(queryResults);
  }

  //Returns entries matching the specified meal type for the day
  Future<List<FoodEntry>> getMealForDay(DateTime date, Meal mealType) async {
    Database db = await this.database;
    String day = date.day.toString();

    List<Map> queryResults = await db.query(
        _foodHistoryTable,
        where: '$_dateCol LIKE ? && $_mealCol = ?',
        whereArgs: [day, mealType.toString()]
    );

    return _convertToFoodObjectList(queryResults);
  }

  Future<void> addFoodEntry(FoodEntry foodEntry) async {
    Database db = await this.database;

    await db.insert(
        _foodHistoryTable,
        foodEntry.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<void> deleteFoodEntry(int id) async {
    Database db = await this.database;

    await db.delete(
        _foodHistoryTable, where: '$_id = ?', whereArgs: [id]
    );
  }

  Future<FoodEntry> getFoodEntry(int id) async {
    Database db = await this.database;

    List<Map> result = await db.query(_foodHistoryTable, where: '$_id = ?',
        whereArgs: [id]);
    return result.isNotEmpty ? FoodEntry.fromMap(result.first) : Null;
  }

  //Private function used by helper functions to convert a query result into
  // food entry objects
  List<FoodEntry> _convertToFoodObjectList(List<Map> queryResults) {
    List<FoodEntry> foodEntries = new List();
    queryResults.forEach((result) {
      FoodEntry foodEntry = FoodEntry.fromMap(result);
      foodEntries.add(foodEntry);
      print(foodEntry.toString());
    });

    return foodEntries;
  }

  // Weight History functions
  Future<List<WeightEntry>> getWeightHistoryForUser() async {
    Database db = await this.database;

    List<Map> queryResults = await db.query(
        'SELECT * FROM $_weightHistoryTable');

    List<WeightEntry> weightEntries = new List();
    queryResults.forEach((result) {
      WeightEntry weightEntry = WeightEntry.fromMap(result);
      weightEntries.add(weightEntry);
    });

    return weightEntries;
  }

  Future<void> addWeightEntry(WeightEntry weightEntry) async {
    Database db = await this.database;

    await db.insert(
        _weightHistoryTable,
        weightEntry.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<void> deleteWeightEntry(int id) async {
    Database db = await this.database;

    await db.delete(
        _weightHistoryTable, where: '$_id = ?', whereArgs: [id]
    );
  }

}