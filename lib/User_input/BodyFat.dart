import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:my_diet_diary/User_input/Goal.dart';


class Bodyfat_Section extends StatefulWidget {
  @override
  _Bodyfat_SectionState createState() => _Bodyfat_SectionState();
}

class _Bodyfat_SectionState extends State<Bodyfat_Section> {
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
            Text('Body Fat',
              style: generalStyle,),
            IconButton(
              icon: Icon(Icons.arrow_forward_ios_outlined),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Goal_Section()),
                );
              },
            ),
          ],
        ),
        backgroundColor: Colors.amber[800],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
              'Do you have a rough concept of your body fat percentage?',
              style: generalStyle,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              RaisedButton(
                child: Text(
                  'Yes',
                  style: generalStyle,
                ),
                onPressed: (){

                },
              ),
              RaisedButton(
                child: Text(
                  'No',
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

