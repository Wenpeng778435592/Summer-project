import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class TargetWeight_Section extends StatefulWidget {
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back_ios_outlined),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            Text('Target Weight',
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
              }
            },
          ),






        ],
      ),
    );;
  }
}
