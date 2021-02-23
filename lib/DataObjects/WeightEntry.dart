import 'package:intl/intl.dart';

class WeightEntry implements Comparable {
  int userID;
  double weight;
  DateTime date;

  WeightEntry(this.userID, this.weight, this.date);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'userID': userID,
      'weight': weight,
      'date': new DateFormat('yyyy-MM-dd').format(date),
    };

    return map;
  }

  WeightEntry.fromMap(Map<String, dynamic> map) {
    userID = map['userID'];
    weight = map['weight'];
    date = DateTime.parse(map['date']);
  }

  @override
  int compareTo(other) {
    if (this.date == null || other == null) {
      return null;
    }

    DateTime otherDate = other.date;

    if (date.isBefore(otherDate)) {
      return -1;
    }

    if (date.isAfter(otherDate)) {
      return 1;
    }

    if (date.isAtSameMomentAs(otherDate)) {
      return 0;
    }

    return null;
  }

  @override
  toString() {
    return weight.toString() + " " + new DateFormat('yyyy-MM-dd').format(date);
  }
}
