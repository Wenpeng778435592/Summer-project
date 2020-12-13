import 'package:flutter/material.dart';
import 'dart:async';

class QuickAdd_Section extends StatefulWidget {
  @override
  _QuickAdd_SectionState createState() => _QuickAdd_SectionState();
}

class _QuickAdd_SectionState extends State<QuickAdd_Section> {
  static const TextStyle generalStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ShortCut',
          style: generalStyle,),
        centerTitle: true,
        backgroundColor: Colors.amber[800],
      ),
      body:Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(50, 50, 20, 20),
                child:RaisedButton(
                   child: Text('B',
                   style: generalStyle,),
                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30)),
                onPressed: (){
                },

                ),

              ),

            ],
          ),
        ],
      ),
    );
  }
}
