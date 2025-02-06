import 'package:bi_replicate/constants/api_constants.dart';
import 'package:bi_replicate/model/chart/chart_data_model.dart';
import 'package:bi_replicate/model/sales/sales_cost_based_stock_cat_db_model.dart';
import 'package:bi_replicate/model/sales/sales_cost_based_stock_cat_view_model.dart';
import 'package:bi_replicate/model/sales_view_model.dart';
import 'package:bi_replicate/model/total_profit_report_model.dart';
import 'package:bi_replicate/provider/screen_content_provider.dart';
import 'package:bi_replicate/utils/constants/app_utils.dart';

import 'package:bi_replicate/utils/constants/responsive.dart';
import 'package:bi_replicate/components/dashboard_components/pie_dashboard_chart.dart';
import 'package:bi_replicate/dialogs/fliter_dialog.dart';
import 'package:bi_replicate/model/cashier_model.dart';
import 'package:bi_replicate/model/chart/pie_chart_model.dart';
import 'package:bi_replicate/utils/func/converters.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
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
  late TooltipBehavior _tooltip;
  List<BranchSalesViewModel> totalCashierLogsList = [];
  double totalCashierLogs = 0.0;
  List<SalesCostBasedStockCategoryViewModel> salesCostBasedStkCatList = [];
  double salesCostBasedStkCatCount = 0.0;

  final ScrollController _scrollController1 = ScrollController();
  double minValue = 0;
  double maxValue = 0;
  double interval = 0;
  double secondaryMinValue = 0;
  double secondaryMaxValue = 0;
  double secondaryInterval = 0;

  fetchSalesByCashierLogs() async {
    totalCashierLogsList.clear();
    totalCashierLogs = 0.0;
    await TotalSalesController()
        .getCashierLogs(cashierLogsSearchCriteria)
        .then((value) {
      for (var i = 0; i < value.length; i++) {
        totalCashierLogsList.add(BranchSalesViewModel.fromDBModel(value[i]));
        totalCashierLogs +=
            double.parse(totalCashierLogsList[i].displayLogsCount);
      }

      print("totalCashierLogsList: ${totalCashierLogsList.length}");
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context)!;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    print("asdasdasdasda");

    _tooltip = TooltipBehavior(enable: true);
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

    cashierLogsSearchCriteria = SearchCriteria(
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
    await fetchSalesByCashierLogs();
    setState(() {});
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
                      dailySalesChart(
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
                      dailySalesChart(
                          totalCashierLogsList, _locale.cashierLogs),
                    ],
                  ))
            ],
          )
        ],
      ),
    );
  }

  Widget dailySalesChart(List<BranchSalesViewModel> totalSales, String title) {
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
                        title == _locale.cashierLogs
                            ? Text(
                                " (${Converters.formatNumberRounded(double.parse(Converters.formatNumberDigits(totalCashierLogs)))})")
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
                        "(${cashierLogsSearchCriteria.fromDate} - ${cashierLogsSearchCriteria.toDate})",
                        style: TextStyle(fontSize: isDesktop ? 13 : 16)),
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
                              filter: title == _locale.cashierLogs
                                  ? cashierLogsSearchCriteria
                                  : cashierLogsSearchCriteria,
                              hint: title);
                        },
                      ).then((value) {
                        if (value != false) {
                          if (title == _locale.cashierLogs) {
                            cashierLogsSearchCriteria = value;
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
                    size: isDesktop ? height * 0.035 : height * 0.03,
                  ),
                )
              ],
            ),
            if (!Responsive.isDesktop(context))
              if (title == _locale.cashierLogs)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                        "(${cashierLogsSearchCriteria.fromDate} - ${cashierLogsSearchCriteria.toDate})",
                        style: TextStyle(fontSize: height * 0.013)),
                  ],
                ),
            Scrollbar(
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
                      ? totalSales.length > 20
                          ? width * (totalSales.length / 10)
                          : width * 0.82
                      : totalSales.length > 20
                          ? width * (totalSales.length / 10)
                          : width * 0.82,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 20.0),
                    child: LineChart(
                      LineChartData(
                        lineTouchData: LineTouchData(
                          touchTooltipData: LineTouchTooltipData(
                            // getTooltipColor: defaultLineTooltipColor,
                            getTooltipItems: (List<LineBarSpot> touchedSpots) {
                              return touchedSpots.map((spot) {
                                return LineTooltipItem(
                                  "${totalSales[spot.spotIndex].displayGroupName}\n${totalSales[spot.spotIndex].displaytransTypeName}\n${Converters.formatNumber(spot.y)}",
                                  const TextStyle(color: Colors.white),
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
                            getTitlesWidget: (value, meta) =>
                                leftTitleWidgets(value),
                            showTitles: true,
                            reservedSize: 35,
                          )),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              getTitlesWidget: (value, meta) => groupNameTitle(
                                  value.toInt(), totalSales, title),
                            ),
                          ),
                        ),
                        borderData: FlBorderData(
                            border: Border.all(
                                color:
                                    const Color.fromARGB(255, 125, 125, 125))),
                        lineBarsData: [
                          LineChartBarData(
                            belowBarData: BarAreaData(
                                show: true,
                                color: Colors.blue.withOpacity(0.5)),
                            isCurved: true,
                            preventCurveOverShooting: true,
                            spots: totalSales.asMap().entries.map((entry) {
                              int index = entry.key;
                              double totalSales =
                                  double.parse(entry.value.displayLogsCount);
                              print("totalSales: ${totalSales}");

                              return FlSpot(index.toDouble(), totalSales);
                            }).toList(),
                          ),
                        ],
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
          width: 50,
          child: Text(
            (title == _locale.cashierLogs)
                ? "${totalSales[value].displayGroupName} / ${totalSales[value].displaytransTypeName}"
                : totalSales[value].displayGroupName,
            style: const TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 8,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
        ),
      );
    } else {
      return const Text('');
    }
  }
}
