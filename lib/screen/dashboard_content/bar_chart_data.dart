import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BarData {
  final String? name;
  final double? percent;

  BarData({required this.name, required this.percent});
}

class BalanceBarChart extends StatelessWidget {
  final List<BarData> data;

  const BalanceBarChart({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: SfCartesianChart(
        isTransposed: true,
        primaryXAxis: CategoryAxis(),
        plotAreaBorderWidth: 0,
        series: <ChartSeries>[
          BarSeries<BarData, String>(
              dataSource: data,
              xValueMapper: (BarData value, _) => value.name,
              yValueMapper: (BarData value, _) => value.percent,
              enableTooltip: true,
              animationDuration: 1000,
              color: Color(0xFFEE9322),
              dataLabelSettings: DataLabelSettings(
                isVisible: true,
                textStyle: TextStyle(
                    color: Color(0xFF219C90), fontWeight: FontWeight.w600),
              ))
        ],
      ),
    );
  }
}
