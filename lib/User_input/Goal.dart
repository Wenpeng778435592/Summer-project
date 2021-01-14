import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_diet_diary/User_input/SuggestedIntake.dart';
import 'dart:async';
import 'package:my_diet_diary/User_input/TargetWeight.dart';
import 'package:my_diet_diary/DataObjects/User.dart';
import 'package:my_diet_diary/User_input/TargetDays.dary.dart';


class Goal_Section extends StatefulWidget {
  User _currentUser;
  num BMR;
  Goal_Section(this._currentUser, this.BMR);
  @override
  _Goal_SectionState createState() => _Goal_SectionState();
}

class _Goal_SectionState extends State<Goal_Section> {
  static const TextStyle generalStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const TextStyle labelStyle =
  TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  @override
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
              child: Text('Goal',
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
            child: Text(
              'What is your goal?',
              style: generalStyle,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(height:30),
              RaisedButton(
                child: Text(
                  'Maintain Weight',
                  style: generalStyle,
                ),
                onPressed: (){
                  widget._currentUser.goal = 'Maintain Weight';
                  widget._currentUser.targetWeight = widget._currentUser.weight;
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SuggestedDailyIntake_Section(widget._currentUser, widget.BMR)));
                },
              ),
              SizedBox(height:30),
              RaisedButton(
                child: Text(
                  'Lose Weight',
                  style: generalStyle,
                ),
                onPressed: (){
                  widget._currentUser.goal = 'Lose Weight';
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TargetWeight_Section(widget._currentUser, widget.BMR)));
                },
              ),
            ],
          ),

        ],
      ),
    );
  }
}
