import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:bi_replicate/components/dashboard_components/bar_dashboard_chart.dart';
import 'package:bi_replicate/provider/dates_provider.dart';
import 'package:bi_replicate/utils/constants/maps.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:bi_replicate/model/criteria/search_criteria.dart';
import 'package:bi_replicate/utils/func/converters.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../controller/sales_adminstration/sales_branches_controller.dart';
import '../../../model/chart/pie_chart_model.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/func/dates_controller.dart';
import '../../components/charts.dart';
import '../../components/dashboard_components/line_dasboard_chart.dart';
import '../../components/dashboard_components/pie_dashboard_chart.dart';
import '../../controller/settings/user_settings/code_reports_controller.dart';
import '../../controller/settings/user_settings/user_report_settings_controller.dart';
import '../../model/settings/user_settings/code_reports_model.dart';
import '../../model/settings/user_settings/user_report_settings.dart';
import '../../utils/constants/app_utils.dart';
import '../../utils/constants/pages_constants.dart';
import '../../utils/constants/responsive.dart';
import 'filter_dialog/filter_dialog_sales_branches.dart';

class BalanceBarChartDashboard extends StatefulWidget {
  const BalanceBarChartDashboard({
    Key? key,
  }) : super(key: key);

  @override
  State<BalanceBarChartDashboard> createState() =>
      _BalanceBarChartDashboardState();
}

class _BalanceBarChartDashboardState extends State<BalanceBarChartDashboard> {
  int colorIndex = 0;

  List<CustomBarChart> data = [];
  double width = 0;
  final dropdownKey = GlobalKey<DropdownButton2State>();
  double height = 0;
  SalesBranchesController salesBranchesController = SalesBranchesController();

  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  String todayDate = "";
  String currentMonth = "";

  int period = 0;
  int selectedChart = 0;

  String lastFromDate = "";
  String lastToDate = "";

  late AppLocalizations _locale;

  final dataMap = <String, double>{};

  List<double> listOfBalances = [];
  List<String> listOfPeriods = [];

  List<BarData> barData = [];
  List<PieChartModel> pieData = [];

