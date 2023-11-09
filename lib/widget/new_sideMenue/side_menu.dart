import 'package:bi_replicate/widget/new_sideMenue/sub_menu_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../provider/local_provider.dart';
import '../../provider/screen_content_provider.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/responsive.dart';
import '../language_widget.dart';
import 'menu.dart';
import 'menu_model.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  double width = 0;
  double height = 0;

  Color shadowColor = Colors.grey.withOpacity(0.3);

  bool isEnteredCollapseIcon = false;
  double fontSize = 0;

  int selectedMenu = 0;
  int selectedSubMenu = -1;
  Color selectedColor = Colors.grey.withOpacity(0.3);

  int selectedMenuHover = -1;
  int selectedSubMenuHover = -1;

  bool isCollapsed = false;

  bool isDesktop = false;

  late AppLocalizations _locale;

  late ScreenContentProvider screenProvider;

  @override
  void didChangeDependencies() {
    // provider = context.read<ScreenContentProvider>();
    _locale = AppLocalizations.of(context)!;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    fontSize = width * 0.008;
    isDesktop = Responsive.isDesktop(context);

    List<MenuModel> menuList = getMenu(_locale);

    screenProvider = context.read<ScreenContentProvider>();
    return Container(
      height: height,
      width: drawerWidth(),
      decoration: BoxDecoration(
        color: primary,
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          titleSection(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: SizedBox(
              height: height * 0.8,
              child: SingleChildScrollView(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // CustomSearchField(
                    //   onChanged: (value) {},
                    // ),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    for (int i = 0; i < menuList.length; i++)
                      createMenuItem(menuList[i], i),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container titleSection() {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return Container(
      decoration: const BoxDecoration(),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: !isCollapsed
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.center,
            children: [
              !isCollapsed
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 15),
                      child: Image.asset(
                        "assets/images/scope_logo.png",
                        width: isDesktop ? width * 0.063 : width * 0.5,
                        // height: 100,
                      ),
                    )
                  : Container(),
              isDesktop
                  ? MouseRegion(
                      onEnter: (event) {
                        setState(() {
                          isEnteredCollapseIcon = true;
                        });
                      },
                      onExit: (event) {
                        setState(() {
                          isEnteredCollapseIcon = false;
                        });
                      },
                      child: IconButton(
                        color: Colors.white,
                        splashRadius: 1,
                        iconSize: width * 0.015,
                        onPressed: () {
                          setState(() {
                            isCollapsed
                                ? isCollapsed = false
                                : isCollapsed = true;
                          });
                        },
                        icon: Icon(
                          Icons.flip_to_back_rounded,
                          color: isEnteredCollapseIcon ? Colors.white : null,
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: LanguageWidget(
              color: Colors.white,
              onLocaleChanged: (locale) {
                localeProvider.setLocale(locale);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget createMenuItem(MenuModel menu, int index) {
    Radius radius = const Radius.circular(100);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          selectedMenu == index
              ? createSelecter(radius)
              : Container(
                  width: isDesktop ? width * 0.002 : width * 0.004,
                ),
          const SizedBox(
            width: 6,
          ),
          menuWidget(index, menu),
        ],
      ),
    );
  }

  Container createSelecter(Radius radius) {
    return Container(
      width: isDesktop ? width * 0.002 : width * 0.004,
      height: 38,
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.only(
          topRight: radius,
          bottomRight: radius,
        ),
      ),
    );
  }

  Widget menuWidget(int index, MenuModel menu) {
    Color activeColor = getActiveColor(index);
    String title = menu.title;
    bool isParent = menu.isParent;
    IconData icon = menu.icon;
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          selectedMenuHover = index;
        });
      },
      onExit: (event) {
        setState(() {
          selectedMenuHover = -1;
        });
      },
      child: Container(
        width: menuWidth(),
        decoration: BoxDecoration(
          color: activeColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  selectedMenu = index;
                  if (!menu.isParent) {
                    screenProvider.setPage(menu.pageNumber, "");
                  } else {
                    selectedSubMenu = menu.subMenuList[0].pageNumber;
                    screenProvider.setPage(menu.subMenuList[0].pageNumber, "");
                  }
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Icon(
                            icon,
                            color: Colors.white,
                            size: isDesktop ? width * 0.011 : width * 0.05,
                          ),
                          !isCollapsed
                              ? const SizedBox(
                                  width: 5,
                                )
                              : Container(),
                          !isCollapsed
                              ? Text(
                                  title,
                                  style: TextStyle(
                                      fontSize:
                                          isDesktop ? fontSize : width * 0.03,
                                      color: Colors.white),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                    !isCollapsed
                        ? isParent
                            ? Icon(
                                color: Colors.white,
                                selectedMenu == index
                                    ? Icons.arrow_drop_down_rounded
                                    : Icons.arrow_right_rounded,
                                size: isDesktop ? width * 0.011 : width * 0.05,
                              )
                            : Container()
                        : Container(),
                  ],
                ),
              ),
            ),
            !isCollapsed
                ? isParent
                    ? selectedMenu == index
                        ? Column(
                            children: [
                              for (int i = 0; i < menu.subMenuList.length; i++)
                                createSubMenu(
                                    menu.subMenuList[i], menu.pageNumber)
                            ],
                          )
                        : Container()
                    : Container()
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget createSubMenu(SubMenuModel subMenu, int parentNumber) {
    String title = subMenu.title;
    int page = subMenu.pageNumber;
    return InkWell(
      onTap: () {
        setState(() {
          selectedSubMenu = page;
          screenProvider.setPage(page, title);
        });
      },
      child: MouseRegion(
        onEnter: (event) {
          setState(() {
            selectedSubMenuHover = page;
          });
        },
        onExit: (event) {
          setState(() {
            selectedSubMenuHover = -1;
          });
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? width * 0.018 : width * 0.1,
              vertical: 15),
          child: Row(
            children: [
              Icon(
                color: Colors.white,
                Icons.circle_rounded,
                size: isDesktop ? width * 0.005 : width * 0.02,
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: isDesktop ? width * 0.08 : width * 0.3,
                child: Text(
                  title,
                  style: TextStyle(
                    color: getActiveSubColor(page, parentNumber),
                    fontSize: isDesktop ? fontSize : width * 0.03,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color getActiveColor(int index) {
    if (selectedMenuHover == index || selectedMenu == index) {
      return primary;
    }
    return primary;
  }

  Color? getActiveSubColor(int page, int parentNumber) {
    if (selectedSubMenuHover == page || (selectedSubMenu == page)) {
      return Colors.white;
    }
    return Colors.white;
  }

  double drawerWidth() {
    if (isDesktop) {
      return !isCollapsed ? width * 0.149 : width * 0.045;
    } else {
      return width * 0.6;
    }
  }

  double menuWidth() {
    if (isDesktop) {
      return !isCollapsed ? width * 0.132 : width * 0.03;
    } else {
      return width * 0.55;
    }
  }
}
