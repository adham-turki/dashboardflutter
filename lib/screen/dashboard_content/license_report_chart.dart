import 'package:bi_replicate/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import '../../utils/constants/constants.dart';
import '../../widget/custom_date_picker.dart';
import '../../widget/drop_down/custom_dropdown.dart';
import 'bar_chart_data.dart';

class LicenseReportChart extends StatefulWidget {
  const LicenseReportChart({Key? key}) : super(key: key);

  @override
  _LicenseReportChartState createState() => _LicenseReportChartState();
}

class _LicenseReportChartState extends State<LicenseReportChart> {
  List<BarData> barData = [];

  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  // TextEditingController toDateController =
  //     TextEditingController(text: "2023-10-09");
  //LicenceReportController licenceReportController = LicenceReportController();
  String selectedPerValue = "monthly";
  List<String> perList = ["weekly", "monthly"];

  @override
  void initState() {
    super.initState();
    //  getLicenseReportData();
  }

  @override
  Widget build(BuildContext context) {
    double dropdowmHeight = MediaQuery.of(context).size.height * 0.15;

    return Container(
      height: 500,
      width: double.infinity,
      padding: EdgeInsets.all(appPadding),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Licenses Report",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: textColor,
            ),
          ),
          Row(
            children: [
              CustomDatePicker(
                label: "From Date",
                //  initialValue: "2022-10-10",
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    // fromDateController.text = value;
                    // getLicenseReportData();
                  }
                },
                controller: fromDate,
                date: DateTime.parse(toDate.text),
              ),
              // CustomDatePicker(
              //   label: "To Date",
              //   initialValue: "2023-10-09",
              //   onChanged: (value) {
              //     if (value.isNotEmpty) {
              //       toDateController.text = value;
              //       getLicenseReportData();
              //     }
              //   },
              // ),
              CustomDropDown(
                label: 'Per',
                initialValue: "monthly",
                // searchBox: false,
                // valSelected: true,
                // heightVal: dropdowmHeight,
                items: perList,
                onChanged: (value) {
                  selectedPerValue = value!;
                  //  getLicenseReportData();
                },
              ),
            ],
          ),
          Expanded(
            child: BalanceBarChart(
              data: barData,
            ),
          )
        ],
      ),
    );
  }

  // Future getLicenseReportData() async {
  //   DateModel dateModel =
  //       DateModel(fromDate: fromDateController.text, per: selectedPerValue);
  //   barData.clear();

  //   licenceReportController.getLicenseReport(dateModel).then((value) {
  //     for (var element in value) {
  //       setState(() {
  //         barData.add(BarData(
  //             name: element.periodLabel, percent: element.numOfLicenses));
  //       });
  //     }
  //   });
  // }
}
