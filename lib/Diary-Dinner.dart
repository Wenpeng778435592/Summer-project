import 'package:flutter/material.dart';
import 'dart:async';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Dinner_Section extends StatefulWidget {
  @override
  _Dinner_SectionState createState() => _Dinner_SectionState();
}

class _Dinner_SectionState extends State<Dinner_Section> {

  static const TextStyle generalStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const TextStyle tableStyle =
  TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon:Icon(Icons.arrow_back_ios_outlined),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            Text('Dinner'),
            IconButton(
              icon:FaIcon(FontAwesomeIcons.barcode),
              onPressed: (){},
            ),
          ],
        ),
        backgroundColor:Colors.amber[800],
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(
            onPressed: (){},
            child:Text('Food Recent',
              style: generalStyle,
            ),
            color: Colors.amber,
          ),
          RaisedButton(
            onPressed: (){},
            child:Text('My Food Recipes',
              style: generalStyle,
            ),
            color: Colors.amber,
          ),
          RaisedButton(
            onPressed: (){},
            child:Text('Find a Food',
              style: generalStyle,
            ),
            color: Colors.amber,
          ),
        ],
      ),
    );
  }
}
