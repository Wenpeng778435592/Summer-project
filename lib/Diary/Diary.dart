import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:my_diet_diary/DataObjects/DatabaseHelper.dart';
import 'package:my_diet_diary/DataObjects/FoodEntry.dart';
import 'package:my_diet_diary/DataObjects/Meal.dart';
import 'package:my_diet_diary/Diary-Breakfast.dart';
import 'package:my_diet_diary/Diary-Dinner.dart';
import 'package:my_diet_diary/Diary-Lunch.dart';
import 'package:my_diet_diary/Diary-Snack.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'CustomExpansionTile.dart';

class Dairy_Section extends StatefulWidget {
  @override
  _Dairy_SectionState createState() => _Dairy_SectionState();
}

class _Dairy_SectionState extends State<Dairy_Section> {
  static TextStyle generalStyle = TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey[800]);

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

  Widget _getCalorieDifferenceText() {
    var color;
    var text;

    if (_targetCalories > _totalCalories) {
      text = (_targetCalories - _totalCalories).toInt().toString() + " kcal left";
      color = Colors.grey[500];
    } else {
      text = (_totalCalories - _targetCalories).toInt().toString() + " kcal over";
      color = Colors.red[300];
    }

    return Text(text, style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal, color: color));
  }

  _getCaloriesForMeal(List<FoodEntry> mealEntries) {
    double calories = 0;

    mealEntries.forEach((FoodEntry foodEntry) {
      calories += foodEntry.calories;
    });

    return calories;
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
                  padding: EdgeInsets.fromLTRB(10, 50, 10, 10),
                  child: Column(
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                          child: Stack(
                            children: [
                              CustomPaint(
                                size: Size(280, 130),
                                painter: ProgressArc(null, null, Colors.grey[300]),
                              ),
                              CustomPaint(
                                size: Size(300, 150),
                                painter: ProgressArc(
                                    _getCaloriesForMeal(_breakfastToday) +
                                        _getCaloriesForMeal(_lunchToday) +
                                        _getCaloriesForMeal(_dinnerToday) +
                                        _getCaloriesForMeal(_snackToday),
                                    _targetCalories,
                                    Colors.green[300]),
                              ),
                              CustomPaint(
                                size: Size(300, 150),
                                painter: ProgressArc(
                                    _getCaloriesForMeal(_breakfastToday) +
                                        _getCaloriesForMeal(_lunchToday) +
                                        _getCaloriesForMeal(_dinnerToday),
                                    _targetCalories,
                                    Colors.blue[300]),
                              ),
                              CustomPaint(
                                size: Size(300, 150),
                                painter: ProgressArc(
                                    _getCaloriesForMeal(_breakfastToday) + _getCaloriesForMeal(_lunchToday),
                                    _targetCalories,
                                    Colors.yellow[300]),
                              ),
                              CustomPaint(
                                size: Size(300, 150),
                                painter:
                                    ProgressArc(_getCaloriesForMeal(_breakfastToday), _targetCalories, Colors.red[300]),
                              ),
                              Positioned.fill(
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: Padding(
                                          padding: EdgeInsets.fromLTRB(10, 45, 15, 10),
                                          child: Column(
                                            children: [
                                              RichText(
                                                  text: new TextSpan(
                                                      style: TextStyle(
                                                          fontSize: 24,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.grey[800]),
                                                      children: <TextSpan>[
                                                    new TextSpan(
                                                        text: _totalCalories.toInt().toString(),
                                                        style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                                                    new TextSpan(
                                                        text: " kcal",
                                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
                                                  ])),
                                              _getCalorieDifferenceText()
                                            ],
                                          ))))
                            ],
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          RichText(
                              text: new TextSpan(
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[700]),
                                  children: <TextSpan>[
                                new TextSpan(text: _totalProtein.toInt().toString() + "g"),
                                new TextSpan(text: " Protein", style: TextStyle(fontWeight: FontWeight.normal)),
                              ])),
                          RichText(
                              text: new TextSpan(
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[700]),
                                  children: <TextSpan>[
                                new TextSpan(text: _totalCarbs.toInt().toString() + "g"),
                                new TextSpan(text: " Carbs", style: TextStyle(fontWeight: FontWeight.normal))
                              ])),
                          RichText(
                              text: new TextSpan(
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[700]),
                                  children: <TextSpan>[
                                new TextSpan(text: _totalFat.toInt().toString() + "g"),
                                new TextSpan(text: " Fat", style: TextStyle(fontWeight: FontWeight.normal))
                              ]))
                        ],
                      ),
                      SizedBox(height: 40),
                      Card(
                          child: CustomExpansionTile(
                              headerText: "Breakfast",
                              color: Colors.red[300],
                              meals: _breakfastToday,
                              nextPage: Breakfast_Section())),
                      SizedBox(height: 10),
                      Card(
                          child: CustomExpansionTile(
                              headerText: "Lunch", color: Colors.amber, meals: _lunchToday, nextPage: Lunch_Section())),
                      SizedBox(height: 10),
                      Card(
                          child: CustomExpansionTile(
                              headerText: "Dinner",
                              color: Colors.blue[300],
                              meals: _dinnerToday,
                              nextPage: Dinner_Section())),
                      SizedBox(height: 10),
                      Card(
                          child: CustomExpansionTile(
                              headerText: "Snack",
                              color: Colors.green[300],
                              meals: _snackToday,
                              nextPage: Snack_Section())),
                      SizedBox(height: 10)
                    ],
                  ),
                );
            }
          }),
    );
  }
}

class ProgressArc extends CustomPainter {
  bool isBackground;
  double calories;
  double targetCalories;
  Color progressColor;
  double arc;

  ProgressArc(double calories, double targetCalories, Color progressColor) {
    this.calories = calories;
    this.targetCalories = targetCalories;
    this.progressColor = progressColor;
    this.isBackground = isBackground;

    if (calories != null) {
      this.arc = (calories / targetCalories) * (math.pi - 0.4);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTRB(0, 0, 300, 300);
    final startAngle = -(math.pi - 0.2);
    final sweepAngle = (arc == null || arc > math.pi - 0.4) ? math.pi - 0.4 : arc;
    final userCenter = false;
    final paint = Paint()
      ..strokeCap = StrokeCap.round
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;

    canvas.drawArc(rect, startAngle, sweepAngle, userCenter, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
