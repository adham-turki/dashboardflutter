import 'dart:convert';
import 'dart:math';

import 'package:bi_replicate/components/charts/pie_chart.dart';
import 'package:bi_replicate/controller/error_controller.dart';
import 'package:bi_replicate/controller/settings/user_settings/user_report_settings_controller.dart';
import 'package:bi_replicate/model/criteria/search_criteria.dart';
import 'package:bi_replicate/model/settings/user_settings/code_reports_model.dart';
import 'package:bi_replicate/model/settings/user_settings/user_report_settings.dart';
import 'package:bi_replicate/utils/constants/api_constants.dart';
import 'package:bi_replicate/utils/constants/responsive.dart';
import 'package:bi_replicate/utils/constants/styles.dart';
import 'package:bi_replicate/utils/func/converters.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:uuid/uuid.dart';
import '../../../components/custom_date.dart';
import '../../../controller/sales_adminstration/sales_branches_controller.dart';
import '../../../controller/settings/user_settings/code_reports_controller.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/pages_constants.dart';
import '../../../widget/drop_down/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../components/charts.dart';
import '../../../model/bar_chart_data_model.dart';
import '../../../model/chart/pie_chart_model.dart';
import '../../../utils/func/dates_controller.dart';

class SalesByBranchesContent extends StatefulWidget {
  const SalesByBranchesContent({super.key});

  @override
  State<SalesByBranchesContent> createState() => _SalesByBranchesContentState();
}

class _SalesByBranchesContentState extends State<SalesByBranchesContent> {
  double width = 0;
  final dropdownKey = GlobalKey<DropdownButton2State>();
  double height = 0;
  bool temp = false;
  late AppLocalizations _locale;
  SalesBranchesController salesBranchesController = SalesBranchesController();
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();
  final dataMap = <String, double>{};
  List<PieChartModel> list = [
    PieChartModel(value: 10, title: "1", color: Colors.blue),
    PieChartModel(value: 20, title: "2", color: Colors.red),
    PieChartModel(value: 30, title: "3", color: Colors.green),
    PieChartModel(value: 40, title: "4", color: Colors.purple),
  ];

  List<double> listOfBalances = [];
  List<String> listOfPeriods = [];

  final List<String> items = [
    'Print',
    'Save as JPEG',
    'Save as PNG',
  ];
  String todayDate = "";
  List<String> periods = [];
  List<String> charts = [];
  var selectedPeriod = "";
  var selectedChart = "";
  List<BarChartData> barData = [];
  List<PieChartModel> pieData = [];
  String txtKey = "";

  bool isDesktop = false;
  List<Color> usedColors = [];
  String fromDate = "";
  String toDate = "";
  List<CodeReportsModel> codeReportsList = [];
  List<UserReportSettingsModel> userReportSettingsList = [];
  String startSearchCriteria = "";
  String currentPageName = "";
  String currentPageCode = "";
  SearchCriteria? searchCriteriaa;
  @override
  void didChangeDependencies() async {
    _locale = AppLocalizations.of(context)!;
    todayDate = DatesController().formatDateReverse(
        DatesController().formatDate(DatesController().todayDate()));
    _fromDateController.text = todayDate;
    _toDateController.text = todayDate;
    periods = [
      _locale.daily,
      _locale.weekly,
      _locale.monthly,
      _locale.yearly,
    ];
    charts = [_locale.lineChart, _locale.pieChart, _locale.barChart];
    selectedChart = charts[0];
    selectedPeriod = periods[0];
    getAllCodeReports();
    print("currentPageCode:::: ${currentPageCode}");

    super.didChangeDependencies();
  }

