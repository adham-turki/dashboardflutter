import 'package:bi_replicate/controller/currency_controller.dart';
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
  String baseCurrency = "";
  @override
  void didChangeDependencies() {
    locale = AppLocalizations.of(context)!;
    // VouchHeaderTransietController().getBranch().then((value) {
    //   setState(() {
    //     vouchHeaderTransietModel = value!;
    //   });
    // });
    todayDate = DatesController().formatDate(DatesController().todayDate());
    currentMonth =
        DatesController().formatDate(DatesController().twoYearsAgo());

    fromDateController.text = currentMonth;
    toDateController.text = todayDate;

    super.didChangeDependencies();
  }

  @override
  void initState() {
    getBaseCurrency();
    super.initState();
  }

  getBaseCurrency() async {
    await CurrencyController().getBaseCurrencyModel().then((value) {
      print("asdasdasdasdasdasdasdasd1111: ${value.txtCode}");
      if (value.txtCode != "") {
        baseCurrency = value.txtCode ?? "";
        print("asdasdsadasd: $baseCurrency");
        setState(() {});
      }
    });
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        
        borderRadius: BorderRadius.circular(8),
        
        
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Consumer<ScreenContentProvider>(builder: ((context, value, child) {
            return Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.shade600,
                      Colors.blue.shade700,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getPageIcon(),
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: SelectableText(
                        getPage(),
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 0.3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          })),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.green.shade50,
                  Colors.green.shade100,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: Colors.green.shade200,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.account_balance_wallet_outlined,
                  color: Colors.green.shade700,
                  size: 14,
                ),
                const SizedBox(width: 6),
                SelectableText(
                  "${locale.baseCurrency}: $baseCurrency",
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.green.shade700,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row mobileView(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Consumer<ScreenContentProvider>(builder: ((context, value, child) {
          return Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.shade600,
                    Colors.blue.shade700,
                  ],
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getPageIcon(),
                    color: Colors.white,
                    size: 12,
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: SelectableText(
                      getPage(),
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        })),
        const SizedBox(width: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.green.shade200),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.account_balance_wallet_outlined,
                color: Colors.green.shade700,
                size: 12,
              ),
              const SizedBox(width: 4),
              SelectableText(
                "${locale.baseCurrency}: $baseCurrency",
                maxLines: 1,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.green.shade700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _getPageIcon() {
    int index = context.read<ScreenContentProvider>().getPage();
    switch (index) {
      case 0: return Icons.dashboard_outlined;
      case 1: case 2: case 3: case 4: return Icons.trending_up_outlined;
      case 5: case 6: return Icons.account_balance_outlined;
      case 7: return Icons.inventory_outlined;
      case 8: case 9: return Icons.receipt_long_outlined;
      case 10: case 11: return Icons.payment_outlined;
      case 12: case 13: case 14: return Icons.bar_chart_outlined;
      case 15: case 16: return Icons.people_outline;
      case 17: case 18: return Icons.settings_outlined;
      case 19: case 20: case 21: case 22: case 23: case 24: return Icons.assessment_outlined;
      case 25: case 26: return Icons.star_outline;
      default: return Icons.circle_outlined;
    }
  }

  // Row cardsMobileView() {
  //   return Row(
  //     // crossAxisAlignment: CrossAxisAlignment.center,
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       const SizedBox(
  //         width: 2,
  //       ),
  //       CustomCard(
  //         gradientColor: const [Color(0xff1cacff), Color(0xff30c4ff)],
  //         title: Converters.formatNumber(
  //                 vouchHeaderTransietModel.paidSales.toDouble())
  //             .toString(),
  //         subtitle: '',
  //         label: locale.totalSales,
  //         icon: Icons.attach_money, // Provide the actual path to the icon
  //       ),
  //       const SizedBox(
  //         width: 2,
  //       ),
  //       CustomCard(
  //         gradientColor: const [Color(0xfffd8236), Color(0xffffce6c)],
  //         title: Converters.formatNumber(
  //                 vouchHeaderTransietModel.returnSales.toDouble())
  //             .toString(),
  //         subtitle: '',
  //         label: locale.totalReturnSal,
  //         icon: Icons
  //             .assignment_return_outlined, // Provide the actual path to the icon
  //       ),
  //       const SizedBox(
  //         width: 2,
  //       ),
  //       CustomCard(
  //         gradientColor: const [
  //           Color.fromRGBO(71, 65, 193, 1),
  //           Color(0xff7e4fe4)
  //         ],
  //         title: Converters.formatNumber(
  //                 vouchHeaderTransietModel.numOfCustomers.toDouble())
  //             .toString(),
  //         subtitle: '',
  //         label: locale.numOfCustomers,
  //         icon: Icons.bar_chart, // Provide the actual path to the icon
  //       ),
  //       const SizedBox(
  //         width: 2,
  //       ),
  //     ],
  //   );
  // }

  // Row cardsDesktopView() {
  //   return Row(
  //     // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //     children: [
  //       CustomCard(
  //         gradientColor: const [Color(0xff1cacff), Color(0xff30c4ff)],
  //         title: Converters.formatNumber(
  //                 vouchHeaderTransietModel.paidSales.toDouble())
  //             .toString(),
  //         subtitle: '',
  //         label: locale.totalSales,
  //         icon: Icons.attach_money, // Provide the actual path to the icon
  //       ),
  //       const SizedBox(
  //         width: 10,
  //       ),
  //       CustomCard(
  //         gradientColor: const [Color(0xfffd8236), Color(0xffffce6c)],
  //         title: Converters.formatNumber(
  //                 vouchHeaderTransietModel.returnSales.toDouble())
  //             .toString(),
  //         subtitle: '',
  //         label: locale.totalReturnSal,
  //         icon: Icons
  //             .assignment_return_outlined, // Provide the actual path to the icon
  //       ),
  //       const SizedBox(
  //         width: 10,
  //       ),
  //       CustomCard(
  //         gradientColor: const [Color(0xff4741c1), Color(0xff7e4fe4)],
  //         title: Converters.formatNumber(
  //                 vouchHeaderTransietModel.numOfCustomers.toDouble())
  //             .toString(),
  //         subtitle: '',
  //         label: locale.numOfCustomers,
  //         icon: Icons.bar_chart, // Provide the actual path to the icon
  //       ),
  //     ],
  //   );
  // }

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
      case 21:
        return locale.logsReports;
      case 22:
        return locale.differencesReports;
      case 23:
        return locale.profitReports;
      case 24:
        return locale.otherReports;
      case 25:
        return locale.byBranches;
      case 26:
        return locale.byCustomers;
      // case 33:
      //   return locale.sessionDate;
      default:
        return "";
    }
  }
}