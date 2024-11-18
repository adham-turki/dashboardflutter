import 'package:bi_replicate/components/dashboard_components/pie_dashboard_chart.dart';
import 'package:bi_replicate/dialogs/fliter_dialog.dart';
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
  SearchCriteria searchCriteria = SearchCriteria(
      branch: "all", shiftStatus: "all", fromDate: "", toDate: "");
  List<BranchSalesViewModel> totalSalesByCashier = [];
  List<BranchSalesViewModel> totalSalesByComputer = [];
  List<BranchSalesViewModel> totalSalesByHours = [];
  List<BranchSalesViewModel> totalSalesByPayTypes = [];
  List<PieChartModel> pieData = [];
  List<BarChartGroupData> barChartData = [];

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
    searchCriteria = SearchCriteria(
        branch: "all",
        shiftStatus: "all",
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
        .getTotalSalesByHours(searchCriteria)
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
        .getTotalSalesByCashier(searchCriteria)
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
        .getTotalSalesByPaymentTypes(searchCriteria)
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
        .getTotalSalesByComputer(searchCriteria)
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

    return Container(
      color: Colors.grey[100],
      height: height,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isDesktop ? desktopView() : mobileView(),
        ],
      ),
    );
  }

  Widget desktopView() {
    return SizedBox(
      width: width,
      height: height,
      child: SingleChildScrollView(
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
      ),
    );
  }

  Widget pieChart(List<PieChartModel> pieData, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Card(
        elevation: 1,
        color: Colors.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          SelectableText(
                            title,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: height * 0.02),
                          ),
                          title == _locale.salesByCashier
                              ? Text(
                                  "(${Converters.formatNumber(totalPricesCashierCount)})")
                              : title == _locale.salesByComputer
                                  ? Text(
                                      "(${Converters.formatNumber(totalPricesComputerCount)})")
                                  : title == _locale.salesByPaymentTypes
                                      ? Text(
                                          "(${Converters.formatNumber(totalPricesPayTypesCount)})")
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
                  blueButton1(
                    onPressed: () async {
                      await TotalSalesController()
                          .getAllBranches()
                          .then((value) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return FilterDialog(
                              branches: value,
                              filter: searchCriteria,
                            );
                          },
                        ).then((value) {
                          if (value != false) {
                            searchCriteria = value;
                            if (title == _locale.salesByCashier) {
                              fetchSalesByCashier();
                            } else if (title == _locale.salesByComputer) {
                              fetchSalesByComputer();
                            } else if (title == _locale.salesByPaymentTypes) {
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
            ),
            Center(
              child: SizedBox(
                height: height * 0.4,
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 2,
        color: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.zero, // Remove corner radius for a flat edge
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          SelectableText(
                            title,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: height * 0.02),
                          ),
                          title == _locale.salesByCashier
                              ? Text(
                                  "(${Converters.formatNumber(totalPricesCashierCount)})")
                              : title == _locale.salesByComputer
                                  ? Text(
                                      "(${Converters.formatNumber(totalPricesComputerCount)})")
                                  : title == _locale.salesByPaymentTypes
                                      ? Text(
                                          "(${Converters.formatNumber(totalPricesPayTypesCount)})")
                                      : title == _locale.salesByHours
                                          ? Text(
                                              "(${Converters.formatNumber(totalPricesHoursCount)})")
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
                  blueButton1(
                    onPressed: () async {
                      await TotalSalesController()
                          .getAllBranches()
                          .then((value) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return FilterDialog(
                              branches: value,
                              filter: searchCriteria,
                            );
                          },
                        ).then((value) {
                          if (value != false) {
                            searchCriteria = value;
                            if (title == _locale.salesByCashier) {
                              fetchSalesByCashier();
                            } else if (title == _locale.salesByComputer) {
                              fetchSalesByComputer();
                            } else if (title == _locale.salesByPaymentTypes) {
                              fetchSalesByPayTypes();
                            } else if (title == _locale.salesByHours) {
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
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 20, 5),
              child: AspectRatio(
                aspectRatio: 1.6,
                child: BarChart(
                  BarChartData(
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
            ),
          ],
        ),
      ),
    );
  }

  Widget dailySalesChart(List<BranchSalesViewModel> totalSales, String title) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Card(
        elevation: 2, // Remove shadow effect
        color: Colors.white, // Set background to transparent
        shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.zero, // Remove corner radius for a flat edge
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
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
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: height * 0.02),
                          ),
                          title == _locale.salesByCashier
                              ? Text(
                                  "(${Converters.formatNumber(totalPricesCashierCount)})")
                              : title == _locale.salesByComputer
                                  ? Text(
                                      "(${Converters.formatNumber(totalPricesComputerCount)})")
                                  : title == _locale.salesByPaymentTypes
                                      ? Text(
                                          "(${Converters.formatNumber(totalPricesPayTypesCount)})")
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
                  blueButton1(
                    onPressed: () async {
                      await TotalSalesController()
                          .getAllBranches()
                          .then((value) {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return FilterDialog(
                              branches: value,
                              filter: searchCriteria,
                            );
                          },
                        ).then((value) {
                          if (value != false) {
                            searchCriteria = value;
                            if (title == _locale.salesByCashier) {
                              fetchSalesByCashier();
                            } else if (title == _locale.salesByComputer) {
                              fetchSalesByComputer();
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
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 20, 5),
                child: AspectRatio(
                  aspectRatio: isDesktop ? 3 : 1,
                  child: LineChart(
                    LineChartData(
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
                              color: const Color.fromARGB(255, 125, 125, 125))),
                      lineBarsData: [
                        LineChartBarData(
                          belowBarData: BarAreaData(
                              show: true, color: Colors.blue.withOpacity(0.5)),
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
                ? "${totalSales[value].displayGroupName} / ${totalSales[value].displayBranch}"
                : totalSales[value].displayGroupName,
            style: const TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 8,
              color: Colors.black,
            ),
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
