import 'dart:math';

import 'package:bi_replicate/screen/dashboard_content/bar_chart_sales_dashboard.dart';
import 'package:bi_replicate/screen/dashboard_content/daily_sales_dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../components/charts.dart';
import '../../controller/sales_adminstration/sales_branches_controller.dart';
import '../../model/chart/pie_chart_model.dart';
import '../../model/criteria/search_criteria.dart';
import '../../utils/constants/app_utils.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/constants.dart';
import '../../utils/constants/responsive.dart';
import '../../utils/func/converters.dart';
import 'cash_flows_dashboard.dart';
import 'filter_dialog.dart';
import 'monthly_dashboard.dart';

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
                            // key: UniqueKey(),

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
                                  child: CashFlowsDashboard(),
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
                            CashFlowsDashboard(),
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
          print("barData length inide method:${barData.length}");
        }
        // setState(() {});
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

  // String accountName() {
  //   accountNameString = "";
  //   for (int i = 0; i < cashboxAccounts.length; i++) {
  //     accountNameString += "${cashboxAccounts[i].accountName},";
  //   }
  //   return accountNameString;
  // }

  // double formatDoubleToTwoDecimalPlaces(double number) {
  //   return double.parse(number.toStringAsFixed(2));
  // }

  // void getCashFlows() {
  //   listOfBalances = [];
  //   pieData = [];
  //   barData = [];
  //   dataMap.clear();
  //   if (_fromDateController.text.isEmpty || _toDateController.text.isEmpty) {
  //     setState(() {
  //       if (_fromDateController.text.isEmpty) {
  //         _fromDateController.text = todayDate;
  //       }
  //       if (_toDateController.text.isEmpty) {
  //         _toDateController.text = todayDate;
  //       }
  //     });
  //   }
  //   int status = getVoucherStatus(_locale, selectedStatus);
  //   String startDate = DatesController().formatDate(_fromDateController.text);
  //   String endDate = DatesController().formatDate(_toDateController.text);
  //   SearchCriteria searchCriteria = SearchCriteria(
  //       fromDate: startDate, toDate: endDate, voucherStatus: status);
  //   cashFlowController.getChartCash(searchCriteria).then((value) {
  //     setState(() {
  //       balance = value[0].value! - value[1].value!;
  //     });
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
  //         barData.add(
  //           BarChartData(_locale.cashIn, element.value!),
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
  //         barData.add(
  //           BarChartData(_locale.cashOut, element.value!),
  //         );
  //       }
  //     }
  //   });
  // }
}
