import 'package:flutter/material.dart';
import 'package:my_diet_diary/Diary-Breakfast.dart';
import 'package:my_diet_diary/Diary-Dinner.dart';
import 'package:my_diet_diary/Diary-Lunch.dart';
import 'package:my_diet_diary/Diary-Snack.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'DataObjects/DatabaseHelper.dart';
import 'DataObjects/FoodEntry.dart';
import 'DataObjects/Meal.dart';
import 'DataObjects/User.dart';

class Dairy_Section extends StatefulWidget {
  @override
  _Dairy_SectionState createState() => _Dairy_SectionState();
}

class _Dairy_SectionState extends State<Dairy_Section> {
  static const TextStyle generalStyle = TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
  static const TextStyle tableStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  static const TextStyle subtitleStyle = TextStyle(fontSize: 18, color: Colors.grey);

  Future _futures;

  DatabaseHelper dbHelper = new DatabaseHelper();

  List<FoodEntry> _breakfastToday;
  List<FoodEntry> _lunchToday;
  List<FoodEntry> _dinnerToday;
  List<FoodEntry> _snackToday;

  User _currentUser;

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

    _currentUser = await dbHelper.getUserByID(currentUserID);
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
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                        child: Table(
                          border: TableBorder.all(color: Colors.black),
                          children: [
                            TableRow(
                              children: [
                                Text(
                                  'Goal Energy',
                                  style: tableStyle,
                                ),
                                Text(
                                  'Food Energy',
                                  style: tableStyle,
                                ),
                                Text(
                                  'Difference',
                                  style: tableStyle,
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Text(
                                  '2000',
                                  style: tableStyle,
                                ),
                                Text(
                                  '2500',
                                  style: tableStyle,
                                ),
                                Text(
                                  '500',
                                  style: tableStyle,
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Text(
                                  'Protein',
                                  style: tableStyle,
                                ),
                                Text(
                                  'Carbohydrate',
                                  style: tableStyle,
                                ),
                                Text(
                                  'Fat',
                                  style: tableStyle,
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Text(
                                  'x',
                                  style: tableStyle,
                                ),
                                Text(
                                  'x',
                                  style: tableStyle,
                                ),
                                Text(
                                  'x',
                                  style: tableStyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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
