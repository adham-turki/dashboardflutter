import 'dart:math';

import 'package:bi_replicate/components/dashboard_components/dashboard_bar_data.dart';
import 'package:bi_replicate/utils/constants/responsive.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../charts.dart';

class BarDashboardChart extends StatefulWidget {
  final List<BarData> barChartData;
  final bool isMax;

  const BarDashboardChart(
      {super.key, required this.barChartData, required this.isMax});

  @override
  State<BarDashboardChart> createState() => _BarDashboardChartState();
}

class _BarDashboardChartState extends State<BarDashboardChart> {
  List<DashboardBarData> dataList = [];
  List<Color> usedColors = [];
  int touchedGroupIndex = -1;
  double width = 0;
  double height = 0;
  bool isFilter = true;
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  Widget buildWidget = const Row();

  void convertBarDataToDashboardBarData() {
    dataList = [];
    List<BarData> barDat = widget.barChartData;
    for (int i = 0; i < barDat.length; i++) {
      DashboardBarData dashboardBarData = DashboardBarData(
          getRandomColor(), barDat[i].percent!, barDat[i].percent!);
      dataList.add(dashboardBarData);
    }
  }

  BarChartGroupData generateBarGroup(
    int x,
    Color color,
    double value,
  ) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: value,
          color: color,
          width: 6,
        ),
      ],
      showingTooltipIndicators: touchedGroupIndex == x ? [0] : [],
    );
  }

  @override
  void didChangeDependencies() {
    getBuildWidget();
    super.didChangeDependencies();
  }

  getBuildWidget() {
    setState(() {
      isLoading = true;
    });
    convertBarDataToDashboardBarData();
    print("isLoading $isLoading dataListLength ${dataList.length}");

    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    bool isMobile = Responsive.isMobile(context);

    buildWidget = Directionality(
      textDirection: TextDirection.ltr,
      child: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        thickness: 8,
        trackVisibility: true,
        radius: const Radius.circular(4),
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding:
                const EdgeInsets.only(right: 50, bottom: 15, top: 20, left: 0),
            child: SizedBox(
              width: isMobile
                  ? (widget.isMax && dataList.length < 6) || dataList.length < 6
                      ? width * 0.8
                      : width * (dataList.length / 4)
                  : (widget.isMax && dataList.length < 6) || dataList.length < 6
                      ? width * .6
                      : width * (dataList.length / 15),
              height: height * 0.35,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                  ),
                  Expanded(
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceBetween,
                        borderData: FlBorderData(
                          show: true,
                          border: Border.symmetric(
                            horizontal: BorderSide(
                              color: Colors.grey.withOpacity(0.2),
                            ),
                          ),
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          leftTitles: AxisTitles(
                            drawBelowEverything: true,
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 100,
                              interval: widget.barChartData.isEmpty
                                  ? 300000
                                  : getMax() / 6,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  value.toInt().toString(),
                                  textAlign: TextAlign.left,
                                );
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 32,
                              interval: 1,
                              getTitlesWidget: (value, meta) {
                                return SideTitleWidget(
                                  axisSide: meta.axisSide,
                                  child: Text(
                                    widget.barChartData[value.toInt()].name!,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                );
                              },
                            ),
                          ),
                          rightTitles: const AxisTitles(),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 35,
                              interval: 1,
                              getTitlesWidget: (value, meta) {
                                return SideTitleWidget(
                                  axisSide: meta.axisSide,
                                  child: const Text(
                                    "",
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          getDrawingHorizontalLine: (value) => FlLine(
                            color: Colors.grey.withOpacity(0.2),
                            strokeWidth: 1,
                          ),
                        ),
                        barGroups: dataList.asMap().entries.map((e) {
                          final index = e.key;
                          final data = e.value;
                          return generateBarGroup(
                            index,
                            data.color,
                            data.value,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    setState(() {
      isLoading = false;
    });
  }

  double getMax() {
    double max = 0;
    for (int i = 0; i < widget.barChartData.length; i++) {
      if (widget.barChartData[i].percent! > max) {
        max = widget.barChartData[i].percent!;
      }
    }
    return max;
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : buildWidget;
  }

  Color getRandomColor() {
    final random = Random();
    Color color;
    do {
      int r = random.nextInt(256); // 0 to 255
      int g = random.nextInt(256); // 0 to 255
      int b = random.nextInt(256); // 0 to 255

      // Create Color object from RGB values
      color =
          Color.fromRGBO(r, g, b, 1.0); // Alpha is set to 1.0 (fully opaque)
    } while (usedColors.contains(color));

    usedColors.add(color);
    return color;
  }
}
