import 'package:bi_replicate/model/vouch_header_transiet_model.dart';
import 'package:bi_replicate/provider/screen_content_provider.dart';
import 'package:bi_replicate/utils/constants/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/vouch_header_transiet_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../utils/func/converters.dart';
import '../utils/func/dates_controller.dart';
import 'customCard.dart';

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
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  String todayDate = "";
  String currentMonth = "";
  VouchHeaderTransietModel vouchHeaderTransietModel = VouchHeaderTransietModel(
      paidSales: 0, returnSales: 0.0, numOfCustomers: 0);

  @override
  void didChangeDependencies() {
    locale = AppLocalizations.of(context)!;
    VouchHeaderTransietController().getBranch().then((value) {
      setState(() {
        vouchHeaderTransietModel = value!;
      });
    });
    todayDate = DatesController().formatDate(DatesController().todayDate());
    currentMonth =
        DatesController().formatDate(DatesController().twoYearsAgo());

    fromDateController.text = currentMonth;
    toDateController.text = todayDate;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    provider = context.read<ScreenContentProvider>();

    return Responsive.isDesktop(context)
        ? desktopView(context)
        : mobileView(context);
  }

  Widget desktopView(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Consumer<ScreenContentProvider>(builder: ((context, value, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SelectableText(
                maxLines: 1,
                getPage(),
                style: TextStyle(
                  fontSize: provider.getPage() == 0
                      ? (Responsive.isDesktop(context) ? width * 0.01 : 15)
                      : (Responsive.isDesktop(context) ? width * 0.012 : 18),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );
        })),
        // provider.getPage() == 0
        //     ? Responsive.isDesktop(context)
        //         ? cardsDesktopView()
        //         : cardsMobileView()
        //     : Container(),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SelectableText(
              maxLines: 1,
              "${locale.baseCurrency}: ${locale.ils}",
              style: TextStyle(
                fontSize: provider.getPage() == 0
                    ? (Responsive.isDesktop(context) ? width * 0.01 : 15)
                    : (Responsive.isDesktop(context) ? width * 0.012 : 18),
              ),
            ),
            // provider.getPage() == 0
            //     ? SelectableText(
            //         maxLines: 1,
            //         "$currentMonth / $todayDate",
            //         style: TextStyle(
            //           fontSize: context
            //                       .read<ScreenContentProvider>()
            //                       .getPage() ==
            //                   0
            //               ? (Responsive.isDesktop(context) ? width * 0.01 : 15)
            //               : (Responsive.isDesktop(context) ? width * 0.01 : 18),
            //         ),
            //       )
            //     : Container(),
          ],
        ),
      ],
    );
  }

  Row mobileView(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Consumer<ScreenContentProvider>(builder: ((context, value, child) {
          return SelectableText(
            maxLines: 1,
            getPage(),
            style: TextStyle(
              fontSize: Responsive.isDesktop(context) ? width * 0.015 : 13,
              fontWeight: FontWeight.w500,
            ),
          );
        })),
        // provider.getPage() == 0
        //     ? SelectableText(
        //         maxLines: 1,
        //         "$currentMonth / $todayDate",
        //         style: TextStyle(
        //           fontSize: provider.getPage() == 0
        //               ? (Responsive.isDesktop(context) ? width * 0.01 : 13)
        //               : (Responsive.isDesktop(context) ? width * 0.01 : 15),
        //         ),
        //       )
        //     : Container(),
        SelectableText(
          maxLines: 1,
          "${locale.baseCurrency}: ${locale.ils}",
          style: TextStyle(
            fontSize: Responsive.isDesktop(context) ? 18 : 14,
          ),
        ),
      ],
    );
  }

  Row cardsMobileView() {
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          width: 2,
        ),
        CustomCard(
          gradientColor: const [Color(0xff1cacff), Color(0xff30c4ff)],
          title: Converters.formatNumber(
                  vouchHeaderTransietModel.paidSales.toDouble())
              .toString(),
          subtitle: '',
          label: locale.totalSales,
          icon: Icons.attach_money, // Provide the actual path to the icon
        ),
        const SizedBox(
          width: 2,
        ),
        CustomCard(
          gradientColor: const [Color(0xfffd8236), Color(0xffffce6c)],
          title: Converters.formatNumber(
                  vouchHeaderTransietModel.returnSales.toDouble())
              .toString(),
          subtitle: '',
          label: locale.totalReturnSal,
          icon: Icons
              .assignment_return_outlined, // Provide the actual path to the icon
        ),
        const SizedBox(
          width: 2,
        ),
        CustomCard(
          gradientColor: const [
            Color.fromRGBO(71, 65, 193, 1),
            Color(0xff7e4fe4)
          ],
          title: Converters.formatNumber(
                  vouchHeaderTransietModel.numOfCustomers.toDouble())
              .toString(),
          subtitle: '',
          label: locale.numOfCustomers,
          icon: Icons.bar_chart, // Provide the actual path to the icon
        ),
        const SizedBox(
          width: 2,
        ),
      ],
    );
  }

  Row cardsDesktopView() {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CustomCard(
          gradientColor: const [Color(0xff1cacff), Color(0xff30c4ff)],
          title: Converters.formatNumber(
                  vouchHeaderTransietModel.paidSales.toDouble())
              .toString(),
          subtitle: '',
          label: locale.totalSales,
          icon: Icons.attach_money, // Provide the actual path to the icon
        ),
        const SizedBox(
          width: 10,
        ),
        CustomCard(
          gradientColor: const [Color(0xfffd8236), Color(0xffffce6c)],
          title: Converters.formatNumber(
                  vouchHeaderTransietModel.returnSales.toDouble())
              .toString(),
          subtitle: '',
          label: locale.totalReturnSal,
          icon: Icons
              .assignment_return_outlined, // Provide the actual path to the icon
        ),
        const SizedBox(
          width: 10,
        ),
        CustomCard(
          gradientColor: const [Color(0xff4741c1), Color(0xff7e4fe4)],
          title: Converters.formatNumber(
                  vouchHeaderTransietModel.numOfCustomers.toDouble())
              .toString(),
          subtitle: '',
          label: locale.numOfCustomers,
          icon: Icons.bar_chart, // Provide the actual path to the icon
        ),
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
        return locale.users;
      case 16:
        return locale.userPermit;
      case 17:
        return locale.setup;
      case 18:
        return locale.changePassword;
      case 19:
        return locale.journalReports;
      case 20:
        return locale.salesReports;
      default:
        return "";
    }
  }
}
