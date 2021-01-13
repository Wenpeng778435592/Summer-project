import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:my_diet_diary/DataObjects/User.dart';
import 'package:my_diet_diary/User_input/SuggestedIntake.dart';

class TargetWeight_Section extends StatefulWidget {
  User _currentUser;
  num BMR;
  TargetWeight_Section(this._currentUser, this.BMR);
  @override
  _TargetWeight_SectionState createState() => _TargetWeight_SectionState();
}

class _TargetWeight_SectionState extends State<TargetWeight_Section> {
  static const TextStyle generalStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const TextStyle labelStyle =
  TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  @override
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  Widget _buildTargetWeight() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'TargetWeight(kg)',labelStyle: labelStyle,
        hintText: 'Enter your target weight in kg here',hintStyle: labelStyle,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: (value){
        setState(() {
          widget._currentUser.targetWeight = int.parse(value);
        });},
      validator: (value){
        if(value.trim().isEmpty){
          return 'Target weight is required.';
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
              child: Text('Target Weight',
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
              'What is your target weight?',
              style: generalStyle,
            ),
          ),
          
          Container(
            padding: EdgeInsets.all(10),
              child: Form(
                key:formkey,
                child:SingleChildScrollView(
                  child:_buildTargetWeight(),
                ),
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => SuggestedDailyIntake_Section(widget._currentUser, widget.BMR)));
              }
            },
          ),






        ],
      ),
    );
  }
}
