import 'package:flutter/material.dart';
import 'dart:async';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Reminder_Section extends StatefulWidget {
  @override
  _Reminder_SectionState createState() => _Reminder_SectionState();
}

class _Reminder_SectionState extends State<Reminder_Section> {
  @override
  static const TextStyle generalStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back_ios_outlined),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            Text('Reminder',
              style: generalStyle,),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: (){

              },
            ),
          ],
        ),
        backgroundColor: Colors.amber[800],
      ),
    );
  }
}

