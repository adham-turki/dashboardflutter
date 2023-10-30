import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import '../../../components/charts.dart';
import '../../../components/custom_date.dart';
import '../../../controller/receivable_management/rec_pay_controller.dart';
import '../../../controller/settings/setup/accounts_name.dart';
import '../../../model/bar_chart_data_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../model/criteria/search_criteria.dart';
import '../../../model/settings/setup/bi_account_model.dart';
import '../../../utils/constants/maps.dart';
import '../../../utils/constants/responsive.dart';
import '../../../utils/constants/styles.dart';
import '../../../utils/func/dates_controller.dart';
import '../../../widget/custom_date_picker.dart';
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
    getRecPayData(isStart: true);
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
      child: Container(
        // height: height,
        decoration: const BoxDecoration(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: width * 0.7,
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
                  width: MediaQuery.of(context).size.width < 800
                      ? MediaQuery.of(context).size.width * 0.9
                      : MediaQuery.of(context).size.width * 0.7,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
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
                    width: MediaQuery.of(context).size.width < 800
                        ? MediaQuery.of(context).size.width * 0.9
                        : MediaQuery.of(context).size.width * 0.7,
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
                width: width * 0.7,
                height: isDesktop ? height * 0.5 : height * 0.6,
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
      ),
    );
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
          width: widthMobile,
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
          width: widthMobile,
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
          width: widthMobile,
          child: CustomDate(
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
