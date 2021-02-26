import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:my_diet_diary/Diary-Breakfast.dart';
import 'package:my_diet_diary/Diary-Dinner.dart';
import 'package:my_diet_diary/Diary-Lunch.dart';
import 'package:my_diet_diary/Diary-Snack.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'DataObjects/DatabaseHelper.dart';
import 'DataObjects/FoodEntry.dart';
import 'DataObjects/Meal.dart';

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

  List<Column> _getListTiles(List<FoodEntry> foodEntry) {
    var boldStyle = TextStyle(fontSize: 18, color: Colors.grey[600], fontWeight: FontWeight.bold);
    var normalStyle = TextStyle(fontSize: 18, color: Colors.grey[600]);

    var boldSubtitleStyle = TextStyle(fontSize: 14, color: Colors.grey[600], fontWeight: FontWeight.bold);
    var normalSubtitleStyle = TextStyle(fontSize: 14, color: Colors.grey[600]);

    return foodEntry.map<Column>((FoodEntry foodEntry) {
      return Column(
        children: [
          Divider(),
          ListTile(
              title: RichText(
                  text: new TextSpan(style: normalStyle, children: <TextSpan>[
                new TextSpan(
                  text: foodEntry.name,
                  style: boldStyle,
                ),
                new TextSpan(text: " " + foodEntry.amount.toString(), style: normalStyle),
              ])),
              subtitle: Padding(
                padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: RichText(
                          text: new TextSpan(style: normalSubtitleStyle, children: <TextSpan>[
                        new TextSpan(text: foodEntry.calories.toInt().toString(), style: boldSubtitleStyle),
                        new TextSpan(text: " kcal")
                      ])),
                    ),
                    Expanded(
                      flex: 1,
                      child: RichText(
                          text: new TextSpan(style: normalSubtitleStyle, children: <TextSpan>[
                        new TextSpan(text: foodEntry.protein.toInt().toString() + "g", style: boldSubtitleStyle),
                        new TextSpan(text: " prot.")
                      ])),
                    ),
                    Expanded(
                      flex: 1,
                      child: RichText(
                          text: new TextSpan(style: normalSubtitleStyle, children: <TextSpan>[
                        new TextSpan(text: foodEntry.carbs.toInt().toString() + "g", style: boldSubtitleStyle),
                        new TextSpan(text: " carbs")
                      ])),
                    ),
                    Expanded(
                      flex: 1,
                      child: RichText(
                          text: new TextSpan(style: normalSubtitleStyle, children: <TextSpan>[
                        new TextSpan(text: foodEntry.calories.toInt().toString() + "g", style: boldSubtitleStyle),
                        new TextSpan(text: " fat")
                      ])),
                    ),
                  ],
                ),
              )),
        ],
      );
    }).toList();
  }

  _getDaySummaryText(List<FoodEntry> mealEntries) {
    var boldStyle = TextStyle(fontSize: 18, color: Colors.grey[600], fontWeight: FontWeight.bold);
    var normalStyle = TextStyle(fontSize: 18, color: Colors.grey[600]);

    double calories = 0;
    double protein = 0;

    mealEntries.forEach((FoodEntry foodEntry) {
      calories += foodEntry.calories;
      protein += foodEntry.protein;
    });

    return RichText(
        text: new TextSpan(style: normalStyle, children: <TextSpan>[
      new TextSpan(
        text: calories.toInt().toString(),
        style: boldStyle,
      ),
      new TextSpan(text: " kcal  "),
      new TextSpan(text: protein.toStringAsFixed(1) + "g", style: boldStyle),
      new TextSpan(text: " Protein")
    ]));
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
                                size: Size(280, 130),
                                painter: ProgressArc(
                                    _getCaloriesForMeal(_breakfastToday) +
                                        _getCaloriesForMeal(_lunchToday) +
                                        _getCaloriesForMeal(_dinnerToday) +
                                        _getCaloriesForMeal(_snackToday),
                                    _targetCalories,
                                    Colors.green[300]),
                              ),
                              CustomPaint(
                                size: Size(280, 130),
                                painter: ProgressArc(
                                    _getCaloriesForMeal(_breakfastToday) +
                                        _getCaloriesForMeal(_lunchToday) +
                                        _getCaloriesForMeal(_dinnerToday),
                                    _targetCalories,
                                    Colors.blue[300]),
                              ),
                              CustomPaint(
                                size: Size(280, 130),
                                painter: ProgressArc(
                                    _getCaloriesForMeal(_breakfastToday) + _getCaloriesForMeal(_lunchToday),
                                    _targetCalories,
                                    Colors.yellow[300]),
                              ),
                              CustomPaint(
                                size: Size(280, 130),
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
                          child: ExpansionTile(
                              tilePadding: EdgeInsets.fromLTRB(10, 10, 15, 10),
                              leading: IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => Breakfast_Section()),
                                  );
                                },
                                icon: Icon(Icons.add, color: Colors.amber, size: 30),
                              ),
                              title: Text("Breakfast", style: generalStyle),
                              subtitle: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 8, 0, 0), child: _getDaySummaryText(_breakfastToday)),
                              children: _getListTiles(_breakfastToday))),
                      SizedBox(height: 10),
                      Card(
                          child: ExpansionTile(
                              tilePadding: EdgeInsets.fromLTRB(10, 10, 15, 10),
                              leading: IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => Lunch_Section()),
                                  );
                                },
                                icon: Icon(Icons.add, color: Colors.amber, size: 30),
                              ),
                              title: Text("Lunch", style: generalStyle),
                              subtitle: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 8, 0, 0), child: _getDaySummaryText(_lunchToday)),
                              children: _getListTiles(_lunchToday))),
                      SizedBox(height: 10),
                      Card(
                          child: ExpansionTile(
                              tilePadding: EdgeInsets.fromLTRB(10, 10, 15, 10),
                              leading: IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => Dinner_Section()),
                                  );
                                },
                                icon: Icon(
                                  Icons.add,
                                  color: Colors.amber,
                                  size: 30,
                                ),
                              ),
                              title: Text("Dinner", style: generalStyle),
                              subtitle: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 8, 0, 0), child: _getDaySummaryText(_dinnerToday)),
                              children: _getListTiles(_dinnerToday))),
                      SizedBox(height: 10),
                      Card(
                          child: ExpansionTile(
                              tilePadding: EdgeInsets.fromLTRB(10, 10, 15, 10),
                              leading: IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => Snack_Section()),
                                  );
                                },
                                icon: Icon(
                                  Icons.add,
                                  color: Colors.amber,
                                  size: 30,
                                ),
                              ),
                              title: Text("Snack", style: generalStyle),
                              subtitle: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 8, 0, 0), child: _getDaySummaryText(_snackToday)),
                              children: _getListTiles(_snackToday))),
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
    final rect = Rect.fromLTRB(0, 0, 280, 280);
    final startAngle = -(math.pi - 0.2);
    final sweepAngle = (arc == null || arc > math.pi - 0.4) ? math.pi - 0.4 : arc;
    final userCenter = false;
    final paint = Paint()
      ..strokeCap = StrokeCap.round
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    canvas.drawArc(rect, startAngle, sweepAngle, userCenter, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }


}
