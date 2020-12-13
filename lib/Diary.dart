import 'package:flutter/material.dart';
import 'dart:async';


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


    body: Column(
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
              SizedBox(height: 30),
              RaisedButton(
                color: Colors.amber,
                onPressed: (){

                },
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
              SizedBox(height: 30),
              RaisedButton(
                color: Colors.amber,
                onPressed: (){

                },
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
              SizedBox(height: 30),
              RaisedButton(
                color: Colors.amber,
                onPressed: (){

                },
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
              SizedBox(height: 30),
              RaisedButton(
                color: Colors.amber,
                onPressed: (){

                },
                child:Icon(Icons.add),
              ),
            ]
        ),

      ],
    ),

    );
  }
}
