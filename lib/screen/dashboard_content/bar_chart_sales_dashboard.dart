import 'dart:math';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:bi_replicate/model/criteria/search_criteria.dart';
import 'package:bi_replicate/utils/func/converters.dart';

import '../../../controller/sales_adminstration/sales_branches_controller.dart';
import '../../../model/chart/pie_chart_model.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/func/dates_controller.dart';
import '../../components/charts.dart';
import '../../components/charts/pie_chart.dart';
import '../../utils/constants/app_utils.dart';
import '../../utils/constants/constants.dart';
import '../../utils/constants/responsive.dart';
import 'filter_dialog/filter_dialog_sales_branches.dart';

class BalanceBarChartDashboard extends StatefulWidget {
  BalanceBarChartDashboard({
    Key? key,
  }) : super(key: key);

  @override
  _BalanceBarChartDashboardState createState() =>
      _BalanceBarChartDashboardState();
}

class _BalanceBarChartDashboardState extends State<BalanceBarChartDashboard> {
  List<CustomBarChart> data = [];
  double width = 0;
  final dropdownKey = GlobalKey<DropdownButton2State>();
  double height = 0;
  bool temp = false;
  SalesBranchesController salesBranchesController = SalesBranchesController();

  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  var period = "";
  var statusVar = "";
  String todayDate = "";

  late AppLocalizations _locale;
  TextEditingController fromCont = TextEditingController();
  TextEditingController toCont = TextEditingController();

  final dataMap = <String, double>{};

  List<double> listOfBalances = [];
  List<String> listOfPeriods = [];

  // var selectedPeriod = "";

  List<BarData> barData = [];
  List<PieChartModel> pieData = [];

  bool isDesktop = false;

  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context);
    todayDate = DatesController().formatDateReverse(
        DatesController().formatDate(DatesController().todayDate()));
    // fromCont.text = todayDate;
    // toCont.text = todayDate;

    print("in bar :${fromCont.text}");

    //  getSalesByBranch();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    print("inistiate fromDate :${fromCont.text}");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("inBuild fromcot :${fromCont.text}");
    // fromCont = widget.fromDateController;
    // toCont = widget.toDateController;

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    isDesktop = Responsive.isDesktop(context);
    // getSalesByBranch();
    print("******************************");
    return SingleChildScrollView(
      child: Container(
        // height: height * 1.7,
        decoration: const BoxDecoration(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: isDesktop ? height * 0.59 : height * 0.67,
                width: double.infinity,
                padding: EdgeInsets.all(appPadding),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _locale.salesByBranches,
                          style: TextStyle(fontSize: isDesktop ? 24 : 18),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0.0, vertical: 0),
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width < 800
                                  ? MediaQuery.of(context).size.width * 0.06
                                  : MediaQuery.of(context).size.width * 0.03,
                              child: blueButton1(
                                icon: Icon(
                                  Icons.filter_list_sharp,
                                  color: whiteColor,
                                  size: isDesktop
                                      ? height * 0.039
                                      : height * 0.03,
                                ),
                                // text: _locale.filter,
                                textColor: Color.fromARGB(255, 255, 255, 255),
                                //   borderRadius: 5.0,
                                height:
                                    isDesktop ? height * .015 : height * .039,
                                fontSize:
                                    isDesktop ? height * .018 : height * .017,
                                width: isDesktop ? width * 0.13 : width * 0.27,
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return FilterDialogSalesByBranches(
                                        onFilter:
                                            (selectedPeriod, fromDate, toDate) {
                                          fromDateController.text = fromDate;
                                          toDateController.text = toDate;
                                          period = selectedPeriod;
                                        },
                                      );
                                    },
                                  ).then((value) async {
                                    getSalesByBranch().then((value) {
                                      setState(() {});
                                    });
                                  });
                                },
                              )),
                        ),
                      ],
                    ),
                    PieChartComponent(
                      radiusNormal: isDesktop ? height * 0.17 : 120,
                      radiusHover: isDesktop ? height * 0.17 : 80,
                      width: isDesktop ? width * 0.42 : width * 0.05,
                      height: isDesktop ? height * 0.42 : height * 0.4,
                      dataList: pieData,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double formatDoubleToTwoDecimalPlaces(double number) {
    return double.parse(number.toStringAsFixed(2));
  }

  Color getRandomColor(List<Color> colorList) {
    final random = Random();
    final index = random.nextInt(colorList.length);
    return colorList[index];
  }

  Future getSalesByBranch() async {
    if (fromDateController.text.isEmpty || toDateController.text.isEmpty) {
      if (fromDateController.text.isEmpty) {
        fromDateController.text = todayDate;
      }
      if (toDateController.text.isEmpty) {
        toDateController.text = todayDate;
      }
    } else {
      SearchCriteria searchCriteria = SearchCriteria(
          fromDate: fromDateController.text.isEmpty
              ? todayDate
              : fromDateController.text,
          toDate:
              toDateController.text.isEmpty ? todayDate : toDateController.text,
          voucherStatus: -100);
      pieData = [];
      dataMap.clear();
      barData = [];
      listOfBalances = [];
      listOfPeriods = [];
      await salesBranchesController
          .getSalesByBranches(searchCriteria)
          .then((value) {
        for (var element in value) {
          double a = (element.totalSales! + element.retSalesDis!) -
              (element.salesDis! + element.totalReturnSales!);
          a = Converters().formateDouble(a);
          if (a != 0.0) {
            temp = true;
          } else if (a == 0.0) {
            temp = false;
          }
          listOfBalances.add(a);
          listOfPeriods.add(element.namee!);
          if (temp) {
            dataMap[element.namee!] = formatDoubleToTwoDecimalPlaces(a);
            pieData.add(PieChartModel(
                title: element.namee!,
                value: formatDoubleToTwoDecimalPlaces(a),
                color: getRandomColor(colorNewList)));
          }

          barData.add(
            BarData(name: element.namee!, percent: a),
          );
        }
      });
    }
  }
}
