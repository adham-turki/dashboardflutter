import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../components/charts.dart';
import '../../../components/custom_date.dart';
import '../../../controller/receivable_management/rec_pay_controller.dart';
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

class MonthCompOfRecPayContent extends StatefulWidget {
  const MonthCompOfRecPayContent({super.key});

  @override
  State<MonthCompOfRecPayContent> createState() =>
      _MonthCompOfRecPayContentState();
}

class _MonthCompOfRecPayContentState extends State<MonthCompOfRecPayContent> {
  double width = 0;
  final dropdownKey = GlobalKey<DropdownButton2State>();
  double height = 0;
  bool isDesktop = false;
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();
  RecPayController recPayController = RecPayController();
  bool accountsActive = false;
  late AppLocalizations _locale;
  List<String> status = [];
  List<String> charts = [];
  var selectedStatus = "";

  var selectedChart = "";
  List<CodeReportsModel> codeReportsList = [];
  List<UserReportSettingsModel> userReportSettingsList = [];
  String startSearchCriteria = "";
  String currentPageName = "";
  String currentPageCode = "";
  SearchCriteria? searchCriteriaa;
  String txtKey = "";
  List<double> listOfBalances = [];
  List<String> listOfPeriods = [];
  List<double> listOfBalances2 = [];
  List<String> listOfPeriods2 = [];
  List<BiAccountModel> payableRecAccounts = [];
  String accountNameString = "";
  final List<String> items = [
    'Print',
    'Save as JPEG',
    'Save as PNG',
  ];
  final dataMap = <String, double>{};

  final colorList = <Color>[
    Colors.green,
    Colors.blue,
    Colors.red,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.teal,
    Colors.amber,
    Colors.cyan,
    Colors.deepPurple,
    Colors.lime,
    Colors.indigo,
    Colors.lightBlue,
    Colors.deepOrange,
    Colors.brown,
  ];
  List<BarChartData> barData = [];
  List<BarChartData> barData2 = [];
  String todayDate = "";

  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context);
    todayDate = DatesController().formatDateReverse(
        DatesController().formatDate(DatesController().todayDate()));

    _fromDateController.text = todayDate;
    _toDateController.text = todayDate;
    status = [
      _locale.all,
      _locale.posted,
      _locale.draft,
      _locale.canceled,
    ];

    charts = [
      _locale.lineChart,
      _locale.barChart,
    ];
    selectedChart = charts[0];
    selectedStatus = status[0];
    // getRecPayData(isStart: true);
    getAllCodeReports();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // getExpensesAccounts();
    payableRecAccounts = [];
    getPayableAccounts(isStart: true).then((value) {
      payableRecAccounts = value;
      setState(() {});
    });
    getReceivableAccounts(isStart: true).then((value) {
      payableRecAccounts.addAll(value);
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: isDesktop ? width * 0.7 : width * 0.9,
            decoration: borderDecoration,
            child: isDesktop ? desktopCriteria() : mobileCriteria(),
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
              height: isDesktop ? height * 0.55 : height * 0.6,
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
                      ? BalanceDoubleLineChart(
                          xAxisText: "",
                          yAxisText: _locale.balances,
                          balances: listOfBalances,
                          periods: listOfPeriods,
                          balances2: listOfBalances2,
                          periods2: listOfPeriods2,
                        )
                      : BalanceDoubleBarChart(
                          data: barData,
                          data2: barData2,
                        ),
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
        getRecPayData(isStart: true);
      });
    });
  }

  setPageName() {
    for (var i = 0; i < codeReportsList.length; i++) {
      if (codeReportsList[i].txtReportnamee ==
          ReportConstants.monthlyComparison) {
        setState(() {
          currentPageName = codeReportsList[i].txtReportnamee;
          currentPageCode = codeReportsList[i].txtReportcode;
          print("codeReportsList[i]: ${codeReportsList[i].toJson()}");
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
              getRecPayData();
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

                  getRecPayData();
                });
              },
            ),
            CustomDate(
              dateController: _fromDateController,
              label: _locale.fromDate,
              // minYear: 2000,
              onValue: (isValid, value) {
                if (isValid) {
                  setState(() {
                    _fromDateController.text = value;

                    getRecPayData();
                  });
                }
              },
            ),
            // CustomDatePicker(
            //   label: _locale.fromDate,
            //   date: DateTime.now(),
            //   controller: _fromDateController,
            //   onSelected: (value) {
            //     setState(() {
            //       _fromDateController.text = value;
            //       getRecPayData();
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
              getRecPayData();
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

              getRecPayData();
            });
          },
        ),
        SizedBox(
          width: widthMobile * 0.81,
          child: CustomDate(
            dateController: _fromDateController,
            label: _locale.fromDate,
            // minYear: 2000,
            onValue: (isValid, value) {
              if (isValid) {
                setState(() {
                  _fromDateController.text = value;
                  getRecPayData();
                });
              }
            },
          ),
        ),
        // CustomDatePicker(
        //   label: _locale.fromDate,
        //   date: DateTime.now(),
        //   controller: _fromDateController,
        //   onSelected: (value) {
        //     setState(() {
        //       _fromDateController.text = value;
        //       getRecPayData();
        //     });
        //   },
        // ),
      ],
    );
  }

  getRecPayData({bool? isStart}) {
    listOfBalances = [];
    listOfBalances2 = [];
    listOfPeriods = [];
    listOfPeriods2 = [];
    dataMap.clear();
    barData = [];
    barData2 = [];
    if (_fromDateController.text.isEmpty || _toDateController.text.isEmpty) {
      setState(() {
        if (_fromDateController.text.isEmpty) {
          _fromDateController.text = todayDate;
        }
        if (_toDateController.text.isEmpty) {
          _toDateController.text = todayDate;
        }
      });
    }
    int status = getVoucherStatus(_locale, selectedStatus);
    SearchCriteria searchCriteria = SearchCriteria(
        fromDate: DatesController().formatDate(_fromDateController.text),
        voucherStatus: status);
    setSearchCriteria(searchCriteria);
    recPayController
        .getRecPayMethod(searchCriteria, isStart: isStart)
        .then((value) {
      int maxVal = value.payables.length > value.receivables.length
          ? value.payables.length
          : value.receivables.length;
      for (int i = 0; i < maxVal; i++) {
        setState(() {
          listOfBalances.add(double.parse(value.payables[i].value!));
          listOfBalances2.add(double.parse(value.receivables[i].value!));
          listOfPeriods.add(value.payables[i].date!);
          listOfPeriods2.add(value.receivables[i].date!);

          barData.add(
            BarChartData(value.payables[i].date!,
                double.parse(value.payables[i].value!)),
          );
          barData2.add(
            BarChartData(value.receivables[i].date!,
                double.parse(value.receivables[i].value!)),
          );
        });
      }
    });
  }

  String accountName() {
    accountNameString = "";
    for (int i = 0; i < payableRecAccounts.length; i++) {
      accountNameString += "${payableRecAccounts[i].accountName},";
    }
    return accountNameString;
  }
}
