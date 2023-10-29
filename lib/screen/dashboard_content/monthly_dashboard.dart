import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:math';
import 'package:bi_replicate/model/criteria/search_criteria.dart';
import 'package:bi_replicate/utils/func/converters.dart';
import 'package:bi_replicate/widget/custom_date_picker.dart';
import '../../../controller/sales_adminstration/sales_branches_controller.dart';
import '../../../utils/constants/colors.dart';
import '../../../widget/drop_down/custom_dropdown.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../model/bar_chart_data_model.dart';
import '../../../model/chart/pie_chart_model.dart';
import '../../../utils/func/dates_controller.dart';
import '../../components/charts.dart';
import '../../components/charts/pie_chart.dart';
import '../../controller/financial_performance/cash_flow_controller.dart';
import '../../controller/receivable_management/rec_pay_controller.dart';
import '../../controller/sales_adminstration/daily_sales_controller.dart';
import '../../controller/settings/setup/accounts_name.dart';
import '../../model/settings/setup/bi_account_model.dart';
import '../../utils/constants/constants.dart';
import '../../utils/constants/maps.dart';
import '../../utils/constants/responsive.dart';

class MonthlyDashboard extends StatefulWidget {
  MonthlyDashboard({Key? key}) : super(key: key);

  @override
  _MonthlyDashboardState createState() => _MonthlyDashboardState();
}

class _MonthlyDashboardState extends State<MonthlyDashboard> {
  double width = 0;
  double height = 0;
  final dropdownKey = GlobalKey<DropdownButton2State>();
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
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    isDesktop = Responsive.isDesktop(context);
    return SingleChildScrollView(
      child: Container(
        // height: height * 1.7,
        decoration: const BoxDecoration(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                // width: width * 0.7,
                // height: isDesktop ? height * 0.6 : height * 0.6,
                // decoration: borderDecoration,
                height: isDesktop ? height * 0.89 : height * 1.2,

                width: double.infinity,
                padding: EdgeInsets.all(appPadding),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _locale.monthlyComparsionOFReceivableAndPayables,
                            style: TextStyle(fontSize: isDesktop ? 24 : 18),
                          ),
                        ),
                      ],
                    ),
                    isDesktop ? desktopCriteria() : mobileCriteria(),
                    BalanceLineChart(
                        yAxisText: _locale.balances,
                        xAxisText: _locale.periods,
                        balances: listOfBalances,
                        periods: listOfPeriods)
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
            CustomDatePicker(
              label: _locale.fromDate,
              date: DateTime.now(),
              controller: _fromDateController,
              onSelected: (value) {
                setState(() {
                  _fromDateController.text = value;
                  getRecPayData();
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
        CustomDatePicker(
          label: _locale.fromDate,
          date: DateTime.now(),
          controller: _fromDateController,
          onSelected: (value) {
            setState(() {
              _fromDateController.text = value;
              getRecPayData();
            });
          },
        ),
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
