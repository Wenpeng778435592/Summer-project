import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Profile_Section extends StatefulWidget {
  @override
  _Profile_SectionState createState() => _Profile_SectionState();
}

class _Profile_SectionState extends State<Profile_Section> {
  static const TextStyle generalStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const TextStyle labelStyle =
  TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  @override
  String _gender = 'None';
  int _age;
  String _height;
  String _weight;

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  Widget _buildGender() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Gender', labelStyle: labelStyle,
      ),
      validator: (value){
        if(value.isEmpty){
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
        labelText: 'Height',labelStyle: labelStyle,
        hintText: 'Enter your height in cm here',hintStyle: labelStyle,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
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
        labelText: 'Weight',labelStyle: labelStyle,
        hintText: 'Enter your weight in kg here',hintStyle: labelStyle,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
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
        title: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back_ios_outlined),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            Text('Profile',
              style: generalStyle,),
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
              _buildAge(),
              _buildGender(),
              _buildHeight(),
              _buildWeight(),
              SizedBox(height: 100),
              RaisedButton(
                child: Text(
                  'Submit',
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
