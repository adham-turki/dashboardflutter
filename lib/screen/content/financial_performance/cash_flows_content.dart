import 'dart:math';

import 'package:bi_replicate/model/chart/pie_chart_model.dart';

import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pie_chart/pie_chart.dart';

import '../../../components/charts.dart';
import '../../../components/charts/pie_chart.dart';
import '../../../components/custom_date.dart';
import '../../../controller/error_controller.dart';
import '../../../controller/financial_performance/cash_flow_controller.dart';
import '../../../controller/settings/setup/accounts_name.dart';
import '../../../model/bar_chart_data_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../model/criteria/search_criteria.dart';
import '../../../model/settings/setup/bi_account_model.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/maps.dart';
import '../../../utils/constants/responsive.dart';
import '../../../utils/constants/styles.dart';
import '../../../utils/func/dates_controller.dart';
import '../../../widget/custom_date_picker.dart';
import '../../../widget/drop_down/custom_dropdown.dart';

class CashFlowsContent extends StatefulWidget {
  const CashFlowsContent({super.key});

  @override
  State<CashFlowsContent> createState() => _CashFlowsContentState();
}

class _CashFlowsContentState extends State<CashFlowsContent> {
  final dropdownKey = GlobalKey<DropdownButton2State>();
  final storage = const FlutterSecureStorage();
  double width = 0;
  double height = 0;
  bool isDesktop = false;
  bool temp = false;
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();
  CashFlowController cashFlowController = CashFlowController();
  List<String> periods = [];
  List<String> status = [];
  late AppLocalizations _locale;

  var selectedStatus = "";
  List<String> charts = [];
  var selectedPeriod = "";
  var selectedChart = "";
  double balance = 0;
  bool accountsActive = false;
  String accountNameString = "";

  List<double> listOfBalances = [];
  List<String> listOfPeriods = [];

  final List<String> items = [
    'Print',
    'Save as JPEG',
    'Save as PNG',
  ];
  final dataMap = <String, double>{};

  List<PieChartModel> pieData = [];
  List<BiAccountModel> cashboxAccounts = [];

  List<BarChartData> barData = [];
  final usedColors = <Color>[];

  // String nextMonth = DatesController().formatDateReverse(DatesController()
  //     .formatDate(DateTime(DatesController().today.year,
  //             DatesController().today.month + 1, DatesController().today.day)
  //         .toString()));
  @override
  void initState() {
    _fromDateController.text = todayDate;
    _toDateController.text = todayDate;

    getCashBoxAccount(isStart: true).then((value) {
      cashboxAccounts = value;
      setState(() {});
    });

    super.initState();
  }

