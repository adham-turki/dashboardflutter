import 'dart:convert';

import 'package:bi_replicate/controller/total_sales_controller.dart';
import 'package:bi_replicate/provider/dates_provider.dart';
import 'package:bi_replicate/widget/drop_down/custom_dropdown.dart';
import 'package:bi_replicate/widget/test_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../components/custom_date.dart';
import '../../../controller/error_controller.dart';
import '../../../controller/sales_adminstration/branch_controller.dart';
import '../../../controller/settings/user_settings/code_reports_controller.dart';
import '../../../controller/settings/user_settings/user_report_settings_controller.dart';
import '../../../model/criteria/search_criteria.dart';
import '../../../model/settings/user_settings/code_reports_model.dart';
import '../../../model/settings/user_settings/user_report_settings.dart';
import '../../../model/stock_model.dart';
import '../../../utils/constants/app_utils.dart';
import '../../../utils/constants/maps.dart';
import '../../../utils/constants/pages_constants.dart';
import '../../../utils/constants/responsive.dart';
import '../../../utils/func/dates_controller.dart';

class FilterDialogSalesByCategory extends StatefulWidget {
  final String? selectedChart;
  final String? selectedPeriod;
  final String? selectedBranchCodeF;
  final String? fromDate;
  final String? toDate;
  final String? selectedCategory;
  final List<String>? branches;
  final List<StockModel>? stocksCodes;
  final Function(
      String selectedPeriod,
      String fromDate,
      String toDate,
      String selectedCategoriesF,
      String selectedBranchCodeF,
      String chart,
      List<String> stocksCodes) onFilter;

  const FilterDialogSalesByCategory(
      {super.key,
      required this.onFilter,
      this.selectedChart,
      this.selectedBranchCodeF,
      this.selectedPeriod,
      this.fromDate,
      this.toDate,
      this.selectedCategory,
      this.stocksCodes,
      this.branches});

  @override
  State<FilterDialogSalesByCategory> createState() =>
      _FilterDialogSalesByCategoryState();
}

