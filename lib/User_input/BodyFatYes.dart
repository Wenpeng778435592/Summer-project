import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:my_diet_diary/User_input/Goal.dart';
import 'package:my_diet_diary/DataObjects/User.dart';

class BodyFatYes_Section extends StatefulWidget {
  User _currentUser;
  BodyFatYes_Section(this._currentUser);
  @override
  _BodyFatYes_SectionState createState() => _BodyFatYes_SectionState();
}

class _BodyFatYes_SectionState extends State<BodyFatYes_Section> {
  @override
  static const TextStyle generalStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const TextStyle labelStyle =
  TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  int bodyfatPercentage = 0;
  num BMR = 0;
  final GlobalKey<FormState> bodyfatkey = GlobalKey<FormState>();

  Widget _buildBodyfat() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Body fat',labelStyle: generalStyle,
        hintText: 'Enter body fat percentage',hintStyle: generalStyle,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: (value){
        setState(() {
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: Form(
              key: bodyfatkey,
              child: SingleChildScrollView(
                child:_buildBodyfat(),
              ),
            ),
          ),

          RaisedButton(
            child: Text(
              'Submit',
              style: generalStyle,
            ),
            onPressed: (){
              if(bodyfatkey.currentState.validate()){
                print('Nice you made it!');
                BMR = 370 + 21.6 * ((100 - bodyfatPercentage)/100 * widget._currentUser.weight);
                print(BMR);
                Navigator.push(context, MaterialPageRoute(builder: (context) => Goal_Section(widget._currentUser, BMR)));
              }

            },
          ),
        ],

            ),
    );
  }
}
