import 'package:bi_replicate/controller/sales_adminstration/branch_controller.dart';
import 'package:bi_replicate/controller/sales_adminstration/sales_category_controller.dart';
import 'package:bi_replicate/controller/settings/user_settings/user_report_settings_controller.dart';
import 'package:bi_replicate/controller/total_sales_controller.dart';
import 'package:bi_replicate/model/branch_sales_by_stocks_model.dart';
import 'package:bi_replicate/model/criteria/search_criteria.dart';
import 'package:bi_replicate/model/settings/user_settings/user_report_settings.dart';
import 'package:bi_replicate/provider/dates_provider.dart';
import 'package:bi_replicate/screen/dashboard_content/filter_dialog/filter_dialog_sales_by_cat.dart';
import 'package:bi_replicate/utils/constants/app_utils.dart';
import 'package:bi_replicate/utils/constants/maps.dart';
import 'package:bi_replicate/utils/constants/responsive.dart';
import 'package:bi_replicate/utils/func/converters.dart';
import 'package:bi_replicate/utils/func/dates_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OtherReportsScreen extends StatefulWidget {
  const OtherReportsScreen({super.key});

  @override
  State<OtherReportsScreen> createState() => _OtherReportsScreenState();
}

class _OtherReportsScreenState extends State<OtherReportsScreen> {
  double width = 0;
  double height = 0;
  bool isDesktop = false;
  late AppLocalizations locale;
  SearchCriteria salesByStocksSearchCriteria =
      SearchCriteria(branch: "", fromDate: "", toDate: "");
  bool isLoading = true;
  double totalSalesByStocks = 0.0;
  double maxY = 0.0;
  List<BranchSalesByStocksModel> salesByStocksList = [];
  List<BarChartGroupData> barChartData = [];
  ScrollController _scrollController2 = ScrollController();
  int selectedCategories = 0;
  int selectedPeriod = 0;
  int selectedChart = 0;
  List<String> branches = [];
  List<String> stocksCodes1 = [];
  var selectedBranchCode = "";
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  String todayDate = "";
  String currentYear = "";
  String currentMonth = "";
  int count = 0;
  bool filterPressed = false;
  late DatesProvider dateProvider;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    locale = AppLocalizations.of(context)!;
    getBranch();
    todayDate = DatesController().formatDate(DatesController().todayDate());
    currentYear = DatesController().formatDate(DatesController().twoYearsAgo());
    currentMonth =
        DatesController().formatDate(DatesController().currentMonth());
    fromDateController.text = salesByStocksSearchCriteria.fromDate!.isEmpty
        ? currentMonth
        : salesByStocksSearchCriteria.fromDate!;
    toDateController.text = salesByStocksSearchCriteria.toDate!.isEmpty
        ? todayDate
        : salesByStocksSearchCriteria.toDate!;
    salesByStocksSearchCriteria.fromDate = fromDateController.text;
    salesByStocksSearchCriteria.toDate = toDateController.text;
    salesByStocksSearchCriteria.fromDate =
        context.read<DatesProvider>().sessionFromDate.isNotEmpty
            ? DatesController().dashFormatDate(
                context.read<DatesProvider>().sessionFromDate, false)
            : salesByStocksSearchCriteria.fromDate;
    salesByStocksSearchCriteria.toDate = context
            .read<DatesProvider>()
            .sessionToDate
            .isNotEmpty
        ? DatesController()
            .dashFormatDate(context.read<DatesProvider>().sessionToDate, false)
        : salesByStocksSearchCriteria.toDate;
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   dateProvider = Provider.of<DatesProvider>(context, listen: false);
    //   dateProvider.addListener(_onDateRangeChanged);
    // });
    fetchSalesByStocks();
    if (count == 0) {
      fromDateController.text = "";
      toDateController.text = "";
      selectedCategories = Category1_Category;
      selectedPeriod = Daily_Period;
      selectedChart = Bar_Chart;
      selectedBranchCode = "";
    }
    count++;
    super.didChangeDependencies();
  }

  void _onDateRangeChanged() {
    if (dateProvider.sessionFromDate != "" &&
        dateProvider.sessionToDate != "") {
      fromDateController.text = salesByStocksSearchCriteria.fromDate!.isEmpty
          ? currentMonth
          : salesByStocksSearchCriteria.fromDate!;
      toDateController.text = salesByStocksSearchCriteria.toDate!.isEmpty
          ? todayDate
          : salesByStocksSearchCriteria.toDate!;
      salesByStocksSearchCriteria.fromDate = fromDateController.text;
      salesByStocksSearchCriteria.toDate = toDateController.text;
      salesByStocksSearchCriteria.fromDate =
          context.read<DatesProvider>().sessionFromDate.isNotEmpty
              ? DatesController().dashFormatDate(
                  context.read<DatesProvider>().sessionFromDate, false)
              : salesByStocksSearchCriteria.fromDate;
      salesByStocksSearchCriteria.toDate =
          context.read<DatesProvider>().sessionToDate.isNotEmpty
              ? DatesController().dashFormatDate(
                  context.read<DatesProvider>().sessionToDate, false)
              : salesByStocksSearchCriteria.toDate;
      fetchSalesByStocks();
    }
  }

  List<String> xLabels = [];
  fetchSalesByStocks() async {
    totalSalesByStocks = 0.0;
    salesByStocksList.clear();
    barChartData.clear();
    maxY = 0.0;
    isLoading = true;
    setState(() {});
    await SalesCategoryController()
        .getSalesByStocks(salesByStocksSearchCriteria)
        .then((value) {
      for (var i = 0; i < value.length; i++) {
        salesByStocksList.add(value[i]);
        salesByStocksList[i].total =
            salesByStocksList[i].creditAmt - salesByStocksList[i].debitAmt;
        totalSalesByStocks += salesByStocksList[i].total ?? 0.0;
        if ((salesByStocksList[i].total ?? 0.0) > maxY) {
          maxY = salesByStocksList[i].total ?? 0.0;
        }
      }

      xLabels = salesByStocksList.map((e) => e.stockName).toList();

      barChartData = List.generate(salesByStocksList.length, (index) {
        return BarChartGroupData(
          x: index, // Use index as x-value
          barRods: [
            BarChartRodData(
              toY: salesByStocksList[index].total ?? 0.0,
              borderRadius: BorderRadius.all(Radius.zero),
            ),
          ],
        );
      });

      isLoading = false;
      setState(() {});
    });
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            selectedChart == Bar_Chart
                ? barChartWidget(locale.branchesSalesByStocks)
                : lineChart(salesByStocksList, locale.branchesSalesByStocks),
          ],
        )
      ],
    );
  }

  Widget mobileDashboard() {
    return Column(
      children: [
        Row(
          children: [
            selectedChart == Bar_Chart
                ? barChartWidget(locale.branchesSalesByStocks)
                : lineChart(salesByStocksList, locale.branchesSalesByStocks),
          ],
        )
      ],
    );
  }

  Widget barChartWidget(String title) {
    return Expanded(
      flex: 1,
      child: SizedBox(
        height: height * 0.53,
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
                              '(\u200E${NumberFormat('#,###', 'en_US').format(totalSalesByStocks)})',
                              style: TextStyle(fontSize: isDesktop ? 15 : 18)),
                        ],
                      ),
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
                            return FilterDialogSalesByCategory(
                              selectedChart:
                                  getChartByCode(selectedChart, locale),
                              selectedBranchCodeF: selectedBranchCode == ""
                                  ? locale.all
                                  : selectedBranchCode,
                              selectedPeriod:
                                  getPeriodByCode(selectedPeriod, locale),
                              fromDate: fromDateController.text,
                              toDate: toDateController.text,
                              selectedCategory:
                                  getCategoryByCode(selectedCategories, locale),
                              branches: branches,
                              onFilter: (selectedPeriodF,
                                  fromDate,
                                  toDate,
                                  selectedCategoriesF,
                                  selectedBranchCodeF,
                                  chart,
                                  stocksCodes) {
                                stocksCodes1 = stocksCodes;
                                fromDateController.text = fromDate;
                                toDateController.text = toDate;
                                selectedCategories =
                                    getCategoryNum(selectedCategoriesF, locale);
                                selectedBranchCode =
                                    selectedBranchCodeF == locale.all
                                        ? ""
                                        : selectedBranchCodeF;
                                selectedPeriod =
                                    getPeriodByName(selectedPeriodF, locale);
                                selectedChart = getChartByName(chart, locale);
                                SearchCriteria searchCriteria = SearchCriteria(
                                  fromDate: fromDateController.text,
                                  toDate: toDateController.text.isEmpty
                                      ? todayDate
                                      : toDateController.text,
                                  byCategory: getCategoryNum(
                                      selectedCategoriesF, locale),
                                  branch: selectedBranchCode,
                                  codesStock: stocksCodes1,
                                );
                                salesByStocksSearchCriteria = searchCriteria;
                                setSearchCriteria(searchCriteria);
                              },
                            );
                          },
                        ).then((value) async {
                          if (title == locale.branchesSalesByStocks) {
                            isLoading = true;
                            setState(() {});
                            fetchSalesByStocks();
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
              if (title == locale.branchesSalesByStocks)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                        "(${salesByStocksSearchCriteria.fromDate} - ${salesByStocksSearchCriteria.toDate})",
                        style: TextStyle(
                            fontSize: isDesktop ? 14 : height * 0.013)),
                  ],
                ),
              (title == locale.branchesSalesByStocks && isLoading)
                  ? SizedBox(
                      height: height * 0.35,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : barChartData.isNotEmpty
                      ? Scrollbar(
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
                                        : width * 0.6
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
                                            "${xLabels[groupIndex]}\n${Converters.formatNumber(rod.toY)}",
                                            const TextStyle(
                                                color: Colors.white),
                                          );
                                        },
                                      ),
                                    ),
                                    titlesData: FlTitlesData(
                                      rightTitles: AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false),
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
                                                  width: 150,
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
                                        sideTitles:
                                            SideTitles(showTitles: false),
                                      ),
                                    ),
                                    barGroups: barChartData
                                      ..sort((b, a) => a.barRods[0].toY
                                          .compareTo(b.barRods[0].toY)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : SizedBox(
                          height: height * 0.35,
                          child: Center(child: Text(locale.noDataAvailable)),
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

  void setSearchCriteria(SearchCriteria searchCriteria) {
    UserReportSettingsModel userReportSettingsModel = UserReportSettingsModel(
        txtKey: "",
        txtReportcode: "",
        txtUsercode: "",
        txtJsoncrit: searchCriteria.toJson().toString(),
        bolAutosave: 1);

    UserReportSettingsController()
        .editUserReportSettings(userReportSettingsModel)
        .then((value) {
      if (value.statusCode == 200) {}
    });
  }

  Widget lineChart(List<BranchSalesByStocksModel> totalSales, String title) {
    return Expanded(
      flex: 1,
      child: SizedBox(
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
                          title == locale.branchesSalesByStocks
                              ? Text(
                                  '(\u200E${NumberFormat('#,###', 'en_US').format(totalSalesByStocks)})',
                                )
                              : SizedBox.shrink()
                        ],
                      ),
                    ],
                  ),
                  if (Responsive.isDesktop(context))
                    if (title == locale.branchesSalesByStocks)
                      Text(
                          "(${salesByStocksSearchCriteria.fromDate} - ${salesByStocksSearchCriteria.toDate})",
                          style: TextStyle(fontSize: isDesktop ? 13 : 16)),
                  blueButton1(
                    onPressed: () async {
                      if (!filterPressed) {
                        setState(() {
                          filterPressed = true;
                        });

                        await TotalSalesController()
                            .getAllBranches()
                            .then((value) {
                          setState(() {
                            filterPressed = false;
                          });
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return FilterDialogSalesByCategory(
                                selectedChart:
                                    getChartByCode(selectedChart, locale),
                                selectedBranchCodeF: selectedBranchCode == ""
                                    ? locale.all
                                    : selectedBranchCode,
                                selectedPeriod:
                                    getPeriodByCode(selectedPeriod, locale),
                                fromDate: fromDateController.text,
                                toDate: toDateController.text,
                                selectedCategory: getCategoryByCode(
                                    selectedCategories, locale),
                                branches: branches,
                                onFilter: (selectedPeriodF,
                                    fromDate,
                                    toDate,
                                    selectedCategoriesF,
                                    selectedBranchCodeF,
                                    chart,
                                    stocksCodes) {
                                  stocksCodes1 = stocksCodes;
                                  fromDateController.text = fromDate;
                                  toDateController.text = toDate;
                                  selectedCategories = getCategoryNum(
                                      selectedCategoriesF, locale);
                                  selectedBranchCode =
                                      selectedBranchCodeF == locale.all
                                          ? ""
                                          : selectedBranchCodeF;
                                  selectedPeriod =
                                      getPeriodByName(selectedPeriodF, locale);
                                  selectedChart = getChartByName(chart, locale);
                                  SearchCriteria searchCriteria =
                                      SearchCriteria(
                                    fromDate: fromDateController.text,
                                    toDate: toDateController.text.isEmpty
                                        ? todayDate
                                        : toDateController.text,
                                    byCategory: getCategoryNum(
                                        selectedCategoriesF, locale),
                                    branch: selectedBranchCode,
                                    codesStock: stocksCodes1,
                                  );
                                  salesByStocksSearchCriteria = searchCriteria;
                                  setSearchCriteria(searchCriteria);
                                },
                              );
                            },
                          ).then((value) async {
                            if (title == locale.branchesSalesByStocks) {
                              isLoading = true;
                              setState(() {});
                              fetchSalesByStocks();
                            }
                          });
                        });
                      }
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
                if (title == locale.branchesSalesByStocks)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                          "(${salesByStocksSearchCriteria.fromDate} - ${salesByStocksSearchCriteria.toDate})",
                          style: TextStyle(fontSize: height * 0.013)),
                    ],
                  ),
              isLoading
                  ? SizedBox(
                      height: height * 0.35,
                      child: const Center(child: CircularProgressIndicator()))
                  : salesByStocksList.isNotEmpty
                      ? Scrollbar(
                          controller: _scrollController2,
                          thumbVisibility: true,
                          thickness: 8,
                          trackVisibility: true,
                          radius: const Radius.circular(4),
                          child: SingleChildScrollView(
                            reverse: locale.localeName == "ar" ? true : false,
                            controller: _scrollController2,
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(
                              height: height * 0.35,
                              width: Responsive.isDesktop(context)
                                  ? totalSales.length > 20
                                      ? width * (totalSales.length / 16)
                                      : width * 0.82
                                  : totalSales.length > 3
                                      ? width * (totalSales.length / 5)
                                      : width * 0.82,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 50.0, vertical: 20.0),
                                child: LineChart(
                                  LineChartData(
                                    maxY: maxY * 1.3,
                                    lineTouchData: LineTouchData(
                                      touchTooltipData: LineTouchTooltipData(
                                        getTooltipItems:
                                            (List<LineBarSpot> touchedSpots) {
                                          return touchedSpots.map((spot) {
                                            return LineTooltipItem(
                                              "${totalSales[spot.spotIndex].stockName}\n${Converters.formatNumber(spot.y)}",
                                              const TextStyle(
                                                  color: Colors.white),
                                            );
                                          }).toList();
                                        },
                                      ),
                                    ),
                                    titlesData: FlTitlesData(
                                      topTitles: const AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false),
                                      ),
                                      rightTitles: const AxisTitles(
                                          sideTitles:
                                              SideTitles(showTitles: false)),
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
                                          getTitlesWidget: (value, meta) =>
                                              groupNameTitle(value.toInt(),
                                                  totalSales, title),
                                        ),
                                      ),
                                    ),
                                    borderData: FlBorderData(
                                        border: Border.all(
                                            color: const Color.fromARGB(
                                                255, 125, 125, 125))),
                                    lineBarsData: [
                                      LineChartBarData(
                                        belowBarData: BarAreaData(
                                            show: true,
                                            color:
                                                Colors.blue.withOpacity(0.5)),
                                        isCurved: true,
                                        preventCurveOverShooting: true,
                                        spots: totalSales
                                            .asMap()
                                            .entries
                                            .map((entry) {
                                          int index = entry.key;

                                          return FlSpot(index.toDouble(),
                                              entry.value.total ?? 0.0);
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : SizedBox(
                          height: height * 0.35,
                          child: Center(child: Text(locale.noDataAvailable)),
                        ),
            ],
          ),
        ),
      ),
    );
  }

  void getBranch() async {
    BranchController().getBranch().then((value) {
      branches.add(locale.all);
      value.forEach((k, v) {
        if (mounted) {
          setState(() {
            branches.add(k);
          });
        }
      });
      setBranchesMap(locale, value);
    });
  }

  Widget groupNameTitle(
      int value, List<BranchSalesByStocksModel> totalSales, String title) {
    if (value >= 0 && value < totalSales.length) {
      return Transform.rotate(
        angle: -30 * 3.14159 / 180, // 90 degrees in radians
        child: SizedBox(
          width: 200,
          child: Center(
            child: Text(
              "${totalSales[value].stockName} / ${totalSales[value].total}",
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
}
