import 'package:bi_replicate/widget/new_sideMenue/sub_menu_model.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'menu_model.dart';

List<MenuModel> getMenu(AppLocalizations locale) {
  List<MenuModel> menuList = [
    MenuModel(
      title: locale.dashboard,
      icon: Icons.dashboard,
      isParent: true,
      subMenuList: [
        SubMenuModel(
          title: locale.dashboard,
          pageNumber: 0,
        ),
        SubMenuModel(
          title: locale.salesReports,
          pageNumber: 20,
        ),
        SubMenuModel(title: locale.logsReports, pageNumber: 21),
        SubMenuModel(title: locale.differencesReports, pageNumber: 22),
        SubMenuModel(title: locale.profitReports, pageNumber: 23)
      ],
      pageNumber: -1,
    ),
    // MenuModel(
    //   isParent: true,
    //   title: locale.salesAdminstration,
    //   icon: Icons.assignment_ind_outlined,
    //   subMenuList: [
    //     SubMenuModel(
    //       title: locale.salesByBranches,
    //       pageNumber: 1,
    //     ),
    //     SubMenuModel(
    //       title: locale.branchesSalesByCategories,
    //       pageNumber: 2,
    //     ),
    //     SubMenuModel(
    //       title: locale.dailySales,
    //       pageNumber: 3,
    //     ),
    //     SubMenuModel(
    //       title: locale.totalCollections,
    //       pageNumber: 4,
    //     ),
    //   ],
    //   pageNumber: -1,
    // ),
    // MenuModel(
    //   isParent: true,
    //   title: locale.financialPerformance,
    //   icon: Icons.monetization_on,
    //   subMenuList: [
    //     SubMenuModel(
    //       title: locale.cashFlows,
    //       pageNumber: 5,
    //     ),
    //     SubMenuModel(
    //       title: locale.expenses,
    //       pageNumber: 6,
    //     ),
    //   ],
    //   pageNumber: -1,
    // ),
    MenuModel(
      title: locale.inventoryPerformance,
      icon: Icons.inventory,
      isParent: false,
      subMenuList: [],
      pageNumber: 7,
    ),
    MenuModel(
      isParent: true,
      title: locale.receivableManagement,
      icon: Icons.moving_outlined,
      subMenuList: [
        SubMenuModel(
          title: locale.monthlyComparsionOFReceivableAndPayables,
          pageNumber: 8,
        ),
        SubMenuModel(
          title: locale.agingReceivable,
          pageNumber: 9,
        ),
      ],
      pageNumber: -1,
    ),
    // MenuModel(
    //   isParent: true,
    //   title: locale.chequesManagement,
    //   icon: Icons.read_more,
    //   subMenuList: [
    //     SubMenuModel(
    //       title: locale.chequesAndBank,
    //       pageNumber: 10,
    //     ),
    //     SubMenuModel(
    //       title: locale.outStandingCheques,
    //       pageNumber: 11,
    //     ),
    //   ],
    //   pageNumber: -1,
    // ),
    MenuModel(
      isParent: true,
      title: locale.reports,
      icon: Icons.note_sharp,
      subMenuList: [
        // SubMenuModel(
        //   title: locale.totalSales,
        //   pageNumber: 12,
        // ),
        SubMenuModel(
          title: locale.salesreport,
          pageNumber: 13,
        ),
        SubMenuModel(
          title: locale.purchasesReport,
          pageNumber: 14,
        ),
      ],
      pageNumber: -1,
    ),
    MenuModel(
      isParent: true,
      title: locale.settings,
      icon: Icons.settings,
      subMenuList: [
        // SubMenuModel(
        //   title: locale.users,
        //   pageNumber: 15,
        // ),
        // SubMenuModel(
        //   title: locale.userPermit,
        //   pageNumber: 16,
        // ),
        SubMenuModel(
          title: locale.setup,
          pageNumber: 17,
        ),
        SubMenuModel(
          title: locale.changePassword,
          pageNumber: 18,
        ),
        // SubMenuModel(title: locale.journalReports, pageNumber: 19)
      ],
      pageNumber: -1,
    ),
  ];
  return menuList;
}
