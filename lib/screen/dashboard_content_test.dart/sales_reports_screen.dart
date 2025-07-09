import 'dart:async';
import 'dart:ui' as ui;
import 'package:bi_replicate/components/dashboard_components/pie_dashboard_chart.dart';
import 'package:bi_replicate/dialogs/fliter_dialog.dart';
import 'package:bi_replicate/model/cashier_model.dart';
import 'package:bi_replicate/model/chart/pie_chart_model.dart';
import 'package:bi_replicate/model/computer_model.dart';
import 'dart:math' as math;

import 'package:bi_replicate/model/sales_view_model.dart';
import 'package:bi_replicate/provider/dates_provider.dart';
import 'package:bi_replicate/provider/screen_content_provider.dart';
import 'package:bi_replicate/utils/constants/app_utils.dart';
import 'package:bi_replicate/utils/constants/colors.dart';
import 'package:bi_replicate/utils/constants/responsive.dart';
import 'package:bi_replicate/utils/func/converters.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
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
  late DatesProvider dateProvider;

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

    formattedToDate = DateFormat('dd/MM/yyyy').format(now);
    formattedFromDate = context.read<DatesProvider>().sessionFromDate.isNotEmpty
        ? context.read<DatesProvider>().sessionFromDate
        : formattedFromDate;
    formattedToDate = context.read<DatesProvider>().sessionToDate.isNotEmpty
        ? context.read<DatesProvider>().sessionToDate
        : formattedToDate;
    print("formattedDate: ${formattedFromDate}");
    print("formattedDate: ${formattedToDate}");
    salesCostBasedBranchReportCrit = SearchCriteria(
        branch: "all",
        shiftStatus: "all",
        transType: "all",
        cashier: "all",
        fromDate: formattedFromDate,
        toDate: formattedToDate);
    // formattedFromDate =
    //     DateFormat('dd/MM/yyyy').format(DateTime(now.year, now.month, 1));
    // formattedToDate = DateFormat('dd/MM/yyyy').format(now);
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
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   dateProvider = Provider.of<DatesProvider>(context, listen: false);
    //   dateProvider.onDatesChanged = () {
    //     fetchData();
    //   };
    // });
    fetchData();
    super.initState();
  }

  // void _onDateRangeChanged() {
  //   formattedToDate = DateFormat('dd/MM/yyyy').format(now);
  //   formattedFromDate = context.read<DatesProvider>().sessionFromDate.isNotEmpty
  //       ? context.read<DatesProvider>().sessionFromDate
  //       : formattedFromDate;
  //   formattedToDate = context.read<DatesProvider>().sessionToDate.isNotEmpty
  //       ? context.read<DatesProvider>().sessionToDate
  //       : formattedToDate;
  //   print("formattedDate: ${formattedFromDate}");
  //   print("formattedDate: ${formattedToDate}");
  //   salesCostBasedBranchReportCrit = SearchCriteria(
  //       branch: "all",
  //       shiftStatus: "all",
  //       transType: "all",
  //       cashier: "all",
  //       fromDate: formattedFromDate,
  //       toDate: formattedToDate);
  //   // formattedFromDate =
  //   //     DateFormat('dd/MM/yyyy').format(DateTime(now.year, now.month, 1));
  //   // formattedToDate = DateFormat('dd/MM/yyyy').format(now);
  //   cashierSearchCriteria = SearchCriteria(
  //       branch: "all",
  //       shiftStatus: "all",
  //       transType: "all",
  //       cashier: "all",
  //       fromDate: formattedFromDate,
  //       toDate: formattedToDate);
  //   payTypesSearchCriteria = SearchCriteria(
  //       branch: "all",
  //       shiftStatus: "all",
  //       transType: "all",
  //       cashier: "all",
  //       fromDate: formattedFromDate,
  //       toDate: formattedToDate);
  //   hoursSearchCriteria = SearchCriteria(
  //       branch: "all",
  //       shiftStatus: "all",
  //       transType: "all",
  //       cashier: "all",
  //       fromDate: formattedFromDate,
  //       toDate: formattedToDate);
  //   desktopSearchCriteria = SearchCriteria(
  //       branch: "all",
  //       shiftStatus: "all",
  //       transType: "all",
  //       cashier: "all",
  //       fromDate: formattedFromDate,
  //       toDate: formattedToDate);
  //   isLoading = true;
  //   isLoading1 = true;
  //   isLoading2 = true;
  //   isLoading3 = true;
  //   fetchData();
  // }

  
