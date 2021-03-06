import 'package:flutter/material.dart';
import 'dart:async';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_diet_diary/DataObjects/DatabaseHelper.dart';
import 'package:my_diet_diary/DataObjects/Meal.dart';
import 'package:my_diet_diary/Search/Add_Item.dart';
import 'package:my_diet_diary/qr_view/BarcodeScanPage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:my_diet_diary/Search/SearchPage.dart';
import 'package:my_diet_diary/Search/MyFoodSearchPage.dart';
import 'package:my_diet_diary/Search/Add_Food.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'DataObjects/FoodEntry.dart';
import 'package:intl/intl.dart';

class Breakfast_Section extends StatefulWidget {
  //to send a message in -- don't need to change four dart files
  final String title;

  const Breakfast_Section({Key key, this.title}) : super(key: key);
  @override
  _Breakfast_SectionState createState() => _Breakfast_SectionState();
}

class _Breakfast_SectionState extends State<Breakfast_Section> {
  static const TextStyle generalStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const TextStyle tableStyle =
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  var foodtype = "";
  var listIndex = 0;

  // final foods = [
  //   "Frenchfries",
  //   'Orange',
  //   'Chocolate',
  // ];
  //
  // final nums = [
  //   300,
  //   100,
  //   20,
  // ];

  List<FoodEntry> foodSource = List();

  // controller show menu
  bool showMenu = false;

  //constructs an index for record expansion item
  List<int> _openedList = List<int>();

