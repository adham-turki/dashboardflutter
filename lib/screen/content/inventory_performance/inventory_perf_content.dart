import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../components/date_text_field.dart';
import '../../../components/table_component.dart';
import '../../../controller/error_controller.dart';
import '../../../controller/inventory_performance/inventory_performance_controller.dart';
import '../../../model/bar_chart_data_model.dart';
import '../../../model/criteria/search_criteria.dart';
import '../../../model/pie_chart_data_model.dart';
import '../../../utils/constants/maps.dart';
import '../../../utils/constants/styles.dart';
import '../../../utils/func/dates_controller.dart';
import '../../../widget/custom_btn.dart';
import '../../../widget/custom_date_picker.dart';
import '../../../widget/drop_down/custom_dropdown.dart';
import '../../../widget/custom_textfield.dart';

class InventoryPerfContent extends StatefulWidget {
  const InventoryPerfContent({super.key});

  @override
  State<InventoryPerfContent> createState() => _InventoryPerfContentState();
}

List dataDec = [];
List dataInc = [];

class _InventoryPerfContentState extends State<InventoryPerfContent> {
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  TextEditingController numberOfrow = TextEditingController();
  InventoryPerformanceController inventoryPerformanceController =
      InventoryPerformanceController();
  DateTime? _selectedDate = DateTime.now();
  DateTime? _selectedDate2 = DateTime.now();
  late AppLocalizations _locale;
  List<String> status = [];
  List<String> periods = [];
  var selectedStatus = "";
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();
  String? fromDateValue;
  String? toDateValue;

  String data = "";

  var selectedPeriod = "";
  String hintValue = '0';
  String todayDate = DatesController().formatDateReverse(
      DatesController().formatDate(DatesController().todayDate()));
  String nextMonth = DatesController().formatDateReverse(DatesController()
      .formatDate(DateTime(DatesController().today.year,
              DatesController().today.month + 1, DatesController().today.day)
          .toString()));
  final List<double> listOfBalances = [
    100.0,
    150.0,
    120.0,
    200.0,
    180.0,
    250.0
  ];
  final List<String> listOfPeriods = [
    'Period 1',
    'Period 2',
    'Period 3',
    'Period 4',
    'Period 5',
    'Period 6'
  ];
  final storage = const FlutterSecureStorage();

  final List<String> items = [
    'Print',
    'Save as JPEG',
    'Save as PNG',
  ];

  final List<PieChartData> pieData = [
    PieChartData('', 50),
    PieChartData('', 50),
  ];

  final List<BarChartData> barData = [
    BarChartData('5', 45),
    BarChartData('4', 35),
    BarChartData('3', 15),
    BarChartData('2', 75),
    BarChartData('1', 85),
  ];
  @override
  void initState() {
    fromDate.text = todayDate;
    toDate.text = nextMonth;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context);

    hintValue = numberOfrow.text == "" ? "0" : (numberOfrow.text);
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

    selectedStatus = status[0];
    selectedPeriod = periods[0];
    numberOfrow.text = 10.toString();
    //  search();

