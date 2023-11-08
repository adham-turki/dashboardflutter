import 'dart:math';
import 'package:bi_replicate/model/chart/pie_chart_model.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import '../../../components/charts.dart';
import '../../../components/charts/pie_chart.dart';
import '../../../components/custom_date.dart';
import '../../../controller/financial_performance/expense_controller.dart';
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
import '../../../widget/drop_down/custom_dropdown.dart';

class ExpensesContent extends StatefulWidget {
  const ExpensesContent({super.key});

  @override
  State<ExpensesContent> createState() => _ExpensesContentState();
}

class _ExpensesContentState extends State<ExpensesContent> {
  double width = 0;
  double height = 0;
  bool isDesktop = false;
  bool boolTemp = false;
  final dropdownKey = GlobalKey<DropdownButton2State>();
  final TextEditingController _fromDateController = TextEditingController();
  late AppLocalizations _locale;
  List<String> status = [];
  List<String> periods = [];
  List<String> charts = [];
  var selectedStatus = "";
  var selectedChart = "";
  var selectedPeriod = "";
  String accountNameString = "";
  List<BiAccountModel> expensesAccounts = [];

  bool accountsActive = false;
  ExpensesController expensesController = ExpensesController();
  List<double> listOfBalances = [];
  List<String> listOfPeriods = [];

  final List<String> items = [
    'Print',
    'Save as JPEG',
    'Save as PNG',
  ];
  final dataMap = <String, double>{};

  List<PieChartModel> pieData = [];

  List<BarChartData> barData = [];
  final usedColors = <Color>[];
  @override
  void initState() {
    getExpensesAccounts(isStart: true).then((value) {
      expensesAccounts = value;
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

    _fromDateController.text = todayDate;
    // selectedChart = _locale.lineChart;
    // selectedStatus = _locale.all;
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
    selectedChart = charts[0];
    selectedStatus = status[0];
    selectedPeriod = periods[0];
    getExpenses(isStart: true);
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
              width: isDesktop ? width * 0.7 : width * 0.9,
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
                  width: isDesktop ? width * 0.7 : width * 0.9,
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
                    width: isDesktop ? width * 0.7 : width * 0.9,
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
                width: isDesktop ? width * 0.7 : width * 0.9,
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

  Column desktopCriteria() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CustomDropDown(
          items: charts,
          label: _locale.chartType,
          initialValue: selectedChart,
          onChanged: (value) {
            setState(() {
              selectedChart = value!;
              getExpenses();
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomDropDown(
              items: status,
              label: _locale.status,
              initialValue: selectedStatus,
              onChanged: (value) {
                setState(() {
                  selectedStatus = value.toString();

                  getExpenses();
                });
              },
            ),
            SizedBox(
              width: width * 0.135,
              child: CustomDate(
                dateController: _fromDateController,
                label: _locale.fromDate,
                minYear: 2000,
                onValue: (isValid, value) {
                  if (isValid) {
                    setState(() {
                      _fromDateController.text = value;

                      getExpenses();
                    });
                  }
                },
              ),
            ),
            // CustomDatePicker(
            //   label: _locale.fromDate,
            //   controller: _fromDateController,
            //   date: DateTime.now(),
            //   onSelected: (value) {
            //     setState(() {
            //       _fromDateController.text = value;
            //       getExpenses();
            //     });
            //   },
            // ),
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
          width: widthMobile * 0.81,
          items: charts,
          label: _locale.chartType,
          initialValue: selectedChart,
          onChanged: (value) {
            setState(() {
              selectedChart = value!;
              getExpenses();
            });
          },
        ),
        CustomDropDown(
          width: widthMobile * 0.81,
          items: status,
          label: _locale.status,
          initialValue: selectedStatus,
          onChanged: (value) {
            setState(() {
              selectedStatus = value.toString();

              getExpenses();
            });
          },
        ),
        SizedBox(
          width: widthMobile * 0.81,
          child: CustomDate(
            dateController: _fromDateController,
            label: _locale.fromDate,
            minYear: 2000,
            onValue: (isValid, value) {
              if (isValid) {
                setState(() {
                  _fromDateController.text = value;
                  getExpenses();
                });
              }
            },
          ),
        ),
        // CustomDatePicker(
        //   label: _locale.fromDate,
        //   controller: _fromDateController,
        //   date: DateTime.now(),
        //   onSelected: (value) {
        //     setState(() {
        //       _fromDateController.text = value;
        //       getExpenses();
        //     });
        //   },
        // ),
      ],
    );
  }

  double formatDoubleToTwoDecimalPlaces(double number) {
    return double.parse(number.toStringAsFixed(2));
  }

  int count = 0;
  getExpenses({bool? isStart}) {
    listOfBalances = [];
    listOfPeriods = [];
    pieData = [];
    barData = [];
    dataMap.clear();
    count = 0;
    if (_fromDateController.text.isEmpty) {
      setState(() {
        if (_fromDateController.text.isEmpty) {
          _fromDateController.text = todayDate;
        }
      });
    }
    int status = getVoucherStatus(_locale, selectedStatus);
    String date = DatesController().formatDate(_fromDateController.text);
    SearchCriteria searchCriteria =
        SearchCriteria(fromDate: date, toDate: date, voucherStatus: status);

    expensesController
        .getExpense(searchCriteria, isStart: isStart)
        .then((value) {
      for (var elemant in value) {
        String temp = DatesController().formatDate(getNextDay(date).toString());
        if (double.parse(elemant.expense.toString()) != 0.0) {
          boolTemp = true;
        } else if (double.parse(elemant.expense.toString()) == 0.0) {
          boolTemp = false;
        }
        setState(() {
          listOfBalances.add(elemant.expense!);
          listOfPeriods.add(temp);
          if (boolTemp) {
            pieData.add(PieChartModel(
                title: temp,
                value: double.parse(elemant.expense.toString()) == 0.0
                    ? 1.0
                    : formatDoubleToTwoDecimalPlaces(
                        double.parse(elemant.expense.toString())),
                color: getRandomColor(colorNewList, usedColors)));
          }

          barData.add(
              BarChartData(temp, double.parse(elemant.expense.toString())));
        });
      }
    });
  }

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
    late DateTime nextDay;
    if (count == 1) {
      nextDay = currentDate;
    } else {
      nextDay = currentDate.add(Duration(days: count - 1));
    }

    return nextDay;
  }

  String accountName() {
    accountNameString = "";
    for (int i = 0; i < expensesAccounts.length; i++) {
      accountNameString += "${expensesAccounts[i].accountName},";
    }
    return accountNameString;
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
