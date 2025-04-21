import 'package:bi_replicate/model/side_menu/side_sub_tab_model.dart';
import 'package:flutter/material.dart';

import '../../model/side_menu/side_tab_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

List<SideTabModel> getSubMenu(AppLocalizations locale) {
  List<SideTabModel> menuList = [
    SideTabModel(
      text: locale.dashboard,
      icon: Icons.dashboard,
      isParent: false,
      subMenu: [
        // SideSubTabModel(text: locale.salesReports, value: 20),
        // SideSubTabModel(text: locale.logsReports, value: 21),
        // SideSubTabModel(text: locale.differencesReports, value: 22),
        // SideSubTabModel(text: locale.profitReports, value: 23)
      ],
      value: 0,
    ),
    SideTabModel(
      text: locale.salesReports,
      icon: Icons.sell_outlined,
      isParent: false,
      subMenu: [
        // SideSubTabModel(text: locale.salesReports, value: 20),
        // SideSubTabModel(text: locale.logsReports, value: 21),
        // SideSubTabModel(text: locale.differencesReports, value: 22),
        // SideSubTabModel(text: locale.profitReports, value: 23)
      ],
      value: 20,
    ),
    SideTabModel(
      text: locale.logsReports,
      icon: Icons.dashboard,
      isParent: false,
      subMenu: [
        // SideSubTabModel(text: locale.salesReports, value: 20),
        // SideSubTabModel(text: locale.logsReports, value: 21),
        // SideSubTabModel(text: locale.differencesReports, value: 22),
        // SideSubTabModel(text: locale.profitReports, value: 23)
      ],
      value: 21,
    ),
    SideTabModel(
      text: locale.differencesReports,
      icon: Icons.save,
      isParent: false,
      subMenu: [
        // SideSubTabModel(text: locale.salesReports, value: 20),
        // SideSubTabModel(text: locale.logsReports, value: 21),
        // SideSubTabModel(text: locale.differencesReports, value: 22),
        // SideSubTabModel(text: locale.profitReports, value: 23)
      ],
      value: 22,
    ),
    SideTabModel(
      text: locale.profitReports,
      icon: Icons.attach_money,
      isParent: false,
      subMenu: [
        // SideSubTabModel(text: locale.salesReports, value: 20),
        // SideSubTabModel(text: locale.logsReports, value: 21),
        // SideSubTabModel(text: locale.differencesReports, value: 22),
        // SideSubTabModel(text: locale.profitReports, value: 23)
      ],
      value: 23,
    ),
    SideTabModel(
      text: locale.otherReports,
      icon: Icons.widgets,
      isParent: false,
      subMenu: [
        // SideSubTabModel(text: locale.salesReports, value: 20),
        // SideSubTabModel(text: locale.logsReports, value: 21),
        // SideSubTabModel(text: locale.differencesReports, value: 22),
        // SideSubTabModel(text: locale.profitReports, value: 23)
      ],
      value: 24,
    ),
    SideTabModel(
      isParent: true,
      text: locale.customerPoints,
      icon: Icons.person,
      subMenu: [
        SideSubTabModel(
          text: locale.byBranches,
          value: 25,
        ),
        SideSubTabModel(
          text: locale.byCustomers,
          value: 26,
        ),
      ],
      value: -1,
    ),
    // SideTabModel(
    //   isParent: true,
    //   text: locale.salesAdminstration,
    //   icon: Icons.assignment_ind_outlined,
    //   subMenu: [
    //     SideSubTabModel(
    //       text: locale.salesByBranches,
    //       value: 1,
    //     ),
    //     SideSubTabModel(
    //       text: locale.branchesSalesByCategories,
    //       value: 2,
    //     ),
    //     SideSubTabModel(
    //       text: locale.dailySales,
    //       value: 3,
    //     ),
    //     SideSubTabModel(
    //       text: locale.totalCollections,
    //       value: 4,
    //     ),
    //   ],
    //   value: -1,
    // ),
    // SideTabModel(
    //   isParent: true,
    //   text: locale.financialPerformance,
    //   icon: Icons.monetization_on,
    //   subMenu: [
    //     SideSubTabModel(
    //       text: locale.cashFlows,
    //       value: 5,
    //     ),
    //     SideSubTabModel(
    //       text: locale.expenses,
    //       value: 6,
    //     ),
    //   ],
    //   value: -1,
    // ),
    SideTabModel(
      text: locale.inventoryPerformance,
      icon: Icons.inventory,
      isParent: false,
      subMenu: [],
      value: 7,
    ),
    // SideTabModel(
    //   isParent: true,
    //   text: locale.receivableManagement,
    //   icon: Icons.moving_outlined,
    //   subMenu: [
    //     SideSubTabModel(
    //       text: locale.monthlyComparsionOFReceivableAndPayables,
    //       value: 8,
    //     ),
    //     SideSubTabModel(
    //       text: locale.agingReceivable,
    //       value: 9,
    //     ),
    //   ],
    //   value: -1,
    // ),
    // SideTabModel(
    //   isParent: true,
    //   text: locale.chequesManagement,
    //   icon: Icons.read_more,
    //   subMenu: [
    //     SideSubTabModel(
    //       text: locale.chequesAndBank,
    //       value: 10,
    //     ),
    //     SideSubTabModel(
    //       text: locale.outStandingCheques,
    //       value: 11,
    //     ),
    //   ],
    //   value: -1,
    // ),
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
      text: locale.reports,
      icon: Icons.note_sharp,
      subMenu: [
        // SideSubTabModel(
        //   text: locale.totalSales,
        //   value: 12,
        // ),
        SideSubTabModel(
          text: locale.salesreport,
          value: 13,
        ),
        SideSubTabModel(
          text: locale.purchasesReport,
          value: 14,
        ),
      ],
      value: -1,
    ),
    SideTabModel(
      isParent: true,
      text: locale.settings,
      icon: Icons.settings,
      subMenu: [
        SideSubTabModel(
          text: locale.setup,
          value: 15,
        ),
        SideSubTabModel(
          text: locale.changePassword,
          value: 16,
        ),
      ],
      value: -1,
    ),
  ];
  return menuList;
}
