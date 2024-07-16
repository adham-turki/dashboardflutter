// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:provider/provider.dart';
import '../../../components/custom_date.dart';
import '../../../components/table_component_new.dart';
import '../../../controller/error_controller.dart';
import '../../../controller/reports/total_sales_controller.dart';
import '../../../model/criteria/search_criteria.dart';
import '../../../model/reports/total_sales/total_sales_model.dart';
import '../../../model/reports/total_sales/total_sales_result.dart';
import '../../../provider/reports_provider.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/constants.dart';
import '../../../utils/constants/maps.dart';
import '../../../utils/constants/responsive.dart';
import '../../../utils/constants/styles.dart';
import '../../../utils/func/dates_controller.dart';
import '../../../widget/drop_down/drop_down_clear.dart';

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
  var selectedStatus = "";
  String? fromDateValue;
  String? toDateValue;

  String data = "";

  var selectedPeriod = "";
  String hintValue = '0';
  String todayDate = DatesController().formatDateReverse(
      DatesController().formatDate(DatesController().todayDate()));
  String firstDayCurrentMonth = DatesController().formatDateReverse(
      DatesController().formatDate(DatesController().currentMonth()));
  List<String> columnsName = [];
  List<String> columnsNameMap = [];

  final storage = const FlutterSecureStorage();
  List<PlutoColumn> polCols = [];

  SearchCriteria criteria = SearchCriteria();
  List<PlutoRow> polTopRows = [];
  TotalSalesResult? reportsResult;
  late ReportsProvider reportsProvider;
  List<String> periods = [];
  late Map<int, String> periodMap;
  ValueNotifier isDownload = ValueNotifier(false);
  List<PlutoRow> rowList = [];
  ValueNotifier pageLis = ValueNotifier(1);
  ValueNotifier isLoading = ValueNotifier(true);
  ValueNotifier isLoadingData = ValueNotifier(true);
  ValueNotifier itemsNumberDisplayed = ValueNotifier(0);
  ValueNotifier<List<PlutoRow>> tableListener = ValueNotifier([]);
  int count = 0;
  late PlutoGridStateManager stateManager;

  @override
  void initState() {
    reportsProvider = context.read<ReportsProvider>();

    todayDate = DatesController().formatDateReverse(
        DatesController().formatDate(DatesController().todayDate()));

    fromDate.text = firstDayCurrentMonth;
    toDate.text = todayDate;
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    _locale = AppLocalizations.of(context)!;
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

    reportsProvider = context.read<ReportsProvider>();

    criteria.fromDate = DatesController().formatDate(fromDate.text);
    criteria.toDate = DatesController().formatDate(toDate.text);
    criteria.voucherStatus = -100;
    criteria.rownum = 10;
    criteria.page = 1;
    polCols = TotalSalesModel.getColumns(
        AppLocalizations.of(context)!, reportsResult, context);
    if (stateManager != null) {
      int maxNumber = 1;

      for (int i = 0; i < polCols.length; i++) {
        int length = polCols[i].title.split(" ").length;
        if (length > maxNumber) {
          maxNumber = length;
        }
        String title = specialColumnsWidth(polCols, i, _locale)
            ? polCols[i].title
            : longSentenceWidth(polCols, i, _locale)
                ? '${polCols[i].title.split(' ').take(2).join(' ')}\n${polCols[i].title.split(' ').skip(2).join(' ')}'
                : polCols[i]
                    .title
                    .replaceAll(" ", "\n"); // _locale.lastPricePurchase
        polCols[i].titleSpan = TextSpan(
          children: [
            WidgetSpan(
              child: Text(
                title,
                style: const TextStyle(fontSize: 10),
              ),
            ),
          ],
        );
        polCols[i].titleTextAlign = PlutoColumnTextAlign.center;
        polCols[i].textAlign = PlutoColumnTextAlign.center;

        stateManager.columns[i].title = polCols[i].title;
        stateManager.columns[i].width = polCols[i].width;
        stateManager.columns[i].titleTextAlign = polCols[i].titleTextAlign;
        stateManager.columns[i].textAlign = polCols[i].textAlign;
        stateManager.columns[i].titleSpan = polCols[i].titleSpan;
      }
      // for (int i = 0; i < stateManager!!.rows.length; i++) {
      //   stateManager!!.rows[i].cells['intStatus']!.value =
      //       getStatusNameDependsLang(
      //           stateManager!!.rows[i].cells['intStatus']!.value, locale);
      // }
      stateManager.notifyListeners(true);
    }
    // reportsResult = await totalSalesController
    //     .getTotalSalesResultMehtod(criteria, isStart: true);
    // fromDate.text = '2023-01-01'; // Replace with your desired initial date
    // toDate.text = todayDate;

    super.didChangeDependencies();
  }

  double width = 0;
  double height = 0;

  String? statusValue;
  String? voucherTypeValue;
  String? periodValue;

  bool isDesktop = false;
  bool isMobile = false;
  int listCounter = 0;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    isDesktop = Responsive.isDesktop(context);
    isMobile = Responsive.isMobile(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: isDesktop ? width * 0.8 : width * 0.9,
          decoration: borderDecorationWhite,
          child: isDesktop ? desktopCritiria(context) : mobileCritiria(context),
        ),
        SizedBox(
          height: height * 0.02,
        ),
        SizedBox(
          // width: MediaQuery.of(context).size.width * 0.2,
          child: ValueListenableBuilder(
            valueListenable: isDownload,
            builder: (context, value, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    label: Text(
                      _locale.search,
                      style: const TextStyle(fontSize: 16, color: whiteColor),
                    ),
                    style: customButtonStyle(
                        Size(isDesktop ? width * 0.13 : width * 0.35,
                            height * 0.045),
                        isDesktop ? 16 : 12,
                        primary),
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      DateTime from = DateTime.parse(DatesController()
                          .formatDateReverse(criteria.fromDate!));
                      DateTime to = DateTime.parse(DatesController()
                          .formatDateReverse(criteria.toDate!));

                      if (from.isAfter(to)) {
                        ErrorController.openErrorDialog(
                            1, _locale.startDateAfterEndDate);
                      } else {
                        pageLis.value = 1;
                        criteria.page = pageLis.value;
                        dynamic body = criteria;

                        stateManager.removeAllRows();

                        List<TotalSalesModel> result = [];
                        stateManager.setShowLoading(true);
                        await totalSalesController
                            .getTotalSalesMethod(body)
                            .then((value) {
                          result = value;
                          stateManager.setShowLoading(false);
                        });
                        listCounter = 0;
                        List<PlutoRow> rowsToAdd = result.map((item) {
                          return item.toPluto(++listCounter);
                        }).toList();
                        stateManager.appendRows(rowsToAdd);
                        pageLis.value = pageLis.value + 1;
                        reportsResult = await totalSalesController
                            .getTotalSalesResultMehtod(body);
                        // if (pageLis.value == 1) {

                        reportsResult = await totalSalesController
                            .getTotalSalesResultMehtod(criteria, isStart: true);

                        List<PlutoColumn> columns = TotalSalesModel.getColumns(
                            AppLocalizations.of(context)!,
                            reportsResult,
                            context);
                        for (int i = 0; i < columns.length; i++) {
                          stateManager.columns[i].footerRenderer =
                              columns[i].footerRenderer;
                        }
                        setState(() {});
                        // }
                      }
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton.icon(
                    onPressed: isDownload.value
                        ? null
                        : () {
                            isDownload.value = true;
                            DateTime from = DateTime.parse(fromDate.text);
                            DateTime to = DateTime.parse(toDate.text);

                            if (from.isAfter(to)) {
                              ErrorController.openErrorDialog(
                                  1, _locale.startDateAfterEndDate);
                            } else {
                              if (reportsResult!.count == 0) {
                                ErrorController.openErrorDialog(
                                    406, _locale.error406);
                                isDownload.value = false;
                              } else {
                                int status =
                                    getVoucherStatus(_locale, selectedStatus);
                                SearchCriteria searchCriteria = SearchCriteria(
                                  fromDate: DatesController()
                                      .formatDate(fromDate.text),
                                  toDate:
                                      DatesController().formatDate(toDate.text),
                                  voucherStatus: status,
                                  columns: [],
                                  customColumns: [],
                                );
                                TotalSalesController()
                                    .exportToExcelApi(searchCriteria)
                                    .then((value) {
                                  saveExcelFile(
                                      value, "${_locale.totalSales}.xlsx");
                                  isDownload.value = false;
                                });
                              }
                            }
                          },
                    icon: Icon(
                      Icons.description,
                      size: isDesktop ? width * 0.015 : width * 0.05,
                      color: whiteColor,
                    ),
                    label: isDownload.value
                        ? SizedBox(
                            width: width * 0.015,
                            height: height * 0.04,
                            child: const CircularProgressIndicator(
                              color: primary,
                            ))
                        : Text(
                            _locale.exportToExcel,
                            style: TextStyle(
                                fontSize: isDesktop ? 16 : 12,
                                color: whiteColor),
                          ),
                    style: customButtonStyle(
                        Size(isDesktop ? width * 0.13 : width * 0.35,
                            height * 0.045),
                        16,
                        primary),
                  ),
                ],
              );
            },
          ),
        ),
        SizedBox(
          height: height * 0.02,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            // width: isDesktop ? width * 0.7 : width * 0.9,
            height: height * 0.7,
            child: TableComponentNew(
              columnHeight: 50,
              // key: UniqueKey(),
              plCols: polCols,
              polRows: [],
              footerBuilder: (stateManager) {
                return lazyLoadingfooter(stateManager);
              },
              onLoaded: (PlutoGridOnLoadedEvent event) {
                stateManager = event.stateManager;
                if (isLoading.value) {
                  stateManager.setShowLoading(true);
                }
                stateManager.setShowColumnFilter(true);
              },
            ),
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
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              DropDown(
                // item/: periods[0],/
                bordeText: _locale.period,
                items: periods,
                width: isDesktop ? width * .14 : width * .35,
                height: isDesktop ? height * 0.045 : height * 0.35,
                initialValue: reportsProvider.getTotalSalesPeriodIndex() == -1
                    ? periods.first
                    : reportsProvider.getTotalSalesPeriodIndex() == 0
                        ? _locale.daily
                        : reportsProvider.getTotalSalesPeriodIndex() == 1
                            ? _locale.weekly
                            : reportsProvider.getTotalSalesPeriodIndex() == 2
                                ? _locale.monthly
                                : reportsProvider.getTotalSalesPeriodIndex() ==
                                        3
                                    ? _locale.yearly
                                    : periods.first,
                onChanged: (value) async {
                  checkPeriods(value);
                  selectedPeriod = value;
                  getPeriodByIndex();
                  // reportsResult = await totalSalesController
                  //     .getTotalSalesResultMehtod(criteria);
                  setState(() {});
                },
              ),
              SizedBox(
                width: width * 0.01,
              ),
              DropDown(
                bordeText: _locale.status,
                // hint: status[0],
                items: status,
                initialValue: reportsProvider.getTotalSalesStatusIndex() == -1
                    ? _locale.all
                    : reportsProvider.getTotalSalesStatusIndex() == 0
                        ? _locale.all
                        : reportsProvider.getTotalSalesStatusIndex() == 1
                            ? _locale.posted
                            : reportsProvider.getTotalSalesStatusIndex() == 2
                                ? _locale.draft
                                : status[3],
                width: isDesktop ? width * .14 : width * .35,
                height: isDesktop ? height * 0.045 : height * 0.35,
                onChanged: (value) async {
                  selectedStatus = value;
                  int status = getVoucherStatus(_locale, selectedStatus);
                  getStatusByIndex();
                  criteria.voucherStatus = status;
                  // reportsResult = await totalSalesController
                  //     .getTotalSalesResultMehtod(criteria);
                  // setState(() {});
                },
              ),
              SizedBox(
                width: width * 0.01,
              ),
              CustomDate(
                readOnly: false,
                height: height * 0.045,
                dateWidth: width * 0.18,
                label: _locale.fromDate,
                dateController: fromDate,
                lastDate: DateTime.now(),
                dateControllerToCompareWith: toDate,
                isInitiaDate: true,
                onValue: (isValid, value) {
                  if (isValid) {
                    setState(() {
                      fromDate.text = value;
                      setControllerFromDateText();
                    });
                  }
                },
                timeControllerToCompareWith: null,
              ),
              SizedBox(
                width: width * 0.01,
              ),
              CustomDate(
                readOnly: false,
                height: height * 0.045,
                dateWidth: width * 0.18,
                label: _locale.toDate,
                dateController: toDate,
                lastDate: DateTime.now(),
                dateControllerToCompareWith: fromDate,
                isInitiaDate: false,
                onValue: (isValid, value) {
                  if (isValid) {
                    setState(() {
                      toDate.text = value;
                      setControllertoDateText();
                    });
                  }
                },
                timeControllerToCompareWith: null,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column mobileCritiria(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                height: height * 0.01,
              ),
              DropDown(
                // item/: periods[0],/
                bordeText: _locale.period,
                items: periods,
                width: isDesktop ? width * .14 : width * .7,
                height: isDesktop ? height * 0.045 : height * 0.045,
                initialValue: reportsProvider.getTotalSalesPeriodIndex() == -1
                    ? periods.first
                    : reportsProvider.getTotalSalesPeriodIndex() == 0
                        ? _locale.daily
                        : reportsProvider.getTotalSalesPeriodIndex() == 1
                            ? _locale.weekly
                            : reportsProvider.getTotalSalesPeriodIndex() == 2
                                ? _locale.monthly
                                : reportsProvider.getTotalSalesPeriodIndex() ==
                                        3
                                    ? _locale.yearly
                                    : periods.first,
                onChanged: (value) async {
                  checkPeriods(value);
                  selectedPeriod = value;
                  getPeriodByIndex();
                  // reportsResult = await totalSalesController
                  //     .getTotalSalesResultMehtod(criteria);
                  setState(() {});
                },
              ),
              SizedBox(
                height: height * 0.01,
              ),
              DropDown(
                bordeText: _locale.status,
                // hint: status[0],
                items: status,
                initialValue: reportsProvider.getTotalSalesStatusIndex() == -1
                    ? _locale.all
                    : reportsProvider.getTotalSalesStatusIndex() == 0
                        ? _locale.all
                        : reportsProvider.getTotalSalesStatusIndex() == 1
                            ? _locale.posted
                            : reportsProvider.getTotalSalesStatusIndex() == 2
                                ? _locale.draft
                                : status[3],
                width: isDesktop ? width * .14 : width * .7,
                height: isDesktop ? height * 0.045 : height * 0.045,
                onChanged: (value) async {
                  selectedStatus = value;
                  int status = getVoucherStatus(_locale, selectedStatus);
                  getStatusByIndex();
                  criteria.voucherStatus = status;
                  // reportsResult = await totalSalesController
                  //     .getTotalSalesResultMehtod(criteria);
                  // setState(() {});
                },
              ),
              SizedBox(
                height: height * 0.01,
              ),
              CustomDate(
                readOnly: false,
                dateWidth: isDesktop ? width * .14 : width * .7,
                height: isDesktop ? height * 0.045 : height * 0.045,
                label: _locale.fromDate,
                dateController: fromDate,
                lastDate: DateTime.now(),
                dateControllerToCompareWith: toDate,
                isInitiaDate: true,
                onValue: (isValid, value) {
                  if (isValid) {
                    setState(() {
                      fromDate.text = value;
                      setControllerFromDateText();
                    });
                  }
                },
                timeControllerToCompareWith: null,
              ),
              SizedBox(
                height: height * 0.01,
              ),
              CustomDate(
                readOnly: false,
                dateWidth: isDesktop ? width * .14 : width * .7,
                height: isDesktop ? height * 0.045 : height * 0.045,
                label: _locale.toDate,
                dateController: toDate,
                lastDate: DateTime.now(),
                dateControllerToCompareWith: fromDate,
                isInitiaDate: false,
                onValue: (isValid, value) {
                  if (isValid) {
                    setState(() {
                      toDate.text = value;
                      setControllertoDateText();
                    });
                  }
                },
                timeControllerToCompareWith: null,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void setControllerFromDateText() async {
    fromDateValue = fromDate.text;
    String startDate = DatesController().formatDate(fromDateValue!);
    criteria.fromDate = startDate;
  }

  void getPeriodByIndex() {
    selectedPeriod == _locale.daily
        ? reportsProvider.setTotalSalesPeriodIndex(0)
        : selectedPeriod == _locale.weekly
            ? reportsProvider.setTotalSalesPeriodIndex(1)
            : selectedPeriod == _locale.monthly
                ? reportsProvider.setTotalSalesPeriodIndex(2)
                : reportsProvider.setTotalSalesPeriodIndex(3);
  }

  void getStatusByIndex() {
    selectedStatus == _locale.all
        ? reportsProvider.setTotalSalesStatusIndex(0)
        : selectedStatus == _locale.posted
            ? reportsProvider.setTotalSalesStatusIndex(1)
            : selectedStatus == _locale.draft
                ? reportsProvider.setTotalSalesStatusIndex(2)
                : reportsProvider.setTotalSalesStatusIndex(3);
  }

  void setControllertoDateText() async {
    toDateValue = toDate.text;
    String endDate = DatesController().formatDate(toDateValue!);
    criteria.toDate = endDate;
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

  // PlutoLazyPagination lazyPaginationFooter(PlutoGridStateManager stateManager) {
  //   return PlutoLazyPagination(
  //     initialPage: 1,
  //     initialFetch: true,
  //     pageSizeToMove: 1,
  //     fetchWithSorting: false,
  //     fetchWithFiltering: false,
  //     fetch: (request) {
  //       return fetch1(request);
  //     },
  //     stateManager: stateManager,
  //   );
  // }

  // Future<PlutoLazyPaginationResponse> fetch1(
  //     PlutoLazyPaginationRequest request) async {
  //   int page = request.page;

  //   //To send the number of page to the JSON Object
  //   criteria.page = page;

  //   List<PlutoRow> topList = [];
  //   List<TotalSalesModel> invList = [];

  //   int totalPage =
  //       reportsResult != null ? (reportsResult!.count! / 10).ceil() : 1;

  //   if (reportsResult != null && reportsResult!.count != 0) {
  //     await totalSalesController.getTotalSalesMethod(criteria).then((value) {
  //       invList = value;
  //     });
  //   }
  //   for (int i = 0; i < invList.length; i++) {
  //     topList.add(invList[i].toPluto());
  //   }

  //   return PlutoLazyPaginationResponse(
  //     totalPage: totalPage,
  //     rows: reportsResult == null ? [] : topList,
  //   );
  // }

  PlutoInfinityScrollRows lazyLoadingfooter(
      PlutoGridStateManager stateManager) {
    return PlutoInfinityScrollRows(
      initialFetch: true,
      fetchWithSorting: false,
      fetchWithFiltering: false,
      fetch: fetch,
      stateManager: stateManager,
    );
  }

  Future<PlutoInfinityScrollRowsResponse> fetch(
    PlutoInfinityScrollRowsRequest request,
  ) async {
    reportsResult = await totalSalesController
        .getTotalSalesResultMehtod(criteria, isStart: true);

    List<PlutoColumn> columns = TotalSalesModel.getColumns(
        AppLocalizations.of(context)!, reportsResult, context);
    for (int i = 0; i < columns.length; i++) {
      stateManager.columns[i].footerRenderer = columns[i].footerRenderer;
    }
    List<PlutoRow> topList = [];
    List<TotalSalesModel> invList = [];

    criteria.page = pageLis.value;
    dynamic body = criteria;

    await totalSalesController.getTotalSalesMethod(body).then((value) {
      invList = value;
    });
    for (int i = 0; i < invList.length; i++) {
      PlutoRow plutoRow = invList[i].toPluto(++listCounter);
      rowList.add(plutoRow);
      topList.add(plutoRow);
    }

    stateManager.setShowLoading(false);
    isLoading.value = false;
    isLoadingData.value = false;
    count = invList.length;
    pageLis.value = pageLis.value + 1;
    itemsNumberDisplayed.value = count;

    return Future.value(PlutoInfinityScrollRowsResponse(
      isLast: false,
      rows: topList.toList(),
    ));
  }
}
