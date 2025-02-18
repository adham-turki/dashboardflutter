import 'dart:async';

import 'package:bi_replicate/dialogs/fliter_dialog.dart';
import 'package:bi_replicate/model/cashier_model.dart';
import 'package:bi_replicate/model/diff_cash_shift_report_by_cashier_model.dart';
import 'package:bi_replicate/model/diff_cash_shift_report_model.dart';
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

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  late AppLocalizations _locale;
  bool isDesktop = true;
  double width = 0;
  double height = 0;
  DateTime now = DateTime.now();
  DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));
  int colorIndex = 0;
  String formattedFromDate = "";
  String formattedToDate = "";
  SearchCriteria diffClosedCashShiftReportCrit = SearchCriteria(
      branch: "all",
      shiftStatus: "all",
      cashier: "",
      transType: "",
      fromDate: "",
      toDate: "");
  SearchCriteria diffCashShiftByCashierReportCrit = SearchCriteria(
      branch: "all",
      shiftStatus: "all",
      cashier: "",
      transType: "",
      fromDate: "",
      toDate: "");
  List<ChartData> data = [];
  List<ChartData> data1 = [];
  late TooltipBehavior _tooltip;
  late TooltipBehavior _tooltip1;
  List<DiffCashShiftReportModel> diffClosedCashShiftReportList = [];
  double totalDiffClosedCashShiftReport = 0.0;
  List<DiffCashShiftReportByCashierModel> diffCashShiftByCashierReportList = [];
  double totalDiffCashShiftByCashierReport = 0.0;
  final ScrollController _scrollController1 = ScrollController();
  final ScrollController _scrollController2 = ScrollController();
  double minValue = 0;
  double maxValue = 0;
  double interval = 0;
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

    diffClosedCashShiftReportCrit = SearchCriteria(
        branch: "all",
        shiftStatus: "all",
        transType: "all",
        cashier: "all",
        fromDate: formattedFromDate,
        toDate: formattedToDate);
    diffCashShiftByCashierReportCrit = SearchCriteria(
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
    await fetchDiffClosedCashShiftReportList();
    await fetchDiffCashShiftByCashierReportList();
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
                      diffClosedCashChart(data, _locale.diffClosedCashByShifts),
                      diffCashChart(data1, _locale.diffCashByShifts),
                      // salesCostChart(data, _locale.salesCostBasedStockCat)
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
                      diffClosedCashChart(data, _locale.diffClosedCashByShifts),
                      diffCashChart(data1, _locale.diffCashByShifts),
                      // salesCostChart(data, _locale.salesCostBasedStockCat)
                    ],
                  ))
            ],
          )
        ],
      ),
    );
  }

  fetchDiffCashShiftByCashierReportList() async {
    diffCashShiftByCashierReportList.clear();
    totalDiffCashShiftByCashierReport = 0.0;
    data1.clear();
    isLoading = true;
    await TotalSalesController()
        .getDiffCashShiftReportByCashierReportList(
            diffCashShiftByCashierReportCrit)
        .then((value) {
      isLoading = false;
      for (var i = 0; i < value.length; i++) {
        diffCashShiftByCashierReportList.add(value[i]);

        totalDiffCashShiftByCashierReport += value[i].diffAmount;
        data1.add(ChartData(
            diffCashShiftByCashierReportList[i].user,
            "${diffCashShiftByCashierReportList[i].shift}",
            0.0,
            (diffCashShiftByCashierReportList[i].diffAmount),
            0.0));
      }
      print(
          "diffCashShiftByCashierReportList: ${diffCashShiftByCashierReportList.length}");
      setState(() {});
    });
  }

  fetchDiffClosedCashShiftReportList() async {
    diffClosedCashShiftReportList.clear();
    totalDiffClosedCashShiftReport = 0.0;
    data.clear();
    isLoading = true;
    await TotalSalesController()
        .getDiffCashShiftReportList(diffClosedCashShiftReportCrit)
        .then((value) {
      isLoading = false;
      for (var i = 0; i < value.length; i++) {
        diffClosedCashShiftReportList.add(value[i]);
        totalDiffClosedCashShiftReport += value[i].diffSum;
        data.add(ChartData(
            diffClosedCashShiftReportList[i].branchName,
            diffClosedCashShiftReportList[i].user,
            (diffClosedCashShiftReportList[i].diffCount).toDouble(),
            (diffClosedCashShiftReportList[i].diffSum),
            0.0));
      }
      // if (data.isNotEmpty) {
      //   maxValue = data
      //       .map((e) => e.y1)
      //       .reduce((value, element) => value > element ? value : element);
      //   minValue = data
      //       .map((e) => e.y1)
      //       .reduce((value, element) => value < element ? value : element);
      //   interval = ((maxValue - minValue) / 10);

      //   print("maxValue: ${maxValue}");
      //   print("minValue: ${minValue}");
      //   print("interval: ${interval}");
      // }
      print("diffCashShiftReportList: ${diffClosedCashShiftReportList.length}");
      setState(() {});
    });
  }

  Widget diffClosedCashChart(List<ChartData> data, String title) {
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
                          title == _locale.diffClosedCashByShifts
                              ? Text(
                                  " (${Converters.formatNumberRounded(double.parse(Converters.formatNumberDigits(totalDiffClosedCashShiftReport)))})")
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
                  if (title == _locale.diffClosedCashByShifts)
                    Text(
                        "(${diffClosedCashShiftReportCrit.fromDate} - ${diffClosedCashShiftReportCrit.toDate})",
                        style: TextStyle(fontSize: isDesktop ? 13 : 16)),
                blueButton1(
                  onPressed: () async {
                    List<CashierModel> cashiers = [];

                    cashiers = await TotalSalesController().getAllCashiers();

                    await TotalSalesController().getAllBranches().then((value) {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return FilterDialog(
                              cashiers: cashiers,
                              branches: value,
                              filter: diffClosedCashShiftReportCrit,
                              hint: title);
                        },
                      ).then((value) {
                        if (value != false) {
                          diffClosedCashShiftReportCrit = value;
                          fetchDiffClosedCashShiftReportList();
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
              if (title == _locale.diffClosedCashByShifts)
                title == _locale.diffClosedCashByShifts
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                              " (${Converters.formatNumberRounded(double.parse(Converters.formatNumberDigits(totalDiffClosedCashShiftReport)))})"),
                        ],
                      )
                    : SizedBox.shrink(),
            if (!Responsive.isDesktop(context))
              if (title == _locale.diffClosedCashByShifts)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                        "(${diffClosedCashShiftReportCrit.fromDate} - ${diffClosedCashShiftReportCrit.toDate})",
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
                              height: height * 0.38,
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
                                  primaryXAxis: CategoryAxis(
                                    majorGridLines: MajorGridLines(
                                        width: 1.5, color: Colors.grey),
                                    labelStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10),
                                    majorTickLines: MajorTickLines(size: 10),
                                    labelPlacement: LabelPlacement.onTicks,
                                    labelRotation:
                                        -30, // Rotating labels by -30 degrees
                                  ),

                                  // primaryYAxis: NumericAxis(
                                  //     minimum: minValue,
                                  //     maximum: maxValue,
                                  //     title: AxisTitle(text: _locale.totalCost),
                                  //     interval: interval),
                                  legend: Legend(
                                    isVisible: true,
                                    position: LegendPosition
                                        .bottom, // Position the legend below the chart
                                    // overflowMode: LegendItemOverflowMode.wrap,
                                  ),
                                  axes: <ChartAxis>[
                                    CategoryAxis(
                                      majorGridLines: MajorGridLines(
                                          width: 1.5, color: Colors.grey),
                                      labelStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 8),
                                      majorTickLines: MajorTickLines(size: 10),
                                      labelPlacement: LabelPlacement.onTicks,
                                      labelRotation: -30, // Rotating
                                    ),
                                  ],
                                  tooltipBehavior: _tooltip,
                                  series: <CartesianSeries<ChartData, String>>[
                                    // ColumnSeries<ChartData, String>(
                                    //     dataSource: data,
                                    //     xValueMapper: (ChartData data, _) => data.x,
                                    //     yValueMapper: (ChartData data, _) => data.y,
                                    //     name: _locale.profit,
                                    //     color: const Color.fromRGBO(184, 2, 2, 1)),
                                    // ColumnSeries<ChartData, String>(
                                    //     dataSource: data,
                                    //     xValueMapper: (ChartData data, _) => data.x,
                                    //     yValueMapper: (ChartData data, _) => data.y1,
                                    //     name: _locale.salesCost,
                                    //     color: const Color.fromRGBO(1, 102, 184, 1)),
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
                                            "${data.perc}\n${data.x.toString()}",
                                        yValueMapper: (ChartData data, _) =>
                                            data.y,
                                        enableTooltip: true,
                                        name: _locale.valueOfTotalDiff,
                                        // xAxisName: 'secondaryXAxis',
                                        // yAxisName: 'secondaryYAxis',
                                        dataLabelMapper: (datum, index) {
                                          return Converters.formatNumberRounded(
                                              double.parse(
                                                  Converters.formatNumberDigits(
                                                      datum.y)));
                                        },
                                        color: const Color.fromRGBO(
                                            26, 138, 6, 1)),
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
                                            "${data.perc}\n${data.x.toString()}",
                                        yValueMapper: (ChartData data, _) =>
                                            data.percD,
                                        enableTooltip: true,
                                        name: _locale.numOfDiffTimes,
                                        // xAxisName: 'secondaryXAxis',
                                        // yAxisName: 'secondaryYAxis',
                                        dataLabelMapper: (datum, index) {
                                          return Converters.formatNumberRounded(
                                              double.parse(
                                                  Converters.formatNumberDigits(
                                                      datum.percD)));
                                        },
                                        color: Color.fromARGB(255, 255, 0, 0)),
                                  ]),
                            ),
                          ),
                        );
                      })
                    : SizedBox(
                        height: height * 0.38,
                        child: Center(child: Text(_locale.noDataAvailable)),
                      )
          ],
        ),
      ),
    );
  }

  Widget diffCashChart(List<ChartData> data, String title) {
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
                          title == _locale.diffCashByShifts
                              ? Text(
                                  " (${Converters.formatNumberRounded(double.parse(Converters.formatNumberDigits(totalDiffCashShiftByCashierReport)))})")
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
                  if (title == _locale.diffCashByShifts)
                    Text(
                        "(${diffCashShiftByCashierReportCrit.fromDate} - ${diffCashShiftByCashierReportCrit.toDate})",
                        style: TextStyle(fontSize: isDesktop ? 13 : 16)),
                blueButton1(
                  onPressed: () async {
                    List<CashierModel> cashiers = [];

                    cashiers = await TotalSalesController().getAllCashiers();
                    await TotalSalesController().getAllBranches().then((value) {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return FilterDialog(
                              cashiers: cashiers,
                              branches: value,
                              filter: diffCashShiftByCashierReportCrit,
                              hint: title);
                        },
                      ).then((value) {
                        if (value != false) {
                          diffCashShiftByCashierReportCrit = value;
                          fetchDiffCashShiftByCashierReportList();
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
              if (title == _locale.diffCashByShifts)
                title == _locale.diffCashByShifts
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                              " (${Converters.formatNumberRounded(double.parse(Converters.formatNumberDigits(totalDiffCashShiftByCashierReport)))})"),
                        ],
                      )
                    : SizedBox.shrink(),
            if (!Responsive.isDesktop(context))
              if (title == _locale.diffCashByShifts)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                        "(${diffCashShiftByCashierReportCrit.fromDate} - ${diffCashShiftByCashierReportCrit.toDate})",
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
                              height: height * 0.38,
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
                                  primaryXAxis: CategoryAxis(
                                    majorGridLines: MajorGridLines(
                                        width: 1.5, color: Colors.grey),
                                    labelStyle:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    majorTickLines: MajorTickLines(size: 10),
                                    labelPlacement: LabelPlacement.onTicks,
                                    labelRotation: -30, // Rotating
                                  ),
                                  // primaryYAxis: NumericAxis(
                                  //     minimum: minValue,
                                  //     maximum: maxValue,
                                  //     title: AxisTitle(text: _locale.totalCost),
                                  //     interval: interval),
                                  legend: Legend(
                                    isVisible: true,
                                    position: LegendPosition
                                        .bottom, // Position the legend below the chart
                                    overflowMode: LegendItemOverflowMode
                                        .wrap, // Handle overflow
                                  ),
                                  axes: <ChartAxis>[
                                    CategoryAxis(
                                      majorGridLines: MajorGridLines(
                                          width: 1.5, color: Colors.grey),
                                      labelStyle: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      majorTickLines: MajorTickLines(size: 10),
                                      labelPlacement: LabelPlacement.onTicks,
                                      labelRotation: -30, // Rotating
                                      // name: 'secondaryXAxis',
                                      // opposedPosition: true,
                                    ),
                                  ],
                                  tooltipBehavior: _tooltip1,
                                  series: <CartesianSeries<ChartData, String>>[
                                    // ColumnSeries<ChartData, String>(
                                    //     dataSource: data,
                                    //     xValueMapper: (ChartData data, _) => data.x,
                                    //     yValueMapper: (ChartData data, _) => data.y,
                                    //     name: _locale.profit,
                                    //     color: const Color.fromRGBO(184, 2, 2, 1)),
                                    // ColumnSeries<ChartData, String>(
                                    //     dataSource: data,
                                    //     xValueMapper: (ChartData data, _) => data.x,
                                    //     yValueMapper: (ChartData data, _) => data.y1,
                                    //     name: _locale.salesCost,
                                    //     color: const Color.fromRGBO(1, 102, 184, 1)),
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
                                            "${data.x}\n${data.perc}",
                                        yValueMapper: (ChartData data, _) =>
                                            data.y,
                                        enableTooltip: true,
                                        name: _locale.differenceValue,
                                        // xAxisName: 'secondaryXAxis',
                                        // yAxisName: 'secondaryYAxis',
                                        dataLabelMapper: (datum, index) {
                                          return "${Converters.formatNumberRounded(double.parse(Converters.formatNumberDigits(datum.y)))}\n${datum.x.toString()}";
                                        },
                                        color: Colors.blue),
                                    // LineSeries<ChartData, String>(
                                    //     dataSource: data,
                                    //     dataLabelSettings: const DataLabelSettings(
                                    //       isVisible: true,
                                    //       textStyle: TextStyle(
                                    //           color: Colors.black,
                                    //           fontWeight: FontWeight.w600),
                                    //     ),
                                    //     xValueMapper: (ChartData data, _) => data.perc,
                                    //     yValueMapper: (ChartData data, _) => data.percD,
                                    //     enableTooltip: true,
                                    //     name: _locale.numOfDiffTimes,
                                    //     // xAxisName: 'secondaryXAxis',
                                    //     // yAxisName: 'secondaryYAxis',
                                    //     dataLabelMapper: (datum, index) {
                                    //       return datum.percD.toString();
                                    //     },
                                    //     color: Color.fromARGB(255, 255, 0, 0)),
                                  ]),
                            ),
                          ),
                        );
                      })
                    : SizedBox(
                        height: height * 0.38,
                        child: Center(child: Text(_locale.noDataAvailable)),
                      )
          ],
        ),
      ),
    );
  }
}
