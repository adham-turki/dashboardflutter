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
import '../../controller/sales_adminstration/daily_sales_controller.dart';
import '../../controller/settings/setup/accounts_name.dart';
import '../../model/settings/setup/bi_account_model.dart';
import '../../utils/constants/constants.dart';
import '../../utils/constants/maps.dart';
import '../../utils/constants/responsive.dart';

class DailySalesDashboard extends StatefulWidget {
  DailySalesDashboard({Key? key}) : super(key: key);

  @override
  _DailySalesDashboardState createState() => _DailySalesDashboardState();
}

class _DailySalesDashboardState extends State<DailySalesDashboard> {
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

  List<PieChartModel> pieData = [];
  String accountNameString = "";
  List<BarChartData> barData = [];

  bool boolTemp = false;
  String todayDate = "";

  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context);
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
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // getExpensesAccounts();

    getPayableAccounts().then((value) {
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
                            _locale.dailySales,
                            style: TextStyle(fontSize: isDesktop ? 24 : 18),
                          ),
                        ),
                      ],
                    ),
                    isDesktop ? desktopCriteria() : mobileCriteria(),
                    PieChartComponent(
                      radiusNormal: isDesktop ? height * 0.17 : 70,
                      radiusHover: isDesktop ? height * 0.17 : 80,
                      width: isDesktop ? width * 0.42 : width * 0.1,
                      height: isDesktop ? height * 0.42 : height * 0.4,
                      dataList: pieData,
                    ),
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
        Column(
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
            CustomDatePicker(
              label: _locale.fromDate,
              controller: _fromDateController,
              date: DateTime.now(),
              onSelected: (value) {
                setState(() {
                  _fromDateController.text = value;
                  getDailySales();
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

              getDailySales();
            });
          },
        ),
        CustomDatePicker(
          label: _locale.fromDate,
          controller: _fromDateController,
          date: DateTime.now(),
          onSelected: (value) {
            setState(() {
              _fromDateController.text = value;
              getDailySales();
            });
          },
        ),
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
                color: getRandomColor(colorNewList)));
          }

          barData.add(
            BarChartData(temp, double.parse(elemant.dailySale.toString())),
          );
        });
      }
    });
  }

  Color getRandomColor(List<Color> colorList) {
    final random = Random();
    final index = random.nextInt(colorList.length);
    return colorList[index];
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
