import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:bi_replicate/components/dashboard_components/bar_dashboard_chart.dart';
import 'package:bi_replicate/components/dashboard_components/line_dasboard_chart.dart';
import 'package:bi_replicate/components/dashboard_components/pie_dashboard_chart.dart';
import 'package:bi_replicate/controller/sales_adminstration/branch_controller.dart';
import 'package:bi_replicate/provider/dates_provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:bi_replicate/model/criteria/search_criteria.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../model/chart/pie_chart_model.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/func/dates_controller.dart';
import '../../components/charts.dart';
import '../../controller/sales_adminstration/daily_sales_controller.dart';
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
import 'filter_dialog/filter_dialog_daily_sales.dart';

class DailySalesDashboard extends StatefulWidget {
  const DailySalesDashboard({
    Key? key,
  }) : super(key: key);

  @override
  State<DailySalesDashboard> createState() => _DailySalesDashboardState();
}

class _DailySalesDashboardState extends State<DailySalesDashboard> {
  double width = 0;
  double height = 0;
  final dropdownKey = GlobalKey<DropdownButton2State>();
  bool isDesktop = false;
  final storage = const FlutterSecureStorage();
  DailySalesController dailySalesController = DailySalesController();
  late AppLocalizations _locale;

  List<String> status = [];
  List<String> charts = [];
  bool accountsActive = false;

