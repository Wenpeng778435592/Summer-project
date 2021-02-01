import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_diet_diary/DataObjects/DatabaseHelper.dart';
import 'package:my_diet_diary/DataObjects/User.dart';
import 'package:my_diet_diary/User_input/ActivityLevel.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  List<String> _gender = ['Male', 'Female', 'Prefer not to say'];

  @override
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  Future userFuture;
  User _currentUser = new User();
  String selectedGender;

  @override
  void initState() {
    super.initState();
    userFuture = _getUserFuture();
  }

  _getUserFuture() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    int currentUserID = sp.getInt("currentUserID");
    
        if (currentUserID != null) {
      DatabaseHelper dbHelper = new DatabaseHelper();
      return await dbHelper.getUserByID(currentUserID);
    } else {
      return null;
    }
  }


  Widget _buildGender() {
    return DropdownButtonFormField(
      value: _currentUser.isEmpty() ? null : _currentUser.gender,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: 'Gender',
        labelStyle: labelStyle,
        hintText: 'Select your gender here',
        hintStyle: labelStyle,
      ),
      items: _gender.map((value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _currentUser.gender = value.toString();
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Gender is required.';
        }
      },
    );
  }
  Widget _buildAge() {
    return TextFormField(
      initialValue: _currentUser.isEmpty() ? "" : _currentUser.age.toString(),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Age',
        labelStyle: labelStyle,
        hintText: 'Enter your age here',
        hintStyle: labelStyle,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: (value) {
        setState(() {
          _currentUser.age = int.parse(value);
        });
      },
      validator: (value) {
        if (value.trim().isEmpty) {
          return 'Age is required.';
        }
      },
    );
  }
  
  Widget _buildHeight() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Height(cm)',
        labelStyle: labelStyle,
        hintText: 'Enter your height in cm here',
        hintStyle: labelStyle,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: (value) {
        setState(() {
          _currentUser.height = int.parse(value);
        });
      },
      validator: (value) {
        if (value.trim().isEmpty) {
          return 'Height is required.';
        }
      },
      initialValue:
          _currentUser.isEmpty() ? "" : _currentUser.height.toString(),
    );
  }
  
  Widget _buildWeight() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Weight(kg)',
        labelStyle: labelStyle,
        hintText: 'Enter your weight in kg here',
        hintStyle: labelStyle,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: (value) {
        setState(() {
          _currentUser.weight = int.parse(value);
        });
      },
      validator: (value) {
        if (value.trim().isEmpty) {
          return 'Weight is required.';
        }
      },
      initialValue:
          _currentUser.isEmpty() ? "" : _currentUser.weight.toString(),
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
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Text(
              'Profile',
              style: generalStyle,
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
            child: FutureBuilder(
                future: userFuture,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator());
                      break;
                    default:
                      if (snapshot.hasError)
                        return Text("Error " + snapshot.error.toString());
                      if (snapshot.data != null) {
                        _currentUser = snapshot.data;
                        print("existing user");
                      }
                      return Column(
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
                                onPressed: () {
                                  if (formkey.currentState.validate()) {
                                    print('Nice you made it!');
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Activity_Section(
                                                    _currentUser)));
                                  }
                                })
                          ]);
                  }
                }),
          ),
        ),
      ),
    );
  }
}
