import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:bi_replicate/components/dashboard_components/bar_dashboard_chart.dart';
import 'package:bi_replicate/utils/constants/maps.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:bi_replicate/model/criteria/search_criteria.dart';
import 'package:bi_replicate/utils/func/converters.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
  bool temp = false;
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

      selectedChart = Pie_Chart;
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
                      ValueListenableBuilder(
                          valueListenable: totalBranchesSale,
                          builder: ((context, value, child) {
                            return Text(
                              "${_locale.salesByBranches} (${Converters.formatNumber(totalBranchesSale.value)})",
                              style: TextStyle(fontSize: isDesktop ? 15 : 18),
                            );
                          })),
                      Text(
                        _locale.localeName == "en"
                            ? "${fromDateController.text}  -  ${toDateController.text}"
                            : "$fromDate  -  $toDate",
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
                              if (isLoading == false) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return FilterDialogSalesByBranches(
                                      selectedChart: getChartByCode(
                                          selectedChart, _locale),
                                      selectedPeriod:
                                          getPeriodByCode(period, _locale),
                                      fromDate: fromDateController.text,
                                      toDate: toDateController.text,
                                      onFilter: (selectedPeriod, fromDate,
                                          toDate, chart) {
                                        fromDateController.text = fromDate;
                                        toDateController.text = toDate;
                                        period = getPeriodByName(
                                            selectedPeriod, _locale);
                                        selectedChart =
                                            getChartByName(chart, _locale);
                                        SearchCriteria searchCriteria =
                                            SearchCriteria(
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

                                      isLoading = false;
                                    });
                                  });
                                });
                              }
                            },
                          )),
                    ],
                  ),
                  isLoading
                      ? const Padding(
                          padding: EdgeInsets.only(bottom: 150),
                          child: CircularProgressIndicator(),
                        )
                      : selectedChart == Bar_Chart
                          ? Center(
                              child: BarDashboardChart(
                                barChartData: barData,
                                isMax: false,
                              ),
                            )
                          : selectedChart == Line_Chart
                              ? Center(
                                  child: SizedBox(
                                    height: height * 0.4,
                                    child: LineDashboardChart(
                                        isMax: false,
                                        balances: listOfBalances,
                                        periods: listOfPeriods),
                                  ),
                                )
                              : Center(
                                  child: PieDashboardChart(
                                    dataList: pieData,
                                  ),
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
        print("bar chart sales dashboard : ${startSearchCriteria}");

        searchCriteriaa =
            SearchCriteria.fromJson(json.decode(startSearchCriteria));
        fromDateController.text = searchCriteriaa!.fromDate!.isEmpty
            ? currentMonth
            : searchCriteriaa!.fromDate!;
        toDateController.text = searchCriteriaa!.toDate!.isEmpty
            ? todayDate
            : searchCriteriaa!.toDate!;
        // selectedBranchCode = searchCriteriaa!.branch!;
        // selectedBranchCode = searchCriteriaa!.byCategory!;

        print(
            "startSearchCriteriastartSearchCriteria: ${searchCriteriaa!.fromDate}");
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

  Color getRandomColor(List<Color> colorList) {
    final random = Random();
    final index = random.nextInt(colorList.length);
    return colorList[index];
  }

  Future<void> getSalesByBranch1() async {
    final selectedFromDate = fromDateController.text;
    final selectedToDate = toDateController.text;

    // Load data when selected dates change
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
      // Update lastFromDate and lastToDate
      lastFromDate = selectedFromDate;
      lastToDate = selectedToDate;
      // Update the data
      for (var element in value) {
        double a = (element.totalSales! + element.retSalesDis!) -
            (element.salesDis! + element.totalReturnSales!);
        a = Converters().formateDouble(a);
        if (a != 0.0) {
          temp = true;
        } else if (a == 0.0) {
          temp = false;
        }
        listOfBalances.add(a);
        listOfPeriods.add(element.namee!);
        if (temp) {
          dataMap[element.namee!] = formatDoubleToTwoDecimalPlaces(a);
          pieData.add(PieChartModel(
            title: element.namee!,
            value: formatDoubleToTwoDecimalPlaces(a),
            color: getNextColor(),
          ));
        }
        barData.add(
          BarData(name: element.namee!, percent: a),
        );
      }
      double total = 0;
      for (int i = 0; i < listOfBalances.length; i++) {
        total += listOfBalances[i];
      }
      totalBranchesSale.value =
          double.parse(Converters.formatNumberDigits(total));
    });
    print(
        "baaaaaaaaaaaaaaal ${listOfBalances.length}  ${listOfPeriods.length}");
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
    _stopTimer(); // Stop timer when the widget is disposed

    super.dispose();
  }

  void _stopTimer() {
    if (_timer != null) {
      _timer!.cancel(); // Cancel the timer
      _timer = null; // Reset timer reference
    }
  }

  Future<void> getSalesByBranch() async {
    final selectedFromDate = fromDateController.text;
    final selectedToDate = toDateController.text;

    if (dataLoaded) {
      // if (selectedFromDate != lastFromDate || selectedToDate != lastToDate) {
      // Load data when selected dates change
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
        // Update lastFromDate and lastToDate
        lastFromDate = selectedFromDate;
        lastToDate = selectedToDate;
        // Update the data
        for (var element in value) {
          double a = (element.totalSales! + element.retSalesDis!) -
              (element.salesDis! + element.totalReturnSales!);
          a = Converters().formateDouble(a);
          if (a != 0.0) {
            temp = true;
          } else if (a == 0.0) {
            temp = false;
          }
          listOfBalances.add(a);
          listOfPeriods.add(element.namee!);
          if (temp) {
            dataMap[element.namee!] = formatDoubleToTwoDecimalPlaces(a);
            pieData.add(PieChartModel(
              title: element.namee!,
              value: formatDoubleToTwoDecimalPlaces(a),
              color: getNextColor(),
            ));
          }
          barData.add(
            BarData(name: element.namee!, percent: a),
          );
        }
        double total = 0;
        for (int i = 0; i < listOfBalances.length; i++) {
          total += listOfBalances[i];
        }
        totalBranchesSale.value =
            double.parse(Converters.formatNumberDigits(total));
      });
      // }
    }
  }

  Color getNextColor() {
    final color = colorListDashboard[colorIndex];
    colorIndex = (colorIndex + 1) % colorListDashboard.length;
    return color;
  }
}
