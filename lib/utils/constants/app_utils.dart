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
