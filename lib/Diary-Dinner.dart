import 'package:flutter/material.dart';
import 'dart:async';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_diet_diary/qr_view/BarcodeScanPage.dart';
import 'package:permission_handler/permission_handler.dart';
import "package:my_diet_diary/qr_view/scan_view.dart";
import 'package:my_diet_diary/Search/SearchPage.dart';
import 'package:my_diet_diary/Search/MyFoodSearchPage.dart';

class Dinner_Section extends StatefulWidget {
  @override
  _Dinner_SectionState createState() => _Dinner_SectionState();
}

class _Dinner_SectionState extends State<Dinner_Section> {

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
            Text('Dinner'),
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
                      MaterialPageRoute(builder: (context) => MyFoodSearchBar('dinner')),
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
                      MaterialPageRoute(builder: (context) => SearchBar('dinner')),
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
    );
  }
}
