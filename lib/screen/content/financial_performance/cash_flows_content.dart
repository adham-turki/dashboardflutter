import 'dart:math';

import 'package:bi_replicate/model/chart/pie_chart_model.dart';

import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pie_chart/pie_chart.dart';

import '../../../components/charts.dart';
import '../../../components/charts/pie_chart.dart';
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
  String todayDate = DatesController().formatDateReverse(
      DatesController().formatDate(DatesController().todayDate()));
  String nextMonth = DatesController().formatDateReverse(DatesController()
      .formatDate(DateTime(DatesController().today.year,
              DatesController().today.month + 1, DatesController().today.day)
          .toString()));
  @override
  void initState() {
    _fromDateController.text = todayDate;
    _toDateController.text = nextMonth;

    getCashBoxAccount().then((value) {
      cashboxAccounts = value;
      setState(() {});
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context);

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
    getCashFlows();
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
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: const [
            //     CustomCard(
            //       gradientColor: [Color(0xff1cacff), Color(0xff30c4ff)],
            //       title: '42136',
            //       subtitle: 'Mon-Fri',
            //       label: 'Overall Sale',
            //       icon:
            //           Icons.attach_money, // Provide the actual path to the icon
            //     ),
            //     SizedBox(
            //       width: 10,
            //     ),
            //     CustomCard(
            //       gradientColor: [Color(0xfffd8236), Color(0xffffce6c)],
            //       title: '1446',
            //       subtitle: 'Mon-Fri',
            //       label: 'Total Visited',
            //       icon: Icons.abc, // Provide the actual path to the icon
            //     ),
            //     SizedBox(
            //       width: 10,
            //     ),
            //     CustomCard(
            //       gradientColor: [Color(0xff4741c1), Color(0xff7e4fe4)],
            //       title: '61%',
            //       subtitle: 'Mon-Fri',
            //       label: 'Overall Growth',
            //       icon: Icons.bar_chart, // Provide the actual path to the icon
            //     ),
            //   ],
            // ),
            // SizedBox(
            //   height: height * 0.1,
            // ),
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
                      ? MediaQuery.of(context).size.width * 0.9
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
                        ? MediaQuery.of(context).size.width * 0.9
                        : MediaQuery.of(context).size.width * 0.7,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5),
                    child: SelectableText(
                      maxLines: 10,
                      accountName(),
                      style: twelve400TextStyle(Colors.black),
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
                CustomDatePicker(
                  label: _locale.fromDate,
                  controller: _fromDateController,
                  onSelected: (value) {
                    setState(() {
                      _fromDateController.text = value;
                      getCashFlows();
                    });
                  },
                ),
                CustomDatePicker(
                  label: _locale.toDate,
                  controller: _toDateController,
                  onSelected: (value) {
                    setState(() {
                      _toDateController.text = value;
                      getCashFlows();
                    });
                  },
                ),
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
        CustomDatePicker(
          label: _locale.fromDate,
          controller: _fromDateController,
          onSelected: (value) {
            setState(() {
              _fromDateController.text = value;
              getCashFlows();
            });
          },
        ),
        CustomDatePicker(
          label: _locale.toDate,
          controller: _toDateController,
          onSelected: (value) {
            setState(() {
              _toDateController.text = value;
              getCashFlows();
            });
          },
        ),
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

  void getCashFlows() {
    listOfBalances = [];
    pieData = [];
    barData = [];
    dataMap.clear();

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
                color: getRandomColor(colorNewList)));
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
                color: getRandomColor(colorNewList)));
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
      _toDateController.text = DatesController().today.toString();
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

  Color getRandomColor(List<Color> colorList) {
    final random = Random();
    final index = random.nextInt(colorList.length);
    return colorList[index];
  }
}
