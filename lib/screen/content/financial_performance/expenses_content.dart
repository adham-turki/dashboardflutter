import 'dart:math';

import 'package:bi_replicate/model/chart/pie_chart_model.dart';
import 'package:bi_replicate/utils/constants/api_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../../components/charts.dart';
import '../../../components/charts/pie_chart.dart';
import '../../../components/customCard.dart';
import '../../../controller/financial_performance/expense_controller.dart';
import '../../../controller/settings/setup/accounts_name.dart';
import '../../../model/bar_chart_data_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../model/criteria/search_criteria.dart';
import '../../../model/settings/setup/bi_account_model.dart';
import '../../../utils/constants/maps.dart';
import '../../../utils/constants/responsive.dart';
import '../../../utils/constants/styles.dart';
import '../../../utils/func/dates_controller.dart';
import '../../../widget/custom_date_picker.dart';
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
  DateTime? _selectedDate = DateTime.now();
  TextEditingController _fromDateController = TextEditingController();
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

  List<PieChartModel> pieData = [];

  List<BarChartData> barData = [];
  @override
  void initState() {
    getExpensesAccounts().then((value) {
      expensesAccounts = value;
      setState(() {});
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context);
    String todayDate = DatesController().formatDateReverse(
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
    getExpenses();
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CustomCard(
                  gradientColor: [Color(0xff1cacff), Color(0xff30c4ff)],
                  title: '42136',
                  subtitle: 'Mon-Fri',
                  label: 'Overall Sale',
                  icon:
                      Icons.attach_money, // Provide the actual path to the icon
                ),
                SizedBox(
                  width: 10,
                ),
                CustomCard(
                  gradientColor: [Color(0xfffd8236), Color(0xffffce6c)],
                  title: '1446',
                  subtitle: 'Mon-Fri',
                  label: 'Total Visited',
                  icon: Icons.abc, // Provide the actual path to the icon
                ),
                SizedBox(
                  width: 10,
                ),
                CustomCard(
                  gradientColor: [Color(0xff4741c1), Color(0xff7e4fe4)],
                  title: '61%',
                  subtitle: 'Mon-Fri',
                  label: 'Overall Growth',
                  icon: Icons.bar_chart, // Provide the actual path to the icon
                ),
              ],
            ),
            SizedBox(
              height: height * 0.1,
            ),
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
                height: isDesktop ? height * 0.6 : height * 0.5,
                decoration: borderDecoration,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            selectedChart == _locale.lineChart
                                ? _locale.lineChart
                                : selectedChart == _locale.pieChart
                                    ? _locale.pieChart
                                    : _locale.barChart,
                            style: const TextStyle(fontSize: 24),
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
              print(selectedChart);
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
                  print(selectedStatus);
                });
              },
            ),
            CustomDatePicker(
              label: _locale.fromDate,
              controller: _fromDateController,
              onSelected: (value) {
                setState(() {
                  _fromDateController.text = value;
                  getExpenses();
                  print(_fromDateController.text);
                });
              },
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
              getExpenses();
              print(selectedChart);
            });
          },
        ),
        CustomDropDown(
          width: widthMobile,
          items: status,
          label: _locale.status,
          initialValue: selectedStatus,
          onChanged: (value) {
            setState(() {
              selectedStatus = value.toString();

              getExpenses();
              print(selectedStatus);
            });
          },
        ),
        CustomDatePicker(
          label: _locale.fromDate,
          controller: _fromDateController,
          onSelected: (value) {
            setState(() {
              _fromDateController.text = value;
              getExpenses();
              print(_fromDateController.text);
            });
          },
        ),
      ],
    );
  }

  int count = 0;
  getExpenses() {
    listOfBalances = [];
    listOfPeriods = [];
    pieData = [];
    barData = [];
    count = 0;
    int status = getVoucherStatus(_locale, selectedStatus);
    String date = DatesController().formatDate(_fromDateController.text);
    SearchCriteria searchCriteria =
        SearchCriteria(fromDate: date, toDate: date, voucherStatus: status);

    expensesController.getExpense(searchCriteria).then((value) {
      for (var elemant in value) {
        String temp = DatesController().formatDate(getNextDay(date).toString());
        setState(() {
          listOfBalances.add(elemant.expense!);
          listOfPeriods.add(temp);
          pieData.add(PieChartModel(
              title: temp,
              value: double.parse(elemant.expense.toString()),
              color: getRandomColor()));
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

  Color getRandomColor() {
    final random = Random();
    final red = random.nextInt(256);
    final green = random.nextInt(256);
    final blue = random.nextInt(256);

    return Color.fromARGB(255, red, green, blue);
  }
}
