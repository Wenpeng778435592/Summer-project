import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_diet_diary/User_input/ActivityLevel.dart';

class Profile_Section extends StatefulWidget {
  @override
  _Profile_SectionState createState() => _Profile_SectionState();
}

class _Profile_SectionState extends State<Profile_Section> {
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
  final dropdownkey = GlobalKey<FormState>();
  String selectedGender;

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
                Navigator.push(context, MaterialPageRoute(builder: (context) => Activity_Section()),
                );

              },
            ),
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
