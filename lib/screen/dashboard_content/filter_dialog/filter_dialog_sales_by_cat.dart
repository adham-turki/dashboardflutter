import 'dart:convert';

import 'package:bi_replicate/provider/dates_provider.dart';
import 'package:bi_replicate/widget/drop_down/custom_dropdown.dart';
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
import '../../../utils/constants/app_utils.dart';
import '../../../utils/constants/maps.dart';
import '../../../utils/constants/pages_constants.dart';
import '../../../utils/constants/responsive.dart';
import '../../../utils/func/dates_controller.dart';

class FilterDialogSalesByCategory extends StatefulWidget {
  final Function(
      String selectedPeriod,
      String fromDate,
      String toDate,
      String selectedCategoriesF,
      String selectedBranchCodeF,
      String chart) onFilter;

  FilterDialogSalesByCategory({
    required this.onFilter,
  });

  @override
  _FilterDialogSalesByCategoryState createState() =>
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
    selectedChart = charts[2];

    selectedCategories = categories[1];
    branches = [_locale.all];
    selectedBranch = branches[0];
    selectedPeriod = periods[0];
    todayDate = DatesController().formatDateReverse(
        DatesController().formatDate(DatesController().todayDate()));
    currentMonth = DatesController().formatDateReverse(
        DatesController().formatDate(DatesController().twoYearsAgo()));

    _toDateController.text = todayDate;

    _fromDateController.text = currentMonth;
    getAllCodeReports();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    getBranch(isStart: true);

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
                        CustomDropDown(
                          items: periods,
                          label: _locale.period,
                          initialValue: selectedPeriod,
                          onChanged: (value) {
                            setState(() {
                              checkPeriods(value);
                              selectedPeriod = value!;
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
                            });
                          },
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomDropDown(
                          items: periods,
                          label: _locale.period,
                          initialValue: selectedPeriod,
                          width: width,
                          onChanged: (value) {
                            setState(() {
                              checkPeriods(value);
                              selectedPeriod = value!;
                            });
                          },
                        ),
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
                          minYear: 2000,
                          onValue: (isValid, value) {
                            if (isValid) {
                              setState(() {
                                _fromDateController.text = value;
                                DateTime from =
                                    DateTime.parse(_fromDateController.text);
                                DateTime to =
                                    DateTime.parse(_toDateController.text);

                                if (from.isAfter(to)) {
                                  ErrorController.openErrorDialog(
                                      1, _locale.startDateAfterEndDate);
                                }
                              });
                            }
                          },
                        ),
                        // SizedBox(
                        //   width: width * 0.01,
                        // ),
                        CustomDate(
                          dateController: _toDateController,
                          label: _locale.toDate,
                          minYear: 2000,
                          onValue: (isValid, value) {
                            if (isValid) {
                              setState(() {
                                _toDateController.text = value;
                                DateTime from =
                                    DateTime.parse(_fromDateController.text);
                                DateTime to =
                                    DateTime.parse(_toDateController.text);

                                if (from.isAfter(to)) {
                                  ErrorController.openErrorDialog(
                                      1, _locale.startDateAfterEndDate);
                                }
                              });
                            }
                          },
                        ),
                        CustomDropDown(
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
                            minYear: 2000,
                            onValue: (isValid, value) {
                              if (isValid) {
                                setState(() {
                                  _fromDateController.text = value;
                                  DateTime from =
                                      DateTime.parse(_fromDateController.text);
                                  DateTime to =
                                      DateTime.parse(_toDateController.text);

                                  if (from.isAfter(to)) {
                                    ErrorController.openErrorDialog(
                                        1, _locale.startDateAfterEndDate);
                                  }
                                });
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: height * 0.12,
                          width: isDesktop ? width * 0.135 : width * 0.9,
                          child: CustomDate(
                            dateController: _toDateController,
                            label: _locale.toDate,
                            minYear: 2000,
                            onValue: (isValid, value) {
                              if (isValid) {
                                setState(() {
                                  _toDateController.text = value;
                                  DateTime from =
                                      DateTime.parse(_fromDateController.text);
                                  DateTime to =
                                      DateTime.parse(_toDateController.text);

                                  if (from.isAfter(to)) {
                                    ErrorController.openErrorDialog(
                                        1, _locale.startDateAfterEndDate);
                                  }
                                });
                              }
                            },
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
        Row(
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
                      selectedChart);

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
}
