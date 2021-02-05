import 'dart:io';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import '../DataObjects/FoodEntry.dart';
import '../DataObjects/Meal.dart';
import '../DataObjects/User.dart';
import '../DataObjects/WeightEntry.dart';

class DatabaseHelper {

  static final _dbName = "LocalData.db";
  static final _dbVersion = 1;

  static final _foodHistoryTable = "FoodHistory";
  static final _weightHistoryTable = "WeightHistory";
  static final _userInfoTable = "UserInformation";

  static final _id = "id";

  static final _foodNameCol = "name";
  static final _amountcol = "amount";
  static final _mealCol = "meal";
  static final _caloriesCol = "calories";
  static final _carbsCol = "carbs";
  static final _fatCol = "fat";
  static final _proteinCol = "protein";
  static final _dateCol = "date";

  static final _weightCol = "weight";
  static final _userIDCol = "userID";

  static final _userNameCol = "name";
  static final _userHeightCol = "height";
  static final _userWeightCol = "weight";
  static final _userAgeCol = "age";
  static final _userGenderCol = "gender";
  static final _userTargetWeightCol = "targetWeight";
  static final _userGoal = "goal";
  static final _userActivityLevel = "activityLevel";
  static final _userCalorieGoal = "calorieGoal";
  static final _userDailyIntake = "dailyIntake";
  static final _userTargetDays = "targetDays";

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
      print("initialise");
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
            "$_mealCol TEXT, $_amountcol REAL, $_fatCol REAL, $_carbsCol REAL, $_proteinCol REAL, "
            + "$_caloriesCol REAL, $_userIDCol INTEGER, $_dateCol TEXT)"
    );
    //Create weight table
    await db
        .execute(
        "CREATE TABLE $_weightHistoryTable ($_id INTEGER PRIMARY KEY AUTOINCREMENT, $_weightCol INTEGER,"
            + "$_userIDCol INTEGER, $_dateCol TEXT)"
    );

    //Create user information table
    await db
        .execute(
        "CREATE TABLE $_userInfoTable ($_id INTEGER PRIMARY KEY AUTOINCREMENT, $_userAgeCol INTEGER,"
            + "$_userHeightCol INTEGER, $_userWeightCol INTEGER, $_userTargetWeightCol INTEGER,$_userGenderCol TEXT,"
            + "$_userNameCol TEXT, $_userGoal TEXT, $_userActivityLevel INTEGER, $_userCalorieGoal INTEGER,"
            + "$_userDailyIntake INTEGER, $_userTargetDays INTEGER)"

    );
  }

/*
  Helper functions
 */

  //Food history functions

  Future<List<FoodEntry>> getAllFoodHistory() async {
    final Database db = await this.database;

    List<Map> queryResults = await db.rawQuery('SELECT * FROM $_foodHistoryTable');

    return _convertToFoodObjectList(queryResults);
  }

  Future<List<FoodEntry>> getFoodHistoryForDay(DateTime date) async {
    Database db = await this.database;
    String day = date.toString().split(" ")[0];

    List<Map> queryResults = await db.query(
        _foodHistoryTable,
        where: '$_dateCol LIKE ?',
        whereArgs: ['%$day%']
    );

    return _convertToFoodObjectList(queryResults);
  }

  //Returns entries matching the specified meal type for the day
  Future<List<FoodEntry>> getMealForDay(DateTime date, Meal mealType) async {
    Database db = await this.database;
    String day = date.toString().split(" ")[0];

    String meal = mealType.value;
    print("meal " + meal);

    List<Map> queryResults = await db.query(
        _foodHistoryTable,
        where: '$_dateCol LIKE ? AND $_mealCol = ?',
        whereArgs: ['%$day%', meal]
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
    print('FoodEntry working in dbhelper');
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

// User information functions
  Future<User> getUserByID(int id) async {
    Database db = await this.database;

    List<Map> result = await db.query(_userInfoTable, where: '$_id = ?',
        whereArgs: [id]);
    return result.isNotEmpty ? User.fromMap(result.first) : Null;
  }

  Future<int> addUser(User user) async {
    Database db = await this.database;

   int insertedID = await db.insert(
        _userInfoTable,
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace
    );

   return insertedID;
  }

  Future<void> replaceUser(User user) async {
    Database db = await this.database;

    await db.insert(
        _userInfoTable,
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<List<User>> getUsers() async {
    Database db = await this.database;

    List<Map> queryResults = await db.query(
        'SELECT * FROM $_userInfoTable');

    List<User> users = new List();
    queryResults.forEach((result) {
      User user= User.fromMap(result);
      users.add(user);
    });

    return users;
  }

}
