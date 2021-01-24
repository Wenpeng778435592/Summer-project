import 'package:flutter/material.dart';
import 'package:my_diet_diary/User_input/BodyFat.dart';
import 'package:my_diet_diary/DataObjects/User.dart';



class Activity_Section extends StatefulWidget {
  User _currentUser;
  Activity_Section(this._currentUser);

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


  final GlobalKey<FormState> activityFormkey = GlobalKey<FormState>();

  String selectedActivityLevel;

  Widget _buildActivity() {
    return DropdownButtonFormField(
      value: widget._currentUser.activityLevel,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: 'Activity Level',labelStyle: generalStyle,
        hintText: 'Select your activity level here',hintStyle: generalStyle,
      ),
      items: _activity.map((value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),

      onChanged: (value){
        setState(() {
          widget._currentUser.activityLevel = value.toString();
        });},
      validator: (value){
        if(value == null){
          return 'Activity level is required.';
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
              child: Text('Activity Level',
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
              key: activityFormkey,
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
              if(activityFormkey.currentState.validate()){
                print(widget._currentUser.activityLevel);
                print('Nice you made it!');
                Navigator.push(context, MaterialPageRoute(builder: (context) => Bodyfat_Section(widget._currentUser)));
              }
            },
          )
        ],
      ),
      );
  }
}




