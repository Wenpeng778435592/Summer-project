class WeightEntry {
  int id;
  int userID;
  int weight;

  WeightEntry(this.userID, this.weight);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'userID': userID,
      'weight': weight
    };
  }

  WeightEntry.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    userID = map['userID'];
    weight = map['weight'];
  }
}