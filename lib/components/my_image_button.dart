import 'package:flutter/material.dart';

class MyImageButton extends StatelessWidget {
  final String imagePath;
  final VoidCallback onPressed;

  MyImageButton({required this.imagePath, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Image.asset(
        imagePath,
        width: 50.0,
        height: 100.0,
      ),
    );
  }
}
