import 'package:flutter/material.dart';
import 'dart:async';


class Dairy_Section extends StatefulWidget {
  @override
  _Dairy_SectionState createState() => _Dairy_SectionState();
}

class _Dairy_SectionState extends State<Dairy_Section> {
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
                Text('Goal Energy'),
                Text('Food Energy'),
                Text('Difference'),
              ],
            ),
            TableRow(
                children: [
                  Text('2000'),
                  Text('2500'),
                  Text('500'),
                ],
            ),
            TableRow(
              children: [
                Text('Protein'),
                Text('Carbohydrate'),
                Text('Fat'),
              ],
            ),
            TableRow(
              children: [
                Text('x'),
                Text('x'),
                Text('x'),
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
                style: TextStyle(
                  fontSize: 30,
                ),
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
                style: TextStyle(
                  fontSize: 30,
                ),
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
                style: TextStyle(
                  fontSize: 30,
                ),
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
                style: TextStyle(
                  fontSize: 30,
                ),
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
