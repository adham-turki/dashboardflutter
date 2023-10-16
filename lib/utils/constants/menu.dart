import 'package:bi_replicate/model/side_menu/side_sub_tab_model.dart';
import 'package:flutter/material.dart';

import '../../model/side_menu/side_tab_model.dart';

List<SideTabModel> menuList = [
  SideTabModel(
    isParent: true,
    text: "Sales Administration",
    icon: Icons.assignment_ind_outlined,
    subMenu: [
      SideSubTabModel(
        text: "Sales By Branches",
        value: 0,
      ),
      SideSubTabModel(
        text: "Branch Sales By Categories",
        value: 1,
      ),
      SideSubTabModel(
        text: "Daily Sales",
        value: 2,
      ),
      SideSubTabModel(
        text: "Total Collections",
        value: 3,
      ),
    ],
    value: -1,
  ),
  SideTabModel(
    isParent: true,
    text: "Financial Performance",
    icon: Icons.monetization_on,
    subMenu: [
      SideSubTabModel(
        text: "Cash Flows",
        value: 4,
      ),
      SideSubTabModel(
        text: "Expenses",
        value: 5,
      ),
    ],
    value: -1,
  ),
  SideTabModel(
    text: "Inventory Performance",
    icon: Icons.inventory,
    isParent: false,
    subMenu: [],
    value: 6,
  ),
  SideTabModel(
    isParent: true,
    text: "Receivable Management",
    icon: Icons.moving_outlined,
    subMenu: [
      SideSubTabModel(
        text: "Monthly comparison of receivable and payable",
        value: 7,
      ),
      SideSubTabModel(
        text: "Aging Receivable",
        value: 8,
      ),
    ],
    value: -1,
  ),
  SideTabModel(
    isParent: true,
    text: "Cheques Management",
    icon: Icons.read_more,
    subMenu: [
      SideSubTabModel(
        text: "Cheques & Banks",
        value: 9,
      ),
      SideSubTabModel(
        text: "Outstanding Cheques",
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
  // SideTabModel(
  //   isParent: true,
  //   text: "Reports",
  //   icon: Icons.note_sharp,
  //   subMenu: [
  //     SideSubTabModel(
  //       text: "Total Sales",
  //       value: 11,
  //     ),
  //     SideSubTabModel(
  //       text: "Sales Report",
  //       value: 12,
  //     ),
  //     SideSubTabModel(
  //       text: "Purchases Report",
  //       value: 13,
  //     ),
  //   ],
  //   value: -1,
  // ),
  // SideTabModel(
  //   isParent: true,
  //   text: "Settings",
  //   icon: Icons.settings,
  //   subMenu: [
  //     SideSubTabModel(
  //       text: "Setup",
  //       value: 14,
  //     ),
  //     SideSubTabModel(
  //       text: "Change Password",
  //       value: 15,
  //     ),
  //   ],
  //   value: -1,
  // ),
];
