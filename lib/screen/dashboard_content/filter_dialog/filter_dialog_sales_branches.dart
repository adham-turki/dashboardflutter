import 'dart:convert';

import 'package:bi_replicate/provider/dates_provider.dart';
import 'package:bi_replicate/widget/drop_down/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../components/custom_date.dart';
import '../../../controller/error_controller.dart';
import '../../../controller/settings/user_settings/code_reports_controller.dart';
import '../../../controller/settings/user_settings/user_report_settings_controller.dart';
import '../../../model/criteria/search_criteria.dart';
import '../../../model/settings/user_settings/code_reports_model.dart';
import '../../../model/settings/user_settings/user_report_settings.dart';
import '../../../utils/constants/app_utils.dart';
import '../../../utils/constants/pages_constants.dart';
import '../../../utils/constants/responsive.dart';
import '../../../utils/func/dates_controller.dart';

class FilterDialogSalesByBranches extends StatefulWidget {
  final String? selectedChart;
  final String? selectedPeriod;
  final String? fromDate;
  final String? toDate;
  final Function(
          String selectedPeriod, String fromDate, String toDate, String chart)
      onFilter;

  const FilterDialogSalesByBranches(
      {super.key,
      required this.onFilter,
      this.selectedChart,
      this.selectedPeriod,
      this.fromDate,
      this.toDate});

  @override
  State<FilterDialogSalesByBranches> createState() =>
      _FilterDialogSalesByBranchesState();
}

class _FilterDialogSalesByBranchesState
    extends State<FilterDialogSalesByBranches> {
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
  List<String> status = [];
  List<String> charts = [];
  var selectedChart = "";

  var selectedStatus = "";
  List<CodeReportsModel> codeReportsList = [];
  List<UserReportSettingsModel> userReportSettingsList = [];
  String startSearchCriteria = "";
  String currentPageName = "";
  String currentPageCode = "";
  SearchCriteria? searchCriteriaa;
  String txtKey = "";

  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context)!;

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
    charts = [_locale.lineChart, _locale.pieChart, _locale.barChart];
    selectedChart = widget.selectedChart!;
    selectedPeriod = widget.selectedPeriod!;
    selectedStatus = status[0];
    todayDate = DatesController().formatDateReverse(
        DatesController().formatDate(DatesController().todayDate()));

    currentMonth = DatesController().formatDateReverse(
        DatesController().formatDate(DatesController().twoYearsAgo()));
    _toDateController.text = widget.fromDate != null
        ? DatesController().formatDateReverse(widget.toDate!)
        : todayDate;

    _fromDateController.text = widget.fromDate != null
        ? DatesController().formatDateReverse(widget.fromDate!)
        : currentMonth;
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
      content: SizedBox(
        width: isDesktop ? width * 0.39 : width * 0.7,
        height: isDesktop ? height * 0.37 : height * 0.55,
        child: SingleChildScrollView(
          child: Column(
            children: [
              isDesktop
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomDropDown(
                          width: width * 0.165,
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
                      ],
                    ),
              isDesktop
                  ? Row(
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
        print("start search barnches: ${startSearchCriteria}");

        searchCriteriaa =
            SearchCriteria.fromJson(json.decode(startSearchCriteria));
        // _fromDateController.text =
        //     DatesController().formatDateReverse(searchCriteriaa!.fromDate!);
        // _toDateController.text =
        //     DatesController().formatDateReverse(searchCriteriaa!.toDate!);
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
          ReportConstants.salesByBranches) {
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
}
