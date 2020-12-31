import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_diet_diary/User_input/BodyFat.dart';


class Activity_Section extends StatefulWidget {
  @override
  _Activity_SectionState createState() => _Activity_SectionState();
}

class _Activity_SectionState extends State<Activity_Section> {
  static const TextStyle generalStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const TextStyle labelStyle =
  TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  List<String> _activity = [
    'Sedentary(desk job)',
    'Light exercise(1-3 times per week)',
    'Moderate exercise(4-5 times per week)',
    'Active exercise(daily or intense sport 3-4 times per week)'
  ];
  @override


  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String selectedActivityLevel;

  Widget _buildActivity() {
    return DropdownButtonFormField(
      isExpanded: true,
      decoration: InputDecoration(
        labelText: 'Activity level',labelStyle: labelStyle,
        hintText: 'Select your activity level here',hintStyle: labelStyle,
      ),
      key: formkey,
      value: selectedActivityLevel,
      items: _activity.map((value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),

      onSaved: (value){
        setState(() {
          selectedActivityLevel = value;
        });},
      onChanged: (value){
        setState(() {
          selectedActivityLevel = value;
        });},
      validator: (value){
        if(value.isNull){
          return 'Activity level is required.';
        }
      },

    );

  }






  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back_ios_outlined),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            Text('Activity Level',
              style: generalStyle,),
            IconButton(
              icon: Icon(Icons.arrow_forward_ios_outlined),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Bodyfat_Section()),
                );
              },
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
              key: formkey,
              child: SingleChildScrollView(
                child:_buildActivity(),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
              'Note: Do not worry if you are not sure about this. The maintainence calorie will be more accurate over time.',
              style: generalStyle,

            ),
          ),
          RaisedButton(
            child: Text(
              'Next',
              style: generalStyle,
            ),
            onPressed: (){
              if(formkey.currentState.validate()){
                print('Nice you made it!');
              }
            },
          )
        ],
      ),
      );
  }
}
