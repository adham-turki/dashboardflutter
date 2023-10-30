import 'dart:math';

import 'package:bi_replicate/components/login_components/custom_btn.dart';
import 'package:bi_replicate/model/bar_chart_data_model.dart';
import 'package:bi_replicate/screen/dashboard_content/bar_chart_sales_dashboard.dart';
import 'package:bi_replicate/screen/dashboard_content/daily_sales_dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  String todayDate = "";

  List<BarData> barData = [];
  List<BarData> barDataCashFlows = [];
  List<PieChartModel> barDataDailySales = [];
  List<BarChartData> barData1 = [];
  List<BarChartData> barData2 = [];

  late AppLocalizations _locale;
  @override
  void didChangeDependencies() {
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
      child: SingleChildScrollView(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0),
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width < 800
                          ? MediaQuery.of(context).size.width * 0.6
                          : MediaQuery.of(context).size.width * 0.13,
                      child: blueButton1(
                        icon: Icon(
                          Icons.filter_list_sharp,
                          color: whiteColor,
                          size: isDesktop ? height * 0.04 : height * 0.03,
                        ),
                        text: _locale.filter,
                        textColor: Color.fromARGB(255, 255, 255, 255),
                        //   borderRadius: 5.0,
                        height: isDesktop ? height * .07 : height * .06,
                        fontSize: isDesktop ? height * .018 : height * .017,
                        width: isDesktop ? width * 0.13 : width * 0.25,
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
                            getSalesByBranch().then((value) {
                              setState(() {});
                            });

                            getCashFlows().then((value) {
                              setState(() {});
                            });

                            getDailySales().then((value) {
                              setState(() {});
                            });

                            getRecPayData().then((value) {
                              setState(() {});
                            });
                          });
                        },
                      )),
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
                                child: DailySalesDashboard(
                                    pieData: barDataDailySales),
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
                          MonthlyDashboard(
                            barData: barData1,
                            barData2: barData2,
                          ),
                          if (Responsive.isMobile(context))
                            SizedBox(
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
                          BalanceBarChartDashboard(
                            barData: barData,
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
      barData = [];
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
    pieData = [];
    barDataCashFlows = [];
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
        }
      }
    });
  }

  Future getDailySales({bool? isStart}) async {
    List<double> listOfBalances = [];
    List<String> listOfPeriods = [];
    final dataMap = <String, double>{};
    DailySalesController dailySalesController = DailySalesController();
    bool boolTemp = false;
    List<BarData> barData = [];

    listOfBalances = [];
    dataMap.clear();
    barDataDailySales = [];
    int stat = getVoucherStatus(_locale, status);
    if (fromDateController.text.isEmpty) {
      if (fromDateController.text.isEmpty) {
        fromDateController.text = todayDate;
      }
    }
    SearchCriteria searchCriteria = SearchCriteria(
        fromDate: fromDateController.text.isEmpty
            ? todayDate
            : fromDateController.text,
        voucherStatus: stat);

    await dailySalesController
        .getDailySale(searchCriteria, isStart: isStart)
        .then((response) {
      for (var elemant in response) {
        String temp = DatesController().formatDate(getNextDay(
          fromDateController.text.isEmpty ? todayDate : fromDateController.text,
        ).toString());
        if (double.parse(elemant.dailySale.toString()) != 0.0) {
          boolTemp = true;
        } else if (double.parse(elemant.dailySale.toString()) == 0.0) {
          boolTemp = false;
        }

        listOfBalances.add(double.parse(elemant.dailySale.toString()));
        listOfPeriods.add(temp);
        if (boolTemp) {
          dataMap[temp] = formatDoubleToTwoDecimalPlaces(
              double.parse(elemant.dailySale.toString()));
          barDataDailySales.add(PieChartModel(
              title: temp,
              value: double.parse(elemant.dailySale.toString()) == 0.0
                  ? 1.0
                  : formatDoubleToTwoDecimalPlaces(
                      double.parse(elemant.dailySale.toString())),
              color: getRandomColor(colorNewList)));
        }

        barData.add(
          BarData(
              name: temp, percent: double.parse(elemant.dailySale.toString())),
        );
      }
    });
  }

  int count = 0;
  DateTime getNextDay(String inputDate) {
    count++;
    final List<String> dateParts = inputDate.split('-');
    if (dateParts.length != 3) {
      throw ArgumentError("Invalid date format. Expected dd-mm-yyyy.");
    }

    final int day = int.parse(dateParts[0]);
    final int month = int.parse(dateParts[1]);
    final int year = int.parse(dateParts[2]);

    final DateTime currentDate = DateTime(year, month, day);
    final DateTime nextDay = currentDate.add(Duration(days: count));

    return nextDay;
  }

  Future getRecPayData({bool? isStart}) async {
    List<double> listOfBalances2 = [];
    List<String> listOfPeriods2 = [];
    final dataMap = <String, double>{};
    List<double> listOfBalances = [];
    List<String> listOfPeriods = [];
    listOfBalances = [];
    listOfBalances2 = [];
    listOfPeriods = [];
    listOfPeriods2 = [];
    RecPayController recPayController = RecPayController();

    dataMap.clear();
    barData1 = [];
    barData2 = [];
    if (fromDateController.text.isEmpty || toDateController.text.isEmpty) {
      if (fromDateController.text.isEmpty) {
        fromDateController.text = todayDate;
      }
      if (toDateController.text.isEmpty) {
        toDateController.text = todayDate;
      }
    }
    int stat = getVoucherStatus(_locale, status);
    SearchCriteria searchCriteria = SearchCriteria(
        fromDate: fromDateController.text.isEmpty
            ? todayDate
            : fromDateController.text,
        voucherStatus: stat);

    await recPayController
        .getRecPayMethod(searchCriteria, isStart: isStart)
        .then((value) {
      int maxVal = value.payables.length > value.receivables.length
          ? value.payables.length
          : value.receivables.length;
      for (int i = 0; i < maxVal; i++) {
        listOfBalances.add(double.parse(value.payables[i].value!));
        listOfBalances2.add(double.parse(value.receivables[i].value!));
        listOfPeriods.add(value.payables[i].date!);
        listOfPeriods2.add(value.receivables[i].date!);

        barData1.add(
          BarChartData(
              value.payables[i].date!, double.parse(value.payables[i].value!)),
        );
        barData2.add(
          BarChartData(value.receivables[i].date!,
              double.parse(value.receivables[i].value!)),
        );
      }
    });
  }
}
