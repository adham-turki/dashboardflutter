import 'dart:math';

import 'package:bi_replicate/model/chart/pie_chart_model.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../../components/charts.dart';
import '../../../components/charts/pie_chart.dart';
import '../../../components/customCard.dart';
import '../../../controller/receivable_management/aging_controller.dart';
import '../../../model/bar_chart_data_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../model/criteria/search_criteria.dart';
import '../../../utils/constants/maps.dart';
import '../../../utils/constants/responsive.dart';
import '../../../utils/constants/styles.dart';
import '../../../widget/custom_date_picker.dart';
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

  List<PieChartModel> pieData = [];
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
    ;
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: width * 0.7,
                height: isDesktop ? height * 0.6 : height * 0.5,
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
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                          SizedBox(
                            // width: width * 0.4,
                            child: Text(
                              "${_locale.transactionBalance} = $balance",
                              style: twelve400TextStyle(Colors.black),
                            ),
                          ),
                          Stack(
                            children: [
                              Positioned(
                                right: 20,
                                bottom: 0,
                                child: SizedBox(
                                  width: 50,
                                  height: 0,
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton2(
                                      key: dropdownKey,
                                      isExpanded: true,
                                      iconStyleData: const IconStyleData(
                                        iconDisabledColor: Colors.transparent,
                                        iconEnabledColor: Colors.transparent,
                                      ),
                                      dropdownStyleData: DropdownStyleData(
                                        width: 120,
                                        padding: EdgeInsets.zero,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          color: Colors.white,
                                        ),
                                      ),
                                      items: items
                                          .map(
                                            (item) => DropdownMenuItem<String>(
                                              alignment: Alignment.center,
                                              value: item,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    item,
                                                    style: twelve400TextStyle(
                                                        Colors.black),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (value) {},
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    dropdownKey.currentState!.callTap();
                                  },
                                  child: const Icon(Icons.list)),
                            ],
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
                            ? BalancePieChart(data: pieData)
                            // Center(
                            //     child:
                            //     PieChartComponent(
                            //       radiusNormal: isDesktop ? height * 0.05 : 70,
                            //       radiusHover: isDesktop ? height * 0.05 : 80,
                            //       width: isDesktop ? width * 0.42 : width * 0.1,
                            //       height:
                            //           isDesktop ? height * 0.42 : height * 0.4,
                            //       dataList: pieData,
                            //     ),
                            //   )
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
                  print(selectedChart);
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
                  print(selectedStatus);
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

              getAgingReceivable();
              print(selectedStatus);
            });
          },
        ),
        // CustomDatePicker(
        //   label: _locale.fromDate,
        //   controller: _fromDateController,
        //   onSelected: (value) {
        //     setState(() {
        //       _fromDateController.text = value;
        //       getAgingReceivable();
        //       print(_fromDateController.text);
        //     });
        //   },
        // ),
      ],
    );
  }

  getAgingReceivable() {
    listOfBalances = [];
    pieData = [];
    barData = [];
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
        setState(() {
          listOfBalances.add(element.total!);
          pieData.add(PieChartModel(
              title: '', value: element.total!, color: getRandomColor()));
          barData.add(
            BarChartData('', element.total!),
          );
        });
      }
    });
  }

  Color getRandomColor() {
    final random = Random();
    final red = random.nextInt(256);
    final green = random.nextInt(256);
    final blue = random.nextInt(256);

    return Color.fromARGB(255, red, green, blue);
  }
}
