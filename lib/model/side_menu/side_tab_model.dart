import 'package:bi_replicate/model/side_menu/side_sub_tab_model.dart';
import 'package:flutter/material.dart';

class SideTabModel {
  bool isParent;
  String text;
  int value;
  IconData icon;
  List<SideSubTabModel> subMenu;

  SideTabModel(
      {required this.isParent,
      required this.text,
      required this.value,
      required this.icon,
      required this.subMenu});
}
