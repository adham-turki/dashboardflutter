import 'package:bi_replicate/utils/constants/colors.dart';
import 'package:bi_replicate/provider/screen_content_provider.dart';
import 'package:bi_replicate/utils/constants/responsive.dart';
import 'package:bi_replicate/widget/sidebar/tab_menu.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../utils/constants/menu.dart';
import '../widget/sidebar/logo_section.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  double width = 0;
  double height = 0;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Container(
      width: Responsive.isDesktop(context) ? width * 0.165 : width * 0.65,
      height: height,
      decoration: BoxDecoration(
        color: primary,
        boxShadow: [
          BoxShadow(
            spreadRadius: 1,
            blurRadius: 10,
            color: Responsive.isDesktop(context)
                ? const Color.fromARGB(155, 218, 218, 218)
                : Colors.transparent,
          ),
        ],
      ),
      child: Column(
        children: [
          sectionLogo(),
          Expanded(
            child: SingleChildScrollView(
              child: Consumer<ScreenContentProvider>(
                builder: (context, value, child) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          for (int i = 0; i < menuList.length - 2; i++)
                            TabMenu(sideTabModel: menuList[i]),
                        ],
                      ),
                      Column(
                        children: [
                          for (int i = menuList.length - 2;
                              i < menuList.length;
                              i++)
                            TabMenu(sideTabModel: menuList[i]),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column sectionLogo() {
    return Column(
      children: [
        LogoSection(),
        const Divider(),
      ],
    );
  }
}
