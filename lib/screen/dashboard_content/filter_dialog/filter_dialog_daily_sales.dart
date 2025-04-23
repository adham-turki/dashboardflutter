import 'dart:convert';

import 'package:bi_replicate/model/settings/user_settings/code_reports_model.dart';
import 'package:bi_replicate/provider/dates_provider.dart';
import 'package:bi_replicate/widget/drop_down/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../components/custom_date.dart';

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
  final String? selectedChart;
  final String? selectedStatus;
  final String? selectedBranchCodeF;
  final String? fromDate;
  final List<String>? branches;
  final Function(String fromDate, String selectedStatus, String chart,
      String selectedBranchCodeF) onFilter;

  const FilterDialogDailySales(
      {super.key,
      required this.onFilter,
      this.selectedChart,
      this.selectedBranchCodeF,
      this.selectedStatus,
      this.fromDate,
      this.branches});

  @override
  State<FilterDialogDailySales> createState() => _FilterDialogDailySalesState();
}

class _FilterDialogDailySalesState extends State<FilterDialogDailySales> {
  late AppLocalizations _locale;
  bool isDesktop = false;
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();
  double width = 0;
  double height = 0;
  String todayDate = "";
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

  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context)!;

    status = [
      _locale.all,
      _locale.posted,
      _locale.draft,
      _locale.canceled,
    ];

    branches = widget.branches ?? [_locale.all];

    charts = [_locale.lineChart, _locale.pieChart, _locale.barChart];
    selectedChart = widget.selectedChart!;
    selectedStatus = widget.selectedStatus!;
    todayDate = DatesController().formatDateReverse(
        DatesController().formatDate(DatesController().todayDate()));
    currentMonth = DatesController().formatDateReverse(
        DatesController().formatDate(DatesController().twoYearsAgo()));
    _fromDateController.text = widget.fromDate != null
        ? DatesController().formatDateReverse(widget.fromDate!)
        : currentMonth;
    _toDateController.text = todayDate;

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
                          width: width * 0.165,
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
                          lastDate: DateTime.now(),
                          minYear: 2000,
                          onValue: (isValid, value) {
                            if (isValid) {
                              setState(() {
                                _fromDateController.text = value;
                              });
                            }
                          },
                          dateControllerToCompareWith: null,
                          isInitiaDate: true,
                          timeControllerToCompareWith: null,
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
                        CustomDropDown(
                          width: width * 0.165,

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
                            lastDate: DateTime.now(),
                            minYear: 2000,
                            onValue: (isValid, value) {
                              if (isValid) {
                                setState(() {
                                  _fromDateController.text = value;
                                });
                              }
                            },
                            dateControllerToCompareWith: null,
                            isInitiaDate: true,
                            timeControllerToCompareWith: null,
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

        searchCriteriaa =
            SearchCriteria.fromJson(json.decode(startSearchCriteria));
        // _fromDateController.text =
        //     DatesController().formatDateReverse(searchCriteriaa!.fromDate!);
        // _toDateController.text =
        //     DatesController().formatDateReverse(searchCriteriaa!.toDate!);
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
      if (codeReportsList[i].txtReportnamee == ReportConstants.dailySales) {
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

    UserReportSettingsController()
        .editUserReportSettings(userReportSettingsModel);
  }
}
