import 'package:bi_replicate/utils/constants/colors.dart';
import 'package:bi_replicate/model/side_menu/side_sub_tab_model.dart';
import 'package:bi_replicate/model/side_menu/side_tab_model.dart';
import 'package:bi_replicate/provider/screen_content_provider.dart';
import 'package:bi_replicate/utils/constants/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';

class TabMenu extends StatefulWidget {
  final SideTabModel sideTabModel;
  const TabMenu({
    super.key,
    required this.sideTabModel,
  });

  @override
  State<TabMenu> createState() => _TabMenuState();
}

class _TabMenuState extends State<TabMenu> {
  double width = 0;
  double height = 0;

  Color hoverColor = const Color.fromRGBO(30, 36, 48, 1);
  Color subMenuColor = const Color.fromRGBO(35, 44, 57, 1);

  bool isHovered = false;
  bool isSelected = false;

  int subHovered = -1;
  int subSelected = 0;

  int duration = 100;

  //For the animation of the container sub menu
  bool isFinishSelect = false;

  late ScreenContentProvider provider;

  bool isDesktop = false;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    SideTabModel sideTabModel = widget.sideTabModel;
    List<SideSubTabModel> subMenu = sideTabModel.subMenu;
    bool isParent = sideTabModel.isParent;

    provider = context.read<ScreenContentProvider>();
    isDesktop = Responsive.isDesktop(context);
    return InkWell(
      onTap: () {
        setState(() {
          //To check container change animation
          isFinishSelect ? isFinishSelect = false : null;

          if (sideTabModel.isParent) {
            int firstPage = sideTabModel.subMenu[0].value;
            // String title = sideTabModel.subMenu[0].text;
            subSelected = firstPage;
            isSelected ? isSelected = false : isSelected = true;
            // provider.setPage(firstPage, title);
          } else {
            int page = sideTabModel.value;
            String title = sideTabModel.text;
            // subSelected = page;
            // isSelected ? isSelected = false : isSelected = true;

            provider.setPage(page, title);
          }
        });
      },
      child: Column(
        children: [
          Container(
            color: activeTabColor(),
            child: mainTabText(sideTabModel),
          ),
          isParent
              ? AnimatedContainer(
                  duration: Duration(milliseconds: duration),
                  onEnd: () {
                    setState(() {
                      isFinishSelect = true;
                    });
                  },
                  width: isDesktop ? width * 0.2 : width * 0.65,
                  height: getDynamicHeight(sideTabModel),
                  color: subMenuColor,
                  child: isFinishSelect
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (int i = 0; i < subMenu.length; i++)
                              subMenuText(subMenu[i]),
                          ],
                        )
                      : Container(),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget mainTabText(SideTabModel sideTabModel) {
    bool isParent = sideTabModel.isParent;
    IconData icon = sideTabModel.icon;
    String title = sideTabModel.text;

    return MouseRegion(
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
      child: SizedBox(
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
                    icon,
                    color: Colors.white,
                    size: isDesktop ? width * 0.014 : width * 0.05,
                  ),
                  SizedBox(
                    width: width * 0.005,
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isDesktop ? width * 0.01 : width * 0.045,
                    ),
                  ),
                ],
              ),
              isParent
                  ? isSelected
                      ? const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Colors.white,
                        )
                      : const Icon(
                          Icons.keyboard_arrow_right_rounded,
                          color: Colors.white,
                        )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget subMenuText(SideSubTabModel sideSubTabModel) {
    String text = sideSubTabModel.text;
    int index = sideSubTabModel.value;

    return InkWell(
      onTap: () {
        setState(() {
          subSelected = index;
          provider.setPage(sideSubTabModel.value, sideSubTabModel.text);
        });
      },
      child: MouseRegion(
        onEnter: (event) {
          setState(() {
            subHovered = index;
          });
        },
        onExit: (event) {
          setState(() {
            subHovered = -1;
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          child: SizedBox(
            width: isDesktop ? width * 0.12 : width * 0.5,
            child: Text(
              ">  $text",
              style: TextStyle(
                color: activeSubColor(index),
                fontSize: isDesktop ? width * 0.009 : width * 0.045,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color activeSubColor(int index) {
    int currentPage = provider.getPage();
    if (subHovered == index) {
      return secondary;
    } else if (subSelected == index && subSelected == currentPage) {
      return secondary;
    }
    return Colors.white;
  }

  Color activeTabColor() {
    return isHovered || isSelected ? hoverColor : primary;
  }

  double getDynamicHeight(SideTabModel sideTabModel) {
    int length = sideTabModel.subMenu.length;
    if (isSelected) {
      if (length == 4) {
        return isDesktop ? 200 : height * 0.3;
      } else if (length == 2) {
        return isDesktop ? 120 : height * 0.2;
      } else {
        return isDesktop ? 150 : height * 0.3;
      }
      // if (length >= 3 && length < 5) {
      //   return isDesktop ? height * 0.23 : height * 0.3;
      // } else if (length >= 4) {
      //   return isDesktop ? height * 0.8 : height * 1;
      // } else {
      //   return isDesktop ? height * 0.14 : height * 0.2;
      // }
    }
    return 0;
  }
}
