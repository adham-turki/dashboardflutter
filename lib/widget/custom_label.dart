import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomLabel extends StatelessWidget {
  String label;
  double width;
  CustomLabel({
    Key? key,
    required this.label,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double rowWidth = width;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: rowWidth,
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
            ),
          ],
        ),
      ),
    );
  }
}
