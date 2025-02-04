import 'package:bi_replicate/dialogs/fliter_dialog.dart';
import 'package:bi_replicate/model/diff_cash_shift_report_by_cashier_model.dart';
import 'package:bi_replicate/model/diff_cash_shift_report_model.dart';
import 'package:bi_replicate/utils/constants/app_utils.dart';
import 'package:bi_replicate/utils/constants/responsive.dart';
import 'package:bi_replicate/utils/func/converters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:bi_replicate/model/chart/chart_data_model.dart';
import 'package:intl/intl.dart';
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
  SearchCriteria diffCashShiftReportCrit = SearchCriteria(
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
  late TooltipBehavior _tooltip;
  List<DiffCashShiftReportModel> diffCashShiftReportList = [];
  double totalDiffCashShiftReport = 0.0;
  List<DiffCashShiftReportByCashierModel> diffCashShiftByCashierReportList = [];
  double totalDiffCashShiftByCashierReport = 0.0;
  final ScrollController _scrollController1 = ScrollController();
  double minValue = 0;
  double maxValue = 0;
  double interval = 0;

  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context)!;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    print("asdasdasdasda");

    _tooltip = TooltipBehavior(enable: true);
    formattedFromDate =
        DateFormat('dd/MM/yyyy').format(DateTime(now.year, now.month, 1));
    formattedToDate = DateFormat('dd/MM/yyyy').format(now);

    diffCashShiftReportCrit = SearchCriteria(
        branch: "all",
        shiftStatus: "all",
        transType: "all",
        cashier: "all",
        fromDate: "01/01/2017"
        // formattedFromDate
        ,
        toDate: formattedToDate);
    diffCashShiftByCashierReportCrit = SearchCriteria(
        branch: "all",
        shiftStatus: "all",
        transType: "all",
        cashier: "all",
        fromDate: "01/01/2017"
        // formattedFromDate
        ,
        toDate: formattedToDate);
    fetchData();
    super.initState();
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
    await fetchDiffCashShiftReportList();

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
                      diffCashChart(data, _locale.diffCashByShifts),
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
                      diffCashChart(data, _locale.diffCashByShifts),
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
    await TotalSalesController()
        .getDiffCashShiftReportByCashierReportList(
            diffCashShiftByCashierReportCrit)
        .then((value) {
      for (var i = 0; i < value.length; i++) {}
    });
  }

  fetchDiffCashShiftReportList() async {
    diffCashShiftReportList.clear();
    totalDiffCashShiftReport = 0.0;
    await TotalSalesController()
        .getDiffCashShiftReportList(diffCashShiftReportCrit)
        .then((value) {
      for (var i = 0; i < value.length; i++) {
        diffCashShiftReportList.add(value[i]);
        totalDiffCashShiftReport += value[i].diffSum;
        data.add(ChartData(
            diffCashShiftReportList[i].branch,
            diffCashShiftReportList[i].user,
            (diffCashShiftReportList[i].diffCount).toDouble(),
            (diffCashShiftReportList[i].diffSum),
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
      print("diffCashShiftReportList: ${diffCashShiftReportList.length}");
      setState(() {});
    });
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
                                  " (${Converters.formatNumberRounded(double.parse(Converters.formatNumberDigits(totalDiffCashShiftReport)))})")
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
                        "(${diffCashShiftReportCrit.fromDate} - ${diffCashShiftReportCrit.toDate})",
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
                              filter: diffCashShiftReportCrit,
                              hint: title);
                        },
                      ).then((value) {
                        if (value != false) {
                          diffCashShiftReportCrit = value;
                          fetchDiffCashShiftReportList();
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
                              " (${Converters.formatNumberRounded(double.parse(Converters.formatNumberDigits(totalDiffCashShiftReport)))})"),
                        ],
                      )
                    : SizedBox.shrink(),
            if (!Responsive.isDesktop(context))
              if (title == _locale.diffCashByShifts)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                        "(${diffCashShiftReportCrit.fromDate} - ${diffCashShiftReportCrit.toDate})",
                        style: TextStyle(fontSize: height * 0.013)),
                  ],
                ),
            if (data.isNotEmpty)
              Scrollbar(
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
                        ? data.length > 20
                            ? width * (data.length / 10)
                            : width * 0.65
                        : data.length > 10
                            ? width * (data.length / 5)
                            : width * 0.95,
                    child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        // primaryYAxis: NumericAxis(
                        //     minimum: minValue,
                        //     maximum: maxValue,
                        //     title: AxisTitle(text: _locale.totalCost),
                        //     interval: interval),
                        legend: Legend(
                          isVisible: true,
                          position: LegendPosition
                              .bottom, // Position the legend below the chart
                          overflowMode:
                              LegendItemOverflowMode.wrap, // Handle overflow
                        ),
                        axes: <ChartAxis>[
                          CategoryAxis(
                              // name: 'secondaryXAxis',
                              // opposedPosition: true,
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
                              dataLabelSettings: const DataLabelSettings(
                                isVisible: true,
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                              xValueMapper: (ChartData data, _) => data.perc,
                              yValueMapper: (ChartData data, _) => data.y,
                              enableTooltip: true,
                              name: _locale.valueOfTotalDiff,
                              // xAxisName: 'secondaryXAxis',
                              // yAxisName: 'secondaryYAxis',
                              dataLabelMapper: (datum, index) {
                                return "${datum.y.toString()}\n${datum.x.toString()}";
                              },
                              color: const Color.fromRGBO(26, 138, 6, 1)),
                          LineSeries<ChartData, String>(
                              dataSource: data,
                              dataLabelSettings: const DataLabelSettings(
                                isVisible: true,
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                              xValueMapper: (ChartData data, _) => data.perc,
                              yValueMapper: (ChartData data, _) => data.percD,
                              enableTooltip: true,
                              name: _locale.numOfDiffTimes,
                              // xAxisName: 'secondaryXAxis',
                              // yAxisName: 'secondaryYAxis',
                              dataLabelMapper: (datum, index) {
                                return datum.percD.toString();
                              },
                              color: Color.fromARGB(255, 255, 0, 0)),
                        ]),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
