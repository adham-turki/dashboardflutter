import 'dart:math';

import 'package:bi_replicate/model/chart/pie_chart_model.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pie_chart/pie_chart.dart';
import '../../../components/charts.dart';
import '../../../components/charts/pie_chart.dart';
import '../../../controller/sales_adminstration/branch_controller.dart';
import '../../../controller/sales_adminstration/sales_category_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../model/bar_chart_data_model.dart';
import '../../../model/criteria/search_criteria.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/maps.dart';
import '../../../utils/constants/responsive.dart';
import '../../../utils/constants/styles.dart';
import '../../../utils/func/dates_controller.dart';
import '../../../widget/custom_date_picker.dart';
import '../../../widget/drop_down/custom_dropdown.dart';

class BranchSalesByCatContent extends StatefulWidget {
  const BranchSalesByCatContent({super.key});

  @override
  State<BranchSalesByCatContent> createState() =>
      _BranchSalesByCatContentState();
}

class _BranchSalesByCatContentState extends State<BranchSalesByCatContent> {
  double width = 0;
  double height = 0;
  bool isDesktop = false;
  final storage = const FlutterSecureStorage();
  final dropdownKey = GlobalKey<DropdownButton2State>();

  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();
  SalesCategoryController salesCategoryController = SalesCategoryController();
  BranchController branchController = BranchController();
  late AppLocalizations _locale;
  List<String> periods = [];
  List<String> charts = [];
  List<String> branches = [];

  var selectedBranch = "";
  var selectedChart = "";

  var selectedPeriod = "";
  var selectedCategories = "Brands";
  var selectedBranchCode = "";

  List<double> listOfBalances = [];
  List<String> listOfPeriods = [];

  final List<String> items = [
    'Print',
    'Save as JPEG',
    'Save as PNG',
  ];
  final List<String> categories = [
    "Brands",
    "Categorie1",
    "Categorie2",
    "Classification"
  ];
  final dataMap = <String, double>{};

  List<PieChartModel> pieData = [];

  List<BarChartData> barData = [];
  String todayDate = "";

