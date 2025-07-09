import 'dart:async';

import 'package:bi_replicate/model/chart/chart_data_model.dart';
import 'package:bi_replicate/model/sales/sales_cost_based_stock_cat_view_model.dart';
import 'package:bi_replicate/model/sales_view_model.dart';
import 'package:bi_replicate/provider/dates_provider.dart';

import 'package:bi_replicate/utils/constants/responsive.dart';
import 'package:bi_replicate/dialogs/fliter_dialog.dart';
import 'package:bi_replicate/model/cashier_model.dart';
import 'package:bi_replicate/utils/func/converters.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../controller/total_sales_controller.dart';
import '../../model/sales/search_crit.dart';

class LogsReportsScreen extends StatefulWidget {
  const LogsReportsScreen({super.key});

  @override
  State<LogsReportsScreen> createState() => _LogsReportsScreenState();
}

class _LogsReportsScreenState extends State<LogsReportsScreen> {
  bool isDesktop = true;
  double width = 0;
  double height = 0;
  DateTime now = DateTime.now();
  DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));
  int colorIndex = 0;
  String formattedFromDate = "";
  String formattedToDate = "";

  SearchCriteria cashierLogsSearchCriteria = SearchCriteria(
      branch: "all",
      shiftStatus: "all",
      cashier: "",
      transType: "",
      fromDate: "",
      toDate: "");

  late AppLocalizations _locale;
  final ScrollController _scrollController = ScrollController();
  List<ChartData> data = [];
  List<BranchSalesViewModel> totalCashierLogsList = [];
  double totalCashierLogs = 0.0;
  List<SalesCostBasedStockCategoryViewModel> salesCostBasedStkCatList = [];
  double salesCostBasedStkCatCount = 0.0;
  List<BarChartGroupData> barChartDataLogs = [];

  double minValue = 0;
  double maxValue = 0;
  double interval = 0;
  double secondaryMinValue = 0;
  double secondaryMaxValue = 0;
  double secondaryInterval = 0;
  final storage = const FlutterSecureStorage();
  Timer? _timer;
  bool isLoading = false;
  double maxY = 0.0;
  List<String> xLabelsLogs = [];
  late DatesProvider dateProvider;

  fetchSalesByCashierLogs() async {
    totalCashierLogsList.clear();
    totalCashierLogs = 0.0;
    isLoading = true;
    maxY = 0.0;
    setState(() {});
    await TotalSalesController()
        .getCashierLogs(cashierLogsSearchCriteria)
        .then((value) {
      isLoading = false;
      for (var i = 0; i < value.length; i++) {
        totalCashierLogsList.add(BranchSalesViewModel.fromDBModel(value[i]));
        totalCashierLogs +=
            double.parse(totalCashierLogsList[i].displayLogsCount);
        if (double.parse(totalCashierLogsList[i].displayLogsCount) > maxY) {
          maxY = double.parse(totalCashierLogsList[i].displayLogsCount);
        }
        xLabelsLogs =
            totalCashierLogsList.map((e) => e.displayGroupName).toList();

        barChartDataLogs = List.generate(totalCashierLogsList.length, (index) {
          return BarChartGroupData(
            x: index, // Use index as x-value
            barRods: [
              BarChartRodData(
                toY: double.parse(totalCashierLogsList[index].displayLogsCount),
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
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context)!;
    cashierLogsSearchCriteria.chartType == _locale.barChart;
    super.didChangeDependencies();
  }

  @override
  void initState() {
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
    formattedFromDate = context.read<DatesProvider>().sessionFromDate.isNotEmpty
        ? context.read<DatesProvider>().sessionFromDate
        : formattedFromDate;
    formattedToDate = context.read<DatesProvider>().sessionToDate.isNotEmpty
        ? context.read<DatesProvider>().sessionToDate
        : formattedToDate;
    cashierLogsSearchCriteria = SearchCriteria(
        branch: "all",
        shiftStatus: "all",
        transType: "all",
        cashier: "all",
        fromDate: formattedFromDate,
        toDate: formattedToDate);
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   dateProvider = Provider.of<DatesProvider>(context, listen: false);
    //   dateProvider.addListener(_onDateRangeChanged);
    // });
    fetchData();
    startTimer();
    super.initState();
  }

  void _onDateRangeChanged() {
    if (dateProvider.sessionFromDate != "" &&
        dateProvider.sessionToDate != "") {
      formattedToDate = DateFormat('dd/MM/yyyy').format(now);
      formattedFromDate =
          context.read<DatesProvider>().sessionFromDate.isNotEmpty
              ? context.read<DatesProvider>().sessionFromDate
              : formattedFromDate;
      formattedToDate = context.read<DatesProvider>().sessionToDate.isNotEmpty
          ? context.read<DatesProvider>().sessionToDate
          : formattedToDate;
      cashierLogsSearchCriteria = SearchCriteria(
          branch: "all",
          shiftStatus: "all",
          transType: "all",
          cashier: "all",
          fromDate: formattedFromDate,
          toDate: formattedToDate);
      fetchData();
    }
  }

  fetchData() async {
    await fetchSalesByCashierLogs();
    setState(() {});
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
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
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
                      cashierLogsSearchCriteria.chartType == _locale.barChart
                          ? barChart(_locale.cashierLogs, barChartDataLogs)
                          : dailySalesChart(
                              totalCashierLogsList, _locale.cashierLogs),
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
                      cashierLogsSearchCriteria.chartType == _locale.barChart
                          ? barChart(_locale.cashierLogs, barChartDataLogs)
                          : dailySalesChart(
                              totalCashierLogsList, _locale.cashierLogs),
                    ],
                  ))
            ],
          )
        ],
      ),
    );
  }

  bool filterPressed = false;

  Widget dailySalesChart(List<BranchSalesViewModel> totalSales, String title) {
    return Container(
      height: height * 0.465,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Card(
        elevation: 0, // Remove default elevation since we're using custom shadow
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(
            color: Color.fromRGBO(82, 151, 176, 0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color.fromRGBO(82, 151, 176, 0.05),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 4,
                              height: 20,
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(82, 151, 176, 1),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 8),
                            SelectableText(
                              title,
                              style: TextStyle(
                                fontSize: isDesktop ? 16 : 18,
                                fontWeight: FontWeight.w600,
                                color: const Color.fromRGBO(82, 151, 176, 1),
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (title == _locale.cashierLogs)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(82, 151, 176, 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '\u200E${NumberFormat('#,###', 'en_US').format(totalCashierLogs)}',
                                  style: TextStyle(
                                    fontSize: isDesktop ? 12 : 14,
                                    fontWeight: FontWeight.w500,
                                    color: const Color.fromRGBO(82, 151, 176, 1),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        if (Responsive.isDesktop(context))
                          if (title == _locale.cashierLogs)
                            Padding(
                              padding: const EdgeInsets.only(top: 8, left: 12),
                              child: Text(
                                "(${cashierLogsSearchCriteria.fromDate} - ${cashierLogsSearchCriteria.toDate})",
                                style: TextStyle(
                                  fontSize: isDesktop ? 12 : 14,
                                  color: Colors.grey.shade600,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                      ],
                    ),
                  ),
                  // Enhanced Filter Button
                  blueButton1(
                    onPressed: () async {
                      if (!filterPressed) {
                        setState(() {
                          filterPressed = true;
                        });

                        List<CashierModel> cashiers = [];
                        if (title == _locale.cashierLogs) {
                          cashiers = await TotalSalesController().getAllCashiers();
                        }
                        await TotalSalesController().getAllBranches().then((value) {
                          setState(() {
                            filterPressed = false;
                          });
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return FilterDialog(
                                  cashiers: cashiers,
                                  branches: value,
                                  filter: title == _locale.cashierLogs
                                      ? cashierLogsSearchCriteria
                                      : cashierLogsSearchCriteria,
                                  hint: title);
                            },
                          ).then((value) {
                            if (value != false) {
                              if (title == _locale.cashierLogs) {
                                cashierLogsSearchCriteria = value;
                                isLoading = true;
                                setState(() {});
                                fetchSalesByCashierLogs();
                              }
                            }
                          });
                        });
                      }
                    },
                    textColor: const Color.fromARGB(255, 255, 255, 255),
                    icon: Icon(
                      Icons.filter_list_sharp,
                      color: Colors.white,
                      size: isDesktop ? height * 0.03 : height * 0.025,
                    ),
                  ),
                ],
              ),
            ),
            if (!Responsive.isDesktop(context))
              if (title == _locale.cashierLogs)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                          "(${cashierLogsSearchCriteria.fromDate} - ${cashierLogsSearchCriteria.toDate})",
                          style: TextStyle(
                            fontSize: height * 0.013,
                            color: Colors.grey.shade600,
                            fontStyle: FontStyle.italic,
                          )),
                    ],
                  ),
                ),
            // Enhanced Chart Content Area
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color.fromRGBO(82, 151, 176, 1),
                          strokeWidth: 3,
                        ),
                      )
                    : totalCashierLogsList.isNotEmpty
                        ? Scrollbar(
                            controller: _scrollController,
                            thumbVisibility: true,
                            thickness: 6,
                            trackVisibility: true,
                            radius: const Radius.circular(8),
                            child: SingleChildScrollView(
                              reverse: _locale.localeName == "ar" ? true : false,
                              controller: _scrollController,
                              scrollDirection: Axis.horizontal,
                              child: SizedBox(
                                height: height * 0.3,
                                width: Responsive.isDesktop(context)
                                    ? totalSales.length > 20
                                        ? width * (totalSales.length / 16)
                                        : width * 0.82
                                    : totalSales.length > 5
                                        ? width * (totalSales.length / 8)
                                        : width * 0.82,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10.0),
                                  child: LineChart(
                                    LineChartData(
                                      maxY: maxY * 1.3,
                                      lineTouchData: LineTouchData(
                                        touchTooltipData: LineTouchTooltipData(
                                          tooltipRoundedRadius: 8,
                                          getTooltipItems: (List<LineBarSpot> touchedSpots) {
                                            return touchedSpots.map((spot) {
                                              return LineTooltipItem(
                                                "${totalSales[spot.spotIndex].displayGroupName}\n${totalSales[spot.spotIndex].displaytransTypeName}\n${Converters.formatNumber(spot.y)}",
                                                const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                                              );
                                            }).toList();
                                          },
                                        ),
                                      ),
                                      titlesData: FlTitlesData(
                                        topTitles: const AxisTitles(
                                          sideTitles: SideTitles(showTitles: false),
                                        ),
                                        rightTitles: const AxisTitles(
                                            sideTitles: SideTitles(showTitles: false)),
                                        leftTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                          getTitlesWidget: (value, meta) => leftTitleWidgets(value),
                                          showTitles: true,
                                          reservedSize: 35,
                                        )),
                                        bottomTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            interval: 1,
                                            getTitlesWidget: (value, meta) =>
                                                groupNameTitle(value.toInt(), totalSales, title),
                                          ),
                                        ),
                                      ),
                                      borderData: FlBorderData(
                                          border: Border.all(
                                              color: const Color.fromRGBO(82, 151, 176, 0.3))),
                                      gridData: FlGridData(
                                        show: true,
                                        drawVerticalLine: true,
                                        horizontalInterval: maxY * 0.2,
                                        verticalInterval: 1,
                                        getDrawingHorizontalLine: (value) {
                                          return const FlLine(
                                            color: Color.fromRGBO(82, 151, 176, 0.1),
                                            strokeWidth: 1,
                                          );
                                        },
                                        getDrawingVerticalLine: (value) {
                                          return const FlLine(
                                            color: Color.fromRGBO(82, 151, 176, 0.1),
                                            strokeWidth: 1,
                                          );
                                        },
                                      ),
                                      lineBarsData: [
                                        LineChartBarData(
                                          belowBarData: BarAreaData(
                                            show: true,
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color.fromRGBO(82, 151, 176, 0.3),
                                                Color.fromRGBO(82, 151, 176, 0.1),
                                              ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                            ),
                                          ),
                                          isCurved: true,
                                          color: const Color.fromRGBO(82, 151, 176, 1),
                                          barWidth: 3,
                                          isStrokeCapRound: true,
                                          dotData: FlDotData(
                                            show: true,
                                            getDotPainter: (spot, percent, barData, index) =>
                                                FlDotCirclePainter(
                                              radius: 4,
                                              color: const Color.fromRGBO(82, 151, 176, 1),
                                              strokeWidth: 2,
                                              strokeColor: Colors.white,
                                            ),
                                          ),
                                          preventCurveOverShooting: true,
                                          spots: totalSales.asMap().entries.map((entry) {
                                            int index = entry.key;
                                            double totalSalesValue = double.parse(entry.value.displayLogsCount);
                                            return FlSpot(index.toDouble(), totalSalesValue);
                                          }).toList(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.bar_chart_outlined,
                                  size: 48,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _locale.noDataAvailable,
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget leftTitleWidgets(double value) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 10,
      color: Colors.grey,
    );

    return Text(
      "\u200E${Converters.formatTitleNumber(value)}",
      style: style,
      textAlign: TextAlign.left,
    );
  }

  Widget groupNameTitle(
      int value, List<BranchSalesViewModel> totalSales, String title) {
    if (value >= 0 && value < totalSales.length) {
      return Transform.rotate(
        angle: -30 * 3.14159 / 180, // 30 degrees in radians
        child: SizedBox(
          width: 200,
          child: Center(
            child: Text(
              (title == _locale.salesByComputer ||
                      title == _locale.salesByCashier)
                  ? "${totalSales[value].displayGroupName} / ${totalSales[value].displayBranchName}"
                  : totalSales[value].displayGroupName,
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 10,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      );
    } else {
      return const Text('');
    }
  }

  Widget barChart(String title, List<BarChartGroupData> enteredBarChartData) {
    return Container(
      height: height * 0.47,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(
            color: Color.fromRGBO(82, 151, 176, 0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            // Enhanced Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color.fromRGBO(82, 151, 176, 0.05),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 4,
                              height: 20,
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(82, 151, 176, 1),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 8),
                            SelectableText(
                              title,
                              style: TextStyle(
                                fontSize: height * 0.015,
                                fontWeight: FontWeight.w600,
                                color: const Color.fromRGBO(82, 151, 176, 1),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(82, 151, 176, 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '\u200E${NumberFormat('#,###', 'en_US').format(totalCashierLogs)}',
                                style: TextStyle(
                                  fontSize: isDesktop ? 12 : 14,
                                  fontWeight: FontWeight.w500,
                                  color: const Color.fromRGBO(82, 151, 176, 1),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (title == _locale.cashierLogs)
                          Padding(
                            padding: const EdgeInsets.only(top: 8, left: 12),
                            child: Text(
                              "(${cashierLogsSearchCriteria.fromDate} - ${cashierLogsSearchCriteria.toDate})",
                              style: TextStyle(
                                fontSize: isDesktop ? 12 : height * 0.013,
                                color: Colors.grey.shade600,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Enhanced Filter Button
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
                                filter: title == _locale.cashierLogs
                                    ? cashierLogsSearchCriteria
                                    : cashierLogsSearchCriteria,
                                hint: title);
                          },
                        ).then((value) {
                          if (value != false) {
                            if (title == _locale.cashierLogs) {
                              cashierLogsSearchCriteria = value;
                              isLoading = true;
                              setState(() {});
                              fetchSalesByCashierLogs();
                            }
                          }
                        });
                      });
                    },
                    textColor: const Color.fromARGB(255, 255, 255, 255),
                    icon: Icon(
                      Icons.filter_list_sharp,
                      color: Colors.white,
                      size: isDesktop ? height * 0.03 : height * 0.025,
                    ),
                  ),
                ],
              ),
            ),
            // Enhanced Chart Content
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: (title == _locale.cashierLogs && isLoading)
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color.fromRGBO(82, 151, 176, 1),
                          strokeWidth: 3,
                        ),
                      )
                    : Scrollbar(
                        controller: title == _locale.cashierLogs
                            ? _scrollController
                            : _scrollController,
                        thumbVisibility: true,
                        thickness: 6,
                        trackVisibility: true,
                        radius: const Radius.circular(8),
                        child: SingleChildScrollView(
                          reverse: _locale.localeName == "ar" ? true : false,
                          controller: title == _locale.cashierLogs
                              ? _scrollController
                              : _scrollController,
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            height: height * 0.3,
                            width: Responsive.isDesktop(context)
                                ? enteredBarChartData.length > 20
                                    ? width * (enteredBarChartData.length / 10)
                                    : width * 0.3
                                : enteredBarChartData.length > 5
                                    ? width * (enteredBarChartData.length / 2)
                                    : width * 0.95,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              child: BarChart(
                                BarChartData(
                                  maxY: title == _locale.cashierLogs ? maxY * 1.4 : maxY * 1.4,
                                  barTouchData: BarTouchData(
                                    touchTooltipData: BarTouchTooltipData(
                                      tooltipRoundedRadius: 8,
                                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                        return BarTooltipItem(
                                          title == _locale.cashierLogs
                                              ? "${Converters.formatNumber(rod.toY)}\n${xLabelsLogs[groupIndex]}"
                                              : "",
                                          const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                                        );
                                      },
                                    ),
                                  ),
                                  titlesData: FlTitlesData(
                                    rightTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 40,
                                        getTitlesWidget: (value, meta) {
                                          int index = value.toInt();
                                          if (index >= 0 &&
                                              index < (title == _locale.cashierLogs ? xLabelsLogs : []).length) {
                                            return Transform.rotate(
                                              angle: -30 * 3.14159 / 180,
                                              child: SizedBox(
                                                width: 200,
                                                child: Center(
                                                  child: Text(
                                                    title == _locale.cashierLogs ? xLabelsLogs[index] : "",
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.grey.shade700,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
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
                                        getTitlesWidget: (value, meta) => leftTitleWidgets(value),
                                        showTitles: true,
                                        reservedSize: 35,
                                      ),
                                    ),
                                    topTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                  ),
                                  gridData: FlGridData(
                                    show: true,
                                    drawVerticalLine: false,
                                    horizontalInterval: maxY * 0.2,
                                    getDrawingHorizontalLine: (value) {
                                      return const FlLine(
                                        color: Color.fromRGBO(82, 151, 176, 0.1),
                                        strokeWidth: 1,
                                      );
                                    },
                                  ),
                                  borderData: FlBorderData(
                                    border: Border.all(
                                      color: const Color.fromRGBO(82, 151, 176, 0.3),
                                    ),
                                  ),
                                  barGroups: enteredBarChartData.map((data) {
                                    return BarChartGroupData(
                                      x: data.x,
                                      barRods: data.barRods.map((rod) {
                                        return BarChartRodData(
                                          toY: rod.toY,
                                          color: const Color.fromRGBO(82, 151, 176, 1),
                                          width: 20,
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4),
                                            topRight: Radius.circular(4),
                                          ),
                                        );
                                      }).toList(),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
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

  Widget blueButton1({
    required VoidCallback onPressed,
    required Color textColor,
    required Icon icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(82, 151, 176, 0.2),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: const Color.fromRGBO(82, 151, 176, 1),
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.all(12),
            child: icon,
          ),
        ),
      ),
    );
  }
}