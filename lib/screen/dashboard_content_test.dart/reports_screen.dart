import 'dart:async';

import 'package:bi_replicate/dialogs/fliter_dialog.dart';
import 'package:bi_replicate/model/cashier_model.dart';
import 'package:bi_replicate/model/diff_cash_shift_report_by_cashier_model.dart';
import 'package:bi_replicate/model/diff_cash_shift_report_model.dart';
import 'package:bi_replicate/provider/dates_provider.dart';
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
  double totalDiffIncreaseClosedCashShiftReport = 0.0;
  double totalDiffDecreaseClosedCashShiftReport = 0.0;
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
  bool isLoading1 = false;
  late DatesProvider dateProvider;

  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context)!;
    super.didChangeDependencies();
  }

  @override
  void initState() {
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
    formattedFromDate = context.read<DatesProvider>().sessionFromDate.isNotEmpty
        ? context.read<DatesProvider>().sessionFromDate
        : formattedFromDate;
    formattedToDate = context.read<DatesProvider>().sessionToDate.isNotEmpty
        ? context.read<DatesProvider>().sessionToDate
        : formattedToDate;
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
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   dateProvider = Provider.of<DatesProvider>(context, listen: false);
    //   dateProvider.addListener(_onDateRangeChanged);
    // });
    fetchData();
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    // dateProvider.removeListener(_onDateRangeChanged); // Always detach
    super.dispose();
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
    }
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
    isLoading1 = true;
    setState(() {});

    await TotalSalesController()
        .getDiffCashShiftReportByCashierReportList(
            diffCashShiftByCashierReportCrit)
        .then((value) {
      isLoading1 = false;
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

      setState(() {});
    });
  }

  fetchDiffClosedCashShiftReportList() async {
    diffClosedCashShiftReportList.clear();
    totalDiffIncreaseClosedCashShiftReport = 0.0;
    totalDiffDecreaseClosedCashShiftReport = 0.0;
    data.clear();
    isLoading = true;
    setState(() {});
    await TotalSalesController()
        .getDiffCashShiftReportList(diffClosedCashShiftReportCrit)
        .then((value) {
      isLoading = false;
      for (var i = 0; i < value.length; i++) {
        diffClosedCashShiftReportList.add(value[i]);
        totalDiffIncreaseClosedCashShiftReport += value[i].increaseDiffSum;
        totalDiffDecreaseClosedCashShiftReport += value[i].decreaseDiffSum;
        data.add(ChartData(
            diffClosedCashShiftReportList[i].branchName,
            diffClosedCashShiftReportList[i].user,
            (diffClosedCashShiftReportList[i].diffCount).toDouble(),
            (diffClosedCashShiftReportList[i].increaseDiffSum),
            (diffClosedCashShiftReportList[i].decreaseDiffSum)));
      }

      setState(() {});
    });
  }

  bool filterPressed = false;
