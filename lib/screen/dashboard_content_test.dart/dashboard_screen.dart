import 'dart:async';

import 'package:bi_replicate/components/dashboard_components/card_content.dart';
import 'package:bi_replicate/screen/dashboard_content/branches_sales_cat_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../controller/vouch_header_transiet_controller.dart';
import '../../model/vouch_header_transiet_model.dart';
import '../../utils/constants/responsive.dart';
import '../../utils/func/converters.dart';
import '../../utils/func/dates_controller.dart';
import '../../widget/sidebar/custom_cards.dart';
import '../dashboard_content/bar_chart_sales_dashboard.dart';
import '../dashboard_content/daily_sales_dashboard.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double width = 0;
  double height = 0;
  bool isDesktop = false;
  late AppLocalizations locale;
  Timer? _timer;

  VouchHeaderTransietModel vouchHeaderTransietModel = VouchHeaderTransietModel(
      paidSales: 0, returnSales: 0.0, numOfCustomers: 0);
  String fromDateEn =
      DatesController().formatDate(DatesController().currentMonth());
  String fromDateAr = DatesController().formatDateReverse(
      DatesController().formatDate(DatesController().currentMonth()));
  String toDateEn = DatesController().formatDate(DatesController().todayDate());
  String toDateAr = DatesController().formatDateReverse(
      DatesController().formatDate(DatesController().todayDate()));
  @override
  void didChangeDependencies() {
    locale = AppLocalizations.of(context)!;
    VouchHeaderTransietController().getBranch().then((value) {
      setState(() {
        vouchHeaderTransietModel = value!;
      });
    });
    _startTimer();

    super.didChangeDependencies();
  }

  void _startTimer() {
    const storage = FlutterSecureStorage();

    const duration = Duration(minutes: 5);
    _timer = Timer.periodic(duration, (Timer t) async {
      String? token = await storage.read(key: "jwt");
      if (token != null) {
        VouchHeaderTransietController().getBranch().then((value) {
          setState(() {
            vouchHeaderTransietModel = value!;
          });
        });
      } else {
        _timer!.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    isDesktop = Responsive.isDesktop(context);

    return isDesktop ? desktopDashboard() : mobileDashboard();
  }

  Widget desktopDashboard() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CustomCards(
                          height: height * 0.216,
                          content: CardContent(
                            title: locale.totalSales,
                            dates: locale.localeName == "en"
                                ? "$fromDateEn - $toDateEn"
                                : "$fromDateAr - $toDateAr",
                            value: Converters.formatNumber(
                                    vouchHeaderTransietModel.paidSales
                                        .toDouble())
                                .toString(),
                            icon: Icons.monetization_on,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.009,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomCards(
                          height: height * 0.216,
                          content: CardContent(
                            title: locale.totalReturnSal,
                            dates: locale.localeName == "en"
                                ? "$fromDateEn - $toDateEn"
                                : "$fromDateAr - $toDateAr",
                            value: Converters.formatNumber(
                                    vouchHeaderTransietModel.returnSales
                                        .toDouble())
                                .toString(),
                            icon: Icons.assignment_return_outlined,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // SizedBox(
                  //   height: height * 0.009,
                  // ),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: CustomCards(
                  //         height: height * 0.144,
                  //         content: CardContent(
                  //           title: locale.numOfCustomers,
                  //           value: Converters.formatNumber(
                  //                   vouchHeaderTransietModel.numOfCustomers
                  //                       .toDouble())
                  //               .toString(),
                  //           icon: Icons.people,
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
            SizedBox(
              width: width * 0.003,
            ),
            Expanded(
              flex: 3,
              child: CustomCards(
                height: height * 0.45,
                content: const DailySalesDashboard(),
              ),
            )
          ],
        ),
        SizedBox(
          height: height * 0.005,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: CustomCards(
                height: height * 0.45,
                content: const BalanceBarChartDashboard(),
              ),
            ),
            SizedBox(
              width: width * 0.002,
            ),
            Expanded(
              flex: 3,
              child: CustomCards(
                height: height * 0.45,
                content: const BranchesSalesByCatDashboard(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget mobileDashboard() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: CustomCards(
                height: 150,
                content: CardContent(
                  title: locale.totalSales,
                  dates: locale.localeName == "ar"
                      ? "$fromDateEn - $toDateEn"
                      : "$fromDateEn - $toDateEn",
                  value: Converters.formatNumber(
                          vouchHeaderTransietModel.paidSales.toDouble())
                      .toString(),
                  icon: Icons.monetization_on,
                ),
              ),
            ),
            SizedBox(
              width: width * 0.01,
            ),
            Expanded(
              child: CustomCards(
                height: 150,
                content: CardContent(
                  title: locale.totalReturnSal,
                  dates: locale.localeName == "ar"
                      ? "$fromDateEn - $toDateEn"
                      : "$fromDateEn - $toDateEn",
                  value: Converters.formatNumber(
                          vouchHeaderTransietModel.returnSales.toDouble())
                      .toString(),
                  icon: Icons.assignment_return_outlined,
                ),
              ),
            ),
            // SizedBox(
            //   width: width * 0.003,
            // ),
            // Expanded(
            //   child: CustomCards(
            //     height: 150,
            //     content: CardContent(
            //       title: locale.numOfCustomers,
            //       dates: locale.localeName == "ar"
            //           ? "$fromDateEn - $toDateEn"
            //           : "$fromDateEn - $toDateEn",
            //       value: Converters.formatNumber(
            //               vouchHeaderTransietModel.numOfCustomers.toDouble())
            //           .toString(),
            //       icon: Icons.people,
            //     ),
            //   ),
            // ),
          ],
        ),
        SizedBox(
          height: height * 0.009,
        ),
        Row(
          children: [
            Expanded(
              child: CustomCards(
                height: height * 0.5,
                content: const DailySalesDashboard(),
              ),
            )
          ],
        ),
        SizedBox(
          height: height * 0.01,
        ),
        Row(
          children: [
            Expanded(
              child: CustomCards(
                height: height * 0.5,
                content: const BalanceBarChartDashboard(),
              ),
            )
          ],
        ),
        SizedBox(
          height: height * 0.01,
        ),
        Row(
          children: [
            Expanded(
              child: CustomCards(
                height: height * 0.5,
                content: const BranchesSalesByCatDashboard(),
              ),
            )
          ],
        ),
      ],
    );
  }
}
