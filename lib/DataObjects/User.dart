class User {
  int id;
  String name;
  int height;
  int weight;
  int age;
  String gender;
  int targetWeight;
  String goal;
  String activityLevel;
  int calorieGoal;

  User();

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'height': height,
      'weight': weight,
      'age': age,
      'goal': goal,
      'name': name,
      'gender':gender,
      'calorieGoal': calorieGoal,
      'activityLevel': activityLevel,
      'targetWeight': targetWeight,
      'id': id
    };
    return map;
  }

  User.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    weight = map['weight'];
    age = map['age'];
    goal = map['goal'];
    name = map['name'];
    calorieGoal = map['calorieGoal'];
    activityLevel = map['activityLevel'];
    targetWeight = map['targetWeight'];
    height = map['height'];
    gender = map['gender'];
  }
}