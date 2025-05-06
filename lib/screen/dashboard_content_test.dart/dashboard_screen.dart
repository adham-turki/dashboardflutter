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
  String fromDateEn =
      DatesController().formatDate(DatesController().currentMonth());
  String fromDateAr = DatesController().formatDateReverse(
      DatesController().formatDate(DatesController().currentMonth()));
  String toDateEn = DatesController().formatDate(DatesController().todayDate());
  String toDateAr = DatesController().formatDateReverse(
      DatesController().formatDate(DatesController().todayDate()));
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
  @override
  void didChangeDependencies() {
    locale = AppLocalizations.of(context)!;
    payTypesSearchCriteria.chartType = locale.pieChart;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    formattedFromDate =
        DateFormat('dd/MM/yyyy').format(DateTime(now.year, now.month, 1));
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
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    isDesktop = Responsive.isDesktop(context);

    return isDesktop ? desktopDashboard() : mobileDashboard();
  }

  Widget desktopDashboard() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: CustomCards(
                height: height * 0.47,
                content: const DailySalesDashboard(),
              ),
            ),
            SizedBox(
              width: width * 0.003,
            ),
            payTypesSearchCriteria.chartType == locale.pieChart
                ? totalSalesByPayTypes.length <= 4
                    ? pieChart(pieData, locale.salesByPaymentTypes)
                    : salesByPaymentTypesBarChart(locale.salesByPaymentTypes)
                : salesByPaymentTypesBarChart(locale.salesByPaymentTypes),
          ],
        ),
        SizedBox(
          height: height * 0.005,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: CustomCards(
                height: height * 0.47,
                content: const BalanceBarChartDashboard(),
              ),
            ),
            SizedBox(
              width: width * 0.002,
            ),
            Expanded(
              flex: 3,
              child: CustomCards(
                height: height * 0.47,
                content: const BranchesSalesByCatDashboard(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget mobileDashboard() {
    return Column(
      children: [
        Row(
          children: [
            payTypesSearchCriteria.chartType == locale.pieChart
                ? totalSalesByPayTypes.length <= 4
                    ? pieChart(pieData, locale.salesByPaymentTypes)
                    : salesByPaymentTypesBarChart(locale.salesByPaymentTypes)
                : salesByPaymentTypesBarChart(locale.salesByPaymentTypes),
          ],
        ),
        SizedBox(
          height: height * 0.009,
        ),
        Row(
          children: [
            Expanded(
              child: CustomCards(
                height: height * 0.5,
                content: const DailySalesDashboard(),
              ),
            )
          ],
        ),
        SizedBox(
          height: height * 0.01,
        ),
        Row(
          children: [
            Expanded(
              child: CustomCards(
                height: height * 0.5,
                content: const BalanceBarChartDashboard(),
              ),
            )
          ],
        ),
        SizedBox(
          height: height * 0.01,
        ),
        Row(
          children: [
            Expanded(
              child: CustomCards(
                height: height * 0.5,
                content: const BranchesSalesByCatDashboard(),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget pieChart(List<PieChartModel> pieData, String title) {
    return Expanded(
      flex: 1,
      child: CustomCards(
        height: height * 0.47,
        content: Column(
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
                          style: TextStyle(fontSize: isDesktop ? 15 : 18),
                        ),
                        title == locale.salesByPaymentTypes
                            ? Text(
                                '(\u200E${NumberFormat('#,###', 'en_US').format(totalPricesPayTypesCount)})',
                                // "(${Converters.formatNumber(totalPricesPayTypesCount)})",
                              )
                            : SizedBox.shrink()
                      ],
                    ),
                  ],
                ),
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
                    size: isDesktop ? height * 0.035 : height * 0.03,
                  ),
                )
              ],
            ),
            if (title == locale.salesByPaymentTypes)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                      "(${payTypesSearchCriteria.fromDate} - ${payTypesSearchCriteria.toDate})",
                      style:
                          TextStyle(fontSize: isDesktop ? 10 : height * 0.013)),
                ],
              ),
            (title == locale.salesByPaymentTypes && isLoading)
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

  List<String> xLabels = [];
  fetchSalesByPayTypes() async {
    pieData.clear();
    totalPricesPayTypesCount = 0.0;
    totalSalesByPayTypes.clear();
    barChartData.clear();

    await TotalSalesController()
        .getTotalSalesByPaymentTypes(payTypesSearchCriteria)
        .then((value) {
      isLoading = false;
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

        barChartData = List.generate(totalSalesByPayTypes.length, (index) {
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

  double formatDoubleToTwoDecimalPlaces(double number) {
    return double.parse(number.toStringAsFixed(2));
  }

  Color getNextColor() {
    final color = colorListDashboard[colorIndex];
    colorIndex = (colorIndex + 1) % colorListDashboard.length;
    return color;
  }

  Widget salesByPaymentTypesBarChart(String title) {
    return Expanded(
      flex: 1,
      child: SizedBox(
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
                          Text(
                              '(\u200E${NumberFormat('#,###', 'en_US').format(totalPricesPayTypesCount)})',
                              style: TextStyle(fontSize: isDesktop ? 15 : 18)),
                        ],
                      ),
                    ],
                  ),
                  blueButton1(
                    onPressed: () async {
                      List<CashierModel> cashiers = [];
                      if (title == locale.cashierLogs) {
                        cashiers =
                            await TotalSalesController().getAllCashiers();
                      }
                      await TotalSalesController()
                          .getAllBranches()
                          .then((value) {
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
                      size: isDesktop ? height * 0.035 : height * 0.03,
                    ),
                  )
                ],
              ),
              if (title == locale.salesByPaymentTypes)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                        "(${payTypesSearchCriteria.fromDate} - ${payTypesSearchCriteria.toDate})",
                        style: TextStyle(
                            fontSize: isDesktop ? 14 : height * 0.013)),
                  ],
                ),
              (title == locale.salesByPaymentTypes && isLoading)
                  ? SizedBox(
                      height: height * 0.35,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Scrollbar(
                      controller: _scrollController2,
                      thumbVisibility: true,
                      thickness: 8,
                      trackVisibility: true,
                      radius: const Radius.circular(4),
                      child: SingleChildScrollView(
                        reverse: locale.localeName == "ar" ? true : false,
                        controller: _scrollController2,
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: height * 0.35,
                            width: Responsive.isDesktop(context)
                                ? barChartData.length > 20
                                    ? width * (barChartData.length / 10)
                                    : width * 0.3
                                : barChartData.length > 5
                                    ? width * (barChartData.length / 5)
                                    : width * 0.95,
                            child: BarChart(
                              BarChartData(
                                  maxY: maxY * 1.4,
                                  barTouchData: BarTouchData(
                                    touchTooltipData: BarTouchTooltipData(
                                      getTooltipItem:
                                          (group, groupIndex, rod, rodIndex) {
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
                                          if (index >= 0 &&
                                              index < xLabels.length) {
                                            return Transform.rotate(
                                              angle: -30 *
                                                  3.14159 /
                                                  180, // 90 degrees in radians
                                              child: SizedBox(
                                                width: 200,
                                                child: Center(
                                                  child: Text(xLabels[index],
                                                      style: TextStyle(
                                                          fontSize: 12)),
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
}
