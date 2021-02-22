import 'package:flutter/material.dart';
import 'dart:async';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:my_diet_diary/Search/SearchPage.dart';
import 'package:my_diet_diary/Search/MyFoodSearchPage.dart';

import 'qr_view/BarcodeScanPage.dart';

class Snack_Section extends StatefulWidget {
  @override
  _Snack_SectionState createState() => _Snack_SectionState();
}

class _Snack_SectionState extends State<Snack_Section> {

  static const TextStyle generalStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const TextStyle tableStyle =
  TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon:Icon(Icons.arrow_back_ios_outlined),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            Text('Snacks'),
            IconButton(
              icon:FaIcon(FontAwesomeIcons.barcode),
              onPressed: ()async {
                PermissionStatus _hasPermission = await Permission.camera.request();
                if(!_hasPermission.isGranted) return;
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BarcodeScanPage()),
                );
              },
            ),
          ],
        ),
        backgroundColor:Colors.amber[800],
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(
                child: RaisedButton(
                  onPressed: (){},
                  child:Text('Food Recent',
                    style: generalStyle,
                  ),
                  color: Colors.amber,
                ),
              ),
              Expanded(
                child: RaisedButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyFoodSearchBar('snack')),
                    );
                  },
                  child:Text('My Food List',
                    style: generalStyle,
                  ),
                  color: Colors.amber,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(
                child: RaisedButton(
                  onPressed: (){
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SearchBar('snack')),
                    );
                  },
                  child:Row(

                    children: [
                      Text('Find a Food',
                        style: generalStyle,
                      ),
                      Icon(Icons.search)
                    ],
                  ),
                  color: Colors.amber,
                ),
              ),
            ],
          ),


        ],
      ),
    );;
  }
}
