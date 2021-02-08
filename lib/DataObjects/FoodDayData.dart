class FoodDayData {
  double calories;
  double carbs;
  double fat;
  double protein;

  FoodDayData(this.calories, this.carbs, this.fat, this.protein);

  String toString() {
    return this.calories.toString() +
        " " +
        this.carbs.toString() +
        " " +
        this.fat.toString() +
        " " +
        this.protein.toString();
  }
}
