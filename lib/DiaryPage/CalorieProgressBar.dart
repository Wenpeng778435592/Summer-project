import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:my_diet_diary/DataObjects/FoodEntry.dart';

class CalorieProgressBar extends StatefulWidget {
  final List<FoodEntry> breakfastFoods;
  final List<FoodEntry> lunchFoods;
  final List<FoodEntry> dinnerFoods;
  final List<FoodEntry> snackFoods;

  final double caloriesToday;
  final double targetCalories;

  @override
  State createState() => CalorieProgressBarState();

  const CalorieProgressBar(
      {Key key,
      this.breakfastFoods,
      this.lunchFoods,
      this.dinnerFoods,
      this.snackFoods,
      this.caloriesToday,
      this.targetCalories})
      : super(key: key);
}

class CalorieProgressBarState extends State<CalorieProgressBar> {
  _getCaloriesForMeal(List<FoodEntry> mealEntries) {
    double calories = 0;

    mealEntries.forEach((FoodEntry foodEntry) {
      calories += foodEntry.calories;
    });

    return calories;
  }

  Widget _getCalorieDifferenceText() {
    var color;
    var text;

    if (widget.targetCalories > widget.caloriesToday) {
      text = (widget.targetCalories - widget.caloriesToday).toInt().toString() + " kcal left";
      color = Colors.grey[500];
    } else {
      text = (widget.caloriesToday - widget.targetCalories).toInt().toString() + " kcal over";
      color = Colors.red[300];
    }

    return Text(text, style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal, color: color));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
        child: Stack(
          children: [
            CustomPaint(
              size: Size(300, 135),
              painter: ProgressArc(null, null, Colors.grey[300]),
            ),
            CustomPaint(
              size: Size(300, 135),
              painter: ProgressArc(
                  _getCaloriesForMeal(widget.breakfastFoods) +
                      _getCaloriesForMeal(widget.lunchFoods) +
                      _getCaloriesForMeal(widget.dinnerFoods) +
                      _getCaloriesForMeal(widget.snackFoods),
                  widget.targetCalories,
                  Colors.green[300]),
            ),
            CustomPaint(
              size: Size(300, 135),
              painter: ProgressArc(
                  _getCaloriesForMeal(widget.breakfastFoods) +
                      _getCaloriesForMeal(widget.lunchFoods) +
                      _getCaloriesForMeal(widget.dinnerFoods),
                  widget.targetCalories,
                  Colors.blue[300]),
            ),
            CustomPaint(
              size: Size(300, 135),
              painter: ProgressArc(_getCaloriesForMeal(widget.breakfastFoods) + _getCaloriesForMeal(widget.lunchFoods),
                  widget.targetCalories, Colors.yellow[300]),
            ),
            CustomPaint(
              size: Size(300, 135),
              painter: ProgressArc(_getCaloriesForMeal(widget.breakfastFoods), widget.targetCalories, Colors.red[300]),
            ),
            Positioned.fill(
                child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(10, 45, 15, 10),
                        child: Column(
                          children: [
                            RichText(
                                text: new TextSpan(
                                    style:
                                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                                    children: <TextSpan>[
                                  new TextSpan(
                                      text: widget.caloriesToday.toInt().toString(),
                                      style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                                  new TextSpan(
                                      text: " kcal", style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
                                ])),
                            _getCalorieDifferenceText()
                          ],
                        ))))
          ],
        ));
  }
}

class ProgressArc extends CustomPainter {
  bool isBackground;
  double calories;
  double targetCalories;
  Color progressColor;
  double arc;

  ProgressArc(double calories, double targetCalories, Color progressColor) {
    this.calories = calories;
    this.targetCalories = targetCalories;
    this.progressColor = progressColor;
    this.isBackground = isBackground;

    if (calories != null) {
      this.arc = (calories / targetCalories) * (math.pi - 0.4);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTRB(0, 0, 300, 300);
    final startAngle = -(math.pi - 0.2);
    final sweepAngle = (arc == null || arc > math.pi - 0.4) ? math.pi - 0.4 : arc;
    final userCenter = false;
    final paint = Paint()
      ..strokeCap = StrokeCap.round
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;

    canvas.drawArc(rect, startAngle, sweepAngle, userCenter, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
