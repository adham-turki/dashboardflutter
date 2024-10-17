import 'package:bi_replicate/model/custom_scroll_behavior.dart';
import 'package:bi_replicate/utils/constants/responsive.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../model/chart/pie_chart_model.dart';
import '../../utils/func/converters.dart';
import 'indicator.dart';

class PieChartComponent extends StatefulWidget {
  final double? width;
  final double? height;
  final List<PieChartModel> dataList;
  final double? radiusNormal;
  final double? radiusHover;
  const PieChartComponent({
    super.key,
    required this.dataList,
    this.width,
    this.height,
    this.radiusNormal,
    this.radiusHover,
  });

  @override
  State<PieChartComponent> createState() => _PieChartComponentState();
}

class _PieChartComponentState extends State<PieChartComponent> {
  int touchedIndex = -1;
  int duration = 100;

  double radiusNormal = 130;
  double radiusHover = 140;

  double width = 500;
  double height = 500;

  Color borderColor = Colors.white;
  bool isMobile = false;
  bool isLoading = false;
  Widget buildWidget = const Row();

  @override
  void didChangeDependencies() {
    // getBuildWidget();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    setAttributes();

    super.initState();
  }

  getBuildWidget() {
    List<PieChartModel> dataList = widget.dataList;
    print("widget.lidt.dataaaa0000 ${dataList.length}");

    bool isEmpty = dataList.isEmpty ? true : false;
    print("widget.lidt.dataaaa0000Empty ${isEmpty}");

    setState(() {
      isLoading = true;
    });

    buildWidget = SizedBox(
      height: height * 0.4,
      width: width,
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: isMobile ? height * 0.27 : height * 0.23,
                  child: PieChart(
                    PieChartData(
                      centerSpaceRadius: 1,
                      pieTouchData: PieTouchData(
                        enabled: true,
                        touchCallback: (event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              touchedIndex = -1;
                              return;
                            }
                            touchedIndex = pieTouchResponse
                                .touchedSection!.touchedSectionIndex;
                          });
                        },
                      ),
                      sections: isEmpty ? noDataList() : showList(dataList),
                    ),
                    swapAnimationDuration: Duration(milliseconds: duration),
                  ),
                ),
                Container(
                  height: isMobile ? height * 0.08 : height * 0.08,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black38),
                  ),
                  child: ScrollConfiguration(
                    behavior: CustomScrollBehavior(),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: showIndicators(dataList),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    isMobile = Responsive.isMobile(context);
    radiusNormal = isMobile ? height * 0.17 : height * 0.19;
    radiusHover = isMobile ? height * 0.18 : height * 0.2;

    getBuildWidget();
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : buildWidget;
  }

  List<PieChartSectionData> showList(List<PieChartModel> dataList) {
    print("widget.lidt.dataaaa333 ${dataList.length}");

    List<PieChartSectionData> list = List.generate(dataList.length, (i) {
      bool isTouched = i == touchedIndex;
      final radius = isTouched ? radiusHover : radiusNormal;
      PieChartModel data = dataList[i];
      return PieChartSectionData(
        value: data.value,
        title: "${data.title}\n${Converters.formatNumber(data.value!)}",
        color: data.color,
        radius: radius,
        titleStyle: const TextStyle(color: Colors.white, fontSize: 14),
        borderSide: isTouched
            ? BorderSide(
                color: borderColor,
                strokeAlign: 10,
                width: 5,
              )
            : null,
        // badgeWidget: Responsive.isDesktop(context) ? badgeLabel(data) : null,
        badgePositionPercentageOffset: 2,
      );
    });
    print("widget.lidt.dataaaa444 ${list.length}");

    return list;
  }

  Padding badgeLabel(PieChartModel data) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: data.color,
          borderRadius: BorderRadius.circular(4),
          boxShadow: const [
            BoxShadow(
              blurRadius: 5,
              color: Colors.black38,
            ),
          ],
        ),
        child: Text(
          data.title ?? "NONE",
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
      ),
    );
  }

  List<PieChartSectionData> noDataList() {
    PieChartModel data = PieChartModel(
      value: 100,
      title: "NO DATA",
      color: Colors.blue,
    );

    List<PieChartSectionData> noData = [
      PieChartSectionData(
        value: data.value,
        title: data.title,
        color: data.color,
        radius: radiusNormal,
        titleStyle: const TextStyle(color: Colors.white),
      ),
    ];

    return noData;
  }

  List<Widget> showIndicators(List<PieChartModel> dataList) {
    return List.generate(dataList.length, (i) {
      PieChartModel data = dataList[i];
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Indicator(
          color: data.color!,
          isSquare: true,
          text: "${data.title!} (${Converters.formatNumber(data.value!)})",
          size: 16,
          textSize: 16,
        ),
      );
    });
  }

  void setAttributes() {
    if (widget.width != null) {
      width = widget.width!;
    }
    if (widget.height != null) {
      height = widget.height!;
    }

    if (widget.radiusNormal != null) {
      radiusNormal = widget.radiusNormal!;
    }
    if (widget.radiusHover != null) {
      radiusHover = widget.radiusHover!;
    }
  }
}
