import 'package:intl/intl.dart';

class DatesController {
  DateTime today = DateTime.now();
  String todayDate() {
    final DateFormat dateFormatter = DateFormat("yyyy-MM-dd");
    return dateFormatter.format(today);
  }

  String currentWeek() {
    int daysUntilFirstDay = (today.weekday + 2) - DateTime.monday;
    DateTime firstDayCurrentWeek =
        today.subtract(Duration(days: daysUntilFirstDay));
    final DateFormat dateFormatter = DateFormat("yyyy-MM-dd");
    return dateFormatter.format(firstDayCurrentWeek);
  }

  String currentMonth() {
    DateTime firstDayCurrentMonth = DateTime(today.year, today.month, 1);
    final DateFormat dateFormatter = DateFormat("yyyy-MM-dd");
    return dateFormatter.format(firstDayCurrentMonth);
  }

  String currentYear() {
    DateTime firstDayOfYear = DateTime(today.year, 1, 1);
    final DateFormat dateFormatter = DateFormat("yyyy-MM-dd");
    return dateFormatter.format(firstDayOfYear);
  }

  formatDate(String date) {
    if (date == "null") {
      return "";
    } else {
      try {
        DateTime dateTime = DateFormat("yyyy-MM-dd").parse(date);
        String newDate = DateFormat("dd-MM-yyyy").format(dateTime).toString();
        return newDate;
      } catch (e) {
        return "null";
      }
    }
  }

  formatDateReverse(String date) {
    if (date == "null") {
      return "";
    } else {
      try {
        DateTime dateTime = DateFormat("dd-MM-yyyy").parse(date);
        String newDate = DateFormat("yyyy-MM-dd").format(dateTime).toString();
        return newDate;
      } catch (e) {
        return "null";
      }
    }
  }

  formatDateReverse1(String date) {
    if (date == "null") {
      return "";
    } else {
      try {
        DateTime dateTime = DateFormat("dd-MM-yyyy").parse(date);
        String newDate = DateFormat("dd-MM-yyyy").format(dateTime).toString();
        return newDate;
      } catch (e) {
        return "null";
      }
    }
  }
  // @override
  // String toString() {
  //   String y = _fourDigits(year);
  //   String m = _twoDigits(month);
  //   String d = _twoDigits(day);
  //   String h = _twoDigits(hour);
  //   String min = _twoDigits(minute);
  //   String sec = _twoDigits(second);
  //   String ms = _threeDigits(millisecond);
  //   String us = microsecond == 0 ? "" : _threeDigits(microsecond);
  //   if (isUtc) {
  //     return "$y-$m-$d $h:$min:$sec.$ms${us}Z";
  //   } else {
  //     return "$y-$m-$d $h:$min:$sec.$ms$us";
  //   }
  // }
}
