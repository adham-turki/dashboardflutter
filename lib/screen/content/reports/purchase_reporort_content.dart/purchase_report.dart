import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:provider/provider.dart';
import 'dart:html' as html;

import '../../../../components/table_component_new.dart';
import '../../../../controller/error_controller.dart';
import '../../../../controller/reports/report_controller.dart';
import '../../../../model/criteria/search_criteria.dart';
import '../../../../model/reports/purchase_cost_report.dart';
import '../../../../model/reports/reports_result.dart';
import '../../../../provider/purchase_provider.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/constants.dart';
import '../../../../utils/constants/maps.dart';
import '../../../../utils/constants/responsive.dart';
import '../../../../utils/func/dates_controller.dart';
import 'tabs/criteria_widget.dart';

import 'tabs/setup_widget.dart';

class PurchasesReportScreen extends StatefulWidget {
  const PurchasesReportScreen({Key? key}) : super(key: key);

  @override
  State<PurchasesReportScreen> createState() => _PurchasesReportScreenState();
}

class _PurchasesReportScreenState extends State<PurchasesReportScreen> {
  int _currentIndex = 0;
  late AppLocalizations _locale;
  List<PurchaseCostReportModel> purchaseList = [];
  List<String> orderByColumns = [];
  int pageNumber = 0;
  late PurchaseCriteraProvider readProvider;
  int limitPage = 0;
  List<String> finalRow = [];
  double width = 0;
  double height = 0;
  bool isDesktop = false;
  bool isMobile = false;
  SearchCriteria criteria = SearchCriteria();
  FocusNode focusNode = FocusNode();
  ValueNotifier isDownload = ValueNotifier(false);
  ValueNotifier isReset = ValueNotifier(false);

  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();

  String todayDate = DatesController().formatDateReverse(
      DatesController().formatDate(DatesController().todayDate()));
  bool hidefilter = false;
  late PlutoGridStateManager stateManager;
  ValueNotifier pageLis = ValueNotifier(1);
  ValueNotifier isLoading = ValueNotifier(false);
  ValueNotifier isLoadingData = ValueNotifier(false);
  ValueNotifier itemsNumberDisplayed = ValueNotifier(0);
  int count = 0;
  List<PlutoRow> rowList = [];
  List<PlutoColumn> polCols = [];

  @override
  void initState() {
    fromDate.text = todayDate;
    toDate.text = todayDate;

    criteria.fromDate = DatesController().formatDate(fromDate.text);
    criteria.toDate = DatesController().formatDate(toDate.text);
    criteria.voucherStatus = -100;
    criteria.rownum = 10;
    focusNode.requestFocus();

    super.initState();
  }

  @override
  void didChangeDependencies() async {
    _locale = AppLocalizations.of(context)!;
    readProvider = context.read<PurchaseCriteraProvider>();
    readProvider.emptyProvider();
    orderByColumns = [
      '#',
      _locale.branch,
      _locale.stock,
      _locale.stockCategoryLevel("1"),
      _locale.stockCategoryLevel("2"),
      _locale.stockCategoryLevel("3"),
      _locale.supplier("1"),
      _locale.supplier("2"),
      _locale.supplier("3"),
      _locale.modelNo,
      _locale.qty,
      _locale.averagePrice,
      _locale.total
    ];

    focusNode.requestFocus();

    polCols = PurchaseCostReportModel.getColumns(
        AppLocalizations.of(context)!, orderByColumns, reportsResult, context);
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

        stateManager!.columns[i].title = polCols[i].title;
        stateManager!.columns[i].width = polCols[i].width;
        stateManager!.columns[i].titleTextAlign = polCols[i].titleTextAlign;
        stateManager!.columns[i].textAlign = polCols[i].textAlign;
        stateManager!.columns[i].titleSpan = polCols[i].titleSpan;
      }

