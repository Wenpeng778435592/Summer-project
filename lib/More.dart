import 'package:flutter/material.dart';
import 'package:my_diet_diary/More-About.dart';
import 'package:my_diet_diary/More-Notifications.dart';
import 'package:my_diet_diary/More-Profile.dart';
import 'package:my_diet_diary/More-Reciples.dart';
import 'dart:async';
import 'package:my_diet_diary/More-Reminder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_diet_diary/More-Settings.dart';
import 'package:my_diet_diary/More-MyFoods.dart';
import 'package:my_diet_diary/More-Help.Dart';

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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('More',
          style: generalStyle,),
        centerTitle: true,
        backgroundColor: Colors.amber[800],
      ),
          body: Column(
              // mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[

                Expanded(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Recipes',
                          style: generalStyle,
                        ),
                        IconButton(
                          color: Colors.amber,
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Reciple_Section()),
                            );
                          },
                          icon:Icon(Icons.keyboard_arrow_right_outlined),
                          iconSize: 55,
                        ),
                      ]
                  ),
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
                          Navigator.push(context, MaterialPageRoute(builder: (context) => MyFood_Section()),
                          );
                        },
                        icon:Icon(Icons.keyboard_arrow_right_outlined),
                        iconSize: 55,
                      ),
                    ]
                ),
                Divider(
                  height: 10,
                  thickness: 5,
                  color: Colors.blue,
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
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Profile_Section()),
                          );
                        },
                        icon:Icon(Icons.keyboard_arrow_right_outlined),
                        iconSize: 55,
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
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Setting_Section()),
                          );
                        },
                        icon:Icon(Icons.keyboard_arrow_right_outlined),
                        iconSize: 55,
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
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Notification_Section()),
                          );
                        },
                        icon:Icon(Icons.keyboard_arrow_right_outlined),
                        iconSize: 55,
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
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Reminder_Section()),
                          );
                        },
                        icon:Icon(Icons.keyboard_arrow_right_outlined),
                        iconSize: 55,
                      ),
                    ]
                ),
                Divider(
                  height: 10,
                  thickness: 5,
                  color: Colors.blue,
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
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Helps_Section()),
                          );
                        },
                        icon:Icon(Icons.keyboard_arrow_right_outlined),
                        iconSize: 55,
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
                          Navigator.push(context, MaterialPageRoute(builder: (context) => About_Section()),
                          );
                        },
                        icon:Icon(Icons.keyboard_arrow_right_outlined),
                        iconSize: 55,
                      ),
                    ]
                ),

              ],
    ),
    );
  }
}
