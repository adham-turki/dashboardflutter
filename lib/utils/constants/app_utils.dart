import 'package:flutter/material.dart';

import 'colors.dart';

class Components {
  Widget blueButton({
    width,
    onPressed,
    height,
    borderRadius,
    text,
    textColor,
    fontSize,
    fontWeight,
    Icon? icon, // New parameter for the icon
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 3),
        ),
        padding: EdgeInsets.zero,
        fixedSize: Size(width ?? 25.0, height ?? 60.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) icon, // Display the icon if provided
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: Text(
              // maxLines: 2,
              textAlign: TextAlign.center,
              text.toString(),
              style: TextStyle(
                color: textColor ?? Colors.black,
                fontSize: fontSize ?? 13,
                fontWeight: fontWeight ?? FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget blueButton1({
  required VoidCallback onPressed,
  required Color textColor,
  required Icon icon,
}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      boxShadow: const [
        BoxShadow(
          color: Color.fromRGBO(82, 151, 176, 0.2),
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Material(
      color: const Color.fromRGBO(82, 151, 176, 1),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(12),
          child: icon,
        ),
      ),
    ),
  );
}