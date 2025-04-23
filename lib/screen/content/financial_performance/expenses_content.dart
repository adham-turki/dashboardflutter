import 'dart:convert';
import 'dart:math';
import 'package:bi_replicate/model/chart/pie_chart_model.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../components/charts.dart';
import '../../../components/charts/pie_chart.dart';
import '../../../components/custom_date.dart';
import '../../../controller/financial_performance/expense_controller.dart';
import '../../../controller/settings/setup/accounts_name.dart';
import '../../../controller/settings/user_settings/code_reports_controller.dart';
import '../../../controller/settings/user_settings/user_report_settings_controller.dart';
import '../../../model/bar_chart_data_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../model/criteria/search_criteria.dart';
import '../../../model/settings/setup/bi_account_model.dart';
import '../../../model/settings/user_settings/code_reports_model.dart';
import '../../../model/settings/user_settings/user_report_settings.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/maps.dart';
import '../../../utils/constants/pages_constants.dart';
import '../../../utils/constants/responsive.dart';
import '../../../utils/constants/styles.dart';
import '../../../utils/func/dates_controller.dart';
import '../../../widget/drop_down/custom_dropdown.dart';

class ExpensesContent extends StatefulWidget {
  const ExpensesContent({super.key});

  @override
  State<ExpensesContent> createState() => _ExpensesContentState();
}

class _ExpensesContentState extends State<ExpensesContent> {
  double width = 0;
  double height = 0;
  bool isDesktop = false;
  bool boolTemp = false;
  final dropdownKey = GlobalKey<DropdownButton2State>();
  final TextEditingController _fromDateController = TextEditingController();
  late AppLocalizations _locale;
  List<String> status = [];
  List<String> periods = [];
  List<String> charts = [];
  var selectedStatus = "";
  var selectedChart = "";
  var selectedPeriod = "";
  String accountNameString = "";
  List<BiAccountModel> expensesAccounts = [];
  List<CodeReportsModel> codeReportsList = [];
  List<UserReportSettingsModel> userReportSettingsList = [];
  String startSearchCriteria = "";
  String currentPageName = "";
  String currentPageCode = "";
  SearchCriteria? searchCriteriaa;
  String txtKey = "";
  bool accountsActive = false;
  ExpensesController expensesController = ExpensesController();
  List<double> listOfBalances = [];
  List<String> listOfPeriods = [];
  bool isLoading = true;

  final List<String> items = [
    'Print',
    'Save as JPEG',
    'Save as PNG',
  ];
  final dataMap = <String, double>{};

  List<PieChartModel> pieData = [];

  List<BarChartData> barData = [];
  final usedColors = <Color>[];
  @override
  void initState() {
    getAllCodeReports();

    getExpensesAccounts(isStart: true).then((value) {
      expensesAccounts = value;
      setState(() {});
    });

    super.initState();
  }

