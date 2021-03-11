class MyFoodEntry {
  num carbs;
  num fat;
  int id;
  int userID;
  num protein;
  num calories;
  num measure;
  String name;

  MyFoodEntry(this.userID, this.carbs, this.protein, this.fat,
      this.calories, this.name, this.measure);


  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'carbs': carbs,
      'protein': protein,
      'fat': fat,
      'calories': calories,
      'name': name,
      'id': id,
      'measure': measure,
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
    measure = map['measure'];
  }

  @override
  String toString() {
    return name;
  }
}
