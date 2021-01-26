import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ChartObjects/WeightDataPoint.dart';
import 'DataObjects/DatabaseHelper.dart';
import 'DataObjects/User.dart';

class Weight_section extends StatefulWidget {
  @override
  _Weight_sectionState createState() => _Weight_sectionState();
}

class _Weight_sectionState extends State<Weight_section> {
  static const TextStyle generalStyle =
      TextStyle(fontSize: 24, fontWeight: FontWeight.bold);

  static const TextStyle subTextStyle = TextStyle(fontSize: 24);

  DatabaseHelper dbHelper = new DatabaseHelper();

  Future userFuture;
  User currentUser;

  List<charts.Series<WeightDataPoint, int>> weightGraphSeries;

  @override
  void initState() {
    super.initState();
    userFuture = _getUserFuture();
    _generateData();
  }

  _getUserFuture() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    int currentUserID = sp.getInt("currentUserID");
    return await dbHelper.getUserByID(currentUserID);
  }

  _generateData() async {
//    List<WeightEntry> weightList =
//        await dbHelper.getWeightHistoryForUser(currentUser.id);
    var dummyData = [
      new WeightDataPoint(1, 55.5),
      new WeightDataPoint(2, 50),
      new WeightDataPoint(3, 45),
      new WeightDataPoint(4, 60),
    ];

    this.weightGraphSeries = [
      charts.Series(
        id: 'Weight',
        data: dummyData,
        domainFn: (WeightDataPoint weightDataPoint, _) =>
            weightDataPoint.dateVal,
        measureFn: (WeightDataPoint weightDataPoint, _) =>
            weightDataPoint.weightVal,
        colorFn: (WeightDataPoint weightDataPoint, _) =>
            charts.ColorUtil.fromDartColor(Colors.blue),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Weight Chart',
          style: generalStyle,
        ),
        centerTitle: true,
        backgroundColor: Colors.amber[800],
      ),
      body: SingleChildScrollView(
          child: FutureBuilder(
              future: userFuture,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                    break;
                  default:
                    if (snapshot.hasError)
                      return Text("Error " + snapshot.error.toString());

                    currentUser = snapshot.data;

                    return Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          Center(
                            child: Text('Current Weight', style: generalStyle),
                          ),
                          SizedBox(height: 15),
                          Center(
                            child: Text(currentUser.weight.toString() + ' kg',
                                style: subTextStyle),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text('Start', style: generalStyle),
                                  SizedBox(height: 15),
                                  Text(currentUser.weight.toString() + ' kg',
                                      style: subTextStyle),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Text('Goal', style: generalStyle),
                                  SizedBox(height: 15),
                                  Text(
                                      currentUser.targetWeight.toString() +
                                          ' kg',
                                      style: subTextStyle),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Container(
                            height: 400,
                            child: Column(
                              children: <Widget>[
                                Text(
                                  "Your Weight History",
                                  style: subTextStyle,
                                ),
                                Expanded(
                                  child: charts.LineChart(weightGraphSeries,
                                      animate: true),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                }
              })),
    );
  }
}