@override
void dispose() {
  _timer?.cancel(); // Cancel any running timer
  _scrollController.dispose();
  _scrollController1.dispose();
  _scrollController2.dispose();
  _scrollController3.dispose();
  super.dispose();
}

  fetchData() async {
    await fetchSalesByCashier();
    await fetchSalesByComputer();
    await fetchsalesCostBasedBranchReportList();
    await fetchSalesByHours();
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
    maxYHours = 0.0;
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
  if (!mounted) return; // Add mounted check
  
  totalSalesByComputer.clear();
  totalPricesComputerCount = 0.0;
  maxYByComputer = 0.0;
  barChartDataComputer.clear(); // Clear before rebuilding
  xLabelsComputer.clear(); // Clear before rebuilding
  
  await TotalSalesController()
      .getTotalSalesByComputer(desktopSearchCriteria)
      .then((value) {
    if (!mounted) return; // Add mounted check
    
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
    }
    
    // Rebuild labels and chart data together
    xLabelsComputer = totalSalesByComputer.map((e) => e.displayGroupName).toList();
    barChartDataComputer = List.generate(totalSalesByComputer.length, (index) {
      return BarChartGroupData(
        x: index, // Use index as x-value
        barRods: [
          BarChartRodData(
            toY: double.parse(totalSalesByComputer[index].displayTotalSales),
            borderRadius: BorderRadius.all(Radius.zero),
          ),
        ],
      );
    });
    
    if (mounted) {
      setState(() {});
    }
  });
}
Widget _buildEmptyChartContent(AppLocalizations _locale) {
  return Center(
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
  );
}
// 2. Fix for fetchSalesByCashier method to ensure proper data synchronization
fetchSalesByCashier() async {
  if (!mounted) return; // Add mounted check
  
  totalSalesByCashier.clear();
  totalPricesCashierCount = 0.0;
  maxYByCashier = 0.0;
  barChartDataCashier.clear(); // Clear before rebuilding
  xLabelsCashier.clear(); // Clear before rebuilding

  await TotalSalesController()
      .getTotalSalesByCashier(cashierSearchCriteria)
      .then((value) {
    if (!mounted) return; // Add mounted check
    
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
    }
    
    // Rebuild labels and chart data together
    xLabelsCashier = totalSalesByCashier.map((e) => e.displayGroupName).toList();
    barChartDataCashier = List.generate(totalSalesByCashier.length, (index) {
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
    
    if (mounted) {
      setState(() {});
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
                            _locale.salesByCashier,
                            barChartDataCashier,
                            context,
                            _locale,
                            isDesktop,
                            height,
                            width,
                            _scrollController,
                            isLoading,
                            xLabelsCashier)
                        : dailySalesChart(
                            totalSalesByCashier,
                            _locale.salesByCashier,
                            maxYByCashier,
                            context,
                            _locale,
                            isDesktop,
                            height,
                            _scrollController,
                            isLoading),
                    desktopSearchCriteria.chartType == _locale.barChart
                        ? salesByPaymentTypesBarChart(
                            _locale.salesByComputer,
                            barChartDataComputer,
                            context,
                            _locale,
                            isDesktop,
                            height,
                            width,
                            _scrollController1,
                            isLoading1,
                            xLabelsComputer)
                        : dailySalesChart(
                            totalSalesByComputer,
                            _locale.salesByComputer,
                            maxYByComputer,
                            context,
                            _locale,
                            isDesktop,
                            height,
                            _scrollController1,
                            isLoading1),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    salesCostBasedBranchChart(
                        data1, _locale.salesCostBasedBranch),
                    hoursSearchCriteria.chartType == _locale.lineChart
                        ? dailySalesChart(
                            totalSalesByHours,
                            _locale.salesByHours,
                            maxYHours,
                            context,
                            _locale,
                            isDesktop,
                            height,
                            _scrollController3,
                            isLoading3)
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
                                '(\u200E${NumberFormat('#,###', 'en_US').format(totalPricesCashierCount)})',
                                style: TextStyle(fontSize: isDesktop ? 13 : 16))
                            : title == _locale.salesByComputer
                                ? Text(
                                    '(\u200E${NumberFormat('#,###', 'en_US').format(totalPricesComputerCount)})',
                                    style: TextStyle(
                                        fontSize: isDesktop ? 13 : 16))
                                : title == _locale.salesByPaymentTypes
                                    ? Text(
                                        '(\u200E${NumberFormat('#,###', 'en_US').format(totalPricesPayTypesCount)})',
                                        style: TextStyle(
                                            fontSize: isDesktop ? 13 : 16))
                                    : SizedBox.shrink()
                      ],
                    ),
                  ],
                ),
                blueButton1(
                  onPressed: () async {
                    List<CashierModel> cashiers = [];
                    if (title == _locale.salesByCashier) {
                      cashiers = await TotalSalesController().getAllCashiers();
                    }
                    List<ComputerModel> computers = [];
                    if (title == _locale.salesByComputer) {
                      computers = await TotalSalesController().getComputers("");
                    }
                    await TotalSalesController().getAllBranches().then((value) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return FilterDialog(
                              cashiers: cashiers,
                              computers: computers,
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                            height: 16,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(82, 151, 176, 1),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          SelectableText(
                            title,
                            style: TextStyle(
                              fontSize: isDesktop ? 14 : 16,
                              fontWeight: FontWeight.w600,
                              color: const Color.fromRGBO(82, 151, 176, 1),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(82, 151, 176, 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '\u200E${NumberFormat('#,###', 'en_US').format(totalPricesHoursCount)}',
                              style: TextStyle(
                                fontSize: isDesktop ? 10 : 12,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromRGBO(82, 151, 176, 1),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (Responsive.isDesktop(context))
                        Padding(
                          padding: const EdgeInsets.only(top: 4, left: 12),
                          child: Text(
                            "(${hoursSearchCriteria.fromDate} - ${hoursSearchCriteria.toDate})",
                            style: TextStyle(
                              fontSize: isDesktop ? 10 : 12,
                              color: Colors.grey.shade600,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                blueButton1(
                  onPressed: () async {
                    List<CashierModel> cashiers = [];
                    List<ComputerModel> computers = [];
                    await TotalSalesController().getAllBranches().then((value) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return FilterDialog(
                            cashiers: cashiers,
                            computers: computers,
                            branches: value,
                            filter: hoursSearchCriteria,
                            hint: title,
                          );
                        },
                      ).then((value) {
                        if (value != false) {
                          hoursSearchCriteria = value;
                          isLoading3 = true;
                          setState(() {});
                          fetchSalesByHours();
                        }
                      });
                    });
                  },
                  textColor: const Color.fromARGB(255, 255, 255, 255),
                  icon: Icon(
                    Icons.filter_list_sharp,
                    color: Colors.white,
                    size: isDesktop ? height * 0.025 : height * 0.02,
                  ),
                ),
              ],
            ),
          ),
          if (!Responsive.isDesktop(context))
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "(${hoursSearchCriteria.fromDate} - ${hoursSearchCriteria.toDate})",
                    style: TextStyle(
                      fontSize: height * 0.011,
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: isLoading3
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color.fromRGBO(82, 151, 176, 1),
                        strokeWidth: 3,
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
          ),
        ],
      ),
    ),
  );
}
Widget dailySalesChart(
    List<BranchSalesViewModel> totalSales,
    String title,
    double maxY,
    BuildContext context,
    AppLocalizations _locale,
    bool isDesktop,
    double height,
    ScrollController _scrollController,
    bool isLoading) {
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                            height: 16,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(82, 151, 176, 1),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          SelectableText(
                            title,
                            style: TextStyle(
                              fontSize: isDesktop ? 14 : 16,
                              fontWeight: FontWeight.w600,
                              color: const Color.fromRGBO(82, 151, 176, 1),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(82, 151, 176, 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              title == _locale.salesByCashier
                                  ? '\u200E${NumberFormat('#,###', 'en_US').format(totalPricesCashierCount)}'
                                  : title == _locale.salesByComputer
                                      ? '\u200E${NumberFormat('#,###', 'en_US').format(totalPricesComputerCount)}'
                                      : title == _locale.salesByHours
                                          ? '\u200E${NumberFormat('#,###', 'en_US').format(totalPricesHoursCount)}'
                                          : '',
                              style: TextStyle(
                                fontSize: isDesktop ? 10 : 12,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromRGBO(82, 151, 176, 1),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (Responsive.isDesktop(context))
                        Padding(
                          padding: const EdgeInsets.only(top: 4, left: 12),
                          child: Text(
                            title == _locale.salesByCashier
                                ? "(${cashierSearchCriteria.fromDate} - ${cashierSearchCriteria.toDate})"
                                : title == _locale.salesByComputer
                                    ? "(${desktopSearchCriteria.fromDate} - ${desktopSearchCriteria.toDate})"
                                    : title == _locale.salesByHours
                                        ? "(${hoursSearchCriteria.fromDate} - ${hoursSearchCriteria.toDate})"
                                        : "",
                            style: TextStyle(
                              fontSize: isDesktop ? 10 : 12,
                              color: Colors.grey.shade600,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                blueButton1(
                  onPressed: () async {
                    List<CashierModel> cashiers = [];
                    List<ComputerModel> computers = [];
                    if (title == _locale.salesByCashier) {
                      cashiers = await TotalSalesController().getAllCashiers();
                    } else if (title == _locale.salesByComputer) {
                      computers = await TotalSalesController().getComputers("");
                    }
                    await TotalSalesController().getAllBranches().then((value) {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return FilterDialog(
                            cashiers: cashiers,
                            computers: computers,
                            branches: value,
                            filter: title == _locale.salesByCashier
                                ? cashierSearchCriteria
                                : title == _locale.salesByComputer
                                    ? desktopSearchCriteria
                                    : hoursSearchCriteria,
                            hint: title,
                          );
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
                            setState(() {
                              isLoading1 = true;
                            });
                            fetchSalesByComputer();
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
                    size: isDesktop ? height * 0.025 : height * 0.02,
                  ),
                ),
              ],
            ),
          ),
          if (!Responsive.isDesktop(context))
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    title == _locale.salesByCashier
                        ? "(${cashierSearchCriteria.fromDate} - ${cashierSearchCriteria.toDate})"
                        : title == _locale.salesByComputer
                            ? "(${desktopSearchCriteria.fromDate} - ${desktopSearchCriteria.toDate})"
                            : title == _locale.salesByHours
                                ? "(${hoursSearchCriteria.fromDate} - ${hoursSearchCriteria.toDate})"
                                : "",
                    style: TextStyle(
                      fontSize: height * 0.011,
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
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
                  : totalSales.isNotEmpty
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
                                      enabled: true,
                                      touchTooltipData: LineTouchTooltipData(
                                        tooltipRoundedRadius: 8,
                                        // Force tooltip to appear above by setting fitInsideHorizontally and fitInsideVertically
                                        fitInsideHorizontally: true,
                                        fitInsideVertically: true,
                                        // Add margin to push tooltip up
                                        tooltipMargin: 20,
                                        // Custom positioning to ensure tooltip appears above
                                        tooltipPadding: const EdgeInsets.all(8),
                                        getTooltipItems:
                                            (List<LineBarSpot> touchedSpots) {
                                          return touchedSpots.map((spot) {
                                            return LineTooltipItem(
                                              "${totalSales[spot.spotIndex].displayGroupName}\n${totalSales[spot.spotIndex].displaytransTypeName}\n${Converters.formatNumber(spot.y)}",
                                              const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500),
                                            );
                                          }).toList();
                                        },
                                      ),
                                      // Custom touch callback to control tooltip position
                                      getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
                                        return spotIndexes.map((spotIndex) {
                                          return TouchedSpotIndicatorData(
                                            FlLine(
                                              color: const Color.fromRGBO(82, 151, 176, 1).withOpacity(0.5),
                                              strokeWidth: 2,
                                              dashArray: [5, 5],
                                            ),
                                            FlDotData(
                                              show: true,
                                              getDotPainter: (spot, percent, barData, index) =>
                                                  FlDotCirclePainter(
                                                radius: 6,
                                                color: const Color.fromRGBO(82, 151, 176, 1),
                                                strokeWidth: 2,
                                                strokeColor: Colors.white,
                                              ),
                                            ),
                                          );
                                        }).toList();
                                      },
                                    ),
                                    titlesData: FlTitlesData(
                                      topTitles: const AxisTitles(
                                        sideTitles: SideTitles(showTitles: false),
                                      ),
                                      rightTitles: const AxisTitles(
                                        sideTitles: SideTitles(showTitles: false),
                                      ),
                                      leftTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          getTitlesWidget: (value, meta) =>
                                              leftTitleWidgets(value),
                                          showTitles: true,
                                          reservedSize: 35,
                                        ),
                                      ),
                                      bottomTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          interval: 1,
                                          reservedSize: 80, // Increased reserved space for labels
                                          getTitlesWidget: (value, meta) =>
                                              groupNameTitle(
                                                  value.toInt(), totalSales, title),
                                        ),
                                      ),
                                    ),
                                    borderData: FlBorderData(
                                      border: Border.all(
                                        color: const Color.fromRGBO(
                                            82, 151, 176, 0.3),
                                      ),
                                    ),
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
                                          getDotPainter:
                                              (spot, percent, barData, index) =>
                                                  FlDotCirclePainter(
                                            radius: 4,
                                            color:
                                                const Color.fromRGBO(82, 151, 176, 1),
                                            strokeWidth: 2,
                                            strokeColor: Colors.white,
                                          ),
                                        ),
                                        preventCurveOverShooting: true,
                                        spots: totalSales.asMap().entries.map((entry) {
                                          int index = entry.key;
                                          double totalSalesValue = double.parse(
                                              entry.value.displayTotalSales);
                                          return FlSpot(
                                              index.toDouble(), totalSalesValue);
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
                              _locale.salesByCashier,
                              barChartDataCashier,
                              context,
                              _locale,
                              isDesktop,
                              height,
                              width,
                              _scrollController,
                              isLoading,
                              xLabelsCashier)
                          : dailySalesChart(
                              totalSalesByCashier,
                              _locale.salesByCashier,
                              maxYByCashier,
                              context,
                              _locale,
                              isDesktop,
                              height,
                              _scrollController,
                              isLoading),
                      desktopSearchCriteria.chartType == _locale.barChart
                          ? salesByPaymentTypesBarChart(
                              _locale.salesByComputer,
                              barChartDataComputer,
                              context,
                              _locale,
                              isDesktop,
                              height,
                              width,
                              _scrollController1,
                              isLoading1,
                              xLabelsComputer)
                          : dailySalesChart(
                              totalSalesByComputer,
                              _locale.salesByComputer,
                              maxYByComputer,
                              context,
                              _locale,
                              isDesktop,
                              height,
                              _scrollController1,
                              isLoading1),
                      salesCostBasedBranchChart(
                          data1, _locale.salesCostBasedBranch),
                      hoursSearchCriteria.chartType == _locale.lineChart
                          ? dailySalesChart(
                              totalSalesByHours,
                              _locale.salesByHours,
                              maxYHours,
                              context,
                              _locale,
                              isDesktop,
                              height,
                              _scrollController3,
                              isLoading3)
                          : hourTotalBarChart(
                              barChartData, _locale.salesByHours),
                    ],
                  ))
            ],
          )
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
    String title,
    List<BarChartGroupData> enteredBarChartData,
    BuildContext context,
    AppLocalizations _locale,
    bool isDesktop,
    double height,
    double width,
    ScrollController _scrollController,
    bool isLoading,
    List<String> xLabels) {
  
  // Validate data consistency before rendering
  bool hasValidData = enteredBarChartData.isNotEmpty && xLabels.isNotEmpty;
  
  // Ensure data consistency - xLabels should match the number of bar chart data points
  List<BarChartGroupData> validBarChartData = [];
  List<String> validXLabels = [];
  
  if (hasValidData) {
    final validDataCount = math.min(enteredBarChartData.length, xLabels.length);
    validBarChartData = enteredBarChartData.take(validDataCount).toList();
    validXLabels = xLabels.take(validDataCount).toList();
  }
  
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
          // Header section (unchanged)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                            height: 16,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(82, 151, 176, 1),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          SelectableText(
                            title,
                            style: TextStyle(
                              fontSize: isDesktop ? 14 : 16,
                              fontWeight: FontWeight.w600,
                              color: const Color.fromRGBO(82, 151, 176, 1),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(82, 151, 176, 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              title == _locale.salesByCashier
                                  ? '\u200E${NumberFormat('#,###', 'en_US').format(totalPricesCashierCount)}'
                                  : title == _locale.salesByComputer
                                      ? '\u200E${NumberFormat('#,###', 'en_US').format(totalPricesComputerCount)}'
                                      : title == _locale.salesByPaymentTypes
                                          ? '\u200E${NumberFormat('#,###', 'en_US').format(totalPricesPayTypesCount)}'
                                          : title == _locale.salesByHours
                                              ? '\u200E${NumberFormat('#,###', 'en_US').format(totalPricesHoursCount)}'
                                              : '',
                              style: TextStyle(
                                fontSize: isDesktop ? 10 : 12,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromRGBO(82, 151, 176, 1),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (Responsive.isDesktop(context))
                        Padding(
                          padding: const EdgeInsets.only(top: 4, left: 12),
                          child: Text(
                            title == _locale.salesByCashier
                                ? "(${cashierSearchCriteria.fromDate} - ${cashierSearchCriteria.toDate})"
                                : title == _locale.salesByComputer
                                    ? "(${desktopSearchCriteria.fromDate} - ${desktopSearchCriteria.toDate})"
                                    : title == _locale.salesByPaymentTypes
                                        ? "(${payTypesSearchCriteria.fromDate} - ${payTypesSearchCriteria.toDate})"
                                        : title == _locale.salesByHours
                                            ? "(${hoursSearchCriteria.fromDate} - ${hoursSearchCriteria.toDate})"
                                            : "",
                            style: TextStyle(
                              fontSize: isDesktop ? 10 : 12,
                              color: Colors.grey.shade600,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                blueButton1(
                  onPressed: () async {
                    List<CashierModel> cashiers = [];
                    List<ComputerModel> computers = [];
                    if (title == _locale.salesByCashier) {
                      cashiers = await TotalSalesController().getAllCashiers();
                    } else if (title == _locale.salesByComputer) {
                      computers = await TotalSalesController().getComputers("");
                    }
                    await TotalSalesController().getAllBranches().then((value) {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return FilterDialog(
                            cashiers: cashiers,
                            computers: computers,
                            branches: value,
                            filter: title == _locale.salesByCashier
                                ? cashierSearchCriteria
                                : title == _locale.salesByComputer
                                    ? desktopSearchCriteria
                                    : title == _locale.salesByPaymentTypes
                                        ? payTypesSearchCriteria
                                        : hoursSearchCriteria,
                            hint: title,
                          );
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
                            setState(() {
                              isLoading1 = true;
                            });
                            fetchSalesByComputer();
                          } else if (title == _locale.salesByPaymentTypes) {
                            payTypesSearchCriteria = value;
                            setState(() {
                              isLoading2 = true;
                            });
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
                    size: isDesktop ? height * 0.025 : height * 0.02,
                  ),
                ),
              ],
            ),
          ),
          if (!Responsive.isDesktop(context))
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    title == _locale.salesByCashier
                        ? "(${cashierSearchCriteria.fromDate} - ${cashierSearchCriteria.toDate})"
                        : title == _locale.salesByComputer
                            ? "(${desktopSearchCriteria.fromDate} - ${desktopSearchCriteria.toDate})"
                            : title == _locale.salesByPaymentTypes
                                ? "(${payTypesSearchCriteria.fromDate} - ${payTypesSearchCriteria.toDate})"
                                : title == _locale.salesByHours
                                    ? "(${hoursSearchCriteria.fromDate} - ${hoursSearchCriteria.toDate})"
                                    : "",
                    style: TextStyle(
                      fontSize: height * 0.011,
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
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
                  : hasValidData && validBarChartData.isNotEmpty && validXLabels.isNotEmpty
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
                              height: double.infinity,
                              width: Responsive.isDesktop(context)
                                  ? validBarChartData.length > 20
                                      ? width * (validBarChartData.length / 16)
                                      : width * 0.82
                                  : validBarChartData.length > 5
                                      ? width * (validBarChartData.length / 8)
                                      : width * 0.82,
                              child: BarChart(
                                BarChartData(
                                  maxY: (title == _locale.salesByCashier
                                      ? maxYByCashier
                                      : title == _locale.salesByComputer
                                          ? maxYByComputer
                                          : title == _locale.salesByPaymentTypes
                                              ? maxY
                                              : maxYHours) * 1.4,
                                  barTouchData: BarTouchData(
                                    touchTooltipData: BarTouchTooltipData(
                                      tooltipRoundedRadius: 8,
                                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                        // Use the bar's x value to find the correct label
                                        int barIndex = group.x;
                                        String labelText = "";
                                        
                                        if (barIndex >= 0 && barIndex < validXLabels.length) {
                                          labelText = validXLabels[barIndex];
                                        } else {
                                          labelText = "Item ${barIndex + 1}";
                                        }
                                        
                                        return BarTooltipItem(
                                          "${Converters.formatNumber(rod.toY)}\n$labelText",
                                          const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
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
                                        reservedSize: 60,
                                        getTitlesWidget: (value, meta) {
                                          int index = value.toInt();
                                          if (index >= 0 && index < validXLabels.length) {
                                            return Transform.rotate(
                                              angle: -30 * 3.14159 / 180,
                                              child: SizedBox(
                                                width: 200,
                                                child: Center(
                                                  child: Text(
                                                    validXLabels[index],
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
                                          return const Text("");
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
                                    horizontalInterval: (title == _locale.salesByCashier
                                        ? maxYByCashier
                                        : title == _locale.salesByComputer
                                            ? maxYByComputer
                                            : title == _locale.salesByPaymentTypes
                                                ? maxY
                                                : maxYHours) * 0.2,
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
                                  barGroups: validBarChartData.asMap().entries.map((entry) {
                                    int index = entry.key;
                                    BarChartGroupData data = entry.value;
                                    
                                    return BarChartGroupData(
                                      x: index, // Use the loop index as x
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
                        )
                      : _buildEmptyChartContent(_locale),
            ),
          ),
        ],
      ),
    ),
  );
} 

Widget salesCostBasedBranchChart(List<ChartData> data1, String title) {
  return Container(
    height: Responsive.isDesktop(context)
        ? MediaQuery.of(context).size.height * 0.465
        : MediaQuery.of(context).size.height * 0.465,
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
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.isDesktop(context) ? 16 : 12,
              vertical: Responsive.isDesktop(context) ? 6 : 4, // Reduced vertical padding
            ),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(82, 151, 176, 0.05),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 4,
                            height: Responsive.isDesktop(context) ? 16 : 14,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(82, 151, 176, 1),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: SelectableText(
                              title,
                              style: TextStyle(
                                fontSize: Responsive.isDesktop(context) ? 14 : 13,
                                fontWeight: FontWeight.w600,
                                color: const Color.fromRGBO(82, 151, 176, 1),
                              ),
                              maxLines: Responsive.isDesktop(context) ? 1 : 2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4), // Reduced spacing
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Responsive.isDesktop(context) ? 8 : 6,
                          vertical: Responsive.isDesktop(context) ? 2 : 1, // Reduced padding
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(82, 151, 176, 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Responsive.isDesktop(context)
                            ? Text(
                                "(${_locale.profit}: \u200E${NumberFormat('#,###', 'en_US').format(totalsalesCostBasedBranchReportProfit)}, ${_locale.sales}: \u200E${NumberFormat('#,###', 'en_US').format(totalsalesCostBasedBranchReport)})",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: const Color.fromRGBO(82, 151, 176, 1),
                                ),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${_locale.profit}: \u200E${NumberFormat('#,###', 'en_US').format(totalsalesCostBasedBranchReportProfit)}",
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: const Color.fromRGBO(82, 151, 176, 1),
                                    ),
                                  ),
                                  Text(
                                    "${_locale.sales}: \u200E${NumberFormat('#,###', 'en_US').format(totalsalesCostBasedBranchReport)}",
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: const Color.fromRGBO(82, 151, 176, 1),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                      if (Responsive.isDesktop(context))
                        Padding(
                          padding: const EdgeInsets.only(top: 2, left: 12), // Reduced top padding
                          child: Text(
                            "(${salesCostBasedBranchReportCrit.fromDate} - ${salesCostBasedBranchReportCrit.toDate})",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade600,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: Responsive.isDesktop(context) ? null : 36,
                  height: Responsive.isDesktop(context) ? null : 36,
                  child: blueButton1(
                    onPressed: () async {
                      await TotalSalesController()
                          .getAllBranches()
                          .then((value) {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return FilterDialog(
                              cashiers: [],
                              branches: value,
                              filter: salesCostBasedBranchReportCrit,
                              hint: title,
                            );
                          },
                        ).then((value) {
                          if (value != false) {
                            isLoading2 = true;
                            setState(() {});
                            salesCostBasedBranchReportCrit = value;
                            fetchsalesCostBasedBranchReportList();
                          }
                        });
                      });
                    },
                    textColor: const Color.fromARGB(255, 255, 255, 255),
                    icon: Icon(
                      Icons.filter_list_sharp,
                      color: Colors.white,
                      size: Responsive.isDesktop(context) ? height * 0.025 : 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (!Responsive.isDesktop(context))
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2), // Reduced vertical padding
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      "(${salesCostBasedBranchReportCrit.fromDate} - ${salesCostBasedBranchReportCrit.toDate})",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade600,
                        fontStyle: FontStyle.italic,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8), // Reduced padding to increase chart height
              child: isLoading2
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color.fromRGBO(82, 151, 176, 1),
                        strokeWidth: 3,
                      ),
                    )
                  : data1.isNotEmpty
                      ? SfCartesianChart(
                          primaryXAxis: CategoryAxis(
                            labelStyle: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                            labelRotation: -45,
                          ),
                          primaryYAxis: NumericAxis(
                            title: AxisTitle(text: _locale.totalCost),
                            labelStyle: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          legend: Legend(
                            isVisible: true,
                            position: LegendPosition.bottom,
                            overflowMode: LegendItemOverflowMode.wrap,
                          ),
                          axes: <ChartAxis>[
                            CategoryAxis(
                              name: 'secondaryXAxis',
                              opposedPosition: true,
                              labelStyle: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            NumericAxis(
                              name: 'secondaryYAxis',
                              title: AxisTitle(text: _locale.profitPercent),
                              opposedPosition: true,
                              labelStyle: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                          tooltipBehavior: _tooltip1,
                          series: <CartesianSeries<ChartData, String>>[
                            ColumnSeries<ChartData, String>(
                              dataSource: data1,
                              xValueMapper: (ChartData data1, _) => data1.x,
                              yValueMapper: (ChartData data1, _) => data1.y,
                              name: _locale.profit,
                              color: Color.fromARGB(255, 14, 185, 11),
                              width: 0.4,
                            ),
                            ColumnSeries<ChartData, String>(
                              dataSource: data1,
                              xValueMapper: (ChartData data1, _) => data1.x,
                              yValueMapper: (ChartData data1, _) => data1.y1,
                              name: _locale.salesCost,
                              color: const Color.fromRGBO(1, 102, 184, 1),
                              width: 0.4,
                            ),
                            LineSeries<ChartData, String>(
                              dataSource: data1,
                              dataLabelSettings: const DataLabelSettings(
                                isVisible: true,
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              xValueMapper: (ChartData data1, _) =>
                                  double.parse(data1.perc).toStringAsFixed(2),
                              yValueMapper: (ChartData data1, _) => data1.percD,
                              enableTooltip: true,
                              name: _locale.profitPercent,
                              xAxisName: 'secondaryXAxis',
                              yAxisName: 'secondaryYAxis',
                              dataLabelMapper: (datum, index) {
                                return "${double.parse(datum.perc).toStringAsFixed(0)}%";
                              },
                              color: const Color.fromRGBO(26, 138, 6, 1),
                            ),
                          ],
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
}