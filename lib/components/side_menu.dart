import 'package:bi_replicate/utils/constants/colors.dart';
import 'package:bi_replicate/provider/screen_content_provider.dart';
import 'package:bi_replicate/utils/constants/responsive.dart';
import 'package:bi_replicate/widget/sidebar/logout_tab.dart';
import 'package:bi_replicate/widget/sidebar/tab_menu.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../provider/local_provider.dart';
import '../utils/constants/menu.dart';
import '../widget/language_widget.dart';
import '../widget/sidebar/logo_section.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final localeProvider = Provider.of<LocaleProvider>(context);

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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: LanguageWidget(
                            color: Colors.white,
                            onLocaleChanged: (locale) {
                              localeProvider.setLocale(locale);
                            },
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          for (int i = 0;
                              i <
                                  getSubMenu(AppLocalizations.of(context))
                                      .length;
                              i++)
                            TabMenu(
                                sideTabModel: getSubMenu(
                                    AppLocalizations.of(context))[i]),
                        ],
                      ),
                      // Column(
                      //   children: [
                      //     for (int i = menuList.length - 2;
                      //         i < menuList.length;
                      //         i++)
                      //       TabMenu(sideTabModel: menuList[i]),
                      //   ],
                      // ),
                    ],
                  );
                },
              ),
            ),
          ),
          const LogoutTab(),
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
