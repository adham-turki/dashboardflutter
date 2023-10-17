import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../../components/date_text_field.dart';
import '../../../components/table_component.dart';
import '../../../controller/error_controller.dart';
import '../../../controller/inventory_performance/inventory_performance_controller.dart';
import '../../../model/bar_chart_data_model.dart';
import '../../../model/criteria/search_criteria.dart';
import '../../../model/inventory_performance/inventory_performance_model.dart';
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
                      hint: periods[0],
                      label: "Period",
                      items: const [
                        "Last Day",
                        "Last Week",
                        "Last Month",
                        "Last Year",
                        "Previous Month",
                      ],
                      initialValue:
                          selectedPeriod.isNotEmpty ? selectedPeriod : null,
                      onChanged: (value) {
                        setState(() {
                          periodValue = value;
                          print("preiod value :${periodValue}");
                          search();
                          // _fetchData();
                        });
                      },
                    ),
                    CustomDropDown(
                      label: "Status",
                      hint: status[0],
                      items: const [
                        "ALL(DRAFT, POSTED)",
                        "Draft",
                        "Posted",
                        "Cancelled",
                      ],
                      initialValue:
                          selectedStatus.isNotEmpty ? selectedStatus : null,
                      height: height * 0.18,
                      onChanged: (value) {
                        setState(() {
                          statusValue = value;
                          search();
                          // _fetchData();
                        });
                      },
                    ),
                    CustomTextField(
                      controller: numberOfrow,
                      initialValue: hintValue,
                      label: "Number of rows",
                      onSubmitted: (value) {
                        hintValue = value;
                        search();
                      },
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
                        search();
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
                          search();
                        });
                      },
                      onSelected: (value) {
                        setState(() {
                          toDateValue = value;
                          // _fetchData();
                          // search();
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  SelectableText(
                    maxLines: 1,
                    _locale.topOfInventoryPerformance,
                    style: eighteen500TextStyle(Colors.green),
                  ),
                  SizedBox(
                    width: width * 0.37,
                    height: height * 0.7,
                    child: TableComponent(
                      plCols: InventoryPerformanceModel.getColumns(
                          AppLocalizations.of(context)),
                      polRows: getStringList().isEmpty ? [] : getStringList(),
                      // footerBuilder: (stateManager) {
                      //    return JournalReport.lazyPaginationFooter(stateManager);
                      // },
                      // onSelected: (event) {
                      //   setState(() {
                      //     data = event.row!.cells['account']!.value.toString();
                      //   });
                      // },
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
                  ),
                ],
              ),
              Column(
                children: [
                  SelectableText(
                    maxLines: 1,
                    _locale.leastOfInventoryPerformance,
                    style: eighteen500TextStyle(Colors.red),
                  ),
                  SizedBox(
                    width: width * 0.37,
                    height: height * 0.7,
                    child: TableComponent(
                      plCols: InventoryPerformanceModel.getColumns(
                          AppLocalizations.of(context)),
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
                  ),
                ],
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

      String startDate = DatesController().formatDate(fromDate.text);
      String endDate = DatesController().formatDate(toDate.text);
      SearchCriteria searchCriteria = SearchCriteria(
          fromDate: startDate,
          toDate: endDate,
          voucherStatus: status,
          rownum: int.parse(numberOfrow.text));

      inventoryPerformanceController.totalSellInc(searchCriteria).then((value) {
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
      print("statuss:${statusValue}");
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

  List<List<String>> getStringList1() {
    List<List<String>> stringList = [];
    for (int i = 0; i < dataInc.length; i++) {
      List<String> temp = [
        (i + 1).toString(),
        dataInc[i]['code'].toString(),
        dataInc[i]['name'].toString(),
        dataInc[i]['currentQty'].toString(),
        dataInc[i]['soldQty'].toString()
      ];
      stringList.add(temp);
    }
    return stringList;
  }

  List<PlutoRow> getStringList() {
    List<PlutoRow> rowList = [];
    for (int i = 0; i < dataInc.length; i++) {
      InventoryPerformanceModel performanceModel =
          InventoryPerformanceModel.fromJson(dataInc[i]);
      PlutoRow newRow = PlutoRow(cells: performanceModel.toPluto());
      rowList.add(newRow);
    }
    return rowList;
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