  @override
  void initState() {
    super.initState();

    //getFoodHistoryForDay
    DatabaseHelper().getFoodHistoryForDay(null, null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back_ios_outlined),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            Text(
              widget.title ?? 'Breakfast',
              style: generalStyle,
            ),

            IconButton(
              icon: FaIcon(FontAwesomeIcons.barcode),
              onPressed: () async {
                PermissionStatus _hasPermission =
                await Permission.camera.request();
                if (!_hasPermission.isGranted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BarcodeScanPage()),
                );
              },
            ),
          ],
        ),
        backgroundColor: Colors.amber[800],
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(
                child: RaisedButton(
                  onPressed: () {
                    setState(() {
                      showMenu = true;
                    });
                  },
                  child: Text(
                    'Food Recent',
                    style: generalStyle,
                  ),
                  color: Colors.amber,
                ),
              ),
              Expanded(
                child: RaisedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyFoodSearchPage('breakfast')),
                    );
                  },
                  child: Text(
                    'My Food List',
                    style: generalStyle,
                  ),
                  color: Colors.amber,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(
                child: RaisedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchBar('breakfast')),
                    );
                  },
                  child: Row(
                    children: [
                      Text(
                        'Find a Food',
                        style: generalStyle,
                      ),
                      Icon(Icons.search)
                    ],
                  ),
                  color: Colors.amber,
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: RaisedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Add_Food()),
                    );
                  },
                  child: Text(
                    'New Food',
                    style: generalStyle,
                  ),
                  color: Colors.amber,
                ),
              ),
            ],
          ),
          this.showMenu == true
              ? Container(
                  color: Colors.amber,
                  height: 40,
                  child: Row(
                    children: [
                      Expanded(
                        child: _item('Breakfast', onTap: () {
                          // setState(() {
                          //   this.listIndex = 8;
                          //   this.foodtype = 'Breakfast';
                          // });
                          _getSourceFromDB(Meal.breakfast);
                        }),
                      ),
                      Expanded(
                        child: _item('Lunch', onTap: () {
                          // setState(() {
                          //   this.listIndex = 8;
                          //   this.foodtype = 'Lunch';
                          // });
                          _getSourceFromDB(Meal.lunch);
                        }),
                      ),
                      Expanded(
                        child: _item('Dinner', onTap: () {
                          // setState(() {
                          //   this.listIndex = 8;
                          //   this.foodtype = 'Dinner';
                          // });
                          _getSourceFromDB(Meal.dinner);
                        }),
                      ),
                      Expanded(
                        child: _item('Snacks', onTap: () {
                          // setState(() {
                          //   this.listIndex = 8;
                          //   this.foodtype = 'Snacks';
                          // });
                          _getSourceFromDB(Meal.snack);
                        }),
                      ),
                    ],
                  ),
                )
              : Container(),
          Expanded(
            child: ListView.builder(
              itemCount: foodSource.length,
              itemBuilder: (BuildContext context, int index) {
                // String name = this.foods[index % 3];
                // int num = this.nums[index % 3];
                FoodEntry foodEntry = foodSource[index];
                //print('foodEntry name is ${foodEntry.name}');
                return _listItem(
                  type: foodEntry.meal,
                  date: () {
                    DateTime date = DateTime.tryParse(foodEntry.date);
                    //
                    if (date != null) {
                      //comment
                      int week = date.weekday;
                      List<String> weeks = ['Mon','Tues','Wed','Thur','Fri','Sat','Sun'];
                      String currentWeek = weeks[week -1];
                      DateFormat df = DateFormat("yyyy-MM-dd");
                      String dateStr = df.format(date);
                      return dateStr + ' ' + currentWeek;
                    } else {
                      return '';
                    }
                  }(),
                  foodName: '${foodEntry.name}${foodEntry.amount}g',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddItem_Section(
                          foodEntry.meal,
                          foodEntry.name,
                          '${foodEntry.carbs}',
                          '${foodEntry.calories}',
                          '${foodEntry.fat}',
                          '${foodEntry.id}',
                          '${foodEntry.protein}',
                          '100', //serv is 100g
                        ),
                      ),
                    );
                  },
                  isOpen: _openedList.contains(index),
                  checkShowMore: () {
                   setState(() {
                      _openedList.add(index);
                   });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _item(String title, {Function onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _listItem(
      {@required String type,
      @required String date,
      @required String foodName,
      @required bool isOpen,
      Function checkShowMore,
      Function onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  type,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 5, bottom: 5),
              child: Row(
                children: () {
                  List<Widget> widgets = List<Widget>();
                  widgets.add(
                    Expanded(
                      child: Text(
                        foodName,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black45,
                      ),
                        maxLines: isOpen == true ? null :1,
                        overflow: isOpen == true ? null : TextOverflow.ellipsis,
                      ),
                    ),
                  );
                  if (isOpen == false) {
                    widgets.add(
                      Container(
                        child: InkWell(
                          onTap: checkShowMore,
                          child: Text(
                            'show more >',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return widgets;
                }(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //get from database //Classified data acquisition
  _getSourceFromDB(Meal meal) async {
    List<FoodEntry> allSource = List();
    var now = DateTime.now();
    for (var i = 0; i < 8; i++) {
      //Build a date condition that loops through the data for each day
      Duration dayD = Duration(days: i);
      var date = now.subtract(dayD);
      List<FoodEntry> temp = await DatabaseHelper().getMealForDay(date, meal);
      allSource.addAll(temp); //Summarize the acquired data
    }

    //clear mark open index
    _openedList.clear();

    setState(() {
      foodSource = allSource;
    });
  }

  //to return String time according to line number
  String _dateStr(int i) {
    var now = DateTime.now();

    // List<String> weeks = ["Mon" "Tues" "Wed" "Thur" "Fri" "Sat" "Sun"];
    if (i == 0) {
      return 'Today';
    } else if (i == 1) {
      return 'Yesterday';
    } else {
      Duration dayD = Duration(days: i + 1);
      var date = now.subtract(dayD);
      var week = date.weekday;
      var day = date.day;
      var month = date.month;
      return '${_weekStr(week)} $day ${_monthStr(month)}';
    }
  }

  //to get months
  String _monthStr(int i) {
    String key = '';
    switch (i) {
      case 1:
        key = 'Jan.';
        break;
      case 2:
        key = 'Feb.';
        break;
      case 3:
        key = 'Mar.';
        break;
      case 4:
        key = 'Apr.';
        break;
      case 5:
        key = 'May.';
        break;
      case 6:
        key = 'Jun.';
        break;
      case 7:
        key = 'Jul.';
        break;
      case 8:
        key = 'Agu.';
        break;
      case 9:
        key = 'Sep.';
        break;
      case 10:
        key = 'Oct.';
        break;
      case 11:
        key = 'Nov.';
        break;
      case 12:
        key = 'Dec.';
        break;
      default:
    }
    return key;
  }

  //to get weeks
  String _weekStr(int i) {
    String key = 'Sun';
    switch (i) {
      case 1:
        key = 'Mon';
        break;
      case 2:
        key = 'Tues';
        break;
      case 3:
        key = 'Wed';
        break;
      case 4:
        key = 'Thur';
        break;
      case 5:
        key = 'Fri';
        break;
      case 6:
        key = 'Sat';
        break;
      case 7:
        key = 'Sun';
        break;
      default:
    }
    return key;
  }
}
