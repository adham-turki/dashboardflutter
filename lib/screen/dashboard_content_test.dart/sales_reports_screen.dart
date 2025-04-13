import 'dart:async';
import 'dart:ui' as ui;
import 'package:bi_replicate/components/dashboard_components/pie_dashboard_chart.dart';
import 'package:bi_replicate/dialogs/fliter_dialog.dart';
import 'package:bi_replicate/model/cashier_model.dart';
import 'package:bi_replicate/model/chart/pie_chart_model.dart';

import 'package:bi_replicate/model/sales_view_model.dart';
import 'package:bi_replicate/provider/screen_content_provider.dart';
import 'package:bi_replicate/utils/constants/app_utils.dart';
import 'package:bi_replicate/utils/constants/colors.dart';
import 'package:bi_replicate/utils/constants/responsive.dart';
import 'package:bi_replicate/utils/func/converters.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../controller/total_sales_controller.dart';
import '../../model/chart/chart_data_model.dart';
import '../../model/sales/search_crit.dart';
import '../../model/total_profit_report_model.dart';

class SalesReportsScreen extends StatefulWidget {
  const SalesReportsScreen({super.key});

  @override
  State<SalesReportsScreen> createState() => _SalesReportsScreenState();
}

class _SalesReportsScreenState extends State<SalesReportsScreen> {
  bool isDesktop = true;
  double width = 0;
  double height = 0;
  DateTime now = DateTime.now();
  int colorIndex = 0;
  String formattedFromDate = "";
  String formattedToDate = "";
  SearchCriteria cashierSearchCriteria = SearchCriteria(
      branch: "all",
      shiftStatus: "all",
      cashier: "",
      transType: "",
      fromDate: "",
      toDate: "");
  SearchCriteria desktopSearchCriteria = SearchCriteria(
      branch: "all",
      shiftStatus: "all",
      cashier: "",
      transType: "",
      fromDate: "",
      toDate: "");
  SearchCriteria payTypesSearchCriteria = SearchCriteria(
      branch: "all",
      shiftStatus: "all",
      cashier: "",
      transType: "",
      fromDate: "",
      toDate: "");
  SearchCriteria hoursSearchCriteria = SearchCriteria(
      branch: "all",
      shiftStatus: "all",
      cashier: "",
      transType: "",
      fromDate: "",
      toDate: "");
  List<BranchSalesViewModel> totalSalesByCashier = [];
  List<BranchSalesViewModel> totalSalesByComputer = [];
  List<BranchSalesViewModel> totalSalesByHours = [];
  List<BranchSalesViewModel> totalSalesByPayTypes = [];
  List<PieChartModel> pieData = [];
  List<BarChartGroupData> barChartData = [];
  List<BarChartGroupData> barChartData1 = [];
  List<BarChartGroupData> barChartDataCashier = [];
  List<BarChartGroupData> barChartDataComputer = [];
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollController1 = ScrollController();
  final ScrollController _scrollController2 = ScrollController();
  final ScrollController _scrollController3 = ScrollController();

