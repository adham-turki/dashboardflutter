import 'dart:typed_data';
import 'dart:html' as html;
import 'package:bi_replicate/controller/reports/total_sales_controller.dart';
import 'package:bi_replicate/model/reports/total_sales/total_sales_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../../components/custom_date.dart';
import '../../../components/table_component.dart';
import '../../../controller/error_controller.dart';
import '../../../model/criteria/search_criteria.dart';
import '../../../model/reports/total_sales/total_sales_result.dart';
import '../../../utils/constants/app_utils.dart';
import '../../../utils/constants/maps.dart';
import '../../../utils/constants/responsive.dart';
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

  final storage = const FlutterSecureStorage();

  SearchCriteria criteria = SearchCriteria();
  List<PlutoRow> polTopRows = [];
  TotalSalesResult? reportsResult;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
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

    selectedStatus = status[0];
    selectedPeriod = periods[0];
    fromDate.text = todayDate;
    toDate.text = todayDate;

    criteria.fromDate = DatesController().formatDate(fromDate.text);
    criteria.toDate = DatesController().formatDate(toDate.text);
    criteria.voucherStatus = -100;
    criteria.rownum = 10;

    reportsResult = await totalSalesController
        .getTotalSalesResultMehtod(criteria, isStart: true);
    super.didChangeDependencies();
  }

  double width = 0;
  double height = 0;

  String? statusValue;
  String? voucherTypeValue;
  String? periodValue;

  int count = 0;
  bool isDesktop = false;
  bool isMobile = false;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    isDesktop = Responsive.isDesktop(context);
    isMobile = Responsive.isMobile(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: width * 0.7,
          decoration: borderDecoration,
          child: isDesktop ? desktopCritiria(context) : mobileCritiria(context),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  SizedBox(
                    width: width * 0.7,
                    height: height * 0.7,
                    child: TableComponent(
                      key: UniqueKey(),
                      plCols: TotalSalesModel.getColumns(
                          AppLocalizations.of(context), reportsResult, context),
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

  Column desktopCritiria(BuildContext context) {
    return Column(
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
              initialValue: selectedPeriod.isNotEmpty ? selectedPeriod : null,
              onChanged: (value) async {
                checkPeriods(value);
                selectedPeriod = value;
                reportsResult = await totalSalesController
                    .getTotalSalesResultMehtod(criteria);
                setState(() {});
              },
            ),
            CustomDropDown(
              label: _locale.status,
              hint: status[0],
              items: status,
              initialValue: selectedStatus.isNotEmpty ? selectedStatus : null,
              height: height * 0.18,
              onChanged: (value) async {
                selectedStatus = value;
                int status = getVoucherStatus(_locale, selectedStatus);

                criteria.voucherStatus = status;
                reportsResult = await totalSalesController
                    .getTotalSalesResultMehtod(criteria);
                setState(() {});
              },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              width: width * .135,
              child: CustomDate(
                label: _locale.fromDate,
                minYear: 2000,
                onValue: (isValid, value) {
                  if (isValid) {
                    setState(() {
                      fromDate.text = value;
                      setControllerFromDateText();
                    });
                  }
                },
              ),
            ),
            // CustomDatePicker(
            //   label: _locale.fromDate,
            //   controller: fromDate,
            //   date: DateTime.parse(toDate.text),
            //   onChanged: (value) {
            //     setControllerFromDateText();
            //   },
            //   onSelected: (value) {
            //     setControllerFromDateText();
            //   },
            // ),
            SizedBox(
              width: width * .135,
              child: CustomDate(
                label: _locale.toDate,
                // minYear: 2000,
                onValue: (isValid, value) {
                  if (isValid) {
                    setState(() {
                      toDate.text = value;
                      setControllertoDateText();
                    });
                  }
                },
              ),
            ),
            // CustomDatePicker(
            //   label: _locale.toDate,
            //   controller: toDate,
            //   date: DateTime.parse(fromDate.text),
            //   onChanged: (value) {
            //     setControllertoDateText();
            //   },
            //   onSelected: (value) {
            //     setControllertoDateText();
            //   },
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
              child: SizedBox(
                  width: MediaQuery.of(context).size.width < 800
                      ? MediaQuery.of(context).size.width * 0.6
                      : MediaQuery.of(context).size.width * 0.16,
                  child: Components().blueButton(
                    text: _locale.exportToExcel,
                    textColor: Colors.white,
                    borderRadius: 5.0,
                    height: isDesktop ? height * .05 : height * .06,
                    fontSize: isDesktop ? height * .016 : height * .011,
                    width: isDesktop ? width * 0.15 : width * 0.25,
                    onPressed: () {
                      if (reportsResult!.count == 0) {
                        ErrorController.openErrorDialog(406, _locale.error406);
                      } else {
                        int status = getVoucherStatus(_locale, selectedStatus);
                        SearchCriteria searchCriteria = SearchCriteria(
                          fromDate: DatesController().formatDate(fromDate.text),
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
                      }
                    },
                  )),
            ),
          ],
        ),
      ],
    );
  }

  Column mobileCritiria(BuildContext context) {
    double widthMobile = width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomDropDown(
              hint: periods[0],
              label: _locale.period,
              width: widthMobile,
              items: periods,
              initialValue: selectedPeriod.isNotEmpty ? selectedPeriod : null,
              onChanged: (value) async {
                checkPeriods(value);
                selectedPeriod = value;
                reportsResult = await totalSalesController
                    .getTotalSalesResultMehtod(criteria);
                setState(() {});
              },
            ),
            CustomDropDown(
              label: _locale.status,
              hint: status[0],
              items: status,
              width: widthMobile,
              initialValue: selectedStatus.isNotEmpty ? selectedStatus : null,
              height: height * 0.18,
              onChanged: (value) async {
                selectedStatus = value;
                int status = getVoucherStatus(_locale, selectedStatus);

                criteria.voucherStatus = status;
                reportsResult = await totalSalesController
                    .getTotalSalesResultMehtod(criteria);
                setState(() {});
              },
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              width: width,
              child: CustomDate(
                label: _locale.fromDate,
                minYear: 2000,
                onValue: (isValid, value) {
                  if (isValid) {
                    setState(() {
                      fromDate.text = value;
                      setControllerFromDateText();
                    });
                  }
                },
              ),
            ),
            // CustomDatePicker(
            //   label: _locale.fromDate,
            //   controller: fromDate,
            //   date: DateTime.parse(toDate.text),
            //   onChanged: (value) {
            //     setControllerFromDateText();
            //   },
            //   onSelected: (value) {
            //     setControllerFromDateText();
            //   },
            // ),
            SizedBox(
              width: width,
              child: CustomDate(
                label: _locale.toDate,
                // minYear: 2000,
                onValue: (isValid, value) {
                  if (isValid) {
                    setState(() {
                      toDate.text = value;
                      setControllertoDateText();
                    });
                  }
                },
              ),
            ),
            // CustomDatePicker(
            //   label: _locale.toDate,
            //   controller: toDate,
            //   date: DateTime.parse(fromDate.text),
            //   onChanged: (value) {
            //     setControllertoDateText();
            //   },
            //   onSelected: (value) {
            //     setControllertoDateText();
            //   },
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
              child: SizedBox(
                  width: MediaQuery.of(context).size.width < 800
                      ? MediaQuery.of(context).size.width * 0.6
                      : MediaQuery.of(context).size.width * 0.16,
                  child: Components().blueButton(
                    text: _locale.exportToExcel,
                    textColor: Colors.white,
                    borderRadius: 5.0,
                    height: isDesktop ? height * .05 : height * .06,
                    fontSize: isDesktop ? height * .016 : height * .011,
                    width: isDesktop ? width * 0.15 : width * 0.25,
                    onPressed: () {
                      if (reportsResult!.count == 0) {
                        ErrorController.openErrorDialog(406, _locale.error406);
                      } else {
                        int status = getVoucherStatus(_locale, selectedStatus);
                        SearchCriteria searchCriteria = SearchCriteria(
                          fromDate: DatesController().formatDate(fromDate.text),
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
                      }
                    },
                  )),
            ),
          ],
        ),
      ],
    );
  }

  void setControllerFromDateText() async {
    fromDateValue = fromDate.text;
    String startDate = DatesController().formatDate(fromDateValue!);
    criteria.fromDate = startDate;
    reportsResult =
        await totalSalesController.getTotalSalesResultMehtod(criteria);
    return setState(() {
      fetch(PlutoLazyPaginationRequest(page: criteria.page!));
    });
  }

  void setControllertoDateText() async {
    toDateValue = toDate.text;
    String endDate = DatesController().formatDate(toDateValue!);
    criteria.toDate = endDate;
    reportsResult =
        await totalSalesController.getTotalSalesResultMehtod(criteria);
    return setState(() {
      fetch(PlutoLazyPaginationRequest(page: criteria.page!));
    });
  }

  void checkPeriods(value) {
    if (value == periods[0]) {
      // Daily
      fromDate.text = DatesController().todayDate().toString();
      DateTime.parse(fromDate.text);
      toDate.text = DatesController().todayDate().toString();
    }
    if (value == periods[1]) {
      // Weekly
      fromDate.text = DatesController().currentWeek().toString();
      toDate.text = DatesController().todayDate().toString();
    }
    if (value == periods[2]) {
      // Monthly
      fromDate.text = DatesController().currentMonth().toString();
      toDate.text = DatesController().todayDate().toString();
    }
    if (value == periods[3]) {
      // Yearly
      fromDate.text = DatesController().currentYear().toString();
      toDate.text = DatesController().todayDate().toString();
    }

    criteria.fromDate = DatesController().formatDate(fromDate.text);
    criteria.toDate = DatesController().formatDate(toDate.text);
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
    List<TotalSalesModel> invList = [];

    int totalPage =
        reportsResult != null ? (reportsResult!.count! / 10).ceil() : 1;

    if (reportsResult != null && reportsResult!.count != 0) {
      await totalSalesController.getTotalSalesMethod(criteria).then((value) {
        invList = value;
      });
    }
    for (int i = 0; i < invList.length; i++) {
      topList.add(invList[i].toPluto());
    }

    return PlutoLazyPaginationResponse(
      totalPage: totalPage,
      rows: reportsResult == null ? [] : topList,
    );
  }
}
