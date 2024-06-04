import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:html' as html;
import '../../../../components/table_component_new.dart';
import '../../../../controller/error_controller.dart';
import '../../../../controller/reports/report_controller.dart';
import '../../../../model/criteria/search_criteria.dart';
import '../../../../model/reports/reports_result.dart';
import '../../../../model/reports/sales_report_model/sales_cost_report.dart';
import '../../../../provider/sales_search_provider.dart';
import '../../../../utils/constants/app_utils.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/constants.dart';
import '../../../../utils/constants/maps.dart';
import '../../../../utils/constants/responsive.dart';
import '../../../../utils/func/dates_controller.dart';
import 'tabs/criteria_widget.dart';
import 'tabs/order_by_widget.dart';
import 'tabs/setup_widget.dart';
import '../../../../components/table_component.dart';

class SalesReportScreen extends StatefulWidget {
  const SalesReportScreen({Key? key}) : super(key: key);

  @override
  State<SalesReportScreen> createState() => _SalesReportScreenState();
}

class _SalesReportScreenState extends State<SalesReportScreen> {
  int _currentIndex = 0;
  late AppLocalizations _locale;
  List<SalesCostReportModel> salesList = [];
  List<String> orderByColumns = [];
  int pageNumber = 0;
  late SalesCriteraProvider readProvider;
  int limitPage = 0;
  List<String> finalRow = [];
  ValueNotifier traficResultModelNotifier =
      ValueNotifier(SalesCostReportModel());

  TextEditingController fromDate = TextEditingController();
  // TextEditingController toDate = TextEditingController();
  double width = 0;
  double height = 0;
  bool isDesktop = false;
  bool isMobile = false;
  ValueNotifier isDownload = ValueNotifier(false);
  bool hidefilter = false;
  bool isHide = false;
  ValueNotifier pageLis = ValueNotifier(1);
  ValueNotifier isLoading = ValueNotifier(true);
  ValueNotifier isLoadingData = ValueNotifier(true);
  ValueNotifier itemsNumberDisplayed = ValueNotifier(0);
  ValueNotifier<List<PlutoRow>> tableListener = ValueNotifier([]);
  int count = 0;
  PlutoGridStateManager? stateManager;
  List<PlutoRow> rowList = [];
  List<PlutoColumn> polCols = [];
  // bool isMobile = false;
  // String todayDate = DatesController().formatDateReverse(
  //     DatesController().formatDate(DatesController().todayDate()));

  ValueNotifier isReset = ValueNotifier(false);

  @override
  void didChangeDependencies() async {
    _locale = AppLocalizations.of(context)!;
    readProvider = context.read<SalesCriteraProvider>();
    readProvider.emptyProvider();
    // polCols = [];

    orderByColumns = [
      '#',
      _locale.branch, _locale.stock,

      _locale.stockCategoryLevel("1"),
      _locale.stockCategoryLevel("2"),
      _locale.stockCategoryLevel("3"),
      _locale.supplier("1"),
      _locale.supplier("2"),
      _locale.supplier("3"),
      _locale.customer,
      _locale.modelNo,
      _locale.qty,
      _locale.averagePrice,
      _locale.total,
      // _locale.costPriceAvg,
      // _locale.totalCost,
      // _locale.diffBetCostAndSale,
      // _locale.profitPercent
    ];
    polCols = SalesCostReportModel.getColumns(
        AppLocalizations.of(context)!, orderByColumns, reportsResult, context);
    // await getResult().then(
    //   (value) {
    //     searchSalesCostReport(1);
    //   },
    //  );

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
      // for (int i = 0; i < stateManager!!.rows.length; i++) {
      //   stateManager!!.rows[i].cells['intStatus']!.value =
      //       getStatusNameDependsLang(
      //           stateManager!!.rows[i].cells['intStatus']!.value, locale);
      // }
      stateManager!.notifyListeners(true);
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    readProvider.emptyProvider();
    super.dispose();
  }

