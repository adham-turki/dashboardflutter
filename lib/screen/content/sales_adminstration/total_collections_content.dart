import 'dart:math';
import 'package:bi_replicate/components/charts/pie_chart.dart';
import 'package:bi_replicate/model/criteria/search_criteria.dart';
import 'package:bi_replicate/utils/constants/responsive.dart';
import 'package:bi_replicate/utils/constants/styles.dart';
import 'package:bi_replicate/widget/custom_date_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:pie_chart/pie_chart.dart';
import '../../../widget/drop_down/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../components/charts.dart';
import '../../../controller/sales_adminstration/total_collection_controller.dart';
import '../../../model/bar_chart_data_model.dart';
import '../../../model/chart/pie_chart_model.dart';
import '../../../utils/constants/maps.dart';
import '../../../utils/func/dates_controller.dart';

class TotalCollectionsContent extends StatefulWidget {
  const TotalCollectionsContent({super.key});

  @override
  State<TotalCollectionsContent> createState() =>
      _TotalCollectionsContentState();
}

class _TotalCollectionsContentState extends State<TotalCollectionsContent> {
  double width = 0;
  double height = 0;
  bool isDesktop = false;
  final dropdownKey = GlobalKey<DropdownButton2State>();
  late AppLocalizations _locale;
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();
  var storage = const FlutterSecureStorage();
  TotalCollectionConroller totalCollectionController =
      TotalCollectionConroller();
  List<String> periods = [];
  List<String> status = [];
  List<String> charts = [];

  var selectedStatus = "";

  var selectedPeriod = "";
  var selectedChart = "";

  List<double> listOfBalances = [];
  List<String> listOfPeriods = [];

  final List<String> items = [
    'Print',
    'Save as JPEG',
    'Save as PNG',
  ];
  final dataMap = <String, double>{};

  final colorList = <Color>[
    Colors.green,
    Colors.blue,
    Colors.red,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.teal,
    Colors.amber,
    Colors.cyan,
    Colors.deepPurple,
    Colors.lime,
    Colors.indigo,
    Colors.lightBlue,
    Colors.deepOrange,
    Colors.brown,
  ];

  List<PieChartModel> pieData = [];

  List<BarChartData> barData = [];

  bool boolTemp = false;
  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context);
    String todayDate = DatesController().formatDateReverse(
        DatesController().formatDate(DatesController().todayDate()));
    String nextMonth = DatesController().formatDateReverse(DatesController()
        .formatDate(DateTime(DatesController().today.year,
                DatesController().today.month + 1, DatesController().today.day)
            .toString()));
    _fromDateController.text = todayDate;
    _toDateController.text = nextMonth;

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
    getTotalCollections();
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
                            ? Container(
                                height: height * 0.4,
                                width: width * 0.4,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: dataMap.isNotEmpty
                                    ? PieChart(
                                        dataMap: dataMap,
                                        chartType: ChartType.disc,
                                        baseChartColor: Colors.grey[300]!,
                                        colorList: colorList,
                                      )
                                    : const Center(
                                        child: Text(
                                          "Pie Chart is Empty!",
                                          style: TextStyle(fontSize: 24),
                                        ),
                                      ),
                              )
                            //  Center(
                            //     child: PieChartComponent(
                            //       radiusNormal: isDesktop ? height * 0.17 : 70,
                            //       radiusHover: isDesktop ? height * 0.17 : 80,
                            //       width:
                            //           isDesktop ? width * 0.42 : width * 0.05,
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
                      getTotalCollections();
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
                      getTotalCollections();
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
                      getTotalCollections();
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
                      getTotalCollections();
                    });
                  },
                ),
                CustomDatePicker(
                  label: _locale.toDate,
                  controller: _toDateController,
                  onSelected: (value) {
                    setState(() {
                      _toDateController.text = value;
                      getTotalCollections();
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
              getTotalCollections();
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
              getTotalCollections();
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
              getTotalCollections();
            });
          },
        ),
        CustomDatePicker(
          label: _locale.fromDate,
          controller: _fromDateController,
          onSelected: (value) {
            setState(() {
              _fromDateController.text = value;
              getTotalCollections();
            });
          },
        ),
        CustomDatePicker(
          label: _locale.toDate,
          controller: _toDateController,
          onSelected: (value) {
            setState(() {
              _toDateController.text = value;
              getTotalCollections();
            });
          },
        ),
      ],
    );
  }

  double formatDoubleToTwoDecimalPlaces(double number) {
    return double.parse(number.toStringAsFixed(2));
  }

  getTotalCollections() {
    listOfBalances = [];
    pieData = [];
    barData = [];

    int status = getVoucherStatus(_locale, selectedStatus);

    String startDate = DatesController().formatDate(_fromDateController.text);
    String endDate = DatesController().formatDate(_toDateController.text);
    SearchCriteria searchCriteria = SearchCriteria(
        fromDate: startDate, toDate: endDate, voucherStatus: status);

    totalCollectionController
        .getTotalCollectionMethod(searchCriteria)
        .then((value) {
      for (var element in value) {
        if (element.collection != 0.0) {
          boolTemp = true;
        } else if (element.collection == 0.0) {
          boolTemp = false;
        }
        setState(() {
          listOfBalances.add(element.collection!);
          listOfPeriods.add(element.name!);
          if (boolTemp) {
            dataMap[element.name!] =
                formatDoubleToTwoDecimalPlaces(element.collection!);
            pieData.add(PieChartModel(
                title: element.name!,
                value: formatDoubleToTwoDecimalPlaces(element.collection!),
                color: getRandomColor()));
          }

          barData.add(
            BarChartData(element.name!, element.collection!),
          );
        });
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

  Color getRandomColor() {
    final random = Random();
    final red = random.nextInt(256);
    final green = random.nextInt(256);
    final blue = random.nextInt(256);

    return Color.fromARGB(255, red, green, blue);
  }
}
