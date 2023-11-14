import 'dart:math';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:bi_replicate/model/criteria/search_criteria.dart';
import '../../../model/chart/pie_chart_model.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/func/dates_controller.dart';
import '../../components/charts.dart';
import '../../components/charts/pie_chart_dashboard.dart';
import '../../controller/sales_adminstration/daily_sales_controller.dart';
import '../../controller/settings/setup/accounts_name.dart';
import '../../model/settings/setup/bi_account_model.dart';
import '../../utils/constants/app_utils.dart';
import '../../utils/constants/maps.dart';
import '../../utils/constants/responsive.dart';
import 'filter_dialog/filter_dialog_daily_sales.dart';

class DailySalesDashboard extends StatefulWidget {
  DailySalesDashboard({
    Key? key,
  }) : super(key: key);

  @override
  _DailySalesDashboardState createState() => _DailySalesDashboardState();
}

class _DailySalesDashboardState extends State<DailySalesDashboard> {
  double width = 0;
  double height = 0;
  final dropdownKey = GlobalKey<DropdownButton2State>();
  bool isDesktop = false;
  //final TextEditingController _fromDateController = TextEditingController();
  final storage = const FlutterSecureStorage();
  DailySalesController dailySalesController = DailySalesController();
  late AppLocalizations _locale;

  List<String> status = [];

  List<String> charts = [];

  bool accountsActive = false;

  TextEditingController fromDateController = TextEditingController();
  var period = "";
  var statusVar = "";

  String todayDate = "";

  var selectedStatus = "";
  var selectedChart = "";
  List<double> listOfBalances = [];
  List<String> listOfPeriods = [];
  final dataMap = <String, double>{};
  bool boolTemp = false;
  List<BarData> barData = [];

  List<PieChartModel> barDataDailySales = [];
  var selectedBranchCode = "";

  List<BiAccountModel> payableAccounts = [];

  final List<String> items = [
    'Print',
    'Save as JPEG',
    'Save as PNG',
  ];
  List<BarData> barDataTest = [];
  String lastBranchCode = "";