  String selectedValueFromDropdown1 = "";
  String selectedValueFromDropdown2 = "";
  String selectedValueFromDropdown3 = "";
  String selectedValueFromDropdown4 = "";

  void updateSelectedValue1(String value) {
    // setState(() {
    selectedValueFromDropdown1 = value;
    // });
  }

  void updateSelectedValue2(String value) {
    // setState(() {
    selectedValueFromDropdown2 = value;
    // });
  }

  void updateSelectedValue3(String value) {
    // setState(() {
    selectedValueFromDropdown3 = value;
    // });
  }

  void updateSelectedValue4(String value) {
    // setState(() {
    selectedValueFromDropdown4 = value;
    // });
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
      _locale.customer,
      _locale.modelNo,
      _locale.qty,
      _locale.averagePrice,
      _locale.total,
      // _locale.costPriceAvg,
      // _locale.totalCost,
      // _locale.diffBetCostAndSale,
      // _locale.profitPercent
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
      stateManager!.removeColumns(stateManager!.columns);

      for (int i = 0;
          i <
              SalesCostReportModel.getColumns(AppLocalizations.of(context)!,
                      orderByColumns, reportsResult, context)
                  .length;
          i++) {
        stateManager!.insertColumns(i, [
          SalesCostReportModel.getColumns(
              _locale, orderByColumnsTemp, reportsResult, context)[i]
        ]);
      }
      if (readProvider.useItemCostPrice == true) {
        orderByColumnsTemp.addAll([
          _locale.costPriceAvg,
          _locale.totalCost,
          _locale.diffBetCostAndSale,
          _locale.profitPercent
        ]);
        stateManager!.removeColumns(stateManager!.columns);

        for (int i = 0;
            i <
                SalesCostReportModel.getColumns(AppLocalizations.of(context)!,
                        orderByColumns, reportsResult, context)
                    .length;
            i++) {
          stateManager!.insertColumns(i, [
            SalesCostReportModel.getColumns(
                _locale, orderByColumnsTemp, reportsResult, context)[i]
          ]);
        }
      } else if (readProvider.useItemCostPrice == false) {
        stateManager!.removeColumns(stateManager!.columns);
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
          _locale.customer,
          _locale.modelNo,
          _locale.qty,
          _locale.averagePrice,
          _locale.total,
        ];
        for (int i = 0;
            i <
                SalesCostReportModel.getColumns(AppLocalizations.of(context)!,
                        orderByColumns, reportsResult, context)
                    .length;
            i++) {
          stateManager!.insertColumns(i, [
            SalesCostReportModel.getColumns(
                _locale, temp, reportsResult, context)[i]
          ]);
        }
      }

