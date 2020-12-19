import 'package:flutter/material.dart';
import 'dart:async';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Lunch_Section extends StatefulWidget {
  @override
  _Lunch_SectionState createState() => _Lunch_SectionState();
}

class _Lunch_SectionState extends State<Lunch_Section> {

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
            Text('Lunch'),
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
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(
                child: RaisedButton(
                  onPressed: (){},
                  child:Text('Food Recent',
                    style: generalStyle,
                  ),
                  color: Colors.amber,
                ),
              ),
              Expanded(
                child: RaisedButton(
                  onPressed: (){},
                  child:Text('My Food Recipes',
                    style: generalStyle,
                  ),
                  color: Colors.amber,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(
                child: RaisedButton(
                  onPressed: (){},
                  child:Text('Find a Food',
                    style: generalStyle,
                  ),
                  color: Colors.amber,
                ),
              ),
            ],
          ),


        ],
      ),
    );
  }
}
