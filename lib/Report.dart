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
        ],
      ),
    );
  }
}
