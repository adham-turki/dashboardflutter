import 'package:bi_replicate/utils/constants/responsive.dart';
import 'package:flutter/material.dart';

class CardContent extends StatefulWidget {
  final String title;
  final String value;
  // final Color color;
  final IconData icon;
  const CardContent({
    super.key,
    required this.title,
    required this.value,
    // required this.color,
    required this.icon,
  });

  @override
  State<CardContent> createState() => _CardContentState();
}

class _CardContentState extends State<CardContent> {
  double radius = 5;
  @override
  Widget build(BuildContext context) {
    String title = widget.title;
    String value = widget.value;
    IconData icon = widget.icon;
    bool isMobile = Responsive.isMobile(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            title,
            style: TextStyle(fontSize: isMobile ? 12 : 18),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 14 : 28.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: TextStyle(
                      fontSize: isMobile ? 12 : 25,
                      fontWeight: FontWeight.bold),
                ),
                Icon(
                  icon,
                  size: isMobile ? 20 : 50,
                ),
              ],
            ),
          ),
        ),
        // Container(
        //   height: 15,
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.only(
        //         bottomLeft: Radius.circular(radius),
        //         bottomRight: Radius.circular(radius)),
        //     color: color,
        //   ),
        // ),
      ],
    );
  }
}
