import 'package:bi_replicate/components/content_header.dart';
import 'package:bi_replicate/provider/screen_content_provider.dart';
import 'package:bi_replicate/screen/content/cheques_anagement/cheques_and_banks.dart';
import 'package:bi_replicate/screen/content/cheques_anagement/out_standing_cheques.dart';
import 'package:bi_replicate/screen/content/customer_points/customer_points_by_branch_screen.dart';
import 'package:bi_replicate/screen/content/customer_points/customer_points_by_customers_screen.dart';
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
import 'package:bi_replicate/screen/content/settings/session_date_screen.dart';
import 'package:bi_replicate/screen/content/settings/setup_content/setup.dart';
import 'package:bi_replicate/screen/content/settings/change_pass/change_password_screen.dart';
import 'package:bi_replicate/screen/content/settings/users_content/users_content.dart';
import 'package:bi_replicate/screen/content/settings/users_permit/user_permissions_screen.dart';
import 'package:bi_replicate/screen/dashboard_content_test.dart/dashboard_screen.dart';
import 'package:bi_replicate/screen/dashboard_content_test.dart/logs_reports_screen.dart';
import 'package:bi_replicate/screen/dashboard_content_test.dart/other_reports_screen.dart';
import 'package:bi_replicate/screen/dashboard_content_test.dart/reports_screen.dart';
import 'package:bi_replicate/screen/dashboard_content_test.dart/sales_reports_screen.dart';
import 'package:bi_replicate/screen/dashboard_content_test.dart/second_reports_screen.dart';
import 'package:bi_replicate/screen/journal_reports_screen.dart';
import 'package:bi_replicate/utils/constants/colors.dart';
import 'package:bi_replicate/utils/constants/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screen/content/reports/sales_report_content.dart/sales_report.dart';
import 'widget/new_sideMenue/side_menu.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  late AppLocalizations locale;
  late ScreenContentProvider provider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    locale = AppLocalizations.of(context)!;
    provider = context.read<ScreenContentProvider>();
  }

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
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // const Text("BI"),
                  Consumer<ScreenContentProvider>(
                      builder: ((context, value, child) {
                    return SizedBox(
                      width: 150,
                      child: Text(
                        maxLines: 2,
                        getPage(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  })),

                  Text(
                    "${locale.baseCurrency}: ${locale.ils}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
      drawer: isDesktop ? null : const SideMenu(),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          isDesktop ? const SideMenu() : Container(),
          Expanded(
            child: Consumer<ScreenContentProvider>(
                builder: (context, value, build) {
              return Column(
                children: [
                  isDesktop
                      ? SizedBox(
                          // width: isDesktop ? width * 0.835 : width,
                          height: isDesktop
                              ? provider.getPage() == 0
                                  ? height * 0.07
                                  : height * 0.055
                              : height * 0.085,
                          child: ContentHeader(page: provider.getPage()),
                        )
                      : const SizedBox.shrink(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Consumer<ScreenContentProvider>(
                          builder: (context, value, build) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: contentPage(),
                        );
                      }),
                    ),
                  ),
                  // const Text("footer"),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget contentPage() {
    index = provider.getPage();
    switch (index) {
      case 0:
        return const DashboardScreen();
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
        return const UsersContent();

      case 16:
        return const UserPermissionsScreen();
      case 17:
        return const SetupScreen();
      case 18:
        return const ChangePasswordScreen();
      case 19:
        return const JournalReportsScreen();
      case 20:
        return const SalesReportsScreen();
      case 21:
        return const LogsReportsScreen();
      case 22:
        return const ReportsScreen();
      case 23:
        return const SecondReportsScreen();
      case 24:
        return const OtherReportsScreen();
      case 25:
        return const CustomerPointsByBranchScreen();
      case 26:
        return const CustomerPointsByCustomersScreen();
      // case 33:
      //   return const SessionDateScreen();
      default:
        return Container();
    }
  }

  String getPage() {
    int index = provider.getPage();
    switch (index) {
      case 0:
        return locale.dashboard;
      case 1:
        return locale.salesByBranches;
      case 2:
        return locale.branchesSalesByCategories;
      case 3:
        return locale.dailySales;
      case 4:
        return locale.totalCollections;
      case 5:
        return locale.cashFlows;
      case 6:
        return locale.expenses;
      case 7:
        return locale.inventoryPerformance;
      case 8:
        return locale.monthlyComparsionOFReceivableAndPayables;
      case 9:
        return locale.agingReceivable;
      case 10:
        return locale.chequesAndBank;
      case 11:
        return locale.outStandingCheques;
      case 12:
        return locale.totalSales;
      case 13:
        return locale.salesreport;
      case 14:
        return locale.purchasesReport;
      case 15:
        return locale.users;
      case 16:
        return locale.userPermit;
      case 17:
        return locale.setup;
      case 18:
        return locale.changePassword;
      case 19:
        return locale.journalReports;
      case 20:
        return locale.salesReports;
      case 21:
        return locale.logsReports;
      case 22:
        return locale.differencesReports;
      case 23:
        return locale.profitReports;
      case 24:
        return locale.otherReports;
      case 25:
        return locale.byBranches;
      case 26:
        return locale.byCustomers;
      // case 33:
      //   return locale.sessionDate;
      default:
        return "";
    }
  }
}
