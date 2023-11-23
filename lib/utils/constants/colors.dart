import 'package:flutter/material.dart';

const primary = Color(0xFF5297b0);
const secondary = Color(0xFFbaa095);
const colColor = Color(0xFF5297b0);
const gridActiveColor = Color.fromARGB(169, 255, 208, 150);
const whiteColor = Colors.white;
const darkBlueColor = Color(0xFF2b4381);
ButtonStyle greenStyle(Size size, double fontSize) {
  return ElevatedButton.styleFrom(
      backgroundColor: primary,
      fixedSize: size,
      textStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold));
}

ButtonStyle cancelStyle(Size size, double fontSize) {
  return ElevatedButton.styleFrom(
      backgroundColor: Color.fromARGB(255, 206, 63, 63),
      textStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
      fixedSize: size,
      alignment: Alignment.center);
}

ButtonStyle blackStyle(Size size, double fontSize) {
  return ElevatedButton.styleFrom(
      backgroundColor: secondary,
      textStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
      fixedSize: size,
      alignment: Alignment.center);
}

final colorNewList = <Color>[
  Colors.green,
  const Color(0xFF2196F3),
  Colors.red,
  Colors.orange,
  Colors.purple,
  Colors.teal,
  Colors.deepPurple,
  Colors.lime,
  Colors.indigo,
  Colors.purpleAccent, Colors.redAccent,
  Colors.blueAccent,
  Colors.greenAccent,
  Colors.orangeAccent,
  Colors.tealAccent,
  Colors.pinkAccent,
  Colors.amberAccent,
  Colors.cyanAccent,
  Colors.brown,
  const Color(0xFF1A237E), // Dark Blue
  const Color(0xFF880E4F), // Dark Pink
  const Color(0xFF3E2723), // Dark Brown
  const Color(0xFF004D40), // Dark Green
  const Color(0xFF3E2723), // Dark Brown
  const Color(0xFF263238), // Dark Blue Grey
  const Color(0xFF880E4F), // Dark Pink
  const Color(0xFF5D4037), // Dark Brown
  const Color(0xFFFF5722), // Deep Orange
  const Color(0xFF673AB7), // Deep Purple
  const Color(0xFF795548), // Brown
  const Color(0xFF3F51B5), // Indigo
  const Color(0xFFFBC02D), // Yellow
  const Color(0xFF4A148C), // Indigo
  const Color(0xFF006064), // Cyan
  const Color(0xFFD84315), // Deep Orange
  const Color(0xFF311B92), // Indigo
  const Color(0xFF558B2F), // Light Green
  const Color(0xFF1B5E20), // Green
  const Color(0xFFBF360C), // Deep Orange
  const Color(0xFF01579B), // Light Blue
  const Color(0xFF33691E), // Green
  const Color(0xFF1976D2), // Blue
  const Color(0xFF827717), // Lime
  const Color(0xFFD81B60), // Pink
  const Color(0xFF827717), // Lime
];

final colorListDashboard = <Color>[
  const Color(0xff7e4fe4),
  const Color(0xfffd8236),
  const Color.fromRGBO(48, 66, 125, 1),
  const Color.fromARGB(218, 23, 107, 135),
  const Color.fromARGB(169, 255, 208, 150),
  const Color(0xFF558B2F), // Light Green
  Colors.teal,
];
Color hoverColor = const Color.fromRGBO(30, 36, 48, 1);
