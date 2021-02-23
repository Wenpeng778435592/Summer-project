import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'DataObjects/DatabaseHelper.dart';
import 'DataObjects/User.dart';
import 'DataObjects/WeightEntry.dart';

class Weight_section extends StatefulWidget {
  @override
  _Weight_sectionState createState() => _Weight_sectionState();
}

class _Weight_sectionState extends State<Weight_section> {
  static const TextStyle generalStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  static const TextStyle subTextStyle = TextStyle(fontSize: 20);

  ButtonStyle outlineButtonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.resolveWith<Color>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.pressed)) return Colors.blue;
        return null; // Use the component's default.
      },
    ),
  );

  DatabaseHelper dbHelper = new DatabaseHelper();

  Future _futures;
  User _currentUser;

  double _currentWeight;

  double _minX;
  double _maxX;
  double _minY;
  double _maxY;

  List<FlSpot> _chartData = const [];
  List<WeightEntry> _weightList = const [];

  @override
  void initState() {
    super.initState();
    _futures = _getFutures();
  }

  _formatDate(int dateInt) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(dateInt);
    return DateFormat('yyyy-MM-dd').format(date);
  }

  _getFutures() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    int currentUserID = sp.getInt("currentUserID");

    await _processData(currentUserID);

    return await dbHelper.getUserByID(currentUserID);
  }

  _processData(int id) async {
    double minY = double.maxFinite;
    double maxY = double.minPositive;

    _currentUser = await dbHelper.getUserByID(id);

    _weightList = await dbHelper.getWeightHistoryForUser(id);

    if (_weightList.isEmpty) {
      _currentWeight = _currentUser.weight.toDouble();
      _chartData = [];
      _minX = 0;
      _maxX = DateTime.now().millisecondsSinceEpoch.toDouble();
      _minY = 0;
      _maxY = 100;
    } else {
      _currentWeight = _weightList.last.weight;

      _chartData = _weightList.map((weightEntry) {
        if (minY > weightEntry.weight) minY = weightEntry.weight;
        if (maxY < weightEntry.weight) maxY = weightEntry.weight;
        return FlSpot(weightEntry.date.millisecondsSinceEpoch.toDouble(), weightEntry.weight.toDouble());
      }).toList();

      _minX = _weightList.first.date.millisecondsSinceEpoch.toDouble();
      _maxX = _weightList.last.date.millisecondsSinceEpoch.toDouble();
      _minY = minY;
      _maxY = maxY;
    }

    setState(() {});
  }

  _lineTouchData() {
    return LineTouchData(
      enabled: true,
      touchSpotThreshold: 15,
      touchTooltipData: LineTouchTooltipData(
          fitInsideHorizontally: true,
          tooltipBgColor: Colors.grey[800],
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((barSpot) {
              return LineTooltipItem(
                '${_formatDate(barSpot.x.toInt())} \n${barSpot.y.toString() + " kg"}',
                TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              );
            }).toList();
          }),
      getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
        return spotIndexes.map((spotIndex) {
          return TouchedSpotIndicatorData(
            FlLine(color: Colors.blue, strokeWidth: 4),
            FlDotData(
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(radius: 8, color: Colors.white, strokeWidth: 5, strokeColor: Colors.blue);
              },
            ),
          );
        }).toList();
      },
    );
  }

  _gridData() {
    return FlGridData(
      show: true,
      getDrawingHorizontalLine: (value) {
        return FlLine(color: Colors.grey[300], dashArray: [6, 6]);
      },
      horizontalInterval: (_maxY - _minY) / 2,
    );
  }

  _lineBarData() {
    return LineChartBarData(
        spots: _chartData,
        colors: [Colors.blue],
        isCurved: true,
        curveSmoothness: 0.2,
        dotData: FlDotData(show: false),
        isStrokeCapRound: true,
        barWidth: 3.5,
        belowBarData: BarAreaData(
            show: true,
            colors: [
              Colors.blue.withOpacity(0.4),
              Colors.blue.withOpacity(0.05),
            ],
            gradientFrom: const Offset(0, 0),
            gradientTo: const Offset(0, 1),
            gradientColorStops: [0, 0.5, 1.0]));
  }

  _borderData() {
    return FlBorderData(
      show: true,
      border: Border.symmetric(
        horizontal: BorderSide(color: Colors.grey[300], width: 2),
      ),
    );
  }

  _titlesData() {
    return FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: false,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTitles: (value) => value.toStringAsFixed(1),
          getTextStyles: (value) => const TextStyle(color: Colors.black, fontSize: 12),
          margin: 10,
          interval: ((_maxY - _minY) / 2),
        ));
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
      body: Container(
          padding: EdgeInsets.fromLTRB(10, 15, 20, 0),
          child: FutureBuilder(
              future: _futures,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                    break;
                  default:
                    _currentUser = snapshot.data;

                    return Column(children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Column(children: <Widget>[
                          Center(
                            child: Text('Current Weight', style: generalStyle),
                          ),
                          SizedBox(height: 5),
                          Center(
                            child: Text(_currentWeight.toString() + ' kg', style: subTextStyle),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text('Start', style: generalStyle),
                                  SizedBox(height: 5),
                                  Text(_currentUser.weight.toString() + ' kg', style: subTextStyle),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Text('Goal', style: generalStyle),
                                  SizedBox(height: 5),
                                  Text(_currentUser.targetWeight.toString() + ' kg', style: subTextStyle),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Container(
                              padding: EdgeInsets.fromLTRB(10, 15, 20, 0),
                              width: double.infinity,
                              height: 190,
                              child: _chartData.isEmpty
                                  ? Center(
                                      child: Text("You don't currently have any saved weight data",
                                          style: TextStyle(
                                              color: Colors.grey[700], fontSize: 16, fontStyle: FontStyle.italic)))
                                  : LineChart(
                                      LineChartData(
                                          minX: _minX,
                                          maxX: _maxX,
                                          minY: _minY,
                                          maxY: _maxY,
                                          titlesData: _titlesData(),
                                          lineTouchData: _lineTouchData(),
                                          gridData: _gridData(),
                                          lineBarsData: [_lineBarData()],
                                          borderData: _borderData()),
                                    )),
                          SizedBox(height: 15),
                          Expanded(
                            flex: 1,
                            child: SingleChildScrollView(
                                child: Column(children: [
                              ListView.separated(
                                itemCount: _weightList.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    child: Padding(
                                        padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                                        child:
                                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                                          Icon(FontAwesomeIcons.bullseye, color: Colors.amber[300]),
                                          Text(DateFormat('yyyy-MM-dd').format(_weightList[index].date),
                                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                                          Text(_weightList[index].weight.toString() + " kg",
                                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                                        ])),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return Divider();
                                },
                              )
                            ])),
                          ),
                        ]),
                      ),
                    ]);
                }
              })),
    );
  }
}
