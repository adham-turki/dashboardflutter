import 'package:bi_replicate/screen/dashboard_content/bar_chart_sales_dashboard.dart';
import 'package:bi_replicate/screen/dashboard_content/total_status_values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../utils/constants/constants.dart';
import '../../utils/constants/responsive.dart';
import 'app_type_chart.dart';
import 'license_report_chart.dart';

class DashboardContent extends StatefulWidget {
  const DashboardContent({Key? key}) : super(key: key);

  @override
  _DashboardContentState createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  @override
  Widget build(BuildContext context) {
    bool isDesktop = Responsive.isDesktop(context);
    bool isMobile = Responsive.isMobile(context);
    return Expanded(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 5,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 8,
                            ),
                            BalanceBarChartDashboard(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 5,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: appPadding,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (!Responsive.isMobile(context))
                                  Expanded(
                                    flex: 2,
                                    child: AppTypeChart(),
                                  ),
                                if (!Responsive.isMobile(context))
                                  const SizedBox(
                                    width: appPadding,
                                  ),
                                Expanded(
                                  flex: 1,
                                  child: StatusChart(),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: appPadding,
                            ),
                            if (Responsive.isMobile(context))
                              SizedBox(
                                height: appPadding,
                              ),
                            if (Responsive.isMobile(context)) AppTypeChart(),
                            if (Responsive.isMobile(context))
                              SizedBox(
                                height: appPadding,
                              ),
                            // if (Responsive.isMobile(context)) StatusChart(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Expanded(
                  //       flex: 5,
                  //       child: Column(
                  //         children: [
                  //           LicenseReportChart(),
                  //           if (Responsive.isMobile(context))
                  //             SizedBox(
                  //               height: appPadding,
                  //             ),
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
