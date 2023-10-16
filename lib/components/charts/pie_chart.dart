import 'package:bi_replicate/model/custom_scroll_behavior.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../model/chart/pie_chart_model.dart';
import 'indicator.dart';

class PieChartComponent extends StatefulWidget {
  final double? width;
  final double? height;
  final List<PieChartModel> dataList;
  const PieChartComponent({
    super.key,
    required this.dataList,
    this.width,
    this.height,
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

  @override
  void initState() {
    //Check width and height
    if (widget.width != null) {
      width = widget.width!;
    }
    if (widget.height != null) {
      height = widget.height!;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<PieChartModel> dataList = widget.dataList;
    bool isEmpty = dataList.isEmpty ? true : false;

    return Column(
      children: [
        SizedBox(
          width: width,
          height: height,
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
                    touchedIndex =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              sections: isEmpty ? noDataList() : showList(dataList),
            ),
            swapAnimationDuration: Duration(milliseconds: duration),
          ),
        ),
        Container(
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
    );
  }

  List<PieChartSectionData> showList(List<PieChartModel> dataList) {
    return List.generate(dataList.length, (i) {
      bool isTouched = i == touchedIndex;
      final radius = isTouched ? radiusHover : radiusNormal;
      PieChartModel data = dataList[i];
      return PieChartSectionData(
        value: data.value,
        title: data.value.toString(),
        color: data.color,
        radius: radius,
        titleStyle: const TextStyle(color: Colors.white),
        borderSide: isTouched
            ? const BorderSide(
                color: Colors.white,
                strokeAlign: 10,
                width: 5,
              )
            : null,
        badgeWidget: Padding(
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
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                data.title ?? "NONE",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        badgePositionPercentageOffset: 1.3,
      );
    });
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
          text: data.title!,
        ),
      );
    });
  }
}
