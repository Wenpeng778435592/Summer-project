import 'package:firebase_database/firebase_database.dart';

class FoodItem{
  String carbs;
  String fat;
  String id;
  String protein;
  String energy;
  int measure;
  String name;

  toJson() {
    return {
      "Carbohydrate_available": carbs,
      "Fat":fat,
      "FoodID":id,
      "Protein":protein,
      "Measure":measure,
      "Energy":energy,
      "Short_Food_Name":name
    };
  }

  @override
  String toString() {
    return name;
  }
}