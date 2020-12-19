import 'package:flutter/material.dart';
import 'dart:async';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Setting_Section extends StatefulWidget {
  @override
  _Setting_SectionState createState() => _Setting_SectionState();
}

class _Setting_SectionState extends State<Setting_Section> {
  static const TextStyle generalStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  @override
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
            Text('Settings',
              style: generalStyle,),
          ],
        ),
        backgroundColor: Colors.amber[800],
      ),
    );
  }
}
