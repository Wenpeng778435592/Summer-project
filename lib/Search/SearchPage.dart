import 'dart:async';
import 'package:algolia/algolia.dart';
import 'package:my_diet_diary/AlgoliaApplication.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  SearchBar({Key key}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {

  static const TextStyle generalStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const TextStyle labelStyle =
  TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  final Algolia _algoliaApp = AlgoliaApplication.algolia;
  String _searchTerm;

  Future<List<AlgoliaObjectSnapshot>> _operation(String input) async {
    AlgoliaQuery query = _algoliaApp.instance.index("Food").search(input);
    AlgoliaQuerySnapshot querySnap = await query.getObjects();
    List<AlgoliaObjectSnapshot> results = querySnap.hits;
    return results;
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
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
                child: Text('Food Search',
                  style: generalStyle,),
              ),
            ],
          ),
          backgroundColor: Colors.amber[800],
        ),
        body: SingleChildScrollView(
          child: Column(
              children:<Widget>[
                TextField(
                    onChanged: (val) {
                      setState(() {
                        _searchTerm = val;
                      });
                    },
                    style: generalStyle,
                    decoration: new InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search ...',
                        hintStyle: TextStyle(color: Colors.black),
                        prefixIcon: const Icon(Icons.search, color: Colors.black
                        ))),
                StreamBuilder<List<AlgoliaObjectSnapshot>>(
                  stream: Stream.fromFuture(_operation(_searchTerm)),
                  builder: (context, snapshot) {
                    if(!snapshot.hasData) return Text("Start Typing", style: TextStyle(color: Colors.black ),);
                    else{
                      List<AlgoliaObjectSnapshot> currSearchStuff = snapshot.data;

                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting: return Container();
                        default:
                          if (snapshot.hasError)
                            return new Text('Error: ${snapshot.error}');
                          else
                            return CustomScrollView(shrinkWrap: true,
                              slivers: <Widget>[
                                SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                        ( context,  index) {
                                      return _searchTerm.length > 0 ? DisplaySearchResult(artDes: currSearchStuff[index].data["artShowDescription"], artistName: currSearchStuff[index].data["artistName"], genre: currSearchStuff[index].data["genre"],) :
                                      Container();

                                    },
                                    childCount: currSearchStuff.length ?? 0,
                                  ),
                                ),
                              ],
                            ); }}
                  },
                ),
              ]),
        ),
      ),
    );
  }

}

class DisplaySearchResult extends StatelessWidget {
  final String artDes;
  final String artistName;
  final String genre;

  DisplaySearchResult({Key key, this.artistName, this.artDes, this.genre}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        children: <Widget>[
          Text(artDes ?? "", style: TextStyle(color: Colors.black ),),
          Text(artistName ?? "", style: TextStyle(color: Colors.black ),),
          Text(genre ?? "", style: TextStyle(color: Colors.black ),),
          Divider(color: Colors.black,),
          SizedBox(height: 20)
        ]
    );
  }
}