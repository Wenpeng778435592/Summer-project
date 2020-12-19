import 'package:flutter/material.dart';
import 'dart:async';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Helps_Section extends StatefulWidget {
  @override
  _Helps_SectionState createState() => _Helps_SectionState();
}

class _Helps_SectionState extends State<Helps_Section> {
  @override
  static const TextStyle generalStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back_ios_outlined),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            Text('Help',
              style: generalStyle,),
          ],
        ),
        backgroundColor: Colors.amber[800],
      ),
    );
  }
}