  bool isDesktop = false;
  List<CodeReportsModel> codeReportsList = [];
  List<UserReportSettingsModel> userReportSettingsList = [];
  String startSearchCriteria = "";
  String currentPageName = "";
  String currentPageCode = "";
  SearchCriteria? searchCriteriaa;
  String txtKey = "";
  int count = 0;
  bool isLoading = false;
  ValueNotifier totalBranchesSale = ValueNotifier(0);
  Timer? _timer;

  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context)!;
    todayDate = DatesController().formatDate(DatesController().todayDate());
    currentMonth =
        DatesController().formatDate(DatesController().twoYearsAgo());

    if (count == 0) {
      fromDateController.text = "";
      toDateController.text = "";

      period = Daily_Period;
    }
    count++;
    super.didChangeDependencies();
  }

  Future<void> getSalesData() async {
    await getSalesByBranch1().then((value) {
      setState(() {});
    });
  }

  bool dataLoaded = false;

  @override
  void initState() {
    getAllCodeReports();
    _startTimer();
    super.initState();
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
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: Responsive.isDesktop(context) ? 6 : 10,
                  ),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 4,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    color: const Color.fromRGBO(82, 151,176, 1),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: ValueListenableBuilder(
                                    valueListenable: totalBranchesSale,
                                    builder: (context, value, child) {
                                      return SelectableText(
                                        "${_locale.salesByBranches} (\u200E${NumberFormat('#,###', 'en_US').format(double.parse(totalBranchesSale.value.toString()))})",
                                        style: TextStyle(
                                          fontSize: isDesktop ? 15 : 17,
                                          fontWeight: FontWeight.w600,
                                          color: const Color.fromRGBO(82, 151, 176, 1),
                                        ),
                                        maxLines: 1,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            if (Responsive.isDesktop(context))
                              Padding(
                                padding: const EdgeInsets.only(top: 4, left: 12),
                                child: Text(
                                  _locale.localeName == "en"
                                      ? "(${fromDateController.text} - ${toDateController.text})"
                                      : "($fromDate - $toDate)",
                                  style: TextStyle(
                                    fontSize: isDesktop ? 11 : 13,
                                    color: Colors.grey.shade600,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: isDesktop
                            ? MediaQuery.of(context).size.width * 0.08
                            : MediaQuery.of(context).size.width * 0.27,
                        child: blueButton1(
                          icon: Icon(
                            Icons.filter_list_sharp,
                            color: whiteColor,
                            size: isDesktop ? height * 0.03 : height * 0.025,
                          ),
                          textColor: const Color.fromARGB(255, 255, 255, 255),
                          onPressed: () {
                            if (isLoading == false) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return FilterDialogSalesByBranches(
                                    selectedChart: getChartByCode(selectedChart, _locale),
                                    selectedPeriod: getPeriodByCode(period, _locale),
                                    fromDate: fromDateController.text,
                                    toDate: toDateController.text,
                                    onFilter: (selectedPeriod, fromDate, toDate, chart) {
                                      fromDateController.text = fromDate;
                                      toDateController.text = toDate;
                                      period = getPeriodByName(selectedPeriod, _locale);
                                      selectedChart = getChartByName(chart, _locale);
                                      SearchCriteria searchCriteria = SearchCriteria(
                                        fromDate: fromDateController.text,
                                        toDate: toDateController.text.isEmpty
                                            ? todayDate
                                            : toDateController.text,
                                        voucherStatus: -100,
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
                                getSalesByBranch().then((value) {
                                  setState(() {
                                    _startTimer();
                                    if (selectedChart == Pie_Chart) {
                                      if (barData.length < 4) {
                                        selectedChart = Pie_Chart;
                                      } else {
                                        selectedChart = Bar_Chart;
                                      }
                                    }
                                    isLoading = false;
                                  });
                                });
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                if (!Responsive.isDesktop(context))
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          _locale.localeName == "en"
                              ? "(${fromDateController.text} - ${toDateController.text})"
                              : "($fromDate - $toDate)",
                          style: TextStyle(
                            fontSize: height * 0.013,
                            color: Colors.grey.shade600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: Responsive.isDesktop(context) ? 2 : 6,
                    ),
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
    if (selectedChart == Bar_Chart || (selectedChart == Pie_Chart && barData.length >= 4)) {
      return _buildBarChart(constraints);
    } else if (selectedChart == Line_Chart) {
      return _buildLineChart(constraints);
    } else {
      return _buildPieChart(constraints);
    }
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
              width: Responsive.isDesktop(context)
                  ? barData.length > 20
                      ? chartConstraints.maxWidth * (barData.length / 20)
                      : chartConstraints.maxWidth
                  : barData.length > 5
                      ? chartConstraints.maxWidth * (barData.length / 10)
                      : chartConstraints.maxWidth,
              child: BarDashboardChart(
                barChartData: barData,
                isMax: false,
                isMedium: false,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLineChart(BoxConstraints constraints) {
    return LayoutBuilder(
      builder: (context, chartConstraints) {
        return SizedBox(
          height: chartConstraints.maxHeight,
          width: chartConstraints.maxWidth,
          child: LineDashboardChart(
            isMax: false,
            isMedium: false,
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
            child: PieDashboardChart(
              dataList: pieData,
            ),
          ),
        );
      },
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
        fromDateController.text = searchCriteriaa!.fromDate!.isEmpty
            ? currentMonth
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
      }
    }
  }

  getAllCodeReports() async {
    setState(() {
      isLoading = true;
    });
    CodeReportsController().getAllCodeReports().then((value) {
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
      if (!dataLoaded) {
        dataLoaded = true;
        await getSalesData();
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  setPageName() {
    for (var i = 0; i < codeReportsList.length; i++) {
      if (codeReportsList[i].txtReportnamee ==
          ReportConstants.salesByBranches) {
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

  double formatDoubleToTwoDecimalPlaces(double number) {
    return double.parse(number.toStringAsFixed(2));
  }

  Color getRandomColor(List<Color> colorList) {
    final random = Random();
    final index = random.nextInt(colorList.length);
    return colorList[index];
  }

  Future<void> getSalesByBranch1() async {
    final selectedFromDate = fromDateController.text;
    final selectedToDate = toDateController.text;

    SearchCriteria searchCriteria = SearchCriteria(
      fromDate: selectedFromDate,
      toDate: selectedToDate,
      voucherStatus: -100,
    );
    setSearchCriteria(searchCriteria);
    pieData = [];
    dataMap.clear();
    barData = [];
    listOfBalances = [];
    listOfPeriods = [];
    await salesBranchesController
        .getSalesByBranches(searchCriteria)
        .then((value) {
      lastFromDate = selectedFromDate;
      lastToDate = selectedToDate;
      for (var element in value) {
        double a = (element.totalSales! + element.retSalesDis!) -
            (element.salesDis! + element.totalReturnSales!);

        a = Converters().formateDouble(a);
        listOfBalances.add(a);
        listOfPeriods.add(element.namee!);
        if (a < 0) {
          a = 0.0;
        }
        dataMap[element.namee!] = formatDoubleToTwoDecimalPlaces(a);
        pieData.add(PieChartModel(
          title: element.namee!,
          value: formatDoubleToTwoDecimalPlaces(a),
          color: getNextColor(),
        ));
        barData.add(
          BarData(name: element.namee!, percent: a),
        );
      }
      double total = 0;
      for (int i = 0; i < listOfBalances.length; i++) {
        total += listOfBalances[i];
      }
      totalBranchesSale.value = total;
    });
    if (barData.length < 4) {
      selectedChart = Pie_Chart;
    } else {
      selectedChart = Bar_Chart;
    }
  }

  void _startTimer() {
    const storage = FlutterSecureStorage();

    const duration = Duration(minutes: 5);
    _timer = Timer.periodic(duration, (Timer t) async {
      String? token = await storage.read(key: "jwt");
      if (token != null) {
        await getSalesByBranch().then((value) async {
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

  Future<void> getSalesByBranch() async {
    final selectedFromDate = fromDateController.text;
    final selectedToDate = toDateController.text;

    if (dataLoaded) {
      SearchCriteria searchCriteria = SearchCriteria(
        fromDate: selectedFromDate,
        toDate: selectedToDate,
        voucherStatus: -100,
      );
      pieData = [];
      dataMap.clear();
      barData = [];
      listOfBalances = [];
      listOfPeriods = [];
      await salesBranchesController
          .getSalesByBranches(searchCriteria)
          .then((value) {
        lastFromDate = selectedFromDate;
        lastToDate = selectedToDate;
        for (var element in value) {
          double a = (element.totalSales! + element.retSalesDis!) -
              (element.salesDis! + element.totalReturnSales!);

          a = Converters().formateDouble(a);
          listOfBalances.add(a);
          listOfPeriods.add(element.namee!);
          if (a < 0) {
            a = 0.0;
          }
          dataMap[element.namee!] = formatDoubleToTwoDecimalPlaces(a);
          pieData.add(PieChartModel(
            title: element.namee!,
            value: formatDoubleToTwoDecimalPlaces(a),
            color: getNextColor(),
          ));
          barData.add(
            BarData(name: element.namee!, percent: a),
          );
        }
        double total = 0;
        for (int i = 0; i < listOfBalances.length; i++) {
          total += listOfBalances[i];
        }
        totalBranchesSale.value = total;
      });
    }
  }

  Color getNextColor() {
    final color = colorListDashboard[colorIndex];
    colorIndex = (colorIndex + 1) % colorListDashboard.length;
    return color;
  }
}