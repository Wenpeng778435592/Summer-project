import 'package:flutter/material.dart';
import 'dart:async';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_diet_diary/Breakfast.dart';
import 'package:my_diet_diary/Dinner.dart';
import 'package:my_diet_diary/Lunch.dart';
import 'package:my_diet_diary/Snack.dart';

class Dairy_Section extends StatefulWidget {
  @override
  _Dairy_SectionState createState() => _Dairy_SectionState();
}

class _Dairy_SectionState extends State<Dairy_Section> {
  static const TextStyle generalStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const TextStyle tableStyle =
  TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Date',
        style: generalStyle,),
        centerTitle: true,
        backgroundColor: Colors.amber[800],
      ),
    body: Container(
    child:Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Table(
          border: TableBorder.all(color: Colors.black),
          children:[
            TableRow(
              children: [
                Text('Goal Energy',
                  style: tableStyle,),
                Text('Food Energy',
                  style: tableStyle,),
                Text('Difference',
                  style: tableStyle,),
              ],
            ),
            TableRow(
                children: [
                  Text('2000',
                    style: tableStyle,),
                  Text('2500',
                    style: tableStyle,),
                  Text('500',
                    style: tableStyle,),
                ],
            ),
            TableRow(
              children: [
                Text('Protein',
                  style: tableStyle,),
                Text('Carbohydrate',
                  style: tableStyle,),
                Text('Fat',
                  style: tableStyle,),
              ],
            ),
            TableRow(
              children: [
                Text('x',
                  style: tableStyle,),
                Text('x',
                  style: tableStyle,),
                Text('x',
                  style: tableStyle,),
              ],
            ),
          ],
        ),
        SizedBox(height: 70),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Breakfast',
                style: generalStyle,
              ),
              RaisedButton(
                color: Colors.amber,
                onPressed: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Breakfast_Section()),
                  );
                },
                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30)),
                child:Icon(Icons.add),
              ),
            ]
        ),
        SizedBox(height: 70),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Lunch',
                style: generalStyle,
              ),
              RaisedButton(
                color: Colors.amber,
                onPressed: (){
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Lunch_Section()),
                  );
                },
                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30)),
                child:Icon(Icons.add),
              ),
            ]
        ),
        SizedBox(height: 70),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Dinner',
                style: generalStyle,
              ),
              RaisedButton(
                color: Colors.amber,
                onPressed: (){
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Dinner_Section()),
                  );
                },
                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30)),
                child:Icon(Icons.add),
              ),
            ]
        ),
        SizedBox(height: 70),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Snacks',
                style: generalStyle,
              ),
              RaisedButton(
                color: Colors.amber,
                onPressed: (){
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Snack_Section()),
                  );
                },
                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30)),
                child:Icon(Icons.add),
              ),
            ]
        ),

      ],
    ),
    ),

    );
  }
}
