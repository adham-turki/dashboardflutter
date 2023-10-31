// ignore: file_names
import 'package:bi_replicate/screen/dashboard_content/dashboard.dart';
import 'package:bi_replicate/utils/constants/responsive.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

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
    double width = 0;
    double height = 0;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    var cardsHeight;
    var cardsWidth;
    bool isDesktop = Responsive.isDesktop(context);
    width > 600
        ? cardsHeight = height * 0.14 //max size
        : cardsWidth = width * 0.165; //min size
    MediaQuery.of(context).size.width < 600
        ? cardsHeight = MediaQuery.of(context).size.height * 0.16 //min size
        : cardsWidth = MediaQuery.of(context).size.width * 0.16; //max size

    return Container(
      width: isDesktop ? cardsWidth : width * 0.5,
      height: isDesktop ? cardsHeight : height * 0.14,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColor,
          begin: Alignment.center,
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
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      child: isDesktop
          ? cardDesktop(cardsWidth, isDesktop, context)
          : cardMobile(cardsWidth, context),
    );
  }

  Column cardMobile(cardsWidth, BuildContext context) {
    return Column(
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
                      fontSize: height * .02,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
            Icon(
              size: MediaQuery.of(context).size.width * 0.04,
              icon,
              color: Colors.white,
            ),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.008,
        ),
        Text(
          subtitle,
          style: TextStyle(
              color: Colors.white,
              fontSize: height * .02,
              fontWeight: FontWeight.w400),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.008,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: height * .02,
                  fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ],
    );
  }

  Column cardDesktop(cardsWidth, bool isDesktop, BuildContext context) {
    return Column(
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
                      fontSize: isDesktop ? cardsWidth * 0.062 : 24,
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
              fontSize: cardsWidth * 0.07,
              fontWeight: FontWeight.w400),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: cardsWidth * 0.05,
                  fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ],
    );
  }
}
