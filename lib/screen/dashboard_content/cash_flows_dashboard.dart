import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
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
import '../../controller/financial_performance/cash_flow_controller.dart';
import '../../controller/settings/setup/accounts_name.dart';
import '../../model/settings/setup/bi_account_model.dart';
import '../../utils/constants/constants.dart';
import '../../utils/constants/maps.dart';
import '../../utils/constants/responsive.dart';

class CashFlowsDashboard extends StatefulWidget {
  CashFlowsDashboard({Key? key}) : super(key: key);

  @override
  _CashFlowsDashboardState createState() => _CashFlowsDashboardState();
}

class _CashFlowsDashboardState extends State<CashFlowsDashboard> {
  List<BarChartData> data = [];
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
  var selectedPeriod = "";

  List<BarChartData> barData = [];
  List<PieChartModel> pieData = [];

  CashFlowController cashFlowController = CashFlowController();

  List<String> status = [];

  var selectedStatus = "";

  double balance = 0;
  bool accountsActive = false;
  String accountNameString = "";

  List<BiAccountModel> cashboxAccounts = [];

  bool isDesktop = false;
  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context);
    todayDate = DatesController().formatDateReverse(
        DatesController().formatDate(DatesController().todayDate()));
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

    selectedPeriod = periods[0];
    selectedStatus = status[0];
    getCashFlows();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _fromDateController.text = todayDate;
    _toDateController.text = todayDate;

    getCashBoxAccount().then((value) {
      cashboxAccounts = value;
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
                            _locale.cashFlows,
                            style: TextStyle(fontSize: isDesktop ? 24 : 18),
                          ),
                        ),
                      ],
                    ),
                    isDesktop ? desktopCriteria() : mobileCriteria(),
                    BalanceBarChart(data: barData, color: colorNewList[7])
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row desktopCriteria() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomDropDown(
                  items: periods,
                  label: _locale.period,
                  initialValue: selectedPeriod,
                  onChanged: (value) {
                    setState(() {
                      checkPeriods(value);
                      selectedPeriod = value!;
                      getCashFlows();
                    });
                  },
                ),
                CustomDropDown(
                  items: status,
                  label: _locale.status,
                  initialValue: selectedStatus,
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value!;
                      getCashFlows();
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomDatePicker(
                  label: _locale.fromDate,
                  date: DateTime.parse(_toDateController.text),
                  controller: _fromDateController,
                  onSelected: (value) {
                    setState(() {
                      _fromDateController.text = value;
                      getCashFlows();
                    });
                  },
                ),
                CustomDatePicker(
                  label: _locale.toDate,
                  controller: _toDateController,
                  date: DateTime.parse(_fromDateController.text),
                  onSelected: (value) {
                    setState(() {
                      _toDateController.text = value;
                      getCashFlows();
                    });
                  },
                ),
              ],
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
          items: periods,
          label: _locale.period,
          initialValue: selectedPeriod,
          onChanged: (value) {
            setState(() {
              checkPeriods(value);
              selectedPeriod = value!;
              getCashFlows();
            });
          },
        ),
        CustomDropDown(
          width: widthMobile,
          items: status,
          label: _locale.byCategory,
          initialValue: selectedStatus,
          onChanged: (value) {
            setState(() {
              selectedStatus = value!;
              getCashFlows();
            });
          },
        ),
        CustomDatePicker(
          label: _locale.fromDate,
          controller: _fromDateController,
          date: DateTime.parse(_toDateController.text),
          onSelected: (value) {
            setState(() {
              _fromDateController.text = value;
              getCashFlows();
            });
          },
        ),
        CustomDatePicker(
          label: _locale.toDate,
          controller: _toDateController,
          date: DateTime.parse(_fromDateController.text),
          onSelected: (value) {
            setState(() {
              _toDateController.text = value;
              getCashFlows();
            });
          },
        ),
      ],
    );
  }

  String accountName() {
    accountNameString = "";
    for (int i = 0; i < cashboxAccounts.length; i++) {
      accountNameString += "${cashboxAccounts[i].accountName},";
    }
    return accountNameString;
  }

  double formatDoubleToTwoDecimalPlaces(double number) {
    return double.parse(number.toStringAsFixed(2));
  }

  void getCashFlows() {
    listOfBalances = [];
    pieData = [];
    barData = [];
    dataMap.clear();
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
    String startDate = DatesController().formatDate(_fromDateController.text);
    String endDate = DatesController().formatDate(_toDateController.text);
    SearchCriteria searchCriteria = SearchCriteria(
        fromDate: startDate, toDate: endDate, voucherStatus: status);
    cashFlowController.getChartCash(searchCriteria).then((value) {
      setState(() {
        balance = value[0].value! - value[1].value!;
      });
      for (var element in value) {
        if (element.value != 0.0) {
          temp = true;
        } else if (element.value == 0.0) {
          temp = false;
        }
        if (element.title! == "debit") {
          listOfBalances.add(element.value!);
          listOfPeriods.add(_locale.cashIn);
          if (temp) {
            dataMap[_locale.cashIn] =
                formatDoubleToTwoDecimalPlaces(element.value!);
            pieData.add(PieChartModel(
                title: _locale.cashIn,
                value: formatDoubleToTwoDecimalPlaces(element.value!),
                color: getRandomColor(colorNewList)));
          }
          barData.add(
            BarChartData(_locale.cashIn, element.value!),
          );
        } else {
          listOfBalances.add(element.value!);
          listOfPeriods.add(_locale.cashOut);
          if (temp) {
            dataMap[_locale.cashOut] =
                formatDoubleToTwoDecimalPlaces(element.value!);
            pieData.add(PieChartModel(
                title: _locale.cashOut,
                value: element.value,
                color: getRandomColor(colorNewList)));
          }
          barData.add(
            BarChartData(_locale.cashOut, element.value!),
          );
        }
      }
    });
  }

  void checkPeriods(value) {
    if (value == periods[0]) {
      _fromDateController.text = DatesController().todayDate().toString();
      _toDateController.text = DatesController().todayDate().toString();
    }
    if (value == periods[1]) {
      _fromDateController.text = DatesController().currentWeek().toString();
      _toDateController.text = DatesController().todayDate().toString();
    }
    if (value == periods[2]) {
      _fromDateController.text = DatesController().currentMonth().toString();
      _toDateController.text = DatesController().todayDate().toString();
    }
    if (value == periods[3]) {
      _fromDateController.text = DatesController().currentYear().toString();
      _toDateController.text = DatesController().todayDate().toString();
    }
  }

  Color getRandomColor(List<Color> colorList) {
    final random = Random();
    final index = random.nextInt(colorList.length);
    return colorList[index];
  }
}