  String todayDate = "";

  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context);
    todayDate = DatesController().formatDateReverse(
        DatesController().formatDate(DatesController().todayDate()));
    status = [
      _locale.all,
      _locale.posted,
      _locale.draft,
      _locale.canceled,
    ];
    periods = [
      _locale.daily,
      _locale.weekly,
      _locale.monthly,
      _locale.yearly,
    ];
    charts = [
      _locale.lineChart,
      _locale.barChart,
      _locale.pieChart,
    ];
    selectedPeriod = periods[0];
    selectedChart = charts[0];
    selectedStatus = status[0];
    getCashFlows(isStart: true);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    isDesktop = Responsive.isDesktop(context);

    return SingleChildScrollView(
      child: Container(
        // height: height,
        decoration: const BoxDecoration(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: width * 0.7,
              decoration: borderDecoration,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: isDesktop ? desktopCriteria() : mobileCriteria(),
              ),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  accountsActive = !accountsActive;
                  setState(() {});
                },
                child: Container(
                  width: MediaQuery.of(context).size.width < 800
                      ? MediaQuery.of(context).size.width * 0.7
                      : MediaQuery.of(context).size.width * 0.7,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SelectableText(
                        maxLines: 1,
                        _locale.accounts,
                        style: fourteen400TextStyle(Colors.white),
                      ),
                      const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            accountsActive
                ? Container(
                    width: MediaQuery.of(context).size.width < 800
                        ? MediaQuery.of(context).size.width * 0.7
                        : MediaQuery.of(context).size.width * 0.7,
                    height: isDesktop ? height * 0.08 : height * 0.12,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5),
                    child: SelectableText(
                      maxLines: 10,
                      accountName(),
                      style: sixteen600TextStyle(Colors.black),
                    ))
                : Container(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: width * 0.7,
                height: isDesktop ? height * 0.6 : height * 0.6,
                decoration: borderDecoration,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            selectedChart == _locale.lineChart
                                ? _locale.lineChart
                                : selectedChart == _locale.pieChart
                                    ? _locale.pieChart
                                    : _locale.barChart,
                            style: TextStyle(fontSize: isDesktop ? 24 : 18),
                          ),
                        ),
                      ],
                    ),
                    selectedChart == _locale.lineChart
                        ? BalanceLineChart(
                            yAxisText: _locale.balances,
                            xAxisText: _locale.periods,
                            balances: listOfBalances,
                            periods: listOfPeriods)
                        : selectedChart == _locale.pieChart
                            ? Center(
                                child: PieChartComponent(
                                  radiusNormal: isDesktop ? height * 0.17 : 70,
                                  radiusHover: isDesktop ? height * 0.17 : 80,
                                  width: isDesktop ? width * 0.42 : width * 0.1,
                                  height:
                                      isDesktop ? height * 0.42 : height * 0.4,
                                  dataList: pieData,
                                ),
                              )
                            : BalanceBarChart(data: barData),
                    const SizedBox(), //Footer
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row desktopCriteria() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomDropDown(
                  items: periods,
                  label: _locale.period,
                  initialValue: selectedPeriod,
                  onChanged: (value) {
                    setState(() {
                      checkPeriods(value);
                      selectedPeriod = value!;
                      getCashFlows();
                    });
                  },
                ),
                CustomDropDown(
                  items: status,
                  label: _locale.status,
                  initialValue: selectedStatus,
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value!;
                      getCashFlows();
                    });
                  },
                ),
                CustomDropDown(
                  items: charts,
                  label: _locale.chartType,
                  initialValue: selectedChart,
                  onChanged: (value) {
                    setState(() {
                      selectedChart = value!;
                      getCashFlows();
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomDate(
                  dateController: _fromDateController,
                  label: _locale.fromDate,
                  minYear: 2000,
                  onValue: (isValid, value) {
                    if (isValid) {
                      setState(() {
                        _fromDateController.text = value;
                        DateTime from =
                            DateTime.parse(_fromDateController.text);
                        DateTime to = DateTime.parse(_toDateController.text);

                        if (from.isAfter(to)) {
                          ErrorController.openErrorDialog(
                              1, _locale.startDateAfterEndDate);
                        } else {
                          getCashFlows();
                        }
                      });
                    }
                  },
                ),
                SizedBox(
                  width: width * 0.01,
                ),
                // CustomDatePicker(
                //   label: _locale.fromDate,
                //   date: DateTime.parse(_toDateController.text),
                //   controller: _fromDateController,
                //   onSelected: (value) {
                //     setState(() {
                //       _fromDateController.text = value;
                //       getCashFlows();
                //     });
                //   },
                // ),
                CustomDate(
                  dateController: _toDateController,
                  label: _locale.toDate,
                  // minYear: 2000,
                  onValue: (isValid, value) {
                    if (isValid) {
                      setState(() {
                        _toDateController.text = value;
                        DateTime from =
                            DateTime.parse(_fromDateController.text);
                        DateTime to = DateTime.parse(_toDateController.text);

                        if (from.isAfter(to)) {
                          ErrorController.openErrorDialog(
                              1, _locale.startDateAfterEndDate);
                        } else {
                          getCashFlows();
                        }
                      });
                    }
                  },
                ),
                // CustomDatePicker(
                //   label: _locale.toDate,
                //   controller: _toDateController,
                //   date: DateTime.parse(_fromDateController.text),
                //   onSelected: (value) {
                //     setState(() {
                //       _toDateController.text = value;
                //       getCashFlows();
                //     });
                //   },
                // ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Column mobileCriteria() {
    double widthMobile = width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CustomDropDown(
          width: widthMobile,
          items: charts,
          label: _locale.chartType,
          initialValue: selectedChart,
          onChanged: (value) {
            setState(() {
              selectedChart = value!;
              getCashFlows();
            });
          },
        ),
        CustomDropDown(
          width: widthMobile,
          items: periods,
          label: _locale.period,
          initialValue: selectedPeriod,
          onChanged: (value) {
            setState(() {
              checkPeriods(value);
              selectedPeriod = value!;
              getCashFlows();
            });
          },
        ),
        CustomDropDown(
          width: widthMobile,
          items: status,
          label: _locale.byCategory,
          initialValue: selectedStatus,
          onChanged: (value) {
            setState(() {
              selectedStatus = value!;
              getCashFlows();
            });
          },
        ),
        SizedBox(
          width: widthMobile,
          child: CustomDate(
            dateController: _fromDateController,
            label: _locale.fromDate,
            minYear: 2000,
            onValue: (isValid, value) {
              if (isValid) {
                setState(() {
                  _fromDateController.text = value;
                  DateTime from = DateTime.parse(_fromDateController.text);
                  DateTime to = DateTime.parse(_toDateController.text);

                  if (from.isAfter(to)) {
                    ErrorController.openErrorDialog(
                        1, _locale.startDateAfterEndDate);
                  } else {
                    getCashFlows();
                  }
                });
              }
            },
          ),
        ),
        // CustomDatePicker(
        //   label: _locale.fromDate,
        //   date: DateTime.parse(_toDateController.text),
        //   controller: _fromDateController,
        //   onSelected: (value) {
        //     setState(() {
        //       _fromDateController.text = value;
        //       getCashFlows();
        //     });
        //   },
        // ),
        SizedBox(
          width: widthMobile,
          child: CustomDate(
            dateController: _toDateController,
            label: _locale.toDate,
            // minYear: 2000,
            onValue: (isValid, value) {
              if (isValid) {
                setState(() {
                  _toDateController.text = value;
                  DateTime from = DateTime.parse(_fromDateController.text);
                  DateTime to = DateTime.parse(_toDateController.text);

                  if (from.isAfter(to)) {
                    ErrorController.openErrorDialog(
                        1, _locale.startDateAfterEndDate);
                  } else {
                    getCashFlows();
                  }
                });
              }
            },
          ),
        ),
        // CustomDatePicker(
        //   label: _locale.toDate,
        //   controller: _toDateController,
        //   date: DateTime.parse(_fromDateController.text),
        //   onSelected: (value) {
        //     setState(() {
        //       _toDateController.text = value;
        //       getCashFlows();
        //     });
        //   },
        // ),
      ],
    );
  }

  String accountName() {
    accountNameString = "";
    for (int i = 0; i < cashboxAccounts.length; i++) {
      accountNameString += "${cashboxAccounts[i].accountName},";
    }
    return accountNameString;
  }

  double formatDoubleToTwoDecimalPlaces(double number) {
    return double.parse(number.toStringAsFixed(2));
  }

  void getCashFlows({bool? isStart}) {
    listOfBalances = [];
    pieData = [];
    barData = [];
    dataMap.clear();
    if (_fromDateController.text.isEmpty || _toDateController.text.isEmpty) {
      setState(() {
        if (_fromDateController.text.isEmpty) {
          _fromDateController.text = todayDate;
        }
        if (_toDateController.text.isEmpty) {
          _toDateController.text = todayDate;
        }
      });
    }
    int status = getVoucherStatus(_locale, selectedStatus);
    String startDate = DatesController().formatDate(_fromDateController.text);
    String endDate = DatesController().formatDate(_toDateController.text);
    SearchCriteria searchCriteria = SearchCriteria(
        fromDate: startDate, toDate: endDate, voucherStatus: status);
    cashFlowController.getChartCash(searchCriteria).then((value) {
      setState(() {
        balance = value[0].value! - value[1].value!;
      });
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
                color: getRandomColor(colorNewList, usedColors)));
          }
          barData.add(
            BarChartData(_locale.cashIn, element.value!),
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
                color: getRandomColor(colorNewList, usedColors)));
          }
          barData.add(
            BarChartData(_locale.cashOut, element.value!),
          );
        }
      }
    });
  }

  void checkPeriods(value) {
    if (value == periods[0]) {
      _fromDateController.text = DatesController().todayDate().toString();
      _toDateController.text = DatesController().todayDate().toString();
    }
    if (value == periods[1]) {
      _fromDateController.text = DatesController().currentWeek().toString();
      _toDateController.text = DatesController().todayDate().toString();
    }
    if (value == periods[2]) {
      _fromDateController.text = DatesController().currentMonth().toString();
      _toDateController.text = DatesController().todayDate().toString();
    }
    if (value == periods[3]) {
      _fromDateController.text = DatesController().currentYear().toString();
      _toDateController.text = DatesController().todayDate().toString();
    }
  }

  Color getRandomColor(List<Color> colorList, List<Color> usedColors) {
    if (usedColors.length == colorList.length) {
      // If all colors have been used, clear the used colors list
      usedColors.clear();
    }

    final random = Random();
    Color color;
    do {
      final index = random.nextInt(colorList.length);
      color = colorList[index];
    } while (usedColors.contains(color));

    usedColors.add(color);
    return color;
  }
}