  bool temp = false;
  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context);
    todayDate = DatesController().formatDateReverse(
        DatesController().formatDate(DatesController().todayDate()));
    _fromDateController.text = todayDate;
    _toDateController.text = todayDate;
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
    branches = [_locale.all];
    selectedBranch = branches[0];
    selectedChart = charts[0];
    selectedPeriod = periods[0];
    getBranchByCat();

    super.didChangeDependencies();
  }

  @override
  void initState() {
    getBranch();
    // fromDate.addListener(() {});
    // toDate.addListener(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    isDesktop = Responsive.isDesktop(context);

    return SingleChildScrollView(
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
                                    isDesktop ? height * 0.42 : height * 0.3,
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
    );
  }

  void getBranch() async {
    branchController.getBranch().then((value) {
      value.forEach((k, v) {
        if (mounted) {
          setState(() {
            branches.add(k);
          });
        }
      });
      setBranchesMap(_locale, value);
    });
  }

  void checkPeriods(value) {
    if (value == periods[0]) {
      _fromDateController.text = DatesController().todayDate().toString();
      _toDateController.text = DatesController().todayDate().toString();
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
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomDropDown(
                  items: branches,
                  label: _locale.branch,
                  initialValue: selectedBranch,
                  onChanged: (value) {
                    setState(() {
                      selectedBranch = value.toString();
                      selectedBranchCode = branchesMap[value.toString()]!;
                      getBranchByCat();
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
                      getBranchByCat();
                    });
                  },
                ),
                CustomDropDown(
                  items: periods,
                  label: _locale.period,
                  initialValue: selectedPeriod,
                  onChanged: (value) {
                    setState(() {
                      checkPeriods(value);
                      selectedPeriod = value!;
                      getBranchByCat();
                    });
                  },
                ),
                CustomDropDown(
                  items: categories,
                  label: _locale.byCategory,
                  initialValue: selectedCategories,
                  onChanged: (value) {
                    setState(() {
                      selectedCategories = value!;
                      getBranchByCat();
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
                  date: DateTime.parse(_toDateController.text),
                  onSelected: (value) {
                    setState(() {
                      _fromDateController.text = value;
                      getBranchByCat();
                    });
                  },
                ),
                CustomDatePicker(
                  label: _locale.toDate,
                  controller: _toDateController,
                  date: DateTime.parse(_fromDateController.text),
                  onSelected: (value) {
                    setState(() {
                      _toDateController.text = value;
                      getBranchByCat();
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
          items: branches,
          label: _locale.branch,
          initialValue: selectedBranch,
          onChanged: (value) {
            setState(() {
              selectedBranch = value.toString();
              selectedBranchCode = branchesMap[value.toString()]!;
              getBranchByCat();
            });
          },
        ),
        CustomDropDown(
          width: widthMobile,
          items: charts,
          label: _locale.chartType,
          initialValue: selectedChart,
          onChanged: (value) {
            setState(() {
              selectedChart = value!;
              getBranchByCat();
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
              getBranchByCat();
            });
          },
        ),
        CustomDropDown(
          width: widthMobile,
          items: categories,
          label: _locale.byCategory,
          initialValue: selectedCategories,
          onChanged: (value) {
            setState(() {
              selectedCategories = value!;
              getBranchByCat();
            });
          },
        ),
        CustomDatePicker(
          label: _locale.fromDate,
          controller: _fromDateController,
          date: DateTime.parse(_toDateController.text),
          onSelected: (value) {
            setState(() {
              _fromDateController.text = value;
              getBranchByCat();
            });
          },
        ),
        CustomDatePicker(
          label: _locale.toDate,
          controller: _toDateController,
          date: DateTime.parse(_fromDateController.text),
          onSelected: (value) {
            setState(() {
              _toDateController.text = value;
              getBranchByCat();
            });
          },
        ),
      ],
    );
  }

  Color getRandomColor(List<Color> colorList) {
    final random = Random();
    final index = random.nextInt(colorList.length);
    return colorList[index];
  }

  double formatDoubleToTwoDecimalPlaces(double number) {
    return double.parse(number.toStringAsFixed(2));
  }

  void getBranchByCat() {
    listOfBalances = [];
    pieData = [];
    barData = [];
    dataMap.clear();
    int cat = byCategoryMap[selectedCategories]!;
    // selectedCategories == "Brands"
    //     ? 1
    //     : selectedCategories == "Categorie1"
    //         ? 2
    //         : selectedCategories == "Categorie2"
    //             ? 3
    //             : 4;
    if (_fromDateController.text.isEmpty || _toDateController.text.isEmpty) {
      setState(() {
        if (_fromDateController.text.isEmpty) {
          _fromDateController.text = todayDate;
        }
        if (_toDateController.text.isEmpty) {
          _toDateController.text = todayDate;
        }
      });
    }
    String startDate = DatesController().formatDate(_fromDateController.text);
    String endDate = DatesController().formatDate(_toDateController.text);
    SearchCriteria searchCriteria = SearchCriteria(
        fromDate: startDate,
        toDate: endDate,
        byCategory: cat,
        branch: selectedBranchCode);
    pieData = [];
    barData = [];
    listOfBalances = [];
    listOfPeriods = [];

    // print("ddddddddddd");
    salesCategoryController.getSalesByCategory(searchCriteria).then((value) {
      for (var element in value) {
        // creditAmt - debitAmt
        double bal = element.creditAmt! - element.debitAmt!;

        // Generate a random color
        Color randomColor =
            getRandomColor(colorNewList); // Use the getRandomColor function
        if (bal != 0.0) {
          temp = true;
        } else if (bal == 0.0) {
          temp = false;
        }
        setState(() {
          listOfBalances.add(bal);
          listOfPeriods.add(element.categoryName!);
          if (temp) {
            dataMap[element.categoryName!] =
                formatDoubleToTwoDecimalPlaces(bal);

            pieData.add(PieChartModel(
                title: element.categoryName!,
                value: formatDoubleToTwoDecimalPlaces(bal),
                color: randomColor)); // Set random color
            // print("asdasd: ${pieData.length}");
          }

          barData.add(
            BarChartData(
              element.categoryName!,
              bal,
            ), // Set random color
          );
        });
      }
    });
  }
}
