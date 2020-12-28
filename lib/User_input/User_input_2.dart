import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
                Navigator.pop(context);
              },
            ),
          ],
        ),
        backgroundColor: Colors.amber[800],
      ),
      body: Form(
          key: formkey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _buildActivity(),
                SizedBox(height: 100),
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
          ),
        ),
      );
  }
}
