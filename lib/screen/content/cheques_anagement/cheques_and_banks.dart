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

class ChequesAndBankContent extends StatefulWidget {
  const ChequesAndBankContent({super.key});

  @override
  State<ChequesAndBankContent> createState() => _ChequesAndBankContentState();
}

List dataDec = [];
List dataInc = [];

class _ChequesAndBankContentState extends State<ChequesAndBankContent> {
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

  SearchCriteria criteria = SearchCriteria();
  List<PlutoRow> polRows = [];

  @override
  void initState() {
    criteria = SearchCriteria(
      fromDate: fromDate.text,
      toDate: toDate.text,
      voucherStatus: -100,
      rownum: 10,
    );
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
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          width: width * 0.76,
          child: Column(
            children: [
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  SelectableText(
                    maxLines: 1,
                    _locale.chequesPayable,
                    style: twenty600TextStyle(Colors.blue[700]),
                  ),
                  SizedBox(
                    width: width * 0.37,
                    height: height * 0.2,
                    child: TableComponent(
                      plCols: InventoryPerformanceModel.getColumns(
                          AppLocalizations.of(context)),
                      //dummy row
                      polRows: polRows,
                      // footerBuilder: (stateManager) {
                      //   return lazyPaginationFooter(stateManager);
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
                    _locale.bankSettlement,
                    style: twenty600TextStyle(Colors.blue[700]),
                  ),
                  SizedBox(
                    width: width * 0.37,
                    height: height * 0.7,
                    child: TableComponent(
                      plCols: InventoryPerformanceModel.getColumns(
                          AppLocalizations.of(context)),
                      polRows: [],
                      // footerBuilder: (stateManager) {
                      //   return lazyPaginationFooterLeast(stateManager);
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
      print("startdate1 : ${startDate}");
      print("startDate2 :${criteria.fromDate}");
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

    print("CRITERIA date NUM: ${criteria.fromDate}");
    print(
        "criteria.voucherStatus inside fetch data :${criteria.voucherStatus}");
    InventoryPerformanceController controller =
        InventoryPerformanceController();
    List<PlutoRow> topList = [];

    List<InventoryPerformanceModel> invList =
        await controller.totalSellInc(criteria);

    int totalPage = 1;

    for (int i = 0; i < invList.length; i++) {
      topList.add(invList[i].toPluto());
    }

    setState(() {
      polRows = topList; // Update polRows with the new data
    });
    print("invList.length ${invList.length}");
    print("invList ${invList}");

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

    print("CRITERIA date NUM: ${criteria.fromDate}");
    print(
        "criteria.voucherStatus inside fetch data :${criteria.voucherStatus}");
    InventoryPerformanceController controller =
        InventoryPerformanceController();
    List<PlutoRow> leastList = [];

    List<InventoryPerformanceModel> invList =
        await controller.totalSellDic(criteria);

    int totalPage = 1;

    for (int i = 0; i < invList.length; i++) {
      leastList.add(invList[i].toPluto());
    }

    // setState(() {
    //   polRows = leastList; // Update polRows with the new data
    // });
    print("invList.length ${invList.length}");
    print("invList ${invList}");

    return PlutoLazyPaginationResponse(
      totalPage: totalPage,
      rows: leastList,
    );
  }
}
