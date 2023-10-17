// ignore: file_names
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final List<Color> gradientColor;
  final String title;
  final String subtitle;
  final String label;
  final IconData icon;

  const CustomCard({
    Key? key,
    required this.gradientColor,
    required this.title,
    required this.subtitle,
    required this.label,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cardsHeight;
    var cardsWidth;
    MediaQuery.of(context).size.width > 600
        ? cardsHeight = MediaQuery.of(context).size.height * 0.14 //max size
        : cardsWidth = MediaQuery.of(context).size.width * 0.3; //min size
    MediaQuery.of(context).size.width < 600
        ? cardsHeight = MediaQuery.of(context).size.height * 0.14 //min size
        : cardsWidth = MediaQuery.of(context).size.width * 0.22; //max size

    return Container(
      width: cardsWidth,
      height: cardsHeight,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColor,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: gradientColor.last.withOpacity(0.4),
            blurRadius: 8,
            spreadRadius: 2,
            offset: const Offset(4, 4),
          ),
        ],
        borderRadius: const BorderRadius.all(Radius.circular(24)),
      ),
      child: MediaQuery.of(context).size.width > 600
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        SizedBox(width: cardsWidth * 0.01),
                        Text(
                          label,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: cardsWidth * 0.06,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    Icon(
                      size: MediaQuery.of(context).size.width * 0.02,
                      icon,
                      color: Colors.white,
                    ),
                  ],
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: cardsWidth * 0.04,
                      fontWeight: FontWeight.w400),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: cardsWidth * 0.06,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        SizedBox(width: cardsWidth * 0.01),
                        Text(
                          label,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: cardsWidth * 0.07,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    Icon(
                      size: MediaQuery.of(context).size.width * 0.05,
                      icon,
                      color: Colors.white,
                    ),
                  ],
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: cardsWidth * 0.05,
                      fontWeight: FontWeight.w400),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: cardsWidth * 0.1,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
