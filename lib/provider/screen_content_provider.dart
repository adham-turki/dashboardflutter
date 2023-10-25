import 'package:flutter/material.dart';

class ScreenContentProvider with ChangeNotifier {
  int _page = 0;
  String _title = "Dashboard";

  void setPage(int page, String title) {
    _page = page;
    _title = title;
    notifyListeners();
  }

  int getPage() {
    return _page;
  }

  String getTitle() {
    return _title;
  }
}
