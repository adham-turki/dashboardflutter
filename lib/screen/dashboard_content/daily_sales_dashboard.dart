import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:bi_replicate/components/dashboard_components/bar_dashboard_chart.dart';
import 'package:bi_replicate/components/dashboard_components/line_dasboard_chart.dart';
import 'package:bi_replicate/components/dashboard_components/pie_dashboard_chart.dart';
import 'package:bi_replicate/controller/sales_adminstration/branch_controller.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:bi_replicate/model/criteria/search_criteria.dart';
import 'package:intl/intl.dart';
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
import '../../utils/func/converters.dart';
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

  // List<PieChartModel> pieData = [];
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

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    isDesktop = Responsive.isDesktop(context);
    String fromDate = fromDateController.text.isEmpty
        ? ""
        : DatesController().formatDateReverse(fromDateController.text);
    print("asadasdasdasd: ${(totalDailySale.value.toString())}");
    print("${double.parse(totalDailySale.value.toString())}");
    return Container(
      decoration: const BoxDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 5, right: 5, bottom: 3, top: 0),
            child: Container(
              height: isDesktop ? height * 0.44 : height * 0.48,
              padding: const EdgeInsets.only(left: 5, right: 5, top: 0),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  isDesktop
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ValueListenableBuilder(
                                valueListenable: totalDailySale,
                                builder: ((context, value, child) {
                                  return Text(
                                    "${_locale.dailySales} (\u200E${NumberFormat('#,###', 'en_US').format(double.parse(totalDailySale.value.toString()))})",
                                    style: TextStyle(
                                        fontSize: isDesktop ? 15 : 18),
                                  );
                                })),
                            Text(
                              _locale.localeName == "en"
                                  ? "(${fromDateController.text})"
                                  : "($fromDate)",
                              style: TextStyle(fontSize: isDesktop ? 15 : 18),
                            ),
                            SizedBox(
                                width: !isDesktop
                                    ? MediaQuery.of(context).size.width * 0.06
                                    : MediaQuery.of(context).size.width * 0.03,
                                child: blueButton1(
                                  icon: Icon(
                                    Icons.filter_list_sharp,
                                    color: whiteColor,
                                    size: isDesktop
                                        ? height * 0.035
                                        : height * 0.03,
                                  ),
                                  textColor:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  height:
                                      isDesktop ? height * .01 : height * .039,
                                  fontSize:
                                      isDesktop ? height * .018 : height * .017,
                                  width:
                                      isDesktop ? width * 0.08 : width * 0.27,
                                  onPressed: () {
                                    if (isLoading == false) {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return FilterDialogDailySales(
                                            selectedChart: getChartByCode(
                                                selectedChart, _locale),
                                            selectedStatus:
                                                getVoucherStatusByCode(
                                                    _locale, statusVar),
                                            selectedBranchCodeF:
                                                selectedBranchCode == ""
                                                    ? _locale.all
                                                    : selectedBranchCode,
                                            fromDate: fromDateController.text,
                                            branches: branches,
                                            onFilter: (
                                              fromDate,
                                              selectedStatus,
                                              chart,
                                              selectedBranchCodeF,
                                            ) {
                                              fromDateController.text =
                                                  fromDate;
                                              statusVar = getVoucherStatus(
                                                  _locale, selectedStatus);
                                              selectedChart = getChartByName(
                                                  chart, _locale);

                                              selectedBranchCode =
                                                  selectedBranchCodeF ==
                                                          _locale.all
                                                      ? ""
                                                      : selectedBranchCodeF;

                                              SearchCriteria searchCriteria =
                                                  SearchCriteria(
                                                fromDate:
                                                    fromDateController.text,
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
                                )),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                ValueListenableBuilder(
                                    valueListenable: totalDailySale,
                                    builder: ((context, value, child) {
                                      return Text(
                                        "${_locale.dailySales}  (\u200E${NumberFormat('#,###', 'en_US').format(double.parse(totalDailySale.value.toString()))})",
                                        style: TextStyle(
                                            fontSize: isDesktop ? 15 : 18),
                                      );
                                    })),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _locale.localeName == "en"
                                      ? "(${fromDateController.text})"
                                      : "($fromDate)",
                                  style:
                                      TextStyle(fontSize: isDesktop ? 15 : 10),
                                ),
                                SizedBox(
                                    width: !isDesktop
                                        ? MediaQuery.of(context).size.width *
                                            0.12
                                        : MediaQuery.of(context).size.width *
                                            0.03,
                                    child: blueButton1(
                                      icon: Icon(
                                        Icons.filter_list_sharp,
                                        color: whiteColor,
                                        size: isDesktop
                                            ? height * 0.035
                                            : height * 0.055,
                                      ),
                                      textColor: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      height: isDesktop
                                          ? height * .01
                                          : height * .039,
                                      fontSize: isDesktop
                                          ? height * .018
                                          : height * .017,
                                      width: isDesktop
                                          ? width * 0.08
                                          : width * 0.27,
                                      onPressed: () {
                                        if (isLoading == false) {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return FilterDialogDailySales(
                                                selectedChart: getChartByCode(
                                                    selectedChart, _locale),
                                                selectedStatus:
                                                    getVoucherStatusByCode(
                                                        _locale, statusVar),
                                                selectedBranchCodeF:
                                                    selectedBranchCode == ""
                                                        ? _locale.all
                                                        : selectedBranchCode,
                                                fromDate:
                                                    fromDateController.text,
                                                branches: branches,
                                                onFilter: (
                                                  fromDate,
                                                  selectedStatus,
                                                  chart,
                                                  selectedBranchCodeF,
                                                ) {
                                                  fromDateController.text =
                                                      fromDate;
                                                  statusVar = getVoucherStatus(
                                                      _locale, selectedStatus);
                                                  selectedChart =
                                                      getChartByName(
                                                          chart, _locale);

                                                  selectedBranchCode =
                                                      selectedBranchCodeF ==
                                                              _locale.all
                                                          ? ""
                                                          : selectedBranchCodeF;

                                                  SearchCriteria
                                                      searchCriteria =
                                                      SearchCriteria(
                                                    fromDate:
                                                        fromDateController.text,
                                                    voucherStatus: -100,
                                                    branch: "",
                                                  );
                                                  setSearchCriteria(
                                                      searchCriteria);
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
                                    )),
                              ],
                            )
                          ],
                        ),
                  isLoading
                      ? const Padding(
                          padding: EdgeInsets.only(bottom: 150),
                          child: CircularProgressIndicator(),
                        )
                      : selectedChart == Pie_Chart
                          ? barDataDailySales.length < 4
                              ? Center(
                                  child: SizedBox(
                                    height: height * 0.4,
                                    child: PieDashboardChart(
                                      dataList: barDataDailySales,
                                    ),
                                  ),
                                )
                              : BarDashboardChart(
                                  barChartData: barData,
                                  isMax: true,
                                  isMedium: false,
                                )
                          : selectedChart == Bar_Chart
                              ? BarDashboardChart(
                                  barChartData: barData,
                                  isMax: true,
                                  isMedium: false,
                                )
                              : SizedBox(
                                  height: height * 0.4,
                                  child: LineDashboardChart(
                                      isMax: true,
                                      isMedium: false,
                                      balances: listOfBalances,
                                      periods: listOfPeriods),
                                )
                ],
              ),
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
        fromDateController.text = searchCriteriaa!.fromDate!.isEmpty
            ? todayDate
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
    UserReportSettingsController()
        .getAllUserReportSettings()
        .then((value) async {
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
    UserReportSettingsController()
        .editUserReportSettings(userReportSettingsModel);
  }

  double formatDoubleToTwoDecimalPlaces(double number) {
    return double.parse(number.toStringAsFixed(2));
  }

  Future<void> getDailySales1({bool? isStart}) async {
    final selectedFromDate = fromDateController.text;

    // Load data when selected dates change
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
    await dailySalesController
        .getDailySale(searchCriteria, isStart: isStart)
        .then((response) {
      // Update lastFromDate and lastToDate
      lastFromDate = selectedFromDate;
      // Update the data
      for (var elemant in response) {
        String temp =
            DatesController().formatDateWithoutYear(elemant.date!) ?? "NO DATE";

        if (double.parse(elemant.dailySale.toString()) != 0.0) {
          boolTemp = true;
        } else if (double.parse(elemant.dailySale.toString()) == 0.0) {
          boolTemp = false;
        }

        listOfBalances.add(elemant.dailySale ?? 0.0);
        listOfPeriods.add(temp);
        if (boolTemp) {
          dataMap[temp] = formatDoubleToTwoDecimalPlaces(
              double.parse(elemant.dailySale.toString()));
          barDataDailySales.add(PieChartModel(
              title: temp,
              value: double.parse(elemant.dailySale.toString()) == 0.0
                  ? 1.0
                  : formatDoubleToTwoDecimalPlaces(
                      double.parse(elemant.dailySale.toString())),
              color: getRandomColor(colorNewList)));
        }

        barData.add(
          BarData(
              name: temp, percent: double.parse(elemant.dailySale.toString())),
        );
      }

      double total = 0;
      for (int i = 0; i < listOfBalances.length; i++) {
        total += listOfBalances[i];
      }

      totalDailySale.value = total;
      //  Converters.formatNumberRounded(
      //     double.parse(Converters.formatNumberDigits(total)));
    });

    print("BBBBBBBBBbbarLength ${barData.length}");
  }

  Future<void> getDailySales({bool? isStart}) async {
    int stat = statusVar;
    var selectedFromDate = fromDateController.text;
    final selectedStatus = statusVar;
    final selectedBranchCodeValue = selectedBranchCode;
    // if (selectedFromDate != lastFromDate ||
    //     getVoucherStatusByCode(_locale, selectedStatus) != lastStatus ||
    //     selectedBranchCodeValue != lastBranchCode) {

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
    await dailySalesController
        .getDailySale(searchCriteria, isStart: isStart)
        .then((response) {
      for (var elemant in response) {
        String temp =
            DatesController().formatDateWithoutYear(elemant.date!) ?? "NO DATE";

        if (double.parse(elemant.dailySale.toString()) != 0.0) {
          boolTemp = true;
        } else if (double.parse(elemant.dailySale.toString()) == 0.0) {
          boolTemp = false;
        }

        listOfBalances.add(double.parse(elemant.dailySale.toString()));
        listOfPeriods.add(temp);
        if (boolTemp) {
          dataMap[temp] = formatDoubleToTwoDecimalPlaces(
              double.parse(elemant.dailySale.toString()));
          barDataDailySales.add(PieChartModel(
              title: temp,
              value: double.parse(elemant.dailySale.toString()) == 0.0
                  ? 1.0
                  : formatDoubleToTwoDecimalPlaces(
                      double.parse(elemant.dailySale.toString())),
              color: getRandomColor(colorNewList)));
        }

        barData.add(
          BarData(
              name: temp, percent: double.parse(elemant.dailySale.toString())),
        );
      }

      double total = 0;
      for (int i = 0; i < listOfBalances.length; i++) {
        total += listOfBalances[i];
      }
      totalDailySale.value = total;
      // Converters.formatNumberRounded(
      // double.parse(Converters.formatNumberDigits(total)));
    });

    // }
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
    _stopTimer(); // Stop timer when the widget is disposed

    super.dispose();
  }

  void _stopTimer() {
    if (_timer != null) {
      _timer!.cancel(); // Cancel the timer
      _timer = null; // Reset timer reference
    }
  }

  Color getRandomColor(List<Color> colorList) {
    final random = Random();
    int r = random.nextInt(256); // 0 to 255
    int g = random.nextInt(256); // 0 to 255
    int b = random.nextInt(256); // 0 to 255

    // Create Color object from RGB values
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
