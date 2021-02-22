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
  static const TextStyle boldStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  static const TextStyle normalStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.w500);

  final Duration animDuration = const Duration(milliseconds: 250);

  Future _futures;

  //Date of the first food entry (to disable button if range is below this)
  DateTime _firstEntryDate;

  //Beginning day of the current viewable week
  DateTime _startDate;

  //End day of the current viewable week
  DateTime _endDate;

  double _caloriesToday;

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
    var firstEntryDate = DateTime.parse(firstFoodEntry.date);
    _firstEntryDate = DateTime(firstEntryDate.year, firstEntryDate.month, firstEntryDate.day, 0, 0, 0);

    _currentWeekFoodEntries = await _getFoodEntriesForWeek(sp.getInt("currentUserID"));

    _caloriesToday = _getCaloriesForDay();

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

  double _getCaloriesForDay() {
    double totalCalories = 0;

    String today = DateTime.now().toString().split(" ")[0];

    _currentWeekFoodEntries.forEach((foodEntry) {
      String foodEntryDate = foodEntry.date.toString().split(" ")[0];

      if (foodEntryDate == today) {
        totalCalories = totalCalories + foodEntry.calories;
      }
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
      return DateFormat('MMM d').format(_startDate) + " - " + DateFormat('MMM d').format(_endDate);
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
          style: boldStyle,
        ),
        centerTitle: true,
        backgroundColor: Colors.amber[800],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
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

                  return Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              IconButton(
                                onPressed: _startDate.isBefore(_firstEntryDate)
                                    ? null
                                    : () => arrowButtonPressed("backward", currentUser.id),
                                icon: Icon(Icons.arrow_back_ios_rounded),
                                iconSize: 40,
                                color: _startDate.isBefore(_firstEntryDate) ? Colors.grey : Colors.amber,
                              ),
                              Container(
                                  padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                                  decoration: BoxDecoration(
                                      color: Colors.amber, borderRadius: BorderRadius.all(Radius.circular(15))),
                                  child: Text(
                                    getDateRangeText(),
                                    style: boldStyle,
                                  )),
                              IconButton(
                                onPressed: _startDate.isAfter(DateTime.now().subtract(Duration(days: 7)))
                                    ? null
                                    : () => arrowButtonPressed("forward", currentUser.id),
                                icon: Icon(Icons.arrow_forward_ios_rounded),
                                iconSize: 40,
                                color: _startDate.isAfter(DateTime.now()) ? Colors.grey : Colors.amber,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                          child: Row(
                            children: <Widget>[
                              Text(
                                'Calories Today',
                                style: boldStyle,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 8, 0, 10),
                          child: Row(
                            children: <Widget>[
                              Text(
                                _caloriesToday.toStringAsFixed(0),
                                style: normalStyle,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Daily Average: ',
                                style: boldStyle,
                              ),
                              Text(
                                _getDailyCalorieAverageForWeek().toString(),
                                style: normalStyle,
                              ),
                              Text(
                                'Goal: ',
                                style: boldStyle,
                              ),
                              Text(
                                currentUser.dailyIntake.round().toString(),
                                style: normalStyle,
                              ),
                            ],
                          ),
                        ),
                        Container(
                            padding: EdgeInsets.fromLTRB(10, 15, 20, 0),
                            width: double.infinity,
                            child: BarChart(BarChartData(
                                maxY: _getMaxY(),
                                barGroups: _barGroups(),
                                titlesData: _titlesData(),
                                barTouchData: _barTouchData(),
                                borderData: _borderData())))
                      ],
                    ),
                  );
              }
            }),
      ),
    );
  }
}
