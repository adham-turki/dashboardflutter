import 'package:bi_replicate/components/charts/pie_chart.dart';
import 'package:bi_replicate/utils/constants/responsive.dart';
import 'package:bi_replicate/utils/constants/styles.dart';
import 'package:bi_replicate/widget/custom_date_picker.dart';
import 'package:bi_replicate/widget/drop_down/custom_dropdown.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../model/chart/pie_chart_model.dart';
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
        height: height,
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
                height: isDesktop ? height * 0.6 : height * 0.5,
                decoration: borderDecoration,
                child: Column(
                  children: [
                    Row(
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Chart Title",
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                      ],
                    ),
                    PieChartComponent(
                      radiusNormal: isDesktop ? 130 : 70,
                      radiusHover: isDesktop ? 140 : 80,
                      width: isDesktop ? 400 : width * 0.1,
                      height: isDesktop ? 450 : height * 0.4,
                      dataList: list,
                    ),
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
        CustomDropDown(
          items: periods,
          label: _locale.period,
          initialValue: selectedPeriod,
          onChanged: (value) {
            print(value);
          },
        ),
        CustomDatePicker(
          label: _locale.fromDate,
          controller: _fromDateController,
        ),
        CustomDatePicker(
          label: _locale.toDate,
          controller: _toDateController,
        ),
        CustomDropDown(
          items: charts,
          label: _locale.chartType,
          initialValue: selectedChart,
          onChanged: (value) {
            print(value);
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
          width: widthMobile,
          label: _locale.period,
          initialValue: selectedPeriod,
          onChanged: (value) {
            print(value);
          },
        ),
        CustomDatePicker(
          label: _locale.fromDate,
          controller: _fromDateController,
        ),
        CustomDatePicker(
          label: _locale.toDate,
          controller: _toDateController,
        ),
        CustomDropDown(
          width: widthMobile,
          label: _locale.chartType,
          initialValue: selectedChart,
          onChanged: (value) {
            print(value);
          },
        ),
      ],
    );
  }
}
