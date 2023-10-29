import 'dart:math';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:bi_replicate/model/criteria/search_criteria.dart';
import 'package:bi_replicate/utils/func/converters.dart';

import '../../../controller/sales_adminstration/sales_branches_controller.dart';
import '../../../model/chart/pie_chart_model.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/func/dates_controller.dart';
import '../../components/charts.dart';
import '../../utils/constants/constants.dart';
import '../../utils/constants/responsive.dart';

class BalanceBarChartDashboard extends StatefulWidget {
  // TextEditingController fromDateController;
  // TextEditingController toDateController;
  // String selectedPeriod;
  List<BarData> barData;

  BalanceBarChartDashboard({
    Key? key,
    // required this.fromDateController,
    // required this.toDateController,
    // required this.selectedPeriod,
    required this.barData,
  }) : super(key: key);

  @override
  _BalanceBarChartDashboardState createState() =>
      _BalanceBarChartDashboardState();
}

class _BalanceBarChartDashboardState extends State<BalanceBarChartDashboard> {
  List<CustomBarChart> data = [];
  double width = 0;
  final dropdownKey = GlobalKey<DropdownButton2State>();
  double height = 0;
  bool temp = false;
  SalesBranchesController salesBranchesController = SalesBranchesController();

  late AppLocalizations _locale;
  TextEditingController fromCont = TextEditingController();
  TextEditingController toCont = TextEditingController();

  final dataMap = <String, double>{};

  List<double> listOfBalances = [];
  List<String> listOfPeriods = [];

  String todayDate = "";
  // var selectedPeriod = "";

  // List<BarData> barData = [];
  List<PieChartModel> pieData = [];

  bool isDesktop = false;

  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context);
    todayDate = DatesController().formatDateReverse(
        DatesController().formatDate(DatesController().todayDate()));
    // fromCont.text = todayDate;
    // toCont.text = todayDate;

    print("in bar :${fromCont.text}");

    //  getSalesByBranch();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    print("inistiate fromDate :${fromCont.text}");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("inBuild fromcot :${fromCont.text}");
    // fromCont = widget.fromDateController;
    // toCont = widget.toDateController;

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    isDesktop = Responsive.isDesktop(context);
    print("bardata build :${widget.barData.length}");
    // getSalesByBranch();
    print("******************************");
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
                height: isDesktop ? height * 0.75 : height * 1.1,
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
                          _locale.salesByBranches,
                          style: TextStyle(fontSize: isDesktop ? 24 : 18),
                        ),
                      ],
                    ),
                    CustomBarChart(
                      data: widget.barData,
                      color: Colors.indigo,
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

  double formatDoubleToTwoDecimalPlaces(double number) {
    return double.parse(number.toStringAsFixed(2));
  }

  Color getRandomColor(List<Color> colorList) {
    final random = Random();
    final index = random.nextInt(colorList.length);
    return colorList[index];
  }
}
