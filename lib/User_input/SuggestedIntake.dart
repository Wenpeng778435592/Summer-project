import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:my_diet_diary/DataObjects/User.dart';
import 'package:my_diet_diary/DataObjects/DatabaseHelper.dart';
import 'package:my_diet_diary/Diary.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_diet_diary/main.dart';

class SuggestedDailyIntake_Section extends StatefulWidget {
  User _currentUser;
  num BMR;
  SuggestedDailyIntake_Section(this._currentUser, this.BMR);
  @override
  _SuggestedDailyIntake_SectionState createState() => _SuggestedDailyIntake_SectionState();
}

class _SuggestedDailyIntake_SectionState extends State<SuggestedDailyIntake_Section> {
  static const TextStyle generalStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const TextStyle labelStyle =
  TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  @override

  num dailyIntake = 0;
  DatabaseHelper dbHelper = new DatabaseHelper();


  @override

  num _intake(BMR, _pattern){
    if(_pattern == 'Maintain Weight'){
      if(widget._currentUser.activityLevel == 'Sedentary(desk job)'){
        dailyIntake = BMR;
      }
      else if(widget._currentUser.activityLevel == 'Light exercise(1-3 times per week)'){
        dailyIntake = BMR * 1.2;
      }
      else if(widget._currentUser.activityLevel == 'Moderate exercise(4-5 times per week)'){
        dailyIntake = BMR * 1.5;
      }
      else if(widget._currentUser.activityLevel == 'Active exercise(daily or intense sport 3-4 times per week)'){
        dailyIntake = BMR * 1.55;
      }
    }
    return dailyIntake;
  }



  Widget build(BuildContext context) {
    if(widget._currentUser.goal == 'Maintain Weight'){
      widget._currentUser.targetDays = 0;
      widget._currentUser.dailyIntake = _intake(widget.BMR, widget._currentUser.goal);
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Stack(
          children: <Widget>[
            Positioned(
              left: 0,
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios_outlined),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
            ),
            Align(
              child: Text('Suggested Intake',
                style: generalStyle,),
            ),
          ],
        ),
        backgroundColor: Colors.amber[800],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: Center(
              child: Text(
                'Suggested daily intake',
                style: generalStyle,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Center(
              child: Text(
                widget._currentUser.dailyIntake.round().toString() + ' cal',
                style: generalStyle,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Center(
              child: Text(
                'Required time to reach your goal',
                style: generalStyle,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Center(
              child: Text(
                widget._currentUser.targetDays.round().toString() + ' days',
                style: generalStyle,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Center(
              child: RaisedButton(
                child: Text(
                  'Finish',
                  style: generalStyle,
                ),
                onPressed: () async{
                  print('Nice you made it!');
                  int id = await dbHelper.addUser(widget._currentUser);

                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setInt("currentUserID", id);

                  Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
                },
              ),
            ),
          ),

        ],
      ),
    );
  }
}
