enum Meal{
  breakfast,
  lunch,
  dinner,
  snack
}

extension MealExtension on Meal{

  String get value{
    switch(this){
      case Meal.breakfast:
        return "breakfast";
      case Meal.lunch:
        return "lunch";
      case Meal.dinner:
        return "dinner";
      case Meal.snack:
        return "snack";
      default:
        return null;
    }
  }

}