import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  Function onPressed;
  FilterButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onPressed();
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Color(0xFFC6C2DE),
        backgroundColor: Colors.white, // text color
        side: const BorderSide(color: Color(0xFFC6C2DE)), // border color
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.search, color: Color(0xFF8B83BA)),
          SizedBox(width: 8), // Add some space between icon and text
          Text(
            'Search',
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
