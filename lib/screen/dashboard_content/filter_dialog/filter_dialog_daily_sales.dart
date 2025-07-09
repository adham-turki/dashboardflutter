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

  // Unified color scheme
  static const Color primaryColor = Color.fromRGBO(82, 151, 176, 1.0);
  static const Color primaryLight = Color.fromRGBO(82, 151, 176, 0.08);
  static const Color primaryDark = Color.fromRGBO(62, 131, 156, 1.0);
  static const Color backgroundColor = Color(0xFFFAFBFC);
  static const Color cardColor = Colors.white;

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

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 40 : 16,
        vertical: 20,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isDesktop ? 600 : width - 32,
          maxHeight: height * 0.8,
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
                  horizontal: isDesktop ? 20 : 16
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
                    Icon(Icons.filter_alt_outlined, 
                         color: Colors.white, 
                         size: isDesktop ? 20 : 18),
                    SizedBox(width: isDesktop ? 8 : 6),
                    Expanded(
                      child: Text(
                        _locale.dailySalesFilter ?? "Daily Sales Filter",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isDesktop ? 16 : 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: EdgeInsets.all(isDesktop ? 4 : 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.close, 
                                   color: Colors.white, 
                                   size: isDesktop ? 16 : 14),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(isDesktop ? 16 : 12),
                  child: Column(
                    children: [
                      // Date Section
                      _buildSection(
                        title: _locale.dateRange ?? "Date Range",
                        child: _buildDateSection(),
                      ),
                      
                      SizedBox(height: isDesktop ? 16 : 12),
                      
                      // Filters Section
                      _buildSection(
                        title: _locale.filters ?? "Filters",
                        child: _buildFiltersSection(),
                      ),
                      
                      SizedBox(height: isDesktop ? 16 : 12),
                      
                      // Display Options Section
                      _buildSection(
                        title: _locale.displayOptions ?? "Display Options",
                        child: _buildDisplaySection(),
                      ),
                    ],
                  ),
                ),
              ),

              // Actions
              Container(
                padding: EdgeInsets.all(isDesktop ? 16 : 12),
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
                      height: isDesktop ? height * .057 : height * .06,
                      fontSize: isDesktop ? height * .018 : height * .015,
                      width: isDesktop ? width * 0.12 : width * 0.3,
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Container(
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
              vertical: isDesktop ? 12 : 10
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
                fontSize: isDesktop ? 14 : 12,
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
    return SizedBox(
      height: isDesktop ? height * 0.12 : height * 0.1,
      width: double.infinity,
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
    );
  }

  Widget _buildFiltersSection() {
    return isDesktop
        ? Row(
            children: [
              Expanded(
                child: CustomDropDown(
                  width: double.infinity,
                  items: status,
                  label: _locale.status,
                  initialValue: selectedStatus,
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value!;
                    });
                  },
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: CustomDropDown(
                  width: double.infinity,
                  items: branches,
                  label: _locale.branch,
                  initialValue: selectedBranch,
                  onChanged: (value) {
                    setState(() {
                      selectedBranch = value.toString();
                      selectedBranchCode = branchesMap[value.toString()]!;
                    });
                  },
                ),
              ),
            ],
          )
        : Column(
            children: [
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
              SizedBox(height: 12),
              CustomDropDown(
                width: width,
                items: branches,
                label: _locale.branch,
                initialValue: selectedBranch,
                onChanged: (value) {
                  setState(() {
                    selectedBranch = value.toString();
                    selectedBranchCode = branchesMap[value.toString()]!;
                  });
                },
              ),
            ],
          );
  }

  Widget _buildDisplaySection() {
    return CustomDropDown(
      items: charts,
      hint: "",
      width: isDesktop ? double.infinity : width,
      label: _locale.chartType,
      initialValue: selectedChart,
      onChanged: (value) {
        setState(() {
          selectedChart = value!;
        });
      },
    );
  }

  // Keep all existing methods unchanged
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