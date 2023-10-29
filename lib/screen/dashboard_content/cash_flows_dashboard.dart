import 'dart:math';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:bi_replicate/model/criteria/search_criteria.dart';
import 'package:bi_replicate/utils/func/converters.dart';
import 'package:bi_replicate/widget/custom_date_picker.dart';

import '../../../controller/sales_adminstration/sales_branches_controller.dart';
import '../../../model/bar_chart_data_model.dart';
import '../../../model/chart/pie_chart_model.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/func/dates_controller.dart';
import '../../../widget/drop_down/custom_dropdown.dart';
import '../../components/charts.dart';
import '../../controller/financial_performance/cash_flow_controller.dart';
import '../../controller/settings/setup/accounts_name.dart';
import '../../model/settings/setup/bi_account_model.dart';
import '../../utils/constants/constants.dart';
import '../../utils/constants/maps.dart';
import '../../utils/constants/responsive.dart';

class CashFlowsDashboard extends StatefulWidget {
  List<BarData> barData;

  CashFlowsDashboard({
    Key? key,
    required this.barData,
  }) : super(key: key);

  @override
  _CashFlowsDashboardState createState() => _CashFlowsDashboardState();
}

class _CashFlowsDashboardState extends State<CashFlowsDashboard> {
  List<BarChartData> data = [];
  double width = 0;
  final dropdownKey = GlobalKey<DropdownButton2State>();
  double height = 0;
  bool temp = false;
  late AppLocalizations _locale;
  SalesBranchesController salesBranchesController = SalesBranchesController();

  final dataMap = <String, double>{};
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
  String todayDate1 = "";
  List<String> periods = [];
  var selectedPeriod = "";

  List<PieChartModel> pieData = [];

  CashFlowController cashFlowController = CashFlowController();

  List<String> status = [];

  var selectedStatus = "";

  double balance = 0;
  bool accountsActive = false;
  String accountNameString = "";

  List<BiAccountModel> cashboxAccounts = [];

  bool isDesktop = false;
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

    selectedPeriod = periods[0];
    selectedStatus = status[0];
    super.didChangeDependencies();
  }

  @override
  void initState() {
    getCashBoxAccount(isStart: true).then((value) {
      cashboxAccounts = value;
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    isDesktop = Responsive.isDesktop(context);
    return SingleChildScrollView(
      child: Container(
        // height: height * 1.7,
        decoration: const BoxDecoration(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                // width: width * 0.7,
                // height: isDesktop ? height * 0.6 : height * 0.6,
                // decoration: borderDecoration,
                height: isDesktop ? height * 0.65 : height * 1.2,

                width: double.infinity,
                padding: EdgeInsets.all(appPadding),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          _locale.cashFlows,
                          style: TextStyle(fontSize: isDesktop ? 24 : 18),
                        ),
                      ],
                    ),
                    //    isDesktop ? desktopCriteria() : mobileCriteria(),
                    CustomBarChart(
                      data: widget.barData,
                      color: Colors.orange,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color getRandomColor(List<Color> colorList) {
    final random = Random();
    final index = random.nextInt(colorList.length);
    return colorList[index];
  }
}
