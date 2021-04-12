import 'package:flutter/material.dart';
import 'package:my_diet_diary/DataObjects/DatabaseHelper.dart';
import 'package:my_diet_diary/DataObjects/FoodEntry.dart';

class CustomExpansionTile extends StatefulWidget {
  final String headerText;
  final Color color;
  final List<FoodEntry> meals;
  final StatefulWidget nextPage;

  @override
  State createState() => CustomExpansionTileState();

  const CustomExpansionTile({Key key, this.headerText, this.color, this.meals, this.nextPage}) : super(key: key);
}

class CustomExpansionTileState extends State<CustomExpansionTile> {
  static TextStyle generalStyle = TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey[800]);
  bool isExpanded = false;
  DatabaseHelper dbHelper = new DatabaseHelper();

  RichText _getDaySummaryText(List<FoodEntry> mealEntries) {
    var boldStyle = TextStyle(fontSize: 16, color: Colors.grey[600], fontWeight: FontWeight.bold);
    var normalStyle = TextStyle(fontSize: 16, color: Colors.grey[600]);

    double calories = 0;
    double protein = 0;

    mealEntries.forEach((FoodEntry foodEntry) {
      calories += foodEntry.calories;
      protein += foodEntry.protein;
    });

    return RichText(
        text: new TextSpan(style: normalStyle, children: <TextSpan>[
      new TextSpan(
        text: calories.toInt().toString(),
        style: boldStyle,
      ),
      new TextSpan(text: " kcal   "),
      new TextSpan(text: protein.toStringAsFixed(1) + "g", style: boldStyle),
      new TextSpan(text: " Protein")
    ]));
  }

  List<Column> _getListTiles(List<FoodEntry> foodEntries) {
    var boldStyle = TextStyle(fontSize: 18, color: Colors.grey[600], fontWeight: FontWeight.bold);
    var normalStyle = TextStyle(fontSize: 18, color: Colors.grey[600]);

    var boldSubtitleStyle = TextStyle(fontSize: 14, color: Colors.grey[600], fontWeight: FontWeight.bold);
    var normalSubtitleStyle = TextStyle(fontSize: 14, color: Colors.grey[600]);

    return foodEntries.map<Column>((FoodEntry foodEntry) {
      return Column(
        children: [
          Divider(),
          ListTile(
              title: RichText(
                  text: new TextSpan(style: normalStyle, children: <TextSpan>[
                new TextSpan(
                  text: foodEntry.name,
                  style: boldStyle,
                ),
                new TextSpan(text: "\n" + foodEntry.amount.toString(), style: normalStyle),
              ])),
              subtitle: Padding(
                padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: RichText(
                          text: new TextSpan(style: normalSubtitleStyle, children: <TextSpan>[
                        new TextSpan(text: foodEntry.calories.toInt().toString(), style: boldSubtitleStyle),
                        new TextSpan(text: " kcal")
                      ])),
                    ),
                    Expanded(
                      flex: 1,
                      child: RichText(
                          text: new TextSpan(style: normalSubtitleStyle, children: <TextSpan>[
                        new TextSpan(text: foodEntry.protein.toInt().toString() + "g", style: boldSubtitleStyle),
                        new TextSpan(text: " prot.")
                      ])),
                    ),
                    Expanded(
                      flex: 1,
                      child: RichText(
                          text: new TextSpan(style: normalSubtitleStyle, children: <TextSpan>[
                        new TextSpan(text: foodEntry.carbs.toInt().toString() + "g", style: boldSubtitleStyle),
                        new TextSpan(text: " carbs")
                      ])),
                    ),
                    Expanded(
                      flex: 1,
                      child: RichText(
                          text: new TextSpan(style: normalSubtitleStyle, children: <TextSpan>[
                        new TextSpan(text: foodEntry.calories.toInt().toString() + "g", style: boldSubtitleStyle),
                        new TextSpan(text: " fat")
                      ])),
                    ),
                    IconButton(
                        icon: Icon(Icons.delete, color: Colors.red[700], size: 24),
                        onPressed: () {
                          dbHelper.deleteFoodEntry(foodEntry.id);
                          foodEntries.remove(foodEntry);
                          setState(() {});

                          final snackBar = SnackBar(
                              content: Text(foodEntry.name + ' deleted', style: TextStyle(fontStyle: FontStyle.italic)),
                              action: SnackBarAction(
                                label: 'Undo',
                                onPressed: () {
                                  foodEntries.add(foodEntry);
                                  dbHelper.addFoodEntry(foodEntry);
                                  setState(() {});
                                },
                              ));

                          Scaffold.of(context).showSnackBar(snackBar);
                        })
                  ],
                ),
              )),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: EdgeInsets.fromLTRB(10, 10, 15, 10),
      leading: IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => widget.nextPage),
          );
        },
        icon: Icon(Icons.add, color: Colors.amber, size: 30),
      ),
      title: Container(
        child: Text(
          widget.headerText,
          style:
              TextStyle(color: isExpanded ? widget.color : Colors.grey[800], fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      onExpansionChanged: (bool expanding) => setState(() => this.isExpanded = expanding),
      subtitle: Padding(padding: EdgeInsets.fromLTRB(0, 8, 0, 0), child: _getDaySummaryText(widget.meals)),
      children: _getListTiles(widget.meals),
    );
  }
}
