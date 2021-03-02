import 'dart:collection';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'DataObjects/DatabaseHelper.dart';
import 'DataObjects/FoodDayData.dart';
import 'DataObjects/FoodEntry.dart';
import 'DataObjects/User.dart';

class Report_Section extends StatefulWidget {
  @override
  _Report_SectionState createState() => _Report_SectionState();
}

class _Report_SectionState extends State<Report_Section> {
  static TextStyle generalStyle = TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white);
  static TextStyle titleStyle = TextStyle(fontSize: 20, color: Colors.grey[700], fontWeight: FontWeight.bold);
  static TextStyle subTextStyle = TextStyle(fontSize: 18, color: Colors.grey[700]);
  static TextStyle subTextBoldStyle = TextStyle(fontSize: 18, color: Colors.grey[700], fontWeight: FontWeight.w500);

  final Duration animDuration = const Duration(milliseconds: 250);

  Future _futures;

  //Date of the first food entry (to disable button if range is below this)
  DateTime _firstEntryDate;

  //Beginning day of the current viewable week
  DateTime _startDate;

  //End day of the current viewable week
  DateTime _endDate;

  double _caloriesThisWeek;

  int touchedIndex;

  DatabaseHelper dbHelper = new DatabaseHelper();

  List<FoodEntry> _currentWeekFoodEntries = new List<FoodEntry>();

  Map _currentWeekSummaryData = LinkedHashMap<String, FoodDayData>();

  @override
  void initState() {
    super.initState();
    _futures = getFutures();
  }

  Future<User> getFutures() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var userID = sp.getInt("currentUserID");

    //Initialise date range
    var now = DateTime.now();
    _endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);

    var oneWeekAgo = _endDate.subtract(Duration(days: 6));
    _startDate = DateTime(oneWeekAgo.year, oneWeekAgo.month, oneWeekAgo.day, 0, 0, 0);

    var firstFoodEntry = await dbHelper.getFirstFoodEntry(userID);

    if (firstFoodEntry == null) {
      var firstEntryDate = DateTime.now();
      _firstEntryDate = DateTime(firstEntryDate.year, firstEntryDate.month, firstEntryDate.day, 0, 0, 0);
    } else {
      var firstEntryDate = DateTime.parse(firstFoodEntry.date);
      _firstEntryDate = DateTime(firstEntryDate.year, firstEntryDate.month, firstEntryDate.day, 0, 0, 0);
    }

    _currentWeekFoodEntries = await _getFoodEntriesForWeek(sp.getInt("currentUserID"));

    _caloriesThisWeek = _getCaloriesForWeek();

    return dbHelper.getUserByID(userID);
  }

  int _getDailyCalorieAverageForWeek() {
    double totalCalories = 0;

    List<String> dates = new List<String>();

    _currentWeekFoodEntries.forEach((foodEntry) {
      totalCalories = totalCalories + foodEntry.calories;
      dates.add(foodEntry.date.split(" ")[0]);
    });

    dates = dates.toSet().toList();
    return dates.length != 0 ? (totalCalories / dates.length).toInt() : 0;
  }

  double _getCaloriesForWeek() {
    double totalCalories = 0;

    _currentWeekFoodEntries.forEach((foodEntry) {
      totalCalories = totalCalories + foodEntry.calories;
    });

    return totalCalories;
  }

  Future<List<FoodEntry>> _getFoodEntriesForWeek(int id) async {
    return await dbHelper.getFoodEntriesBetweenDates(id, _startDate, _endDate);
  }

  arrowButtonPressed(String direction, int id) async {
    var newEndDate;
    var newStartDate;

    switch (direction) {
      case "forward":
        newStartDate = _endDate.add(Duration(days: 1));
        newStartDate = DateTime(newStartDate.year, newStartDate.month, newStartDate.day, 0, 0, 0);

        newEndDate = newStartDate.add(Duration(days: 6));
        newEndDate = DateTime(newEndDate.year, newEndDate.month, newEndDate.day, 23, 59, 59);

        break;
      case "backward":
        newStartDate = _startDate.subtract(Duration(days: 7));

        newEndDate = newStartDate.add(Duration(days: 6));
        newEndDate = DateTime(newEndDate.year, newEndDate.month, newEndDate.day, 23, 59, 59);

        break;
    }

    _endDate = newEndDate;
    _startDate = newStartDate;

    _currentWeekFoodEntries = await _getFoodEntriesForWeek(id);

    setState(() {});
  }

  getDateRangeText() {
    if (_startDate.isAfter(DateTime.now().subtract(Duration(days: 7)))) {
      return "This Week";
    } else if (_startDate.isAfter(DateTime.now().subtract(Duration(days: 14)))) {
      return "Last Week";
    } else {
      return DateFormat('EEE MMM d').format(_startDate) + " - " + DateFormat('MMM d').format(_endDate);
    }
  }

  _getCalorieSummaryData() {
    Map currentWeekSummaryData = LinkedHashMap<String, FoodDayData>();

    currentWeekSummaryData = {
      new DateFormat('yyyy-MM-dd').format(_endDate.subtract(Duration(days: 6))): FoodDayData(0, 0, 0, 0),
      new DateFormat('yyyy-MM-dd').format(_endDate.subtract(Duration(days: 5))): FoodDayData(0, 0, 0, 0),
      new DateFormat('yyyy-MM-dd').format(_endDate.subtract(Duration(days: 4))): FoodDayData(0, 0, 0, 0),
      new DateFormat('yyyy-MM-dd').format(_endDate.subtract(Duration(days: 3))): FoodDayData(0, 0, 0, 0),
      new DateFormat('yyyy-MM-dd').format(_endDate.subtract(Duration(days: 2))): FoodDayData(0, 0, 0, 0),
      new DateFormat('yyyy-MM-dd').format(_endDate.subtract(Duration(days: 1))): FoodDayData(0, 0, 0, 0),
      new DateFormat('yyyy-MM-dd').format(_endDate): FoodDayData(0, 0, 0, 0)
    };

    _currentWeekFoodEntries.forEach((foodEntry) {
      var foodEntryDateFormatted = foodEntry.date.split(" ")[0];

      FoodDayData currentDataForDate = currentWeekSummaryData[foodEntryDateFormatted];
      currentDataForDate.calories += foodEntry.calories;
      currentDataForDate.fat += foodEntry.fat;
      currentDataForDate.protein += foodEntry.protein;
      currentDataForDate.carbs += foodEntry.carbs;
    });

    return currentWeekSummaryData;
  }

  _getMaxY() {
    double maxY = 0;
    _currentWeekSummaryData.forEach((date, data) {
      if (data.calories > maxY) {
        maxY = data.calories;
      }
    });

    return maxY + 100;
  }

  _borderData() {
    return FlBorderData(
      show: true,
      border: Border.symmetric(
        horizontal: BorderSide(color: Colors.grey[300], width: 2),
      ),
    );
  }

  _barGroups() {
    var barWidth = 40;
    Map summaryData = LinkedHashMap<String, FoodDayData>();

    summaryData = _getCalorieSummaryData();

    List<BarChartGroupData> barGroup = new List<BarChartGroupData>();

    int barNumber = 0;

    summaryData.forEach((date, data) {
      BarChartRodData rodData = new BarChartRodData(
          y: touchedIndex == barNumber ? data.calories + 50 : data.calories,
          width: barWidth.toDouble(),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(6),
          ),
          colors: touchedIndex == barNumber ? [Colors.amber] : [Colors.blue]);

      BarChartGroupData groupData = new BarChartGroupData(x: barNumber, barRods: [rodData]);

      barGroup.add(groupData);

      barNumber++;
    });

    return barGroup;
  }

  _titlesData() {
    return FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(color: Colors.black, fontSize: 12),
          getTitles: (double index) {
            List<dynamic> dateList = _currentWeekSummaryData.keys.toList();
            var dateAtIndex = dateList.elementAt(index.toInt());

            DateTime date = DateTime.parse(dateAtIndex);
            return DateFormat('E').format(date);
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTitles: (double value) => value.toInt().toString(),
          interval: 500,
          getTextStyles: (value) => const TextStyle(color: Colors.black, fontSize: 12),
        ));
  }

  _barTouchData() {
    return BarTouchData(
      enabled: true,
      touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.grey[800],
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            List<dynamic> dateList = _currentWeekSummaryData.keys.toList();
            String dateString = dateList.elementAt(group.x.toInt());

            FoodDayData dayData = _currentWeekSummaryData[dateString];

            return BarTooltipItem(
                "$dateString\n\nCalories: ${dayData.calories.toString()}cal\nCarbs: ${dayData.carbs.toString()}g\n" +
                    "Fat: ${dayData.fat.toString()}g\nProtein: ${dayData.protein.toString()}g",
                TextStyle(color: Colors.white));
          }),
      touchCallback: (barTouchResponse) {
        setState(() {
          if (barTouchResponse.spot != null &&
              barTouchResponse.touchInput is! FlPanEnd &&
              barTouchResponse.touchInput is! FlLongPressEnd) {
            touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
          } else {
            touchedIndex = -1;
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Energy Chart',
          style: generalStyle,
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
                User currentUser = snapshot.data;

                _currentWeekSummaryData = _getCalorieSummaryData();

                return SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Card(
                        elevation: 0.25,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 35, 20, 20),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  SizedBox(
                                    height: 24.0,
                                    width: 24.0,
                                    child: IconButton(
                                      padding: new EdgeInsets.all(0.0),
                                      iconSize: 24,
                                      icon: Icon(Icons.arrow_back_ios_rounded),
                                      color: _startDate.isBefore(_firstEntryDate) ? Colors.grey : Colors.amber,
                                      onPressed: _startDate.isBefore(_firstEntryDate)
                                          ? null
                                          : () => arrowButtonPressed("backward", currentUser.id),
                                    ),
                                  ),
                                  Text(
                                    getDateRangeText(),
                                    style: titleStyle,
                                  ),
                                  SizedBox(
                                    height: 24.0,
                                    width: 24.0,
                                    child: IconButton(
                                      padding: new EdgeInsets.all(0.0),
                                      iconSize: 24,
                                      icon: Icon(Icons.arrow_forward_ios_rounded),
                                      color: _startDate.isAfter(DateTime.now()) ? Colors.grey : Colors.amber,
                                      onPressed: _startDate.isAfter(DateTime.now().subtract(Duration(days: 7)))
                                          ? null
                                          : () => arrowButtonPressed("forward", currentUser.id),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(5, 35, 5, 0),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Calories This Week',
                                      style: subTextStyle,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                  child: Row(children: <Widget>[
                                    Text(_caloriesThisWeek.toStringAsFixed(0),
                                        style: TextStyle(
                                            fontSize: 36, fontWeight: FontWeight.bold, color: Colors.grey[800])),
                                  ])),
                              Container(
                                padding: EdgeInsets.fromLTRB(5, 5, 5, 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Text(
                                        'Daily Average: ',
                                        style: subTextStyle,
                                      ),
                                      Text(
                                        _getDailyCalorieAverageForWeek().toString(),
                                        style: subTextBoldStyle,
                                      ),
                                    ]),
                                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Text(
                                        'Goal: ',
                                        style: subTextStyle,
                                      ),
                                      Text(
                                        currentUser.dailyIntake.round().toString(),
                                        style: subTextBoldStyle,
                                      ),
                                    ])
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Card(
                        elevation: 0.25,
                        child: Container(
                            height: 250,
                            padding: EdgeInsets.fromLTRB(20, 20, 35, 15),
                            width: double.infinity,
                            child: BarChart(BarChartData(
                                maxY: _getMaxY(),
                                barGroups: _barGroups(),
                                titlesData: _titlesData(),
                                barTouchData: _barTouchData(),
                                borderData: _borderData()))),
                      )
                    ],
                  ),
                );
            }
          }),
    );
  }
}