      // });
    } else {
      Set<String> selectedValues = {};

      if (selectedValueFromDropdown1 != "") {
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
      if (readProvider.useItemCostPrice == true) {
        orderByColumnsTemp.addAll([
          _locale.costPriceAvg,
          _locale.totalCost,
          _locale.diffBetCostAndSale,
          _locale.profitPercent
        ]);
        stateManager!.removeColumns(stateManager!.columns);

        for (int i = 0;
            i <
                SalesCostReportModel.getColumns(AppLocalizations.of(context)!,
                        orderByColumns, reportsResult, context)
                    .length;
            i++) {
          stateManager!.insertColumns(i, [
            SalesCostReportModel.getColumns(
                _locale, orderByColumnsTemp, reportsResult, context)[i]
          ]);
        }
      }

      // setState(() {
      orderByColumns = columns;
      stateManager!.removeColumns(stateManager!.columns);
      if (readProvider.getOrders!.isNotEmpty) {
        for (int i = 0;
            i <
                SalesCostReportModel.getColumns(AppLocalizations.of(context)!,
                        orderByColumns, reportsResult, context)
                    .length;
            i++) {
          stateManager!.insertColumns(i, [
            SalesCostReportModel.getColumns(
                _locale, orderByColumns, reportsResult, context)[i]
          ]);
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
                SalesCostReportModel.getColumns(AppLocalizations.of(context)!,
                        temp, reportsResult, context)
                    .length;
            i++) {
          stateManager!.insertColumns(i, [
            SalesCostReportModel.getColumns(
                _locale, temp, reportsResult, context)[i]
          ]);
        }
      }
      // });
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
      child: SingleChildScrollView(
        child: Column(
          children: [
            // SizedBox(
            //   height: height * 0.04,
            //   child: DottedBorder(
            //     color: Colors.blue,
            //     strokeWidth: 1,
            //     dashPattern: const [
            //       2,
            //       2,
            //     ],
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         SizedBox(),
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           crossAxisAlignment: CrossAxisAlignment.center,
            //           children: [
            //             Tooltip(
            //               message: hidefilter == true
            //                   ? _locale.showFilters
            //                   : _locale.hideFilters,
            //               child: IconButton(
            //                 padding: const EdgeInsets.only(top: 3),
            //                 onPressed: () {
            //                   setState(() {
            //                     hidefilter = !hidefilter;
            //                     isHide = true;
            //                   });
            //                 },
            //                 icon: hidefilter == false
            //                     ? Icon(
            //                         Icons.arrow_circle_up_sharp,
            //                         size: height * 0.025,
            //                       )
            //                     : Icon(
            //                         Icons.arrow_circle_down_sharp,
            //                         size: height * 0.025,
            //                       ),
            //               ),
            //             ),
            //             Text(_locale.chooseFilter),
            //           ],
            //         ),
            //         Row(
            //           // mainAxisAlignment: MainAxisAlignment.center,
            //           // crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             Tooltip(
            //               message: _locale.reset,
            //               child: IconButton(
            //                   padding: const EdgeInsets.only(top: 3),
            //                   onPressed: () {
            //                     setState(() {
            //                       readProvider.emptyProvider();
            //                       salesList = [];
            //                       finalRow = [];
            //                       orderByColumns = [
            //                         '#',
            //                         _locale.branch,
            //                         _locale.stockCategoryLevel("1"),
            //                         _locale.stockCategoryLevel("2"),
            //                         _locale.stockCategoryLevel("3"),
            //                         _locale.supplier("1"),
            //                         _locale.supplier("2"),
            //                         _locale.supplier("3"),
            //                         _locale.customer,
            //                         _locale.stock,
            //                         _locale.modelNo,
            //                         _locale.qty,
            //                         _locale.averagePrice,
            //                         _locale.total
            //                       ];
            //                     });
            //                   },
            //                   icon: Icon(
            //                     Icons.refresh,
            //                     color: Colors.black,
            //                     size: height * 0.025,
            //                   )),
            //             ),
            //             Tooltip(
            //               message: _locale.exportToExcel,
            //               child: IconButton(
            //                   padding: const EdgeInsets.only(top: 3),
            //                   onPressed: () {
            //                     isDownload.value = true;

            //                     DateTime from = DateTime.parse(DatesController()
            //                         .formatDateReverse(
            //                             readProvider.getFromDate()!));
            //                     DateTime to = DateTime.parse(DatesController()
            //                         .formatDateReverse(
            //                             readProvider.getToDate()!));

            //                     if (from.isAfter(to)) {
            //                       ErrorController.openErrorDialog(
            //                           1, _locale.startDateAfterEndDate);
            //                     } else {
            //                       if (salesList.isEmpty) {
            //                         ErrorController.openErrorDialog(
            //                             406, _locale.error406);
            //                         isDownload.value = false;
            //                       } else {
            //                         SearchCriteria searchCriteria =
            //                             SearchCriteria(
            //                           fromDate: readProvider.fromDate,
            //                           toDate: readProvider.toDate,
            //                           voucherStatus: -100,
            //                           columns: getColumnsName(
            //                               _locale, orderByColumns, true),
            //                           customColumns: getCustomColumnsName(
            //                               _locale, orderByColumns, true),
            //                         );
            //                         Map<String, dynamic> body =
            //                             readProvider.toJson();
            //                         ReportController()
            //                             .exportToExcelApi(searchCriteria, body)
            //                             .then((value) {
            //                           saveExcelFile(
            //                               value, "${_locale.salesreport}.xlsx");
            //                           isDownload.value = false;
            //                         });
            //                       }
            //                     }
            //                   },
            //                   icon: Icon(
            //                     Icons.description,
            //                     color: Colors.black,
            //                     size: height * 0.025,
            //                   )),
            //             ),
            //           ],
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            hidefilter == false
                ? Column(
                    children: [
                      Center(
                        child: SizedBox(
                          width: isDesktop ? width * 0.7 : width * 0.9,
                          height: height * 0.045,
                          child: TabBar(
                            unselectedLabelColor: Colors.grey,
                            labelColor: Colors.black,
                            indicatorColor: primary,
                            tabs: [
                              Tab(
                                child: Text(
                                    maxLines: 1, _locale.critiriaAndOrderBy),
                              ),
                              // Tab(
                              //   child: Text(maxLines: 1, _locale.orderBy),
                              // ),
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
            // SizedBox(
            //   height: isDesktop ? height * 0.0001 : height * 0.05,
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: height * 0.04,
                // width: width * 0.7,
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
                                  isHide = true;
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
                        // mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                            alignment: Alignment.center,
                            color: primary,
                            onPressed: () async {
                              // context.read<SalesCriteraProvider>().setFromDate(
                              //     DatesController().formatDate(fromDate.text));
                              // context
                              //     .read<SalesCriteraProvider>()
                              //     .setToDate(DatesController().formatDate(toDate.text));

                              DateTime from = DateTime.parse(DatesController()
                                  .formatDateReverse(DatesController()
                                      .formatDate(
                                          readProvider.getFromDate()!)));
                              DateTime to = DateTime.parse(DatesController()
                                  .formatDateReverse(DatesController()
                                      .formatDate(readProvider.getToDate()!)));

                              if (from.isAfter(to)) {
                                ErrorController.openErrorDialog(
                                    1, _locale.startDateAfterEndDate);
                              } else {
                                setState(() {
                                  hidefilter = !hidefilter;
                                });
                                // }
                                // dynamic body = readProvider.toJson();

                                pageLis.value = 1;

                                readProvider.setPage(pageLis.value);
                                dynamic body = readProvider.toJson();
                                stateManager!.setShowLoading(true);
                                await generateColumns();
                                // if (pageLis.value == 1) {
                                reportsResult = await ReportController()
                                    .getSalesResultMehtod(readProvider.toJson(),
                                        isStart: true);
                                stateManager!.removeAllRows();

                                List<SalesCostReportModel> result = [];
                                ReportController purchaseReportController =
                                    ReportController();

                                await purchaseReportController
                                    .postSalesCostReportMethod(body)
                                    .then((value) {
                                  result = value;
                                  stateManager!.setShowLoading(false);
                                });

                                List<PlutoColumn> columns =
                                    SalesCostReportModel.getColumns(
                                        AppLocalizations.of(context)!,
                                        orderByColumns,
                                        reportsResult,
                                        context);
                                if (stateManager != null) {
                                  int maxNumber = 1;

                                  for (int i = 0; i < polCols.length; i++) {
                                    int length =
                                        polCols[i].title.split(" ").length;
                                    if (length > maxNumber) {
                                      maxNumber = length;
                                    }
                                    String title = specialColumnsWidth(
                                            polCols, i, _locale)
                                        ? polCols[i].title
                                        : longSentenceWidth(polCols, i, _locale)
                                            ? '${polCols[i].title.split(' ').take(2).join(' ')}\n${polCols[i].title.split(' ').skip(2).join(' ')}'
                                            : polCols[i].title.replaceAll(" ",
                                                "\n"); // _locale.lastPricePurchase
                                    polCols[i].titleSpan = TextSpan(
                                      children: [
                                        WidgetSpan(
                                          child: Text(
                                            title,
                                            style:
                                                const TextStyle(fontSize: 10),
                                          ),
                                        ),
                                      ],
                                    );
                                    polCols[i].titleTextAlign =
                                        PlutoColumnTextAlign.center;
                                    polCols[i].textAlign =
                                        PlutoColumnTextAlign.center;

                                    stateManager!.columns[i].title =
                                        polCols[i].title;
                                    stateManager!.columns[i].width =
                                        polCols[i].width;
                                    stateManager!.columns[i].titleTextAlign =
                                        polCols[i].titleTextAlign;
                                    stateManager!.columns[i].textAlign =
                                        polCols[i].textAlign;
                                    stateManager!.columns[i].titleSpan =
                                        polCols[i].titleSpan;
                                  }
                                  // for (int i = 0; i < stateManager!!.rows.length; i++) {
                                  //   stateManager!!.rows[i].cells['intStatus']!.value =
                                  //       getStatusNameDependsLang(
                                  //           stateManager!!.rows[i].cells['intStatus']!.value, locale);
                                  // }
                                  stateManager!.notifyListeners(true);
                                }

                                for (int i = 0; i < columns.length; i++) {
                                  stateManager!.columns[i].footerRenderer =
                                      columns[i].footerRenderer;
                                }
                                setState(() {});
                                stateManager!.notifyListeners(true);
                                List<PlutoRow> rowsToAdd = result
                                    .map((item) => item.toPluto())
                                    .toList();
                                stateManager!.appendRows(rowsToAdd);
                                pageLis.value = pageLis.value + 1;
                                reportsResult = await ReportController()
                                    .getSalesResultMehtod(body);
                                // setState(() {});
                              }
                            },
                            icon: Icon(
                              Icons.search,
                              color: Colors.black,
                              size: height * 0.025,
                            ),
                            // style: customButtonStyle(
                            //     Size(width * 0.13, height * 0.045), 16, primary2),
                          ),
                          Tooltip(
                            message: _locale.reset,
                            child: IconButton(
                                padding: const EdgeInsets.only(top: 3),
                                onPressed: () {
                                  readProvider.emptyProvider();
                                  salesList = [];
                                  finalRow = [];
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

                                  DateTime from = DateTime.parse(
                                      DatesController().formatDateReverse(
                                          readProvider.getFromDate()!));
                                  DateTime to = DateTime.parse(DatesController()
                                      .formatDateReverse(
                                          readProvider.getToDate()!));

                                  if (from.isAfter(to)) {
                                    ErrorController.openErrorDialog(
                                        1, _locale.startDateAfterEndDate);
                                  } else {
                                    if (salesList.isEmpty) {
                                      ErrorController.openErrorDialog(
                                          406, _locale.error406);
                                      isDownload.value = false;
                                    } else {
                                      SearchCriteria searchCriteria =
                                          SearchCriteria(
                                        fromDate: readProvider.fromDate,
                                        toDate: readProvider.toDate,
                                        voucherStatus: -100,
                                        columns: getColumnsName(
                                            _locale, orderByColumns, true),
                                        customColumns: getCustomColumnsName(
                                            _locale, orderByColumns, true),
                                      );
                                      Map<String, dynamic> body =
                                          readProvider.toJson();
                                      ReportController()
                                          .exportToExcelApi(
                                              searchCriteria, body)
                                          .then((value) {
                                        saveExcelFile(value,
                                            "${_locale.salesreport}.xlsx");
                                        isDownload.value = false;
                                      });
                                    }
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
                      // SizedBox(),
                    ],
                  ),
                ),
              ),
            ),
            // SizedBox(
            //   height: isDesktop ? height * 0.0001 : height * 0.05,
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                // width: isDesktop
                // ? orderByColumns.length > 6
                //     ? width * 0.8
                //     : width * double.parse("0.${orderByColumns.length}6")
                // : width * 0.7,
                height: hidefilter == true
                    ? height * 0.77
                    : _currentIndex == 1
                        ? height * 0.6
                        : _currentIndex == 0
                            ? height * 0.55
                            : height * 0.4,
                child: TableComponentNew(
                  columnHeight: 70,
                  // key: UniqueKey(),
                  plCols: polCols,
                  polRows: [],
                  footerBuilder: (stateManager) {
                    return lazyLoadingfooter(stateManager!);
                  },
                  onLoaded: (PlutoGridOnLoadedEvent event) {
                    stateManager = event.stateManager;
                    if (isLoading.value) {
                      stateManager!.setShowLoading(true);
                    }
                    stateManager!.setShowColumnFilter(true);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
    } else {
      // final directory = await getTemporaryDirectory();
      // final file = File('${directory.path}/$filename');
      // await file.writeAsBytes(byteList);
      // Use platform-specific code to open the file in a Flutter app
      // For example: launch(url) from the url_launcher package
    }
  }

  // PlutoLazyPagination lazyPaginationFooter(PlutoGridStateManager! stateManager!) {
  //   return PlutoLazyPagination(
  //     initialPage: 1,
  //     initialFetch: true,
  //     pageSizeToMove: 1,
  //     fetchWithSorting: false,
  //     fetchWithFiltering: false,
  //     fetch: (request) {
  //       return fetchPagination(request);
  //     },
  //     stateManager!: stateManager!,
  //   );
  // }

  // Future<PlutoLazyPaginationResponse> fetchPagination(
  //     PlutoLazyPaginationRequest request) async {
  //   int page = request.page;

  //   ReportController salesReportController = ReportController();
  //   // List<SalesCostReportModel> newList = salesList;
  //   readProvider.setPage(page);
  //   dynamic body = readProvider.toJson();
  //   salesList = [];
  //   // reportsResult = await salesReportController.getSalesResultMehtod(body);
  //   List<PlutoRow> topList = [];

  //   limitPage = reportsResult != null ? (reportsResult!.count! / 10).ceil() : 1;

  //   if (reportsResult != null && reportsResult!.count != 0) {
  //     await await salesReportController
  //         .postSalesCostReportMethod(body)
  //         .then((value) {
  //       salesList = value;
  //     });
  //   }
  //   for (int i = 0; i < salesList.length; i++) {
  //     topList.add(salesList[i].toPluto());
  //   }
  //   return PlutoLazyPaginationResponse(
  //     totalPage: limitPage,
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
    if (pageLis.value == 1) {
      reportsResult = await ReportController()
          .getSalesResultMehtod(readProvider.toJson(), isStart: true);

      List<PlutoColumn> columns = SalesCostReportModel.getColumns(
          AppLocalizations.of(context)!,
          orderByColumns,
          reportsResult,
          context);
      for (int i = 0; i < columns.length; i++) {
        stateManager!.columns[i].footerRenderer = columns[i].footerRenderer;
      }
    }
    List<PlutoRow> topList = [];
    salesList = [];
    ReportController salesReportController = ReportController();

    readProvider.setPage(pageLis.value);
    dynamic body = readProvider.toJson();

    await salesReportController.postSalesCostReportMethod(body).then((value) {
      salesList = value;
    });

    reportsResult =
        await ReportController().getSalesResultMehtod(readProvider.toJson());

    for (int i = 0; i < salesList.length; i++) {
      PlutoRow plutoRow = salesList[i].toPluto();
      rowList.add(plutoRow);
      topList.add(plutoRow);
    }

    stateManager!.setShowLoading(false);
    isLoading.value = false;
    isLoadingData.value = false;
    bool isLast = salesList.isEmpty ? true : false;
    count = salesList.length;
    pageLis.value = pageLis.value + 1;
    itemsNumberDisplayed.value = count;

    return Future.value(PlutoInfinityScrollRowsResponse(
      isLast: isLast,
      rows: reportsResult == null ? [] : topList,
    ));
  }
}
