import 'package:flutter/material.dart';
import 'dart:async';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Weight_section extends StatefulWidget {
  @override
  _Weight_sectionState createState() => _Weight_sectionState();
}

class _Weight_sectionState extends State<Weight_section> {
  static const TextStyle generalStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weight Chart',
          style: generalStyle,),
        centerTitle: true,
        backgroundColor: Colors.amber[800],
      ),
      body:Column(
        children: <Widget>[
          SizedBox(height: 20),
          Center(
            child: Text(
              'Current Weight',
              style: generalStyle
            ),
          ),
          SizedBox(height:20),
          Center(
            child: Text(
                'x' + ' kg',
                style: generalStyle
            ),
          ),
          SizedBox(height:20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                      'Start',
                      style: generalStyle
                  ),
                  SizedBox(height:20),
                  Text(
                      'x' + ' kg',
                      style: generalStyle
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Text(
                      'Goal',
                      style: generalStyle
                  ),
                  SizedBox(height:20),
                  Text(
                      'y' + ' kg',
                      style: generalStyle
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height:100),
          Center(
            child: Text(
                'Enter Graph Here',
                style: generalStyle
            ),
          ),
          SizedBox(height:100),
          Center(
            child: Text(
                'for scrolldown purpose',
                style: generalStyle
            ),
          ),

        ],
      ),
    );
  }
}
