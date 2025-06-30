import 'package:flutter/material.dart';

class DatesProvider with ChangeNotifier {
  TextEditingController fromCont = TextEditingController();
  TextEditingController toCont = TextEditingController();
  bool dayTemp = true;
  bool monthTemp = true;
  bool yearTemp = true;
  String sessionFromDate = "";
  String sessionToDate = "";
  VoidCallback? onDatesChanged;

  setSessionFromDate(String value) {
    sessionFromDate = value;
    // notifyListeners();
  }

  setSessionToDate(String value) {
    sessionToDate = value;
    // notifyListeners();
  }

  void triggerDateChange() {
    onDatesChanged?.call();
  }

  notify() {
    notifyListeners();
  }

  setDayTemp(bool temp) {
    dayTemp = temp;
    notifyListeners();
  }

  getDayTemp() {
    return dayTemp;
  }

  setMonthTemp(bool temp) {
    monthTemp = temp;
    notifyListeners();
  }

  getMonthTemp() {
    return monthTemp;
  }

  setYearTemp(bool temp) {
    yearTemp = temp;
    notifyListeners();
  }

  getYearTemp() {
    return yearTemp;
  }

  void setDatesController(TextEditingController fromController,
      TextEditingController toController) {
    fromCont = fromController;
    toCont = toController;
    notifyListeners();
  }

  TextEditingController getFromCont() {
    return fromCont;
  }

  TextEditingController getToCont() {
    return toCont;
  }
}