  double totalPricesCashierCount = 0.0;
  double totalPricesComputerCount = 0.0;
  double totalPricesHoursCount = 0.0;
  double totalPricesPayTypesCount = 0.0;
  double maxYByComputer = 0.0;
  double maxYByCashier = 0.0;
  late AppLocalizations _locale;
  final storage = const FlutterSecureStorage();
  Timer? _timer;
  bool isLoading = true;
  bool isLoading1 = true;
  bool isLoading2 = true;
  bool isLoading3 = true;

  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context)!;
    cashierSearchCriteria.chartType = _locale.lineChart;
    desktopSearchCriteria.chartType = _locale.lineChart;
    payTypesSearchCriteria.chartType = _locale.pieChart;
    hoursSearchCriteria.chartType = _locale.barChart;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    print("asdasdasdasda");

    _tooltip1 = TooltipBehavior(enable: true);
    if (now.day == 1) {
      // If today is the first day of the month, set formattedFromDate to the first day of the previous month
      DateTime firstDayOfPreviousMonth = DateTime(now.year, now.month - 1, 1);
      formattedFromDate =
          DateFormat('dd/MM/yyyy').format(firstDayOfPreviousMonth);
    } else {
      // Otherwise, format the first day of the current month
      formattedFromDate =
          DateFormat('dd/MM/yyyy').format(DateTime(now.year, now.month, 1));
    }
    // formattedFromDate =
    //     DateFormat('dd/MM/yyyy').format(DateTime(now.year, now.month, 1));
    formattedToDate = DateFormat('dd/MM/yyyy').format(now);

    salesCostBasedBranchReportCrit = SearchCriteria(
        branch: "all",
        shiftStatus: "all",
        transType: "all",
        cashier: "all",
        fromDate: formattedFromDate,
        toDate: formattedToDate);
    formattedFromDate =
        DateFormat('dd/MM/yyyy').format(DateTime(now.year, now.month, 1));
    formattedToDate = DateFormat('dd/MM/yyyy').format(now);
    cashierSearchCriteria = SearchCriteria(
        branch: "all",
        shiftStatus: "all",
        transType: "all",
        cashier: "all",
        fromDate: formattedFromDate,
        toDate: formattedToDate);
    payTypesSearchCriteria = SearchCriteria(
        branch: "all",
        shiftStatus: "all",
        transType: "all",
        cashier: "all",
        fromDate: formattedFromDate,
        toDate: formattedToDate);
    hoursSearchCriteria = SearchCriteria(
        branch: "all",
        shiftStatus: "all",
        transType: "all",
        cashier: "all",
        fromDate: formattedFromDate,
        toDate: formattedToDate);
    desktopSearchCriteria = SearchCriteria(
        branch: "all",
        shiftStatus: "all",
        transType: "all",
        cashier: "all",
        fromDate: formattedFromDate,
        toDate: formattedToDate);
    fetchData();
    super.initState();
  }

  fetchData() async {
    await fetchSalesByCashier();
    await fetchSalesByComputer();
    // await fetchSalesByPayTypes();
    await fetchsalesCostBasedBranchReportList();
    await fetchSalesByHours();
    setState(() {});
  }

  SearchCriteria salesCostBasedBranchReportCrit = SearchCriteria(
      branch: "all",
      shiftStatus: "all",
      cashier: "",
      transType: "",
      fromDate: "",
      toDate: "");
  List<ChartData> data1 = [];
  late TooltipBehavior _tooltip1;
  List<TotalProfitReportModel> salesCostBasedBranchReportList = [];
  double totalsalesCostBasedBranchReportProfit = 0.0;
  double totalsalesCostBasedBranchReport = 0.0;
  fetchsalesCostBasedBranchReportList() async {
    salesCostBasedBranchReportList.clear();
    totalsalesCostBasedBranchReportProfit = 0.0;
    totalsalesCostBasedBranchReport = 0.0;
    data1.clear();
    isLoading2 = true;
    await TotalSalesController()
        .getTotalProfitsByBranchReportList(salesCostBasedBranchReportCrit)
        .then((value) {
      isLoading2 = false;
      for (var i = 0; i < value.length; i++) {
        salesCostBasedBranchReportList.add(value[i]);

        totalsalesCostBasedBranchReportProfit += value[i].totalProfit;
        totalsalesCostBasedBranchReport += value[i].totalSales;
        data1.add(ChartData(
            salesCostBasedBranchReportList[i].name,
            "${salesCostBasedBranchReportList[i].percentage}",
            (salesCostBasedBranchReportList[i].percentage),
            (salesCostBasedBranchReportList[i].totalProfit),
            (salesCostBasedBranchReportList[i].totalSales)));
      }
      if (data1.isNotEmpty) {
        data1.sort((a, b) => b.y.compareTo(a.y));
      }

      print(
          "salesCostBasedBranchReportList: ${salesCostBasedBranchReportList.length}");
      setState(() {});
    });
  }

  startTimer() {
    const duration = Duration(minutes: 5);
    _timer = Timer.periodic(duration, (Timer t) async {
      String? token = await storage.read(key: "jwt");
      if (token != null) {
        fetchData();
      } else {
        _timer!.cancel();
      }
    });
  }

  double maxYHours = 0.0;

  fetchSalesByHours() async {
    totalSalesByHours.clear();
    totalPricesHoursCount = 0.0;
    barChartData.clear();
    await TotalSalesController()
        .getTotalSalesByHours(hoursSearchCriteria)
        .then((value) {
      isLoading3 = false;
      for (var i = 0; i < value.length; i++) {
        totalSalesByHours.add(BranchSalesViewModel.fromDBModel(value[i]));
        totalPricesHoursCount +=
            double.parse(totalSalesByHours[i].displayTotalSales);
        if (double.parse(totalSalesByHours[i].displayTotalSales) > maxYHours) {
          maxYHours = double.parse(totalSalesByHours[i].displayTotalSales);
        }
        barChartData.add(BarChartGroupData(
            x: int.parse(totalSalesByHours[i].displayGroupName),
            barRods: [
              BarChartRodData(
                toY: double.parse(totalSalesByHours[i].displayTotalSales),
                borderRadius: BorderRadius.all(Radius.zero),
              )
            ]));
      }
      setState(() {});
    });
  }

  List<String> xLabelsCashier = [];

  fetchSalesByCashier() async {
    totalSalesByCashier.clear();
    totalPricesCashierCount = 0.0;
    maxYByCashier = 0.0;
    barChartDataCashier.clear();
    await TotalSalesController()
        .getTotalSalesByCashier(cashierSearchCriteria)
        .then((value) {
      isLoading = false;
      for (var i = 0; i < value.length; i++) {
        totalSalesByCashier.add(BranchSalesViewModel.fromDBModel(value[i]));
        totalPricesCashierCount +=
            double.parse(totalSalesByCashier[i].displayTotalSales);
        if (double.parse(totalSalesByCashier[i].displayTotalSales) >
            maxYByCashier) {
          maxYByCashier =
              double.parse(totalSalesByCashier[i].displayTotalSales);
        }
        xLabelsCashier =
            totalSalesByCashier.map((e) => e.displayGroupName).toList();

        barChartDataCashier =
            List.generate(totalSalesByCashier.length, (index) {
          return BarChartGroupData(
            x: index, // Use index as x-value
            barRods: [
              BarChartRodData(
                toY: double.parse(totalSalesByCashier[index].displayTotalSales),
                borderRadius: BorderRadius.all(Radius.zero),
              ),
            ],
          );
        });
      }
      setState(() {});
    });
  }

  List<String> xLabels = [];
  double maxY = 0.0;

  fetchSalesByPayTypes() async {
    pieData.clear();
    totalPricesPayTypesCount = 0.0;
    totalSalesByPayTypes.clear();
    barChartData1.clear();
    await TotalSalesController()
        .getTotalSalesByPaymentTypes(payTypesSearchCriteria)
        .then((value) {
      isLoading2 = false;
      for (var i = 0; i < value.length; i++) {
        totalSalesByPayTypes.add(BranchSalesViewModel.fromDBModel(value[i]));
        totalPricesPayTypesCount +=
            double.parse(totalSalesByPayTypes[i].displayTotalSales);
        if (double.parse(totalSalesByPayTypes[i].displayTotalSales) > maxY) {
          maxY = double.parse(totalSalesByPayTypes[i].displayTotalSales);
        }
        pieData.add(PieChartModel(
          title: totalSalesByPayTypes[i].displayGroupName,
          value: formatDoubleToTwoDecimalPlaces(
              double.parse(totalSalesByPayTypes[i].displayTotalSales)),
          color: getNextColor(),
        ));
        xLabels = totalSalesByPayTypes.map((e) => e.displayGroupName).toList();

        barChartData1 = List.generate(totalSalesByPayTypes.length, (index) {
          return BarChartGroupData(
            x: index, // Use index as x-value
            barRods: [
              BarChartRodData(
                toY:
                    double.parse(totalSalesByPayTypes[index].displayTotalSales),
                borderRadius: BorderRadius.all(Radius.zero),
              ),
            ],
          );
        });
      }
      setState(() {});
    });
  }

  List<String> xLabelsComputer = [];
  fetchSalesByComputer() async {
    totalSalesByComputer.clear();
    totalPricesComputerCount = 0.0;

    maxYByComputer = 0.0;
    await TotalSalesController()
        .getTotalSalesByComputer(desktopSearchCriteria)
        .then((value) {
      isLoading1 = false;
      for (var i = 0; i < value.length; i++) {
        totalSalesByComputer.add(BranchSalesViewModel.fromDBModel(value[i]));
        totalPricesComputerCount +=
            double.parse(totalSalesByComputer[i].displayTotalSales);
        if (double.parse(totalSalesByComputer[i].displayTotalSales) >
            maxYByComputer) {
          maxYByComputer =
              double.parse(totalSalesByComputer[i].displayTotalSales);
        }
        xLabelsComputer =
            totalSalesByComputer.map((e) => e.displayGroupName).toList();

        barChartDataComputer =
            List.generate(totalSalesByComputer.length, (index) {
          return BarChartGroupData(
            x: index, // Use index as x-value
            barRods: [
              BarChartRodData(
                toY:
                    double.parse(totalSalesByComputer[index].displayTotalSales),
                borderRadius: BorderRadius.all(Radius.zero),
              ),
            ],
          );
        });
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    isDesktop = Responsive.isDesktop(context);
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  isDesktop ? desktopView() : mobileView(),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget desktopView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    cashierSearchCriteria.chartType == _locale.barChart
                        ? salesByPaymentTypesBarChart(
                            _locale.salesByCashier, barChartDataCashier)
                        : dailySalesChart(totalSalesByCashier,
                            _locale.salesByCashier, maxYByCashier),
                    desktopSearchCriteria.chartType == _locale.barChart
                        ? salesByPaymentTypesBarChart(
                            _locale.salesByComputer, barChartDataComputer)
                        : dailySalesChart(totalSalesByComputer,
                            _locale.salesByComputer, maxYByComputer),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    // payTypesSearchCriteria.chartType == _locale.pieChart
                    //     ? pieChart(pieData, _locale.salesByPaymentTypes)
                    //     : salesByPaymentTypesBarChart(
                    //         _locale.salesByPaymentTypes, barChartData1),
                    salesCostBasedBranchChart(
                        data1, _locale.salesCostBasedBranch),

                    hoursSearchCriteria.chartType == _locale.lineChart
                        ? dailySalesChart(
                            totalSalesByHours, _locale.salesByHours, maxYHours)
                        : hourTotalBarChart(barChartData, _locale.salesByHours),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget pieChart(List<PieChartModel> pieData, String title) {
    return SizedBox(
      height: height * 0.47,
      child: Card(
        elevation: 2,
        color: Colors.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        SelectableText(
                          title,
                          style: TextStyle(fontSize: height * 0.015),
                        ),
                        title == _locale.salesByCashier
                            ? Text(
                                " (${Converters.formatNumberRounded(double.parse(Converters.formatNumberDigits(totalPricesCashierCount)))})",
                                style: TextStyle(fontSize: isDesktop ? 13 : 16))
                            : title == _locale.salesByComputer
                                ? Text(
                                    " (${Converters.formatNumberRounded(double.parse(Converters.formatNumberDigits(totalPricesComputerCount)))})",
                                    style: TextStyle(
                                        fontSize: isDesktop ? 13 : 16))
                                : title == _locale.salesByPaymentTypes
                                    ? Text(
                                        " (${Converters.formatNumberRounded(double.parse(Converters.formatNumberDigits(totalPricesPayTypesCount)))})",
                                        style: TextStyle(
                                            fontSize: isDesktop ? 13 : 16))
                                    : SizedBox.shrink()
                      ],
                    ),
                    // title == "Sales By Cashier"
                    //     ? Text(
                    //         "Total: ${Converters.formatNumber(totalPricesCashierCount)}")
                    //     : title == "Sales By Computer"
                    //         ? Text(
                    //             "Total: ${Converters.formatNumber(totalPricesComputerCount)}")
                    //         : title == "Sales By Payment Types"
                    //             ? Text(
                    //                 "Total: ${Converters.formatNumber(totalPricesPayTypesCount)}")
                    //             : SizedBox.shrink()
                  ],
                ),
                // if (Responsive.isDesktop(context))
                //   if (title == _locale.salesByCashier)
                //     Text(
                //         "(${cashierSearchCriteria.fromDate} - ${cashierSearchCriteria.toDate})"),
                // if (Responsive.isDesktop(context))
                //   if (title == _locale.salesByComputer)
                //     Text(
                //         "(${desktopSearchCriteria.fromDate} - ${desktopSearchCriteria.toDate})"),
                // if (Responsive.isDesktop(context))
                //   if (title == _locale.salesByHours)
                //     Text(
                //         "(${hoursSearchCriteria.fromDate} - ${hoursSearchCriteria.toDate})"),
                // if (Responsive.isDesktop(context))
                //   if (title == _locale.salesByPaymentTypes)
                //     Text(
                //         "(${payTypesSearchCriteria.fromDate} - ${payTypesSearchCriteria.toDate})"),
                blueButton1(
                  onPressed: () async {
                    List<CashierModel> cashiers = [];
                    if (title == _locale.cashierLogs) {
                      cashiers = await TotalSalesController().getAllCashiers();
                    }
                    await TotalSalesController().getAllBranches().then((value) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return FilterDialog(
                              cashiers: cashiers,
                              branches: value,
                              filter: title == _locale.salesByCashier
                                  ? cashierSearchCriteria
                                  : title == _locale.salesByComputer
                                      ? desktopSearchCriteria
                                      : title == _locale.salesByPaymentTypes
                                          ? payTypesSearchCriteria
                                          : hoursSearchCriteria,
                              hint: title);
                        },
                      ).then((value) {
                        if (value != false) {
                          if (title == _locale.salesByCashier) {
                            cashierSearchCriteria = value;
                            setState(() {
                              isLoading = true;
                            });
                            fetchSalesByCashier();
                          } else if (title == _locale.salesByComputer) {
                            desktopSearchCriteria = value;
                            fetchSalesByComputer();
                          } else if (title == _locale.salesByPaymentTypes) {
                            payTypesSearchCriteria = value;
                            isLoading2 = true;
                            setState(() {});
                            fetchSalesByPayTypes();
                          }
                        }
                      });
                    });
                  },
                  textColor: const Color.fromARGB(255, 255, 255, 255),
                  icon: Icon(
                    Icons.filter_list_sharp,
                    color: Colors.white,
                    size: isDesktop ? height * 0.035 : height * 0.03,
                  ),
                )
              ],
            ),
            // if (!Responsive.isDesktop(context))
            if (title == _locale.salesByCashier)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                      "(${cashierSearchCriteria.fromDate} - ${cashierSearchCriteria.toDate})",
                      style:
                          TextStyle(fontSize: isDesktop ? 14 : height * 0.013)),
                ],
              ),
            // if (!Responsive.isDesktop(context))
            if (title == _locale.salesByComputer)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                      "(${desktopSearchCriteria.fromDate} - ${desktopSearchCriteria.toDate})",
                      style:
                          TextStyle(fontSize: isDesktop ? 14 : height * 0.013)),
                ],
              ),
            // if (!Responsive.isDesktop(context))
            if (title == _locale.salesByHours)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                      "(${hoursSearchCriteria.fromDate} - ${hoursSearchCriteria.toDate})",
                      style:
                          TextStyle(fontSize: isDesktop ? 14 : height * 0.013)),
                ],
              ),
            // if (!Responsive.isDesktop(context))
            if (title == _locale.salesByPaymentTypes)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                      "(${payTypesSearchCriteria.fromDate} - ${payTypesSearchCriteria.toDate})",
                      style:
                          TextStyle(fontSize: isDesktop ? 10 : height * 0.013)),
                ],
              ),
            (title == _locale.salesByPaymentTypes && isLoading2)
                ? SizedBox(
                    height: height * 0.35,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Center(
                    child: SizedBox(
                      height: height * 0.37,
                      child: PieDashboardChart(
                        dataList: pieData,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget hourTotalBarChart(List<BarChartGroupData> barChartData, String title) {
    return SizedBox(
      height: height * 0.47,
      child: Card(
        elevation: 2,
        color: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.zero, // Remove corner radius for a flat edge
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        SelectableText(
                          title,
                          style: TextStyle(fontSize: height * 0.015),
                        ),
                        title == _locale.salesByCashier
                            ? Text(
                                " (${Converters.formatNumberRounded(double.parse(Converters.formatNumberDigits(totalPricesCashierCount)))})",
                                style: TextStyle(fontSize: isDesktop ? 15 : 18))
                            : title == _locale.salesByComputer
                                ? Text(
                                    " (${Converters.formatNumberRounded(double.parse(Converters.formatNumberDigits(totalPricesComputerCount)))})",
                                    style: TextStyle(
                                        fontSize: isDesktop ? 15 : 18))
                                : title == _locale.salesByPaymentTypes
                                    ? Text(
                                        " (${Converters.formatNumberRounded(double.parse(Converters.formatNumberDigits(totalPricesPayTypesCount)))})",
                                        style: TextStyle(
                                            fontSize: isDesktop ? 15 : 18))
                                    : title == _locale.salesByHours
                                        ? Text(
                                            " (${Converters.formatNumberRounded(double.parse(Converters.formatNumberDigits(totalPricesHoursCount)))})",
                                            style: TextStyle(
                                                fontSize: isDesktop ? 15 : 18))
                                        : SizedBox.shrink(),
                      ],
                    ),
                    // title == "Sales By Cashier"
                    //     ? Text(
                    //         "Total: ${Converters.formatNumber(totalPricesCashierCount)}")
                    //     : title == "Sales By Computer"
                    //         ? Text(
                    //             "Total: ${Converters.formatNumber(totalPricesComputerCount)}")
                    //         : title == "Sales By Payment Types"
                    //             ? Text(
                    //                 "Total: ${Converters.formatNumber(totalPricesPayTypesCount)}")
                    //             : SizedBox.shrink()
                  ],
                ),
                // if (Responsive.isDesktop(context))
                //   if (title == _locale.salesByCashier)
                //     Text(
                //         "(${cashierSearchCriteria.fromDate} - ${cashierSearchCriteria.toDate})"),
                // if (Responsive.isDesktop(context))
                //   if (title == _locale.salesByComputer)
                //     Text(
                //         "(${desktopSearchCriteria.fromDate} - ${desktopSearchCriteria.toDate})"),
                // if (Responsive.isDesktop(context))
                //   if (title == _locale.salesByHours)
                //     Text(
                //         "(${hoursSearchCriteria.fromDate} - ${hoursSearchCriteria.toDate})"),
                // if (Responsive.isDesktop(context))
                //   if (title == _locale.salesByPaymentTypes)
                //     Text(
                //         "(${payTypesSearchCriteria.fromDate} - ${payTypesSearchCriteria.toDate})"),
                blueButton1(
                  onPressed: () async {
                    List<CashierModel> cashiers = [];
                    if (title == _locale.cashierLogs) {
                      cashiers = await TotalSalesController().getAllCashiers();
                    }
                    await TotalSalesController().getAllBranches().then((value) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return FilterDialog(
                              cashiers: cashiers,
                              branches: value,
                              filter: title == _locale.salesByCashier
                                  ? cashierSearchCriteria
                                  : title == _locale.salesByComputer
                                      ? desktopSearchCriteria
                                      : title == _locale.salesByPaymentTypes
                                          ? payTypesSearchCriteria
                                          : hoursSearchCriteria,
                              hint: title);
                        },
                      ).then((value) {
                        if (value != false) {
                          if (title == _locale.salesByCashier) {
                            cashierSearchCriteria = value;
                            fetchSalesByCashier();
                          } else if (title == _locale.salesByComputer) {
                            desktopSearchCriteria = value;
                            fetchSalesByComputer();
                          } else if (title == _locale.salesByPaymentTypes) {
                            payTypesSearchCriteria = value;
                            isLoading2 = true;
                            setState(() {});
                            fetchSalesByPayTypes();
                          } else if (title == _locale.salesByHours) {
                            hoursSearchCriteria = value;
                            isLoading3 = true;
                            setState(() {});
                            fetchSalesByHours();
                          }
                        }
                      });
                    });
                  },
                  textColor: const Color.fromARGB(255, 255, 255, 255),
                  icon: Icon(
                    Icons.filter_list_sharp,
                    color: Colors.white,
                    size: isDesktop ? height * 0.035 : height * 0.03,
                  ),
                )
              ],
            ),
            // if (!Responsive.isDesktop(context))
            if (title == _locale.salesByCashier)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                      "(${cashierSearchCriteria.fromDate} - ${cashierSearchCriteria.toDate})",
                      style:
                          TextStyle(fontSize: isDesktop ? 14 : height * 0.013)),
                ],
              ),
            // if (!Responsive.isDesktop(context))
            if (title == _locale.salesByComputer)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                      "(${desktopSearchCriteria.fromDate} - ${desktopSearchCriteria.toDate})",
                      style:
                          TextStyle(fontSize: isDesktop ? 14 : height * 0.013)),
                ],
              ),
            // if (!Responsive.isDesktop(context))
            if (title == _locale.salesByHours)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                      "(${hoursSearchCriteria.fromDate} - ${hoursSearchCriteria.toDate})",
                      style:
                          TextStyle(fontSize: isDesktop ? 14 : height * 0.013)),
                ],
              ),
            // if (!Responsive.isDesktop(context))
            if (title == _locale.salesByPaymentTypes)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                      "(${payTypesSearchCriteria.fromDate} - ${payTypesSearchCriteria.toDate})",
                      style:
                          TextStyle(fontSize: isDesktop ? 14 : height * 0.013)),
                ],
              ),
            (title == _locale.salesByPaymentTypes && isLoading2)
                ? SizedBox(
                    height: height * 0.35,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : (title == _locale.salesByHours && isLoading3)
                    ? SizedBox(
                        height: height * 0.35,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : SizedBox(
                        height: height * 0.35,
                        child: BarChart(
                          BarChartData(
                              maxY: maxYHours * 1.4,
                              barTouchData: BarTouchData(
                                touchTooltipData: BarTouchTooltipData(
                                  getTooltipItem:
                                      (group, groupIndex, rod, rodIndex) {
                                    return BarTooltipItem(
                                      Converters.formatNumber(rod.toY),
                                      const TextStyle(color: Colors.white),
                                    );
                                  },
                                ),
                              ),
                              titlesData: FlTitlesData(
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                  getTitlesWidget: (value, meta) =>
                                      leftTitleWidgets(value),
                                  showTitles: true,
                                  reservedSize: 35,
                                )),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              barGroups: barChartData),
                        ),
                      ),
          ],
        ),
      ),
    );
  }

  Widget dailySalesChart(
      List<BranchSalesViewModel> totalSales, String title, double maxY) {
    return SizedBox(
      height: height * 0.47,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SelectableText(
                    title,
                    style: TextStyle(fontSize: height * 0.015),
                  ),
                  title == _locale.salesByCashier
                      ? Text(
                          " (${Converters.formatNumberRounded(double.parse(Converters.formatNumberDigits(totalPricesCashierCount)))})",
                          style: TextStyle(fontSize: isDesktop ? 13 : 16))
                      : title == _locale.salesByComputer
                          ? Text(
                              " (${Converters.formatNumberRounded(double.parse(Converters.formatNumberDigits(totalPricesComputerCount)))})",
                              style: TextStyle(fontSize: isDesktop ? 15 : 18))
                          : title == _locale.salesByPaymentTypes
                              ? Text(
                                  " (${Converters.formatNumberRounded(double.parse(Converters.formatNumberDigits(totalPricesPayTypesCount)))})",
                                  style:
                                      TextStyle(fontSize: isDesktop ? 15 : 18))
                              : title == _locale.salesByHours
                                  ? Text(
                                      " (${Converters.formatNumberRounded(double.parse(Converters.formatNumberDigits(totalPricesHoursCount)))})",
                                      style: TextStyle(
                                          fontSize: isDesktop ? 15 : 18))
                                  : SizedBox.shrink()
                ],
              ),
              if (Responsive.isDesktop(context))
                if (title == _locale.salesByCashier)
                  Text(
                      "(${cashierSearchCriteria.fromDate} - ${cashierSearchCriteria.toDate})"),
              if (Responsive.isDesktop(context))
                if (title == _locale.salesByComputer)
                  Text(
                      "(${desktopSearchCriteria.fromDate} - ${desktopSearchCriteria.toDate})"),
              if (Responsive.isDesktop(context))
                if (title == _locale.salesByHours)
                  Text(
                      "(${hoursSearchCriteria.fromDate} - ${hoursSearchCriteria.toDate})"),
              if (Responsive.isDesktop(context))
                if (title == _locale.salesByPaymentTypes)
                  Text(
                      "(${payTypesSearchCriteria.fromDate} - ${payTypesSearchCriteria.toDate})"),
              blueButton1(
                onPressed: () async {
                  List<CashierModel> cashiers = [];
                  if (title == _locale.cashierLogs) {
                    cashiers = await TotalSalesController().getAllCashiers();
                  }
                  await TotalSalesController().getAllBranches().then((value) {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return FilterDialog(
                            cashiers: cashiers,
                            branches: value,
                            filter: title == _locale.salesByCashier
                                ? cashierSearchCriteria
                                : title == _locale.salesByComputer
                                    ? desktopSearchCriteria
                                    : title == _locale.salesByPaymentTypes
                                        ? payTypesSearchCriteria
                                        : hoursSearchCriteria,
                            hint: title);
                      },
                    ).then((value) {
                      if (value != false) {
                        if (title == _locale.salesByCashier) {
                          cashierSearchCriteria = value;
                          print(
                              "cashierSearchCriteria.chartType: ${cashierSearchCriteria.chartType}");
                          setState(() {
                            isLoading = true;
                          });
                          fetchSalesByCashier();
                        } else if (title == _locale.salesByComputer) {
                          desktopSearchCriteria = value;
                          setState(() {
                            isLoading1 = true;
                          });
                          fetchSalesByComputer();
                        } else if (title == _locale.salesByPaymentTypes) {
                          payTypesSearchCriteria = value;
                          isLoading2 = true;
                          setState(() {});
                          fetchSalesByPayTypes();
                        } else if (title == _locale.salesByHours) {
                          hoursSearchCriteria = value;
                          setState(() {
                            isLoading3 = true;
                          });
                          fetchSalesByHours();
                        }
                      }
                    });
                  });
                },
                textColor: const Color.fromARGB(255, 255, 255, 255),
                icon: Icon(
                  Icons.filter_list_sharp,
                  color: Colors.white,
                  size: isDesktop ? height * 0.035 : height * 0.03,
                ),
              )
            ],
          ),
          if (!Responsive.isDesktop(context))
            if (title == _locale.salesByCashier)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                      "(${cashierSearchCriteria.fromDate} - ${cashierSearchCriteria.toDate})",
                      style: TextStyle(fontSize: height * 0.013)),
                ],
              ),
          if (!Responsive.isDesktop(context))
            if (title == _locale.salesByComputer)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                      "(${desktopSearchCriteria.fromDate} - ${desktopSearchCriteria.toDate})",
                      style: TextStyle(fontSize: height * 0.013)),
                ],
              ),
          if (!Responsive.isDesktop(context))
            if (title == _locale.salesByHours)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                      "(${hoursSearchCriteria.fromDate} - ${hoursSearchCriteria.toDate})",
                      style: TextStyle(fontSize: height * 0.013)),
                ],
              ),
          if (!Responsive.isDesktop(context))
            if (title == _locale.salesByPaymentTypes)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                      "(${payTypesSearchCriteria.fromDate} - ${payTypesSearchCriteria.toDate})",
                      style: TextStyle(fontSize: height * 0.013)),
                ],
              ),
          (title == _locale.salesByCashier && isLoading)
              ? SizedBox(
                  height: height * 0.35,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : (title == _locale.salesByComputer && isLoading1)
                  ? SizedBox(
                      height: height * 0.35,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : (title == _locale.salesByPaymentTypes && isLoading2)
                      ? SizedBox(
                          height: height * 0.35,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : (title == _locale.salesByHours && isLoading3)
                          ? SizedBox(
                              height: height * 0.35,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : Scrollbar(
                              controller: title == _locale.salesByCashier
                                  ? _scrollController
                                  : title == _locale.salesByHours
                                      ? _scrollController3
                                      : _scrollController1,
                              thumbVisibility: true,
                              thickness: 8,
                              trackVisibility: true,
                              radius: const Radius.circular(4),
                              child: SingleChildScrollView(
                                reverse:
                                    _locale.localeName == "ar" ? true : false,
                                controller: title == _locale.salesByCashier
                                    ? _scrollController
                                    : title == _locale.salesByHours
                                        ? _scrollController3
                                        : _scrollController1,
                                scrollDirection: Axis.horizontal,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    height: height * 0.35,
                                    width: Responsive.isDesktop(context)
                                        ? totalSales.length > 20
                                            ? width * (totalSales.length / 16)
                                            : title == _locale.salesByHours
                                                ? width * 0.45
                                                : width * 0.82
                                        : totalSales.length > 5
                                            ? width * (totalSales.length / 8)
                                            : width * 0.82,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 50.0, vertical: 40.0),
                                      child: LineChart(
                                        LineChartData(
                                          maxY: maxY * 1.3,
                                          lineTouchData: LineTouchData(
                                            touchTooltipData:
                                                LineTouchTooltipData(
                                              // getTooltipColor: defaultLineTooltipColor,
                                              getTooltipItems:
                                                  (List<LineBarSpot>
                                                      touchedSpots) {
                                                return touchedSpots.map((spot) {
                                                  return LineTooltipItem(
                                                    "${totalSales[spot.spotIndex].displayGroupName} / ${totalSales[spot.spotIndex].displayBranchName} / ${Converters.formatNumber(spot.y)}",
                                                    const TextStyle(
                                                        color: Colors.white),
                                                  );
                                                }).toList();
                                              },
                                            ),
                                          ),
                                          titlesData: FlTitlesData(
                                            topTitles: const AxisTitles(
                                              sideTitles:
                                                  SideTitles(showTitles: false),
                                            ),
                                            rightTitles: const AxisTitles(
                                                sideTitles: SideTitles(
                                                    showTitles: false)),
                                            leftTitles: AxisTitles(
                                                sideTitles: SideTitles(
                                              getTitlesWidget: (value, meta) =>
                                                  leftTitleWidgets(value),
                                              showTitles: true,
                                              reservedSize: 35,
                                            )),
                                            bottomTitles: AxisTitles(
                                              sideTitles: SideTitles(
                                                showTitles: true,
                                                interval: 1,
                                                getTitlesWidget:
                                                    (value, meta) =>
                                                        groupNameTitle(
                                                            value.toInt(),
                                                            totalSales,
                                                            title),
                                              ),
                                            ),
                                          ),
                                          borderData: FlBorderData(
                                              border: Border.all(
                                                  color: const Color.fromARGB(
                                                      255, 125, 125, 125))),
                                          lineBarsData: [
                                            LineChartBarData(
                                              belowBarData: BarAreaData(
                                                  show: true,
                                                  color: Colors.blue
                                                      .withOpacity(0.5)),
                                              isCurved: true,
                                              preventCurveOverShooting: true,
                                              isStrokeJoinRound: true,
                                              spots: totalSales
                                                  .asMap()
                                                  .entries
                                                  .map((entry) {
                                                int index = entry.key;
                                                double totalSales =
                                                    double.parse(entry.value
                                                        .displayTotalSales);
                                                print(
                                                    "totalSales: ${totalSales}");

                                                return FlSpot(index.toDouble(),
                                                    totalSales);
                                              }).toList(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
        ],
      ),
    );
  }

  Widget leftTitleWidgets(double value) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );

    return Text(
      Converters.formatTitleNumber(value),
      style: style,
      textAlign: TextAlign.left,
    );
  }

  Widget groupNameTitle(
      int value, List<BranchSalesViewModel> totalSales, String title) {
    if (value >= 0 && value < totalSales.length) {
      return Transform.rotate(
        angle: -30 * 3.14159 / 180, // 90 degrees in radians
        child: SizedBox(
          width: 200,
          child: Center(
            child: Text(
              (title == _locale.salesByComputer ||
                      title == _locale.salesByCashier)
                  ? "${totalSales[value].displayGroupName} / ${totalSales[value].displayBranchName}"
                  : totalSales[value].displayGroupName,
              style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 10,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    } else {
      return const Text('');
    }
  }

  Widget mobileView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      cashierSearchCriteria.chartType == _locale.barChart
                          ? salesByPaymentTypesBarChart(
                              _locale.salesByCashier, barChartDataCashier)
                          : dailySalesChart(totalSalesByCashier,
                              _locale.salesByCashier, maxYByCashier),
                      desktopSearchCriteria.chartType == _locale.barChart
                          ? salesByPaymentTypesBarChart(
                              _locale.salesByComputer, barChartDataComputer)
                          : dailySalesChart(totalSalesByComputer,
                              _locale.salesByComputer, maxYByComputer),

                      // payTypesSearchCriteria.chartType == _locale.pieChart
                      //     ? pieChart(pieData, _locale.salesByPaymentTypes)
                      //     : salesByPaymentTypesBarChart(
                      //         _locale.salesByPaymentTypes, barChartData1),
                      salesCostBasedBranchChart(
                          data1, _locale.salesCostBasedBranch),
                      // cashierTotalSales(),
                      hoursSearchCriteria.chartType == _locale.lineChart
                          ? dailySalesChart(totalSalesByHours,
                              _locale.salesByHours, maxYHours)
                          : hourTotalBarChart(
                              barChartData, _locale.salesByHours),
                    ],
                  ))
            ],
          )
          // XCard(),
          // XCard(),
          // XCard(),
          // XCard(),
          // XCard(),

          // cashierTotalSales(),
        ],
      ),
    );
  }

  Widget dailySalesTitle(double value, TitleMeta meta) {
    var style = TextStyle(
      fontSize: isDesktop ? 10 : 7,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic,
    );

    // Get the current month
    final currentMonth = DateTime.now().month;

    // Format the label as "day/month"
    final day = (value.toInt() + 1).toString();
    final label = day;

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(label, style: style),
    );
  }

  double formatDoubleToTwoDecimalPlaces(double number) {
    return double.parse(number.toStringAsFixed(2));
  }

  Color getNextColor() {
    final color = colorListDashboard[colorIndex];
    colorIndex = (colorIndex + 1) % colorListDashboard.length;
    return color;
  }

  Widget salesByPaymentTypesBarChart(
      String title, List<BarChartGroupData> enteredBarChartData) {
    return SizedBox(
      height: height * 0.47,
      child: Card(
        elevation: 2,
        color: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.zero, // Remove corner radius for a flat edge
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        SelectableText(
                          title,
                          style: TextStyle(fontSize: height * 0.015),
                        ),
                        title == _locale.salesByCashier
                            ? Text(
                                " (${Converters.formatNumberRounded(double.parse(Converters.formatNumberDigits(totalPricesCashierCount)))})",
                                style: TextStyle(fontSize: isDesktop ? 15 : 18))
                            : title == _locale.salesByComputer
                                ? Text(
                                    " (${Converters.formatNumberRounded(double.parse(Converters.formatNumberDigits(totalPricesComputerCount)))})",
                                    style: TextStyle(
                                        fontSize: isDesktop ? 15 : 18))
                                : title == _locale.salesByPaymentTypes
                                    ? Text(
                                        " (${Converters.formatNumberRounded(double.parse(Converters.formatNumberDigits(totalPricesPayTypesCount)))})",
                                        style: TextStyle(
                                            fontSize: isDesktop ? 15 : 18))
                                    : title == _locale.salesByHours
                                        ? Text(
                                            " (${Converters.formatNumberRounded(double.parse(Converters.formatNumberDigits(totalPricesHoursCount)))})",
                                            style: TextStyle(
                                                fontSize: isDesktop ? 15 : 18))
                                        : SizedBox.shrink(),
                      ],
                    ),
                  ],
                ),
                // if (Responsive.isDesktop(context))
                //   if (title == locale.salesByCashier)
                //     Text(
                //         "(${cashierSearchCriteria.fromDate} - ${cashierSearchCriteria.toDate})"),
                // if (Responsive.isDesktop(context))
                //   if (title == locale.salesByComputer)
                //     Text(
                //         "(${desktopSearchCriteria.fromDate} - ${desktopSearchCriteria.toDate})"),
                // if (Responsive.isDesktop(context))
                //   if (title == locale.salesByHours)
                //     Text(
                //         "(${hoursSearchCriteria.fromDate} - ${hoursSearchCriteria.toDate})"),
                // if (Responsive.isDesktop(context))
                //   if (title == locale.salesByPaymentTypes)
                //     Text(
                //         "(${payTypesSearchCriteria.fromDate} - ${payTypesSearchCriteria.toDate})"),
                blueButton1(
                  onPressed: () async {
                    List<CashierModel> cashiers = [];
                    if (title == _locale.cashierLogs) {
                      cashiers = await TotalSalesController().getAllCashiers();
                    }
                    await TotalSalesController().getAllBranches().then((value) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return FilterDialog(
                              cashiers: cashiers,
                              branches: value,
                              filter: title == _locale.salesByPaymentTypes
                                  ? payTypesSearchCriteria
                                  : title == _locale.salesByCashier
                                      ? cashierSearchCriteria
                                      : desktopSearchCriteria,
                              hint: title);
                        },
                      ).then((value) {
                        if (value != false) {
                          if (title == _locale.salesByPaymentTypes) {
                            payTypesSearchCriteria = value;
                            isLoading2 = true;
                            setState(() {});
                            fetchSalesByPayTypes();
                          } else if (title == _locale.salesByCashier) {
                            cashierSearchCriteria = value;
                            isLoading = true;
                            print(
                                "cashierSearchCriteria.chartType: ${cashierSearchCriteria.chartType}");
                            setState(() {});
                            fetchSalesByCashier();
                          } else if (title == _locale.salesByComputer) {
                            desktopSearchCriteria = value;
                            isLoading1 = true;
                            setState(() {});
                            fetchSalesByComputer();
                          } else if (title == _locale.salesByHours) {
                            hoursSearchCriteria = value;
                            isLoading3 = true;
                            setState(() {});
                            fetchSalesByHours();
                          }
                        }
                      });
                    });
                  },
                  textColor: const Color.fromARGB(255, 255, 255, 255),
                  icon: Icon(
                    Icons.filter_list_sharp,
                    color: Colors.white,
                    size: isDesktop ? height * 0.035 : height * 0.03,
                  ),
                )
              ],
            ),
            // if (!Responsive.isDesktop(context))

            if (title == _locale.salesByPaymentTypes)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                      "(${payTypesSearchCriteria.fromDate} - ${payTypesSearchCriteria.toDate})",
                      style:
                          TextStyle(fontSize: isDesktop ? 14 : height * 0.013)),
                ],
              ),
            (title == _locale.salesByCashier && isLoading)
                ? SizedBox(
                    height: height * 0.35,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : (title == _locale.salesByComputer && isLoading1)
                    ? SizedBox(
                        height: height * 0.35,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : (title == _locale.salesByPaymentTypes && isLoading2)
                        ? SizedBox(
                            height: height * 0.35,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : (title == _locale.salesByHours && isLoading3)
                            ? SizedBox(
                                height: height * 0.35,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : Scrollbar(
                                controller: title == _locale.salesByCashier
                                    ? _scrollController
                                    : title == _locale.salesByComputer
                                        ? _scrollController1
                                        : _scrollController2,
                                thumbVisibility: true,
                                thickness: 8,
                                trackVisibility: true,
                                radius: const Radius.circular(4),
                                child: SingleChildScrollView(
                                  reverse:
                                      _locale.localeName == "ar" ? true : false,
                                  controller: title == _locale.salesByCashier
                                      ? _scrollController
                                      : title == _locale.salesByComputer
                                          ? _scrollController1
                                          : _scrollController2,
                                  scrollDirection: Axis.horizontal,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: height * 0.35,
                                      width: Responsive.isDesktop(context)
                                          ? title == _locale.salesByComputer
                                              ? enteredBarChartData.length > 10
                                                  ? width *
                                                      (enteredBarChartData
                                                              .length /
                                                          10)
                                                  : width * 0.3
                                              : enteredBarChartData.length > 20
                                                  ? width *
                                                      (enteredBarChartData
                                                              .length /
                                                          10)
                                                  : width * 0.3
                                          : enteredBarChartData.length > 5
                                              ? width *
                                                  (enteredBarChartData.length /
                                                      2)
                                              : width * 0.95,
                                      child: BarChart(
                                        BarChartData(
                                            maxY: title ==
                                                    _locale.salesByPaymentTypes
                                                ? maxY * 1.4
                                                : title ==
                                                        _locale.salesByCashier
                                                    ? maxYByCashier * 1.4
                                                    : maxYByComputer * 1.4,
                                            barTouchData: BarTouchData(
                                              touchTooltipData:
                                                  BarTouchTooltipData(
                                                getTooltipItem: (group,
                                                    groupIndex, rod, rodIndex) {
                                                  return BarTooltipItem(
                                                    title ==
                                                            _locale
                                                                .salesByPaymentTypes
                                                        ? "${Converters.formatNumber(rod.toY)}\n${xLabels[groupIndex]}"
                                                        : title ==
                                                                _locale
                                                                    .salesByCashier
                                                            ? "${Converters.formatNumber(rod.toY)}\n${xLabelsCashier[groupIndex]}"
                                                            : title ==
                                                                    _locale
                                                                        .salesByComputer
                                                                ? "${Converters.formatNumber(rod.toY)}\n${xLabelsComputer[groupIndex]}"
                                                                : "",
                                                    const TextStyle(
                                                        color: Colors.white),
                                                  );
                                                },
                                              ),
                                            ),
                                            titlesData: FlTitlesData(
                                              rightTitles: AxisTitles(
                                                sideTitles: SideTitles(
                                                    showTitles: false),
                                              ),
                                              bottomTitles: AxisTitles(
                                                sideTitles: SideTitles(
                                                  showTitles: true,
                                                  reservedSize: 40,
                                                  getTitlesWidget:
                                                      (value, meta) {
                                                    int index = value.toInt();
                                                    if (index >= 0 &&
                                                        index <
                                                            (title ==
                                                                        _locale
                                                                            .salesByPaymentTypes
                                                                    ? xLabels
                                                                    : title ==
                                                                            _locale
                                                                                .salesByCashier
                                                                        ? xLabelsCashier
                                                                        : title ==
                                                                                _locale.salesByComputer
                                                                            ? xLabelsComputer
                                                                            : [])
                                                                .length) {
                                                      return Transform.rotate(
                                                        angle: -30 *
                                                            3.14159 /
                                                            180, // 90 degrees in radians
                                                        child: SizedBox(
                                                          width: 200,
                                                          child: Center(
                                                            child: Text(
                                                                title ==
                                                                        _locale
                                                                            .salesByPaymentTypes
                                                                    ? xLabels[
                                                                        index]
                                                                    : title ==
                                                                            _locale
                                                                                .salesByCashier
                                                                        ? xLabelsCashier[
                                                                            index]
                                                                        : title ==
                                                                                _locale
                                                                                    .salesByComputer
                                                                            ? xLabelsComputer[
                                                                                index]
                                                                            : "",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12)),
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                    return Text("");
                                                  },
                                                ),
                                              ),
                                              leftTitles: AxisTitles(
                                                  sideTitles: SideTitles(
                                                getTitlesWidget:
                                                    (value, meta) =>
                                                        leftTitleWidgets(value),
                                                showTitles: true,
                                                reservedSize: 35,
                                              )),
                                              topTitles: AxisTitles(
                                                sideTitles: SideTitles(
                                                    showTitles: false),
                                              ),
                                            ),
                                            barGroups: enteredBarChartData),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
          ],
        ),
      ),
    );
  }

  Widget salesCostBasedBranchChart(List<ChartData> data1, String title) {
    return SizedBox(
      height: height * 0.465,
      child: Card(
        elevation: 2, // Remove shadow effect
        color: Colors.white, // Set background to transparent
        shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.zero, // Remove corner radius for a flat edge
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Column(
                      children: [
                        SelectableText(title,
                            style: TextStyle(fontSize: isDesktop ? 15 : 18)),
                        if (Responsive.isDesktop(context))
                          title == _locale.salesCostBasedBranch
                              ? Text(
                                  " (${_locale.profit}: ${Converters.formatNumberRounded(double.parse(Converters.formatNumberDigits(totalsalesCostBasedBranchReportProfit)))}, ${_locale.sales}: ${Converters.formatNumberRounded(double.parse(Converters.formatNumberDigits(totalsalesCostBasedBranchReport)))})")
                              : SizedBox.shrink()
                      ],
                    ),
                    // title == "Sales By Cashier"
                    //     ? Text(
                    //         "Total: ${Converters.formatNumber(totalPricesCashierCount)}")
                    //     : title == "Sales By Computer"
                    //         ? Text(
                    //             "Total: ${Converters.formatNumber(totalPricesComputerCount)}")
                    //         : title == "Sales By Payment Types"
                    //             ? Text(
                    //                 "Total: ${Converters.formatNumber(totalPricesPayTypesCount)}")
                    //             : SizedBox.shrink()
                  ],
                ),
                if (Responsive.isDesktop(context))
                  if (title == _locale.salesCostBasedBranch)
                    Text(
                        "(${salesCostBasedBranchReportCrit.fromDate} - ${salesCostBasedBranchReportCrit.toDate})",
                        style: TextStyle(fontSize: isDesktop ? 13 : 16)),
                blueButton1(
                  onPressed: () async {
                    await TotalSalesController().getAllBranches().then((value) {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return FilterDialog(
                              cashiers: [],
                              branches: value,
                              filter: salesCostBasedBranchReportCrit,
                              hint: title);
                        },
                      ).then((value) {
                        if (value != false) {
                          if (title == _locale.salesCostBasedBranch) {
                            isLoading2 = true;
                            setState(() {});
                            salesCostBasedBranchReportCrit = value;
                            fetchsalesCostBasedBranchReportList();
                          }
                        }
                      });
                    });
                  },
                  textColor: const Color.fromARGB(255, 255, 255, 255),
                  icon: Icon(
                    Icons.filter_list_sharp,
                    color: Colors.white,
                    size: isDesktop ? height * 0.035 : height * 0.03,
                  ),
                )
              ],
            ),
            if (!Responsive.isDesktop(context))
              if (title == _locale.salesCostBasedBranch)
                title == _locale.salesCostBasedBranch
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                              "(${_locale.profit}: ${Converters.formatNumberRounded(double.parse(Converters.formatNumberDigits(totalsalesCostBasedBranchReportProfit)))} ${_locale.sales}: ${Converters.formatNumberRounded(double.parse(Converters.formatNumberDigits(totalsalesCostBasedBranchReport)))})"),
                        ],
                      )
                    : SizedBox.shrink(),
            if (!Responsive.isDesktop(context))
              if (title == _locale.salesCostBasedBranch)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                        textDirection: ui.TextDirection.ltr,
                        "(${salesCostBasedBranchReportCrit.fromDate} - ${salesCostBasedBranchReportCrit.toDate})",
                        style: TextStyle(fontSize: height * 0.013)),
                  ],
                ),
            isLoading2
                ? SizedBox(
                    height: height * 0.35,
                    child: const Center(child: CircularProgressIndicator()))
                : (data1.isNotEmpty)
                    ? Consumer<ScreenContentProvider>(
                        builder: (context, value, child) {
                        return Scrollbar(
                          controller: _scrollController2,
                          thumbVisibility: true,
                          thickness: 8,
                          trackVisibility: true,
                          radius: const Radius.circular(4),
                          child: SingleChildScrollView(
                            reverse: _locale.localeName == "ar" ? true : false,
                            controller: _scrollController2,
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(
                              height: height * 0.35,
                              width: Responsive.isDesktop(context)
                                  ? data1.length > 20
                                      ? width * (data1.length / 10)
                                      : !value.getIsColapsed()
                                          ? width * 0.42
                                          : width * 0.52
                                  : data1.length > 10
                                      ? width * (data1.length / 5)
                                      : width * 0.95,
                              child: SfCartesianChart(
                                  primaryXAxis: CategoryAxis(),
                                  primaryYAxis: NumericAxis(
                                    // minimum: minValue,
                                    // maximum: maxValue,
                                    title: AxisTitle(text: _locale.totalCost),
                                    // interval: interval
                                  ),
                                  legend: Legend(
                                    isVisible: true,
                                    position: LegendPosition
                                        .bottom, // Position the legend below the chart
                                    overflowMode: LegendItemOverflowMode
                                        .wrap, // Handle overflow
                                  ),
                                  axes: <ChartAxis>[
                                    CategoryAxis(
                                      name: 'secondaryXAxis',
                                      opposedPosition: true,
                                    ),
                                    NumericAxis(
                                      name: 'secondaryYAxis',
                                      title: AxisTitle(
                                          text: _locale.profitPercent),
                                      opposedPosition: true,
                                      // minimum: secondaryMinValue,
                                      // maximum: secondaryMaxValue,
                                      // interval: secondaryInterval,
                                    ),
                                  ],
                                  tooltipBehavior: _tooltip1,
                                  series: <CartesianSeries<ChartData, String>>[
                                    ColumnSeries<ChartData, String>(
                                        dataSource: data1,
                                        xValueMapper: (ChartData data1, _) =>
                                            data1.x,
                                        yValueMapper: (ChartData data1, _) =>
                                            data1.y,
                                        name: _locale.profit,
                                        color:
                                            Color.fromARGB(255, 14, 185, 11)),
                                    ColumnSeries<ChartData, String>(
                                        dataSource: data1,
                                        xValueMapper: (ChartData data1, _) =>
                                            data1.x,
                                        yValueMapper: (ChartData data1, _) =>
                                            data1.y1,
                                        name: _locale.salesCost,
                                        color: const Color.fromRGBO(
                                            1, 102, 184, 1)),
                                    LineSeries<ChartData, String>(
                                        dataSource: data1,
                                        dataLabelSettings:
                                            const DataLabelSettings(
                                          isVisible: true,
                                          textStyle: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        xValueMapper: (ChartData data1, _) =>
                                            double.parse(data1.perc)
                                                .toStringAsFixed(2),
                                        yValueMapper: (ChartData data1, _) =>
                                            data1.percD,
                                        enableTooltip: true,
                                        name: _locale.profitPercent,
                                        xAxisName: 'secondaryXAxis',
                                        yAxisName: 'secondaryYAxis',
                                        dataLabelMapper: (datum, index) {
                                          return "${double.parse(datum.perc).toStringAsFixed(0)}%";
                                        },
                                        color:
                                            const Color.fromRGBO(26, 138, 6, 1))
                                  ]),
                            ),
                          ),
                        );
                      })
                    : SizedBox(
                        height: height * 0.35,
                        child: Center(child: Text(_locale.noDataAvailable)),
                      )
          ],
        ),
      ),
    );
  }
}
