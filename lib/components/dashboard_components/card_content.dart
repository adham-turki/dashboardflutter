import 'package:bi_replicate/utils/constants/responsive.dart';
import 'package:flutter/material.dart';

import '../../utils/constants/colors.dart';

class CardContent extends StatefulWidget {
  final String title;
  final String value;
  final String? dates;
  // final Color color;
  final IconData icon;
  const CardContent({
    super.key,
    required this.title,
    required this.value,
    this.dates,
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
    String dates = widget.dates ?? "";

    bool isMobile = Responsive.isMobile(context);
    return Column(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              isMobile
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          if (dates.isNotEmpty)
                            Text(
                              dates,
                              style: const TextStyle(fontSize: 10),
                            ),
                        ],
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(fontSize: 18),
                        ),
                        if (dates.isNotEmpty)
                          Text(
                            dates,
                            style: const TextStyle(fontSize: 16),
                          ),
                      ],
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                        fontSize: isMobile ? 15 : 25,
                        fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    icon,
                    color: primary,
                    size: isMobile ? 25 : 50,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
