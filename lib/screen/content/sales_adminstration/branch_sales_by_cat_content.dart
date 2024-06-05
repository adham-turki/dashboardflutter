import 'dart:convert';
import 'dart:math';
import 'package:bi_replicate/model/chart/pie_chart_model.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';
import '../../../components/charts.dart';
import '../../../components/charts/pie_chart.dart';
import '../../../components/custom_date.dart';
import '../../../controller/error_controller.dart';
import '../../../controller/sales_adminstration/branch_controller.dart';
import '../../../controller/sales_adminstration/sales_category_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../controller/settings/user_settings/code_reports_controller.dart';
import '../../../controller/settings/user_settings/user_report_settings_controller.dart';
import '../../../model/bar_chart_data_model.dart';
import '../../../model/criteria/search_criteria.dart';
import '../../../model/settings/user_settings/code_reports_model.dart';
import '../../../model/settings/user_settings/user_report_settings.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/maps.dart';
import '../../../utils/constants/pages_constants.dart';
import '../../../utils/constants/responsive.dart';
import '../../../utils/constants/styles.dart';
import '../../../utils/func/dates_controller.dart';
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

  // final TextEditingController _fromDateDayController = TextEditingController();
  // final TextEditingController _fromDateMonthController =
  //     TextEditingController();
  // final TextEditingController _fromDateYearController = TextEditingController();
  // final TextEditingController _toDateDayController = TextEditingController();
  // final TextEditingController _toDateMonthController = TextEditingController();
  // final TextEditingController _toDateYearController = TextEditingController();
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
  var selectedCategories = "";
  var selectedBranchCode = "";

  List<double> listOfBalances = [];
  List<String> listOfPeriods = [];
  List<CodeReportsModel> codeReportsList = [];
  List<UserReportSettingsModel> userReportSettingsList = [];
  String startSearchCriteria = "";
  String currentPageName = "";
  String currentPageCode = "";
  SearchCriteria? searchCriteriaa;
  String txtKey = "";
  final List<String> items = [
    'Print',
    'Save as JPEG',
    'Save as PNG',
  ];
  List<String> categories = [];
  final dataMap = <String, double>{};

  List<PieChartModel> pieData = [];

  List<BarChartData> barData = [];
  String todayDate = "";

  bool temp = false;
  final usedColors = <Color>[];
  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context)!;
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
    categories = [
      _locale.brands,
      _locale.categories("1"),
      _locale.categories("2"),
      _locale.classifications
    ];
    branches = [_locale.all];
    selectedBranch = branches[0];
    selectedChart = charts[0];
    selectedPeriod = periods[0];
    selectedCategories = categories[1];
    // getBranchByCat(isStart: true);
    getAllCodeReports();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    getBranch(isStart: true);
    // _fromDateController.addListener(() {});
    // _toDateController.addListener(() {});
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
            width: isDesktop ? width * 0.7 : width * 0.9,
            decoration: borderDecoration,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: isDesktop ? desktopCriteria() : mobileCriteria(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: isDesktop ? width * 0.7 : width * 0.9,
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

  void getBranch({bool? isStart}) async {
    branchController.getBranch(isStart: isStart).then((value) {
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

  String createUuid() {
    var uuid = const Uuid();
    return uuid.v4();
  }

  setStartSearchCriteria() {
    for (var i = 0; i < userReportSettingsList.length; i++) {
      if (currentPageCode == userReportSettingsList[i].txtReportcode) {
        txtKey = userReportSettingsList[i].txtKey;
        startSearchCriteria = userReportSettingsList[i].txtJsoncrit;
        // Adding double quotes around keys and values to make it valid JSON
        startSearchCriteria = startSearchCriteria
            .replaceAllMapped(RegExp(r'(\w+):\s*([\w-]+|)(?=,|\})'), (match) {
          if (match.group(1) == "fromDate" ||
              match.group(1) == "toDate" ||
              match.group(1) == "branch") {
            print(match.group(1));
            return '"${match.group(1)}":"${match.group(2)!.isEmpty ? "" : match.group(2)!}"';
          } else {
            return '"${match.group(1)}":${match.group(2)}';
          }
        });

        // Removing the extra curly braces
        startSearchCriteria =
            startSearchCriteria.replaceAll('{', '').replaceAll('}', '');

        // Wrapping the string with curly braces to make it a valid JSON object
        startSearchCriteria = '{$startSearchCriteria}';
        print(
            "startSearchCriteriastartSearchCriteria2222222: ${startSearchCriteria}");

        searchCriteriaa =
            SearchCriteria.fromJson(json.decode(startSearchCriteria));
        _fromDateController.text =
            DatesController().formatDateReverse(searchCriteriaa!.fromDate!);
        _toDateController.text =
            DatesController().formatDateReverse(searchCriteriaa!.toDate!);
        // selectedBranchCode = searchCriteriaa!.branch!;
        // selectedBranchCode = searchCriteriaa!.byCategory!;

        print(
            "startSearchCriteriastartSearchCriteria: ${searchCriteriaa!.fromDate}");
      }
    }
  }

  getAllCodeReports() {
    CodeReportsController().getAllCodeReports().then((value) {
      if (value.isNotEmpty) {
        setState(() {
          codeReportsList = value;
          setPageName();
          if (currentPageName.isNotEmpty) {
            getAllUserReportSettings();
          }

          print("codeReportsList Length: ${codeReportsList.length}");
        });
      }
    });
  }

  getAllUserReportSettings() {
    UserReportSettingsController().getAllUserReportSettings().then((value) {
      setState(() {
        userReportSettingsList = value;
        setStartSearchCriteria();
        getBranchByCat(isStart: true);
      });
    });
  }

  setPageName() {
    for (var i = 0; i < codeReportsList.length; i++) {
      if (codeReportsList[i].txtReportnamee ==
          ReportConstants.branchesSalesByCategories) {
        setState(() {
          currentPageName = codeReportsList[i].txtReportnamee;
          currentPageCode = codeReportsList[i].txtReportcode;
          // print("codeReportsList[i]: ${codeReportsList[i].toJson()}");
        });
      }
    }
  }

  void setSearchCriteria(SearchCriteria searchCriteria) {
    print(
        "searchCriteria.toJson().toString(): ${searchCriteria.toJson().toString()}");
    print("currentPageCode: ${currentPageCode}");
    String search = "${searchCriteria.toJson()}";
    UserReportSettingsModel userReportSettingsModel = UserReportSettingsModel(
        txtKey: txtKey,
        txtReportcode: currentPageCode,
        txtUsercode: "",
        txtJsoncrit: searchCriteria.toJson().toString(),
        bolAutosave: 1);
    // UserReportSettingsModel.fromJson(userReportSettingsModel.toJson());
    // print(
    //     "json.encode: ${UserReportSettingsModel.fromJson(userReportSettingsModel.toJson()).txtJsoncrit}");
    // Map<String, dynamic> toJson = parseStringToJson(
    //     UserReportSettingsModel.fromJson(userReportSettingsModel.toJson())
    //         .txtJsoncrit);
    // print(toJson.toString());
    // print(
    //     "json.encode: ${SearchCriteria.fromJson(searchCriteria.toJson()).voucherStatus}");

    UserReportSettingsController()
        .editUserReportSettings(userReportSettingsModel)
        .then((value) {
      if (value.statusCode == 200) {
        print("value.statusCode: ${value.statusCode}");
      }
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
                CustomDate(
                  dateController: _fromDateController,
                  label: _locale.fromDate,
                  minYear: 2000,
                  onValue: (isValid, value) {
                    if (isValid) {
                      setState(() {
                        _fromDateController.text = value;
                        print("frommmmmmmmmmmm: ${_fromDateController}");
                        DateTime from =
                            DateTime.parse(_fromDateController.text);
                        DateTime to = DateTime.parse(_toDateController.text);

                        if (from.isAfter(to)) {
                          ErrorController.openErrorDialog(
                              1, _locale.startDateAfterEndDate);
                        } else {
                          getBranchByCat();
                        }
                      });
                    }
                  },
                ),
                SizedBox(
                  width: width * 0.01,
                ),
                // CustomDatePicker(
                //   label: _locale.fromDate,
                //   controller: _fromDateController,
                //   date: DateTime.parse(_toDateController.text),
                //   onSelected: (value) {},
                // ),
                CustomDate(
                  dateController: _toDateController,
                  label: _locale.toDate,
                  // minYear: 2000,
                  onValue: (isValid, value) {
                    if (isValid) {
                      setState(() {
                        _toDateController.text = value;
                        DateTime from =
                            DateTime.parse(_fromDateController.text);
                        DateTime to = DateTime.parse(_toDateController.text);

                        if (from.isAfter(to)) {
                          ErrorController.openErrorDialog(
                              1, _locale.startDateAfterEndDate);
                        } else {
                          getBranchByCat();
                        }
                      });
                    }
                  },
                ),
                // CustomDatePicker(
                //   label: _locale.toDate,
                //   controller: _toDateController,
                //   date: DateTime.parse(_fromDateController.text),
                //   onSelected: (value) {
                //     setState(() {
                //       _toDateController.text = value;
                //       getBranchByCat();
                //     });
                //   },
                // ),
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
          width: widthMobile * 0.81,
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
          width: widthMobile * 0.81,
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
          width: widthMobile * 0.81,
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
          width: widthMobile * 0.81,
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
        SizedBox(
          width: widthMobile * 0.81,
          child: CustomDate(
            dateController: _fromDateController,
            label: _locale.fromDate,
            minYear: 2000,
            onValue: (isValid, value) {
              if (isValid) {
                setState(() {
                  _fromDateController.text = value;
                  DateTime from = DateTime.parse(_fromDateController.text);
                  DateTime to = DateTime.parse(_toDateController.text);

                  if (from.isAfter(to)) {
                    ErrorController.openErrorDialog(
                        1, _locale.startDateAfterEndDate);
                  } else {
                    getBranchByCat();
                  }
                });
              }
            },
          ),
        ),
        // CustomDatePicker(
        //   label: _locale.fromDate,
        //   controller: _fromDateController,
        //   date: DateTime.parse(_toDateController.text),
        //   onSelected: (value) {},
        // ),
        SizedBox(
          width: widthMobile * 0.81,
          child: CustomDate(
            dateController: _toDateController,
            label: _locale.toDate,
            // minYear: 2000,
            onValue: (isValid, value) {
              if (isValid) {
                setState(() {
                  _toDateController.text = value;
                  DateTime from = DateTime.parse(_fromDateController.text);
                  DateTime to = DateTime.parse(_toDateController.text);

                  if (from.isAfter(to)) {
                    ErrorController.openErrorDialog(
                        1, _locale.startDateAfterEndDate);
                  } else {
                    getBranchByCat();
                  }
                });
              }
            },
          ),
        ),
      ],
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

  void getBranchByCat({bool? isStart}) {
    listOfBalances = [];
    pieData = [];
    barData = [];
    dataMap.clear();
    int cat = getCategoryNum(selectedCategories, _locale);
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
    setSearchCriteria(searchCriteria);
    pieData = [];
    barData = [];
    listOfBalances = [];
    listOfPeriods = [];

    salesCategoryController
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
        setState(() {
          listOfBalances.add(bal);
          listOfPeriods.add(element.categoryName!);
          if (temp) {
            dataMap[element.categoryName!] =
                formatDoubleToTwoDecimalPlaces(bal);

            pieData.add(PieChartModel(
                title: element.categoryName! == ""
                    ? _locale.general
                    : element.categoryName!,
                value: formatDoubleToTwoDecimalPlaces(bal),
                color: randomColor)); // Set random color
          }

          barData.add(
            BarChartData(
              element.categoryName! == ""
                  ? _locale.general
                  : element.categoryName!,
              bal,
            ), // Set random color
          );
        });
      }
    });
  }
}
