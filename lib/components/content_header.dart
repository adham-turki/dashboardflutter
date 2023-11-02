import 'package:bi_replicate/model/vouch_header_transiet_model.dart';
import 'package:bi_replicate/provider/screen_content_provider.dart';
import 'package:bi_replicate/utils/constants/responsive.dart';
import 'package:bi_replicate/utils/func/converters.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

import '../controller/vouch_header_transiet_controller.dart';
import '../provider/local_provider.dart';
import '../widget/language_widget.dart';
import 'customCard.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ContentHeader extends StatefulWidget {
  int page;
  ContentHeader({super.key, required this.page});

  @override
  State<ContentHeader> createState() => _ContentHeaderState();
}

class _ContentHeaderState extends State<ContentHeader> {
  double width = 0;
  double height = 0;
  late ScreenContentProvider provider;
  late AppLocalizations locale;
  VouchHeaderTransietModel vouchHeaderTransietModel = VouchHeaderTransietModel(
      paidSales: 0, returnSales: 0.0, numOfCustomers: 0);
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    locale = AppLocalizations.of(context);
    VouchHeaderTransietController().getBranch().then((value) {
      setState(() {
        vouchHeaderTransietModel = value!;
        print("hhhhhhhhhhhhh: ${value.numOfCustomers}");
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    provider = context.read<ScreenContentProvider>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Responsive.isDesktop(context)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Consumer<ScreenContentProvider>(
                      builder: ((context, value, child) {
                    return Column(
                      children: [
                        SelectableText(
                          maxLines: 1,
                          getPage(),
                          style: TextStyle(
                            fontSize: context
                                        .read<ScreenContentProvider>()
                                        .getPage() ==
                                    0
                                ? (Responsive.isDesktop(context)
                                    ? width * 0.01
                                    : 15)
                                : (Responsive.isDesktop(context)
                                    ? width * 0.015
                                    : 18),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    );
                  })),
                  SelectableText(
                    maxLines: 1,
                    "${locale.baseCurrency}: ${locale.ils}",
                    style: TextStyle(
                      fontSize:
                          context.read<ScreenContentProvider>().getPage() == 0
                              ? (Responsive.isDesktop(context)
                                  ? width * 0.01
                                  : 15)
                              : (Responsive.isDesktop(context)
                                  ? width * 0.015
                                  : 18),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Consumer<ScreenContentProvider>(
                      builder: ((context, value, child) {
                    return SelectableText(
                      maxLines: 1,
                      getPage(),
                      style: TextStyle(
                        fontSize:
                            Responsive.isDesktop(context) ? width * 0.015 : 18,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  })),
                  SelectableText(
                    maxLines: 1,
                    "${locale.baseCurrency}: ${locale.ils}",
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
        // SizedBox(
        //   height: height * 0.04,
        // ),
        // widget.page == 0
        //     ? Responsive.isDesktop(context)
        //         ? Row(
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             children: [
        //               CustomCard(
        //                 gradientColor: const [
        //                   Color(0xff1cacff),
        //                   Color(0xff30c4ff)
        //                 ],
        //                 title: Converters.formatNumber(
        //                         vouchHeaderTransietModel.paidSales.toDouble())
        //                     .toString(),
        //                 subtitle: '',
        //                 label: locale.totalSales,
        //                 icon: Icons
        //                     .attach_money, // Provide the actual path to the icon
        //               ),
        //               const SizedBox(
        //                 width: 10,
        //               ),
        //               CustomCard(
        //                 gradientColor: const [
        //                   Color(0xfffd8236),
        //                   Color(0xffffce6c)
        //                 ],
        //                 title: Converters.formatNumber(
        //                         vouchHeaderTransietModel.returnSales
        //                             .toDouble())
        //                     .toString(),
        //                 subtitle: '',
        //                 label: locale.totalReturnSal,
        //                 icon: Icons
        //                     .assignment_return_outlined, // Provide the actual path to the icon
        //               ),
        //               const SizedBox(
        //                 width: 10,
        //               ),
        //               CustomCard(
        //                 gradientColor: const [
        //                   Color(0xff4741c1),
        //                   Color(0xff7e4fe4)
        //                 ],
        //                 title: Converters.formatNumber(
        //                         vouchHeaderTransietModel.numOfCustomers
        //                             .toDouble())
        //                     .toString(),
        //                 subtitle: '',
        //                 label: locale.numOfCustomers,
        //                 icon: Icons
        //                     .bar_chart, // Provide the actual path to the icon
        //               ),
        //             ],
        //           )
        //         : SizedBox(
        //             width: width * 0.8,
        //             height: height * 0.16,
        //             child: ListView(
        //               scrollDirection: Axis.horizontal,
        //               children: [
        //                 CustomCard(
        //                   gradientColor: const [
        //                     Color(0xff1cacff),
        //                     Color(0xff30c4ff)
        //                   ],
        //                   title: Converters.formatNumber(
        //                           vouchHeaderTransietModel.paidSales
        //                               .toDouble())
        //                       .toString(),
        //                   subtitle: '',
        //                   label: locale.totalSales,
        //                   icon: Icons
        //                       .attach_money, // Provide the actual path to the icon
        //                 ),
        //                 const SizedBox(
        //                   width: 10,
        //                 ),
        //                 CustomCard(
        //                   gradientColor: const [
        //                     Color(0xfffd8236),
        //                     Color(0xffffce6c)
        //                   ],
        //                   title: Converters.formatNumber(
        //                           vouchHeaderTransietModel.returnSales
        //                               .toDouble())
        //                       .toString(),
        //                   subtitle: '',
        //                   label: locale.totalReturnSal,
        //                   icon: Icons
        //                       .assignment_return_outlined, // Provide the actual path to the icon
        //                 ),
        //                 const SizedBox(
        //                   width: 10,
        //                 ),
        //                 CustomCard(
        //                   gradientColor: const [
        //                     Color(0xff4741c1),
        //                     Color(0xff7e4fe4)
        //                   ],
        //                   title: Converters.formatNumber(
        //                           vouchHeaderTransietModel.numOfCustomers
        //                               .toDouble())
        //                       .toString(),
        //                   subtitle: '',
        //                   label: locale.numOfCustomers,
        //                   icon: Icons
        //                       .bar_chart, // Provide the actual path to the icon
        //                 ),
        //               ],
        //             ),
        //           )
        //:

        Container(),
      ],
    );
  }

  String getPage() {
    int index = context.read<ScreenContentProvider>().getPage();
    switch (index) {
      case 0:
        return locale.dashboard;
      case 1:
        return locale.salesByBranches;
      case 2:
        return locale.branchesSalesByCategories;
      case 3:
        return locale.dailySales;
      case 4:
        return locale.totalCollections;
      case 5:
        return locale.cashFlows;
      case 6:
        return locale.expenses;
      case 7:
        return locale.inventoryPerformance;
      case 8:
        return locale.monthlyComparsionOFReceivableAndPayables;
      case 9:
        return locale.agingReceivable;
      case 10:
        return locale.chequesAndBank;
      case 11:
        return locale.outStandingCheques;
      case 12:
        return locale.totalSales;
      case 13:
        return locale.salesreport;
      case 14:
        return locale.purchasesReport;
      case 15:
        return locale.setup;
      case 16:
        return locale.changePassword;
      default:
        return "";
    }
  }
}
