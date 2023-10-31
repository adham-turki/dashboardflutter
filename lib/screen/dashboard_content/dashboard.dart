import 'dart:math';

import 'package:bi_replicate/components/login_components/custom_btn.dart';
import 'package:bi_replicate/model/bar_chart_data_model.dart';
import 'package:bi_replicate/screen/dashboard_content/bar_chart_sales_dashboard.dart';
import 'package:bi_replicate/screen/dashboard_content/daily_sales_dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../components/charts.dart';
import '../../controller/financial_performance/cash_flow_controller.dart';
import '../../controller/receivable_management/rec_pay_controller.dart';
import '../../controller/sales_adminstration/daily_sales_controller.dart';
import '../../controller/sales_adminstration/sales_branches_controller.dart';
import '../../model/chart/pie_chart_model.dart';
import '../../model/criteria/search_criteria.dart';
import '../../model/settings/setup/bi_account_model.dart';
import '../../utils/constants/app_utils.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/constants.dart';
import '../../utils/constants/maps.dart';
import '../../utils/constants/responsive.dart';
import '../../utils/func/converters.dart';
import '../../utils/func/dates_controller.dart';
import 'branches_sales_cat_dashboard.dart';
import 'filter_dialog/filter_dialog_sales_branches.dart';
import 'monthly_dashboard.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DashboardContent extends StatefulWidget {
  const DashboardContent({Key? key}) : super(key: key);

  @override
  _DashboardContentState createState() => _DashboardContentState();
}

double width = 0;
double height = 0;

class _DashboardContentState extends State<DashboardContent> {
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  var period = "";
  var status = "";
  String todayDate = "";

  // List<BarData> barData = [];
  List<PieChartModel> pieData = [];
  List<BarData> barDataCashFlows = [];
  List<PieChartModel> barDataDailySales = [];
  List<BarChartData> barData1 = [];
  List<BarChartData> barData2 = [];

  late AppLocalizations _locale;
  @override
  void didChangeDependencies() async {
    _locale = AppLocalizations.of(context);
    todayDate = DatesController().formatDateReverse(
        DatesController().formatDate(DatesController().todayDate()));

    super.didChangeDependencies();
  }

