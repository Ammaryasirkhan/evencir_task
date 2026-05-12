import 'package:flutter/foundation.dart';

class NutritionController extends ChangeNotifier {
  NutritionController() {
    _selectedDate = _stripTime(DateTime.now());
    _weekDates = _buildWeek(_selectedDate);
  }

  late DateTime _selectedDate;
  late List<DateTime> _weekDates;

  DateTime get selectedDate => _selectedDate;
  List<DateTime> get weekDates => _weekDates;
  int get selectedWeekOfMonth => _weekOfMonth(_selectedDate);
  int get totalWeeksInSelectedMonth => _totalWeeksInMonth(_selectedDate);

  NutritionInsights get insights => NutritionInsights.fromDate(_selectedDate);

  void selectDate(DateTime date) {
    final DateTime normalized = _stripTime(date);
    _selectedDate = normalized;
    _weekDates = _buildWeek(normalized);
    notifyListeners();
  }

  static DateTime _stripTime(DateTime d) => DateTime(d.year, d.month, d.day);

  static List<DateTime> _buildWeek(DateTime anchor) {
    final int diffToMonday = anchor.weekday - DateTime.monday;
    final DateTime monday = anchor.subtract(Duration(days: diffToMonday));
    return List.generate(7, (index) => monday.add(Duration(days: index)));
  }

  static int _weekOfMonth(DateTime date) {
    final DateTime first = DateTime(date.year, date.month, 1);
    final int mondayBasedOffset = first.weekday - DateTime.monday;
    return ((date.day + mondayBasedOffset - 1) ~/ 7) + 1;
  }

  static int _totalWeeksInMonth(DateTime date) {
    final DateTime first = DateTime(date.year, date.month, 1);
    final DateTime nextMonth =
        date.month == 12 ? DateTime(date.year + 1, 1, 1) : DateTime(date.year, date.month + 1, 1);
    final int daysInMonth = nextMonth.subtract(const Duration(days: 1)).day;
    final int mondayBasedOffset = first.weekday - DateTime.monday;
    return ((daysInMonth + mondayBasedOffset - 1) ~/ 7) + 1;
  }
}

class NutritionInsights {
  const NutritionInsights({
    required this.calories,
    required this.goal,
    required this.weightKg,
    required this.weightDelta,
    required this.hydrationPercent,
    required this.hydrationMl,
    required this.hydrationTargetMl,
    required this.workoutTitle,
    required this.workoutMin,
  });

  final int calories;
  final int goal;
  final double weightKg;
  final double weightDelta;
  final int hydrationPercent;
  final int hydrationMl;
  final int hydrationTargetMl;
  final String workoutTitle;
  final int workoutMin;

  int get remaining => (goal - calories).clamp(0, goal);
  double get calorieProgress => goal == 0 ? 0 : (calories / goal).clamp(0, 1);

  static NutritionInsights fromDate(DateTime date) {
    final int seed = date.year * 10000 + date.month * 100 + date.day;
    final int calories = 420 + (seed % 520);
    final int goal = 2200 + (seed % 500);
    final double weightKg = 68 + ((seed % 90) / 10);
    final double weightDelta = ((seed % 31) - 15) / 10;
    final int hydrationTarget = 2000;
    final int hydrationMl = (seed * 37) % hydrationTarget;
    final int hydrationPercent = ((hydrationMl / hydrationTarget) * 100).round();

    const workouts = ['Upper Body', 'Mobility Flow', 'Core Focus', 'Leg Strength'];
    final String workout = workouts[seed % workouts.length];
    final int duration = 20 + (seed % 21);

    return NutritionInsights(
      calories: calories,
      goal: goal,
      weightKg: double.parse(weightKg.toStringAsFixed(1)),
      weightDelta: double.parse(weightDelta.toStringAsFixed(1)),
      hydrationPercent: hydrationPercent,
      hydrationMl: hydrationMl,
      hydrationTargetMl: hydrationTarget,
      workoutTitle: workout,
      workoutMin: duration,
    );
  }
}
