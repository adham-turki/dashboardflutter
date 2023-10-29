import 'dart:math';

import 'package:bi_replicate/screen/dashboard_content/bar_chart_sales_dashboard.dart';
import 'package:bi_replicate/screen/dashboard_content/daily_sales_dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../components/charts.dart';
import '../../controller/financial_performance/cash_flow_controller.dart';
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
import 'cash_flows_dashboard.dart';
import 'filter_dialog.dart';
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

  List<BarData> barData = [];
  List<BarData> barDataCashFlows = [];
  late AppLocalizations _locale;
  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context);

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
      child: SingleChildScrollView(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Column(
              children: [
                Components().blueButton(
                  height: width > 800 ? height * .05 : height * .06,
                  fontSize: width > 800 ? height * .016 : height * .011,
                  width: width * 0.25,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return FilterDialog(
                          onFilter: (selectedPeriod, fromDate, toDate,
                              selectedStatus) {
                            fromDateController.text = fromDate;
                            toDateController.text = toDate;
                            period = selectedPeriod;
                            status = selectedStatus;
                          },
                        );
                      },
                    ).then((value) async {
                      // print("after dialog status: ${status}");
                      // print("after fromDate : ${fromDateController.text}");
                      getSalesByBranch().then((value) {
                        print("bar Data inisde then:${barData.length}");
                        setState(() {});
                      });

                      getCashFlows().then((value) {
                        print("valee :${value}");
                        print(
                            "bar cash inisde then:${barDataCashFlows.length}");

                        setState(() {});
                      });
                    });
                  },
                  text: "Filter",
                  borderRadius: 0.3,
                  textColor: Colors.white,
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
                          BalanceBarChartDashboard(
                            barData: barData,
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
                            height: appPadding,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!Responsive.isMobile(context))
                                Expanded(
                                  flex: 3,
                                  child: CashFlowsDashboard(
                                    barData: barDataCashFlows,
                                  ),
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
                            CashFlowsDashboard(
                              barData: barDataCashFlows,
                            ),
                          if (Responsive.isMobile(context))
                            const SizedBox(
                              height: appPadding,
                            ),
// if (Responsive.isMobile(context)) StatusChart(),
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
                          MonthlyDashboard(),
                          if (Responsive.isMobile(context))
                            SizedBox(
                              height: appPadding,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future getSalesByBranch() async {
    print("************************ hi ********************************");
    List<double> listOfBalances = [];
    List<String> listOfPeriods = [];
    List<PieChartModel> pieData = [];
    bool temp = false;
    SalesBranchesController salesBranchesController = SalesBranchesController();
    String todayDate = "";
    // var selectedPeriod = "";
    final dataMap = <String, double>{};
    print("in get sales:${fromDateController.text}");
    if (fromDateController.text.isEmpty || toDateController.text.isEmpty) {
      if (fromDateController.text.isEmpty) {
        fromDateController.text = todayDate;
      }
      if (toDateController.text.isEmpty) {
        toDateController.text = todayDate;
      }
    } else {
      SearchCriteria searchCriteria = SearchCriteria(
          fromDate: fromDateController.text.isEmpty
              ? todayDate
              : fromDateController.text,
          toDate:
              toDateController.text.isEmpty ? todayDate : toDateController.text,
          voucherStatus: -100);
      pieData = [];
      dataMap.clear();
      barDataCashFlows = [];
      listOfBalances = [];
      listOfPeriods = [];
      await salesBranchesController
          .getSalesByBranches(searchCriteria)
          .then((value) {
        for (var element in value) {
          double a = (element.totalSales! + element.retSalesDis!) -
              (element.salesDis! + element.totalReturnSales!);
          a = Converters().formateDouble(a);
          if (a != 0.0) {
            temp = true;
          } else if (a == 0.0) {
            temp = false;
          }
          listOfBalances.add(a);
          listOfPeriods.add(element.namee!);
          if (temp) {
            dataMap[element.namee!] = formatDoubleToTwoDecimalPlaces(a);
            pieData.add(PieChartModel(
                title: element.namee!,
                value: formatDoubleToTwoDecimalPlaces(a),
                color: getRandomColor(colorNewList)));
          }

          barData.add(
            BarData(name: element.namee!, percent: a),
          );
          print("barData length inide method:${barData.length}");
        }
      });
    }
  }

  double formatDoubleToTwoDecimalPlaces(double number) {
    return double.parse(number.toStringAsFixed(2));
  }

  Color getRandomColor(List<Color> colorList) {
    final random = Random();
    final index = random.nextInt(colorList.length);
    return colorList[index];
  }

  String accountName() {
    String accountNameString = "";
    List<BiAccountModel> cashboxAccounts = [];

    accountNameString = "";
    for (int i = 0; i < cashboxAccounts.length; i++) {
      accountNameString += "${cashboxAccounts[i].accountName},";
    }
    return accountNameString;
  }

  Future getCashFlows() async {
    List<double> listOfBalances = [];
    List<String> listOfPeriods = [];
    CashFlowController cashFlowController = CashFlowController();
    bool temp = false;

    listOfBalances = [];
    List<PieChartModel> pieData = [];
    final dataMap = <String, double>{};
    String todayDate = "";
    pieData = [];
    dataMap.clear();
    if (fromDateController.text.isEmpty || toDateController.text.isEmpty) {
      if (fromDateController.text.isEmpty) {
        fromDateController.text = todayDate;
      }
      if (toDateController.text.isEmpty) {
        toDateController.text = todayDate;
      }
    }
    int stat = getVoucherStatus(_locale, status);
    String startDate = DatesController().formatDate(fromDateController.text);
    String endDate = DatesController().formatDate(toDateController.text);
    SearchCriteria searchCriteria = SearchCriteria(
        fromDate: fromDateController.text.isEmpty
            ? todayDate
            : fromDateController.text,
        toDate:
            toDateController.text.isEmpty ? todayDate : toDateController.text,
        voucherStatus: stat);
    await cashFlowController.getChartCash(searchCriteria).then((value) {
      for (var element in value) {
        if (element.value != 0.0) {
          temp = true;
        } else if (element.value == 0.0) {
          temp = false;
        }
        if (element.title! == "debit") {
          listOfBalances.add(element.value!);
          listOfPeriods.add(_locale.cashIn);
          if (temp) {
            dataMap[_locale.cashIn] =
                formatDoubleToTwoDecimalPlaces(element.value!);
            pieData.add(PieChartModel(
                title: _locale.cashIn,
                value: formatDoubleToTwoDecimalPlaces(element.value!),
                color: getRandomColor(colorNewList)));
          }
          barDataCashFlows.add(
            BarData(name: _locale.cashIn, percent: element.value!),
          );
        } else {
          listOfBalances.add(element.value!);
          listOfPeriods.add(_locale.cashOut);
          if (temp) {
            dataMap[_locale.cashOut] =
                formatDoubleToTwoDecimalPlaces(element.value!);
            pieData.add(PieChartModel(
                title: _locale.cashOut,
                value: element.value,
                color: getRandomColor(colorNewList)));
          }
          barDataCashFlows.add(
            BarData(name: _locale.cashOut, percent: element.value!),
          );
          print("flowchart length inide method:${barData.length}");
        }
      }
    });
  }
}
