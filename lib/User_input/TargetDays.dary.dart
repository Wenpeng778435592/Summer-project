import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:my_diet_diary/DataObjects/User.dart';
import 'package:my_diet_diary/User_input/SuggestedIntake.dart';

class TargetDays_Section extends StatefulWidget {
  num BMR;
  User _currentUser;
  TargetDays_Section(this._currentUser, this.BMR);
  @override
  _TargetDays_SectionState createState() => _TargetDays_SectionState();
}

class _TargetDays_SectionState extends State<TargetDays_Section> {

  static const TextStyle generalStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const TextStyle labelStyle =
  TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  final GlobalKey<FormState> targetDaysKey = GlobalKey<FormState>();
  num dailyIntake = 0;
  num requiredTime = 0;
  num requiredTimeMin = 0;
  num requiredTimeMax = 0;
  num maintainIntake = 0;
  num loseWeightTime = 0;
  num beta = 0;
  num BMI = 0;
  List requiredTimeList = [0, 0];

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
    else if(_pattern == 'Lose Weight'){
      loseWeightTime = widget._currentUser.targetDays;
      beta = (0.25 * (widget._currentUser.weight - widget._currentUser.targetWeight) * 1000 * 0.3 * 4 + 0.75 * (widget._currentUser.weight - widget._currentUser.targetWeight) * 1000 * 0.87 * 9 );
      if(widget._currentUser.activityLevel == 'Sedentary(desk job)'){
        dailyIntake = beta / loseWeightTime + BMR;
      }
      else if(widget._currentUser.activityLevel == 'Light exercise(1-3 times per week)'){
        dailyIntake = beta / loseWeightTime + BMR * 1.2;
      }
      else if(widget._currentUser.activityLevel == 'Moderate exercise(4-5 times per week)'){
        dailyIntake = beta / loseWeightTime + BMR * 1.5;
      }
      else if(widget._currentUser.activityLevel == 'Active exercise(daily or intense sport 3-4 times per week)'){
        dailyIntake = beta / loseWeightTime + BMR * 1.55;
      }
    }
    return dailyIntake;
  }

  List _goalTime(currentWeight, targetWeight, _pattern){
    maintainIntake = _intake(widget.BMR, 'Maintain Weight');
    BMI = (widget._currentUser.targetWeight) / (widget._currentUser.height / 100) / (widget._currentUser.height / 100);
    if(_pattern == 'Lose Weight'){
      if(BMI < 25){
        requiredTimeMin = (log(targetWeight/currentWeight)) / (log(1-0.008)) * 7;
        requiredTimeMax = (log(targetWeight/currentWeight)) / (log(1-0.004)) * 7;

      }
      else if(BMI >= 25){
        requiredTimeMin = (log(targetWeight/currentWeight)) / (log(0.99)) * 7;
        requiredTimeMax = (log(targetWeight/currentWeight)) / (log(0.99)) * 7;
      }
    }
    requiredTimeList[0] = requiredTimeMin.round();
    requiredTimeList[1] = requiredTimeMax.round();
    return requiredTimeList;
  }

  Widget _buildTargetDays() {
    requiredTimeList = _goalTime(widget._currentUser.weight, widget._currentUser.targetWeight, widget._currentUser.goal);
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Target time(between ' + requiredTimeList[0].toString() + ' - ' + requiredTimeList[1].toString() + ' days)',labelStyle: labelStyle,
        hintText: 'Enter your target time in days here',hintStyle: labelStyle,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: (value){
        setState(() {
          widget._currentUser.targetDays = int.parse(value);
        });},
      validator: (value){
        requiredTimeList = _goalTime(widget._currentUser.weight, widget._currentUser.targetWeight, widget._currentUser.goal);
        if(value.trim().isEmpty || int.parse(value) > requiredTimeList[1]  || int.parse(value) < requiredTimeList[0] || value == null){
          return 'Please enter a valid number.';
        }
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Stack(
          children: <Widget>[
            Positioned(left:  0,
              child:IconButton(
                icon: Icon(Icons.arrow_back_ios_outlined),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
            ),
            Align(child: Text('Target days',
              style: generalStyle,),)





          ],
        ),
        backgroundColor: Colors.amber[800],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Form(
          key: targetDaysKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _buildTargetDays(),
                SizedBox(height: 100),
                RaisedButton(
                  child: Text(
                    'Next',
                    style: generalStyle,
                  ),
                  onPressed: (){
                    if(targetDaysKey.currentState.validate()){
                      widget._currentUser.dailyIntake = _intake(widget.BMR, widget._currentUser.goal);
                      print('Nice you made it!');
                      print(dailyIntake);
                      print(widget._currentUser.targetDays);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SuggestedDailyIntake_Section(widget._currentUser, widget.BMR)));


                    }
                  },
                )

              ],

            ),
          ),
        ),
      ),
    );
  }
}
