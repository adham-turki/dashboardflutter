import 'package:bi_replicate/controller/error_controller.dart';
import 'package:bi_replicate/model/reports/reports_result.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:html' as html;
import '../../../../components/table_component.dart';
import '../../../../controller/reports/report_controller.dart';
import '../../../../model/criteria/search_criteria.dart';
import '../../../../model/reports/sales_report_model/sales_cost_report.dart';
import '../../../../provider/sales_search_provider.dart';
import '../../../../utils/constants/app_utils.dart';
import '../../../../utils/constants/maps.dart';
import '../../../../utils/constants/responsive.dart';
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
  // TextEditingController fromDate = TextEditingController();
  // TextEditingController toDate = TextEditingController();
  double width = 0;
  double height = 0;
  bool isDesktop = false;
  bool isMobile = false;
  // bool isMobile = false;

  @override
  void didChangeDependencies() async {
    _locale = AppLocalizations.of(context)!;
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

    reportsResult = await ReportController()
        .getSalesResultMehtod(readProvider.toJson(), isStart: true);
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
                width: isDesktop ? width * 0.7 : width * 0.9,
                height: isDesktop ? height * 0.1 : height * 0.1,
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
                    // fromDate: fromDate,
                    // toDate: toDate,
                    )
                : _currentIndex == 1
                    ? OrderByWidget(
                        // fromDate: fromDate,
                        // toDate: toDate,
                        onSelectedValueChanged1: updateSelectedValue1,
                        onSelectedValueChanged2: updateSelectedValue2,
                        onSelectedValueChanged3: updateSelectedValue3,
                        onSelectedValueChanged4: updateSelectedValue4)
                    : SetupWidget(
                        // fromDate: fromDate,
                        // toDate: toDate,
                        ),
            SizedBox(
              height: isDesktop ? height * 0.05 : height * 0.05,
            ),
            SizedBox(
              width: isDesktop ? width * 0.5 : width * .7,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButton(
                    text: _locale.reset,
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
                  ),
                  CustomButton(
                    text: _locale.search,
                    textColor: Colors.white,
                    borderRadius: 5.0,
                    onPressed: () async {
                      // context.read<SalesCriteraProvider>().setFromDate(
                      //     DatesController().formatDate(fromDate.text));
                      // context
                      //     .read<SalesCriteraProvider>()
                      //     .setToDate(DatesController().formatDate(toDate.text));
                      DateTime from = DateTime.parse(DatesController()
                          .formatDateReverse(readProvider.getFromDate!));
                      DateTime to = DateTime.parse(DatesController()
                          .formatDateReverse(readProvider.getToDate!));

                      if (from.isAfter(to)) {
                        ErrorController.openErrorDialog(
                            1, _locale.startDateAfterEndDate);
                      } else {
                        await generateColumns();

                        dynamic body = readProvider.toJson();
                        reportsResult =
                            await ReportController().getSalesResultMehtod(body);
                        setState(() {});
                      }
                    },
                  ),
                  Components().blueButton(
                    text: _locale.exportToExcel,
                    textColor: Colors.white,
                    borderRadius: 5.0,
                    height: isDesktop ? height * .05 : height * .06,
                    fontSize: isDesktop ? height * .016 : height * .011,
                    width: isDesktop ? width * 0.15 : width * 0.25,
                    onPressed: () {
                      DateTime from = DateTime.parse(DatesController()
                          .formatDateReverse(readProvider.getFromDate!));
                      DateTime to = DateTime.parse(DatesController()
                          .formatDateReverse(readProvider.getToDate!));

                      if (from.isAfter(to)) {
                        print("formmmm $from");
                        print("to $to");
                        print("hellllllllo");
                        ErrorController.openErrorDialog(
                            1, _locale.startDateAfterEndDate);
                      } else {
                        if (salesList.isEmpty) {
                          ErrorController.openErrorDialog(
                              406, _locale.error406);
                        } else {
                          SearchCriteria searchCriteria = SearchCriteria(
                            fromDate: readProvider.fromDate,
                            toDate: readProvider.toDate,
                            voucherStatus: -100,
                            columns:
                                getColumnsName(_locale, orderByColumns, true),
                            customColumns: getCustomColumnsName(
                                _locale, orderByColumns, true),
                          );
                          Map<String, dynamic> body = readProvider.toJson();
                          ReportController()
                              .exportToExcelApi(searchCriteria, body)
                              .then((value) {
                            saveExcelFile(value, "${_locale.salesreport}.xlsx");
                          });
                        }
                      }
                    },
                  ),
                  // SizedBox(
                  //   width: isMobile ? width * 0.05 : width * 0.05,
                  // ),
                ],
              ),
            ),
            SizedBox(
              height: isDesktop ? height * 0.05 : height * 0.05,
            ),
            SizedBox(
              width: isDesktop
                  ? orderByColumns.length > 6
                      ? width * 0.7
                      : width * double.parse("0.${orderByColumns.length}6")
                  : width * 0.7,
              height: height * 0.7,
              child: TableComponent(
                key: UniqueKey(),
                plCols: SalesCostReportModel.getColumns(
                    AppLocalizations.of(context)!,
                    orderByColumns,
                    reportsResult,
                    context),
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
      pageSizeToMove: 1,
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
    salesList = [];
    // reportsResult = await salesReportController.getSalesResultMehtod(body);
    List<PlutoRow> topList = [];

    limitPage = reportsResult != null ? (reportsResult!.count! / 10).ceil() : 1;

    if (reportsResult != null && reportsResult!.count != 0) {
      await await salesReportController
          .postSalesCostReportMethod(body)
          .then((value) {
        salesList = value;
      });
    }
    for (int i = 0; i < salesList.length; i++) {
      topList.add(salesList[i].toPluto());
    }
    return PlutoLazyPaginationResponse(
      totalPage: limitPage,
      rows: reportsResult == null ? [] : topList,
    );
  }
}
