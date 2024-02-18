import 'dart:convert';
import 'dart:math';

import 'package:bi_replicate/model/chart/pie_chart_model.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';
import '../../../components/charts.dart';
import '../../../components/charts/pie_chart.dart';
import '../../../components/custom_date.dart';
import '../../../controller/sales_adminstration/daily_sales_controller.dart';
import '../../../controller/settings/setup/accounts_name.dart';
import '../../../controller/settings/user_settings/code_reports_controller.dart';
import '../../../controller/settings/user_settings/user_report_settings_controller.dart';
import '../../../model/bar_chart_data_model.dart';
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

class DailySalesContent extends StatefulWidget {
  const DailySalesContent({super.key});

  @override
  State<DailySalesContent> createState() => _DailySalesContentState();
}

class _DailySalesContentState extends State<DailySalesContent> {
  double width = 0;
  double height = 0;
  final dropdownKey = GlobalKey<DropdownButton2State>();
  bool isDesktop = false;
  final TextEditingController _fromDateController = TextEditingController();
  final storage = const FlutterSecureStorage();
  DailySalesController dailySalesController = DailySalesController();
  late AppLocalizations _locale;

  List<String> status = [];

  List<String> charts = [];

  bool accountsActive = false;

  var selectedStatus = "";
  var selectedChart = "";

  List<double> listOfBalances = [];
  List<String> listOfPeriods = [];
  List<BiAccountModel> payableAccounts = [];

  final List<String> items = [
    'Print',
    'Save as JPEG',
    'Save as PNG',
  ];
  final dataMap = <String, double>{};
  List<CodeReportsModel> codeReportsList = [];
  List<UserReportSettingsModel> userReportSettingsList = [];
  String startSearchCriteria = "";
  String currentPageName = "";
  String currentPageCode = "";
  SearchCriteria? searchCriteriaa;
  String txtKey = "";
  List<PieChartModel> pieData = [];
  String accountNameString = "";
  List<BarChartData> barData = [];
  List<BarChartData> barDataTest = [];
  bool boolTemp = false;
  final usedColors = <Color>[];
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

