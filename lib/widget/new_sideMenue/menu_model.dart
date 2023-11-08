import 'package:bi_replicate/widget/new_sideMenue/sub_menu_model.dart';
import 'package:flutter/material.dart';

class MenuModel {
  String title;
  IconData icon;
  bool isParent;
  int pageNumber;
  List<SubMenuModel> subMenuList;

  MenuModel({
    required this.title,
    required this.icon,
    required this.isParent,
    required this.pageNumber,
    required this.subMenuList,
  });
}
