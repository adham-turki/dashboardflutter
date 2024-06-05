import 'dart:convert';

import 'package:bi_replicate/model/settings/user_settings/code_reports_model.dart';
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
import '../../../model/settings/user_settings/user_report_settings.dart';
import '../../../utils/constants/app_utils.dart';
import '../../../utils/constants/maps.dart';
import '../../../utils/constants/pages_constants.dart';
import '../../../utils/constants/responsive.dart';
import '../../../utils/func/dates_controller.dart';

class FilterDialogDailySales extends StatefulWidget {
  final Function(
    String fromDate,
    String selectedStatus,
    String chart,
    String selectedBranchCodeF,
  ) onFilter;

  FilterDialogDailySales({
    required this.onFilter,
  });

  @override
  _FilterDialogDailySalesState createState() => _FilterDialogDailySalesState();
}

class _FilterDialogDailySalesState extends State<FilterDialogDailySales> {
  late AppLocalizations _locale;
  bool isDesktop = false;
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();
  double width = 0;
  double height = 0;
  String todayDate = "";
  List<String> periods = [];
  var selectedPeriod = "";
  List<String> status = [];
  List<String> charts = [];
  var selectedStatus = "";
  List<CodeReportsModel> codeReportsList = [];
  List<UserReportSettingsModel> userReportSettingsList = [];
  String startSearchCriteria = "";
  String currentPageName = "";
  String currentPageCode = "";
  SearchCriteria? searchCriteriaa;
  String txtKey = "";
  String currentMonth = "";
  var selectedChart = "";
  List<String> branches = [];
  var selectedBranch = "";
  var selectedBranchCode = "";
  BranchController branchController = BranchController();

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
    branches = [_locale.all];
    selectedBranch = branches[0];
    charts = [_locale.lineChart, _locale.pieChart, _locale.barChart];
    selectedChart = charts[2];
    selectedPeriod = periods[0];
    selectedStatus = status[0];
    todayDate = DatesController().formatDateReverse(
        DatesController().formatDate(DatesController().todayDate()));
    currentMonth = DatesController().formatDateReverse(
        DatesController().formatDate(DatesController().twoYearsAgo()));
    _fromDateController.text = currentMonth;
    _toDateController.text = todayDate;
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
      content: SizedBox(
        width: isDesktop ? width * 0.39 : width * 0.75,
        height: isDesktop ? height * 0.37 : height * 0.55,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isDesktop
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomDropDown(
                          items: status,
                          label: _locale.status,
                          initialValue: selectedStatus,
                          onChanged: (value) {
                            setState(() {
                              selectedStatus = value!;
                            });
                          },
                        ),
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
                                // DateTime to =
                                //     DateTime.parse(_toDateController.text);

                                // if (from.isAfter(to)) {
                                //   ErrorController.openErrorDialog(
                                //       1, _locale.startDateAfterEndDate);
                                // }
                              });
                            }
                          },
                        ),
                      ],
                    )
                  : Container(),
              isDesktop
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                        CustomDropDown(
                          //   width: width,
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
                          items: status,
                          label: _locale.status,
                          initialValue: selectedStatus,
                          width: width,
                          onChanged: (value) {
                            setState(() {
                              selectedStatus = value!;
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
                              print("inside filter :${selectedBranchCode}");
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
              height: width > 800 ? height * .057 : height * .06,
              fontSize: width > 800 ? height * .018 : height * .015,
              width: isDesktop ? width * 0.09 : width * 0.25,
              onPressed: () {
                DateTime from = DateTime.parse(_fromDateController.text);
                // DateTime to = DateTime.parse(_toDateController.text);

                widget.onFilter(
                    DatesController().formatDate(_fromDateController.text),
                    selectedStatus,
                    selectedChart,
                    selectedBranchCode);

                context
                    .read<DatesProvider>()
                    .setDatesController(_fromDateController, _toDateController);
                Navigator.of(context).pop();
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
      if (codeReportsList[i].txtReportnamee == ReportConstants.dailySales) {
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
