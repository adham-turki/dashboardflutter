import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:bi_replicate/components/dashboard_components/line_dasboard_chart.dart';
import 'package:bi_replicate/controller/sales_adminstration/branch_controller.dart';
import 'package:bi_replicate/utils/func/converters.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:bi_replicate/model/criteria/search_criteria.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../controller/sales_adminstration/sales_branches_controller.dart';
import '../../../model/bar_chart_data_model.dart';
import '../../../model/chart/pie_chart_model.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/func/dates_controller.dart';
import '../../components/charts.dart';
import '../../components/dashboard_components/bar_dashboard_chart.dart';
import '../../components/dashboard_components/pie_dashboard_chart.dart';
import '../../controller/financial_performance/cash_flow_controller.dart';
import '../../controller/sales_adminstration/sales_category_controller.dart';
import '../../controller/settings/setup/accounts_name.dart';
import '../../controller/settings/user_settings/code_reports_controller.dart';
import '../../controller/settings/user_settings/user_report_settings_controller.dart';
import '../../model/settings/setup/bi_account_model.dart';
import '../../model/settings/user_settings/code_reports_model.dart';
import '../../model/settings/user_settings/user_report_settings.dart';
import '../../utils/constants/app_utils.dart';
import '../../utils/constants/maps.dart';
import '../../utils/constants/pages_constants.dart';
import '../../utils/constants/responsive.dart';
import 'filter_dialog/filter_dialog_sales_by_cat.dart';

class BranchesSalesByCatDashboard extends StatefulWidget {
  const BranchesSalesByCatDashboard({
    Key? key,
  }) : super(key: key);

  @override
  State<BranchesSalesByCatDashboard> createState() =>
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

  String lastFromDate = "";
  String lastToDate = "";

  String lastCategories = "";
  String lastBranchCode = "";
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
  String todayDate1 = "";
  List<String> periods = [];
  List<String> categories = [];

  List<BarData> barData = [];

  List<PieChartModel> pieData = [];

  CashFlowController cashFlowController = CashFlowController();

  //List<String> status = [];
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  String todayDate = "";
  String currentYear = "";
  int selectedCategories = 0;
  int selectedPeriod = 0;
  int selectedChart = 0;

  var selectedBranchCode = "";

  double balance = 0;
  bool accountsActive = false;
  String accountNameString = "";
  final usedColors = <Color>[];

  List<BiAccountModel> cashboxAccounts = [];
  SalesCategoryController salesCategoryController = SalesCategoryController();

