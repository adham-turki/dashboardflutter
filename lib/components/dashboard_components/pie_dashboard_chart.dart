import 'package:bi_replicate/screen/dashboard_content/dashboard.dart';
import 'package:flutter/material.dart';

import '../../model/chart/pie_chart_model.dart';
import '../../utils/constants/responsive.dart';
import '../charts/pie_chart.dart';

class PieDashboardChart extends StatefulWidget {
  final List<PieChartModel> dataList;

  const PieDashboardChart({super.key, required this.dataList});

  @override
  State<PieDashboardChart> createState() => _PieDashboardChartState();
}

class _PieDashboardChartState extends State<PieDashboardChart> {
  List<PieChartModel> dataList = [];
  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    dataList = [];

    dataList = widget.dataList;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: isMobile ? 0 : 14.0),
          ),
          Expanded(
            child: PieChartComponent(
              dataList: dataList,
            ),
          ),
        ],
      ),
    );
  }
}