class _FilterDialogSalesByCategoryState
    extends State<FilterDialogSalesByCategory> {
  late AppLocalizations _locale;
  bool isDesktop = false;
  final TextEditingController _fromDateController =
      TextEditingController(text: "29-10-2021");
  final TextEditingController _toDateController = TextEditingController();
  double width = 0;
  double height = 0;
  String todayDate = "";
  String currentMonth = "";
  List<String> periods = [];
  var selectedPeriod = "";
  List<String> categories = [];
  List<String> charts = [];
  var selectedChart = "";
  List<CodeReportsModel> codeReportsList = [];
  List<UserReportSettingsModel> userReportSettingsList = [];
  String startSearchCriteria = "";
  String currentPageName = "";
  String currentPageCode = "";
  SearchCriteria? searchCriteriaa;
  String txtKey = "";
  var selectedCategories = "";
  var selectedBranchCode = "";
  List<String> branches = [];
  var selectedBranch = "";
  BranchController branchController = BranchController();
  List<StockModel> stocks = [];
  List<String> stocksCodes = [];
  List<StockModel> tempStocks = [];
  List<String> tempStocksCodes = [];
  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context)!;

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
    charts = [_locale.lineChart, _locale.pieChart, _locale.barChart];
    selectedChart = widget.selectedChart!;

    selectedCategories = categories[1];

    branches = [_locale.all];
    selectedPeriod = widget.selectedPeriod!;
    todayDate = DatesController().formatDateReverse(
        DatesController().formatDate(DatesController().todayDate()));
    currentMonth = DatesController().formatDateReverse(
        DatesController().formatDate(DatesController().twoYearsAgo()));

    _toDateController.text = widget.toDate != null
        ? DatesController().formatDateReverse(widget.toDate!)
        : todayDate;

    _fromDateController.text = widget.fromDate != null
        ? DatesController().formatDateReverse(widget.fromDate!)
        : currentMonth;
    selectedCategories = widget.selectedCategory ?? "";

    branches = widget.branches ?? [_locale.all];

    selectedBranch = widget.selectedBranchCodeF == null
        ? _locale.all
        : widget.selectedBranchCodeF == _locale.all
            ? widget.selectedBranchCodeF!
            : branchesMap2[widget.selectedBranchCodeF!];

    selectedBranchCode = branchesMap[selectedBranch];
    getAllCodeReports();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    isDesktop = Responsive.isDesktop(context);
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      // title: SelectableText(_locale.filter),
      content: SizedBox(
        width: isDesktop ? width * 0.55 : width * 0.7,
        height: isDesktop ? height * 0.37 : null,
        child: SingleChildScrollView(
          child: Column(
            children: [
              isDesktop
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // CustomDropDown(
                        //   width: width * 0.165,
                        //   items: periods,
                        //   label: _locale.period,
                        //   initialValue: selectedPeriod,
                        //   onChanged: (value) {
                        //     setState(() {
                        //       checkPeriods(value);
                        //       selectedPeriod = value!;
                        //     });
                        //   },
                        // ),
                        CustomDropDown(
                          width: width * 0.165,
                          items: categories,
                          label: _locale.byCategory,
                          initialValue: selectedCategories,
                          onChanged: (value) {
                            setState(() {
                              selectedCategories = value!;
                            });
                          },
                        ),
                        CustomDropDown(
                          width: width * 0.165,
                          items: charts,
                          hint: "",
                          label: _locale.chartType,
                          initialValue: selectedChart,
                          onChanged: (value) {
                            setState(() {
                              selectedChart = value!;
                            });
                          },
                        ),
                        SizedBox(
                          width: width * 0.16,
                          height: height * 0.08,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_locale.stocks),
                              TestDropdown(
                                  isEnabled: true,
                                  icon: const Icon(Icons.search),
                                  cleanPrevSelectedItem: true,
                                  onItemAddedOrRemoved: (value) {
                                    for (int i = 0; i < value.length; i++) {
                                      tempStocks.add(value[i]);
                                      tempStocksCodes
                                          .add(tempStocks[i].txtStkcode ?? "");
                                      print(
                                          "asdasdsadTemp: ${tempStocks[i].txtNamea ?? tempStocks[i].txtNamee}");
                                      print(
                                          "asdasdsadTemp1: ${tempStocksCodes[i]}");
                                    }
                                  },
                                  onChanged: (value) {
                                    print("asdasdasddeeee: ${value.length}");
                                    print("asdasdasddeeee");
                                    if (value.isNotEmpty) {
                                      stocks.clear();
                                      stocksCodes.clear();
                                      tempStocks.clear();
                                      tempStocksCodes.clear();
                                      for (int i = 0; i < value.length; i++) {
                                        stocks.add(value[i]);
                                        stocksCodes
                                            .add(stocks[i].txtStkcode ?? "");
                                        print(
                                            "asdasdsad: ${stocks[i].txtNamea ?? stocks[i].txtNamee}");
                                        print("asdasdsad1: ${stocksCodes[i]}");
                                      }
                                      setState(() {});
                                    }
                                  },
                                  stringValue:
                                      "${_locale.select} ${_locale.stock}",
                                  borderText: "",
                                  onClearIconPressed: () {
                                    // dealsProvider.clearStockCateg();
                                    // hintCategory = "";
                                  },
                                  onPressed: () {},
                                  onSearch: (text) async {
                                    List<StockModel> value =
                                        await TotalSalesController()
                                            .getStocks(0, text);
                                    print("value1: ${value.length}");
                                    value = value
                                        .where((stock) => !tempStocks.any(
                                            (temp) =>
                                                temp.txtStkcode ==
                                                stock.txtStkcode))
                                        .toList();
                                    print("value1111: ${value.length}");
                                    // for (var i = 0; i < value.length; i++) {
                                    //   print("asddddd1:${value[i].txtStkcode}");
                                    //   print("asddddd21:${tempStocks.length}");
                                    //   if (tempStocksCodes.contains(value[i].txtStkcode)) {
                                    //     value.removeAt(i);
                                    //     print(
                                    //         "asddddd: ${tempStocksCodes.contains(value[i].txtStkcode)}");
                                    //   }
                                    // }
                                    return value;
                                  }),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // CustomDropDown(
                        //   items: periods,
                        //   label: _locale.period,
                        //   initialValue: selectedPeriod,
                        //   width: width,
                        //   onChanged: (value) {
                        //     setState(() {
                        //       checkPeriods(value);
                        //       selectedPeriod = value!;
                        //     });
                        //   },
                        // ),

                        CustomDropDown(
                          items: categories,
                          width: width,
                          label: _locale.byCategory,
                          initialValue: selectedCategories,
                          onChanged: (value) {
                            setState(() {
                              selectedCategories = value!;
                            });
                          },
                        ),
                      ],
                    ),
              isDesktop
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomDate(
                          dateController: _fromDateController,
                          label: _locale.fromDate,
                          lastDate: DateTime.now(),
                          minYear: 2000,
                          onValue: (isValid, value) {
                            if (isValid) {
                              setState(() {
                                _fromDateController.text = value;
                              });
                            }
                          },
                          dateControllerToCompareWith: _toDateController,
                          isInitiaDate: true,
                          timeControllerToCompareWith: null,
                        ),
                        // SizedBox(
                        //   width: width * 0.01,
                        // ),
                        CustomDate(
                          dateController: _toDateController,
                          label: _locale.toDate,
                          lastDate: DateTime.now(),
                          minYear: 2000,
                          onValue: (isValid, value) {
                            if (isValid) {
                              setState(() {
                                _toDateController.text = value;
                              });
                            }
                          },
                          dateControllerToCompareWith: _fromDateController,
                          isInitiaDate: false,
                          timeControllerToCompareWith: null,
                        ),
                        CustomDropDown(
                          width: width * 0.165,
                          items: branches,
                          label: _locale.branch,
                          initialValue: selectedBranch,
                          onChanged: (value) {
                            setState(() {
                              selectedBranch = value.toString();
                              selectedBranchCode =
                                  branchesMap[value.toString()]!;
                            });
                          },
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: height * 0.12,
                          width: isDesktop ? width * 0.135 : width * 0.9,
                          child: CustomDate(
                            dateController: _fromDateController,
                            label: _locale.fromDate,
                            lastDate: DateTime.now(),
                            minYear: 2000,
                            onValue: (isValid, value) {
                              if (isValid) {
                                setState(() {
                                  _fromDateController.text = value;
                                });
                              }
                            },
                            dateControllerToCompareWith: _toDateController,
                            isInitiaDate: true,
                            timeControllerToCompareWith: null,
                          ),
                        ),
                        SizedBox(
                          height: height * 0.12,
                          width: isDesktop ? width * 0.135 : width * 0.9,
                          child: CustomDate(
                            dateController: _toDateController,
                            label: _locale.toDate,
                            lastDate: DateTime.now(),
                            minYear: 2000,
                            onValue: (isValid, value) {
                              if (isValid) {
                                setState(() {
                                  _toDateController.text = value;
                                });
                              }
                            },
                            dateControllerToCompareWith: _fromDateController,
                            isInitiaDate: false,
                            timeControllerToCompareWith: null,
                          ),
                        ),
                        SizedBox(
                          width: width * 0.65,
                          height: height * 0.08,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_locale.stocks),
                              TestDropdown(
                                  isEnabled: true,
                                  icon: const Icon(Icons.search),
                                  cleanPrevSelectedItem: true,
                                  onItemAddedOrRemoved: (value) {
                                    for (int i = 0; i < value.length; i++) {
                                      tempStocks.add(value[i]);
                                      tempStocksCodes
                                          .add(tempStocks[i].txtStkcode ?? "");
                                      print(
                                          "asdasdsadTemp: ${tempStocks[i].txtNamea ?? tempStocks[i].txtNamee}");
                                      print(
                                          "asdasdsadTemp1: ${tempStocksCodes[i]}");
                                    }
                                  },
                                  onChanged: (value) {
                                    print("asdasdasddeeee: ${value.length}");
                                    print("asdasdasddeeee");
                                    if (value.isNotEmpty) {
                                      stocks.clear();
                                      stocksCodes.clear();
                                      tempStocks.clear();
                                      tempStocksCodes.clear();
                                      for (int i = 0; i < value.length; i++) {
                                        stocks.add(value[i]);
                                        stocksCodes
                                            .add(stocks[i].txtStkcode ?? "");
                                        print(
                                            "asdasdsad: ${stocks[i].txtNamea ?? stocks[i].txtNamee}");
                                        print("asdasdsad1: ${stocksCodes[i]}");
                                      }
                                      setState(() {});
                                    }
                                  },
                                  stringValue:
                                      "${_locale.select} ${_locale.stock}",
                                  borderText: "",
                                  onClearIconPressed: () {
                                    // dealsProvider.clearStockCateg();
                                    // hintCategory = "";
                                  },
                                  onPressed: () {},
                                  onSearch: (text) async {
                                    List<StockModel> value =
                                        await TotalSalesController()
                                            .getStocks(0, text);
                                    print("value1: ${value.length}");
                                    value = value
                                        .where((stock) => !tempStocks.any(
                                            (temp) =>
                                                temp.txtStkcode ==
                                                stock.txtStkcode))
                                        .toList();
                                    print("value1111: ${value.length}");
                                    // for (var i = 0; i < value.length; i++) {
                                    //   print("asddddd1:${value[i].txtStkcode}");
                                    //   print("asddddd21:${tempStocks.length}");
                                    //   if (tempStocksCodes.contains(value[i].txtStkcode)) {
                                    //     value.removeAt(i);
                                    //     print(
                                    //         "asddddd: ${tempStocksCodes.contains(value[i].txtStkcode)}");
                                    //   }
                                    // }
                                    return value;
                                  }),
                            ],
                          ),
                        ),
                        CustomDropDown(
                          items: charts,
                          hint: "",
                          width: width,
                          label: _locale.chartType,
                          initialValue: selectedChart,
                          onChanged: (value) {
                            setState(() {
                              selectedChart = value!;
                            });
                          },
                        ),
                        CustomDropDown(
                          width: width,
                          items: branches,
                          label: _locale.branch,
                          initialValue: selectedBranch,
                          onChanged: (value) {
                            setState(() {
                              selectedBranch = value.toString();
                              selectedBranchCode =
                                  branchesMap[value.toString()]!;
                            });
                          },
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Components().blueButton(
                height: width > 800 ? height * .054 : height * .06,
                fontSize: width > 800 ? height * .0158 : height * .015,
                width: isDesktop ? width * 0.09 : width * 0.25,
                onPressed: () {
                  DateTime from = DateTime.parse(_fromDateController.text);
                  DateTime to = DateTime.parse(_toDateController.text);

                  if (from.isAfter(to)) {
                    ErrorController.openErrorDialog(
                        1, _locale.startDateAfterEndDate);
                  } else {
                    widget.onFilter(
                        selectedPeriod,
                        DatesController().formatDate(_fromDateController.text),
                        DatesController().formatDate(_toDateController.text),
                        selectedCategories,
                        selectedBranchCode,
                        selectedChart,
                        stocksCodes);

                    context.read<DatesProvider>().setDatesController(
                        _fromDateController, _toDateController);
                    Navigator.of(context).pop();
                  }
                },
                text: _locale.filter,
                borderRadius: 0.3,
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
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
        startSearchCriteria = startSearchCriteria.replaceAll('الكل', '');
        // Wrapping the string with curly braces to make it a valid JSON object
        startSearchCriteria = '{$startSearchCriteria}';
        // print("start search sales dashboard : ${startSearchCriteria}");

        searchCriteriaa =
            SearchCriteria.fromJson(json.decode(startSearchCriteria));
        // _fromDateController.text =
        //     DatesController().formatDateReverse(searchCriteriaa!.fromDate!);
        // _toDateController.text =
        //     DatesController().formatDateReverse(searchCriteriaa!.toDate!);
        // selectedCategories = searchCriteriaa!.byCategory! == 1
        //     ? _locale.brands
        //     : searchCriteriaa!.byCategory! == 2
        //         ? _locale.categories("1")
        //         : searchCriteriaa!.byCategory! == 3
        //             ? _locale.categories("2")
        //             : _locale.classifications;

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
        codeReportsList = value;
        setPageName();
        if (currentPageName.isNotEmpty) {
          getAllUserReportSettings();
        }
      }
    });
  }

  getAllUserReportSettings() {
    UserReportSettingsController().getAllUserReportSettings().then((value) {
      userReportSettingsList = value;
      setStartSearchCriteria();
    });
  }

  setPageName() {
    for (var i = 0; i < codeReportsList.length; i++) {
      if (codeReportsList[i].txtReportnamee ==
          ReportConstants.branchesSalesByCategories) {
        currentPageName = codeReportsList[i].txtReportnamee;
        currentPageCode = codeReportsList[i].txtReportcode;
      }
    }
  }

  void setSearchCriteria(SearchCriteria searchCriteria) {
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
}
