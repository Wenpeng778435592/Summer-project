import 'package:firebase_database/firebase_database.dart';

import 'FoodItem.dart';

class FirebaseHelper{

  static DatabaseReference _dbReference;

  Future<DatabaseReference> get dbReference async {
    if (_dbReference == null) {
      print("initialise");
      _dbReference = FirebaseDatabase().reference().reference();;
    }
    return _dbReference;
  }

  Future<List<FoodItem>> searchForFood(String query) async{
    DatabaseReference dbReference = await this.dbReference;

    List<FoodItem> foodItems = new List();

    dbReference.once().then((DataSnapshot snapshot){
      List<dynamic> values = snapshot.value;
      values.forEach((value) {
        //Split short name in db by space, remove commas and split to lowercase
        List<String> splitName = value["Short_Food_Name"].toLowerCase()
            .replaceAll(",","").split(" ");

        //Split words in query
        List<String> splitQuery = query.replaceAll(",","").split(" ");

        //If every word in the search query matches a word in the db name, return
        if(splitQuery.every((word) => splitName.contains(word))){
          FoodItem foodItem = new FoodItem();
          foodItem.carbs = value["Carbs"];
          foodItem.fat = value["Fat"];
          foodItem.id = value["FoodID"];
          foodItem.protein = value["Protein"];
          foodItem.measure = value["Measure"];
          foodItem.energy = value["Energy"];
          foodItem.name = value["Short_Food_Name"];

          print(foodItem.toString());

          foodItems.add(foodItem);
        }
        });
    });

    return foodItems;
  }
}
