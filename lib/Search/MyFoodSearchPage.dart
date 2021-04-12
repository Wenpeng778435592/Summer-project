import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_diet_diary/DataObjects/DatabaseHelper.dart';





class MyFoodSearchPage extends StatefulWidget {


  final String meal;
  MyFoodSearchPage(this.meal);
  @override
  _MyFoodSearchPageState createState() => _MyFoodSearchPageState();
}

class _MyFoodSearchPageState extends State<MyFoodSearchPage> {

  static const TextStyle generalStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const TextStyle labelStyle =
  TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  DatabaseHelper dbhelper = new DatabaseHelper();

  @override
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
              child: Text('My Food Search',
                style: generalStyle,),
            ),
            Positioned(
              right: 0,
              child: IconButton(
                icon: Icon(Icons.search),
                onPressed: (){
                  showSearch(context: context, delegate: MyFoodSearchPageTest());
                },
              ),
            ),
          ],
        ),
        backgroundColor: Colors.amber[800],
      ),

      body:
      FutureBuilder<List>(
        future: dbhelper.getMyFoods(),
        initialData: List(),
        builder: (context, snapshot){
          return snapshot.hasData
              ? ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (_, int position){
              final item = snapshot.data[position];
              return Card(
                child: ListTile(
                  title: Text(snapshot.data[position].name),
                ),
              );


            },
          )
              : Center(
            child: CircularProgressIndicator(),
          );
        },
      ),


    );
  }
}



class MyFoodSearchPageTest extends SearchDelegate {

  DatabaseHelper dbhelper = new DatabaseHelper();

  @override
  List<Widget> buildActions(BuildContext context) {
    //actions of appbar
    return[
    IconButton(
      icon: Icon(Icons.clear),
      onPressed: (){
        query = '';
      },
    ),

    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //leading part of appbar
    return IconButton(
      icon: Icon(Icons.arrow_back_ios_outlined),
      onPressed: (){
        close(context, null);
      },
    );

  }

  @override
  Widget buildResults(BuildContext context) {
    //show result based on the selection
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //show when someone searches for something
    return FutureBuilder<List>(
      future: dbhelper.getMyFoods(),
      initialData: List(),
      builder: (context, snapshot){
        return snapshot.hasData
            ? ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (_, int position){
            final item = snapshot.data[position];
            return Card(
              child: ListTile(
                title: Text(snapshot.data[position].name),
              ),
            );


          },
        )
            : Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
