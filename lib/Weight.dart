import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_diet_diary/DataObjects/DatabaseHelper.dart';
import 'package:my_diet_diary/DataObjects/User.dart';
import 'package:my_diet_diary/DataObjects/WeightEntry.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Weight_section extends StatefulWidget {
  @override
  _Weight_sectionState createState() => _Weight_sectionState();
}

class _Weight_sectionState extends State<Weight_section> {
  final GlobalKey expansionTileKey = GlobalKey();
  final GlobalKey<FormState> keyDialogForm = new GlobalKey<FormState>();

  TextEditingController _textFieldController = TextEditingController();

  static TextStyle generalStyle = TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white);
  static TextStyle titleStyle = TextStyle(fontSize: 20, color: Colors.grey[700], fontWeight: FontWeight.bold);
  static TextStyle subTextStyle = TextStyle(fontSize: 18, color: Colors.grey[700]);

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

  Future _displayTextInputDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Form(
              key: keyDialogForm,
              child: Column(
                children: <Widget>[
                  Align(alignment: Alignment.centerLeft, child: Text("Log Todays Weight")),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Weight in kgs",
                    ),
                    onSaved: (value) {
                      WeightEntry weightEntry =
                          new WeightEntry(_currentUser.id, double.tryParse(value), DateTime.now());
                      dbHelper.addWeightEntry(weightEntry);

                      _processData(_currentUser.id);
                      setState(() {});
                    },
                    validator: (value) {
                      if (double.tryParse(value) == null) {
                        return "Please enter a number e.g 65.2";
                      }
                      return null;
                    },
                  )
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('CANCEL')),
              FlatButton(
                onPressed: () {
                  if (keyDialogForm.currentState.validate()) {
                    keyDialogForm.currentState.save();

                    Navigator.pop(context);
                  }
                },
                child: Text('SAVE'),
              ),
            ],
          );
        });
  }

  void _scrollToSelectedContent({GlobalKey expansionTileKey}) {
    final keyContext = expansionTileKey.currentContext;
    if (keyContext != null) {
      Future.delayed(Duration(milliseconds: 200)).then((value) {
        Scrollable.ensureVisible(keyContext, duration: Duration(milliseconds: 200));
      });
    }
  }

  _getWeightProgressPercentage(int startWeight, int targetWeight, double currentWeight) {
    double difference = startWeight - currentWeight;

    if (currentWeight <= targetWeight) {
      return 1.0;
    } else if (difference < 0) {
      return 0.0;
    } else {
      return difference / (startWeight.toDouble() - targetWeight.toDouble());
    }
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
        curveSmoothness: 0.1,
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(width: 26, height: 26),
            Text(
              'My Weight',
              style: generalStyle,
            ),
            SizedBox(
              height: 26.0,
              width: 26.0,
              child: IconButton(
                padding: new EdgeInsets.all(0.0),
                iconSize: 26,
                icon: Icon(Icons.add),
                onPressed: () {
                  _displayTextInputDialog();
                },
              ),
            )
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.amber[800],
      ),
      body: Container(
          child: FutureBuilder(
              future: _futures,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                    break;
                  default:
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Card(
                            elevation: 0.25,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(10, 15, 20, 30),
                              child: Column(children: <Widget>[
                                Column(children: <Widget>[
                                  SizedBox(height: 15),
                                  Center(
                                    child: Text('Current Weight', style: subTextStyle),
                                  ),
                                  SizedBox(height: 5),
                                  Center(
                                    child: RichText(
                                        text: new TextSpan(
                                            style: TextStyle(
                                                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                                            children: <TextSpan>[
                                          new TextSpan(
                                              text: _currentWeight.toString(),
                                              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
                                          new TextSpan(
                                              text: " kg",
                                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
                                        ])),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          Text('Start', style: subTextStyle),
                                          Text(_currentUser.weight.toString() + ' kg', style: titleStyle),
                                        ],
                                      ),
                                      Container(
                                        margin: EdgeInsets.symmetric(vertical: 20),
                                        width: 180,
                                        height: 8,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                          child: LinearProgressIndicator(
                                            value: _getWeightProgressPercentage(
                                                _currentUser.weight, _currentUser.targetWeight, _currentWeight),
                                            valueColor: new AlwaysStoppedAnimation<Color>(Colors.green[300]),
                                            backgroundColor: Colors.grey[300],
                                          ),
                                        ),
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Text('Goal', style: subTextStyle),
                                          Text(_currentUser.targetWeight.toString() + ' kg', style: titleStyle),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 25),
                                  Container(
                                      padding: EdgeInsets.fromLTRB(10, 15, 20, 0),
                                      width: double.infinity,
                                      height: 220,
                                      child: _chartData.isEmpty
                                          ? Center(
                                              child: Text("You don't currently have any saved weight data",
                                                  style: TextStyle(
                                                      color: Colors.grey[700],
                                                      fontSize: 16,
                                                      fontStyle: FontStyle.italic)))
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
                                ]),
                              ]),
                            ),
                          ),
                          SizedBox(height: 15),
                          Card(
                            elevation: 0.25,
                            child: ExpansionTile(
                                key: expansionTileKey,
                                onExpansionChanged: (value) {
                                  if (value) {
                                    _scrollToSelectedContent(expansionTileKey: expansionTileKey);
                                  }
                                },
                                tilePadding: EdgeInsets.fromLTRB(15, 6, 15, 6),
                                leading: Icon(Icons.history, size: 26),
                                title: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('History',
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.grey[800], fontWeight: FontWeight.w500))),
                                children: [
                                  ListView.separated(
                                    itemCount: _weightList.length,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (BuildContext context, int index) {
                                      return Container(
                                        child: Padding(
                                            padding: EdgeInsets.fromLTRB(15, 10, 15, 18),
                                            child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Text(DateFormat('EEE, d MMMM').format(_weightList[index].date),
                                                      style: TextStyle(fontSize: 18, color: Colors.grey[800])),
                                                  RichText(
                                                      text: new TextSpan(
                                                          style: TextStyle(
                                                              fontSize: 24,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.grey[800]),
                                                          children: <TextSpan>[
                                                        new TextSpan(
                                                            text: _weightList[index].weight.toString(),
                                                            style:
                                                                TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                                                        new TextSpan(
                                                            text: " kg",
                                                            style:
                                                                TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
                                                      ])),
                                                ])),
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return Divider();
                                    },
                                  )
                                ]),
                          ),
                          SizedBox(height: 20)
                        ],
                      ),
                    );
                }
              })),
    );
  }
}
