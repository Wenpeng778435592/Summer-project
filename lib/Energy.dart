import 'dart:collection';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'DataObjects/DatabaseHelper.dart';
import 'DataObjects/FoodDayData.dart';
import 'DataObjects/FoodEntry.dart';

class Report_Section extends StatefulWidget {
  @override
  _Report_SectionState createState() => _Report_SectionState();
}

class _Report_SectionState extends State<Report_Section> {
  static const TextStyle boldStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  static const TextStyle normalStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.w500);

  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex;

  DatabaseHelper dbHelper = new DatabaseHelper();

  List<FoodEntry> _currentWeekFoodEntries = new List<FoodEntry>();
  List<FoodEntry> _foodEntriesToday = new List<FoodEntry>();

  Map _currentWeekSummaryData = LinkedHashMap<String, FoodDayData>();

  int _currentUserID;
  int _currentUserCalorieGoal;

  @override
  void initState() {
    super.initState();
    _getFutures();
  }

  _getFutures() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    _currentUserID = sp.getInt("currentUserID");
    _currentUserCalorieGoal = (await dbHelper.getUserByID(_currentUserID)).calorieGoal;

    _currentWeekFoodEntries = await _getFoodEntriesForWeek(DateTime.now());
    _foodEntriesToday = await _getFoodEntriesForDay(DateTime.now(), _currentUserID);

    _currentWeekSummaryData = _getCalorieSummaryData();

    print(_getDailyCalorieAverageForWeek());

    setState(() {});
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

    _foodEntriesToday.forEach((foodEntry) {
      totalCalories = totalCalories + foodEntry.calories;
    });

    return totalCalories;
  }

  Future<List<FoodEntry>> _getFoodEntriesForWeek(DateTime startDate) async {
    DateTime prevWeekDate = startDate.subtract(Duration(days: 6));
    return await dbHelper.getFoodEntriesBetweenDates(_currentUserID, prevWeekDate, startDate);
  }

  Future<List<FoodEntry>> _getFoodEntriesForDay(DateTime startDate, int userID) async {
    return await dbHelper.getFoodHistoryForDay(startDate, _currentUserID);
  }

  _getCalorieSummaryData() {
    DateTime currentDate = DateTime.now();
    Map currentWeekSummaryData = LinkedHashMap<String, FoodDayData>();

    currentWeekSummaryData = {
      new DateFormat('yyyy-MM-dd').format(currentDate.subtract(Duration(days: 6))): FoodDayData(0, 0, 0, 0),
      new DateFormat('yyyy-MM-dd').format(currentDate.subtract(Duration(days: 5))): FoodDayData(0, 0, 0, 0),
      new DateFormat('yyyy-MM-dd').format(currentDate.subtract(Duration(days: 4))): FoodDayData(0, 0, 0, 0),
      new DateFormat('yyyy-MM-dd').format(currentDate.subtract(Duration(days: 3))): FoodDayData(0, 0, 0, 0),
      new DateFormat('yyyy-MM-dd').format(currentDate.subtract(Duration(days: 2))): FoodDayData(0, 0, 0, 0),
      new DateFormat('yyyy-MM-dd').format(currentDate.subtract(Duration(days: 1))): FoodDayData(0, 0, 0, 0),
      new DateFormat('yyyy-MM-dd').format(currentDate): FoodDayData(0, 0, 0, 0)
    };

    _currentWeekFoodEntries.forEach((foodEntry) {
      var foodEntryDateFormatted = foodEntry.date.split(" ")[0];

      FoodDayData currentDataForDate = currentWeekSummaryData[foodEntryDateFormatted];
      currentDataForDate.calories += foodEntry.calories;
      currentDataForDate.fat += foodEntry.fat;
      currentDataForDate.protein += foodEntry.protein;
      currentDataForDate.carbs += foodEntry.carbs;

      print(foodEntryDateFormatted + " " + currentDataForDate.toString());
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
                "Calories: ${dayData.calories.toString()}\nCarbs: ${dayData.carbs.toString()}\n" +
                    "Fat: ${dayData.fat.toString()}\nProtein: ${dayData.protein.toString()}",
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
        child: Container(
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
                      onPressed: () {},
                      icon: Icon(Icons.arrow_back),
                      iconSize: 55,
                      color: Colors.amber,
                    ),
                    RaisedButton(
                      onPressed: () {},
                      child: Text(
                        'This Week',
                        style: boldStyle,
                      ),
                      color: Colors.amber,
                      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30)),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.arrow_forward),
                      iconSize: 55,
                      color: Colors.amber,
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
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
                      _getCaloriesForDay().toString(),
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
                      _currentUserCalorieGoal.toString(),
                      style: normalStyle,
                    ),
                  ],
                ),
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                  width: double.infinity,
                  child: BarChart(BarChartData(
                      maxY: _getMaxY(),
                      barGroups: _barGroups(),
                      titlesData: _titlesData(),
                      barTouchData: _barTouchData(),
                      borderData: _borderData())))
            ],
          ),
        ),
      ),
    );
  }
}
