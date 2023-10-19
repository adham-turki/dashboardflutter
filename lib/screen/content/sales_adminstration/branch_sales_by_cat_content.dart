import 'dart:math';

import 'package:bi_replicate/model/chart/pie_chart_model.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../components/charts.dart';
import '../../../components/charts/pie_chart.dart';
import '../../../components/customCard.dart';
import '../../../controller/sales_adminstration/branch_controller.dart';
import '../../../controller/sales_adminstration/sales_category_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../model/bar_chart_data_model.dart';
import '../../../model/criteria/search_criteria.dart';
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
  DateTime? _selectedDate;
  DateTime? _selectedDate2;
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

  List<PieChartModel> pieData = [];

  List<BarChartData> barData = [];
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
                height: isDesktop ? height * 0.6 : height * 0.5,
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
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
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
                      print(selectedBranch);
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
                      print(selectedChart);
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
                      print(selectedPeriod);
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
                      print(selectedCategories);
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
                      getBranchByCat();
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
                      getBranchByCat();
                      print(_toDateController.text);
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
              print(selectedBranch);
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
              print(selectedChart);
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
              print(selectedPeriod);
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
              print(selectedCategories);
            });
          },
        ),
        CustomDatePicker(
          label: _locale.fromDate,
          controller: _fromDateController,
          onSelected: (value) {
            setState(() {
              _fromDateController.text = value;
              getBranchByCat();
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
              getBranchByCat();
              print(_toDateController.text);
            });
          },
        ),
      ],
    );
  }

  Color getRandomColor() {
    final random = Random();
    final red = random.nextInt(256);
    final green = random.nextInt(256);
    final blue = random.nextInt(256);

    return Color.fromARGB(255, red, green, blue);
  }

  void getBranchByCat() {
    listOfBalances = [];
    pieData = [];
    barData = [];
    int cat = byCategoryMap[selectedCategories]!;
    // selectedCategories == "Brands"
    //     ? 1
    //     : selectedCategories == "Categorie1"
    //         ? 2
    //         : selectedCategories == "Categorie2"
    //             ? 3
    //             : 4;
    String startDate = DatesController().formatDate(_fromDateController.text);
    String endDate = DatesController().formatDate(_toDateController.text);
    print("selectedBranch: ${selectedBranchCode}");
    SearchCriteria searchCriteria = SearchCriteria(
        fromDate: startDate,
        toDate: endDate,
        byCategory: cat,
        branch: selectedBranchCode);
    pieData = [];
    barData = [];
    listOfBalances = [];
    listOfPeriods = [];
    final random = Random();

    salesCategoryController.getSalesByCategory(searchCriteria).then((value) {
      for (var element in value) {
        // creditAmt - debitAmt
        double bal = element.creditAmt! - element.debitAmt!;

        // Generate a random color
        Color randomColor = getRandomColor(); // Use the getRandomColor function

        setState(() {
          listOfBalances.add(bal);
          listOfPeriods.add(element.categoryName!);
          pieData.add(PieChartModel(
              title: element.categoryName!,
              value: bal,
              color: randomColor)); // Set random color
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