  @override
  void initState() {
    // setSearchCriteria();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    isDesktop = Responsive.isDesktop(context);

    return SingleChildScrollView(
      child: Container(
        // height: height * 1.7,
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
                    selectedChart == _locale.barChart
                        ? BalanceBarChart(data: barData)
                        : selectedChart == _locale.pieChart
                            ? Center(
                                child: PieChartComponent(
                                  radiusNormal: isDesktop ? height * 0.17 : 70,
                                  radiusHover: isDesktop ? height * 0.17 : 80,
                                  width: isDesktop ? width * 0.42 : width * 0.4,
                                  height:
                                      isDesktop ? height * 0.42 : height * 0.4,
                                  dataList: pieData,
                                ),
                              )
                            : BalanceLineChart(
                                yAxisText: _locale.balances,
                                xAxisText: _locale.periods,
                                balances: listOfBalances,
                                periods: listOfPeriods),
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

  double formatDoubleToTwoDecimalPlaces(double number) {
    return double.parse(number.toStringAsFixed(2));
  }

  Future getSalesByBranch({bool? isStart}) async {
    if (_fromDateController.text.isEmpty || _toDateController.text.isEmpty) {
      ErrorController.openErrorDialog(406, _locale.dateFieldsRequired);
      setState(() {
        if (_fromDateController.text.isEmpty) {
          _fromDateController.text = todayDate;
        }
        if (_toDateController.text.isEmpty) {
          _toDateController.text = todayDate;
        }
      });
    } else {
      // Map<String, dynamic> dataMap = json.decode('{$startSearchCriteria}');
      // SearchCriteria searchCriteria1 = SearchCriteria(
      //   fromDate: dataMap['fromDate'],
      //   toDate: dataMap['toDate'],
      //   voucherStatus: dataMap['voucherStatus'],
      //   rownum: dataMap['rownum'],
      //   byCategory: dataMap['byCategory'],
      //   branch: dataMap['branch'],
      //   page: dataMap['page'],
      // );
      // print("searchCriteria1: ${searchCriteria1.toJson()}");
      print("criiiiiiiiiiiiiiiiter: ${startSearchCriteria}");
      print(
          "searchCriteriaa!.fromDate!: ${DatesController().formatDateReverse(searchCriteriaa!.fromDate!)}");
      print("_fromDateController.text: ${_fromDateController.text}");

      SearchCriteria searchCriteria = SearchCriteria(
          fromDate:
              // searchCriteriaa!.fromDate!,
              DatesController().formatDate(_fromDateController.text.isEmpty
                  ? todayDate
                  : _fromDateController.text),
          toDate: DatesController().formatDate(_toDateController.text.isEmpty
              ? todayDate
              : _toDateController.text),
          voucherStatus: -100);
      // _fromDateController.text =
      //     DatesController().formatDateReverse(searchCriteriaa!.fromDate!);
      // _toDateController.text =
      //     DatesController().formatDateReverse(searchCriteriaa!.toDate!);

      setSearchCriteria(searchCriteria);
      pieData = [];
      dataMap.clear();
      barData = [];
      listOfBalances = [];
      listOfPeriods = [];
      salesBranchesController
          .getSalesByBranches(searchCriteria, isStart: isStart)
          .then((value) {
        for (var element in value) {
          double a = (element.totalSales! + element.retSalesDis!) -
              (element.salesDis! + element.totalReturnSales!);
          a = Converters().formateDouble(a);
          if (a != 0.0) {
            temp = true;
          } else if (a == 0.0) {
            temp = false;
          }
          setState(() {
            listOfBalances.add(a);
            listOfPeriods.add(element.namee!);
            if (temp) {
              dataMap[element.namee!] = formatDoubleToTwoDecimalPlaces(a);
              pieData.add(PieChartModel(
                  title: element.namee!,
                  value: formatDoubleToTwoDecimalPlaces(a),
                  color: getRandomColor(colorNewList, usedColors)));
            }

            barData.add(
              BarChartData(element.namee!, a),
            );
          });
        }
      });
    }
  }

  void checkPeriods(value) {
    if (value == periods[0]) {
      _fromDateController.text = DatesController().todayDate().toString();
      fromDate = DatesController().todayDate().toString();
      _toDateController.text = DatesController().todayDate().toString();
      toDate = DatesController().todayDate().toString();
    }
    if (value == periods[1]) {
      _fromDateController.text = DatesController().currentWeek().toString();
      fromDate = DatesController().currentWeek().toString();
      _toDateController.text = DatesController().todayDate().toString();
      toDate = DatesController().todayDate().toString();
    }
    if (value == periods[2]) {
      _fromDateController.text = DatesController().currentMonth().toString();
      fromDate = DatesController().currentMonth().toString();
      _toDateController.text = DatesController().todayDate().toString();
      toDate = DatesController().todayDate().toString();
    }
    if (value == periods[3]) {
      _fromDateController.text = DatesController().currentYear().toString();
      fromDate = DatesController().currentYear().toString();
      _toDateController.text = DatesController().todayDate().toString();
      toDate = DatesController().todayDate().toString();
    }
  }

  Row desktopCriteria() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CustomDropDown(
          items: periods,
          label: _locale.period,
          initialValue: selectedPeriod,
          hint: "",
          onChanged: (value) {
            setState(() {
              checkPeriods(value);
              selectedPeriod = value!;
              getSalesByBranch();
            });
          },
        ),
        CustomDate(
          date: fromDate,
          dateController: _fromDateController,
          label: _locale.fromDate,
          minYear: 2000,
          onValue: (isValid, value) {
            if (isValid) {
              setState(() {
                _fromDateController.text = value;
                DateTime from = DateTime.parse(_fromDateController.text);
                DateTime to = DateTime.parse(_toDateController.text);

                if (from.isAfter(to)) {
                  ErrorController.openErrorDialog(
                      1, _locale.startDateAfterEndDate);
                } else {
                  getSalesByBranch();
                }
              });
            }
          },
        ),
        SizedBox(
          width: width * 0.01,
        ),
        // CustomDatePicker(
        //   label: _locale.fromDate,
        //   controller: _fromDateController,
        //   date: DateTime.parse(_toDateController.text),
        //   onSelected: (value) {
        //     setState(() {
        //       _fromDateController.text = value;
        //       getSalesByBranch();
        //     });
        //   },
        // ),
        CustomDate(
          dateController: _toDateController,
          date: toDate,
          label: _locale.toDate,
          onValue: (isValid, value) {
            if (isValid) {
              setState(() {
                _toDateController.text = value;
                DateTime from = DateTime.parse(_fromDateController.text);
                DateTime to = DateTime.parse(_toDateController.text);

                if (from.isAfter(to)) {
                  ErrorController.openErrorDialog(
                      1, _locale.startDateAfterEndDate);
                } else {
                  getSalesByBranch();
                }
              });
            }
          },
        ),
        // CustomDatePicker(
        //   label: _locale.toDate,
        //   controller: _toDateController,
        //   date: DateTime.parse(_fromDateController.text),
        //   onSelected: (value) {
        //     setState(() {
        //       _toDateController.text = value;
        //       getSalesByBranch();
        //     });
        //   },
        // ),
        CustomDropDown(
          items: charts,
          hint: "",
          label: _locale.chartType,
          initialValue: selectedChart,
          onChanged: (value) {
            setState(() {
              selectedChart = value!;
              getSalesByBranch();
            });
          },
        ),
      ],
    );
  }

