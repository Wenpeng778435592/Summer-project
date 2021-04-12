import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:my_diet_diary/DataObjects/MyFoodEntry.dart';
import 'package:my_diet_diary/DataObjects/DatabaseHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_diet_diary/DataObjects/Meal.dart';



Future userFuture;
MyFoodEntry _myFoodEntry;
DatabaseHelper dbHelper = new DatabaseHelper();



class Add_Food extends StatefulWidget {
  @override
  _Add_FoodState createState() => _Add_FoodState();
}

class _Add_FoodState extends State<Add_Food> {
  static const TextStyle generalStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const TextStyle labelStyle =
  TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  String _foodName = '';
  num _servingSize = 0;
  num _energy = 0;
  num _protein = 0;
  num _fat = 0;
  num _carbohydrate = 0;
  String _unit = 'Cal';
  int currentUserID;

  @override

  void initState() {
    super.initState();
    userFuture = _getUserFuture();
  }

  _getUserFuture() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    currentUserID = sp.getInt("currentUserID");
  }


  final GlobalKey<FormState> AddFoodNameFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> AddFoodValueFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> OptionalFormKey = GlobalKey<FormState>();
  List<bool> _selections = List.generate(2, (index) => false);


  bool isexpanded  = false;

  Widget _buildName() {
    return TextFormField(
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        labelText: 'Name',labelStyle: generalStyle,
      ),
      onChanged: (value){
        setState(() {
          _foodName = value.toString();
        });},
      validator: (value){
        if(value.trim().isEmpty){
          return 'Name of the food is required.';
        }
      },
    );
  }

  Widget _buildServingSize() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Serving Size (g)',labelStyle: generalStyle,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: (value){
        setState(() {
          _servingSize = num.parse(value);
        });},
      validator: (value){
        if(value == 0){
          return 'Invalid serving size.';
        }
      },
    );
  }

  Widget _buildEnergy() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: (value){
        setState(() {
          _energy = num.parse(value);
        });},
      validator: (value){
        if(value == 0){
          return 'Invalid energy input.';
        }
      },
    );
  }

  Widget _buildProtein() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Protein (g)',labelStyle: generalStyle,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: (value){
        setState(() {
          _protein = num.parse(value);
        });},
      validator: (value){
        if(value == 0){
          return 'Invalid protein input.';
        }
      },
    );
  }

  Widget _buildFat() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Fat (g)',labelStyle: generalStyle,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: (value){
        setState(() {
          _fat = num.parse(value);
        });},
      // validator: (value){
      //   if(value == 0){
      //     return 'Invalid fat input.';
      //   }
      // },
    );
  }

  Widget _buildCarbohydrate() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Carbohydrate (g)',labelStyle: generalStyle,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: (value){
        setState(() {
          _carbohydrate = num.parse(value);
        });},
      // validator: (value){
      //   if(value == 0){
      //     return 'Invalid carbohydrate input.';
      //   }
      // },
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
            Center(
              child: Text('New Food',
                style: generalStyle,),
            ),
            Positioned(
              right: 0,
              child: TextButton(
                child: Text('Save',
                  style: TextStyle(
                    color: Colors.white,
                      fontSize: 25, fontWeight: FontWeight.bold),),
                onPressed: (){
                  if(AddFoodNameFormKey.currentState.validate() && AddFoodValueFormKey.currentState.validate()){
                    print('Nice you made it!');
                    print('AddFood working');
                    print(_unit + ' working');
                    print('UserID');
                    print(currentUserID);
                    if(_unit == 'KJ'){ _energy = _energy / 4.184;}
                    _myFoodEntry = new MyFoodEntry(currentUserID, _carbohydrate, _protein, _fat,
                        _energy, _foodName, _servingSize);
                    dbHelper.addMyFood(_myFoodEntry);
                    print('db working');
                  }
                },
              ),
            ),
          ],
        ),
        backgroundColor: Colors.amber[800],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Form(
                key: AddFoodNameFormKey,
                child: Column(
                  children: <Widget>[
                    _buildName(),
                    _buildServingSize()
                  ],
                ),),
            ),

            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              alignment: Alignment.topLeft,
              child: Text('Per Serving',
                     style: generalStyle,),
            ),


            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              alignment: Alignment.topLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Energy',
                    style: generalStyle,),
                  ToggleButtons(
                      children: [
                        Text('KJ',
                          style: labelStyle,
                        ),
                        Text('Cal',
                          style: labelStyle,
                        ),
                      ], isSelected: _selections,
                    onPressed: (int index) {

                      setState(() {
                        for (int i = 0; i < _selections.length; i++) {
                          _selections[i] = i == index;
                        }

                      });
                      if(index == 0){_unit = 'KJ';}else if(index == 1){_unit = 'Cal';}
                      print(index);
                      print(_unit);
                    },
                    selectedColor: Colors.amber[800],
                  )
                ]
              ),
            ),


            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
              child: Form(
                key: AddFoodValueFormKey,
                child: Column(
                  children: <Widget>[
                    _buildEnergy(),
                    _buildProtein(),
                  ],
                ),),
            ),

            ExpansionTile(
              title: Text('Optional', style: generalStyle,),
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: Form(
                    key: OptionalFormKey,
                    child: Column(
                      children: <Widget>[
                        _buildFat(),
                        _buildCarbohydrate(),
                      ],
                    ),),
                ),
              ],
            ),


          ],
        ),

        )

    );
  }
}
