import 'package:flutter/material.dart';
import 'dart:async';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_diet_diary/Diary-Breakfast.dart';
import 'package:my_diet_diary/Diary-Dinner.dart';
import 'package:my_diet_diary/Diary-Lunch.dart';
import 'package:my_diet_diary/Diary-Snack.dart';


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
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              RaisedButton(
                child: Text('B',
                  style: generalStyle,),
                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30)),
                onPressed: (){
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Breakfast_Section()),
                  );
                },
              ),
              RaisedButton(
                child: Text('S',
                  style: generalStyle,),
                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30)),
                onPressed: (){
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Breakfast_Section()),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Text('L',
                  style: generalStyle,),
                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30)),
                onPressed: (){
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Breakfast_Section()),
                  );
                },
              ),
              RaisedButton(
                child: Text('D',
                  style: generalStyle,),
                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30)),
                onPressed: (){
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Breakfast_Section()),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
