import 'package:bi_replicate/widget/custom_btn.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:provider/provider.dart';
import '../../../../components/table_component.dart';
import '../../../../controller/error_controller.dart';
import '../../../../controller/reports/report_controller.dart';
import '../../../../model/criteria/search_criteria.dart';
import '../../../../model/reports/purchase_cost_report.dart';
import '../../../../model/reports/reports_result.dart';
import '../../../../provider/purchase_provider.dart';
import '../../../../utils/constants/app_utils.dart';
import '../../../../utils/constants/maps.dart';
import '../../../../utils/constants/responsive.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:html' as html;

import 'tabs/criteria_widget.dart';
import 'tabs/order_by_widget.dart';
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
  // TextEditingController fromDate = TextEditingController();
  // TextEditingController toDate = TextEditingController();
  @override
  void didChangeDependencies() async {
    _locale = AppLocalizations.of(context);
    readProvider = context.read<PurchaseCriteraProvider>();
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
      _locale.stock,
      _locale.modelNo,
      _locale.qty,
      _locale.averagePrice,
      _locale.total
    ];

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
          child: Column(children: [
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
          height: isMobile ? height * 0.05 : height * 0.05,
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
                    purchaseList = [];
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
                  // context
                  //     .read<PurchaseCriteraProvider>()
                  //     .setFromDate(DatesController().formatDate(fromDate.text));
                  // context
                  //     .read<PurchaseCriteraProvider>()
                  //     .setToDate(DatesController().formatDate(toDate.text));
                  await generateColumns();
                  dynamic body = readProvider.toJson();
                  reportsResult =
                      await ReportController().getPurchaseResultMehtod(body);
                  setState(() {});
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
                  if (purchaseList.isEmpty) {
                    ErrorController.openErrorDialog(406, _locale.error406);
                  } else {
                    SearchCriteria searchCriteria = SearchCriteria(
                      fromDate: readProvider.fromDate,
                      toDate: readProvider.toDate,
                      voucherStatus: -100,
                      columns: getColumnsName(_locale, orderByColumns, false),
                      customColumns:
                          getColumnsName(_locale, orderByColumns, false),
                    );
                    Map<String, dynamic> body = readProvider.toJson();

                    ReportController()
                        .exportPurchaseToExcelApi(searchCriteria, body)
                        .then((value) {
                      saveExcelFile(value, "PurchasesReports.xlsx");
                    });
                  }
                },
              ),
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
            plCols: PurchaseCostReportModel.getColumns(
                AppLocalizations.of(context),
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
      ])),
    );
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

    ReportController purchaseReportController = ReportController();
    // List<SalesCostReportModel> newList = salesList;
    readProvider.setPage(page);
    dynamic body = readProvider.toJson();
    purchaseList =
        await purchaseReportController.postPurchaseCostReportMethod(body);
    // reportsResult = await salesReportController.getSalesResultMehtod(body);
    List<PlutoRow> topList = [];

    limitPage = reportsResult != null ? (reportsResult!.count! / 10).ceil() : 1;

    for (int i = 0; i < purchaseList.length; i++) {
      topList.add(purchaseList[i].toPluto());
    }
    print("finish");
    return PlutoLazyPaginationResponse(
      totalPage: limitPage,
      rows: reportsResult == null ? [] : topList,
    );
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
