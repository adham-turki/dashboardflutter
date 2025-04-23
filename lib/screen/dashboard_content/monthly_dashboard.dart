import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../model/bar_chart_data_model.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/func/dates_controller.dart';
import '../../components/charts.dart';
import '../../controller/receivable_management/rec_pay_controller.dart';
import '../../controller/settings/setup/accounts_name.dart';
import '../../model/settings/setup/bi_account_model.dart';
import '../../utils/constants/constants.dart';
import '../../utils/constants/responsive.dart';

// ignore: must_be_immutable
class MonthlyDashboard extends StatefulWidget {
  List<BarChartData> barData;
  List<BarChartData> barData2;
  MonthlyDashboard({
    Key? key,
    required this.barData,
    required this.barData2,
  }) : super(key: key);

  @override
  _MonthlyDashboardState createState() => _MonthlyDashboardState();
}

class _MonthlyDashboardState extends State<MonthlyDashboard> {
  double width = 0;
  double height = 0;
  final dropdownKey = GlobalKey<DropdownButton2State>();
  bool isDesktop = false;
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();
  RecPayController recPayController = RecPayController();
  bool accountsActive = false;
  late AppLocalizations _locale;
  List<String> status = [];
  List<String> charts = [];
  var selectedStatus = "";

  var selectedChart = "";

  List<double> listOfBalances2 = [];
  List<String> listOfPeriods2 = [];
  List<BiAccountModel> payableRecAccounts = [];
  String accountNameString = "";
  final List<String> items = [
    'Print',
    'Save as JPEG',
    'Save as PNG',
  ];
  final dataMap = <String, double>{};

  final colorList = <Color>[
    Colors.green,
    Colors.blue,
    Colors.red,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.teal,
    Colors.amber,
    Colors.cyan,
    Colors.deepPurple,
    Colors.lime,
    Colors.indigo,
    Colors.lightBlue,
    Colors.deepOrange,
    Colors.brown,
  ];

  String todayDate = "";

  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context)!;
    todayDate = DatesController().formatDateReverse(
        DatesController().formatDate(DatesController().todayDate()));

    _fromDateController.text = todayDate;
    _toDateController.text = todayDate;
    status = [
      _locale.all,
      _locale.posted,
      _locale.draft,
      _locale.canceled,
    ];

    charts = [
      _locale.lineChart,
      _locale.barChart,
    ];
    selectedChart = charts[0];
    selectedStatus = status[0];
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // getExpensesAccounts();
    payableRecAccounts = [];
    getPayableAccounts(isStart: true).then((value) {
      payableRecAccounts = value;
      setState(() {});
    });
    getReceivableAccounts(isStart: true).then((value) {
      payableRecAccounts.addAll(value);
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    isDesktop = Responsive.isDesktop(context);
    return SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: isDesktop ? height * 0.7 : height * 1.2,
                width: double.infinity,
                padding: const EdgeInsets.all(appPadding),
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _locale.monthlyComparsionOFReceivableAndPayables,
                            style: TextStyle(fontSize: isDesktop ? 24 : 18),
                          ),
                        ),
                      ],
                    ),
                    BalanceDoubleBarChart(
                      data: widget.barData,
                      data2: widget.barData2,
                      color: Colors.amber,
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
}
