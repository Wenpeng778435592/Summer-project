import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper{

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
      print("not created yet");
      _databaseHelper =
          DatabaseHelper._createInstance(); //EXEC ONLY ONCE (SINGLETON OBJ)
    }
    print("created already");
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
    print("path: " + dbPath);
    var database = await openDatabase(dbPath, version: _dbVersion, onCreate: _createDb);
    return database;
  }

  void _createDb(Database db, int newVersion) async {
    //Create food table
    await db
        .execute("CREATE TABLE $_foodHistoryTable ($_id INTEGER PRIMARY KEY AUTOINCREMENT, $_foodNameCol TEXT,"
        + "$_mealCol TEXT, $_fatCol INTEGER, $_carbsCol INTEGER, $_proteinCol INTEGER, "
        + "$_caloriesCol INTEGER, $_userIDCol INTEGER, $_dateCol TEXT)"
    );
    //Create weight table
    await db
        .execute("CREATE TABLE $_weightHistoryTable ($_id INTEGER PRIMARY KEY AUTOINCREMENT, $_weightCol INTEGER,"
        +"$_userIDCol INTEGER, $_dateCol TEXT)"
    );
  }

}