      stateManager!.notifyListeners(true);
    }
    dynamic body = readProvider.toJson();

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  String selectedValueFromDropdown1 = "";
  String selectedValueFromDropdown2 = "";
  String selectedValueFromDropdown3 = "";
  String selectedValueFromDropdown4 = "";
  void updateSelectedValue1(String value) {
    selectedValueFromDropdown1 = value;
  }

  void updateSelectedValue2(String value) {
    selectedValueFromDropdown2 = value;
  }

  void updateSelectedValue3(String value) {
    selectedValueFromDropdown3 = value;
  }

  void updateSelectedValue4(String value) {
    selectedValueFromDropdown4 = value;
  }

  generateColumns() {
    List<String> orderByColumnsTemp = [
      '#',
      _locale.branch,
      _locale.stock,
      _locale.stockCategoryLevel("1"),
      _locale.stockCategoryLevel("2"),
      _locale.stockCategoryLevel("3"),
      _locale.supplier("1"),
      _locale.supplier("2"),
      _locale.supplier("3"),
      _locale.modelNo,
      _locale.qty,
      _locale.averagePrice,
      _locale.total
    ];

    if ((selectedValueFromDropdown1.isEmpty ||
            selectedValueFromDropdown1 == "") &&
        (selectedValueFromDropdown2.isEmpty ||
            selectedValueFromDropdown2 == "") &&
        (selectedValueFromDropdown3.isEmpty ||
            selectedValueFromDropdown3 == "") &&
        (selectedValueFromDropdown4.isEmpty ||
            selectedValueFromDropdown4 == "")) {
      orderByColumns = orderByColumnsTemp;
      stateManager.removeColumns(stateManager!.columns);

      for (int i = 0;
          i <
              PurchaseCostReportModel.getColumns(AppLocalizations.of(context)!,
                      orderByColumns, reportsResult, context)
                  .length;
          i++) {
        print("orderByColumnsorderByColumns 111:${orderByColumns[i]}");
        stateManager!.insertColumns(i, [
          PurchaseCostReportModel.getColumns(
              _locale, orderByColumns, reportsResult, context)[i]
        ]);
        print("orderByColumnsorderByColumns 2222:${orderByColumns[i]}");
      }
    } else {
      print("big else");
      Set<String> selectedValues = {};

      if (selectedValueFromDropdown1 != "") {
        print("case 1 ");
        if (selectedValueFromDropdown1 == _locale.supp) {
          selectedValues.add(_locale.supplier("1"));
          selectedValues.add(_locale.supplier("2"));
          selectedValues.add(_locale.supplier("3"));
        } else {
          selectedValues.add(selectedValueFromDropdown1);
        }
      }

      if (selectedValueFromDropdown2 != "") {
        if (selectedValueFromDropdown2 == _locale.supp) {
          selectedValues.add(_locale.supplier("1"));
          selectedValues.add(_locale.supplier("2"));
          selectedValues.add(_locale.supplier("3"));
        } else {
          selectedValues.add(selectedValueFromDropdown2);
        }
      }

      if (selectedValueFromDropdown3 != "") {
        if (selectedValueFromDropdown3 == _locale.supp) {
          selectedValues.add(_locale.supplier("1"));
          selectedValues.add(_locale.supplier("2"));
          selectedValues.add(_locale.supplier("3"));
        } else {
          selectedValues.add(selectedValueFromDropdown3);
        }
      }

      if (selectedValueFromDropdown4 != "") {
        if (selectedValueFromDropdown4 == _locale.supp) {
          selectedValues.add(_locale.supplier("1"));
          selectedValues.add(_locale.supplier("2"));
          selectedValues.add(_locale.supplier("3"));
        } else {
          selectedValues.add(selectedValueFromDropdown4);
        }
      }
      List<String> columns = ['#'];
      columns.addAll(selectedValues);
      columns.addAll([
        _locale.qty,
        _locale.averagePrice,
        _locale.total,
      ]);

      orderByColumns = columns;
      stateManager.removeColumns(stateManager!.columns);

      if (readProvider.getOrders!.isNotEmpty) {
        List<PlutoColumn> newColumns;

        if (orderByColumns.length == 5) {
          newColumns = PurchaseCostReportModel.getColumns(
              _locale, orderByColumns, reportsResult, context,
              isOne: true);
        } else if (orderByColumns.length == 6) {
          newColumns = PurchaseCostReportModel.getColumns(
              _locale, orderByColumns, reportsResult, context,
              isTwo: true);
        } else if (orderByColumns.length == 7) {
          newColumns = PurchaseCostReportModel.getColumns(
              _locale, orderByColumns, reportsResult, context,
              isThree: true);
        } else if (orderByColumns.length == 8) {
          newColumns = PurchaseCostReportModel.getColumns(
              _locale, orderByColumns, reportsResult, context,
              isFour: true);
        } else {
          newColumns = PurchaseCostReportModel.getColumns(
              _locale, orderByColumns, reportsResult, context,
              isSupplier: true);
        }

        // Insert the generated columns into the state manager
        for (int i = 0; i < newColumns.length; i++) {
          stateManager!.insertColumns(i, [newColumns[i]]);
        }
      } else {
        List<String> temp = [
          '#',
          _locale.branch,
          _locale.stock,
          _locale.stockCategoryLevel("1"),
          _locale.stockCategoryLevel("2"),
          _locale.stockCategoryLevel("3"),
          _locale.supplier("1"),
          _locale.supplier("2"),
          _locale.supplier("3"),
          _locale.modelNo,
          _locale.qty,
          _locale.averagePrice,
          _locale.total
        ];
        for (int i = 0;
            i <
                PurchaseCostReportModel.getColumns(
                        AppLocalizations.of(context)!,
                        temp,
                        reportsResult,
                        context)
                    .length;
            i++) {
          print("orderByColumnsorderByColumns 111:${temp[i]}");
          stateManager!.insertColumns(i, [
            PurchaseCostReportModel.getColumns(
                _locale, temp, reportsResult, context)[i]
          ]);
          print("orderByColumnsorderByColumns 2222:${temp[i]}");
        }
      }
    }
  }

  ReportsResult? reportsResult;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    isDesktop = Responsive.isDesktop(context);
    isMobile = Responsive.isMobile(context);

    return DefaultTabController(
      length: 2,
      child: Column(children: [
        hidefilter == false
            ? Column(
                children: [
                  SizedBox(
                    width: isDesktop ? width * 0.7 : width * 0.9,
                    height: height * 0.045,
                    child: TabBar(
                      unselectedLabelColor: Colors.grey,
                      labelColor: Colors.black,
                      indicatorColor: primary,
                      tabs: [
                        Tab(
                          child: Text(maxLines: 1, _locale.critiriaAndOrderBy),
                        ),
                        Tab(
                          child: Text(maxLines: 1, _locale.setUPSetting),
                        ),
                      ],
                      onTap: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                    ),
                  ),
                  _currentIndex == 0
                      ? CriteriaWidget(
                          onSelectedValueChanged1: updateSelectedValue1,
                          onSelectedValueChanged2: updateSelectedValue2,
                          onSelectedValueChanged3: updateSelectedValue3,
                          onSelectedValueChanged4: updateSelectedValue4)
                      : SetupWidget(),
                ],
              )
            : SizedBox.shrink(),
        SizedBox(
          height: isDesktop ? height * 0.01 : height * 0.01,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: height * 0.04,
            child: DottedBorder(
              color: Colors.blue,
              strokeWidth: 1,
              dashPattern: const [
                2,
                2,
              ],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Tooltip(
                        message: hidefilter == true
                            ? _locale.showFilters
                            : _locale.hideFilters,
                        child: IconButton(
                          padding: const EdgeInsets.only(top: 3),
                          onPressed: () {
                            setState(() {
                              hidefilter = !hidefilter;
                            });
                          },
                          icon: hidefilter == false
                              ? Icon(
                                  Icons.arrow_circle_up_sharp,
                                  size: height * 0.025,
                                )
                              : Icon(
                                  Icons.arrow_circle_down_sharp,
                                  size: height * 0.025,
                                ),
                        ),
                      ),
                      Text(_locale.chooseFilter),
                    ],
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  const VerticalDivider(
                    color: primary,
                    width: 1,
                    thickness: 1,
                    indent: 0,
                    endIndent: 0,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Row(
                    children: [
                      IconButton(
                        alignment: Alignment.center,
                        color: primary,
                        onPressed: () async {
                          DateTime from = DateTime.parse(DatesController()
                              .formatDateReverse(DatesController()
                                  .formatDate(readProvider.getFromDate())));
                          DateTime to = DateTime.parse(DatesController()
                              .formatDateReverse(DatesController()
                                  .formatDate(readProvider.getToDate())));
                          if (from.isAfter(to)) {
                            ErrorController.openErrorDialog(
                                1, _locale.startDateAfterEndDate);
                          } else {
                            setState(() {
                              hidefilter = !hidefilter;
                            });

                            pageLis.value = 1;
                            readProvider.setPage(pageLis.value);
                            dynamic body = readProvider.toJson();
                            await generateColumns();
                            reportsResult = await ReportController()
                                .getPurchaseResultMehtod(body, isStart: true);
                            stateManager.removeAllRows();

                            List<PurchaseCostReportModel> result = [];
                            ReportController purchaseReportController =
                                ReportController();
                            stateManager.setShowLoading(true);
                            await purchaseReportController
                                .postPurchaseCostReportMethod(body)
                                .then((value) {
                              result = value;
                              stateManager.setShowLoading(false);
                            });
                            List<PlutoColumn> columns =
                                PurchaseCostReportModel.getColumns(
                                    AppLocalizations.of(context)!,
                                    orderByColumns,
                                    reportsResult,
                                    context);
                            for (int i = 0; i < columns.length; i++) {
                              stateManager!.columns[i].footerRenderer =
                                  columns[i].footerRenderer;
                            }
                            setState(() {});
                            stateManager!.notifyListeners(true);
                            List<PlutoRow> rowsToAdd =
                                result.map((item) => item.toPluto()).toList();
                            stateManager.appendRows(rowsToAdd);
                            pageLis.value = pageLis.value + 1;
                            reportsResult = await ReportController()
                                .getPurchaseResultMehtod(body);
                          }
                        },
                        icon: Icon(
                          Icons.search,
                          size: height * 0.025,
                          color: Colors.black,
                        ),
                      ),
                      Tooltip(
                        message: _locale.reset,
                        child: IconButton(
                            padding: const EdgeInsets.only(top: 3),
                            onPressed: () {
                              isReset.value = true;
                              setState(() {
                                readProvider.emptyProvider();
                                purchaseList = [];
                                finalRow = [];
                              });
                              Future.delayed(Duration(milliseconds: 20), () {
                                isReset.value = false;
                              });
                            },
                            icon: Icon(
                              Icons.refresh,
                              color: Colors.black,
                              size: height * 0.025,
                            )),
                      ),
                      Tooltip(
                        message: _locale.exportToExcel,
                        child: IconButton(
                            padding: const EdgeInsets.only(top: 3),
                            onPressed: () {
                              isDownload.value = true;

                              if (reportsResult!.count == 0) {
                                isDownload.value = false;
                              } else {
                                SearchCriteria searchCriteria = SearchCriteria(
                                  fromDate: readProvider.fromDate,
                                  toDate: readProvider.toDate,
                                  voucherStatus: -100,
                                  columns: getColumnsName(
                                      _locale, orderByColumns, false),
                                  customColumns: getCustomColumnsName(
                                      _locale, orderByColumns, false),
                                );
                                Map<String, dynamic> body =
                                    readProvider.toJson();

                                ReportController()
                                    .exportPurchaseToExcelApi(
                                        searchCriteria, body)
                                    .then((value) {
                                  saveExcelFile(
                                      value, "${_locale.purchasesReport}.xlsx");
                                  isDownload.value = false;
                                });
                              }
                            },
                            icon: Icon(
                              Icons.description,
                              color: Colors.black,
                              size: height * 0.025,
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: hidefilter == true
                ? height * 0.84
                : _currentIndex == 1
                    ? height * 0.6
                    : _currentIndex == 0
                        ? height * 0.56
                        : height * 0.4,
            child: TableComponentNew(
              columnHeight: 70,
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
      ]),
    );
  }

  PlutoLazyPagination lazyPaginationFooter(PlutoGridStateManager stateManager) {
    return PlutoLazyPagination(
      initialPage: 1,
      initialFetch: true,
      pageSizeToMove: 1,
      fetchWithSorting: false,
      fetchWithFiltering: false,
      fetch: (request) {
        return fetch1(request);
      },
      stateManager: stateManager,
    );
  }

  Future<PlutoLazyPaginationResponse> fetch1(
      PlutoLazyPaginationRequest request) async {
    int page = request.page;

    ReportController purchaseReportController = ReportController();
    readProvider.setPage(page);
    dynamic body = readProvider.toJson();
    purchaseList = [];
    List<PlutoRow> topList = [];

    limitPage = reportsResult != null ? (reportsResult!.count! / 10).ceil() : 1;

    print("limitPage purch:${limitPage}");
    if (reportsResult != null && reportsResult!.count != 0) {
      await purchaseReportController
          .postPurchaseCostReportMethod(body)
          .then((value) {
        purchaseList = value;
      });
    }
    for (int i = 0; i < purchaseList.length; i++) {
      topList.add(purchaseList[i].toPluto());
    }
    print("finish purhase");
    return PlutoLazyPaginationResponse(
      totalPage: limitPage,
      rows: reportsResult == null ? [] : topList,
    );
  }

  PlutoInfinityScrollRows lazyLoadingfooter(
      PlutoGridStateManager stateManager) {
    return PlutoInfinityScrollRows(
      initialFetch: false,
      fetchWithSorting: false,
      fetchWithFiltering: false,
      fetch: fetch,
      stateManager: stateManager,
    );
  }

  Future<PlutoInfinityScrollRowsResponse> fetch(
    PlutoInfinityScrollRowsRequest request,
  ) async {
    if (pageLis.value == 1) {
      reportsResult = await ReportController()
          .getPurchaseResultMehtod(readProvider.toJson(), isStart: true);

      // ignore: use_build_context_synchronously
      List<PlutoColumn> columns = PurchaseCostReportModel.getColumns(
          AppLocalizations.of(context)!,
          orderByColumns,
          reportsResult,
          context);
      for (int i = 0; i < columns.length; i++) {
        stateManager.columns[i].footerRenderer = columns[i].footerRenderer;
      }
    }
    List<PlutoRow> topList = [];
    purchaseList = [];
    ReportController salesReportController = ReportController();

    readProvider.setPage(pageLis.value);
    dynamic body = readProvider.toJson();

    await salesReportController
        .postPurchaseCostReportMethod(body)
        .then((value) {
      purchaseList = value;
    });
    for (int i = 0; i < purchaseList.length; i++) {
      PlutoRow plutoRow = purchaseList[i].toPluto();
      rowList.add(plutoRow);
      topList.add(plutoRow);
    }

    stateManager.setShowLoading(false);
    isLoading.value = false;
    isLoadingData.value = false;
    bool isLast = purchaseList.isEmpty ? true : false;
    count = purchaseList.length;
    pageLis.value = pageLis.value + 1;
    itemsNumberDisplayed.value = count;

    return Future.value(PlutoInfinityScrollRowsResponse(
      isLast: false,
      rows: reportsResult == null ? [] : topList,
    ));
  }

  void saveExcelFile(Uint8List byteList, String filename) {
    final blob = html.Blob([byteList]);
    final url = html.Url.createObjectUrlFromBlob(blob);

    final anchor = html.AnchorElement(href: url)
      ..target = 'blank'
      ..download = filename
      ..click();

    html.Url.revokeObjectUrl(url);
  }
}
