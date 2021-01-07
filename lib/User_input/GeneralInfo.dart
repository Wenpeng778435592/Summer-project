import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_diet_diary/User_input/ActivityLevel.dart';
import 'package:my_diet_diary/DataObjects/User.dart';
import 'package:my_diet_diary/DataObjects/DatabaseHelper.dart';
import '../DataObjects/User.dart';

class GeneralInfo_Section extends StatefulWidget {
  @override
  _GeneralInfo_SectionState createState() => _GeneralInfo_SectionState();
}

class _GeneralInfo_SectionState extends State<GeneralInfo_Section> {
  static const TextStyle generalStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const TextStyle labelStyle =
  TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  List<String> _gender = [
    'Male',
    'Female',
    'Prefer not to say'
  ];

  @override



  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  String selectedGender;
  User _currentUser = new User();
  DatabaseHelper dbhelper = new DatabaseHelper();


  Widget _buildGender() {
    return DropdownButtonFormField(
      isExpanded: true,
      decoration: InputDecoration(
        labelText: 'Gender',labelStyle: labelStyle,
        hintText: 'Select your gender here',hintStyle: labelStyle,
      ),
      items: _gender.map((value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),


      onChanged: (value){
        setState(() {
          _currentUser.gender = value.toString();
        });},
      validator: (value){
        if(value == null){
          return 'Gender is required.';
        }
      },
    );

  }
  Widget _buildAge() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Age',labelStyle: labelStyle,
        hintText: 'Enter your age here',hintStyle: labelStyle,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: (value){
        setState(() {
          // if(_currentUser.age == null){
          //   _currentUser.age = int.parse(value);
          // };
          _currentUser.age = int.parse(value);
        });},
      validator: (value){
        if(value.trim().isEmpty){
          return 'Age is required.';
        }
      },
    );
  }
  Widget _buildHeight() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Height(cm)',labelStyle: labelStyle,
        hintText: 'Enter your height in cm here',hintStyle: labelStyle,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: (value){
        setState(() {
          // if(_currentUser.height == null){
          //   _currentUser.height = int.parse(value);
          // };
          _currentUser.height = int.parse(value);
        });},
      validator: (value){
        if(value.trim().isEmpty){
          return 'Height is required.';
        }
      },
    );
  }
  Widget _buildWeight() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Weight(kg)',labelStyle: labelStyle,
        hintText: 'Enter your weight in kg here',hintStyle: labelStyle,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: (value){
        setState(() {
          // if(_currentUser.weight == null){
          //   _currentUser.weight = int.parse(value);
          // };
          _currentUser.weight = int.parse(value);
        });},
      validator: (value){
        if(value.trim().isEmpty){
          return 'Weight is required.';
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
            Positioned(left:  0,
              child:IconButton(
                icon: Icon(Icons.arrow_back_ios_outlined),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
                ),

            Align(child: Text('Info',
              style: generalStyle,),)





          ],
        ),
        backgroundColor: Colors.amber[800],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Form(
          key: formkey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _buildAge(),
                _buildHeight(),
                _buildWeight(),
                _buildGender(),
                SizedBox(height: 100),
                RaisedButton(
                  child: Text(
                    'Next',
                    style: generalStyle,
                  ),
                  onPressed: (){
                    if(formkey.currentState.validate()){
                      print('Nice you made it!');
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Activity_Section(_currentUser)));

                    }
                  },
                )

              ],

            ),
          ),
        ),
      ),
    );
  }
}