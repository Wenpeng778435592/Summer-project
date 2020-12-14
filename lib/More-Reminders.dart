import 'package:flutter/material.dart';
import 'dart:async';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ReminderSection extends StatefulWidget {
  @override
  _ReminderSectionState createState() => _ReminderSectionState();
}

class _ReminderSectionState extends State<ReminderSection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(Icons.arrow_back_ios_outlined),
            Text(
                'Reminder'
            ),
            Icon(Icons.add),
          ],
        ),

      ),
      body: Column(
        children: <Widget>[
          Text('hello'),

        ],
      ),
    );
  }
}