  List<PieChartModel> pieData = [];
  String accountNameString = "";
  String lastFromDate = "";
  String lastStatus = "";

  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context);
    todayDate = DatesController().formatDate(DatesController().twoYearsAgo());
    fromDateController.text = todayDate;
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
    super.didChangeDependencies();
  }

  @override
  void initState() {
    getPayableAccounts(isStart: true).then((value) {
      payableAccounts = value;
      setState(() {});
    });
    Future.delayed(Duration.zero, () {
      lastFromDate = fromDateController.text;
      lastStatus = selectedStatus;
      lastBranchCode = selectedBranchCode;
      selectedChart = _locale.lineChart;
      getPayableAccountsData().then((value) {
        setState(() {});
      });
    });
    super.initState();
  }

  Future<void> getPayableAccountsData() async {
    await getDailySales1().then((value) {
      setState(() {});
    });
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
              padding:
                  const EdgeInsets.only(left: 5, right: 5, bottom: 3, top: 0),
              child: Container(
                // width: width * 0.7,
                // height: isDesktop ? height * 0.6 : height * 0.6,
                // decoration: borderDecoration,
                height: isDesktop ? height * 0.44 : height * 0.53,

                // width: double.infinity,
                padding: EdgeInsets.only(left: 5, right: 5, top: 0),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _locale.dailySales,
                          style: TextStyle(fontSize: isDesktop ? 15 : 18),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0.0, vertical: 0),
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width < 800
                                  ? MediaQuery.of(context).size.width * 0.06
                                  : MediaQuery.of(context).size.width * 0.03,
                              child: blueButton1(
                                icon: Icon(
                                  Icons.filter_list_sharp,
                                  color: whiteColor,
                                  size: isDesktop
                                      ? height * 0.035
                                      : height * 0.03,
                                ),
                                // text: _locale.filter,
                                textColor: Color.fromARGB(255, 255, 255, 255),
                                //   borderRadius: 5.0,
                                height:
                                    isDesktop ? height * .015 : height * .039,
                                fontSize:
                                    isDesktop ? height * .018 : height * .017,
                                width: isDesktop ? width * 0.13 : width * 0.27,
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return FilterDialogDailySales(
                                        onFilter: (
                                          fromDate,
                                          selectedStatus,
                                          chart,
                                          selectedBranchCodeF,
                                        ) {
                                          fromDateController.text = fromDate;
                                          statusVar = selectedStatus;
                                          selectedChart = chart;
                                          selectedBranchCode =
                                              selectedBranchCodeF;
                                        },
                                      );
                                    },
                                  ).then((value) async {
                                    getDailySales().then((value) {
                                      setState(() {});
                                    });
                                  });
                                },
                              )),
                        ),
                      ],
                    ),
                    // selectedChart == _locale.barChart
                    //     ? SizedBox(
                    //         height: 15,
                    //       )
                    //     : Container(),
                    selectedChart == _locale.barChart
                        ? CustomBarChart(
                            data: barData,
                          )
                        : selectedChart == _locale.pieChart
                            ? Center(
                                child: PieChartDashboard(
                                  radiusNormal:
                                      isDesktop ? height * 0.15 : height * 0.15,
                                  radiusHover: isDesktop
                                      ? height * 0.15
                                      : height * 0.015,
                                  width: isDesktop ? width * 0.4 : width * 0.05,
                                  height:
                                      isDesktop ? height * 0.31 : height * 0.37,
                                  dataList: barDataDailySales,
                                ),
                              )
                            : BalanceLineChart(
                                yAxisText: "",
                                xAxisText: "",
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

  double formatDoubleToTwoDecimalPlaces(double number) {
    return double.parse(number.toStringAsFixed(2));
  }

  Future<void> getDailySales1({bool? isStart}) async {
    int stat = getVoucherStatus(_locale, statusVar);
    var selectedFromDate = fromDateController.text;
    final selectedStatus = statusVar;
    final selectedBranchCodeValue = selectedBranchCode;

    // if (selectedFromDate != lastFromDate || selectedStatus != lastStatus) {
    //   lastFromDate = selectedFromDate;
    //   lastStatus = selectedStatus;

    if (selectedFromDate.isEmpty) {
      selectedFromDate = todayDate;
    }
    SearchCriteria searchCriteria = SearchCriteria(
      fromDate: selectedFromDate,
      voucherStatus: stat,
      branch: selectedBranchCode,
    );

    await dailySalesController
        .getDailySale(searchCriteria, isStart: isStart)
        .then((response) {
      for (var elemant in response) {
        String temp = DatesController().formatDate(getNextDay(
          selectedFromDate,
        ).toString());
        if (double.parse(elemant.dailySale.toString()) != 0.0) {
          boolTemp = true;
        } else if (double.parse(elemant.dailySale.toString()) == 0.0) {
          boolTemp = false;
        }

        listOfBalances.add(double.parse(elemant.dailySale.toString()));
        listOfPeriods.add(temp);
        if (boolTemp) {
          dataMap[temp] = formatDoubleToTwoDecimalPlaces(
              double.parse(elemant.dailySale.toString()));
          barDataDailySales.add(PieChartModel(
              title: temp,
              value: double.parse(elemant.dailySale.toString()) == 0.0
                  ? 1.0
                  : formatDoubleToTwoDecimalPlaces(
                      double.parse(elemant.dailySale.toString())),
              color: getRandomColor(colorNewList)));
        }

        barData.add(
          BarData(
              name: temp, percent: double.parse(elemant.dailySale.toString())),
        );
      }
    });
  }
  // }

  Future<void> getDailySales({bool? isStart}) async {
    int stat = getVoucherStatus(_locale, statusVar);
    var selectedFromDate = fromDateController.text;
    final selectedStatus = statusVar;
    final selectedBranchCodeValue = selectedBranchCode;

    if (selectedFromDate != lastFromDate ||
        selectedStatus != lastStatus ||
        selectedBranchCodeValue != lastBranchCode) {
      lastFromDate = selectedFromDate;
      lastStatus = selectedStatus;
      lastBranchCode = selectedBranchCode;

      if (selectedFromDate.isEmpty) {
        selectedFromDate = todayDate;
      }
      SearchCriteria searchCriteria = SearchCriteria(
        fromDate: selectedFromDate,
        voucherStatus: stat,
        branch: selectedBranchCode,
      );

      await dailySalesController
          .getDailySale(searchCriteria, isStart: isStart)
          .then((response) {
        for (var elemant in response) {
          String temp = DatesController().formatDate(getNextDay(
            selectedFromDate,
          ).toString());
          if (double.parse(elemant.dailySale.toString()) != 0.0) {
            boolTemp = true;
          } else if (double.parse(elemant.dailySale.toString()) == 0.0) {
            boolTemp = false;
          }

          listOfBalances.add(double.parse(elemant.dailySale.toString()));
          listOfPeriods.add(temp);
          if (boolTemp) {
            dataMap[temp] = formatDoubleToTwoDecimalPlaces(
                double.parse(elemant.dailySale.toString()));
            barDataDailySales.add(PieChartModel(
                title: temp,
                value: double.parse(elemant.dailySale.toString()) == 0.0
                    ? 1.0
                    : formatDoubleToTwoDecimalPlaces(
                        double.parse(elemant.dailySale.toString())),
                color: getRandomColor(colorNewList)));
          }

          barData.add(
            BarData(
                name: temp,
                percent: double.parse(elemant.dailySale.toString())),
          );
        }
      });
    }
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
}
