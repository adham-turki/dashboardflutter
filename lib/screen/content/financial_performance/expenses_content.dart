import 'package:bi_replicate/model/chart/pie_chart_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../../controller/financial_performance/expense_controller.dart';
import '../../../controller/settings/setup/accounts_name.dart';
import '../../../model/bar_chart_data_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../model/settings/setup/bi_account_model.dart';
import '../../../utils/func/dates_controller.dart';

class ExpensesContent extends StatefulWidget {
  const ExpensesContent({super.key});

  @override
  State<ExpensesContent> createState() => _ExpensesContentState();
}

class _ExpensesContentState extends State<ExpensesContent> {
  DateTime? _selectedDate = DateTime.now();
  TextEditingController fromDate = TextEditingController();
  late AppLocalizations _locale;
  List<String> status = [];
  List<String> periods = [];
  List<String> charts = [];
  var selectedStatus = "";
  var selectedChart = "";
  var selectedPeriod = "";
  String accountNameString = "";
  List<BiAccountModel> expensesAccounts = [];

  bool accountsActive = false;
  ExpensesController expensesController = ExpensesController();
  List<double> listOfBalances = [];
  List<String> listOfPeriods = [];

  final List<String> items = [
    'Print',
    'Save as JPEG',
    'Save as PNG',
  ];

  List<PieChartModel> pieData = [];

  List<BarChartData> barData = [];
  @override
  void initState() {
    getExpensesAccounts().then((value) {
      expensesAccounts = value;
      setState(() {});
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context);
    String todayDate = DatesController().formatDateReverse(
        DatesController().formatDate(DatesController().todayDate()));

    fromDate.text = todayDate;
    // selectedChart = _locale.lineChart;
    // selectedStatus = _locale.all;
    status = [
      _locale.all,
      _locale.posted,
      _locale.draft,
      _locale.canceled,
    ];
    periods = [
      _locale.daily,
      _locale.weekly,
      _locale.monthly,
      _locale.yearly,
    ];
    charts = [
      _locale.lineChart,
      _locale.barChart,
      _locale.pieChart,
    ];
    selectedChart = charts[0];
    selectedStatus = status[0];
    selectedPeriod = periods[0];
    // search();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