Widget diffClosedCashChart(List<ChartData> data, String title) {
  return Container(
    height: Responsive.isDesktop(context) ? height * 0.465 : height * 0.48,
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
              vertical: Responsive.isDesktop(context) ? 8 : 6,
            ),
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
                          Expanded(
                            child: SelectableText(
                              title,
                              style: TextStyle(
                                fontSize: Responsive.isDesktop(context) ? 14 : 12,
                                fontWeight: FontWeight.w600,
                                color: const Color.fromRGBO(82, 151, 176, 1),
                              ),
                              maxLines: 1,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: Responsive.isDesktop(context) ? 6 : 4,
                              vertical: Responsive.isDesktop(context) ? 2 : 1,
                            ),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(82, 151, 176, 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '(${_locale.increaseDiffSum}: \u200E${NumberFormat('#,###', 'en_US').format(totalDiffIncreaseClosedCashShiftReport)}, ${_locale.decreaseDiffSum}: \u200E${NumberFormat('#,###', 'en_US').format(totalDiffDecreaseClosedCashShiftReport)})',
                              style: TextStyle(
                                fontSize: Responsive.isDesktop(context) ? 10 : 8,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromRGBO(82, 151, 176, 1),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      if (Responsive.isDesktop(context))
                        Padding(
                          padding: const EdgeInsets.only(top: 4, left: 12),
                          child: Text(
                            "(${diffClosedCashShiftReportCrit.fromDate} - ${diffClosedCashShiftReportCrit.toDate})",
                            style: TextStyle(
                              fontSize: Responsive.isDesktop(context) ? 10 : 8,
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
                    if (!filterPressed) {
                      setState(() {
                        filterPressed = true;
                      });
                      List<CashierModel> cashiers = [];
                      cashiers = await TotalSalesController().getAllCashiers();
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
                              filter: diffClosedCashShiftReportCrit,
                              hint: title,
                            );
                          },
                        ).then((value) {
                          if (value != false) {
                            diffClosedCashShiftReportCrit = value;
                            isLoading = true;
                            setState(() {});
                            fetchDiffClosedCashShiftReportList();
                          }
                        });
                      });
                    }
                  },
                  textColor: const Color.fromARGB(255, 255, 255, 255),
                  icon: Icon(
                    Icons.filter_list_sharp,
                    color: Colors.white,
                    size: Responsive.isDesktop(context) ? height * 0.025 : height * 0.018,
                  ),
                ),
              ],
            ),
          ),
          if (!Responsive.isDesktop(context))
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "(${diffClosedCashShiftReportCrit.fromDate} - ${diffClosedCashShiftReportCrit.toDate})",
                    style: TextStyle(
                      fontSize: height * 0.01,
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
                  : data.isNotEmpty
                      ? diffClosedCashWidget(data)
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
  Consumer<ScreenContentProvider> diffClosedCashWidget(List<ChartData> data) {
    return Consumer<ScreenContentProvider>(builder: (context, value, child) {
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
                  majorGridLines:
                      MajorGridLines(width: 1.5, color: Colors.grey),
                  labelStyle:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                  majorTickLines: MajorTickLines(size: 10),
                  labelPlacement: LabelPlacement.onTicks,
                  labelRotation: -30, // Rotating labels by -30 degrees
                ),
                legend: Legend(
                  isVisible: true,
                  position: LegendPosition
                      .bottom, // Position the legend below the chart
                ),
                axes: <ChartAxis>[
                  CategoryAxis(
                    majorGridLines:
                        MajorGridLines(width: 1.5, color: Colors.grey),
                    labelStyle:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 8),
                    majorTickLines: MajorTickLines(size: 10),
                    labelPlacement: LabelPlacement.onTicks,
                    labelRotation: -30, // Rotating
                  ),
                ],
                tooltipBehavior: _tooltip,
                series: <CartesianSeries<ChartData, String>>[
                  LineSeries<ChartData, String>(
                      dataSource: data,
                      dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                        textStyle: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                      xValueMapper: (ChartData data, _) =>
                          "${data.perc}\n${data.x.toString()}",
                      yValueMapper: (ChartData data, _) => data.y,
                      enableTooltip: true,
                      name: _locale.increaseDiffSum,
                      dataLabelMapper: (datum, index) {
                        return Converters.formatNumberRounded(double.parse(
                            Converters.formatNumberDigits(datum.y)));
                      },
                      color: const Color.fromRGBO(26, 138, 6, 1)),
                  LineSeries<ChartData, String>(
                      dataSource: data,
                      dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                        textStyle: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                      xValueMapper: (ChartData data, _) =>
                          "${data.perc}\n${data.x.toString()}",
                      yValueMapper: (ChartData data, _) => data.y1,
                      enableTooltip: true,
                      name: _locale.decreaseDiffSum,
                      dataLabelMapper: (datum, index) {
                        return Converters.formatNumberRounded(double.parse(
                            Converters.formatNumberDigits(datum.y1)));
                      },
                      color: Color.fromARGB(255, 255, 2, 2)),
                  LineSeries<ChartData, String>(
                      dataSource: data,
                      dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                        textStyle: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                      xValueMapper: (ChartData data, _) =>
                          "${data.perc}\n${data.x.toString()}",
                      yValueMapper: (ChartData data, _) => data.percD,
                      enableTooltip: true,
                      name: _locale.numOfDiffTimes,
                      dataLabelMapper: (datum, index) {
                        return Converters.formatNumberRounded(double.parse(
                            Converters.formatNumberDigits(datum.percD)));
                      },
                      color: Color.fromARGB(255, 39, 128, 243)),
                ]),
          ),
        ),
      );
    });
  }

  bool filterPressed2 = false;
