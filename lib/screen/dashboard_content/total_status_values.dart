import 'package:bi_replicate/utils/constants/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../utils/constants/constants.dart';
// import '../../constants/constants.dart';
// import '../../controllers/status_chart_controller.dart';
// import '../../models/status_chart_model.dart';

class StatusChart extends StatefulWidget {
  @override
  _StatusChartState createState() => _StatusChartState();
}

class _StatusChartState extends State<StatusChart> {
  // StatusChartController statusChartController = StatusChartController();
  // late StatusChartModel statusChartModel;

  double? registeredValue = 0;
  double? unregisteredValue = 0;
  double? canceledValue = 0;

  @override
  void initState() {
    super.initState();
    // getStatusValues();
  }

  // void getStatusValues() async {
  //   final StatusChartModel statusChartModel =
  //       await statusChartController.getAllStatusValues();

  //   setState(() {
  //     registeredValue = statusChartModel.registered!.toDouble();
  //     unregisteredValue = statusChartModel.unRegistered!.toDouble();
  //     canceledValue = statusChartModel.canceled!.toDouble();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final totalValues = registeredValue! + unregisteredValue! + canceledValue!;

    final registeredPercentage = ((registeredValue!) / totalValues) * 100;
    final unregisteredPercentage = ((unregisteredValue!) / totalValues) * 100;
    final canceledPercentage = ((canceledValue!) / totalValues) * 100;

    return Container(
      height: 400,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(10),
      ),
      // padding: EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.5,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 1,
                  centerSpaceRadius: 60,
                  sections: [
                    PieChartSectionData(
                      color: Color(0xFF219C90),
                      value: registeredValue,
                      title: '${registeredPercentage.toStringAsFixed(2)}%',
                      radius: 50,
                    ),
                    PieChartSectionData(
                      color: Color(0xFFEE9322),
                      value: unregisteredValue,
                      title: '${unregisteredPercentage.toStringAsFixed(2)}%',
                      radius: 50,
                    ),
                    PieChartSectionData(
                      color: Color(0xFFC1D8C3),
                      value: canceledValue,
                      title: '${canceledPercentage.toStringAsFixed(2)}%',
                      radius: 50,
                    ),
                  ],
                ),
              ),
            ),
            // SizedBox(
            //   height: 30,
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
          ],
        ),
      ),
    );
  }
}
