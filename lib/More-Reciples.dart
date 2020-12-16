import 'package:flutter/material.dart';
import 'dart:async';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Reciple_Section extends StatefulWidget {
  @override
  _Reciple_SectionState createState() => _Reciple_SectionState();
}

class _Reciple_SectionState extends State<Reciple_Section> {
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
            Text('Reciple',
              style: generalStyle,),
          ],
        ),
        backgroundColor: Colors.amber[800],
      ),
    );
  }
}
