import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:my_diet_diary/User_input/Goal.dart';
import 'package:my_diet_diary/DataObjects/User.dart';



class Bodyfat_Section extends StatefulWidget {
  User _currentUser;
  Bodyfat_Section(this._currentUser);
  @override
  _Bodyfat_SectionState createState() => _Bodyfat_SectionState();
}

class _Bodyfat_SectionState extends State<Bodyfat_Section> {
  static const TextStyle generalStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const TextStyle labelStyle =
  TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  num BMR = 0;
  int bodyfatPercentage = 0;




  @override
  final GlobalKey<FormState> bodyfatkey = GlobalKey<FormState>();

  Widget _buildBodyfat() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Body fat',labelStyle: labelStyle,
        hintText: 'Enter your body fat percentage in kg here',hintStyle: labelStyle,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: (value){
        setState(() {
          // if(_currentUser.weight == null){
          //   _currentUser.weight = int.parse(value);
          // };
          bodyfatPercentage = int.parse(value);
        });},
      validator: (value){
        if(value.trim().isEmpty){
          return 'Body fat is required.';
        }
      },
    );
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Stack(
          children: <Widget>[
            Positioned(
              left: 0,
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios_outlined),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
            ),
            Align(
              child: Text('Body Fat',
                style: generalStyle,),
            ),
          ],
        ),
        backgroundColor: Colors.amber[800],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
              'Do you have a rough concept of your body fat percentage?',
              style: generalStyle,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              RaisedButton(
                child: Text(
                  'Yes',
                  style: generalStyle,
                ),
                onPressed: (){
                  _buildBodyfat();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Goal_Section(widget._currentUser, BMR)));
                },
              ),
              RaisedButton(
                child: Text(
                  'No',
                  style: generalStyle,
                ),
                onPressed: (){
                  if(widget._currentUser.gender == 'Male'){
                    BMR = 88.362 + 13.397 * widget._currentUser.weight + 4.799 * widget._currentUser.height - 5.677 * widget._currentUser.age;
                  }
                  else if(widget._currentUser.gender == 'Female'){
                    BMR = 447.593 + (9.247 * widget._currentUser.weight) + (3.098 * widget._currentUser.height) - (4.330 * widget._currentUser.age);
                  }
                  else if(widget._currentUser.gender == 'Prefer not to say'){
                    BMR = ((88.362 + 13.397 * widget._currentUser.weight + 4.799 * widget._currentUser.height - 5.677 * widget._currentUser.age) +
                        (BMR = 447.593 + (9.247 * widget._currentUser.weight) + (3.098 * widget._currentUser.height) - (4.330 * widget._currentUser.age))) / 2;
                  }
                  print(BMR);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Goal_Section(widget._currentUser, BMR)));
                },
              ),
            ],
          ),

        ],
      ),
    );
  }
}

