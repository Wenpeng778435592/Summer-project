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

  FoodEntry(this.id, this.userID, this.carbs, this.protein, this.fat,
      this.calories, this.name, this.meal);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
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
    meal = map['meal'].value;
  }
}