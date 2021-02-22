import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:my_diet_diary/DataObjects/FoodEntry.dart';
import 'package:my_diet_diary/DataObjects/DatabaseHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_diet_diary/DataObjects/Meal.dart';

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

  @override

  Widget _buildName() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: 'Enter name of food here',hintStyle: labelStyle,
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
        hintText: 'Enter size per serve here',hintStyle: labelStyle,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: (value){
        setState(() {
          _servingSize = int.parse(value);
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
        hintText: 'Enter energy per serve here',hintStyle: labelStyle,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: (value){
        setState(() {
          _energy = int.parse(value);
        });},
      validator: (value){
        if(value == 0){
          return 'Invalid energy number.';
        }
      },
    );
  }

  Widget _buildProtein() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: 'Enter protein per serve here',hintStyle: labelStyle,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: (value){
        setState(() {
          _protein = int.parse(value);
        });},
      validator: (value){
        if(value == 0){
          return 'Invalid protein number.';
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
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
        backgroundColor: Colors.amber[800],
      ),
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                alignment: Alignment.topLeft,
                child: Text('Name',
                  style: generalStyle,),
              ),
              _buildName(),
              SizedBox(height:10),
              Container(
                alignment: Alignment.topLeft,
                child: Text('Serving Size',
                  style: generalStyle,),
              ),
              _buildServingSize(),
              SizedBox(height:20),
              Container(
                alignment: Alignment.topLeft,
                child: Text('Per serving',
                  style: generalStyle,),
              ),
              SizedBox(height:20),
              Container(
                alignment: Alignment.topLeft,
                child: Text('Energy',
                  style: generalStyle,),
              ),
              _buildEnergy(),
              SizedBox(height:10),
              Container(
                alignment: Alignment.topLeft,
                child: Text('Protein(g)',
                  style: generalStyle,),
              ),
              _buildProtein(),

            ]),


      ),

    );
  }
}
