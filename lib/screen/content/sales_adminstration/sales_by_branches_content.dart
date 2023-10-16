import 'package:bi_replicate/components/charts/pie_chart.dart';
import 'package:bi_replicate/utils/constants/responsive.dart';
import 'package:bi_replicate/utils/constants/styles.dart';
import 'package:bi_replicate/widget/custom_date_picker.dart';
import 'package:bi_replicate/widget/custom_dropdown.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart';

import '../../../model/chart/pie_chart_model.dart';

class SalesByBranchesContent extends StatefulWidget {
  const SalesByBranchesContent({super.key});

  @override
  State<SalesByBranchesContent> createState() => _SalesByBranchesContentState();
}

class _SalesByBranchesContentState extends State<SalesByBranchesContent> {
  double width = 0;
  double height = 0;

  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();

  List<PieChartModel> list = [
    PieChartModel(value: 10, title: "1", color: Colors.blue),
    PieChartModel(value: 20, title: "2", color: Colors.red),
    PieChartModel(value: 30, title: "3", color: Colors.green),
    PieChartModel(value: 40, title: "4", color: Colors.purple),
  ];

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Container(
        height: height,
        decoration: const BoxDecoration(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: width * 0.7,
              decoration: borderDecoration,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Responsive.isDesktop(context)
                    ? desktopCriteria()
                    : mobileCriteria(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: width * 0.7,
                height:
                    Responsive.isDesktop(context) ? height * 0.6 : height * 0.5,
                decoration: borderDecoration,
                child: Column(
                  children: [
                    Row(
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Chart Title",
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                      ],
                    ),
                    PieChartComponent(
                      radiusNormal: Responsive.isDesktop(context) ? 130 : 70,
                      radiusHover: Responsive.isDesktop(context) ? 140 : 80,
                      width: Responsive.isDesktop(context) ? 400 : width * 0.1,
                      height:
                          Responsive.isDesktop(context) ? 450 : height * 0.4,
                      dataList: list,
                    ),
                    const SizedBox(), //Footer
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row desktopCriteria() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CustomDropDown(
          label: "Period",
        ),
        CustomDatePicker(
          label: "From Date",
          controller: _fromDateController,
        ),
        CustomDatePicker(
          label: "To Date",
          controller: _toDateController,
        ),
        CustomDropDown(
          label: "Chart Type",
        ),
      ],
    );
  }

  Column mobileCriteria() {
    double widthMobile = width;
    return Column(
      children: [
        CustomDropDown(
          width: widthMobile,
          label: "Period",
        ),
        CustomDatePicker(
          label: "From Date",
          controller: _fromDateController,
        ),
        CustomDatePicker(
          label: "To Date",
          controller: _toDateController,
        ),
        CustomDropDown(
          width: widthMobile,
          label: "Chart Type",
        ),
      ],
    );
  }
}