  //
  @override
  Widget build(BuildContext context) {
    bool isDesktop = Responsive.isDesktop(context);
    bool isMobile = Responsive.isMobile(context);
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Column(
        children: [
          Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: appPadding,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!Responsive.isMobile(context))
                              Expanded(
                                flex: 2,
                                child: BalanceBarChartDashboard(),
                              ),
                            if (!Responsive.isMobile(context))
                              const SizedBox(
                                width: appPadding,
                              ),
                            Expanded(
                              flex: 2,
                              child: DailySalesDashboard(),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: appPadding,
                        ),
                        if (Responsive.isMobile(context))
                          const SizedBox(
                            height: appPadding,
                          ),
                        if (Responsive.isMobile(context))
                          BalanceBarChartDashboard(),
                        if (Responsive.isMobile(context))
                          const SizedBox(
                            height: appPadding,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        BranchesSalesByCatDashboard(),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // double formatDoubleToTwoDecimalPlaces(double number) {
  //   return double.parse(number.toStringAsFixed(2));
  // }

  // Color getRandomColor(List<Color> colorList) {
  //   final random = Random();
  //   final index = random.nextInt(colorList.length);
  //   return colorList[index];
  // }

  // String accountName() {
  //   String accountNameString = "";
  //   List<BiAccountModel> cashboxAccounts = [];

  //   accountNameString = "";
  //   for (int i = 0; i < cashboxAccounts.length; i++) {
  //     accountNameString += "${cashboxAccounts[i].accountName},";
  //   }
  //   return accountNameString;
  // }

  // Future getCashFlows() async {
  //   List<double> listOfBalances = [];
  //   List<String> listOfPeriods = [];
  //   CashFlowController cashFlowController = CashFlowController();
  //   bool temp = false;

  //   listOfBalances = [];
  //   List<PieChartModel> pieData = [];
  //   final dataMap = <String, double>{};
  //   pieData = [];
  //   barDataCashFlows = [];
  //   dataMap.clear();
  //   if (fromDateController.text.isEmpty || toDateController.text.isEmpty) {
  //     if (fromDateController.text.isEmpty) {
  //       fromDateController.text = todayDate;
  //     }
  //     if (toDateController.text.isEmpty) {
  //       toDateController.text = todayDate;
  //     }
  //   }
  //   int stat = getVoucherStatus(_locale, status);
  //   String startDate = DatesController().formatDate(fromDateController.text);
  //   String endDate = DatesController().formatDate(toDateController.text);
  //   SearchCriteria searchCriteria = SearchCriteria(
  //       fromDate: fromDateController.text.isEmpty
  //           ? todayDate
  //           : fromDateController.text,
  //       toDate:
  //           toDateController.text.isEmpty ? todayDate : toDateController.text,
  //       voucherStatus: stat);
  //   await cashFlowController.getChartCash(searchCriteria).then((value) {
  //     for (var element in value) {
  //       if (element.value != 0.0) {
  //         temp = true;
  //       } else if (element.value == 0.0) {
  //         temp = false;
  //       }
  //       if (element.title! == "debit") {
  //         listOfBalances.add(element.value!);
  //         listOfPeriods.add(_locale.cashIn);
  //         if (temp) {
  //           dataMap[_locale.cashIn] =
  //               formatDoubleToTwoDecimalPlaces(element.value!);
  //           pieData.add(PieChartModel(
  //               title: _locale.cashIn,
  //               value: formatDoubleToTwoDecimalPlaces(element.value!),
  //               color: getRandomColor(colorNewList)));
  //         }
  //         barDataCashFlows.add(
  //           BarData(name: _locale.cashIn, percent: element.value!),
  //         );
  //       } else {
  //         listOfBalances.add(element.value!);
  //         listOfPeriods.add(_locale.cashOut);
  //         if (temp) {
  //           dataMap[_locale.cashOut] =
  //               formatDoubleToTwoDecimalPlaces(element.value!);
  //           pieData.add(PieChartModel(
  //               title: _locale.cashOut,
  //               value: element.value,
  //               color: getRandomColor(colorNewList)));
  //         }
  //         barDataCashFlows.add(
  //           BarData(name: _locale.cashOut, percent: element.value!),
  //         );
  //       }
  //     }
  //   });
  // }

  // Future getRecPayData({bool? isStart}) async {
  //   List<double> listOfBalances2 = [];
  //   List<String> listOfPeriods2 = [];
  //   final dataMap = <String, double>{};
  //   List<double> listOfBalances = [];
  //   List<String> listOfPeriods = [];
  //   listOfBalances = [];
  //   listOfBalances2 = [];
  //   listOfPeriods = [];
  //   listOfPeriods2 = [];
  //   RecPayController recPayController = RecPayController();

  //   dataMap.clear();
  //   barData1 = [];
  //   barData2 = [];
  //   if (fromDateController.text.isEmpty || toDateController.text.isEmpty) {
  //     if (fromDateController.text.isEmpty) {
  //       fromDateController.text = todayDate;
  //     }
  //     if (toDateController.text.isEmpty) {
  //       toDateController.text = todayDate;
  //     }
  //   }
  //   int stat = getVoucherStatus(_locale, status);
  //   SearchCriteria searchCriteria = SearchCriteria(
  //       fromDate: fromDateController.text.isEmpty
  //           ? todayDate
  //           : fromDateController.text,
  //       voucherStatus: stat);

  //   await recPayController
  //       .getRecPayMethod(searchCriteria, isStart: isStart)
  //       .then((value) {
  //     int maxVal = value.payables.length > value.receivables.length
  //         ? value.payables.length
  //         : value.receivables.length;
  //     for (int i = 0; i < maxVal; i++) {
  //       listOfBalances.add(double.parse(value.payables[i].value!));
  //       listOfBalances2.add(double.parse(value.receivables[i].value!));
  //       listOfPeriods.add(value.payables[i].date!);
  //       listOfPeriods2.add(value.receivables[i].date!);

  //       barData1.add(
  //         BarChartData(
  //             value.payables[i].date!, double.parse(value.payables[i].value!)),
  //       );
  //       barData2.add(
  //         BarChartData(value.receivables[i].date!,
  //             double.parse(value.receivables[i].value!)),
  //       );
  //     }
  //   });
  // }
}
