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
import '../../controller/sales_adminstration/sales_category_controller.dart';
import '../../controller/settings/setup/accounts_name.dart';
import '../../model/settings/setup/bi_account_model.dart';
import '../../utils/constants/app_utils.dart';
import '../../utils/constants/constants.dart';
import '../../utils/constants/maps.dart';
import '../../utils/constants/responsive.dart';
import 'filter_dialog/filter_dialog_sales_by_cat.dart';

class BranchesSalesByCatDashboard extends StatefulWidget {
  BranchesSalesByCatDashboard({
    Key? key,
  }) : super(key: key);

  @override
  _BranchesSalesByCatDashboardState createState() =>
      _BranchesSalesByCatDashboardState();
}

class _BranchesSalesByCatDashboardState
    extends State<BranchesSalesByCatDashboard> {
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
  List<BarData> barData = [];

  List<PieChartModel> pieData = [];

  CashFlowController cashFlowController = CashFlowController();

  //List<String> status = [];
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  var period = "";
  var statusVar = ""; //not required
  String todayDate = "";
  var selectedCategories = "";
  var selectedBranchCode = "";

  double balance = 0;
  bool accountsActive = false;
  String accountNameString = "";
  final usedColors = <Color>[];

  List<BiAccountModel> cashboxAccounts = [];
  SalesCategoryController salesCategoryController = SalesCategoryController();

  bool isDesktop = false;
  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context);

    periods = [
      _locale.daily,
      _locale.weekly,
      _locale.monthly,
      _locale.yearly,
    ];

    selectedPeriod = periods[0];
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
                height: isDesktop ? height * 0.65 : height * 0.69,

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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _locale.branchesSalesByCategories,
                          style: TextStyle(fontSize: isDesktop ? 24 : 18),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0.0, vertical: 0),
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width < 800
                                  ? MediaQuery.of(context).size.width * 0.06
                                  : MediaQuery.of(context).size.width * 0.03,
                              child: blueButton1(
                                icon: Icon(
                                  Icons.filter_list_sharp,
                                  color: whiteColor,
                                  size: isDesktop
                                      ? height * 0.039
                                      : height * 0.03,
                                ),
                                // text: _locale.filter,
                                textColor: Color.fromARGB(255, 255, 255, 255),
                                //   borderRadius: 5.0,
                                height:
                                    isDesktop ? height * .015 : height * .03,
                                fontSize:
                                    isDesktop ? height * .018 : height * .017,
                                width: isDesktop ? width * 0.13 : width * 0.25,
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return FilterDialogSalesByCategory(
                                        onFilter: (selectedPeriodF,
                                            fromDate,
                                            toDate,
                                            selectedCategoriesF,
                                            selectedBranchCodeF) {
                                          fromDateController.text = fromDate;
                                          toDateController.text = toDate;
                                          selectedCategories =
                                              selectedCategoriesF;
                                          selectedBranchCode =
                                              selectedBranchCodeF;
                                          selectedPeriod = selectedPeriodF;
                                        },
                                      );
                                    },
                                  ).then((value) async {
                                    getBranchByCat().then((value) {
                                      setState(() {});
                                    });
                                  });
                                },
                              )),
                        ),
                      ],
                    ),
                    //    isDesktop ? desktopCriteria() : mobileCriteria(),
                    CustomBarChart(
                      data: barData,
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

  double formatDoubleToTwoDecimalPlaces(double number) {
    return double.parse(number.toStringAsFixed(2));
  }

  Future getBranchByCat({bool? isStart}) async {
    listOfBalances = [];
    pieData = [];
    barData = [];
    dataMap.clear();
    int cat = getCategoryNum(selectedCategories, _locale);
    if (fromDateController.text.isEmpty || toDateController.text.isEmpty) {
      if (fromDateController.text.isEmpty) {
        fromDateController.text = todayDate;
      }
      if (toDateController.text.isEmpty) {
        toDateController.text = todayDate;
      }
    }

    SearchCriteria searchCriteria = SearchCriteria(
        fromDate: fromDateController.text.isEmpty
            ? todayDate
            : fromDateController.text,
        toDate:
            toDateController.text.isEmpty ? todayDate : toDateController.text,
        byCategory: cat,
        branch: selectedBranchCode);
    pieData = [];
    barData = [];
    listOfBalances = [];
    listOfPeriods = [];

    // print("ddddddddddd");
    await salesCategoryController
        .getSalesByCategory(searchCriteria, isStart: isStart)
        .then((value) {
      for (var element in value) {
        // creditAmt - debitAmt
        double bal = element.creditAmt! - element.debitAmt!;

        // Generate a random color
        Color randomColor = getRandomColor(
            colorNewList, usedColors); // Use the getRandomColor function
        if (bal != 0.0) {
          temp = true;
        } else if (bal == 0.0) {
          temp = false;
        }
        listOfBalances.add(bal);
        listOfPeriods.add(element.categoryName!);
        if (temp) {
          dataMap[element.categoryName!] = formatDoubleToTwoDecimalPlaces(bal);

          pieData.add(PieChartModel(
              title: element.categoryName! == ""
                  ? _locale.general
                  : "${element.categoryName!}",
              value: formatDoubleToTwoDecimalPlaces(bal),
              color: randomColor)); // Set random color
          // print("asdasd: ${pieData.length}");
        }

        barData.add(
          BarData(
            name: element.categoryName! == ""
                ? _locale.general
                : element.categoryName!,
            percent: bal,
          ), // Set random color
        );

        print("bardata Length :${barData.length}");
      }
    });
  }
}
