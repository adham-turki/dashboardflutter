import 'package:bi_replicate/components/content_header.dart';
import 'package:bi_replicate/components/side_menu.dart';
import 'package:bi_replicate/provider/screen_content_provider.dart';
import 'package:bi_replicate/screen/content/cheques_anagement/cheques_and_banks.dart';
import 'package:bi_replicate/screen/content/cheques_anagement/out_standing_cheques.dart';
import 'package:bi_replicate/screen/content/financial_performance/cash_flows_content.dart';
import 'package:bi_replicate/screen/content/financial_performance/expenses_content.dart';
import 'package:bi_replicate/screen/content/inventory_performance/inventory_perf_content.dart';
import 'package:bi_replicate/screen/content/receivable_management/aging_receivable.dart';
import 'package:bi_replicate/screen/content/receivable_management/month_comp_of_rec_pay_content.dart';
import 'package:bi_replicate/screen/content/reports/purchase_reporort_content.dart/purchase_report.dart';
import 'package:bi_replicate/screen/content/reports/total_sales.dart';
import 'package:bi_replicate/screen/content/sales_adminstration/branch_sales_by_cat_content.dart';
import 'package:bi_replicate/screen/content/sales_adminstration/daily_sales_content.dart';
import 'package:bi_replicate/screen/content/sales_adminstration/sales_by_branches_content.dart';
import 'package:bi_replicate/screen/content/sales_adminstration/total_collections_content.dart';
import 'package:bi_replicate/screen/content/settings/setup_content/setup.dart';
import 'package:bi_replicate/screen/content/settings/change_pass/change_password_screen.dart';
import 'package:bi_replicate/utils/constants/colors.dart';
import 'package:bi_replicate/utils/constants/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screen/content/reports/sales_report_content.dart/sales_report.dart';
import 'screen/dashboard_content/dashboard.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isDesktop = false;
  double width = 0;
  double height = 0;
  int index = 0;
  @override
  Widget build(BuildContext context) {
    isDesktop = Responsive.isDesktop(context);
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: isDesktop
          ? null
          : AppBar(
              backgroundColor: primary,
              title: const Text("BI"),
            ),
      drawer: isDesktop ? null : const SideMenu(),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          isDesktop ? const SideMenu() : Container(),
          Consumer<ScreenContentProvider>(builder: (context, value, build) {
            return Column(
              children: [
                SizedBox(
                  width: isDesktop ? width * 0.835 : width,
                  height: isDesktop
                      ? context.read<ScreenContentProvider>().getPage() == 0
                          ? height * 0.031
                          : height * 0.05
                      : context.read<ScreenContentProvider>().getPage() == 0
                          ? height * 0.1
                          : height * 0.07,
                  child: ContentHeader(
                      page: context.read<ScreenContentProvider>().getPage()),
                ),
                SizedBox(
                  //  height: isDesktop ? height * 0.85 : height * 0.7,
                  height: context.read<ScreenContentProvider>().getPage() == 0
                      ? isDesktop
                          ? height * 0.95
                          : height * 0.82
                      : isDesktop
                          ? height * 0.92
                          : height * 0.85,
                  width: isDesktop ? width * 0.835 : width * 0.95,
                  child: SingleChildScrollView(
                    child: Consumer<ScreenContentProvider>(
                        builder: (context, value, build) {
                      return contentPage();
                    }),
                  ),
                )
                // const Text("footer"),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget contentPage() {
    index = context.read<ScreenContentProvider>().getPage();
    print("index: ${index}");
    switch (index) {
      case 0:
        return const DashboardContent();
      case 1:
        return const SalesByBranchesContent();
      case 2:
        return const BranchSalesByCatContent();
      case 3:
        return const DailySalesContent();
      case 4:
        return const TotalCollectionsContent();
      case 5:
        return const CashFlowsContent();
      case 6:
        return const ExpensesContent();
      case 7:
        return const InventoryPerfContent();
      case 8:
        return const MonthCompOfRecPayContent();
      case 9:
        return const AgingReceivable();
      case 10:
        return const ChequesAndBankContent();
      case 11:
        return const OutStandingChequesContent();
      case 12:
        return const TotalSalesContent();
      case 13:
        return const SalesReportScreen();
      case 14:
        return const PurchasesReportScreen();
      case 15:
        return const SetupScreen();
      case 16:
        return const ChangePasswordScreen();
      default:
        return Container();
    }
  }
}
