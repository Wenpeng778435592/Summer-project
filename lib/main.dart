import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_diet_diary/Diary.dart';
import 'package:my_diet_diary/Energy.dart';
import 'package:my_diet_diary/More.dart';
import 'package:my_diet_diary/QuickAdd.dart';
import 'package:my_diet_diary/Weight.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'DataObjects/DatabaseHelper.dart';
import 'User_input/GeneralInfo.dart';

final databaseReference = FirebaseDatabase().reference().reference();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  int userID = prefs.getInt("currentUserID");

  print(userID.toString());

  runApp(MaterialApp(
      // If current user doesn't exist, show profile screen to create new user
      home: userID == null ? GeneralInfo_Section() : Home()));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
            label: 'Weight',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'QuickAdd',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood),
            label: 'Energy',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help),
            label: 'More',
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
  }
}