    super.didChangeDependencies();
  }

  double width = 0;
  String? statusValue;
  String? voucherTypeValue;
  String? fromJCodeValue;
  String? toJCodeValue;
  String? periodValue;
  double height = 0;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          child: SizedBox(
            // height: height * 0.9,
            width: width * 0.76,
            child: Column(
              children: [
                Row(
                  children: [
                    CustomDropDown(
                      hint: "",
                      label: "Period",
                      items: const [
                        "Last Day",
                        "Last Week",
                        "Last Month",
                        "Last Year",
                        "Previous Month",
                      ],
                      initialValue: "Last Month",
                      onChanged: (value) {
                        setState(() {
                          periodValue = value;
                          // _fetchData();
                        });
                      },
                    ),
                    CustomDropDown(
                      label: "Status",
                      hint: "",
                      items: const [
                        "ALL(DRAFT, POSTED)",
                        "Draft",
                        "Posted",
                        "Cancelled",
                      ],
                      initialValue: "ALL(DRAFT, POSTED)",
                      height: height * 0.18,
                      onChanged: (value) {
                        setState(() {
                          statusValue = value;
                          // _fetchData();
                        });
                      },
                    ),
                    CustomTextField(
                      controller: numberOfrow,
                      label: "",
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomDatePicker(
                      label: "From Date",
                      controller: _fromDateController,
                      onChanged: (value) {
                        setControllerFromDateText();
                      },
                      onSelected: (value) {
                        setControllerFromDateText();
                      },
                    ),
                    CustomDatePicker(
                      label: "To Date",
                      controller: _toDateController,
                      onChanged: (value) {
                        setState(() {
                          toDateValue = value;
                          // _fetchData();
                        });
                      },
                      onSelected: (value) {
                        setState(() {
                          toDateValue = value;
                          // _fetchData();
                        });
                      },
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.22,
                        child: blueButton(
                          height: MediaQuery.of(context).size.width > 800
                              ? MediaQuery.of(context).size.height * .05
                              : MediaQuery.of(context).size.height * .04,
                          text: _locale.search,
                          fontWeight: FontWeight.w400,
                          textColor: Colors.white,
                          borderRadius: 5.0,
                          onPressed: () {
                            search();
                            setState(() {});
                          },
                          fontSize: MediaQuery.of(context).size.width > 800
                              ? MediaQuery.of(context).size.height * .016
                              : MediaQuery.of(context).size.height * .011,
                        ))
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              TableComponent(
                plCols: [],
                polRows: [],
                // footerBuilder: (stateManager) {
                //    return JournalReport.lazyPaginationFooter(stateManager);
                // },
                onSelected: (event) {
                  setState(() {
                    data = event.row!.cells['account']!.value.toString();
                  });
                },
                doubleTab: (event) {
                  showDialog(
                      context: context,
                      builder: (builder) {
                        return const AlertDialog(
                          title: Text("ACTION"),
                        );
                      });
                },
                rightClickTap: (event) {
                  showDialog(
                      context: context,
                      builder: (builder) {
                        return const AlertDialog(
                          title: Text("ACTION"),
                        );
                      });
                },
                // headerBuilder: (event) {
                //   return headerTableSection(data);
                // },
              ),
              TableComponent(
                plCols: [],
                polRows: [],
                // footerBuilder: (stateManager) {
                //    return JournalReport.lazyPaginationFooter(stateManager);
                // },
                onSelected: (event) {
                  setState(() {
                    data = event.row!.cells['account']!.value.toString();
                  });
                },
                doubleTab: (event) {
                  showDialog(
                      context: context,
                      builder: (builder) {
                        return const AlertDialog(
                          title: Text("ACTION"),
                        );
                      });
                },
                rightClickTap: (event) {
                  showDialog(
                      context: context,
                      builder: (builder) {
                        return const AlertDialog(
                          title: Text("ACTION"),
                        );
                      });
                },
                // headerBuilder: (event) {
                //   return headerTableSection(data);
                // },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void setControllerFromDateText() {
    return setState(() {
      fromDateValue = _fromDateController.text;
      // _fetchData();
    });
  }

  void checkPeriods(value) {
    if (value == periods[0]) {
      fromDate.text = DatesController().todayDate().toString();
      toDate.text = DatesController().today.toString();
      _selectedDate = DateTime.parse(fromDate.text);
      _selectedDate2 = DateTime.parse(toDate.text);
    }
    if (value == periods[1]) {
      fromDate.text = DatesController().currentWeek().toString();

      toDate.text = DatesController().todayDate().toString();
      _selectedDate = DateTime.parse(fromDate.text);
      _selectedDate2 = DateTime.parse(toDate.text);
    }
    if (value == periods[2]) {
      fromDate.text = DatesController().currentMonth().toString();
      toDate.text = DatesController().todayDate().toString();
      _selectedDate = DateTime.parse(fromDate.text);
      _selectedDate2 = DateTime.parse(toDate.text);
    }
    if (value == periods[3]) {
      fromDate.text = DatesController().currentYear().toString();
      toDate.text = DatesController().todayDate().toString();
      _selectedDate = DateTime.parse(fromDate.text);
      _selectedDate2 = DateTime.parse(toDate.text);
    }
  }

  void search() {
    hintValue = numberOfrow.text == "" ? "0" : (numberOfrow.text);

    if (numberOfrow.text == 0 || numberOfrow.text == '0' || hintValue == '0') {
      ErrorController.openErrorDialog(406, "No Data Available");
    } else {
      dataInc = [];
      dataDec = [];
      int status = getVoucherStatus(_locale, selectedStatus);
      //  selectedStatus == _locale.all
      //     ? -100
      //     : selectedStatus == _locale.posted
      //         ? 0
      //         : selectedStatus == _locale.draft
      //             ? -1
      //             : selectedStatus == _locale.canceled
      //                 ? 1
      //                 : -100;
      String startDate = DatesController().formatDate(fromDate.text);
      String endDate = DatesController().formatDate(toDate.text);
      SearchCriteria searchCriteria = SearchCriteria(
          fromDate: startDate,
          toDate: endDate,
          voucherStatus: status,
          rownum: int.parse(numberOfrow.text));

      inventoryPerformanceController.totalSellInc(searchCriteria).then((value) {
        // if (value.isEmpty) {
        //   ErrorController.openErrorDialog(406, "No Data Available");
        // }
        for (var elemant in value) {
          setState(() {
            dataDec.add(
              {
                "code": elemant.code,
                "name": elemant.name,
                "currentQty": elemant.intQty,
                "soldQty": elemant.outQty
              },
            );
          });
        }
      });
      SearchCriteria searchCriteria2 = SearchCriteria(
          fromDate: startDate,
          toDate: endDate,
          voucherStatus: status,
          rownum: int.parse(numberOfrow.text));

      inventoryPerformanceController
          .totalSellDic(searchCriteria2)
          .then((value) {
        for (var elemant in value) {
          setState(() {
            dataInc.add(
              {
                "code": elemant.code,
                "name": elemant.name,
                "currentQty": elemant.intQty,
                "soldQty": elemant.outQty
              },
            );
          });
        }
      });
    }
  }

  Future<void> _showCalendar() async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate ?? DateTime.now(),
        firstDate: DateTime(1950),
        //  : DateTime.now(),
        lastDate: DateTime(2101));

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        fromDate.text =
            '${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}';
      });
    }
  }

  Future<void> _showCalendar2() async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate2 ?? DateTime.now(),
        firstDate: DateTime(1950),
        //  : DateTime.now(),
        lastDate: DateTime(2101));

    if (pickedDate != null && pickedDate != _selectedDate2) {
      setState(() {
        _selectedDate2 = pickedDate;
        toDate.text =
            '${_selectedDate2!.year}-${_selectedDate2!.month}-${_selectedDate2!.day}';
      });
    }

    void setControllerFromDateText() {
      return setState(() {
        fromDateValue = _fromDateController.text;
        // _fetchData();
      });
    }

    void setLastMonth() {
      DateTime currentDate = DateTime.now();
      DateTime lastM =
          DateTime(currentDate.year, currentDate.month - 1, currentDate.day);

      // Handle the case where the current month is January (month 1)
      if (currentDate.month == 1) {
        lastM = DateTime(currentDate.year - 1, 12, currentDate.day);
      }
      int lastDay = lastM.day;
      int lastMonth = lastM.month;
      int lastYear = lastM.year;

      _fromDateController.text = "$lastDay/$lastMonth/$lastYear";

      int nowDay = currentDate.day;
      int nowMonth = currentDate.month;
      int nowYear = currentDate.year;

      _toDateController.text = "$nowDay/$nowMonth/$nowYear";
    }

    void setInitialValues() {
      fromJCodeValue = "A";
      toJCodeValue = "C";
      setLastMonth();
    }
  }
}