    charts = [
      _locale.lineChart,
      _locale.barChart,
      _locale.pieChart,
    ];
    selectedStatus = status[0];
    selectedChart = charts[0];
    getDailySales(isStart: true);
    // getAllCodeReports();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // getExpensesAccounts();
    for (int i = 0; i < 100; i++) {
      barDataTest.add(BarChartData(
        'Bar $i',
        Random().nextDouble() * 100, // Random percent between 0 and 100
      ));
    }
    getPayableAccounts(isStart: true).then((value) {
      payableAccounts = value;
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    isDesktop = Responsive.isDesktop(context);

    return SingleChildScrollView(
      child: Container(
        // height: height,
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
                        _locale.dailySales,
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5),
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
                    selectedChart == _locale.lineChart
                        ? BalanceLineChart(
                            yAxisText: _locale.balances,
                            xAxisText: _locale.periods,
                            balances: listOfBalances,
                            periods: listOfPeriods)
                        : selectedChart == _locale.pieChart
                            ? Center(
                                child: PieChartComponent(
                                  radiusNormal: isDesktop ? height * 0.17 : 70,
                                  radiusHover: isDesktop ? height * 0.17 : 80,
                                  width: isDesktop ? width * 0.42 : width * 0.1,
                                  height:
                                      isDesktop ? height * 0.42 : height * 0.4,
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
          if (match.group(1) == "fromDate") {
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
        print(
            "startSearchCriteriastartSearchCriteria2222222: ${startSearchCriteria}");

        searchCriteriaa =
            SearchCriteria.fromJson(json.decode(startSearchCriteria));
        _fromDateController.text =
            DatesController().formatDateReverse(searchCriteriaa!.fromDate!);

        // selectedBranchCode = searchCriteriaa!.branch!;
        // selectedBranchCode = searchCriteriaa!.byCategory!;

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
        getDailySales(isStart: true);
      });
    });
  }

  setPageName() {
    for (var i = 0; i < codeReportsList.length; i++) {
      if (codeReportsList[i].txtReportnamee == ReportConstants.dailySales) {
        setState(() {
          currentPageName = codeReportsList[i].txtReportnamee;
          currentPageCode = codeReportsList[i].txtReportcode;
          print("codeReportsList[i]: ${codeReportsList[i].toJson()}");
        });
      }
    }
  }

  String createUuid() {
    var uuid = const Uuid();
    return uuid.v4();
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
              getDailySales();
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

                  getDailySales();
                });
              },
            ),
            CustomDate(
              dateController: _fromDateController,
              label: _locale.fromDate,
              minYear: 2000,
              onValue: (isValid, value) {
                if (isValid) {
                  setState(() {
                    _fromDateController.text = value;
                    getDailySales();
                  });
                }
              },
            ),
            // CustomDatePicker(
            //   label: _locale.fromDate,
            //   controller: _fromDateController,
            //   date: DateTime.now(),
            //   onSelected: (value) {
            //     setState(() {
            //       _fromDateController.text = value;
            //       getDailySales();
            //     });
            //   },
            // ),
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
              getDailySales();
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

              getDailySales();
            });
          },
        ),
        SizedBox(
          width: widthMobile * 0.81,
          child: CustomDate(
            dateController: _fromDateController,
            label: _locale.fromDate,
            minYear: 2000,
            onValue: (isValid, value) {
              if (isValid) {
                setState(() {
                  _fromDateController.text = value;
                  getDailySales();
                });
              }
            },
          ),
        ),
        // CustomDatePicker(
        //   label: _locale.fromDate,
        //   controller: _fromDateController,
        //   date: DateTime.now(),
        //   onSelected: (value) {
        //     setState(() {
        //       _fromDateController.text = value;
        //       getDailySales();
        //     });
        //   },
        // ),
      ],
    );
  }

  double formatDoubleToTwoDecimalPlaces(double number) {
    return double.parse(number.toStringAsFixed(2));
  }

  void getDailySales({bool? isStart}) {
    listOfBalances = [];
    dataMap.clear();
    pieData = [];
    barData = [];
    int status = getVoucherStatus(_locale, selectedStatus);
    if (_fromDateController.text.isEmpty) {
      setState(() {
        if (_fromDateController.text.isEmpty) {
          _fromDateController.text = todayDate;
        }
      });
    }
    String startDate = DatesController().formatDate(_fromDateController.text);
    SearchCriteria searchCriteria =
        SearchCriteria(fromDate: startDate, voucherStatus: status);
    setSearchCriteria(searchCriteria);
    dailySalesController
        .getDailySale(searchCriteria, isStart: isStart)
        .then((response) {
      for (var elemant in response) {
        String temp =
            DatesController().formatDate(getNextDay(startDate).toString());
        if (double.parse(elemant.dailySale.toString()) != 0.0) {
          boolTemp = true;
        } else if (double.parse(elemant.dailySale.toString()) == 0.0) {
          boolTemp = false;
        }
        setState(() {
          listOfBalances.add(double.parse(elemant.dailySale.toString()));
          listOfPeriods.add(temp);
          if (boolTemp) {
            dataMap[temp] = formatDoubleToTwoDecimalPlaces(
                double.parse(elemant.dailySale.toString()));
            pieData.add(PieChartModel(
                title: temp,
                value: double.parse(elemant.dailySale.toString()) == 0.0
                    ? 1.0
                    : formatDoubleToTwoDecimalPlaces(
                        double.parse(elemant.dailySale.toString())),
                color: getRandomColor(colorNewList, usedColors)));
          }

          barData.add(
            BarChartData(temp, double.parse(elemant.dailySale.toString())),
          );
        });
      }
    });
  }

  Color getRandomColor(List<Color> colorList, List<Color> usedColors) {
    if (usedColors.length == colorList.length) {
      // If all colors have been used, clear the used colors list
      usedColors.clear();
    }

    final random = Random();
    Color color;
    do {
      final index = random.nextInt(colorList.length);
      color = colorList[index];
    } while (usedColors.contains(color));

    usedColors.add(color);
    return color;
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

  String accountName() {
    accountNameString = "";
    for (int i = 0; i < payableAccounts.length; i++) {
      accountNameString += "${payableAccounts[i].accountName},";
    }
    return accountNameString;
  }
}
