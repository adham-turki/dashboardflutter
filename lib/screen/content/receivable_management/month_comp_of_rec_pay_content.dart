import 'package:bi_replicate/model/chart/pie_chart_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../../components/charts.dart';
import '../../../components/charts/pie_chart.dart';
import '../../../components/customCard.dart';
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
  double height = 0;
  bool isDesktop = false;
  TextEditingController _fromDateController = TextEditingController();
  TextEditingController _toDateController = TextEditingController();
  RecPayController recPayController = RecPayController();
  DateTime? _selectedDate = DateTime.now();
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

  List<BarChartData> barData = [];
  List<BarChartData> barData2 = [];

  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context);
    String todayDate = DatesController().formatDateReverse(
        DatesController().formatDate(DatesController().todayDate()));
    String nextMonth = DatesController().formatDateReverse(DatesController()
        .formatDate(DateTime(DatesController().today.year,
                DatesController().today.month + 1, DatesController().today.day)
            .toString()));

    _fromDateController.text = todayDate;
    _toDateController.text = nextMonth;
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
    getRecPayData();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // getExpensesAccounts();
    payableRecAccounts = [];
    getPayableAccounts().then((value) {
      payableRecAccounts = value;
      setState(() {});
    });
    getReceivableAccounts().then((value) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CustomCard(
                  gradientColor: [Color(0xff1cacff), Color(0xff30c4ff)],
                  title: '42136',
                  subtitle: 'Mon-Fri',
                  label: 'Overall Sale',
                  icon:
                      Icons.attach_money, // Provide the actual path to the icon
                ),
                SizedBox(
                  width: 10,
                ),
                CustomCard(
                  gradientColor: [Color(0xfffd8236), Color(0xffffce6c)],
                  title: '1446',
                  subtitle: 'Mon-Fri',
                  label: 'Total Visited',
                  icon: Icons.abc, // Provide the actual path to the icon
                ),
                SizedBox(
                  width: 10,
                ),
                CustomCard(
                  gradientColor: [Color(0xff4741c1), Color(0xff7e4fe4)],
                  title: '61%',
                  subtitle: 'Mon-Fri',
                  label: 'Overall Growth',
                  icon: Icons.bar_chart, // Provide the actual path to the icon
                ),
              ],
            ),
            SizedBox(
              height: height * 0.1,
            ),
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
                      style: twelve400TextStyle(Colors.black),
                    ))
                : Container(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: width * 0.7,
                height: isDesktop ? height * 0.6 : height * 0.5,
                decoration: borderDecoration,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            selectedChart == _locale.lineChart
                                ? _locale.lineChart
                                : selectedChart == _locale.pieChart
                                    ? _locale.pieChart
                                    : _locale.barChart,
                            style: const TextStyle(fontSize: 24),
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
              print(selectedChart);
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
                  print(selectedStatus);
                });
              },
            ),
            CustomDatePicker(
              label: _locale.fromDate,
              controller: _fromDateController,
              onSelected: (value) {
                setState(() {
                  _fromDateController.text = value;
                  getRecPayData();
                  print(_fromDateController.text);
                });
              },
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
          width: widthMobile,
          items: charts,
          label: _locale.chartType,
          initialValue: selectedChart,
          onChanged: (value) {
            setState(() {
              selectedChart = value!;
              getRecPayData();
              print(selectedChart);
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
              print(selectedStatus);
            });
          },
        ),
        CustomDatePicker(
          label: _locale.fromDate,
          controller: _fromDateController,
          onSelected: (value) {
            setState(() {
              _fromDateController.text = value;
              getRecPayData();
              print(_fromDateController.text);
            });
          },
        ),
      ],
    );
  }

  getRecPayData() {
    listOfBalances = [];
    listOfBalances2 = [];
    listOfPeriods = [];
    listOfPeriods2 = [];
    barData = [];
    barData2 = [];

    int status = getVoucherStatus(_locale, selectedStatus);
    SearchCriteria searchCriteria = SearchCriteria(
        fromDate: DatesController().formatDate(_fromDateController.text),
        voucherStatus: status);

    recPayController.getRecPayMethod(searchCriteria).then((value) {
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