  String todayDate = "";

  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context)!;
    todayDate = DatesController().formatDateReverse(
        DatesController().formatDate(DatesController().todayDate()));

    _fromDateController.text = todayDate;

    status = [
      _locale.all,
      _locale.posted,
      _locale.draft,
      _locale.canceled,
    ];
    periods = [
      _locale.daily,
      _locale.weekly,
      _locale.monthly,
      _locale.yearly,
    ];
    charts = [
      _locale.lineChart,
      _locale.barChart,
      _locale.pieChart,
    ];
    selectedChart = charts[0];
    selectedStatus = status[0];
    selectedPeriod = periods[0];
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    isDesktop = Responsive.isDesktop(context);

    return Container(
      decoration: const BoxDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: isDesktop ? width * 0.7 : width * 0.9,
            decoration: borderDecoration,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: isDesktop ? desktopCriteria() : mobileCriteria(),
            ),
          ),
          SizedBox(
            height: height * 0.01,
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                accountsActive = !accountsActive;
                setState(() {});
              },
              child: Container(
                width: isDesktop ? width * 0.7 : width * 0.9,
                decoration: const BoxDecoration(
                  color: primary,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SelectableText(
                      maxLines: 1,
                      _locale.accounts,
                      style: fourteen400TextStyle(Colors.white),
                    ),
                    const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
          accountsActive
              ? Container(
                  width: isDesktop ? width * 0.7 : width * 0.9,
                  height: isDesktop ? height * 0.08 : height * 0.12,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                  child: SelectableText(
                    maxLines: 10,
                    accountName(),
                    style: sixteen600TextStyle(Colors.black),
                  ))
              : Container(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: isDesktop ? width * 0.7 : width * 0.9,
              height: isDesktop ? height * 0.6 : height * 0.6,
              decoration: borderDecoration,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          selectedChart == _locale.lineChart
                              ? _locale.lineChart
                              : selectedChart == _locale.pieChart
                                  ? _locale.pieChart
                                  : _locale.barChart,
                          style: TextStyle(fontSize: isDesktop ? 24 : 18),
                        ),
                      ),
                    ],
                  ),
                  isLoading
                      ? const Padding(
                          padding: EdgeInsets.all(150),
                          child: CircularProgressIndicator(),
                        )
                      : selectedChart == _locale.lineChart
                          ? BalanceLineChart(
                              yAxisText: _locale.balances,
                              xAxisText: _locale.periods,
                              balances: listOfBalances,
                              periods: listOfPeriods)
                          : selectedChart == _locale.pieChart
                              ? Center(
                                  child: PieChartComponent(
                                    radiusNormal:
                                        isDesktop ? height * 0.17 : 70,
                                    radiusHover: isDesktop ? height * 0.17 : 80,
                                    width:
                                        isDesktop ? width * 0.42 : width * 0.1,
                                    height: isDesktop
                                        ? height * 0.42
                                        : height * 0.4,
                                    dataList: pieData,
                                  ),
                                )
                              : BalanceBarChart(data: barData),
                  const SizedBox(), //Footer
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String createUuid() {
    var uuid = const Uuid();
    return uuid.v4();
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
        _fromDateController.text =
            DatesController().formatDateReverse(searchCriteriaa!.fromDate!);
      }
    }
  }

  getAllCodeReports() {
    CodeReportsController().getAllCodeReports().then((value) {
      setState(() {
        codeReportsList = value;
        setPageName();
        getAllUserReportSettings();
      });
    });
  }

  getAllUserReportSettings() {
    UserReportSettingsController().getAllUserReportSettings().then((value) {
      setState(() {
        userReportSettingsList = value;
        setStartSearchCriteria();
        getExpenses(isStart: true);
      });
    });
  }

  setPageName() {
    for (var i = 0; i < codeReportsList.length; i++) {
      if (codeReportsList[i].txtReportnamee == ReportConstants.expenses) {
        setState(() {
          currentPageName = codeReportsList[i].txtReportnamee;
          currentPageCode = codeReportsList[i].txtReportcode;
        });
      }
    }
  }

  void setSearchCriteria(SearchCriteria searchCriteria) {
    String search = "${searchCriteria.toJson()}";
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

  Column desktopCriteria() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CustomDropDown(
          items: charts,
          label: _locale.chartType,
          initialValue: selectedChart,
          onChanged: (value) {
            setState(() {
              selectedChart = value!;
              getExpenses();
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomDropDown(
              items: status,
              label: _locale.status,
              initialValue: selectedStatus,
              onChanged: (value) {
                setState(() {
                  selectedStatus = value.toString();

                  getExpenses();
                });
              },
            ),
            SizedBox(
              width: width * 0.135,
              child: CustomDate(
                dateController: _fromDateController,
                label: _locale.fromDate,
                lastDate: DateTime.now(),
                minYear: 2000,
                onValue: (isValid, value) {
                  if (isValid) {
                    setState(() {
                      _fromDateController.text = value;

                      getExpenses();
                    });
                  }
                },
                dateControllerToCompareWith: null,
                isInitiaDate: true,
                timeControllerToCompareWith: null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Column mobileCriteria() {
    double widthMobile = width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CustomDropDown(
          width: widthMobile * 0.81,
          items: charts,
          label: _locale.chartType,
          initialValue: selectedChart,
          onChanged: (value) {
            setState(() {
              selectedChart = value!;
              getExpenses();
            });
          },
        ),
        CustomDropDown(
          width: widthMobile * 0.81,
          items: status,
          label: _locale.status,
          initialValue: selectedStatus,
          onChanged: (value) {
            setState(() {
              selectedStatus = value.toString();

              getExpenses();
            });
          },
        ),
        SizedBox(
          width: widthMobile * 0.81,
          child: CustomDate(
            dateController: _fromDateController,
            label: _locale.fromDate,
            lastDate: DateTime.now(),
            minYear: 2000,
            onValue: (isValid, value) {
              if (isValid) {
                setState(() {
                  _fromDateController.text = value;
                  getExpenses();
                });
              }
            },
            dateControllerToCompareWith: null,
            isInitiaDate: true,
            timeControllerToCompareWith: null,
          ),
        ),
      ],
    );
  }

  double formatDoubleToTwoDecimalPlaces(double number) {
    return double.parse(number.toStringAsFixed(2));
  }

  int count = 0;
  getExpenses({bool? isStart}) {
    setState(() {
      isLoading = true;
    });
    listOfBalances = [];
    listOfPeriods = [];
    pieData = [];
    barData = [];
    dataMap.clear();
    count = 0;
    if (_fromDateController.text.isEmpty) {
      setState(() {
        if (_fromDateController.text.isEmpty) {
          _fromDateController.text = todayDate;
        }
      });
    }
    int status = getVoucherStatus(_locale, selectedStatus);
    String date = DatesController().formatDate(_fromDateController.text);
    SearchCriteria searchCriteria =
        SearchCriteria(fromDate: date, toDate: date, voucherStatus: status);
    setSearchCriteria(searchCriteria);
    expensesController
        .getExpense(searchCriteria, isStart: isStart)
        .then((value) {
      for (var elemant in value) {
        String temp = DatesController().formatDate(getNextDay(date).toString());
        if (double.parse(elemant.expense.toString()) != 0.0) {
          boolTemp = true;
        } else if (double.parse(elemant.expense.toString()) == 0.0) {
          boolTemp = false;
        }
        setState(() {
          listOfBalances.add(elemant.expense!);
          listOfPeriods.add(temp);
          if (boolTemp) {
            pieData.add(PieChartModel(
                title: temp,
                value: double.parse(elemant.expense.toString()) == 0.0
                    ? 1.0
                    : formatDoubleToTwoDecimalPlaces(
                        double.parse(elemant.expense.toString())),
                color: getRandomColor(colorNewList, usedColors)));
          }

          barData.add(
              BarChartData(temp, double.parse(elemant.expense.toString())));
        });
      }
      setState(() {
        isLoading = false;
      });
    });
  }

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
    late DateTime nextDay;
    if (count == 1) {
      nextDay = currentDate;
    } else {
      nextDay = currentDate.add(Duration(days: count - 1));
    }

    return nextDay;
  }

  String accountName() {
    accountNameString = "";
    for (int i = 0; i < expensesAccounts.length; i++) {
      accountNameString += "${expensesAccounts[i].accountName},";
    }
    return accountNameString;
  }

  Color getRandomColor(List<Color> colorList, List<Color> usedColors) {
    if (usedColors.length == colorList.length) {
      // If all colors have been used, clear the used colors list
      usedColors.clear();
    }

    final random = Random();
    Color color;
    do {
      int r = random.nextInt(256); // 0 to 255
      int g = random.nextInt(256); // 0 to 255
      int b = random.nextInt(256); // 0 to 255

      // Create Color object from RGB values
      color =
          Color.fromRGBO(r, g, b, 1.0); // Alpha is set to 1.0 (fully opaque)
    } while (usedColors.contains(color));

    usedColors.add(color);
    return color;
  }
}
