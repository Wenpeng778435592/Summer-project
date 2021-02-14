class MyFoodEntry {
  num carbs;
  num fat;
  int id;
  int userID;
  num protein;
  num calories;
  num amount;
  String name;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'carbs': carbs,
      'protein': protein,
      'fat': fat,
      'calories': calories,
      'name': name,
      'id': id,
      'amount': amount,
      'userID': userID
    };
    return map;
  }

  MyFoodEntry.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    userID = map['userID'];
    carbs = map['carbs'];
    protein = map['protein'];
    fat = map['fat'];
    calories = map['calories'];
    name = map['name'];
    amount = map['amount'];
  }

  @override
  String toString() {
    return name;
  }
}
