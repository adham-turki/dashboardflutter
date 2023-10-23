import 'dart:typed_data';
import 'dart:html' as html;
import 'package:bi_replicate/controller/reports/total_sales_controller.dart';
import 'package:bi_replicate/model/reports/total_sales/total_sales_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../../components/table_component.dart';
import '../../../model/criteria/search_criteria.dart';
import '../../../utils/constants/maps.dart';
import '../../../utils/constants/styles.dart';
import '../../../utils/func/dates_controller.dart';
import '../../../widget/custom_btn.dart';
import '../../../widget/custom_date_picker.dart';
import '../../../widget/drop_down/custom_dropdown.dart';

class TotalSalesContent extends StatefulWidget {
  const TotalSalesContent({super.key});

  @override
  State<TotalSalesContent> createState() => _TotalSalesContentState();
}

class _TotalSalesContentState extends State<TotalSalesContent> {
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  TotalSalesController totalSalesController = TotalSalesController();

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

  List<String> columnsName = [];
  List<String> columnsNameMap = [];

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
    toDate.text = todayDate;

    criteria.fromDate = todayDate;
    criteria.toDate = todayDate;
    criteria.voucherStatus = -100;
    criteria.rownum = 10;

    super.initState();
  }

  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context);
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
    columnsName = [
      "#",
      _locale.dueDate,
      _locale.bankName,
      _locale.supplier(""),
      _locale.currency,
      _locale.chequeNo,
      _locale.chequeAmount
    ];

    columnsNameMap = [
      'dueDate',
      'bankName',
      'custSupName',
      'curName',
      'chequeNum'
          'amount'
    ];
    selectedStatus = status[0];
    selectedPeriod = periods[0];

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

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: width * 0.7,
          decoration: borderDecoration,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomDropDown(
                    hint: periods[0],
                    label: _locale.period,
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
                    label: _locale.status,
                    hint: status[0],
                    items: status,
                    initialValue:
                        selectedStatus.isNotEmpty ? selectedStatus : null,
                    height: height * 0.18,
                    onChanged: (value) {
                      setState(() {
                        selectedStatus = value;
                        int status = getVoucherStatus(_locale, selectedStatus);
                        criteria.voucherStatus = status;
                      });
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CustomDatePicker(
                    label: _locale.fromDate,
                    controller: fromDate,
                    onChanged: (value) {
                      setControllerFromDateText();
                    },
                    onSelected: (value) {
                      setControllerFromDateText();
                    },
                  ),
                  CustomDatePicker(
                    label: _locale.toDate,
                    controller: toDate,
                    onChanged: (value) {
                      setControllertoDateText();
                    },
                    onSelected: (value) {
                      setControllertoDateText();
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 8),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width < 800
                            ? MediaQuery.of(context).size.width * 0.6
                            : MediaQuery.of(context).size.width * 0.16,
                        child: CustomButton(
                          text: _locale.exportToExcel,
                          fontWeight: FontWeight.w400,
                          textColor: Colors.white,
                          borderRadius: 5.0,
                          onPressed: () {
                            int status =
                                getVoucherStatus(_locale, selectedStatus);
                            SearchCriteria searchCriteria = SearchCriteria(
                              fromDate:
                                  DatesController().formatDate(fromDate.text),
                              toDate: DatesController().formatDate(toDate.text),
                              voucherStatus: status,
                              columns: [],
                              customColumns: [],
                            );
                            TotalSalesController()
                                .exportToExcelApi(searchCriteria)
                                .then((value) {
                              saveExcelFile(value, "TotalsSales.xlsx");
                            });
                          },
                          fontSize: MediaQuery.of(context).size.width > 800
                              ? MediaQuery.of(context).size.height * .016
                              : MediaQuery.of(context).size.height * .011,
                        )),
                  ),
                ],
              ),
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
                    _locale.totalSales,
                    style: eighteen500TextStyle(Colors.green),
                  ),
                  SizedBox(
                    width: width * 0.7,
                    height: height * 0.7,
                    child: TableComponent(
                      key: UniqueKey(),
                      plCols: TotalSalesModel.getColumns(
                          AppLocalizations.of(context)),
                      polRows: [],
                      footerBuilder: (stateManager) {
                        return lazyPaginationFooter(stateManager);
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

  Future<void> saveExcelFile(Uint8List byteList, String filename) async {
    if (html.window != null) {
      final blob = html.Blob([byteList]);
      final url = html.Url.createObjectUrlFromBlob(blob);

      final anchor = html.AnchorElement(href: url)
        ..target = 'blank'
        ..download = filename
        ..click();

      html.Url.revokeObjectUrl(url);
    } else {}
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
    List<TotalSalesModel> invList =
        await totalSalesController.getTotalSalesMethod(criteria);

    int totalPage = 1;

    for (int i = 0; i < invList.length; i++) {
      topList.add(invList[i].toPluto());
    }

    print("topList :${topList.length}");
    return PlutoLazyPaginationResponse(
      totalPage: totalPage,
      rows: topList,
    );
  }
}