  TextEditingController fromDateController = TextEditingController();
  int statusVar = 0;
  String todayDate = "";
  int selectedStatus = 0;
  int selectedChart = 0;
  List<double> listOfBalances = [];
  List<String> listOfPeriods = [];
  final dataMap = <String, double>{};
  bool boolTemp = false;
  List<BarData> barData = [];
  List<PieChartModel> barDataDailySales = [];
  var selectedBranchCode = "";
  List<BiAccountModel> payableAccounts = [];
  final List<String> items = [
    'Print',
    'Save as JPEG',
    'Save as PNG',
  ];
  List<BarData> barDataTest = [];
  String lastBranchCode = "";
  String accountNameString = "";
  String lastFromDate = "";
  String lastStatus = "";
  List<CodeReportsModel> codeReportsList = [];
  List<UserReportSettingsModel> userReportSettingsList = [];
  String startSearchCriteria = "";
  String currentPageName = "";
  String currentPageCode = "";
  SearchCriteria? searchCriteriaa;
  String txtKey = "";
  int counter = 0;
  bool isLoading = true;
  List<String> branches = [];
  ValueNotifier totalDailySale = ValueNotifier(0);
  Timer? _timer;

  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context)!;
    getBranch();
    todayDate = DatesController().formatDate(DatesController().twoYearsAgo());

    if (counter == 0) {
      fromDateController.text = "";
      selectedChart = Line_Chart;
      selectedStatus = All_Status;
      statusVar = All_Status;
      selectedBranchCode = "";
    }
    counter++;
    super.didChangeDependencies();
  }

  Future<void> getPayableAccountsData() async {
    await getDailySales1().then((value) {});
  }

  bool dataLoaded = false;

  @override
  void initState() {
    getAllCodeReports();
    getPayableAccounts(isStart: true).then((value) {
      payableAccounts = value;
    });
    _startTimer();
    super.initState();
  }

  // Helper method to get pie chart specific dimensions
  Size getPieChartSize() {
    final screenWidth = MediaQuery.of(context).size.width;
    final availableHeight = MediaQuery.of(context).size.height * (isDesktop ? 0.4 : 0.45);
    
    if (isDesktop) {
      double maxSize = min(screenWidth * 0.35, availableHeight * 0.9);
      return Size(maxSize, maxSize);
    } else if (Responsive.isTablet(context)) {
      double maxSize = min(screenWidth * 0.5, availableHeight * 0.85);
      return Size(maxSize, maxSize);
    } else {
      double maxSize = min(screenWidth * 0.8, availableHeight * 0.8);
      return Size(maxSize, maxSize);
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    isDesktop = Responsive.isDesktop(context);

    String fromDate = fromDateController.text.isEmpty
        ? ""
        : DatesController().formatDateReverse(fromDateController.text);

    return Container(
      height: isDesktop ? height * 0.5 : height * 0.6,
      constraints: const BoxConstraints(
        minHeight: 300,
        maxHeight: 600,
      ),
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                            _locale.dailySales,
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
                          valueListenable: totalDailySale,
                          builder: (context, value, child) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(82, 151, 176, 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '(\u200E${NumberFormat('#,###', 'en_US').format(double.parse(totalDailySale.value.toString()))})',
                                style: TextStyle(
                                  fontSize: isDesktop ? 10 : 12,
                                  fontWeight: FontWeight.w500,
                                  color: const Color.fromRGBO(82, 151, 176, 1),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _locale.localeName == "en"
                              ? "(${fromDateController.text})"
                              : "($fromDate)",
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
                      color: whiteColor,
                      size: isDesktop ? height * 0.025 : height * 0.022,
                    ),
                    textColor: const Color.fromARGB(255, 255, 255, 255),
                    height: isDesktop ? height * 0.008 : height * 0.035,
                    fontSize: isDesktop ? height * 0.016 : height * 0.015,
                    width: isDesktop ? width * 0.08 : width * 0.27,
                    onPressed: () {
                      if (isLoading == false) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return FilterDialogDailySales(
                              selectedChart: getChartByCode(selectedChart, _locale),
                              selectedStatus: getVoucherStatusByCode(_locale, statusVar),
                              selectedBranchCodeF: selectedBranchCode == "" ? _locale.all : selectedBranchCode,
                              fromDate: fromDateController.text,
                              branches: branches,
                              onFilter: (fromDate, selectedStatus, chart, selectedBranchCodeF) {
                                fromDateController.text = fromDate;
                                statusVar = getVoucherStatus(_locale, selectedStatus);
                                selectedChart = getChartByName(chart, _locale);
                                selectedBranchCode = selectedBranchCodeF == _locale.all ? "" : selectedBranchCodeF;
                                SearchCriteria searchCriteria = SearchCriteria(
                                  fromDate: fromDateController.text,
                                  voucherStatus: -100,
                                  branch: "",
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
                          getDailySales().then((value) {
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
                    : _buildChartContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartContent() {
    if (selectedChart == Bar_Chart || (selectedChart == Pie_Chart && barDataDailySales.length >= 4)) {
      return _buildBarChart();
    } else if (selectedChart == Line_Chart) {
      return _buildLineChart();
    } else {
      return _buildPieChart();
    }
  }

  Widget _buildBarChart() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scrollbar(
          thumbVisibility: true,
          thickness: 6,
          trackVisibility: true,
          radius: const Radius.circular(8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              height: min(MediaQuery.of(context).size.height * (isDesktop ? 0.4 : 0.45), constraints.maxHeight),
              width: isDesktop
                  ? barData.length > 20
                      ? MediaQuery.of(context).size.width * 0.9 * (barData.length / 20)
                      : MediaQuery.of(context).size.width * 0.9
                  : barData.length > 5
                      ? MediaQuery.of(context).size.width * 0.95 * (barData.length / 10)
                      : MediaQuery.of(context).size.width * 0.95,
              child: BarDashboardChart(
                barChartData: barData,
                isMax: true,
                isMedium: false,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLineChart() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * (isDesktop ? 0.4 : 0.45),
      child: LineDashboardChart(
        isMax: true,
        isMedium: false,
        balances: listOfBalances,
        periods: listOfPeriods,
      ),
    );
  }

  Widget _buildPieChart() {
    final pieSize = getPieChartSize();
    return LayoutBuilder(
      builder: (context, constraints) {
        double horizontalPadding = isDesktop ? 12 : 16;
        double verticalPadding = isDesktop ? 8 : 12;
        return ClipRect(
          child: Container(
            padding: EdgeInsets.only(
              left: horizontalPadding,
              right: horizontalPadding,
              top: verticalPadding,
              bottom: 0,
            ),
            alignment: Alignment.topCenter,
            child: AspectRatio(
              aspectRatio: 1.0,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: min(pieSize.height, constraints.maxHeight - verticalPadding),
                  maxWidth: min(pieSize.width, constraints.maxWidth - (horizontalPadding * 2)),
                ),
                child: barDataDailySales.isNotEmpty
                    ? PieDashboardChart(
                        dataList: barDataDailySales,
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.pie_chart_outline,
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
                      ),
              ),
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
        startSearchCriteria = startSearchCriteria.replaceAll('{', '').replaceAll('}', '');
        startSearchCriteria = '{$startSearchCriteria}';
        searchCriteriaa = SearchCriteria.fromJson(json.decode(startSearchCriteria));
        fromDateController.text = searchCriteriaa!.fromDate!.isEmpty
            ? todayDate
            : searchCriteriaa!.fromDate!;
        fromDateController.text = context.read<DatesProvider>().sessionFromDate.isNotEmpty
            ? DatesController().dashFormatDate(context.read<DatesProvider>().sessionFromDate, false)
            : searchCriteriaa!.fromDate!;
      }
    }
  }

  getAllCodeReports() async {
    setState(() {
      isLoading = true;
    });
    await CodeReportsController().getAllCodeReports().then((value) {
      if (value.isNotEmpty) {
        codeReportsList = value;
        setPageName();
        if (currentPageName.isNotEmpty) {
          getAllUserReportSettings();
        } else {
          setState(() {
            isLoading = false;
          });
        }
      }
    });
  }

  getAllUserReportSettings() async {
    UserReportSettingsController().getAllUserReportSettings().then((value) async {
      userReportSettingsList = value;
      setStartSearchCriteria();
      lastFromDate = fromDateController.text;
      selectedChart = Line_Chart;
      lastBranchCode = selectedBranchCode;
      lastStatus = getVoucherStatusByCode(_locale, All_Status);
      if (!dataLoaded) {
        dataLoaded = true;
        await getPayableAccountsData();
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
    UserReportSettingsController().editUserReportSettings(userReportSettingsModel);
  }

  double formatDoubleToTwoDecimalPlaces(double number) {
    return double.parse(number.toStringAsFixed(2));
  }

  Future<void> getDailySales1({bool? isStart}) async {
    final selectedFromDate = fromDateController.text;
    SearchCriteria searchCriteria = SearchCriteria(
      fromDate: selectedFromDate,
      voucherStatus: -100,
      branch: "",
    );
    setSearchCriteria(searchCriteria);
    barDataDailySales = [];
    dataMap.clear();
    barData = [];
    listOfBalances = [];
    listOfPeriods = [];
    await dailySalesController.getDailySale(searchCriteria, isStart: isStart).then((response) {
      lastFromDate = selectedFromDate;
      for (var elemant in response) {
        String temp = DatesController().formatDateWithoutYear(elemant.date!);
        if (double.parse(elemant.dailySale.toString()) != 0.0) {
          boolTemp = true;
        } else if (double.parse(elemant.dailySale.toString()) == 0.0) {
          boolTemp = false;
        }
        listOfBalances.add(elemant.dailySale ?? 0.0);
        listOfPeriods.add(temp);
        if (boolTemp) {
          dataMap[temp] = formatDoubleToTwoDecimalPlaces(double.parse(elemant.dailySale.toString()));
          barDataDailySales.add(PieChartModel(
              title: temp,
              value: double.parse(elemant.dailySale.toString()) == 0.0
                  ? 1.0
                  : formatDoubleToTwoDecimalPlaces(double.parse(elemant.dailySale.toString())),
              color: getRandomColor(colorNewList)));
        }
        barData.add(
          BarData(name: temp, percent: double.parse(elemant.dailySale.toString())),
        );
      }
      double total = 0;
      for (int i = 0; i < listOfBalances.length; i++) {
        total += listOfBalances[i];
      }
      totalDailySale.value = total;
    });
  }

  Future<void> getDailySales({bool? isStart}) async {
    int stat = statusVar;
    var selectedFromDate = fromDateController.text;
    lastFromDate = selectedFromDate;
    lastStatus = getVoucherStatusByCode(_locale, statusVar);
    lastBranchCode = selectedBranchCode;
    if (selectedFromDate.isEmpty) {
      selectedFromDate = todayDate;
    }
    SearchCriteria searchCriteria = SearchCriteria(
      fromDate: selectedFromDate,
      voucherStatus: stat,
      branch: selectedBranchCode,
    );
    barDataDailySales = [];
    dataMap.clear();
    barData = [];
    listOfBalances = [];
    listOfPeriods = [];
    await dailySalesController.getDailySale(searchCriteria, isStart: isStart).then((response) {
      for (var elemant in response) {
        String temp = DatesController().formatDateWithoutYear(elemant.date!);
        if (double.parse(elemant.dailySale.toString()) != 0.0) {
          boolTemp = true;
        } else if (double.parse(elemant.dailySale.toString()) == 0.0) {
          boolTemp = false;
        }
        listOfBalances.add(double.parse(elemant.dailySale.toString()));
        listOfPeriods.add(temp);
        if (boolTemp) {
          dataMap[temp] = formatDoubleToTwoDecimalPlaces(double.parse(elemant.dailySale.toString()));
          barDataDailySales.add(PieChartModel(
              title: temp,
              value: double.parse(elemant.dailySale.toString()) == 0.0
                  ? 1.0
                  : formatDoubleToTwoDecimalPlaces(double.parse(elemant.dailySale.toString())),
              color: getRandomColor(colorNewList)));
        }
        barData.add(
          BarData(name: temp, percent: double.parse(elemant.dailySale.toString())),
        );
      }
      double total = 0;
      for (int i = 0; i < listOfBalances.length; i++) {
        total += listOfBalances[i];
      }
      totalDailySale.value = total;
    });
  }

  void _startTimer() {
    const storage = FlutterSecureStorage();
    const duration = Duration(minutes: 5);
    _timer = Timer.periodic(duration, (Timer t) async {
      String? token = await storage.read(key: "jwt");
      if (token != null) {
        await getDailySales().then((value) async {
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

  Color getRandomColor(List<Color> colorList) {
    final random = Random();
    int r = random.nextInt(256);
    int g = random.nextInt(256);
    int b = random.nextInt(256);
    return Color.fromRGBO(r, g, b, 1.0);
  }

  int count = 0;
  DateTime getNextDay(String inputDate) {
    count++;
    final List<String> dateParts = inputDate.split('-');
    if (dateParts.length != 3) {
      throw ArgumentError("Invalid date format. Expected dd-mm-yyyy.");
    }
    final int day = int.parse(dateParts[0]);
    final int month = int.parse(dateParts[1]);
    final int year = int.parse(dateParts[2]);
    final DateTime currentDate = DateTime(year, month, day);
    final DateTime nextDay = currentDate.add(Duration(days: count));
    return nextDay;
  }

  void getBranch() async {
    BranchController().getBranch().then((value) {
      branches.add(_locale.all);
      value.forEach((k, v) {
        if (mounted) {
          branches.add(k);
        }
      });
      setBranchesMap(_locale, value);
    });
  }
}