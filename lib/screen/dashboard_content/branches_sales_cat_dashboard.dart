  import 'dart:async';
  import 'dart:convert';
  import 'dart:math';
  import 'package:bi_replicate/components/dashboard_components/line_dasboard_chart.dart';
  import 'package:bi_replicate/controller/sales_adminstration/branch_controller.dart';
  import 'package:bi_replicate/provider/dates_provider.dart';
  import 'package:dropdown_button2/dropdown_button2.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter_gen/gen_l10n/app_localizations.dart';
  import 'package:bi_replicate/model/criteria/search_criteria.dart';
  import 'package:flutter_secure_storage/flutter_secure_storage.dart';
  import 'package:intl/intl.dart';
  import 'package:provider/provider.dart';
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
    List<String> stocksCodes1 = [];

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

      return LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            height: constraints.maxHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(
                  color: Color.fromRGBO(82, 151, 176, 0.2),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  // Header Section
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 1),
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(82, 151, 176, 0.05),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                width: 4,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(82, 151, 176, 1),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  _locale.branchesSalesByCategories,
                                  style: TextStyle(
                                    fontSize: isDesktop ? 14 : 16,
                                    fontWeight: FontWeight.w600,
                                    color: const Color.fromRGBO(82, 151, 176, 1),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              ValueListenableBuilder(
                                valueListenable: totalBranchesByCateg,
                                builder: ((context, value, child) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color.fromRGBO(82, 151, 176, 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '(\u200E${NumberFormat('#,###', 'en_US').format(double.parse(totalBranchesByCateg.value.toString()))})',
                                      style: TextStyle(
                                        fontSize: isDesktop ? 10 : 12,
                                        fontWeight: FontWeight.w500,
                                        color: const Color.fromRGBO(82, 151, 176, 1),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _locale.localeName == "en"
                                    ? "(${fromDateController.text} - ${toDateController.text})"
                                    : "($fromDate - $toDate)",
                                style: TextStyle(
                                  fontSize: isDesktop ? 10 : 11,
                                  color: Colors.grey.shade600,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        blueButton1(
                          icon: Icon(
                            Icons.filter_list_sharp,
                            color: Colors.white,
                            size: isDesktop ? height * 0.025 : height * 0.022,
                          ),
                          textColor: const Color.fromARGB(255, 255, 255, 255),
                          onPressed: () {
                            if (isLoading == false) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return FilterDialogSalesByCategory(
                                    selectedChart: getChartByCode(selectedChart, _locale),
                                    selectedBranchCodeF: selectedBranchCode == ""
                                        ? _locale.all
                                        : selectedBranchCode,
                                    selectedPeriod: getPeriodByCode(selectedPeriod, _locale),
                                    fromDate: fromDateController.text,
                                    toDate: toDateController.text,
                                    selectedCategory: getCategoryByCode(selectedCategories, _locale),
                                    branches: branches,
                                    onFilter: (selectedPeriodF,
                                        fromDate,
                                        toDate,
                                        selectedCategoriesF,
                                        selectedBranchCodeF,
                                        chart,
                                        stocksCodes) {
                                      stocksCodes1 = stocksCodes;
                                      fromDateController.text = fromDate;
                                      toDateController.text = toDate;
                                      selectedCategories = getCategoryNum(selectedCategoriesF, _locale);
                                      selectedBranchCode = selectedBranchCodeF == _locale.all
                                          ? ""
                                          : selectedBranchCodeF;
                                      selectedPeriod = getPeriodByName(selectedPeriodF, _locale);
                                      selectedChart = getChartByName(chart, _locale);
                                      SearchCriteria searchCriteria = SearchCriteria(
                                        fromDate: fromDateController.text,
                                        toDate: toDateController.text.isEmpty
                                            ? todayDate
                                            : toDateController.text,
                                        byCategory: getCategoryNum(selectedCategoriesF, _locale),
                                        branch: selectedBranchCode,
                                        codesStock: stocksCodes1,
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
                        ),
                      ],
                    ),
                  ),

                  // Chart Section
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Color.fromRGBO(82, 151, 176, 1),
                                strokeWidth: 3,
                              ),
                            )
                          : _buildChartContent(constraints),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    Widget _buildChartContent(BoxConstraints constraints) {
      if (selectedChart == Line_Chart) {
        return _buildLineChart(constraints);
      } else if (selectedChart == Pie_Chart) {
        return _buildPieChart(constraints);
      } else {
        // Bar Chart
        return _buildBarChart(constraints);
      }
    }

    Widget _buildLineChart(BoxConstraints constraints) {
      return LayoutBuilder(
        builder: (context, chartConstraints) {
          return SizedBox(
            height: chartConstraints.maxHeight,
            width: chartConstraints.maxWidth,
            child: LineDashboardChart(
              isMax: false,
              isMedium: true,
              balances: listOfBalances,
              periods: listOfPeriods,
            ),
          );
        },
      );
    }

    Widget _buildPieChart(BoxConstraints constraints) {
      return LayoutBuilder(
        builder: (context, chartConstraints) {
          final availableSize = chartConstraints.biggest.shortestSide;
          final chartSize = availableSize * 0.8;
          
          return Center(
            child: SizedBox(
              height: chartSize,
              width: chartSize,
              child: pieData.isNotEmpty
                  ? PieDashboardChart(
                      dataList: pieData,
                    )
                  : _buildNoDataWidget(Icons.pie_chart_outline),
            ),
          );
        },
      );
    }

    Widget _buildBarChart(BoxConstraints constraints) {
      return LayoutBuilder(
        builder: (context, chartConstraints) {
          return Scrollbar(
            thumbVisibility: true,
            thickness: 6,
            trackVisibility: true,
            radius: const Radius.circular(8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                height: chartConstraints.maxHeight,
                width: isDesktop
                    ? barData.length > 20
                        ? chartConstraints.maxWidth * (barData.length / 20)
                        : chartConstraints.maxWidth
                    : barData.length > 5
                        ? chartConstraints.maxWidth * (barData.length / 10)
                        : chartConstraints.maxWidth,
                child: barData.isNotEmpty
                    ? BarDashboardChart(
                        barChartData: barData,
                        isMax: false,
                        isMedium: true,
                      )
                    : _buildNoDataWidget(Icons.bar_chart_outlined),
              ),
            ),
          );
        },
      );
    }

    Widget _buildNoDataWidget(IconData icon) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              _locale.noDataAvailable,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
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
          startSearchCriteria = startSearchCriteria.replaceAll('الكل', '');

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
          fromDateController.text = searchCriteriaa!.fromDate!.isEmpty
              ? currentYear
              : searchCriteriaa!.fromDate!;
          toDateController.text = searchCriteriaa!.toDate!.isEmpty
              ? todayDate
              : searchCriteriaa!.toDate!;
          fromDateController.text =
              context.read<DatesProvider>().sessionFromDate.isNotEmpty
                  ? DatesController().dashFormatDate(
                      context.read<DatesProvider>().sessionFromDate, false)
                  : searchCriteriaa!.fromDate!;
          toDateController.text =
              context.read<DatesProvider>().sessionToDate.isNotEmpty
                  ? DatesController().dashFormatDate(
                      context.read<DatesProvider>().sessionToDate, false)
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
          });
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

    Color getRandomColor(List<Color> colorList) {
      final random = Random();
      int r = random.nextInt(256);
      int g = random.nextInt(256);
      int b = random.nextInt(256);
      return Color.fromRGBO(r, g, b, 1.0);
    }

    double formatDoubleToTwoDecimalPlaces(double number) {
      return double.parse(number.toStringAsFixed(2));
    }

    Future<void> getBranchByCat({bool? isStart}) async {
      var selectedFromDate = fromDateController.text;
      var selectedToDate = toDateController.text;

      lastFromDate = selectedFromDate;
      lastToDate = selectedToDate;

      lastCategories = getCategoryByCode(selectedCategories, _locale);
      lastBranchCode = selectedBranchCode;

      SearchCriteria searchCriteria = SearchCriteria(
          fromDate: selectedFromDate,
          toDate: selectedToDate,
          byCategory: selectedCategories,
          branch: selectedBranchCode == "الكل" ? "" : selectedBranchCode,
          codesStock: stocksCodes1);
      setSearchCriteria(searchCriteria);
      pieData = [];
      barData = [];
      listOfBalances = [];
      listOfPeriods = [];

      await salesCategoryController
          .getSalesByCategory(searchCriteria, isStart: isStart)
          .then((value) {
        for (var element in value) {
          double bal = element.creditAmt! - element.debitAmt!;

          if (bal != 0.0) {
            temp = true;
          } else if (bal == 0.0) {
            temp = false;
          }
          listOfBalances.add(bal);
          listOfPeriods.add(
            element.categoryName!.isNotEmpty ? element.categoryName! : "-",
          );
          if (temp) {
            dataMap[element.categoryName!] = formatDoubleToTwoDecimalPlaces(bal);

            pieData.add(
              PieChartModel(
                title: element.categoryName!.isNotEmpty
                    ? element.categoryName!
                    : "-",
                value: formatDoubleToTwoDecimalPlaces(bal),
                color: getRandomColor(colorNewList),
              ),
            );
            barData.add(
              BarData(
                name: element.categoryName!.isNotEmpty
                    ? element.categoryName!
                    : "-",
                percent: formatDoubleToTwoDecimalPlaces(bal),
              ),
            );
          }
        }

        double total = 0.0;
        for (int i = 0; i < listOfBalances.length; i++) {
          total += listOfBalances[i];
        }
        totalBranchesByCateg.value = total;
      });
    }

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
      _stopTimer();
      super.dispose();
    }

    void _stopTimer() {
      if (_timer != null) {
        _timer!.cancel();
        _timer = null;
      }
    }

    void getBranch() async {
      BranchController().getBranch().then((value) {
        branches.add(_locale.all);
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