  getAllUserReportSettings() {
    UserReportSettingsController().getAllUserReportSettings().then((value) {
      setState(() {
        userReportSettingsList = value;
        setStartSearchCriteria();
        getSalesByBranch(isStart: true);
      });
    });
  }

  setStartSearchCriteria() {
    for (var i = 0; i < userReportSettingsList.length; i++) {
      if (currentPageCode == userReportSettingsList[i].txtReportcode) {
        txtKey = userReportSettingsList[i].txtKey;
        startSearchCriteria = userReportSettingsList[i].txtJsoncrit;
        // Adding double quotes around keys and values to make it valid JSON
        startSearchCriteria = startSearchCriteria.replaceAllMapped(
            RegExp(r'(\w+):\s*([\w-]+|\b\b)(?=,|\})'), (match) {
          if (match.group(1) == "fromDate" ||
              match.group(1) == "toDate" ||
              match.group(1) == "branch") {
            print(match.group(1));
            return '"${match.group(1)}":"${match.group(2)}"';
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
        _toDateController.text =
            DatesController().formatDateReverse(searchCriteriaa!.toDate!);
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

  setPageName() {
    for (var i = 0; i < codeReportsList.length; i++) {
      if (codeReportsList[i].txtReportnamee ==
          ReportConstants.salesByBranches) {
        setState(() {
          currentPageName = codeReportsList[i].txtReportnamee;
          currentPageCode = codeReportsList[i].txtReportcode;
          print("/ ${codeReportsList[i].toJson()}");
        });
      }
    }
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

  Column mobileCriteria() {
    double widthMobile = width;
    return Column(
      children: [
        CustomDropDown(
          items: periods,
          width: widthMobile * 0.81,
          label: _locale.period,
          initialValue: selectedPeriod,
          hint: "",
          onChanged: (value) {
            setState(() {
              checkPeriods(value);
              selectedPeriod = value!;
              getSalesByBranch();
            });
          },
        ),
        SizedBox(
          width: widthMobile * 0.81,
          child: CustomDate(
            date: fromDate,
            dateController: _fromDateController,
            label: _locale.fromDate,
            minYear: 2000,
            onValue: (isValid, value) {
              if (isValid) {
                setState(() {
                  _fromDateController.text = value;
                  DateTime from = DateTime.parse(_fromDateController.text);
                  DateTime to = DateTime.parse(_toDateController.text);

                  if (from.isAfter(to)) {
                    ErrorController.openErrorDialog(
                        1, _locale.startDateAfterEndDate);
                  } else {
                    getSalesByBranch();
                  }
                });
              }
            },
          ),
        ),
        // CustomDatePicker(
        //   label: _locale.fromDate,
        //   controller: _fromDateController,
        //   date: DateTime.parse(_toDateController.text),
        //   onSelected: (value) {
        //     setState(() {
        //       _fromDateController.text = value;
        //       getSalesByBranch();
        //     });
        //   },
        // ),
        SizedBox(
          width: widthMobile * 0.81,
          child: CustomDate(
            date: toDate,
            dateController: _toDateController,
            label: _locale.toDate,
            onValue: (isValid, value) {
              if (isValid) {
                setState(() {
                  _toDateController.text = value;
                  DateTime from = DateTime.parse(_fromDateController.text);
                  DateTime to = DateTime.parse(_toDateController.text);

                  if (from.isAfter(to)) {
                    ErrorController.openErrorDialog(
                        1, _locale.startDateAfterEndDate);
                  } else {
                    getSalesByBranch();
                  }
                });
              }
            },
          ),
        ),
        // CustomDatePicker(
        //   label: _locale.toDate,
        //   controller: _toDateController,
        //   date: DateTime.parse(_fromDateController.text),
        //   onSelected: (value) {
        //     setState(() {
        //       _toDateController.text = value;
        //       getSalesByBranch();
        //     });
        //   },
        // ),
        CustomDropDown(
          items: charts,
          width: widthMobile * 0.81,
          label: _locale.chartType,
          initialValue: selectedChart,
          hint: "",
          onChanged: (value) {
            setState(() {
              selectedChart = value!;
              getSalesByBranch();
            });
          },
        ),
      ],
    );
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
        // txtJsoncrit: json.encode(searchCriteria.toJson()),
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
}
