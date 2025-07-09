import 'package:bi_replicate/model/custom_scroll_behavior.dart';
import 'package:bi_replicate/utils/constants/responsive.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../model/chart/pie_chart_model.dart';
import '../../utils/func/converters.dart';

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
  double total = 0.0;

  @override
  void didChangeDependencies() {
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

    buildWidget = Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(20), // Add padding to prevent badge cutoff
      child: Center(
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
    );
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    isMobile = Responsive.isMobile(context);
    radiusNormal = isMobile ? height * 0.17 : height * 0.16;
    radiusHover = isMobile ? height * 0.18 : height * 0.19;

    getBuildWidget();
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : buildWidget;
  }

  List<PieChartSectionData> showList(List<PieChartModel> dataList) {
    total = 0.0;
    for (var i = 0; i < dataList.length; i++) {
      total += (dataList[i].value ?? 0.0);
    }
    print("$total - ${dataList.length}");

    List<PieChartSectionData> list = List.generate(dataList.length, (i) {
      bool isTouched = i == touchedIndex;
      final radius = isTouched ? radiusHover : radiusNormal;
      PieChartModel data = dataList[i];
      
      return PieChartSectionData(
        value: data.value,
        // Inner labels always visible
        title: "${data.title}\n${Converters.formatNumber(data.value!)}\n${Converters.formatNumber((((data.value ?? 1.0) / total) * 100))}%",
        color: data.color,
        radius: radius,
        titleStyle: TextStyle(
          color: Colors.white, 
          fontSize: isMobile ? 8 : 10,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              offset: const Offset(1, 1),
              blurRadius: 2,
              color: Colors.black.withOpacity(0.7),
            ),
          ],
        ),
        borderSide: isTouched
            ? BorderSide(
                color: borderColor,
                strokeAlign: 10,
                width: 5,
              )
            : null,
        // Outside badge only appears on hover
        badgeWidget: isTouched ? badgeLabel(data) : null,
        badgePositionPercentageOffset: 0.8,
      );
    });
    print("widget.lidt.dataaaa444 ${list.length}");

    return list;
  }

  Widget badgeLabel(PieChartModel data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: data.color!, width: 2),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black.withOpacity(0.3),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            (data.title ?? "NONE").length > 15
                ? "${(data.title ?? "NONE").substring(0, 15)}..."
                : (data.title ?? "NONE"),
            style: const TextStyle(
              color: Colors.white, 
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            Converters.formatNumber(data.value!),
            style: TextStyle(
              color: data.color, 
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            "${Converters.formatNumber((((data.value ?? 1.0) / total) * 100))}%",
            style: const TextStyle(
              color: Colors.white70, 
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ],
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