import 'package:bi_replicate/components/dashboard_components/pie_dashboard_chart.dart';
import 'package:bi_replicate/dialogs/fliter_dialog.dart';
import 'package:bi_replicate/model/cashier_model.dart';
import 'package:bi_replicate/model/chart/pie_chart_model.dart';

import 'package:bi_replicate/model/sales_view_model.dart';
import 'package:bi_replicate/utils/constants/app_utils.dart';
import 'package:bi_replicate/utils/constants/colors.dart';
import 'package:bi_replicate/utils/constants/responsive.dart';
import 'package:bi_replicate/utils/func/converters.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../../controller/total_sales_controller.dart';
import '../../model/sales/search_crit.dart';

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
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollController1 = ScrollController();

  double totalPricesCashierCount = 0.0;
  double totalPricesComputerCount = 0.0;
  double totalPricesHoursCount = 0.0;
  double totalPricesPayTypesCount = 0.0;
  late AppLocalizations _locale;
  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context)!;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    print("asdasdasdasda");
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
    await fetchSalesByPayTypes();
    await fetchSalesByHours();
    setState(() {});
  }

  fetchSalesByHours() async {
    totalSalesByHours.clear();
    totalPricesHoursCount = 0.0;
    barChartData.clear();
    await TotalSalesController()
        .getTotalSalesByHours(hoursSearchCriteria)
        .then((value) {
      for (var i = 0; i < value.length; i++) {
        totalSalesByHours.add(BranchSalesViewModel.fromDBModel(value[i]));
        totalPricesHoursCount +=
            double.parse(totalSalesByHours[i].displayTotalSales);
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

  fetchSalesByCashier() async {
    totalSalesByCashier.clear();
    totalPricesCashierCount = 0.0;
    await TotalSalesController()
        .getTotalSalesByCashier(cashierSearchCriteria)
        .then((value) {
      for (var i = 0; i < value.length; i++) {
        totalSalesByCashier.add(BranchSalesViewModel.fromDBModel(value[i]));
        totalPricesCashierCount +=
            double.parse(totalSalesByCashier[i].displayTotalSales);
      }
      setState(() {});
    });
  }

  fetchSalesByPayTypes() async {
    pieData.clear();
    totalPricesPayTypesCount = 0.0;
    totalSalesByPayTypes.clear();
    await TotalSalesController()
        .getTotalSalesByPaymentTypes(payTypesSearchCriteria)
        .then((value) {
      for (var i = 0; i < value.length; i++) {
        totalSalesByPayTypes.add(BranchSalesViewModel.fromDBModel(value[i]));
        totalPricesPayTypesCount +=
            double.parse(totalSalesByPayTypes[i].displayTotalSales);
        pieData.add(PieChartModel(
          title: totalSalesByPayTypes[i].displayGroupName,
          value: formatDoubleToTwoDecimalPlaces(
              double.parse(totalSalesByPayTypes[i].displayTotalSales)),
          color: getNextColor(),
        ));
      }
      setState(() {});
    });
  }

  fetchSalesByComputer() async {
    totalSalesByComputer.clear();
    totalPricesComputerCount = 0.0;
    await TotalSalesController()
        .getTotalSalesByComputer(desktopSearchCriteria)
        .then((value) {
      for (var i = 0; i < value.length; i++) {
        totalSalesByComputer.add(BranchSalesViewModel.fromDBModel(value[i]));
        totalPricesComputerCount +=
            double.parse(totalSalesByComputer[i].displayTotalSales);
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
                    dailySalesChart(
                        totalSalesByCashier, _locale.salesByCashier),
                    dailySalesChart(
                        totalSalesByComputer, _locale.salesByComputer),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    pieChart(pieData, _locale.salesByPaymentTypes),
                    // cashierTotalSales(),
                    hourTotalBarChart(barChartData, _locale.salesByHours),
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
      height: height * 0.465,
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
                            fetchSalesByCashier();
                          } else if (title == _locale.salesByComputer) {
                            desktopSearchCriteria = value;
                            fetchSalesByComputer();
                          } else if (title == _locale.salesByPaymentTypes) {
                            payTypesSearchCriteria = value;
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
                          TextStyle(fontSize: isDesktop ? 14 : height * 0.013)),
                ],
              ),
            Center(
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
      height: height * 0.465,
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
                            fetchSalesByPayTypes();
                          } else if (title == _locale.salesByHours) {
                            hoursSearchCriteria = value;
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
            SizedBox(
              height: height * 0.35,
              child: BarChart(
                BarChartData(
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
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
                            fetchSalesByCashier();
                          } else if (title == _locale.salesByComputer) {
                            desktopSearchCriteria = value;
                            fetchSalesByComputer();
                          } else if (title == _locale.salesByPaymentTypes) {
                            payTypesSearchCriteria = value;
                            fetchSalesByPayTypes();
                          } else if (title == _locale.salesByHours) {
                            hoursSearchCriteria = value;
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
            Scrollbar(
              controller: title == _locale.salesByCashier
                  ? _scrollController
                  : _scrollController1,
              thumbVisibility: true,
              thickness: 8,
              trackVisibility: true,
              radius: const Radius.circular(4),
              child: SingleChildScrollView(
                reverse: _locale.localeName == "ar" ? true : false,
                controller: title == _locale.salesByCashier
                    ? _scrollController
                    : _scrollController1,
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: height * 0.35,
                    width: Responsive.isDesktop(context)
                        ? totalSales.length > 20
                            ? width * (totalSales.length / 10)
                            : width * 0.65
                        : totalSales.length > 20
                            ? width * (totalSales.length / 10)
                            : width * 0.65,
                    child: LineChart(
                      LineChartData(
                        lineTouchData: LineTouchData(
                          touchTooltipData: LineTouchTooltipData(
                            // getTooltipColor: defaultLineTooltipColor,
                            getTooltipItems: (List<LineBarSpot> touchedSpots) {
                              return touchedSpots.map((spot) {
                                return LineTooltipItem(
                                  "${totalSales[spot.spotIndex].displayGroupName}\n${totalSales[spot.spotIndex].displayBranchName}\n${Converters.formatNumber(spot.y)}",
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
                                  double.parse(entry.value.displayTotalSales);
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
            (title == _locale.salesByComputer ||
                    title == _locale.salesByCashier)
                ? "${totalSales[value].displayGroupName} / ${totalSales[value].displayBranchName}"
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

  Widget mobileView() {
    return SizedBox(
      height: 800,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // XCard(),
            // XCard(),
            // XCard(),
            // XCard(),
            // XCard(),
            dailySalesChart(totalSalesByCashier, _locale.salesByCashier),
            dailySalesChart(totalSalesByComputer, _locale.salesByComputer),
            pieChart(pieData, _locale.salesByPaymentTypes),
            hourTotalBarChart(barChartData, _locale.salesByHours),
            // cashierTotalSales(),
          ],
        ),
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
}
