import 'package:bi_replicate/model/bar_chart_data_model.dart';
import 'package:bi_replicate/screen/dashboard_content/bar_chart_sales_dashboard.dart';
import 'package:bi_replicate/screen/dashboard_content/daily_sales_dashboard.dart';
import 'package:flutter/material.dart';
import '../../components/charts.dart';
import '../../components/customCard.dart';
import '../../controller/vouch_header_transiet_controller.dart';
import '../../model/chart/pie_chart_model.dart';
import '../../model/vouch_header_transiet_model.dart';
import '../../utils/constants/responsive.dart';
import '../../utils/func/converters.dart';
import 'branches_sales_cat_dashboard.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DashboardContent extends StatefulWidget {
  const DashboardContent({Key? key}) : super(key: key);

  @override
  _DashboardContentState createState() => _DashboardContentState();
}

double width = 0;
double height = 0;

class _DashboardContentState extends State<DashboardContent> {
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  var period = "";
  var status = "";
  String todayDate = "";

  List<PieChartModel> pieData = [];
  List<BarData> barDataCashFlows = [];
  List<PieChartModel> barDataDailySales = [];
  List<BarChartData> barData1 = [];
  List<BarChartData> barData2 = [];
  VouchHeaderTransietModel vouchHeaderTransietModel = VouchHeaderTransietModel(
      paidSales: 0, returnSales: 0.0, numOfCustomers: 0);

  late AppLocalizations locale;
  @override
  void didChangeDependencies() async {
    locale = AppLocalizations.of(context)!;
    VouchHeaderTransietController().getBranch().then((value) {
      setState(() {
        vouchHeaderTransietModel = value!;
      });
    });
    setState(() {});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = Responsive.isDesktop(context);
    bool isMobile = Responsive.isMobile(context);
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!Responsive.isMobile(context))
                          Expanded(
                            flex: 2,
                            child: BalanceBarChartDashboard(),
                          ),
                        if (!Responsive.isMobile(context))
                          Expanded(
                            flex: 2,
                            child: DailySalesDashboard(),
                          ),
                      ],
                    ),
                    if (Responsive.isMobile(context))
                      BalanceBarChartDashboard(),
                    if (Responsive.isMobile(context)) DailySalesDashboard(),
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
                    BranchesSalesByCatDashboard(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Column cardsMobileView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomCard(
          gradientColor: const [Color(0xff1cacff), Color(0xff30c4ff)],
          title: Converters.formatNumber(
                  vouchHeaderTransietModel.paidSales.toDouble())
              .toString(),
          subtitle: '',
          label: locale.totalSales,
          icon: Icons.attach_money,
        ),
        const SizedBox(
          height: 10,
        ),
        CustomCard(
          gradientColor: const [Color(0xfffd8236), Color(0xffffce6c)],
          title: Converters.formatNumber(
                  vouchHeaderTransietModel.returnSales.toDouble())
              .toString(),
          subtitle: '',
          label: locale.totalReturnSal,
          icon: Icons.assignment_return_outlined,
        ),
        const SizedBox(
          height: 10,
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
          icon: Icons.bar_chart,
        ),
      ],
    );
  }

  Row cardsDesktopView() {
    return Row(
      children: [
        CustomCard(
          gradientColor: const [Color(0xff1cacff), Color(0xff30c4ff)],
          title: Converters.formatNumber(
                  vouchHeaderTransietModel.paidSales.toDouble())
              .toString(),
          subtitle: '',
          label: locale.totalSales,
          icon: Icons.attach_money,
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
          icon: Icons.bar_chart,
        ),
      ],
    );
  }
}
