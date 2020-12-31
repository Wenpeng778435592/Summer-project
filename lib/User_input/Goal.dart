import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:my_diet_diary/User_input/TargetWeight.dart';

class Goal_Section extends StatefulWidget {
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back_ios_outlined),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            Text('Goal',
              style: generalStyle,),
            IconButton(
              icon: Icon(Icons.arrow_forward_ios_outlined),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => TargetWeight_Section()));
              },
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
              RaisedButton(
                child: Text(
                  'Gain Muscle(balk)',
                  style: generalStyle,
                ),
                onPressed: (){

                },
              ),
              SizedBox(height:30),
              RaisedButton(
                child: Text(
                  'Maintain Weight',
                  style: generalStyle,
                ),
                onPressed: (){

                },
              ),
              SizedBox(height:30),
              RaisedButton(
                child: Text(
                  'Lose Weight',
                  style: generalStyle,
                ),
                onPressed: (){

                },
              ),
            ],
          ),

        ],
      ),
    );
  }
}
