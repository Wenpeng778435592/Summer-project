import 'Meal.dart';

class FoodEntry {
  int id;
  int userID;
  int carbs;
  int protein;
  int fat;
  int calories;
  String name;
  String date;
  Meal meal;

  FoodEntry(this.userID, this.carbs, this.protein, this.fat,
      this.calories, this.name, this.meal, this.date);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'userID': userID,
      'carbs': carbs,
      'protein': protein,
      'fat': fat,
      'calories': calories,
      'name': name,
      'date':date,
      'meal': meal.value
    };
    return map;
  }

  FoodEntry.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    userID = map['userID'];
    carbs = map['carbs'];
    protein = map['protein'];
    fat = map['fat'];
    calories = map['calories'];
    name = map['name'];
    date = map['date'];
    meal = Meal.values.firstWhere((e) => e.toString() == 'Meal.' + map['meal']);
  }

  String toString(){
    return this.name + " " + this.date;
  }
}