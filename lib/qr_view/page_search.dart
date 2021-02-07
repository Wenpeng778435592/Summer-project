import 'package:flutter/material.dart';
import 'package:my_diet_diary/Search/Add_Item.dart';


class NeteaseSearchPage extends StatefulWidget {

  const NeteaseSearchPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _NeteaseSearchPageState();
  }
}

class _NeteaseSearchPageState extends State<NeteaseSearchPage> {
  final TextEditingController _queryTextController = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  String get query => _queryTextController.text;

  set query(String value) {
    assert(value != null);
    _queryTextController.text = value;
  }

  ///the query of [_SearchResultPage]
  String _searchedQuery = "";

  bool initialState = true;

  @override
  void initState() {
    super.initState();
    _queryTextController.addListener(_onQueryTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _queryTextController.removeListener(_onQueryTextChanged);
    _focusNode.removeListener(_onFocusChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.amber[800],
        title: TextField(
          controller: _queryTextController,
          focusNode: _focusNode,
          textInputAction: TextInputAction.search,
          onSubmitted: (String _) => _search(query),
          decoration: InputDecoration(
              fillColor: Colors.white,
              border: InputBorder.none,
              filled: true,
              hintText: MaterialLocalizations.of(context).searchFieldLabel),
        ),
        actions: buildActions(context),
      ),
      resizeToAvoidBottomInset: false,
      body:SizedBox(),
    );
  }

  ///start search for keyword
  void _search(String query) {
    if (query.isEmpty) {
      return;
    }
    _focusNode.unfocus();
    setState(() {
      initialState = false;
      _searchedQuery = query;
      this.query = query;
    });
  }

  void _onQueryTextChanged() {
    setState(() {
      // rebuild ourselves because query changed.
    });
  }

  void _onAnimationStatusChanged(AnimationStatus status) {
    if (status != AnimationStatus.completed) {
      return;
    }
    //we need request focus on text field when first in
    FocusScope.of(context).requestFocus(_focusNode);
  }

  void _onFocusChanged() {
    setState(() {

    });
  }

  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      GestureDetector(
        onTap: (){
          Navigator.pop(context);
        },
        child: Container(
    // height: 100,
    // width: 80,
    child:Column(
    mainAxisAlignment:MainAxisAlignment.center,
      children: [
        RaisedButton(
          child: Text("Submit"),
            onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddItem_Section()));
            }),

    ],)),
      )
      // query.isEmpty
      //     ? null
      //     : IconButton(
      //         tooltip: 'Clear',
      //         icon: const Icon(Icons.clear),
      //         onPressed: () {
      //           query = '';
      //         },
      //       )
    ]..removeWhere((v) => v == null);
  }

}


