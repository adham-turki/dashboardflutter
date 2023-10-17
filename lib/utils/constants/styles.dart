import 'package:flutter/material.dart';

fortyEight600TextStyle(color) {
  return TextStyle(
    height: 1,
    fontWeight: FontWeight.w600,
    fontSize: 48,
    color: color,
  );
}

twentyEight700TextStyle(color) {
  return TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 28,
    color: color,
  );
}

twentySix700TextStyle(color) {
  return TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 26,
    color: color,
  );
}

twentyFour500TextStyle(color) {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 24,
    color: color,
  );
}

twentyFour700TextStyle(color) {
  return TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 24,
    color: color,
  );
}

twentyTwo700TextStyle(color) {
  return TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 22,
    color: color,
  );
}

twenty600TextStyle(color) {
  return TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 20,
    color: color,
  );
}

twenty500TextStyle(color) {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 20,
    color: color,
  );
}

twenty400TextStyle(color) {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 20,
    color: color,
  );
}

nineteen600TextStyle(color) {
  return TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 19,
    color: color,
  );
}

nineteen400TextStyle(color) {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 19,
    color: color,
  );
}

eighteen400TextStyle(color) {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 18,
    color: color,
  );
}

eighteen500TextStyle(color) {
  return TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18,
    color: color,
  );
}

seventeen500TextStyle(color) {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 17,
    color: color,
  );
}

seventeen700TextStyle(color) {
  return TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 17,
    color: color,
  );
}

seventeen700ShadowsTextStyle(color) {
  return TextStyle(
    fontWeight: FontWeight.w700,
    shadows: const [
      BoxShadow(
        color: Colors.black,
        offset: Offset(0, 0),
        blurRadius: 3,
      ),
    ],
    fontSize: 17,
    color: color,
  );
}

seventeen400TextStyle(color) {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 17,
    color: color,
  );
}

sixteen400TextStyle(color) {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16,
    color: color,
  );
}

sixteen400ShadowsTextStyle(color) {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16,
    shadows: const [
      BoxShadow(
        color: Colors.black,
        offset: Offset(0, 0),
        blurRadius: 3,
      ),
    ],
    color: color,
  );
}

sixteen500TextStyle(color) {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 16,
    color: color,
  );
}

sixteen500UnderlineTextStyle(color) {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 16,
    color: color,
    decoration: TextDecoration.underline,
  );
}

sixteen600TextStyle(color) {
  return TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 16,
    color: color,
  );
}

fifteen400TextStyle(color, size) {
  return TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: size,
    color: color,
  );
}

fifteen400ShadowsTextStyle(color) {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 15,
    shadows: const [
      BoxShadow(
        color: Colors.black,
        offset: Offset(0, 0),
        blurRadius: 3,
      ),
    ],
    color: color,
  );
}

fifteen700TextStyle(color) {
  return TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 15,
    color: color,
  );
}

fourteen500TextStyle(color) {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 14,
    color: color,
  );
}

fourteen400TextStyle(color) {
  return TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 15,
    color: color,
  );
}

twelve400TextStyle(color) {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 12,
    color: color,
  );
}

eight400TextStyle(color) {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 8,
    color: color,
  );
}

// Widget blueButton({
//   width,
//   onPressed,
//   height,
//   borderRadius,
//   text,
//   textColor,
//   fontSize,
//   fontWeight,
// }) {
//   return ElevatedButton(
//     onPressed: onPressed,
//     style: ElevatedButton.styleFrom(
//       backgroundColor: const Color(0xFF10709e),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(borderRadius ?? 3),
//       ),
//       padding: EdgeInsets.zero,
//       fixedSize: Size(width ?? 25.0, height ?? 60.0),
//     ),
//     child: Container(
//       alignment: Alignment.center,
//       padding: const EdgeInsets.all(10),
//       child: Text(
//         maxLines: 1,
//         text.toString(),
//         style: TextStyle(
//           color: textColor ?? Colors.black,
//           fontSize: fontSize ?? 13,
//           fontWeight: fontWeight ?? FontWeight.bold,
//         ),
//       ),
//     ),
//   );
// }

const gridFooterStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
);

var borderDecoration = BoxDecoration(
  color: Color.fromARGB(77, 228, 228, 228),
  border: Border.all(color: Colors.black38),
  borderRadius: BorderRadius.circular(5),
);
