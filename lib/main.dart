import 'package:flutter/material.dart';
import 'package:my_diet_diary/DataObjects/DatabaseHelper.dart';
import 'package:my_diet_diary/DataObjects/Meal.dart';
import 'dart:async';
import 'package:my_diet_diary/Diary.dart';
import 'package:my_diet_diary/Weight.dart';
import 'package:my_diet_diary/QuickAdd.dart';
import 'package:my_diet_diary/Report.dart';
import 'package:my_diet_diary/More.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sqflite/sqflite.dart';

import 'DataObjects/User.dart';
// Text(
// 'More',
// style: TextStyle(
// fontSize: 30,
// fontWeight: FontWeight.bold
// ),
// ),

void main() {
  runApp(MaterialApp(
    home: Home()
  ));//MyApp is a widget/class
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var dbHelper = DatabaseHelper();

  int _currentIndex = 0;
  List<Widget> _options = <Widget>[
    Dairy_Section(),
    Weight_section(),
    QuickAdd_Section(),
    Report_Section(),
    More_Section(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: _options.elementAt(_currentIndex),


      // body: Container(
      //   child: Image(
      //     // image:AssetImage('assets/sample_1.jpg'),
      //     image:NetworkImage('https://images.unsplash.com/photo-1531113463068-6f334622d795?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80'),
      //   ),
      // ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.grey[300],
        iconSize: 35,
        items: [
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.book),
              label: 'Diary',
          ),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.weight),
              label:'Weight',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label:'QuickAdd',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.fastfood),
              label:'Energy',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.help),
              label:'More',
          ),

        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

        },

      ),
    );
  }

  void _insert() async {
    // row to insert
    dbHelper.getAllFoodHistory();
  }
}


