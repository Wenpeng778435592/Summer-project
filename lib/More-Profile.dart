import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_diet_diary/User_input/GeneralInfo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'DataObjects/DatabaseHelper.dart';
import 'DataObjects/User.dart';
import 'User_input/GeneralInfo.dart';

class Profile_Section extends StatefulWidget {
  @override
  _Profile_SectionState createState() => _Profile_SectionState();
}

class _Profile_SectionState extends State<Profile_Section> {
  static const TextStyle generalStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static const TextStyle buttonStyle =
      TextStyle(fontSize: 18, color: Colors.black);

  Future userFuture;

  @override
  void initState() {
    super.initState();
    userFuture = _getUserFuture();
  }

  _getUserFuture() async {
    DatabaseHelper dbHelper = new DatabaseHelper();
    SharedPreferences sp = await SharedPreferences.getInstance();

    int currentUserID = sp.getInt("currentUserID");
    return await dbHelper.getUserByID(currentUserID);
  }
  Widget _buildGender() {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        labelText: 'Gender',labelStyle: labelStyle,
        hintText: 'Select your gender here',hintStyle: labelStyle,
      ),
      key: dropdownkey,
      value: selectedGender,
      items: _gender.map((value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),

      onSaved: (value){
        setState(() {
          selectedGender = value;
        });},
      onChanged: (value){
        setState(() {
          selectedGender = value;
        });},
      validator: (value){
        if(value.isNull){
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
        labelText: 'Height(cm)',labelStyle: labelStyle,
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
        labelText: 'Weight(kg)',labelStyle: labelStyle,
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back_ios_outlined),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            Text('Profile',
              style: generalStyle,),
            IconButton(
              icon: Icon(Icons.arrow_forward_ios_outlined),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => GeneralInfo_Section()));

              },
            ),
          ],
        ),
        backgroundColor: Colors.amber[800],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          
          Container(
            padding: EdgeInsets.fromLTRB(10, 50, 10, 50),
            child: RaisedButton(
            child:Text('View User Information', style: generalStyle,),
            color: Colors.amber,
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => GeneralInfo_Section()));
            },
        ),
          ),
        ],

      ),

    );
  }
}




