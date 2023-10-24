import 'package:bi_replicate/model/side_menu/side_sub_tab_model.dart';
import 'package:flutter/material.dart';

import '../../model/side_menu/side_tab_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

List<SideTabModel> getSubMenu(AppLocalizations local) {
  List<SideTabModel> menuList = [
    SideTabModel(
      isParent: true,
      text: local.salesAdminstration,
      icon: Icons.assignment_ind_outlined,
      subMenu: [
        SideSubTabModel(
          text: local.salesByBranches,
          value: 0,
        ),
        SideSubTabModel(
          text: local.branchesSalesByCategories,
          value: 1,
        ),
        SideSubTabModel(
          text: local.dailySales,
          value: 2,
        ),
        SideSubTabModel(
          text: local.totalCollections,
          value: 3,
        ),
      ],
      value: -1,
    ),
    SideTabModel(
      isParent: true,
      text: local.financialPerformance,
      icon: Icons.monetization_on,
      subMenu: [
        SideSubTabModel(
          text: local.cashFlows,
          value: 4,
        ),
        SideSubTabModel(
          text: local.expenses,
          value: 5,
        ),
      ],
      value: -1,
    ),
    SideTabModel(
      text: local.inventoryPerformance,
      icon: Icons.inventory,
      isParent: false,
      subMenu: [],
      value: 6,
    ),
    SideTabModel(
      isParent: true,
      text: local.receivableManagement,
      icon: Icons.moving_outlined,
      subMenu: [
        SideSubTabModel(
          text: local.monthlyComparsionOFReceivableAndPayables,
          value: 7,
        ),
        SideSubTabModel(
          text: local.agingReceivable,
          value: 8,
        ),
      ],
      value: -1,
    ),
    SideTabModel(
      isParent: true,
      text: local.chequesManagement,
      icon: Icons.read_more,
      subMenu: [
        SideSubTabModel(
          text: local.chequesAndBank,
          value: 9,
        ),
        SideSubTabModel(
          text: local.outStandingCheques,
          value: 10,
        ),
      ],
      value: -1,
    ),
    // SideTabModel(
    //   isParent: true,
    //   text: "General Ledger",
    //   icon: Icons.note_sharp,
    //   subMenu: [
    //     SideSubTabModel(
    //       text: "Journal Report",
    //       value: 11,
    //     ),
    //     SideSubTabModel(
    //       text: "Ledger Report",
    //       value: 12,
    //     ),
    //     SideSubTabModel(
    //       text: "Accounts Balances",
    //       value: 13,
    //     ),
    //     SideSubTabModel(
    //       text: "Account Transaction",
    //       value: 14,
    //     ),
    //     SideSubTabModel(
    //       text: "Statement of Payable Account Report",
    //       value: 15,
    //     ),
    //     SideSubTabModel(
    //       text: "Balances by Account Subsidery",
    //       value: 16,
    //     ),
    //     SideSubTabModel(
    //       text: "Balance by Cost Center/Account Report",
    //       value: 17,
    //     ),
    //     SideSubTabModel(
    //       text: "Journal Transaction by Cose Center Report",
    //       value: 18,
    //     ),
    //     SideSubTabModel(
    //       text: "Parent Cost Center Balance",
    //       value: 19,
    //     ),
    //     SideSubTabModel(
    //       text: "Trial Balance Report and Financial Report",
    //       value: 20,
    //     ),
    //     SideSubTabModel(
    //       text: "Employee Statement Report",
    //       value: 21,
    //     ),
    //     SideSubTabModel(
    //       text: "Employee Balance Report",
    //       value: 22,
    //     ),
    //   ],
    //   value: -1,
    // ),
    SideTabModel(
      isParent: true,
      text: local.reports,
      icon: Icons.note_sharp,
      subMenu: [
        SideSubTabModel(
          text: local.totalSales,
          value: 11,
        ),
        SideSubTabModel(
          text: local.salesreport,
          value: 12,
        ),
        SideSubTabModel(
          text: local.purchasesReport,
          value: 13,
        ),
      ],
      value: -1,
    ),
    SideTabModel(
      isParent: true,
      text: local.settings,
      icon: Icons.settings,
      subMenu: [
        SideSubTabModel(
          text: local.setup,
          value: 14,
        ),
        SideSubTabModel(
          text: local.changePassword,
          value: 15,
        ),
      ],
      value: -1,
    ),
  ];
  return menuList;
}
