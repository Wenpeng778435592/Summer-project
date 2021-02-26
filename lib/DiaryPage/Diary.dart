import 'package:flutter/material.dart';
import 'package:my_diet_diary/DataObjects/DatabaseHelper.dart';
import 'package:my_diet_diary/DataObjects/FoodEntry.dart';
import 'package:my_diet_diary/DataObjects/Meal.dart';
import 'package:my_diet_diary/Diary-Breakfast.dart';
import 'package:my_diet_diary/Diary-Dinner.dart';
import 'package:my_diet_diary/Diary-Lunch.dart';
import 'package:my_diet_diary/Diary-Snack.dart';
import 'package:my_diet_diary/DiaryPage/CalorieProgressBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'CustomExpansionTile.dart';

class Dairy_Section extends StatefulWidget {
  @override
  _Dairy_SectionState createState() => _Dairy_SectionState();
}

class _Dairy_SectionState extends State<Dairy_Section> {
  static TextStyle generalStyle = TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white);

  Future _futures;

  DatabaseHelper dbHelper = new DatabaseHelper();

  List<FoodEntry> _breakfastToday;
  List<FoodEntry> _lunchToday;
  List<FoodEntry> _dinnerToday;
  List<FoodEntry> _snackToday;

  double _totalCalories;
  double _totalCarbs;
  double _totalProtein;
  double _totalFat;

  double _targetCalories;

  @override
  void initState() {
    super.initState();
    _futures = _getFutures();
  }

  _getFutures() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    int currentUserID = sp.getInt("currentUserID");

    var now = DateTime.now();
    var today = DateTime(now.year, now.month, now.day);

    _breakfastToday = await dbHelper.getMealForDay(today, Meal.breakfast);
    _lunchToday = await dbHelper.getMealForDay(today, Meal.lunch);
    _dinnerToday = await dbHelper.getMealForDay(today, Meal.dinner);
    _snackToday = await dbHelper.getMealForDay(today, Meal.snack);

    _getDayTotals();
    var currentUser = await dbHelper.getUserByID(currentUserID);
    _targetCalories = currentUser.dailyIntake;
  }

  _getDayTotals() {
    _totalCalories = 0;
    _totalCarbs = 0;
    _totalProtein = 0;
    _totalFat = 0;

    _breakfastToday.forEach((FoodEntry foodEntry) {
      _totalCalories += foodEntry.calories;
      _totalCarbs += foodEntry.carbs;
      _totalProtein += foodEntry.protein;
      _totalFat += foodEntry.fat;
    });

    _lunchToday.forEach((FoodEntry foodEntry) {
      _totalCalories += foodEntry.calories;
      _totalCarbs += foodEntry.carbs;
      _totalProtein += foodEntry.protein;
      _totalFat += foodEntry.fat;
    });

    _dinnerToday.forEach((FoodEntry foodEntry) {
      _totalCalories += foodEntry.calories;
      _totalCarbs += foodEntry.carbs;
      _totalProtein += foodEntry.protein;
      _totalFat += foodEntry.fat;
    });

    _snackToday.forEach((FoodEntry foodEntry) {
      _totalCalories += foodEntry.calories;
      _totalCarbs += foodEntry.carbs;
      _totalProtein += foodEntry.protein;
      _totalFat += foodEntry.fat;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Today',
              style: generalStyle,
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.play_arrow),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.amber[800],
      ),
      body: FutureBuilder(
          future: _futures,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
                break;
              default:
                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Column(
                    children: <Widget>[
                      Card(
                        elevation: 0.25,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 35, 0, 35),
                          child: Column(children: [
                            CalorieProgressBar(
                                breakfastFoods: _breakfastToday,
                                lunchFoods: _lunchToday,
                                dinnerFoods: _dinnerToday,
                                snackFoods: _snackToday,
                                caloriesToday: _totalCalories,
                                targetCalories: _targetCalories),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                  Text(_totalProtein.toInt().toString() + "g",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold, color: Colors.grey[700], fontSize: 18)),
                                  Text(" Protein",
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal, color: Colors.grey[700], fontSize: 16))
                                ]),
                                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                  Text(_totalCarbs.toInt().toString() + "g",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold, color: Colors.grey[700], fontSize: 18)),
                                  Text(" Carbs",
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal, color: Colors.grey[700], fontSize: 16))
                                ]),
                                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                  Text(_totalFat.toInt().toString() + "g",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold, color: Colors.grey[700], fontSize: 18)),
                                  Text(" Fat",
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal, color: Colors.grey[700], fontSize: 16))
                                ])
                              ],
                            ),
                          ]),
                        ),
                      ),
                      SizedBox(height: 15),
                      Card(
                          elevation: 0.25,
                          child: CustomExpansionTile(
                              headerText: "Breakfast",
                              color: Colors.red[300],
                              meals: _breakfastToday,
                              nextPage: Breakfast_Section())),
                      SizedBox(height: 5),
                      Card(
                          elevation: 0.25,
                          child: CustomExpansionTile(
                              headerText: "Lunch", color: Colors.amber, meals: _lunchToday, nextPage: Lunch_Section())),
                      SizedBox(height: 5),
                      Card(
                          elevation: 0.25,
                          child: CustomExpansionTile(
                              headerText: "Dinner",
                              color: Colors.blue[300],
                              meals: _dinnerToday,
                              nextPage: Dinner_Section())),
                      SizedBox(height: 5),
                      Card(
                          elevation: 0.25,
                          child: CustomExpansionTile(
                              headerText: "Snack",
                              color: Colors.green[300],
                              meals: _snackToday,
                              nextPage: Snack_Section())),
                      SizedBox(height: 5)
                    ],
                  ),
                );
            }
          }),
    );
  }
}
