import 'dart:math';

import 'package:bi_replicate/model/chart/pie_chart_model.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import '../../../components/charts.dart';
import '../../../components/charts/pie_chart.dart';
import '../../../controller/receivable_management/aging_controller.dart';
import '../../../model/bar_chart_data_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../model/criteria/search_criteria.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/maps.dart';
import '../../../utils/constants/responsive.dart';
import '../../../utils/constants/styles.dart';
import '../../../widget/drop_down/custom_dropdown.dart';

class AgingReceivable extends StatefulWidget {
  const AgingReceivable({super.key});

  @override
  State<AgingReceivable> createState() => _AgingReceivableState();
}

class _AgingReceivableState extends State<AgingReceivable> {
  double width = 0;
  double height = 0;
  bool isDesktop = false;
  final dropdownKey = GlobalKey<DropdownButton2State>();
  late AppLocalizations _locale;
  List<String> status = [];
  List<String> charts = [];

  var selectedStatus = "";
  var selectedStatusCode = "";

  var selectedChart = "";
  double balance = 0;

  List<double> listOfBalances = [];
  List<String> listOfPeriods = [];

  final List<String> items = [
    'Print',
    'Save as JPEG',
    'Save as PNG',
  ];
  final dataMap = <String, double>{};

  List<PieChartModel> pieData = [];

  bool temp = false;
  @override
  void initState() {
    super.initState();
  }

  List<BarChartData> barData = [];
  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context);
    status = [
      _locale.all,
      _locale.posted,
      _locale.draft,
      _locale.canceled,
    ];
    listOfPeriods = [
      _locale.lessThan30Days,
      _locale.lessThan60Days,
      _locale.lessThan90Days,
      _locale.moreThan90Days
    ];
    charts = [
      _locale.lineChart,
      _locale.barChart,
      _locale.pieChart,
    ];

    // search();
    selectedChart = charts[0];
    selectedStatus = status[0];
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: width * 0.7,
                height: isDesktop ? height * 0.6 : height * 0.6,
                decoration: borderDecoration,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
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
                          SizedBox(
                            width: width * 0.4,
                            child: Text(
                              "${_locale.transactionBalance} = $balance",
                              style: twelve400TextStyle(Colors.black),
                            ),
                          ),
                        ],
                      ),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomDropDown(
              items: charts,
              label: _locale.chartType,
              initialValue: selectedChart,
              onChanged: (value) {
                setState(() {
                  selectedChart = value!;
                  getAgingReceivable();
                });
              },
            ),
            CustomDropDown(
              items: status,
              label: _locale.status,
              initialValue: selectedStatus,
              onChanged: (value) {
                setState(() {
                  selectedStatus = value.toString();

                  getAgingReceivable();
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
              getAgingReceivable();
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

              getAgingReceivable();
            });
          },
        ),
      ],
    );
  }

  double formatDoubleToTwoDecimalPlaces(double number) {
    return double.parse(number.toStringAsFixed(2));
  }

  getAgingReceivable() {
    listOfBalances = [];
    pieData = [];
    barData = [];
    dataMap.clear();
    int status = getVoucherStatus(_locale, selectedStatus);

    SearchCriteria searchCriteria = SearchCriteria(
      voucherStatus: status,
    );
    AgingController().getAgingList(searchCriteria).then((value) {
      setState(() {
        for (int i = 0; i < value.length; i++) {
          balance += value[i].total!;
        }
      });
      for (var element in value) {
        if (element.total != 0.0) {
          temp = true;
        } else if (element.total == 0.0) {
          temp = false;
        }
        setState(() {
          listOfBalances.add(element.total!);
          if (temp) {
            dataMap[""] = formatDoubleToTwoDecimalPlaces(element.total!);
            pieData.add(PieChartModel(
                title: '',
                value: formatDoubleToTwoDecimalPlaces(element.total!),
                color: getRandomColor(colorNewList)));
          }
          barData.add(
            BarChartData('', element.total!),
          );
        });
      }
    });
  }

  Color getRandomColor(List<Color> colorList) {
    final random = Random();
    final index = random.nextInt(colorList.length);
    return colorList[index];
  }
}
