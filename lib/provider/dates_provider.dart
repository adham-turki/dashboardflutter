import 'package:flutter/material.dart';

class DatesProvider with ChangeNotifier {
  TextEditingController fromCont = TextEditingController();
  TextEditingController toCont = TextEditingController();

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
