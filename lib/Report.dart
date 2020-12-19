import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Report_Section extends StatefulWidget {
  @override
  _Report_SectionState createState() => _Report_SectionState();
}

class _Report_SectionState extends State<Report_Section> {
  static const TextStyle generalStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Energy Chart',
          style: generalStyle,),
        centerTitle: true,
        backgroundColor: Colors.amber[800],
      ),
      body: Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                onPressed: (){},
                icon:Icon(Icons.arrow_back),
                iconSize: 55,
                color: Colors.amber,
              ),
              RaisedButton(
                onPressed: (){},
                child:Text(
                  'This Week',
                  style:generalStyle,
                ),
                color: Colors.amber,
                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30)),
              ),

              IconButton(
                onPressed: (){},
                icon:Icon(Icons.arrow_forward),
                iconSize: 55,
                color: Colors.amber,
              ),
            ],
          ),
          SizedBox(height: 20,),
          Row(
            children: <Widget>[
              Text(
                'Calories',
                style:generalStyle,
              ),
            ],
          ),
          SizedBox(height: 20,),
          Row(
            children: <Widget>[
              Text(
                'x',
                style:generalStyle,
              ),
            ],
          ),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Daily Average: ',
                style:generalStyle,
              ),
              Text(
                'y',
                style:generalStyle,
              ),
              Text(
                'Goal: ',
                style:generalStyle,
              ),
              Text(
                'z',
                style:generalStyle,
              ),
            ],
          ),
          SizedBox(height: 20,),
        ],
      ),
    );
  }
}
