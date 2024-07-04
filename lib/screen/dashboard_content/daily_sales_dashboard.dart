import 'dart:convert';
import 'dart:math';
import 'package:bi_replicate/components/dashboard_components/bar_dashboard_chart.dart';
import 'package:bi_replicate/components/dashboard_components/line_dasboard_chart.dart';
import 'package:bi_replicate/components/dashboard_components/pie_dashboard_chart.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:bi_replicate/model/criteria/search_criteria.dart';
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
  var period = "";
  var statusVar = "";

  String todayDate = "";

  var selectedStatus = "";
  var selectedChart = "";
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
  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context)!;
    todayDate = DatesController().formatDate(DatesController().twoYearsAgo());
    fromDateController.text = todayDate;

    if (counter == 0) {
      selectedChart = _locale.lineChart;
      selectedStatus = _locale.all;
      statusVar = _locale.all;
      selectedBranchCode = _locale.all;
    }
    counter++;
    super.didChangeDependencies();
  }

  Future<void> getPayableAccountsData() async {
    await getDailySales1().then((value) {
      setState(() {});
    });
  }

  bool dataLoaded = false;

  @override
  void initState() {
    print("init state");
    getAllCodeReports();

    getPayableAccounts(isStart: true).then((value) {
      payableAccounts = value;
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    isDesktop = Responsive.isDesktop(context);
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _locale.dailySales,
                        style: TextStyle(fontSize: isDesktop ? 15 : 18),
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width < 800
                              ? MediaQuery.of(context).size.width * 0.06
                              : MediaQuery.of(context).size.width * 0.03,
                          child: blueButton1(
                            icon: Icon(
                              Icons.filter_list_sharp,
                              color: whiteColor,
                              size: isDesktop ? height * 0.035 : height * 0.03,
                            ),
                            textColor: const Color.fromARGB(255, 255, 255, 255),
                            height: isDesktop ? height * .01 : height * .039,
                            fontSize: isDesktop ? height * .018 : height * .017,
                            width: isDesktop ? width * 0.08 : width * 0.27,
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return FilterDialogDailySales(
                                    selectedChart: selectedChart,
                                    selectedStatus: statusVar,
                                    selectedBranchCodeF: selectedBranchCode,
                                    onFilter: (
                                      fromDate,
                                      selectedStatus,
                                      chart,
                                      selectedBranchCodeF,
                                    ) {
                                      fromDateController.text = fromDate;
                                      statusVar = selectedStatus;
                                      selectedChart = chart;

                                      selectedBranchCode = selectedBranchCodeF;

                                      SearchCriteria searchCriteria =
                                          SearchCriteria(
                                        fromDate: fromDateController.text,
                                        voucherStatus: -100,
                                        branch: "",
                                      );
                                      setSearchCriteria(searchCriteria);
                                    },
                                  );
                                },
                              ).then((value) async {
                                getDailySales().then((value) {
                                  setState(() {});
                                });
                              });
                            },
                          )),
                    ],
                  ),
                  selectedChart == _locale.pieChart
                      ? Center(
                          child: PieDashboardChart(
                            dataList: barDataDailySales,
                          ),
                        )
                      : selectedChart == _locale.barChart
                          ? BarDashboardChart(
                              barChartData: barData,
                              isMax: true,
                            )
                          : SizedBox(
                              height: height * 0.4,
                              child: LineDashboardChart(
                                  isMax: true,
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
        print("start search daily sales: ${startSearchCriteria}");

        searchCriteriaa =
            SearchCriteria.fromJson(json.decode(startSearchCriteria));
        fromDateController.text = searchCriteriaa!.fromDate!;

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
        Future.delayed(Duration.zero, () async {
          lastFromDate = fromDateController.text;
          selectedChart = _locale.lineChart;
          lastBranchCode = selectedBranchCode;
          lastStatus = selectedStatus;
          if (!dataLoaded) {
            dataLoaded = true;
            await getPayableAccountsData();
            setState(() {});
          }
        });
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
        String temp = elemant.date ?? "NO DATE";
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
    });
  }

  Future<void> getDailySales({bool? isStart}) async {
    int stat = getVoucherStatus(_locale, statusVar);
    var selectedFromDate = fromDateController.text;
    final selectedStatus = statusVar;
    final selectedBranchCodeValue = selectedBranchCode;

    if (selectedFromDate != lastFromDate ||
        selectedStatus != lastStatus ||
        selectedBranchCodeValue != lastBranchCode) {
      lastFromDate = selectedFromDate;
      lastStatus = selectedStatus;
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
          String temp = elemant.date ?? "NO DATE";

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
                name: temp,
                percent: double.parse(elemant.dailySale.toString())),
          );
        }
      });
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
}
