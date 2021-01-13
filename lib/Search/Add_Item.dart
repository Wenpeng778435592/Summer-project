import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:my_diet_diary/DataObjects/User.dart';

class AddItem_Section extends StatefulWidget {
  @override
  _AddItem_SectionState createState() => _AddItem_SectionState();
}

class _AddItem_SectionState extends State<AddItem_Section> {
  static const TextStyle generalStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const TextStyle labelStyle =
  TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  @override

  num amountFood = 0;

  final GlobalKey<FormState> AddItemFormKey = GlobalKey<FormState>();

  Widget _buildAmount() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Amount',labelStyle: generalStyle,
        hintText: 'Enter amount of food here',hintStyle: labelStyle,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: (value){
        setState(() {
          amountFood = int.parse(value);
        });},
      validator: (value){
        if(value.trim().isEmpty){
          return 'Amount of selected food is required.';
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
              child: Text('Item Details',
                style: generalStyle,),
            ),
            Positioned(
              right: 0,
              child: RaisedButton(
                child: Text(
                  'Add',
                ),
                onPressed: (){},
              ),
            ),
          ],
        ),
        backgroundColor: Colors.amber[800],
      ),
      body: Align(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 3),
                ),
                child: Text(
                  'Product Name',
                  style: generalStyle,
                ),
              ),


            IntrinsicWidth(
              child: Column(
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
                          'Serving(' + 'x' + ') g',
                          style: generalStyle,
                        ),
                        Text(
                          'g',
                          style: generalStyle,
                        ),
                      ],
                    ),


                  ),
                ],
              ),
            ),








            RaisedButton(
              child: Text(
                'Next',
                style: generalStyle,
              ),
              onPressed: (){
                if(AddItemFormKey.currentState.validate()){
                  print('Nice you made it!');

                }
              },
            ),






          ],
        ),
      ),
    );
  }
}









