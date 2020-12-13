import 'package:flutter/material.dart';
import 'dart:async';


class More_Section extends StatefulWidget {

  @override
  _More_SectionState createState() => _More_SectionState();
}

class _More_SectionState extends State<More_Section> {
  static const TextStyle generalStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const TextStyle tableStyle =
  TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('More',
          style: generalStyle,),
        centerTitle: true,
        backgroundColor: Colors.amber[800],
      ),
          body: Column(
      children: <Widget>[

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Recipes',
                style: generalStyle,
              ),
              IconButton(
                color: Colors.amber,
                onPressed: (){
                },
                icon:Icon(Icons.keyboard_arrow_right_outlined),
                iconSize: 50,
              ),
            ]
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'MyFoods',
                style: generalStyle,
              ),
              IconButton(
                color: Colors.amber,
                onPressed: (){
                },
                icon:Icon(Icons.keyboard_arrow_right_outlined),
                iconSize: 50,
              ),
            ]
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Profile',
                style: generalStyle,
              ),
              IconButton(
                color: Colors.amber,
                onPressed: (){
                },
                icon:Icon(Icons.keyboard_arrow_right_outlined),
                iconSize: 50,
              ),
            ]
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Settings',
                style: generalStyle,
              ),
              IconButton(
                color: Colors.amber,
                onPressed: (){
                },
                icon:Icon(Icons.keyboard_arrow_right_outlined),
                iconSize: 50,
              ),
            ]
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Help',
                style: generalStyle,
              ),
              IconButton(
                color: Colors.amber,
                onPressed: (){
                },
                icon:Icon(Icons.keyboard_arrow_right_outlined),
                iconSize: 50,
              ),
            ]
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'About',
                style: generalStyle,
              ),
              IconButton(
                color: Colors.amber,
                onPressed: (){
                },
                icon:Icon(Icons.keyboard_arrow_right_outlined),
                iconSize: 50,
              ),
            ]
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Notifications',
                style: generalStyle,
              ),
              IconButton(
                color: Colors.amber,
                onPressed: (){
                },
                icon:Icon(Icons.keyboard_arrow_right_outlined),
                iconSize: 50,
              ),
            ]
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Reminders',
                style: generalStyle,
              ),
              IconButton(
                color: Colors.amber,
                onPressed: (){
                },
                icon:Icon(Icons.keyboard_arrow_right_outlined),
                iconSize: 50,
              ),
            ]
        ),

      ],
    ),
    );
  }
}
