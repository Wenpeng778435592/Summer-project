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

  DatabaseHelper dbHelper = new DatabaseHelper();


//  WeightEntry entry = new WeightEntry(userID, 50.1, DateTime.now());
//  WeightEntry entry1 = new WeightEntry(userID, 56.5, DateTime(2021, 1, 12));
//  WeightEntry entry2 = new WeightEntry(userID, 54.7, DateTime(2021, 1, 27));
//  WeightEntry entry3 = new WeightEntry(userID, 58.3, DateTime(2021, 1, 18));
//
//  FoodEntry foodEntry1 = new FoodEntry(userID, 50, 30, 20, 100, "apple", "breakfast", DateTime.now().toString(), 10);
//  FoodEntry foodEntry2 = new FoodEntry(
//      userID, 15, 40, 35, 90, "banana", "snack", DateTime.now().subtract(Duration(days: 7)).toString(), 10);
//  FoodEntry foodEntry3 = new FoodEntry(
//      userID, 50, 300, 150, 400, "pancakes", "lunch", DateTime.now().subtract(Duration(days: 8)).toString(), 10);
//  FoodEntry foodEntry4 = new FoodEntry(
//      userID, 400, 70, 200, 670, "cheeseburger", "dinner", DateTime.now().subtract(Duration(days: 3)).toString(), 10);
//  FoodEntry foodEntry5 = new FoodEntry(
//      userID, 25, 25, 50, 100, "apple", "snack", DateTime.now().subtract(Duration(days: 2)).toString(), 10);
//
//  await dbHelper.addFoodEntry(foodEntry1);
//  await dbHelper.addFoodEntry(foodEntry2);
//  await dbHelper.addFoodEntry(foodEntry3);
//  await dbHelper.addFoodEntry(foodEntry4);
//  await dbHelper.addFoodEntry(foodEntry5);
//
//  await dbHelper.addWeightEntry(entry);
//  await dbHelper.addWeightEntry(entry1);
//  await dbHelper.addWeightEntry(entry2);
//  await dbHelper.addWeightEntry(entry3);

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
