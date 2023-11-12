// ignore: file_names
import 'package:bi_replicate/screen/dashboard_content/dashboard.dart';
import 'package:bi_replicate/utils/constants/responsive.dart';
import 'package:flutter/material.dart';
// import 'package:http/http.dart';

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
        ? cardsHeight = height * 0.066 //max size
        : cardsWidth = width * 0.1; //min size
    MediaQuery.of(context).size.width < 600
        ? cardsHeight = MediaQuery.of(context).size.height * 0.16 //min size
        : cardsWidth = MediaQuery.of(context).size.width * 0.16; //max size

    return Container(
      width: isDesktop ? width * 0.143 : width * 0.5,
      height: isDesktop ? height * 0.05 : height * 0.14,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColor,
          begin: Alignment.center,
          end: Alignment.centerRight,
        ),
        // boxShadow: [
        //   BoxShadow(
        //     color: gradientColor.last.withOpacity(0.4),
        //     blurRadius: 8,
        //     spreadRadius: 2,
        //     offset: const Offset(4, 4),
        //   ),
        // ],
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
                      fontSize: height * .018,
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
          height: MediaQuery.of(context).size.height * 0.006,
        ),
        Text(
          subtitle,
          style: TextStyle(
              color: Colors.white,
              fontSize: height * .015,
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
                  fontSize: height * .015,
                  fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ],
    );
  }

  Column cardDesktop(cardsWidth, bool isDesktop, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              size: MediaQuery.of(context).size.width * 0.015,
              icon,
              color: Colors.white,
            ),
            Row(
              children: <Widget>[
                SizedBox(width: cardsWidth * 0.01),
                Text(
                  "${label} : ",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: isDesktop ? cardsWidth * 0.055 : 24,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
            Row(
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
        ),
        // Text(
        //   subtitle,
        //   style: TextStyle(
        //       color: Colors.white,
        //       fontSize: cardsWidth * 0.07,
        //       fontWeight: FontWeight.w400),
        // ),
      ],
    );
  }
}
