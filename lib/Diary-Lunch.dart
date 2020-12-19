import 'package:flutter/material.dart';
import 'dart:async';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import "package:my_diet_diary/qr_view/scan_view.dart";
import "package:my_diet_diary/qr_view/page_search.dart";

class Lunch_Section extends StatefulWidget {
  @override
  _Lunch_SectionState createState() => _Lunch_SectionState();
}

class _Lunch_SectionState extends State<Lunch_Section> {

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
            Text('Lunch'),
            IconButton(
              icon:FaIcon(FontAwesomeIcons.barcode),
              onPressed: ()async {
                PermissionStatus _hasPermission = await Permission.camera.request();
                if(!_hasPermission.isGranted) return;
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ScanView()),
                );
              },
            ),
          ],
        ),
        backgroundColor:Colors.amber[800],
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(
            onPressed: (){},
            child:Text('Food Recent',
              style: generalStyle,
            ),
            color: Colors.amber,
          ),
          RaisedButton(
            onPressed: (){},
            child:Text('My Food Recipes',
              style: generalStyle,
            ),
            color: Colors.amber,
          ),
          RaisedButton(
            onPressed: (){
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => NeteaseSearchPage()),
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
        ],
      ),
    );
  }
}
