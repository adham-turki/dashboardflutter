import 'package:bi_replicate/utils/constants/colors.dart';
import 'package:bi_replicate/utils/constants/responsive.dart';
import 'package:flutter/material.dart';

class LogoSection extends StatelessWidget {
  LogoSection({super.key});

  double width = 0;
  double height = 0;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Container(
      height: height * 0.08,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              "assets/images/scope_logo1.png",
              width: Responsive.isDesktop(context) ? width * 0.1 : width * 0.2,
            ),
            Icon(
              Icons.dashboard,
              size: Responsive.isDesktop(context) ? width * 0.02 : width * 0.04,
              color: primary,
            ),
          ],
        ),
      ),
    );
  }
}
