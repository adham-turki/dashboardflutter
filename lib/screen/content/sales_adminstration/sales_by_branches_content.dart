import 'dart:math';
import 'package:bi_replicate/components/charts/pie_chart.dart';
import 'package:bi_replicate/model/criteria/search_criteria.dart';
import 'package:bi_replicate/utils/constants/responsive.dart';
import 'package:bi_replicate/utils/constants/styles.dart';
import 'package:bi_replicate/widget/custom_date_picker.dart';
import '../../../controller/sales_adminstration/sales_branches_controller.dart';
import '../../../utils/func/converters.dart';
import '../../../widget/drop_down/custom_dropdown.dart';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../components/charts.dart';
import '../../../components/customCard.dart';
import '../../../controller/sales_adminstration/total_collection_controller.dart';
import '../../../model/bar_chart_data_model.dart';
import '../../../model/chart/pie_chart_model.dart';
import '../../../utils/constants/maps.dart';
import '../../../utils/func/dates_controller.dart';

class SalesByBranchesContent extends StatefulWidget {
  const SalesByBranchesContent({super.key});

  @override
  State<SalesByBranchesContent> createState() => _SalesByBranchesContentState();
}

class _SalesByBranchesContentState extends State<SalesByBranchesContent> {
  double width = 0;
  double height = 0;
  late AppLocalizations _locale;
  SalesBranchesController salesBranchesController = SalesBranchesController();
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();

  List<PieChartModel> list = [
    PieChartModel(value: 10, title: "1", color: Colors.blue),
    PieChartModel(value: 20, title: "2", color: Colors.red),
    PieChartModel(value: 30, title: "3", color: Colors.green),
    PieChartModel(value: 40, title: "4", color: Colors.purple),
  ];
  List<double> listOfBalances = [];
  List<String> listOfPeriods = [];

  final List<String> items = [
    'Print',
    'Save as JPEG',
    'Save as PNG',
  ];
  DateTime? _selectedDate;
  DateTime? _selectedDate2;
  List<String> periods = [];
  List<String> charts = [];
  var selectedPeriod = "";
  var selectedChart = "";
  List<BarChartData> barData = [];
  List<PieChartModel> pieData = [];

  bool isDesktop = false;

  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context);
    String todayDate = DatesController().formatDateReverse(
        DatesController().formatDate(DatesController().todayDate()));
    _fromDateController.text = todayDate;
    _toDateController.text = todayDate;
    periods = [
      _locale.daily,
      _locale.weekly,
      _locale.monthly,
      _locale.yearly,
    ];
    charts = [_locale.lineChart, _locale.pieChart, _locale.barChart];
    selectedChart = charts[0];
    selectedPeriod = periods[0];
    getSalesByBranch();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
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

  Future getSalesByBranch() async {
    SearchCriteria searchCriteria = SearchCriteria(
        fromDate: DatesController().formatDate(_fromDateController.text),
        toDate: DatesController().formatDate(_toDateController.text),
        voucherStatus: -100);
    pieData = [];
    barData = [];
    listOfBalances = [];
    listOfPeriods = [];
    salesBranchesController.getSalesByBranches(searchCriteria).then((value) {
      for (var element in value) {
        double a = (element.totalSales! + element.retSalesDis!) -
            (element.salesDis! + element.totalReturnSales!);
        a = Converters().formateDouble(a);
        print("name: ${element.namee!}");
        print("double: $a");
        setState(() {
          listOfBalances.add(a);
          listOfPeriods.add(element.namee!);

          pieData.add(PieChartModel(
              title: element.namee!, value: a, color: Colors.blue));
          barData.add(
            BarChartData(element.namee!, a),
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

  Row desktopCriteria() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CustomDropDown(
          items: periods,
          label: _locale.period,
          initialValue: selectedPeriod,
          hint: "",
          onChanged: (value) {
            setState(() {
              checkPeriods(value);
              selectedPeriod = value!;
              getSalesByBranch();
              print(selectedPeriod);
            });
          },
        ),
        CustomDatePicker(
          label: _locale.fromDate,
          controller: _fromDateController,
          onSelected: (value) {
            setState(() {
              _fromDateController.text = value;
              getSalesByBranch();
              print(_fromDateController.text);
            });
          },
        ),
        CustomDatePicker(
          label: _locale.toDate,
          controller: _toDateController,
          onSelected: (value) {
            setState(() {
              _toDateController.text = value;
              getSalesByBranch();
              print(_toDateController.text);
            });
          },
        ),
        CustomDropDown(
          items: charts,
          hint: "",
          label: _locale.chartType,
          initialValue: selectedChart,
          onChanged: (value) {
            setState(() {
              selectedChart = value!;
              getSalesByBranch();
              print(selectedChart);
            });
          },
        ),
      ],
    );
  }

  Column mobileCriteria() {
    double widthMobile = width;
    return Column(
      children: [
        CustomDropDown(
          items: periods,
          width: widthMobile,
          label: _locale.period,
          initialValue: selectedPeriod,
          hint: "",
          onChanged: (value) {
            setState(() {
              checkPeriods(value);
              selectedPeriod = value!;
              print(selectedPeriod);
            });
          },
        ),
        CustomDatePicker(
          label: _locale.fromDate,
          controller: _fromDateController,
          onSelected: (value) {
            setState(() {
              _fromDateController.text = value;
              print(_fromDateController.text);
            });
          },
        ),
        CustomDatePicker(
          label: _locale.toDate,
          controller: _toDateController,
          onSelected: (value) {
            setState(() {
              _toDateController.text = value;
              print(_toDateController.text);
            });
          },
        ),
        CustomDropDown(
          items: charts,
          width: widthMobile,
          label: _locale.chartType,
          initialValue: selectedChart,
          hint: "",
          onChanged: (value) {
            setState(() {
              selectedChart = value!;
              print(selectedChart);
            });
          },
        ),
      ],
    );
  }
}
