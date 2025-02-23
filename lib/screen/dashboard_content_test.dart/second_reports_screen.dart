import 'dart:async';

import 'package:bi_replicate/dialogs/fliter_dialog.dart';
import 'package:bi_replicate/model/diff_cash_shift_report_by_cashier_model.dart';
import 'package:bi_replicate/model/diff_cash_shift_report_model.dart';
import 'package:bi_replicate/model/total_profit_report_model.dart';
import 'package:bi_replicate/provider/screen_content_provider.dart';
import 'package:bi_replicate/utils/constants/app_utils.dart';
import 'package:bi_replicate/utils/constants/responsive.dart';
import 'package:bi_replicate/utils/func/converters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:bi_replicate/model/chart/chart_data_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../controller/total_sales_controller.dart';
import '../../model/sales/search_crit.dart';
import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SecondReportsScreen extends StatefulWidget {
  const SecondReportsScreen({super.key});

  @override
  State<SecondReportsScreen> createState() => _SecondReportsScreenState();
}

class _SecondReportsScreenState extends State<SecondReportsScreen> {
  late AppLocalizations _locale;
  bool isDesktop = true;
  double width = 0;
  double height = 0;
  DateTime now = DateTime.now();
  DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));
  int colorIndex = 0;
  String formattedFromDate = "";
  String formattedToDate = "";
  String salesCostFormattedFromDate = "";
  String salesCostFormattedToDate = "";

  SearchCriteria salesCostBasedBranchReportCrit = SearchCriteria(
      branch: "all",
      shiftStatus: "all",
      cashier: "",
      transType: "",
      fromDate: "",
      toDate: "");
  SearchCriteria salesCostSearchCriteria = SearchCriteria(
      branch: "all",
      shiftStatus: "all",
      cashier: "",
      transType: "",
      fromDate: "",
      toDate: "");
  List<ChartData> data1 = [];
  late TooltipBehavior _tooltip1;
  List<ChartData> data = [];
  late TooltipBehavior _tooltip;
  List<TotalProfitReportModel> totalProfitsByCategoryList = [];
  double totalProfitsByCategoryCount = 0.0;
  List<TotalProfitReportModel> salesCostBasedBranchReportList = [];
  double totalsalesCostBasedBranchReport = 0.0;
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollController1 = ScrollController();
  final storage = const FlutterSecureStorage();
  Timer? _timer;
  bool isLoading = false;
  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context)!;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    print("asdasdasdasda");
    salesCostFormattedFromDate = DateFormat('dd/MM/yyyy').format(yesterday);
    salesCostFormattedToDate = DateFormat('dd/MM/yyyy').format(now);
    _tooltip = TooltipBehavior(enable: true);
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
    salesCostSearchCriteria = SearchCriteria(
        branch: "all",
        shiftStatus: "all",
        transType: "all",
        cashier: "all",
        fromDate: formattedFromDate,
        toDate: formattedToDate);
    fetchData();
    startTimer();
    super.initState();
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
                    Responsive.isDesktop(context)
                        ? desktopView()
                        : mobileView(),
                  ],
                ))
          ],
        )
      ],
    );
  }

  fetchData() async {
    await fetchsalesCostBasedBranchReportList();
    await fetchSalesCostBasedStockCat();
    setState(() {});
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
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      salesCostBasedBranchChart(
                          data1, _locale.salesCostBasedBranch),
                      salesCostChart(data, _locale.salesCostBasedStockCat)
                    ],
                  ))
            ],
          )
        ],
      ),
    );
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
                      salesCostBasedBranchChart(
                          data1, _locale.salesCostBasedBranch),
                      salesCostChart(data, _locale.salesCostBasedStockCat)
                    ],
                  ))
            ],
          )
        ],
      ),
    );
  }

  fetchSalesCostBasedStockCat() async {
    totalProfitsByCategoryList.clear();
    totalProfitsByCategoryCount = 0.0;
    data.clear();
    isLoading = true;
    await TotalSalesController()
        .getTotalProfitsByCategoryReportList(salesCostSearchCriteria)
        .then((value) {
      isLoading = false;
      for (var i = 0; i < value.length; i++) {
        totalProfitsByCategoryList.add(value[i]);
        totalProfitsByCategoryCount +=
            (totalProfitsByCategoryList[i].totalProfit);
        data.add(ChartData(
            totalProfitsByCategoryList[i].name,
            "${totalProfitsByCategoryList[i].percentage}",
            (totalProfitsByCategoryList[i].percentage),
            (totalProfitsByCategoryList[i].totalProfit),
            (totalProfitsByCategoryList[i].totalSales)));
      }
      // if (data.isNotEmpty) {
      //   maxValue = data
      //       .map((e) => e.y1)
      //       .reduce((value, element) => value > element ? value : element);
      //   minValue = data
      //       .map((e) => e.y1)
      //       .reduce((value, element) => value < element ? value : element);
      //   interval = ((maxValue - minValue) / 10);
      //   secondaryMaxValue = data
      //       .map((e) => e.percD)
      //       .reduce((value, element) => value > element ? value : element);
      //   secondaryMinValue = data
      //       .map((e) => e.percD)
      //       .reduce((value, element) => value < element ? value : element);
      //   secondaryInterval = ((secondaryMaxValue - secondaryMinValue) / 10);
      //   print("secondaryMaxValue: ${secondaryMaxValue}");
      //   print("secondaryMinValue: ${secondaryMinValue}");
      //   print("secondaryInterval: ${secondaryInterval}");
      // }

      print("totalProfitsByCategoryList: ${totalProfitsByCategoryList.length}");
      setState(() {});
    });
  }

  fetchsalesCostBasedBranchReportList() async {
    salesCostBasedBranchReportList.clear();
    totalsalesCostBasedBranchReport = 0.0;
    data1.clear();
    isLoading = true;
    await TotalSalesController()
        .getTotalProfitsByBranchReportList(salesCostBasedBranchReportCrit)
        .then((value) {
      isLoading = false;
      for (var i = 0; i < value.length; i++) {
        salesCostBasedBranchReportList.add(value[i]);

        totalsalesCostBasedBranchReport += value[i].totalProfit;
        data1.add(ChartData(
            salesCostBasedBranchReportList[i].name,
            "${salesCostBasedBranchReportList[i].percentage}",
            (salesCostBasedBranchReportList[i].percentage),
            (salesCostBasedBranchReportList[i].totalProfit),
            (salesCostBasedBranchReportList[i].totalSales)));
      }
      print(
          "salesCostBasedBranchReportList: ${salesCostBasedBranchReportList.length}");
      setState(() {});
    });
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
                    Row(
                      children: [
                        SelectableText(title,
                            style: TextStyle(fontSize: isDesktop ? 15 : 18)),
                        if (Responsive.isDesktop(context))
                          title == _locale.salesCostBasedBranch
                              ? Text(
                                  " (${Converters.formatNumberRounded(double.parse(Converters.formatNumberDigits(totalsalesCostBasedBranchReport)))})")
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
                  if (title == _locale.cashierLogs)
                    Text(
                        "(${salesCostBasedBranchReportCrit.fromDate} - ${salesCostBasedBranchReportCrit.toDate})",
                        style: TextStyle(fontSize: isDesktop ? 13 : 16)),
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
                              " (${Converters.formatNumberRounded(double.parse(Converters.formatNumberDigits(totalsalesCostBasedBranchReport)))})"),
                        ],
                      )
                    : SizedBox.shrink(),
            if (!Responsive.isDesktop(context))
              if (title == _locale.salesCostBasedBranch)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                        "(${salesCostBasedBranchReportCrit.fromDate} - ${salesCostBasedBranchReportCrit.toDate})",
                        style: TextStyle(fontSize: height * 0.013)),
                  ],
                ),
            isLoading
                ? SizedBox(
                    height: height * 0.35,
                    child: const Center(child: CircularProgressIndicator()))
                : (data1.isNotEmpty)
                    ? Consumer<ScreenContentProvider>(
                        builder: (context, value, child) {
                        return Scrollbar(
                          controller: _scrollController1,
                          thumbVisibility: true,
                          thickness: 8,
                          trackVisibility: true,
                          radius: const Radius.circular(4),
                          child: SingleChildScrollView(
                            reverse: _locale.localeName == "ar" ? true : false,
                            controller: _scrollController1,
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(
                              height: height * 0.35,
                              width: Responsive.isDesktop(context)
                                  ? data1.length > 20
                                      ? width * (data1.length / 10)
                                      : !value.getIsColapsed()
                                          ? width * 0.82
                                          : width * 0.92
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

  Widget salesCostChart(List<ChartData> data, String title) {
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
                    Row(
                      children: [
                        SelectableText(title,
                            style: TextStyle(fontSize: isDesktop ? 15 : 18)),
                        if (Responsive.isDesktop(context))
                          title == _locale.salesCostBasedStockCat
                              ? Text(
                                  " (${Converters.formatNumberRounded(double.parse(Converters.formatNumberDigits(totalProfitsByCategoryCount)))})")
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
                  if (title == _locale.salesCostBasedStockCat)
                    Text(
                        "(${salesCostSearchCriteria.fromDate} - ${salesCostSearchCriteria.toDate})",
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
                              filter: salesCostSearchCriteria,
                              hint: title);
                        },
                      ).then((value) {
                        if (value != false) {
                          if (title == _locale.salesCostBasedStockCat) {
                            salesCostSearchCriteria = value;
                            fetchSalesCostBasedStockCat();
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
              if (title == _locale.salesCostBasedStockCat)
                title == _locale.salesCostBasedStockCat
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                              " (${Converters.formatNumberRounded(double.parse(Converters.formatNumberDigits(totalProfitsByCategoryCount)))})"),
                        ],
                      )
                    : SizedBox.shrink(),
            if (!Responsive.isDesktop(context))
              if (title == _locale.salesCostBasedStockCat)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                        "(${salesCostSearchCriteria.fromDate} - ${salesCostSearchCriteria.toDate})",
                        style: TextStyle(fontSize: height * 0.013)),
                  ],
                ),
            isLoading
                ? SizedBox(
                    height: height * 0.35,
                    child: const Center(child: CircularProgressIndicator()))
                : (data.isNotEmpty)
                    ? Consumer<ScreenContentProvider>(
                        builder: (context, value, child) {
                        return Scrollbar(
                          controller: _scrollController,
                          thumbVisibility: true,
                          thickness: 8,
                          trackVisibility: true,
                          radius: const Radius.circular(4),
                          child: SingleChildScrollView(
                            reverse: _locale.localeName == "ar" ? true : false,
                            controller: _scrollController,
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(
                              height: height * 0.35,
                              width: Responsive.isDesktop(context)
                                  ? data.length > 20
                                      ? width * (data.length / 10)
                                      : !value.getIsColapsed()
                                          ? width * 0.82
                                          : width * 0.92
                                  : data.length > 10
                                      ? width * (data.length / 5)
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
                                  tooltipBehavior: _tooltip,
                                  series: <CartesianSeries<ChartData, String>>[
                                    ColumnSeries<ChartData, String>(
                                        dataSource: data,
                                        xValueMapper: (ChartData data, _) =>
                                            data.x,
                                        yValueMapper: (ChartData data, _) =>
                                            data.y,
                                        name: _locale.profit,
                                        color:
                                            Color.fromARGB(255, 14, 185, 11)),
                                    ColumnSeries<ChartData, String>(
                                        dataSource: data,
                                        xValueMapper: (ChartData data, _) =>
                                            data.x,
                                        yValueMapper: (ChartData data, _) =>
                                            data.y1,
                                        name: _locale.salesCost,
                                        color: const Color.fromRGBO(
                                            1, 102, 184, 1)),
                                    LineSeries<ChartData, String>(
                                        dataSource: data,
                                        dataLabelSettings:
                                            const DataLabelSettings(
                                          isVisible: true,
                                          textStyle: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        xValueMapper: (ChartData data, _) =>
                                            double.parse(data.perc)
                                                .toStringAsFixed(2),
                                        yValueMapper: (ChartData data, _) =>
                                            data.percD,
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
