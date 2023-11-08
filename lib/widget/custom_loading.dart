import 'package:flutter/material.dart';

class CustomLoading extends StatelessWidget {
  CustomLoading({super.key});

  double _width = 0;
  double _height = 0;

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;

    return SizedBox(
      width: _width * 0.2,
      height: _height * 0.2,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