Widget diffCashChart(List<ChartData> data, String title) {
  return Container(
    height: Responsive.isDesktop(context) ? height * 0.465 : height * 0.48,
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
              vertical: Responsive.isDesktop(context) ? 8 : 6,
            ),
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
                          Expanded(
                            child: SelectableText(
                              title,
                              style: TextStyle(
                                fontSize: Responsive.isDesktop(context) ? 14 : 12,
                                fontWeight: FontWeight.w600,
                                color: const Color.fromRGBO(82, 151, 176, 1),
                              ),
                              maxLines: 1,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: Responsive.isDesktop(context) ? 6 : 4,
                              vertical: Responsive.isDesktop(context) ? 2 : 1,
                            ),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(82, 151, 176, 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '(\u200E${NumberFormat('#,###', 'en_US').format(totalDiffCashShiftByCashierReport)})',
                              style: TextStyle(
                                fontSize: Responsive.isDesktop(context) ? 10 : 8,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromRGBO(82, 151, 176, 1),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      if (Responsive.isDesktop(context))
                        Padding(
                          padding: const EdgeInsets.only(top: 4, left: 12),
                          child: Text(
                            "(${diffCashShiftByCashierReportCrit.fromDate} - ${diffCashShiftByCashierReportCrit.toDate})",
                            style: TextStyle(
                              fontSize: Responsive.isDesktop(context) ? 10 : 8,
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
                    if (!filterPressed2) {
                      setState(() {
                        filterPressed2 = true;
                      });
                      List<CashierModel> cashiers = [];
                      cashiers = await TotalSalesController().getAllCashiers();
                      await TotalSalesController().getAllBranches().then((value) {
                        setState(() {
                          filterPressed2 = false;
                        });
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return FilterDialog(
                              cashiers: cashiers,
                              branches: value,
                              filter: diffCashShiftByCashierReportCrit,
                              hint: title,
                            );
                          },
                        ).then((value) {
                          if (value != false) {
                            diffCashShiftByCashierReportCrit = value;
                            isLoading1 = true;
                            setState(() {});
                            fetchDiffCashShiftByCashierReportList();
                          }
                        });
                      });
                    }
                  },
                  textColor: const Color.fromARGB(255, 255, 255, 255),
                  icon: Icon(
                    Icons.filter_list_sharp,
                    color: Colors.white,
                    size: Responsive.isDesktop(context) ? height * 0.025 : height * 0.018,
                  ),
                ),
              ],
            ),
          ),
          if (!Responsive.isDesktop(context))
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "(${diffCashShiftByCashierReportCrit.fromDate} - ${diffCashShiftByCashierReportCrit.toDate})",
                    style: TextStyle(
                      fontSize: height * 0.01,
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
              child: isLoading1
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color.fromRGBO(82, 151, 176, 1),
                        strokeWidth: 3,
                      ),
                    )
                  : data.isNotEmpty
                      ? diffCashWidget(data)
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

  Consumer<ScreenContentProvider> diffCashWidget(List<ChartData> data) {
    return Consumer<ScreenContentProvider>(builder: (context, value, child) {
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
                  majorGridLines:
                      MajorGridLines(width: 1.5, color: Colors.grey),
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  majorTickLines: MajorTickLines(size: 10),
                  labelPlacement: LabelPlacement.onTicks,
                  labelRotation: -30, // Rotating
                ),
                legend: Legend(
                  isVisible: true,
                  position: LegendPosition
                      .bottom, // Position the legend below the chart
                  overflowMode: LegendItemOverflowMode.wrap, // Handle overflow
                ),
                axes: <ChartAxis>[
                  CategoryAxis(
                    majorGridLines:
                        MajorGridLines(width: 1.5, color: Colors.grey),
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    majorTickLines: MajorTickLines(size: 10),
                    labelPlacement: LabelPlacement.onTicks,
                    labelRotation: -30, // Rotating
                  ),
                ],
                tooltipBehavior: _tooltip1,
                series: <CartesianSeries<ChartData, String>>[
                  LineSeries<ChartData, String>(
                      dataSource: data,
                      dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                        textStyle: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                      xValueMapper: (ChartData data, _) =>
                          "${data.x}\n${data.perc}",
                      yValueMapper: (ChartData data, _) => data.y,
                      enableTooltip: true,
                      name: _locale.differenceValue,
                      dataLabelMapper: (datum, index) {
                        return "${Converters.formatNumberRounded(double.parse(Converters.formatNumberDigits(datum.y)))}\n${datum.x.toString()}";
                      },
                      color: Colors.blue),
                ]),
          ),
        ),
      );
    });
  }
}
