
class FoodEntry {
  int id;
  int userID;
  num carbs;
  num protein;
  num fat;
  num calories;
  String name;
  String date;
  String meal;
  num amount;

  FoodEntry(this.userID, this.carbs, this.protein, this.fat,
      this.calories, this.name, this.meal, this.date, this.amount);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'userID': userID,
      'carbs': carbs,
      'protein': protein,
      'fat': fat,
      'calories': calories,
      'name': name,
      'date':date,
      'meal': meal,
      'id': id,
      'amount': amount,
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
    amount = map['amount'];
    meal = map['meal'];
  }

  String toString(){
    return this.name + " " + this.date + " " + this.meal;
  }
}