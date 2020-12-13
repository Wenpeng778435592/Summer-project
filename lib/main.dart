import 'package:flutter/material.dart';
import 'dart:async';
import 'package:my_diet_diary/Diary.dart';
import 'package:my_diet_diary/Weight.dart';
import 'package:my_diet_diary/QuickAdd.dart';
import 'package:my_diet_diary/Report.dart';
import 'package:my_diet_diary/More.dart';


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

  int _currentIndex = 0;
  List<Widget> _options = <Widget>[
    Dairy_Section(),
    Text('2'),
    Text('3'),
    Text('4'),
    Text('5'),
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Date'),
        centerTitle: true,
        backgroundColor: Colors.amber[800],
      ),

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
        backgroundColor: Colors.grey[200],
        iconSize: 30,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.article),
              label: 'Diary',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.line_weight),
              label:'Weight',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label:'QuickAdd',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.report),
              label:'Report',
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
}


