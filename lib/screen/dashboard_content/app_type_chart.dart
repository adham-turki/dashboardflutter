import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../utils/constants/colors.dart';
import '../../utils/constants/constants.dart';

class AppTypeChart extends StatefulWidget {
  @override
  _AppTypeChartState createState() => _AppTypeChartState();
}

class _AppTypeChartState extends State<AppTypeChart> {
  List<ChartData> chartData = [];

  @override
  void initState() {
    super.initState();
    // fetchData();
  }

  // void fetchData() async {
  //   final appTypeReportController = AppTypeReportController();
  //   final apiData = await appTypeReportController.getAppTypeList();

  //   // Convert API data into ChartData objects
  //   apiData.forEach((item) {
  //     chartData.add(ChartData(
  //       item.applicationType!,
  //       item.registered!,
  //       item.unRegistered!,
  //       item.canceled!,
  //     ));
  //   });

  //   // Call setState to rebuild the widget with the new data
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      padding: EdgeInsets.all(appPadding),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.circle,
                    color: Color(0xFF219C90),
                    size: 12,
                  ),
                  SizedBox(
                    width: appPadding / 2,
                  ),
                  Text(
                    'Registered',
                    style: TextStyle(
                      color: textColor.withOpacity(0.5),
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.circle,
                    color: Color(0xFFEE9322),
                    size: 12,
                  ),
                  SizedBox(
                    width: appPadding / 2,
                  ),
                  Text(
                    'UnRegistered',
                    style: TextStyle(
                      color: textColor.withOpacity(0.5),
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.circle,
                    color: Color(0xFFC1D8C3),
                    size: 12,
                  ),
                  SizedBox(
                    width: appPadding / 2,
                  ),
                  Text(
                    'Canceled',
                    style: TextStyle(
                      color: textColor.withOpacity(0.5),
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ],
          ),
          SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            series: <ChartSeries>[
              ColumnSeries<ChartData, String>(
                dataSource: chartData,
                xValueMapper: (ChartData data, _) => data.applicationType,
                yValueMapper: (ChartData data, _) => data.registered,
                name: 'Registered',
                color: Color(0xFF219C90),
                dataLabelSettings: DataLabelSettings(isVisible: true),
              ),
              ColumnSeries<ChartData, String>(
                dataSource: chartData,
                xValueMapper: (ChartData data, _) => data.applicationType,
                yValueMapper: (ChartData data, _) => data.unRegistered,
                name: 'Unregistered',
                color: Color(0xFFEE9322),
                dataLabelSettings: DataLabelSettings(isVisible: true),
              ),
              ColumnSeries<ChartData, String>(
                dataSource: chartData,
                xValueMapper: (ChartData data, _) => data.applicationType,
                yValueMapper: (ChartData data, _) => data.canceled,
                name: 'Canceled',
                color: Color(0xFFC1D8C3),
                dataLabelSettings: DataLabelSettings(isVisible: true),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(
      this.applicationType, this.registered, this.unRegistered, this.canceled);

  final String applicationType;
  final int registered;
  final int unRegistered;
  final int canceled;
}
