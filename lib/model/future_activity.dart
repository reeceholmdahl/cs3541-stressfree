import 'package:firstapp/model/planned_activity.dart';

import 'activity.dart';

class FutureActivity extends PlannedActivity {
  final Recurrence recurrence;
  bool isHidden = false;
  bool get isToday => recurrence.isToday();

  FutureActivity(Activity activity, this.recurrence)
      : super(activity.name, activity.category);
}

class Recurrence {
  final DateTime startDate;
  final DateTime? endDate;
  final bool isOnce, isDaily, isWeekly, isMonthly, isYearly;
  final List<bool> weeklyDays =
      List.generate(8, (index) => false, growable: false);

  Recurrence(
      {required this.startDate,
      this.endDate,
      this.isOnce = false,
      this.isDaily = false,
      this.isWeekly = false,
      this.isMonthly = false,
      this.isYearly = false}) {
    assert(isOnce || isDaily || isWeekly || isMonthly || isYearly);
  }

  static Recurrence once({required DateTime date}) {
    return Recurrence(startDate: date, isOnce: true);
  }

  static Recurrence daily({required DateTime startDate, DateTime? endDate}) {
    return Recurrence(startDate: startDate, endDate: endDate, isDaily: true);
  }

  static Recurrence weekly({
    required DateTime startDate,
    DateTime? endDate,
    bool everyday = false,
    bool monday = false,
    bool tuesday = false,
    bool wednesday = false,
    bool thursday = false,
    bool friday = false,
    bool saturday = false,
    bool sunday = false,
  }) {
    final r = Recurrence(startDate: startDate, isWeekly: true);

    if (everyday) {
      r.weeklyDays.setAll(0, List.generate(8, (index) => false));
    } else {
      if (monday) {
        r.weeklyDays[1] = true;
      }

      if (tuesday) {
        r.weeklyDays[2] = true;
      }

      if (wednesday) {
        r.weeklyDays[3] = true;
      }

      if (thursday) {
        r.weeklyDays[4] = true;
      }

      if (friday) {
        r.weeklyDays[5] = true;
      }

      if (saturday) {
        r.weeklyDays[6] = true;
      }

      if (sunday) {
        r.weeklyDays[7] = true;
      }

      // TODO Investigate if this is necessary
      // r.weeklyDays[startDate.weekday] = true;
    }

    return r;
  }

  static Recurrence monthly({required DateTime startDate, DateTime? endDate}) {
    return Recurrence(startDate: startDate, endDate: endDate, isMonthly: true);
  }

  static Recurrence yearly({required DateTime startDate, DateTime? endDate}) {
    return Recurrence(startDate: startDate, endDate: endDate, isYearly: true);
  }

  bool isToday() {
    final now = DateTime.now();

    if (endDate?.isAfter(now) ?? true) {
      if (isOnce) {
        return now.day == startDate.day &&
            now.month == startDate.month &&
            now.year == startDate.year;
      } else if (isDaily) {
        return true;
      } else if (isWeekly) {
        return weeklyDays[now.weekday];
      } else if (isMonthly) {
        return now.day == startDate.day;
      } else if (isYearly) {
        return now.day == startDate.day && now.month == startDate.month;
      } else {
        assert(false);
      }
    }

    return false;
  }

  String toString() {
    return 'is once: $isOnce is daily: $isDaily is weekly: $isWeekly is monthly $isMonthly is yearly $isYearly start date $startDate end date $endDate week days ${weeklyDays.toString()}';
  }
}
