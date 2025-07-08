import 'dart:convert';
import 'package:bi_replicate/provider/dates_provider.dart';
import 'package:bi_replicate/widget/drop_down/custom_dropdown.dart';
import 'package:flutter/material.dart';
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

  const FilterDialogSalesByBranches({
    super.key,
    required this.onFilter,
    this.selectedChart,
    this.selectedPeriod,
    this.fromDate,
    this.toDate,
  });

  @override
  State<FilterDialogSalesByBranches> createState() =>
      _FilterDialogSalesByBranchesState();
}

class _FilterDialogSalesByBranchesState
    extends State<FilterDialogSalesByBranches> {
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

  // Unified color scheme
  static const Color primaryColor = Color.fromRGBO(82, 151, 176, 1.0);
  static const Color primaryLight = Color.fromRGBO(82, 151, 176, 0.08);
  static const Color primaryDark = Color.fromRGBO(62, 131, 156, 1.0);
  static const Color backgroundColor = Color(0xFFFAFBFC);
  static const Color cardColor = Colors.white;

  @override
  void didChangeDependencies() {
    status = [
      "All",
      "Posted",
      "Draft",
      "Canceled",
    ];
    periods = [
      "Daily",
      "Weekly",
      "Monthly",
      "Yearly",
    ];
    charts = ["Line Chart", "Pie Chart", "Bar Chart"];
    selectedChart = widget.selectedChart ?? "Line Chart";
    selectedPeriod = widget.selectedPeriod ?? "Monthly";
    selectedStatus = status[0];
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

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isDesktop ? width * 0.1 : 16,
        vertical: isDesktop ? 40 : 24,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isDesktop ? 600 : width * 0.9,
          maxHeight: height * 0.85,
          minWidth: isDesktop ? 400 : width * 0.85,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: isDesktop ? 16 : 12,
                  horizontal: isDesktop ? 20 : 16,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, primaryDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.filter_alt_outlined,
                      color: Colors.white,
                      size: isDesktop ? 24 : 20,
                    ),
                    SizedBox(width: isDesktop ? 12 : 8),
                    Expanded(
                      child: Text(
                        "Sales by Branches Filter",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isDesktop ? 18 : 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: EdgeInsets.all(isDesktop ? 6 : 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: isDesktop ? 20 : 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(isDesktop ? 20 : 16),
                  child: Column(
                    children: [
                      // Date Range Section
                      _buildSection(
                        title: "Date Range",
                        child: _buildDateSection(),
                      ),
                      SizedBox(height: isDesktop ? 20 : 16),
                      // Display Options Section
                      _buildSection(
                        title: "Display Options",
                        child: _buildDisplaySection(),
                      ),
                    ],
                  ),
                ),
              ),

              // Actions
              Container(
                padding: EdgeInsets.all(isDesktop ? 20 : 16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Components().blueButton(
                      height: isDesktop ? 48 : 40,
                      fontSize: isDesktop ? 16 : 14,
                      width: isDesktop ? 120 : width * 0.35,
                      onPressed: () {
                        DateTime from = DateTime.parse(_fromDateController.text);
                        DateTime to = DateTime.parse(_toDateController.text);
                        if (from.isAfter(to)) {
                          ErrorController.openErrorDialog(
                              1, "Start date cannot be after end date");
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
                      text: "Filter",
                      borderRadius: 8,
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      margin: EdgeInsets.only(bottom: isDesktop ? 12 : 8),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 16 : 12,
              vertical: isDesktop ? 12 : 10,
            ),
            decoration: BoxDecoration(
              color: primaryLight,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Text(
              title,
              style: TextStyle(
                color: primaryDark,
                fontSize: isDesktop ? 15 : 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(isDesktop ? 16 : 12),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildDateSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 400 && isDesktop;
        return isWide
            ? Row(
                children: [
                  Expanded(
                    child: CustomDate(
                      dateController: _fromDateController,
                      label: "From Date",
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
                  SizedBox(width: 16),
                  Expanded(
                    child: CustomDate(
                      dateController: _toDateController,
                      label: "To Date",
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
                ],
              )
            : Column(
                children: [
                  CustomDate(
                    dateController: _fromDateController,
                    label: "From Date",
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
                  SizedBox(height: 12),
                  CustomDate(
                    dateController: _toDateController,
                    label: "To Date",
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
                ],
              );
      },
    );
  }

  Widget _buildDisplaySection() {
    return Column(
      children: [
        CustomDropDown(
          width: double.infinity,
          items: charts,
          hint: "Select Chart Type",
          label: "Chart Type",
          initialValue: selectedChart,
          onChanged: (value) {
            setState(() {
              selectedChart = value!;
            });
          },
        ),
        SizedBox(height: 12),
        CustomDropDown(
          width: double.infinity,
          items: periods,
          hint: "Select Period",
          label: "Period",
          initialValue: selectedPeriod,
          onChanged: (value) {
            setState(() {
              selectedPeriod = value!;
              checkPeriods(value);
            });
          },
        ),
      ],
    );
  }

  setStartSearchCriteria() {
    for (var i = 0; i < userReportSettingsList.length; i++) {
      if (currentPageCode == userReportSettingsList[i].txtReportcode) {
        txtKey = userReportSettingsList[i].txtKey;
        startSearchCriteria = userReportSettingsList[i].txtJsoncrit;
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
        startSearchCriteria =
            startSearchCriteria.replaceAll('{', '').replaceAll('}', '');
        startSearchCriteria = '{$startSearchCriteria}';
        searchCriteriaa =
            SearchCriteria.fromJson(json.decode(startSearchCriteria));
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
          ReportConstants.salesByBranches) {
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
        .editUserReportSettings(userReportSettingsModel)
        .then((value) {
      if (value.statusCode == 200) {}
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