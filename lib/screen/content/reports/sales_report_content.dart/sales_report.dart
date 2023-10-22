import 'package:bi_replicate/model/reports/reports_result.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:html' as html;
import '../../../../components/table_component.dart';
import '../../../../controller/reports/report_controller.dart';
import '../../../../model/criteria/search_criteria.dart';
import '../../../../model/reports/sales_report_model/sales_cost_report.dart';
import '../../../../provider/sales_search_provider.dart';
import '../../../../utils/constants/maps.dart';
import '../../../../utils/constants/responsive.dart';
import '../../../../utils/constants/styles.dart';
import '../../../../utils/func/dates_controller.dart';
import '../../../../widget/custom_btn.dart';
import 'tabs/criteria_widget.dart';
import 'tabs/order_by_widget.dart';
import 'tabs/setup_widget.dart';

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
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  double width = 0;
  double height = 0;
  bool isDesktop = false;
  bool isMobile = false;
  // bool isMobile = false;

  @override
  void didChangeDependencies() async {
    _locale = AppLocalizations.of(context);
    readProvider = context.read<SalesCriteraProvider>();
    readProvider.emptyProvider();

    orderByColumns = [
      '#',
      _locale.branch,
      _locale.stockCategoryLevel("1"),
      _locale.stockCategoryLevel("2"),
      _locale.stockCategoryLevel("3"),
      _locale.supplier("1"),
      _locale.supplier("2"),
      _locale.supplier("3"),
      _locale.customer,
      _locale.stock,
      _locale.modelNo,
      _locale.qty,
      _locale.averagePrice,
      _locale.total
    ];

    // await getResult().then(
    //   (value) {
    //     searchSalesCostReport(1);
    //   },
    //  );
    super.didChangeDependencies();
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
      _locale.stockCategoryLevel("1"),
      _locale.stockCategoryLevel("2"),
      _locale.stockCategoryLevel("3"),
      _locale.supplier("1"),
      _locale.supplier("2"),
      _locale.supplier("3"),
      _locale.customer,
      _locale.stock,
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
      // setState(() {
      orderByColumns = orderByColumnsTemp;
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
      // setState(() {
      orderByColumns = columns;
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
      length: 3,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: SizedBox(
                width: isMobile ? width * 0.9 : width * 0.7,
                height: isMobile ? height * 0.1 : height * 0.1,
                child: TabBar(
                  unselectedLabelColor: Colors.grey,
                  labelColor: Colors.black,
                  tabs: [
                    Tab(
                      child: Text(maxLines: 1, _locale.criteria),
                    ),
                    Tab(
                      child: Text(maxLines: 1, _locale.orderBy),
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
            ),
            _currentIndex == 0
                ? CriteriaWidget(
                    fromDate: fromDate,
                    toDate: toDate,
                  )
                : _currentIndex == 1
                    ? OrderByWidget(
                        fromDate: fromDate,
                        toDate: toDate,
                        onSelectedValueChanged1: updateSelectedValue1,
                        onSelectedValueChanged2: updateSelectedValue2,
                        onSelectedValueChanged3: updateSelectedValue3,
                        onSelectedValueChanged4: updateSelectedValue4)
                    : SetupWidget(
                        fromDate: fromDate,
                        toDate: toDate,
                      ),
            SizedBox(
              height: isMobile ? height * 0.05 : height * 0.05,
            ),
            SizedBox(
              width: isDesktop ? width * 0.5 : width * .7,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButton(
                    text: _locale.reset,
                    fontWeight: FontWeight.w400,
                    textColor: Colors.white,
                    borderRadius: 5.0,
                    onPressed: () {
                      setState(() {
                        readProvider.emptyProvider();
                        salesList = [];
                        finalRow = [];
                        orderByColumns = [
                          '#',
                          _locale.branch,
                          _locale.stockCategoryLevel("1"),
                          _locale.stockCategoryLevel("2"),
                          _locale.stockCategoryLevel("3"),
                          _locale.supplier("1"),
                          _locale.supplier("2"),
                          _locale.supplier("3"),
                          _locale.customer,
                          _locale.stock,
                          _locale.modelNo,
                          _locale.qty,
                          _locale.averagePrice,
                          _locale.total
                        ];
                      });
                    },
                    fontSize: isDesktop ? height * .016 : height * .011,
                  ),
                  CustomButton(
                    text: _locale.search,
                    fontWeight: FontWeight.w400,
                    textColor: Colors.white,
                    borderRadius: 5.0,
                    onPressed: () async {
                      print("frommm ${fromDate.text}");
                      context.read<SalesCriteraProvider>().setFromDate(
                          DatesController().formatDate(fromDate.text));
                      context
                          .read<SalesCriteraProvider>()
                          .setToDate(DatesController().formatDate(toDate.text));
                      await generateColumns();

                      dynamic body = readProvider.toJson();
                      reportsResult =
                          await ReportController().getSalesResultMehtod(body);
                      setState(() {
                        // fetch(PlutoLazyPaginationRequest(
                        //     page: readProvider.getPage!));
                      });

                      // getResult().then(
                      //   (value) {
                      //     searchSalesCostReport(1);
                      //   },
                      // );
                    },
                    fontSize: isDesktop ? height * .016 : height * .011,
                  ),
                  CustomButton(
                    text: _locale.exportToExcel,
                    fontWeight: FontWeight.w400,
                    textColor: Colors.white,
                    borderRadius: 5.0,
                    onPressed: () {
                      SearchCriteria searchCriteria = SearchCriteria(
                        fromDate: readProvider.fromDate,
                        toDate: readProvider.toDate,
                        voucherStatus: -100,
                        columns: getColumnsName(_locale, orderByColumns, true),
                        customColumns:
                            getColumnsName(_locale, orderByColumns, true),
                      );
                      Map<String, dynamic> body = readProvider.toJson();
                      ReportController()
                          .exportToExcelApi(searchCriteria, body)
                          .then((value) {
                        saveExcelFile(value, "SalesReport.xlsx");
                      });
                    },
                    fontSize: isDesktop ? height * .016 : height * .011,
                  ),
                  // SizedBox(
                  //   width: isMobile ? width * 0.05 : width * 0.05,
                  // ),
                ],
              ),
            ),
            SizedBox(
              height: isMobile ? height * 0.05 : height * 0.05,
            ),
            SizedBox(
              width: width * 0.7,
              height: height * 0.7,
              child: TableComponent(
                key: UniqueKey(),
                plCols: SalesCostReportModel.getColumns(
                    AppLocalizations.of(context),
                    orderByColumns,
                    reportsResult,
                    width),
                polRows: [],
                footerBuilder: (stateManager) {
                  // print("stateManager ${stateManager.}");
                  return lazyPaginationFooter(stateManager);
                },
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

    ReportController salesReportController = ReportController();
    // List<SalesCostReportModel> newList = salesList;
    readProvider.setPage(page);
    dynamic body = readProvider.toJson();
    salesList = await salesReportController.postSalesCostReportMethod(body);
    // reportsResult = await salesReportController.getSalesResultMehtod(body);
    List<PlutoRow> topList = [];

    limitPage = reportsResult != null ? (reportsResult!.count! / 10).ceil() : 1;

    for (int i = 0; i < salesList.length; i++) {
      topList.add(salesList[i].toPluto());
    }
    print("finish");
    return PlutoLazyPaginationResponse(
      totalPage: limitPage,
      rows: topList,
    );
  }

  // Future searchSalesCostReport(int pageNum) async {
  //   ReportController salesReportController = ReportController();
  //   List<SalesCostReportModel> newList = salesList;
  //   readProvider.setPage(pageNum);
  //   dynamic body = readProvider.toJson();
  //   print("Bodddddy $body");
  //   await salesReportController.postSalesCostReportMethod(body).then((value) {
  //     salesList = value;
  //     if (pageNum > 1 && salesList.isEmpty) {
  //       pageNumber = pageNum - 1;

  //       salesList = newList;
  //     }
  //     setState(() {});
  //   });
  // }

  // Future getResult() async {
  //   ReportController salesReportController = ReportController();

  //   dynamic body = readProvider.toJson();
  //   await salesReportController.getSalesResultMehtod(body).then((value) {
  //     if (value.count! > 0) {
  //       pageNumber = 1;
  //     }
  //     limitPage = (value.count! / 10).ceil();
  //     finalRow = limitPage == 0
  //         ? []
  //         : getTotal(orderByColumns.length, value.total!, value.quantity!,
  //             value.avgPrice!);
  //   });
  // }

  // List<String> getTotal(
  //     int length, double totalAmount, double qty, double price) {
  //   List<String> stringList = [];

  //   for (int i = 0; i < length; i++) {
  //     if (i == length - 1) {
  //       stringList.add(totalAmount.toStringAsFixed(2));
  //     } else if (i == length - 2) {
  //       stringList.add(price.toStringAsFixed(2));
  //     } else if (i == length - 3) {
  //       stringList.add(qty.toStringAsFixed(2));
  //     } else if (i == length - 4) {
  //       stringList.add(AppLocalizations.of(context).finalTotal);
  //     } else {
  //       stringList.add("");
  //     }
  //   }
  //   print("ListFinal ${stringList.length}");
  //   return stringList;
  // }
}
