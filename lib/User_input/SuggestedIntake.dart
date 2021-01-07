import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:my_diet_diary/DataObjects/User.dart';

class SuggestedDailyIntake_Section extends StatefulWidget {
  int BMR;
  User _currentUser;
  SuggestedDailyIntake_Section(this._currentUser, this.BMR);
  @override
  _SuggestedDailyIntake_SectionState createState() => _SuggestedDailyIntake_SectionState();
}

class _SuggestedDailyIntake_SectionState extends State<SuggestedDailyIntake_Section> {
  static const TextStyle generalStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const TextStyle labelStyle =
  TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  num dailyIntake = 0;
  num requiredTime = 0;
  num maintainIntake = 0;
  @override

  num _intake(BMR, _pattern){
    if(_pattern == 'Maintain Weight'){
      if(widget._currentUser.activityLevel == 'Sedentary(desk job)'){
        dailyIntake = BMR;
      }
      if(widget._currentUser.activityLevel == 'Light exercise(1-3 times per week)'){
        dailyIntake = BMR * 1.2;
      }
      if(widget._currentUser.activityLevel == 'Moderate exercise(4-5 times per week)'){
        dailyIntake = BMR * 1.5;
      }
      if(widget._currentUser.activityLevel == 'Active exercise(daily or intense sport 3-4 times per week)'){
        dailyIntake = BMR * 1.55;
      }
    }
    else if(_pattern == 'Gain Muscle (bulk)'){
      if(widget._currentUser.activityLevel == 'Sedentary(desk job)'){
        dailyIntake = BMR * 1.07;
      }
      if(widget._currentUser.activityLevel == 'Light exercise(1-3 times per week)'){
        dailyIntake = BMR * 1.2 * 1.07;
      }
      if(widget._currentUser.activityLevel == 'Moderate exercise(4-5 times per week)'){
        dailyIntake = BMR * 1.5 * 1.07;
      }
      if(widget._currentUser.activityLevel == 'Active exercise(daily or intense sport 3-4 times per week)'){
        dailyIntake = BMR * 1.55 * 1.07;
      }
    }
    else if(_pattern == 'Lose Weight'){

    }
    return dailyIntake;
  }

  num _goalTime(currentWeight, targetWeight, _pattern){
    maintainIntake = _intake(widget.BMR, 'Maintain Weight');
    if(_pattern == 'Maintain Weight'){

    }
    else if(_pattern == 'Gain Muscle (bulk)'){
      requiredTime = (0.25 * (targetWeight - currentWeight) * 1000 * 0.3 * 4 + 0.75 * (targetWeight - currentWeight) * 1000 * 0.87 * 9) / 0.07 / maintainIntake;
      return requiredTime;
    }
    else if(_pattern == 'Lose Weight'){

    }
  }

  Widget build(BuildContext context) {
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
                _intake(widget.BMR, widget._currentUser.goal).toString() + 'cal',
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
                'days',
                style: generalStyle,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Center(
              child: Text(
                'Note: gaining muscle is a slow process, gaining too fast (faster than recommended) can result in excessive amount of fit gain. ',
                style: generalStyle,
              ),
            ),
          ),

        ],
      ),
    );
  }
}