  bool isDesktop = false;
  int count = 0;
  bool isLoading = true;
  List<String> branches = [];
  ValueNotifier totalBranchesByCateg = ValueNotifier(0);
  Timer? _timer;

  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context)!;
    getBranch();

    periods = [
      _locale.daily,
      _locale.weekly,
      _locale.monthly,
      _locale.yearly,
    ];

    categories = [
      _locale.brands,
      _locale.categories("1"),
      _locale.categories("2"),
      _locale.classifications
    ];
    todayDate = DatesController().formatDate(DatesController().todayDate());
    currentYear = DatesController().formatDate(DatesController().twoYearsAgo());

    if (count == 0) {
      fromDateController.text = "";
      toDateController.text = "";
      selectedCategories = Category1_Category;
      selectedPeriod = Daily_Period;
      selectedChart = Bar_Chart;
      selectedBranchCode = "";
    }
    count++;
    super.didChangeDependencies();
  }

  List<BarData> barDataTest = [];

  @override
  void initState() {
    for (int i = 0; i < 100; i++) {
      barDataTest.add(BarData(
        name: 'Bar $i',
        percent: Random().nextDouble() * 100,
      ));
    }

    getCashBoxAccount(isStart: true).then((value) {
      cashboxAccounts = value;
      setState(() {});
    });
    getAllCodeReports();
    _startTimer();

    super.initState();
  }

  Future<void> getBranchByCatData() async {
    await getBranchByCat().then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    isDesktop = Responsive.isDesktop(context);
    String fromDate = fromDateController.text.isEmpty
        ? ""
        : DatesController().formatDateReverse(fromDateController.text);
    String toDate = toDateController.text.isEmpty
        ? ""
        : DatesController().formatDateReverse(toDateController.text);

    return Container(
      decoration: const BoxDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 5, right: 5, bottom: 3, top: 0),
            child: Container(
              height: isDesktop ? height * 0.44 : height * 0.48,
              padding: const EdgeInsets.only(left: 5, right: 5, top: 0),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  isDesktop
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ValueListenableBuilder(
                                valueListenable: totalBranchesByCateg,
                                builder: ((context, value, child) {
                                  return Text(
                                    "${_locale.branchesSalesByCategories} (${totalBranchesByCateg.value})",
                                    style: TextStyle(
                                        fontSize: isDesktop ? 15 : 18),
                                  );
                                })),
                            Text(
                              _locale.localeName == "en"
                                  ? "${fromDateController.text}  -  ${toDateController.text}"
                                  : "$fromDate  -  $toDate",
                              style: TextStyle(fontSize: isDesktop ? 15 : 13),
                            ),
                            SizedBox(
                                width: MediaQuery.of(context).size.width < 800
                                    ? MediaQuery.of(context).size.width * 0.06
                                    : MediaQuery.of(context).size.width * 0.03,
                                child: blueButton1(
                                  icon: Icon(
                                    Icons.filter_list_sharp,
                                    color: whiteColor,
                                    size: isDesktop
                                        ? height * 0.035
                                        : height * 0.03,
                                  ),
                                  textColor:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  height:
                                      isDesktop ? height * .015 : height * .03,
                                  fontSize:
                                      isDesktop ? height * .018 : height * .017,
                                  width:
                                      isDesktop ? width * 0.13 : width * 0.25,
                                  onPressed: () {
                                    if (isLoading == false) {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return FilterDialogSalesByCategory(
                                            selectedChart: getChartByCode(
                                                selectedChart, _locale),
                                            selectedBranchCodeF:
                                                selectedBranchCode == ""
                                                    ? _locale.all
                                                    : selectedBranchCode,
                                            selectedPeriod: getPeriodByCode(
                                                selectedPeriod, _locale),
                                            fromDate: fromDateController.text,
                                            toDate: toDateController.text,
                                            selectedCategory: getCategoryByCode(
                                                selectedCategories, _locale),
                                            branches: branches,
                                            onFilter: (selectedPeriodF,
                                                fromDate,
                                                toDate,
                                                selectedCategoriesF,
                                                selectedBranchCodeF,
                                                chart) {
                                              fromDateController.text =
                                                  fromDate;
                                              toDateController.text = toDate;
                                              selectedCategories =
                                                  getCategoryNum(
                                                      selectedCategoriesF,
                                                      _locale);
                                              selectedBranchCode =
                                                  selectedBranchCodeF ==
                                                          _locale.all
                                                      ? ""
                                                      : selectedBranchCodeF;
                                              selectedPeriod = getPeriodByName(
                                                  selectedPeriodF, _locale);
                                              selectedChart = getChartByName(
                                                  chart, _locale);
                                              SearchCriteria searchCriteria =
                                                  SearchCriteria(
                                                fromDate:
                                                    fromDateController.text,
                                                toDate: toDateController
                                                        .text.isEmpty
                                                    ? todayDate
                                                    : toDateController.text,
                                                byCategory: getCategoryNum(
                                                    selectedCategoriesF,
                                                    _locale),
                                                branch: selectedBranchCode,
                                              );
                                              setSearchCriteria(searchCriteria);
                                            },
                                          );
                                        },
                                      ).then((value) async {
                                        setState(() {
                                          _timer!.cancel();

                                          isLoading = true;
                                        });
                                        getBranchByCat().then((value) {
                                          setState(() {
                                            _startTimer();

                                            isLoading = false;
                                          });
                                        });
                                      });
                                    }
                                  },
                                )),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                ValueListenableBuilder(
                                    valueListenable: totalBranchesByCateg,
                                    builder: ((context, value, child) {
                                      return Text(
                                        "${_locale.branchesSalesByCategories}   (${totalBranchesByCateg.value})",
                                        style: TextStyle(
                                            fontSize: isDesktop ? 15 : 18),
                                      );
                                    })),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _locale.localeName == "en"
                                      ? "${fromDateController.text}  -  ${toDateController.text}"
                                      : "$fromDate  -  $toDate",
                                  style:
                                      TextStyle(fontSize: isDesktop ? 15 : 10),
                                ),
                                SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width < 800
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.12
                                            : MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.03,
                                    child: blueButton1(
                                      icon: Icon(
                                        Icons.filter_list_sharp,
                                        color: whiteColor,
                                        size: isDesktop
                                            ? height * 0.035
                                            : height * 0.055,
                                      ),
                                      textColor: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      height: isDesktop
                                          ? height * .015
                                          : height * .03,
                                      fontSize: isDesktop
                                          ? height * .018
                                          : height * .017,
                                      width: isDesktop
                                          ? width * 0.13
                                          : width * 0.25,
                                      onPressed: () {
                                        if (isLoading == false) {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return FilterDialogSalesByCategory(
                                                selectedChart: getChartByCode(
                                                    selectedChart, _locale),
                                                selectedBranchCodeF:
                                                    selectedBranchCode == ""
                                                        ? _locale.all
                                                        : selectedBranchCode,
                                                selectedPeriod: getPeriodByCode(
                                                    selectedPeriod, _locale),
                                                fromDate:
                                                    fromDateController.text,
                                                toDate: toDateController.text,
                                                selectedCategory:
                                                    getCategoryByCode(
                                                        selectedCategories,
                                                        _locale),
                                                branches: branches,
                                                onFilter: (selectedPeriodF,
                                                    fromDate,
                                                    toDate,
                                                    selectedCategoriesF,
                                                    selectedBranchCodeF,
                                                    chart) {
                                                  fromDateController.text =
                                                      fromDate;
                                                  toDateController.text =
                                                      toDate;
                                                  selectedCategories =
                                                      getCategoryNum(
                                                          selectedCategoriesF,
                                                          _locale);
                                                  selectedBranchCode =
                                                      selectedBranchCodeF ==
                                                              _locale.all
                                                          ? ""
                                                          : selectedBranchCodeF;
                                                  selectedPeriod =
                                                      getPeriodByName(
                                                          selectedPeriodF,
                                                          _locale);
                                                  selectedChart =
                                                      getChartByName(
                                                          chart, _locale);
                                                  SearchCriteria
                                                      searchCriteria =
                                                      SearchCriteria(
                                                    fromDate:
                                                        fromDateController.text,
                                                    toDate: toDateController
                                                            .text.isEmpty
                                                        ? todayDate
                                                        : toDateController.text,
                                                    byCategory: getCategoryNum(
                                                        selectedCategoriesF,
                                                        _locale),
                                                    branch: selectedBranchCode,
                                                  );
                                                  setSearchCriteria(
                                                      searchCriteria);
                                                },
                                              );
                                            },
                                          ).then((value) async {
                                            setState(() {
                                              _timer!.cancel();

                                              isLoading = true;
                                            });
                                            getBranchByCat().then((value) {
                                              setState(() {
                                                _startTimer();

                                                isLoading = false;
                                              });
                                            });
                                          });
                                        }
                                      },
                                    )),
                              ],
                            )
                          ],
                        ),
                  isLoading
                      ? const Padding(
                          padding: EdgeInsets.only(bottom: 150),
                          child: CircularProgressIndicator(),
                        )
                      : selectedChart == Line_Chart
                          ? SizedBox(
                              height: height * .4,
                              child: LineDashboardChart(
                                  isMax: false,
                                  balances: listOfBalances,
                                  periods: listOfPeriods),
                            )
                          : selectedChart == Pie_Chart
                              ? Center(
                                  child: SizedBox(
                                    height: height * 0.4,
                                    child: PieDashboardChart(
                                      dataList: pieData,
                                    ),
                                  ),
                                )
                              : BarDashboardChart(
                                  barChartData: barData,
                                  isMax: false,
                                )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  setStartSearchCriteria() {
    for (var i = 0; i < userReportSettingsList.length; i++) {
      if (currentPageCode == userReportSettingsList[i].txtReportcode) {
        txtKey = userReportSettingsList[i].txtKey;
        startSearchCriteria = userReportSettingsList[i].txtJsoncrit;
        // Adding double quotes around keys and values to make it valid JSON
        print("startSearchCriteria3434343434 ${startSearchCriteria}");
        print(
            "startSearchCriteria3434343434 matchGroup 0  ${startSearchCriteria}");
        startSearchCriteria = startSearchCriteria.replaceAll('الكل', '');

        startSearchCriteria = startSearchCriteria
            .replaceAllMapped(RegExp(r'(\w+):\s*([\w-]+|)(?=,|\})'), (match) {
          if (match.group(1) == "fromDate" ||
              match.group(1) == "toDate" ||
              match.group(1) == "branch") {
            print(
                "startSearchCriteria3434343434 matchGroup 1 ${match.group(1)}");
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
        // print("start search sales dashboard : ${startSearchCriteria}");
        print("startSearchCriteria3434343434 ${startSearchCriteria}");

        searchCriteriaa =
            SearchCriteria.fromJson(json.decode(startSearchCriteria));
        fromDateController.text = searchCriteriaa!.fromDate!.isEmpty
            ? currentYear
            : searchCriteriaa!.fromDate!;
        toDateController.text = searchCriteriaa!.toDate!.isEmpty
            ? todayDate
            : searchCriteriaa!.toDate!;
        selectedCategories = searchCriteriaa!.byCategory! == 1
            ? Brands_Category
            : searchCriteriaa!.byCategory! == 2
                ? Category1_Category
                : searchCriteriaa!.byCategory! == 3
                    ? Category2_Category
                    : Classifications_Category;
      }
    }
  }

  getAllCodeReports() async {
    await CodeReportsController().getAllCodeReports().then((value) {
      if (value.isNotEmpty) {
        setState(() {
          codeReportsList = value;
          setPageName();
          if (currentPageName.isNotEmpty) {
            getAllUserReportSettings();
          } else {
            setState(() {
              isLoading = false;
            });
          }
        });
      }
    });
  }

  getAllUserReportSettings() {
    UserReportSettingsController()
        .getAllUserReportSettings()
        .then((value) async {
      userReportSettingsList = value;

      setStartSearchCriteria();

      await getBranchByCat();

      setState(() {
        isLoading = false;
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
    // print("currentPageCode: ${currentPageCode}");
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

  Color getRandomColor(List<Color> colorList) {
    final random = Random();
    int r = random.nextInt(256); // 0 to 255
    int g = random.nextInt(256); // 0 to 255
    int b = random.nextInt(256); // 0 to 255

    // Create Color object from RGB values
    return Color.fromRGBO(r, g, b, 1.0);
  }

  double formatDoubleToTwoDecimalPlaces(double number) {
    return double.parse(number.toStringAsFixed(2));
  }

  Future<void> getBranchByCat({bool? isStart}) async {
    var selectedFromDate = fromDateController.text;
    var selectedToDate = toDateController.text;

    final selectedCategoriesValue = selectedCategories;
    final selectedBranchCodeValue = selectedBranchCode;

    // if (selectedFromDate != lastFromDate ||
    //     getCategoryByCode(selectedCategoriesValue, _locale) != lastCategories ||
    //     selectedBranchCodeValue != lastBranchCode ||
    //     selectedToDate != lastToDate) {
    lastFromDate = selectedFromDate;
    lastToDate = selectedToDate;

    lastCategories = getCategoryByCode(selectedCategories, _locale);
    lastBranchCode = selectedBranchCode;

    // if (selectedFromDate.isEmpty || toDateController.text.isEmpty) {
    //   if (selectedFromDate.isEmpty) {
    //     selectedFromDate = todayDate;
    //   }
    //   if (toDateController.text.isEmpty) {
    //     toDateController.text = todayDate;
    //   }
    // }

    SearchCriteria searchCriteria = SearchCriteria(
      fromDate: selectedFromDate,
      toDate: selectedToDate,
      byCategory: selectedCategories,
      branch: selectedBranchCode == "الكل" ? "" : selectedBranchCode,
    );
    setSearchCriteria(searchCriteria);
    pieData = [];
    barData = [];
    listOfBalances = [];
    listOfPeriods = [];

    await salesCategoryController
        .getSalesByCategory(searchCriteria, isStart: isStart)
        .then((value) {
      for (var element in value) {
        // print("adasdasdasdasdasdas");
        double bal = element.creditAmt! - element.debitAmt!;

        if (bal != 0.0) {
          temp = true;
        } else if (bal == 0.0) {
          temp = false;
        }
        listOfBalances.add(bal);
        listOfPeriods.add(
          element.categoryName!.isNotEmpty
              ? element.categoryName!
              : _locale.general,
        );
        if (temp) {
          dataMap[element.categoryName!] = formatDoubleToTwoDecimalPlaces(bal);

          pieData.add(
            PieChartModel(
              title: element.categoryName!.isNotEmpty
                  ? element.categoryName!
                  : _locale.general,
              value: formatDoubleToTwoDecimalPlaces(bal),
              color: getRandomColor(colorNewList),
            ),
          );
          barData.add(
            BarData(
              name: element.categoryName!.isNotEmpty
                  ? element.categoryName!
                  : _locale.general,
              percent: formatDoubleToTwoDecimalPlaces(bal),
            ),
          );
        }
      }

      double total = 0.0;
      for (int i = 0; i < listOfBalances.length; i++) {
        total += listOfBalances[i];
      }
      totalBranchesByCateg.value = Converters.formatNumberRounded(
          double.parse(Converters.formatNumberDigits(total)));
    });

    // }
  }

  // Future getBranchByCat1({bool? isStart}) async {
  //   listOfBalances = [];
  //   pieData = [];
  //   barData = [];
  //   dataMap.clear();
  //   int cat = getCategoryNum(selectedCategories, _locale);
  //   if (fromDateController.text.isEmpty || toDateController.text.isEmpty) {
  //     if (fromDateController.text.isEmpty) {
  //       fromDateController.text = todayDate;
  //     }
  //     if (toDateController.text.isEmpty) {
  //       toDateController.text = todayDate;
  //     }
  //   }

  //   SearchCriteria searchCriteria = SearchCriteria(
  //       fromDate: fromDateController.text.isEmpty
  //           ? todayDate
  //           : fromDateController.text,
  //       toDate:
  //           toDateController.text.isEmpty ? todayDate : toDateController.text,
  //       byCategory: cat,
  //       branch: selectedBranchCode);
  //   pieData = [];
  //   barData = [];
  //   listOfBalances = [];
  //   listOfPeriods = [];

  //   await salesCategoryController
  //       .getSalesByCategory(searchCriteria, isStart: isStart)
  //       .then((value) {
  //     for (var element in value) {
  //       double bal = element.creditAmt! - element.debitAmt!;

  //       if (bal != 0.0) {
  //         temp = true;
  //       } else if (bal == 0.0) {
  //         temp = false;
  //       }
  //       listOfBalances.add(bal);
  //       listOfPeriods.add(element.categoryName!);
  //       if (temp) {
  //         dataMap[element.categoryName!] = formatDoubleToTwoDecimalPlaces(bal);

  //         pieData.add(PieChartModel(
  //             title: element.categoryName! == ""
  //                 ? _locale.general
  //                 : element.categoryName!,
  //             value: formatDoubleToTwoDecimalPlaces(bal),
  //             color: getRandomColor(colorNewList))); // Set random color
  //       }

  //       barData.add(
  //         BarData(
  //           name: element.categoryName! == ""
  //               ? _locale.general
  //               : element.categoryName!,
  //           percent: bal,
  //         ),
  //       );
  //     }
  //     print("balLengthhhh ${barData.length}");
  //   });
  // }
  void _startTimer() {
    const storage = FlutterSecureStorage();

    const duration = Duration(minutes: 5);
    _timer = Timer.periodic(duration, (Timer t) async {
      String? token = await storage.read(key: "jwt");
      if (token != null) {
        await getBranchByCat().then((value) async {
          setState(() {
            isLoading = true;
          });

          await Future.delayed(const Duration(milliseconds: 1));
          setState(() {
            isLoading = false;
          });
        });
      } else {
        _timer!.cancel();
      }
    });
  }

  @override
  void dispose() {
    _stopTimer(); // Stop timer when the widget is disposed

    super.dispose();
  }

  void _stopTimer() {
    if (_timer != null) {
      _timer!.cancel(); // Cancel the timer
      _timer = null; // Reset timer reference
    }
  }

  void getBranch() async {
    BranchController().getBranch().then((value) {
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
}
