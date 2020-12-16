import 'package:flutter/material.dart';
import 'dart:async';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class About_Section extends StatefulWidget {
  @override
  _About_SectionState createState() => _About_SectionState();
}

class _About_SectionState extends State<About_Section> {
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
            Text('About',
              style: generalStyle,),
          ],
        ),
        backgroundColor: Colors.amber[800],
      ),
    );
  }
}
