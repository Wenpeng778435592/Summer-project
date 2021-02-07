import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'DataObjects/DatabaseHelper.dart';

class Report_Section extends StatefulWidget {
  @override
  _Report_SectionState createState() => _Report_SectionState();
}

class _Report_SectionState extends State<Report_Section> {
  static const TextStyle generalStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  DatabaseHelper dbHelper = new DatabaseHelper();

  int _currentUserID;

  int _getDailyAverageForWeek(DateTime startDate) {}

  int _getWeightEntriesForWeek(DateTime startDate) {
    DateTime prevWeekDate = startDate.subtract(Duration(days: 7));
  }

  @override
  void initState() {
    super.initState();
  }

  _getFutures() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    _currentUserID = sp.getInt("currentUserID");
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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
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
                        style: generalStyle,
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
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Calories',
                      style: generalStyle,
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  children: <Widget>[
                    Text(
                      'x',
                      style: generalStyle,
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
                      style: generalStyle,
                    ),
                    Text(
                      'y',
                      style: generalStyle,
                    ),
                    Text(
                      'Goal: ',
                      style: generalStyle,
                    ),
                    Text(
                      'z',
                      style: generalStyle,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
