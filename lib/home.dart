import 'package:bi_replicate/components/content_header.dart';
import 'package:bi_replicate/components/side_menu.dart';
import 'package:bi_replicate/provider/screen_content_provider.dart';
import 'package:bi_replicate/screen/content/financial_performance/cash_flows_content.dart';
import 'package:bi_replicate/screen/content/financial_performance/expenses_content.dart';
import 'package:bi_replicate/screen/content/inventory_performance/inventory_perf_content.dart';
import 'package:bi_replicate/screen/content/receivable_management/aging_receivable.dart';
import 'package:bi_replicate/screen/content/receivable_management/month_comp_of_rec_pay_content.dart';
import 'package:bi_replicate/screen/content/sales_adminstration/branch_sales_by_cat_content.dart';
import 'package:bi_replicate/screen/content/sales_adminstration/daily_sales_content.dart';
import 'package:bi_replicate/screen/content/sales_adminstration/sales_by_branches_content.dart';
import 'package:bi_replicate/screen/content/sales_adminstration/total_collections_content.dart';
import 'package:bi_replicate/utils/constants/colors.dart';
import 'package:bi_replicate/utils/constants/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';

import 'screen/content/journal_report_content.dart';
import 'screen/content/reports/sales_report_content.dart/sales_report.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double width = 0;
  double height = 0;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: Responsive.isDesktop(context)
          ? null
          : AppBar(
              backgroundColor: primary,
              title: const Text("BI"),
            ),
      drawer: Responsive.isDesktop(context) ? null : const SideMenu(),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Responsive.isDesktop(context) ? const SideMenu() : Container(),
          Column(
            children: [
              SizedBox(
                width: Responsive.isDesktop(context) ? width * 0.835 : width,
                height: height * 0.08,
                child: const ContentHeader(),
              ),
              SizedBox(
                height: Responsive.isDesktop(context)
                    ? height * 0.9
                    : height * 0.85,
                width: width * 0.835,
                child: SingleChildScrollView(
                  child: Consumer<ScreenContentProvider>(
                      builder: (context, value, build) {
                    return contentPage();
                  }),
                ),
              )
              // const Text("footer"),
            ],
          ),
        ],
      ),
    );
  }

  Widget contentPage() {
    int index = context.read<ScreenContentProvider>().getPage();
    switch (index) {
      case 0:
        return const SalesByBranchesContent();
      case 1:
        return const BranchSalesByCatContent();
      case 2:
        return const DailySalesContent();
      case 3:
        return const TotalCollectionsContent();
      case 4:
        return const CashFlowsContent();
      case 5:
        return const ExpensesContent();
      case 6:
        return const InventoryPerfContent();
      case 7:
        return const MonthCompOfRecPayContent();
      case 8:
        return const AgingReceivable();
      case 9:
        return Container();
      case 10:
        return Container();
      case 11:
        return const JournalContent();
      case 12:
        return const SalesReportScreen();
      case 13:
        return Container();
      case 14:
        return Container();
      case 15:
        return Container();
      default:
        return Container();
    }
  }
}
