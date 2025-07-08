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

  // Unified color scheme
  static const Color primaryColor = Color.fromRGBO(82, 151, 176, 1.0);
  static const Color primaryLight = Color.fromRGBO(82, 151, 176, 0.08);
  static const Color primaryDark = Color.fromRGBO(62, 131, 156, 1.0);
  static const Color backgroundColor = Color(0xFFFAFBFC);
  static const Color cardColor = Colors.white;

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
    charts = [
      _locale.lineChart,
      _locale.barChart
    ];
    selectedChart = widget.selectedChart!;
    selectedCategories = categories[1];
    branches = [_locale.all];
    selectedPeriod = widget.selectedPeriod!;
    todayDate = DatesController().formatDateReverse(
        DatesController().formatDate(DatesController().todayDate()));
    currentMonth = DatesController().formatDateReverse(
        DatesController().formatDate(DatesController().currentMonth()));
    _toDateController.text = (widget.toDate ?? "") != ""
        ? DatesController().formatDateReverse(widget.toDate!)
        : todayDate;
    _fromDateController.text = (widget.fromDate ?? "") != ""
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

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 40 : 16,
        vertical: 20,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isDesktop ? 700 : width - 32,
          maxHeight: height * 0.85,
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
                        "Sales by Category Filter",
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
                      // Date Range Section
                      _buildSection(
                        title: "Date Range",
                        child: _buildDateSection(),
                      ),
                      
                      SizedBox(height: isDesktop ? 16 : 12),
                      
                      // Category & Filters Section
                      _buildSection(
                        title: "Category & Filters",
                        child: _buildFiltersSection(),
                      ),
                      
                      SizedBox(height: isDesktop ? 16 : 12),
                      
                      // Stocks Section
                      _buildSection(
                        title: "Stock Selection",
                        child: _buildStocksSection(),
                      ),
                      
                      SizedBox(height: isDesktop ? 16 : 12),
                      
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
                      height: isDesktop ? height * .054 : height * .06,
                      fontSize: isDesktop ? height * .0158 : height * .015,
                      width: isDesktop ? width * 0.12 : width * 0.3,
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
    return isDesktop
        ? Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: height * 0.12,
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
              ),
              SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  height: height * 0.12,
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
              ),
            ],
          )
        : Column(
            children: [
              SizedBox(
                height: height * 0.12,
                width: width * 0.9,
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
              SizedBox(height: 12),
              SizedBox(
                height: height * 0.12,
                width: width * 0.9,
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
            ],
          );
  }

  Widget _buildFiltersSection() {
    return isDesktop
        ? Row(
            children: [
              Expanded(
                child: CustomDropDown(
                  width: double.infinity,
                  items: categories,
                  label: _locale.byCategory,
                  initialValue: selectedCategories,
                  onChanged: (value) {
                    setState(() {
                      selectedCategories = value!;
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

  Widget _buildStocksSection() {
    return SizedBox(
      width: double.infinity,
      height: isDesktop ? 100 : height * 0.08,
      child: Column(
        mainAxisAlignment: isDesktop ? MainAxisAlignment.center : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_locale.stocks),
          Expanded(
            child: TestDropdown(
                isEnabled: true,
                icon: const Icon(Icons.search),
                cleanPrevSelectedItem: true,
                onItemAddedOrRemoved: (value) {
                  for (int i = 0; i < value.length; i++) {
                    tempStocks.add(value[i]);
                    tempStocksCodes.add(tempStocks[i].txtStkcode ?? "");
                  }
                },
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    stocks.clear();
                    stocksCodes.clear();
                    tempStocks.clear();
                    tempStocksCodes.clear();
                    for (int i = 0; i < value.length; i++) {
                      stocks.add(value[i]);
                      stocksCodes.add(stocks[i].txtStkcode ?? "");
                    }
                    setState(() {});
                  }
                },
                stringValue: stocks.isEmpty
                    ? "${_locale.select} ${_locale.stocks}"
                    : stocks.map((b) => b.txtNamee).join(', '),
                borderText: "",
                onClearIconPressed: () {},
                onPressed: () {},
                onSearch: (text) async {
                  List<StockModel> value =
                      await TotalSalesController().getStocks(0, text);
                  value = value
                      .where((stock) => !tempStocks.any(
                          (temp) => temp.txtStkcode == stock.txtStkcode))
                      .toList();
                  return value;
                }),
          ),
        ],
      ),
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
        startSearchCriteria = startSearchCriteria.replaceAll('الكل', '');
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
