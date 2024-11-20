import 'package:bi_replicate/model/trans_type_constants.dart';
import 'package:flutter/material.dart';

final colorListDashboard = <Color>[
  const Color(0xff7e4fe4),
  const Color(0xfffd8236),
  const Color.fromRGBO(48, 66, 125, 1),
  const Color.fromARGB(218, 23, 107, 135),
  const Color.fromARGB(169, 255, 208, 150),
  const Color(0xFF558B2F), // Light Green
  Colors.teal,
];
final List<TransTypeConstants> constTransTypeList = [
  const TransTypeConstants(id: 0, description: "مردود مبيعات"), // Return Sales
  const TransTypeConstants(id: 1, description: "محذوفات"), // Deleted
  const TransTypeConstants(
      id: 2, description: "فتح جارور الكاش بدون مبيعات"), // Open Cash Drawer
  const TransTypeConstants(
      id: 3, description: "خصومات اضافية"), // Other Discounts
  const TransTypeConstants(
      id: 5, description: "تجاوزات الطلبيات"), // Orders Logs
  const TransTypeConstants(id: 6, description: "تصفير بيانات"), // Clear Data
  const TransTypeConstants(
      id: 7, description: "انقاص كمية"), // Decrease Quantities
  const TransTypeConstants(
      id: 8, description: "خصومات على السطر"), // Row Discount
];
