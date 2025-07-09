import 'package:bi_replicate/constants/constants.dart';
import 'package:bi_replicate/dialogs/fliter_dialog.dart';
import 'package:bi_replicate/model/cashier_model.dart';
import 'package:bi_replicate/provider/dates_provider.dart';
import 'package:bi_replicate/screen/dashboard_content/branches_sales_cat_dashboard.dart';
import 'package:bi_replicate/utils/constants/app_utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../components/dashboard_components/pie_dashboard_chart.dart';
import '../../controller/total_sales_controller.dart';
import '../../model/chart/pie_chart_model.dart';
import '../../model/sales/search_crit.dart';
import '../../model/sales_view_model.dart';
import '../../model/vouch_header_transiet_model.dart';
import '../../utils/constants/responsive.dart';
import '../../utils/func/converters.dart';
import '../../utils/func/dates_controller.dart';
import '../../widget/sidebar/custom_cards.dart';
import '../dashboard_content/bar_chart_sales_dashboard.dart';
import '../dashboard_content/daily_sales_dashboard.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double width = 0;
  double height = 0;
  bool isDesktop = false;
  late AppLocalizations locale;
  double maxY = 0.0;
  VouchHeaderTransietModel vouchHeaderTransietModel = VouchHeaderTransietModel(
      paidSales: 0, returnSales: 0.0, numOfCustomers: 0);
  String fromDateEn = DatesController().formatDate(DatesController().currentMonth());
  String fromDateAr = DatesController().formatDateReverse(DatesController().formatDate(DatesController().currentMonth()));
  String toDateEn = DatesController().formatDate(DatesController().todayDate());
  String toDateAr = DatesController().formatDateReverse(DatesController().formatDate(DatesController().todayDate()));
  List<PieChartModel> pieData = [];
  double totalPricesPayTypesCount = 0.0;
  List<BranchSalesViewModel> totalSalesByPayTypes = [];
  SearchCriteria payTypesSearchCriteria = SearchCriteria(
      branch: "all",
      shiftStatus: "all",
      transType: "all",
      cashier: "all",
      fromDate: "",
      toDate: "");
  int colorIndex = 0;
  DateTime now = DateTime.now();
  List<BarChartGroupData> barChartData = [];
  String formattedFromDate = "";
  String formattedToDate = "";
  ScrollController _scrollController2 = ScrollController();
  bool isLoading = true;
  late DatesProvider dateProvider;

  @override
  void didChangeDependencies() {
    locale = AppLocalizations.of(context)!;
    payTypesSearchCriteria.chartType = locale.pieChart;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    formattedFromDate = DateFormat('dd/MM/yyyy').format(DateTime(now.year, now.month, 1));
    formattedToDate = DateFormat('dd/MM/yyyy').format(now);
    formattedFromDate = context.read<DatesProvider>().sessionFromDate.isNotEmpty
        ? context.read<DatesProvider>().sessionFromDate
        : formattedFromDate;
    formattedToDate = context.read<DatesProvider>().sessionToDate.isNotEmpty
        ? context.read<DatesProvider>().sessionToDate
        : formattedToDate;
    payTypesSearchCriteria = SearchCriteria(
        branch: "all",
        shiftStatus: "all",
        transType: "all",
        cashier: "all",
        fromDate: formattedFromDate,
        toDate: formattedToDate);
    fetchSalesByPayTypes();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController2.dispose();
    super.dispose();
  }

  void _onDateRangeChanged() {
    if (dateProvider.sessionFromDate != "" && dateProvider.sessionToDate != "") {
      formattedFromDate = context.read<DatesProvider>().sessionFromDate.isNotEmpty
          ? context.read<DatesProvider>().sessionFromDate
          : formattedFromDate;
      formattedToDate = context.read<DatesProvider>().sessionToDate.isNotEmpty
          ? context.read<DatesProvider>().sessionToDate
          : formattedToDate;
      payTypesSearchCriteria = SearchCriteria(
          branch: "all",
          shiftStatus: "all",
          transType: "all",
          cashier: "all",
          fromDate: formattedFromDate,
          toDate: formattedToDate);
      fetchSalesByPayTypes();
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    isDesktop = Responsive.isDesktop(context);

    return isDesktop ? desktopDashboard() : mobileDashboard();
  }

  Widget desktopDashboard() {
    final screenHeight = MediaQuery.of(context).size.height;
    final usableHeight = screenHeight - kToolbarHeight - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom;
    final cardHeight = (usableHeight - 28) / 2;

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: cardHeight,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: CustomCards(
                    height: cardHeight,
                    content: const DailySalesDashboard(),
                  ),
                ),
                SizedBox(width: width * 0.003),
                payTypesSearchCriteria.chartType == locale.pieChart
                    ? totalSalesByPayTypes.length <= 4
                        ? pieChart(pieData, locale.salesByPaymentTypes, cardHeight)
                        : salesByPaymentTypesBarChart(locale.salesByPaymentTypes, cardHeight)
                    : salesByPaymentTypesBarChart(locale.salesByPaymentTypes, cardHeight),
              ],
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: cardHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: CustomCards(
                    height: cardHeight,
                    content: const BalanceBarChartDashboard(),
                  ),
                ),
                SizedBox(width: width * 0.003),
                Expanded(
                  flex: 3,
                  child: CustomCards(
                    height: cardHeight,
                    content: const BranchesSalesByCatDashboard(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget mobileDashboard() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: payTypesSearchCriteria.chartType == locale.pieChart
                    ? totalSalesByPayTypes.length <= 4
                        ? pieChart(pieData, locale.salesByPaymentTypes, height * 0.6)
                        : salesByPaymentTypesBarChart(locale.salesByPaymentTypes, height * 0.6)
                    : salesByPaymentTypesBarChart(locale.salesByPaymentTypes, height * 0.6),
              ),
            ],
          ),
          SizedBox(height: height * 0.01),
          Row(
            children: [
              Expanded(
                child: CustomCards(
                  height: height * 0.6,
                  content: const DailySalesDashboard(),
                ),
              ),
            ],
          ),
          SizedBox(height: height * 0.01),
          Row(
            children: [
              Expanded(
                child: CustomCards(
                  height: height * 0.6,
                  content: const BalanceBarChartDashboard(),
                ),
              ),
            ],
          ),
          SizedBox(height: height * 0.01),
          Row(
            children: [
              Expanded(
                child: CustomCards(
                  height: height * 0.6,
                  content: const BranchesSalesByCatDashboard(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget pieChart(List<PieChartModel> pieData, String title, double cardHeight) {
    return Expanded(
      flex: 1,
      child: Container(
        height: cardHeight,
        constraints: BoxConstraints(
          minHeight: 250,
          maxHeight: cardHeight,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              spreadRadius: 1,
              offset: const Offset(0, 8),
              blurRadius: 10,
              color: Colors.grey.withOpacity(0.3),
            )
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                      child: Row(
                        children: [
                          Container(
                            width: 4,
                            height: 16,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(82, 151, 176, 1),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontSize: isDesktop ? 14 : 16,
                                fontWeight: FontWeight.w600,
                                color: const Color.fromRGBO(82, 151, 176, 1),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(82, 151, 176, 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '(\u200E${NumberFormat('#,###', 'en_US').format(totalPricesPayTypesCount)})',
                              style: TextStyle(
                                fontSize: isDesktop ? 10 : 12,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromRGBO(82, 151, 176, 1),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "(${payTypesSearchCriteria.fromDate} - ${payTypesSearchCriteria.toDate})",
                            style: TextStyle(
                              fontSize: isDesktop ? 10 : 11,
                              color: Colors.grey.shade600,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    blueButton1(
                      onPressed: () async {
                        List<CashierModel> cashiers = [];
                        if (title == locale.cashierLogs) {
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
                                  filter: title == locale.salesByPaymentTypes
                                      ? payTypesSearchCriteria
                                      : payTypesSearchCriteria,
                                  hint: title);
                            },
                          ).then((value) {
                            if (value != false) {
                              if (title == locale.salesByPaymentTypes) {
                                payTypesSearchCriteria = value;
                                isLoading = true;
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
                        size: isDesktop ? height * 0.025 : height * 0.022,
                      ),
                    ),
                  ],
                ),
              ),
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
                      : pieData.isNotEmpty
                          ? LayoutBuilder(
                              builder: (context, constraints) {
                                final availableSize = constraints.biggest;
                                final chartSize = availableSize.shortestSide * 0.7; // Reduced to avoid overflow
                                return Center(
                                  child: SizedBox(
                                    height: chartSize,
                                    width: chartSize,
                                    child: PieDashboardChart(
                                      dataList: pieData,
                                    ),
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.pie_chart_outline,
                                    size: 48,
                                    color: Colors.grey.shade400,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    locale.noDataAvailable,
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
      ),
    );
  }

  Widget salesByPaymentTypesBarChart(String title, double cardHeight) {
    return Expanded(
      flex: 1,
      child: Container(
        height: cardHeight,
        constraints: BoxConstraints(
          minHeight: 250,
          maxHeight: cardHeight,
        ),
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                      child: Row(
                        children: [
                          Container(
                            width: 4,
                            height: 16,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(82, 151, 176, 1),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontSize: isDesktop ? 14 : 16,
                                fontWeight: FontWeight.w600,
                                color: const Color.fromRGBO(82, 151, 176, 1),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(82, 151, 176, 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '(\u200E${NumberFormat('#,###', 'en_US').format(totalPricesPayTypesCount)})',
                              style: TextStyle(
                                fontSize: isDesktop ? 10 : 12,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromRGBO(82, 151, 176, 1),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "(${payTypesSearchCriteria.fromDate} - ${payTypesSearchCriteria.toDate})",
                            style: TextStyle(
                              fontSize: isDesktop ? 10 : 11,
                              color: Colors.grey.shade600,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    blueButton1(
                      onPressed: () async {
                        List<CashierModel> cashiers = [];
                        if (title == locale.cashierLogs) {
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
                                  filter: title == locale.salesByPaymentTypes
                                      ? payTypesSearchCriteria
                                      : payTypesSearchCriteria,
                                  hint: title);
                            },
                          ).then((value) {
                            if (value != false) {
                              if (title == locale.salesByPaymentTypes) {
                                payTypesSearchCriteria = value;
                                isLoading = true;
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
                        size: isDesktop ? height * 0.025 : height * 0.022,
                      ),
                    ),
                  ],
                ),
              ),
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
                      : barChartData.isNotEmpty
                          ? LayoutBuilder(
                              builder: (context, constraints) {
                                // Calculate chart width based on data length
                                final chartWidth = isDesktop
                                    ? barChartData.length > 20
                                        ? constraints.maxWidth * (barChartData.length / 20)
                                        : constraints.maxWidth
                                    : barChartData.length > 5
                                        ? constraints.maxWidth * (barChartData.length / 10)
                                        : constraints.maxWidth;
                                // Show Scrollbar only if content exceeds available width
                                return Scrollbar(
                                  controller: chartWidth > constraints.maxWidth ? _scrollController2 : null,
                                  thumbVisibility: chartWidth > constraints.maxWidth,
                                  trackVisibility: chartWidth > constraints.maxWidth,
                                  thickness: 6,
                                  radius: const Radius.circular(8),
                                  child: SingleChildScrollView(
                                    reverse: locale.localeName == "ar" ? true : false,
                                    controller: _scrollController2,
                                    scrollDirection: Axis.horizontal,
                                    child: SizedBox(
                                      height: constraints.maxHeight,
                                      width: chartWidth,
                                      child: BarChart(
                                        BarChartData(
                                          maxY: maxY * 1.4,
                                          barTouchData: BarTouchData(
                                            touchTooltipData: BarTouchTooltipData(
                                              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                                return BarTooltipItem(
                                                  "${Converters.formatNumber(rod.toY)}\n${xLabels[groupIndex]}",
                                                  const TextStyle(color: Colors.white),
                                                );
                                              },
                                            ),
                                          ),
                                          titlesData: FlTitlesData(
                                            rightTitles: AxisTitles(
                                              sideTitles: SideTitles(showTitles: false),
                                            ),
                                            bottomTitles: AxisTitles(
                                              sideTitles: SideTitles(
                                                showTitles: true,
                                                reservedSize: 40,
                                                getTitlesWidget: (value, meta) {
                                                  int index = value.toInt();
                                                  if (index >= 0 && index < xLabels.length) {
                                                    return Transform.rotate(
                                                      angle: -30 * 3.14159 / 180,
                                                      child: SizedBox(
                                                        width: 200,
                                                        child: Center(
                                                          child: Text(
                                                            xLabels[index],
                                                            style: TextStyle(fontSize: 12),
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
                                            topTitles: AxisTitles(
                                              sideTitles: SideTitles(showTitles: false),
                                            ),
                                          ),
                                          barGroups: barChartData,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
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
                                    locale.noDataAvailable,
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
      ),
    );
  }

  Widget leftTitleWidgets(double value) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );
    return Text(
      "\u200E${Converters.formatTitleNumber(value)}",
      style: style,
      textAlign: TextAlign.left,
    );
  }

  List<String> xLabels = [];

  fetchSalesByPayTypes() async {
    pieData.clear();
    totalPricesPayTypesCount = 0.0;
    totalSalesByPayTypes.clear();
    barChartData.clear();

    await TotalSalesController().getTotalSalesByPaymentTypes(payTypesSearchCriteria).then((value) {
      isLoading = false;
      for (var i = 0; i < value.length; i++) {
        totalSalesByPayTypes.add(BranchSalesViewModel.fromDBModel(value[i]));
        totalPricesPayTypesCount += double.parse(totalSalesByPayTypes[i].displayTotalSales);
        if (double.parse(totalSalesByPayTypes[i].displayTotalSales) > maxY) {
          maxY = double.parse(totalSalesByPayTypes[i].displayTotalSales);
        }
        pieData.add(PieChartModel(
          title: totalSalesByPayTypes[i].displayGroupName,
          value: formatDoubleToTwoDecimalPlaces(double.parse(totalSalesByPayTypes[i].displayTotalSales)),
          color: getNextColor(),
        ));
        xLabels = totalSalesByPayTypes.map((e) => e.displayGroupName).toList();

        barChartData = List.generate(totalSalesByPayTypes.length, (index) {
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: double.parse(totalSalesByPayTypes[index].displayTotalSales),
                borderRadius: BorderRadius.all(Radius.zero),
              ),
            ],
          );
        });
      }
      setState(() {});
    });
  }

  double formatDoubleToTwoDecimalPlaces(double number) {
    return double.parse(number.toStringAsFixed(2));
  }

  Color getNextColor() {
    final color = colorListDashboard[colorIndex];
    colorIndex = (colorIndex + 1) % colorListDashboard.length;
    return color;
  }
}