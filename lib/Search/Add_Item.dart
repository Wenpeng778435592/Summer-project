import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_diet_diary/DataObjects/DatabaseHelper.dart';
import 'package:my_diet_diary/DataObjects/FoodEntry.dart';
import 'package:my_diet_diary/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future userFuture;
FoodEntry _foodEntry;
DatabaseHelper dbHelper = new DatabaseHelper();

class AddItem_Section extends StatefulWidget {
  final String meal;
  final String short_names;
  String carbohydrate;
  String energy;
  String fat;
  final String id;
  String protein;
  final String serv;
  AddItem_Section(
      this.meal, this.short_names, this.carbohydrate, this.energy, this.fat, this.id, this.protein, this.serv);
  @override
  _AddItem_SectionState createState() => _AddItem_SectionState();
}

class _AddItem_SectionState extends State<AddItem_Section> {
  int currentUserID;
  static const TextStyle generalStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const TextStyle labelStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  @override
  void initState() {
    super.initState();
    userFuture = _getUserFuture();
  }

  _getUserFuture() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    currentUserID = sp.getInt("currentUserID");
  }

  num amountFood = 1;

  final GlobalKey<FormState> AddItemFormKey = GlobalKey<FormState>();

  Widget _buildAmount() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Amount',
        labelStyle: generalStyle,
        hintText: 'Enter amount of food here',
        hintStyle: labelStyle,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: (value) {
        setState(() {
          amountFood = int.parse(value);
        });
      },
      validator: (value) {
        if (value.trim().isEmpty) {
          return 'Amount of selected food is required.';
        }
      },
    );
  }

  Widget build(BuildContext context) {
    if (widget.fat == 'trace') {
      widget.fat = '0';
    }
    if (widget.energy == 'trace') {
      widget.energy = '0';
    }
    if (widget.protein == 'trace') {
      widget.protein = '0';
    }
    if (widget.carbohydrate == 'trace') {
      widget.carbohydrate = '0';
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Stack(
          children: <Widget>[
            Positioned(
              left: 0,
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios_outlined),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Center(
              child: Text(
                'Item Details',
                style: generalStyle,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.amber[800],
      ),
      body: Builder(
        builder: (context) => SingleChildScrollView(
          child: Align(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 3),
                  ),
                  child: Text(
                    widget.short_names,
                    style: generalStyle,
                  ),
                ),
                Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 3),
                      ),
                      child: Form(
                        key: AddItemFormKey,
                        child: SingleChildScrollView(
                          child: _buildAmount(),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 3),
                      ),
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Serving (g)',
                            style: generalStyle,
                          ),
                          Text(
                            widget.serv,
                            style: generalStyle,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Table(
                        border: TableBorder.all(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 2,
                        ),
                        children: [
                          TableRow(
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'Energy',
                                    style: labelStyle,
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Carb',
                                    style: labelStyle,
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Fat',
                                    style: labelStyle,
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Protein',
                                    style: labelStyle,
                                  )
                                ],
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              Column(
                                children: [
                                  Text(
                                    ((num.parse(widget.energy) * amountFood).toStringAsFixed(1)).toString(),
                                    style: generalStyle,
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    ((num.parse(widget.carbohydrate) * amountFood).toStringAsFixed(1)).toString(),
                                    style: generalStyle,
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    ((num.parse(widget.fat) * amountFood).toStringAsFixed(1)).toString(),
                                    style: generalStyle,
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    ((num.parse(widget.protein) * amountFood).toStringAsFixed(1)).toString(),
                                    style: generalStyle,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: RaisedButton(
                    child: Text(
                      'Add',
                      style: generalStyle,
                    ),
                    onPressed: () {
                      if (AddItemFormKey.currentState.validate()) {
                        _foodEntry = new FoodEntry(
                            currentUserID,
                            num.parse(widget.carbohydrate) * amountFood,
                            num.parse(widget.protein) * amountFood,
                            num.parse(widget.fat) * amountFood,
                            num.parse(widget.energy) * amountFood,
                            widget.short_names,
                            widget.meal,
                            DateTime.now().toString(),
                            this.amountFood * 100);
                        dbHelper.addFoodEntry(_foodEntry);

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Home()),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
