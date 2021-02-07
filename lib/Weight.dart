import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sticky_headers/sticky_headers.dart';

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

  Future _userFuture;
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
    _userFuture = _getFutures();
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

    _weightList = await dbHelper.getWeightHistoryForUser(id);

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

    print("x: " + _minX.toString() + " " + _maxX.toString());
    print("y: " + _minY.toString() + " " + _maxY.toString());

    setState(() {});
  }

  _lineTouchData() {
    return LineTouchData(
      enabled: true,
      touchTooltipData: LineTouchTooltipData(
          fitInsideHorizontally: true,
          tooltipBgColor: Colors.white,
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((barSpot) {
              return LineTooltipItem(
                '${_formatDate(barSpot.x.toInt())} \n${barSpot.y.toString() + " kg"}',
                TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              );
            }).toList();
          }),
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
        isStrokeCapRound: true,
        barWidth: 3,
        belowBarData: BarAreaData(
            show: true,
            colors: [
              Colors.blue,
              Colors.blue.withOpacity(0.1),
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
//          getTitles: (value) {
//            final DateTime date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
//            return DateFormat.MMMd().format(date);
//          },
//          margin: 15,
//          interval: _maxX - _minX,
//          reservedSize: 10,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          getTitles: (value) => value.toStringAsFixed(1),
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
      body: SingleChildScrollView(
          child: FutureBuilder(
              future: _userFuture,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                    break;
                  default:
                    if (snapshot.hasError) return Text("Error " + snapshot.error.toString());
                    _currentUser = snapshot.data;

                    return Column(children: <Widget>[
                      SafeArea(
                          child: Padding(
                              padding: EdgeInsets.only(left: 16, right: 16, top: 20),
                              child: Column(
                                children: <Widget>[
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
                                  StickyHeader(
                                    header: Container(
                                      padding: EdgeInsets.only(top: 15, bottom: 15),
                                      color: Colors.white,
                                      height: 180,
                                      width: double.infinity,
                                      child: LineChart(
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
                                      ),
                                    ),
                                    content: Container(
                                        child: ListView.separated(
                                      itemCount: _weightList.length,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (BuildContext context, int index) {
                                        return Container(
                                            height: 45,
                                            child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Icon(FontAwesomeIcons.bullseye, color: Colors.grey),
                                                  Text(DateFormat('yyyy-MM-dd').format(_weightList[index].date),
                                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                                                  Text(_weightList[index].weight.toString() + " kg",
                                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                                                ]));
                                      },
                                      separatorBuilder: (BuildContext context, int index) => const Divider(),
                                    )),
                                  ),
                                ],
                              )))
                    ]);
                }
              })),
    );
  }
}
