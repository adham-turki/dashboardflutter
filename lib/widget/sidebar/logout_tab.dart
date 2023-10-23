import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../utils/constants/colors.dart';
import '../../utils/constants/responsive.dart';

class LogoutTab extends StatefulWidget {
  const LogoutTab({super.key});

  @override
  State<LogoutTab> createState() => _LogoutTabState();
}

class _LogoutTabState extends State<LogoutTab> {
  double width = 0;
  double height = 0;
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    bool isDesktop = Responsive.isDesktop(context);

    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: MouseRegion(
        onEnter: (event) {
          setState(() {
            isHovered = true;
          });
        },
        onExit: (event) {
          setState(() {
            isHovered = false;
          });
        },
        child: logoutTab(isDesktop),
      ),
    );
  }

  Container logoutTab(bool isDesktop) {
    return Container(
      decoration: BoxDecoration(
        color: getActiveColor(),
        border: Border(
          top: BorderSide(
            color: Colors.grey.withOpacity(0.3),
            width: 2,
          ),
        ),
      ),
      height: height * 0.06,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              textBaseline: TextBaseline.alphabetic,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  Icons.logout,
                  color: Colors.white,
                  size: isDesktop ? width * 0.014 : width * 0.05,
                ),
                SizedBox(
                  width: width * 0.005,
                ),
                Text(
                  "Logout",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isDesktop ? width * 0.01 : width * 0.045,
                  ),
                ),
              ],
            ),
            const SizedBox(),
          ],
        ),
      ),
    );
  }

  getActiveColor() {
    return isHovered ? hoverColor : primary;
  }
}
