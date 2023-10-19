import 'package:bi_replicate/model/chart/pie_chart_model.dart';
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
import '../../../utils/constants/maps.dart';
import '../../../utils/constants/styles.dart';
import '../../../utils/func/dates_controller.dart';
import '../../../widget/custom_btn.dart';
import '../../../widget/custom_date_picker.dart';
import '../../../widget/drop_down/custom_dropdown.dart';
import '../../../widget/custom_textfield.dart';
import '../../../widget/headerWidget.dart';

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

  SearchCriteria criteria = SearchCriteria();
  List<PlutoRow> polTopRows = [];

  @override
  void initState() {
    fromDate.text = todayDate;
    toDate.text = nextMonth;

    criteria.fromDate = todayDate;
    criteria.toDate = nextMonth;
    criteria.voucherStatus = -100;
    criteria.rownum = 10;

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

    super.didChangeDependencies();
  }

  double width = 0;
  String? statusValue;
  String? voucherTypeValue;
  String? fromJCodeValue;
  String? toJCodeValue;
  String? periodValue;
  double height = 0;
  int count = 0;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    print("INSIDE BUILD POLToproWS: ${polTopRows.length}");

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          width: width * 0.76,
          child: Column(
            children: [
              const HeaderWidget(),
              Container(
                width: width * 0.7,
                decoration: borderDecoration,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomDropDown(
                          hint: periods[0],
                          label: "Period",
                          items: periods,
                          initialValue:
                              selectedPeriod.isNotEmpty ? selectedPeriod : null,
                          onChanged: (value) {
                            setState(() {
                              checkPeriods(value);
                              selectedPeriod = value;
                            });
                          },
                        ),
                        CustomDropDown(
                          label: "Status",
                          hint: status[0],
                          items: status,
                          initialValue:
                              selectedStatus.isNotEmpty ? selectedStatus : null,
                          height: height * 0.18,
                          onChanged: (value) {
                            setState(() {
                              selectedStatus = value;
                              int status =
                                  getVoucherStatus(_locale, selectedStatus);
                              criteria.voucherStatus = status;
                              print(
                                  "criteria.voucherStatus :{$criteria.voucherStatus}");
                            });
                          },
                        ),
                        CustomTextField(
                          controller: numberOfrow,
                          initialValue: numberOfrow.text,
                          label: "Number of rows",
                          onChanged: (value) {
                            // setState(() {

                            // fetch(PlutoLazyPaginationRequest(
                            //     page: criteria.page!));

                            // print("Hello");
                            // print("CRITERIA BEFORE JSON: ${criteria.toJson()}");
                            // fetch(PlutoLazyPaginationRequest(
                            //     page: criteria.page!));
                            // });
                            // polTopRows = [];
                            setState(() {
                              hintValue = value;
                              criteria.rownum = int.parse(numberOfrow.text);
                              // polTopRows = [];
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomDatePicker(
                          label: "From Date",
                          controller: fromDate,
                          onChanged: (value) {
                            setControllerFromDateText();
                          },
                          onSelected: (value) {
                            setControllerFromDateText();
                          },
                        ),
                        CustomDatePicker(
                          label: "To Date",
                          controller: toDate,
                          onChanged: (value) {
                            setControllertoDateText();
                          },
                          onSelected: (value) {
                            setControllertoDateText();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
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
                      key: UniqueKey(),
                      plCols: InventoryPerformanceModel.getColumns(
                          AppLocalizations.of(context)),
                      polRows: polTopRows,
                      footerBuilder: (stateManager) {
                        return lazyPaginationFooter(stateManager);
                      },
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
                      key: UniqueKey(),
                      plCols: InventoryPerformanceModel.getColumns(
                          AppLocalizations.of(context)),
                      polRows: [],
                      footerBuilder: (stateManager) {
                        return lazyPaginationFooterLeast(stateManager);
                      },
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
      fromDateValue = fromDate.text;
      String startDate = DatesController().formatDate(fromDateValue!);
      criteria.fromDate = startDate;
      fetch(PlutoLazyPaginationRequest(page: criteria.page!));
    });
  }

  void setControllertoDateText() {
    return setState(() {
      toDateValue = toDate.text;
      String endDate = DatesController().formatDate(toDateValue!);
      criteria.toDate = endDate;
      fetch(PlutoLazyPaginationRequest(page: criteria.page!));
    });
  }

  void checkPeriods(value) {
    if (value == periods[0]) {
      // Daily
      fromDate.text = DatesController()
          .formatDate(DatesController().todayDate())
          .toString();
      DateTime.parse(fromDate.text);
      toDate.text = DatesController()
          .formatDate(DatesController().todayDate())
          .toString();
      print("cjeck :${toDate.text}");
    }
    if (value == periods[1]) {
      // Weekly
      fromDate.text = DatesController()
          .formatDate(DatesController().currentWeek())
          .toString();
      toDate.text = DatesController()
          .formatDate(DatesController().todayDate())
          .toString();
    }
    if (value == periods[2]) {
      // Monthly
      fromDate.text = DatesController()
          .formatDate(DatesController().currentMonth())
          .toString();
      toDate.text = DatesController()
          .formatDate(DatesController().todayDate())
          .toString();
    }
    if (value == periods[3]) {
      // Yearly
      fromDate.text = DatesController()
          .formatDate(DatesController().currentYear())
          .toString();
      toDate.text = DatesController()
          .formatDate(DatesController().todayDate())
          .toString();
    }

    criteria.fromDate = fromDate.text;
    criteria.toDate = toDate.text;
  }

  PlutoLazyPagination lazyPaginationFooter(PlutoGridStateManager stateManager) {
    return PlutoLazyPagination(
      initialPage: 1,
      initialFetch: true,
      pageSizeToMove: null,
      fetchWithSorting: false,
      fetchWithFiltering: false,
      fetch: (request) {
        return fetch(request);
      },
      stateManager: stateManager,
    );
  }

  Future<PlutoLazyPaginationResponse> fetch(
      PlutoLazyPaginationRequest request) async {
    int page = request.page;

    //To send the number of page to the JSON Object
    criteria.page = page;

    List<PlutoRow> topList = [];
    print("from date critiria :${criteria.fromDate}");
    List<InventoryPerformanceModel> invList =
        await inventoryPerformanceController.totalSellDic(criteria);

    int totalPage = 1;

    for (int i = 0; i < invList.length; i++) {
      topList.add(invList[i].toPluto());
    }

    return PlutoLazyPaginationResponse(
      totalPage: totalPage,
      rows: topList,
    );
  }

  PlutoLazyPagination lazyPaginationFooterLeast(
      PlutoGridStateManager stateManager) {
    return PlutoLazyPagination(
      initialPage: 1,
      initialFetch: true,
      pageSizeToMove: null,
      fetchWithSorting: false,
      fetchWithFiltering: false,
      fetch: (request) {
        return fetchLeast(request);
      },
      stateManager: stateManager,
    );
  }

  Future<PlutoLazyPaginationResponse> fetchLeast(
      PlutoLazyPaginationRequest request) async {
    int page = request.page;

    //To send the number of page to the JSON Object
    criteria.page = page;
    print(criteria.toJson());

    List<PlutoRow> topList = [];

    List<InventoryPerformanceModel> invList =
        await inventoryPerformanceController.totalSellInc(criteria);

    print(invList.length);

    int totalPage = 1;

    for (int i = 0; i < invList.length; i++) {
      print("object");
      topList.add(invList[i].toPluto());
    }

    print("TOP LIST: ${topList.length}");

    return PlutoLazyPaginationResponse(
      totalPage: totalPage,
      rows: topList,
    );
  }
}
