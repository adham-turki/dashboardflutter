import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../../components/custom_date.dart';
import '../../../components/table_component.dart';
import '../../../controller/error_controller.dart';
import '../../../controller/inventory_performance/inventory_performance_controller.dart';
import '../../../model/criteria/search_criteria.dart';
import '../../../model/inventory_performance/inventory_performance_model.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/maps.dart';
import '../../../utils/constants/responsive.dart';
import '../../../utils/constants/styles.dart';
import '../../../utils/func/dates_controller.dart';
import '../../../widget/custom_date_picker.dart';
import '../../../widget/drop_down/custom_dropdown.dart';
import '../../../widget/custom_textfield.dart';

class InventoryPerfContent extends StatefulWidget {
  const InventoryPerfContent({super.key});

  @override
  State<InventoryPerfContent> createState() => _InventoryPerfContentState();
}

class _InventoryPerfContentState extends State<InventoryPerfContent> {
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  TextEditingController numberOfrow = TextEditingController();
  InventoryPerformanceController inventoryPerformanceController =
      InventoryPerformanceController();
  late AppLocalizations _locale;
  List<String> status = [];
  List<String> periods = [];
  var selectedStatus = "";
  String? fromDateValue;
  String? toDateValue;

  var selectedPeriod = "";
  String hintValue = '0';

  String todayDate = DatesController().formatDateReverse(
      DatesController().formatDate(DatesController().todayDate()));

  final storage = const FlutterSecureStorage();

  SearchCriteria criteria = SearchCriteria();
  List<PlutoRow> polTopRows = [];
  FocusNode focusNode = FocusNode();
  int countInc = 0;
  int countDec = 0;

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
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context)!;
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
    focusNode.requestFocus();

    super.didChangeDependencies();
  }

  double width = 0;
  double height = 0;
  int count = 0;
  bool isDesktop = false;
  bool isMobile = false;
  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    isDesktop = Responsive.isDesktop(context);
    isMobile = Responsive.isMobile(context);
    focusNode.requestFocus();
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Container(
              width: isDesktop ? width * 0.7 : width * 0.9,
              decoration: borderDecoration,
              child: isDesktop ? desktopCritiria() : mobileCritiria(),
            )
          ],
        ),
        isDesktop
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: height * .03,
                        ),
                        SelectableText(
                          maxLines: 1,
                          _locale.topOfInventoryPerformance,
                          style: eighteen500TextStyle(colorNewList[0]),
                        ),
                        SizedBox(
                          height: height * .03,
                        ),
                        SizedBox(
                          width: width * 0.37,
                          height: height * 0.6,
                          child: TableComponent(
                            key: UniqueKey(),
                            plCols: InventoryPerformanceModel.getColumns(
                                AppLocalizations.of(context)!, context),
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
                        SizedBox(
                          height: height * .03,
                        ),
                        SelectableText(
                          maxLines: 1,
                          _locale.leastOfInventoryPerformance,
                          style: eighteen500TextStyle(colorNewList[2]),
                        ),
                        SizedBox(
                          height: height * .03,
                        ),
                        SizedBox(
                          width: width * 0.37,
                          height: height * 0.6,
                          child: TableComponent(
                            key: UniqueKey(),
                            plCols: InventoryPerformanceModel.getColumns(
                                AppLocalizations.of(context)!, context),
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
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: height * .03,
                        ),
                        SelectableText(
                          maxLines: 1,
                          _locale.topOfInventoryPerformance,
                          style: eighteen500TextStyle(colorNewList[0]),
                        ),
                        SizedBox(
                          height: height * .03,
                        ),
                        SizedBox(
                          width: isDesktop ? width * 0.7 : width * 0.9,
                          height: height * 0.7,
                          child: TableComponent(
                            key: UniqueKey(),
                            plCols: InventoryPerformanceModel.getColumns(
                                AppLocalizations.of(context)!, context),
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
                        SizedBox(
                          height: height * .03,
                        ),
                        SelectableText(
                          maxLines: 1,
                          _locale.leastOfInventoryPerformance,
                          style: eighteen500TextStyle(colorNewList[2]),
                        ),
                        SizedBox(
                          height: height * .03,
                        ),
                        SizedBox(
                          width: isDesktop ? width * 0.7 : width * 0.9,
                          height: height * 0.7,
                          child: TableComponent(
                            key: UniqueKey(),
                            plCols: InventoryPerformanceModel.getColumns(
                                AppLocalizations.of(context)!, context),
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

  Column desktopCritiria() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomDropDown(
              hint: periods[0],
              label: _locale.period,
              items: periods,
              initialValue: selectedPeriod.isNotEmpty ? selectedPeriod : null,
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
              initialValue: selectedStatus.isNotEmpty ? selectedStatus : null,
              height: height * 0.18,
              onChanged: (value) {
                setState(() {
                  selectedStatus = value;
                  int status = getVoucherStatus(_locale, selectedStatus);
                  criteria.voucherStatus = status;
                });
              },
            ),
            CustomTextField(
              focusNode: focusNode,
              controller: numberOfrow,
              initialValue: numberOfrow.text,
              label: _locale.itemsNumber,
              onSubmitted: (value) {
                setState(() {
                  hintValue = value;
                  criteria.rownum = int.parse(numberOfrow.text);
                });
              },
              onChanged: (value) {
                hintValue = value;
                criteria.rownum = int.parse(numberOfrow.text);
              },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomDate(
              dateController: fromDate,
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
              dateControllerToCompareWith: toDate,
              isInitiaDate: true,
              timeControllerToCompareWith: null,
            ),
            SizedBox(
              width: width * 0.01,
            ),
            CustomDate(
              dateController: toDate,
              label: _locale.toDate,
              onValue: (isValid, value) {
                if (isValid) {
                  setState(() {
                    toDate.text = value;
                    setControllertoDateText();
                  });
                }
              },
              dateControllerToCompareWith: fromDate,
              isInitiaDate: false,
              timeControllerToCompareWith: null,
            ),
          ],
        ),
      ],
    );
  }

  Column mobileCritiria() {
    double widthMobile = width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomDropDown(
              hint: periods[0],
              label: _locale.period,
              width: widthMobile * 0.81,
              items: periods,
              initialValue: selectedPeriod.isNotEmpty ? selectedPeriod : null,
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
              width: widthMobile * 0.81,
              initialValue: selectedStatus.isNotEmpty ? selectedStatus : null,
              height: height * 0.18,
              onChanged: (value) {
                setState(() {
                  selectedStatus = value;
                  int status = getVoucherStatus(_locale, selectedStatus);
                  criteria.voucherStatus = status;
                });
              },
            ),
            CustomTextField(
              focusNode: focusNode,
              controller: numberOfrow,
              width: widthMobile * 0.81,
              initialValue: numberOfrow.text,
              label: _locale.itemsNumber,
              onSubmitted: (value) {
                setState(() {
                  hintValue = value;
                  criteria.rownum = int.parse(numberOfrow.text);
                });
              },
              onChanged: (value) {
                hintValue = value;
                criteria.rownum = int.parse(numberOfrow.text);
              },
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: widthMobile * 0.81,
              child: CustomDate(
                dateController: fromDate,
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
                dateControllerToCompareWith: toDate,
                isInitiaDate: true,
                timeControllerToCompareWith: null,
              ),
            ),
            SizedBox(
              width: widthMobile * 0.81,
              child: CustomDate(
                dateController: toDate,
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
                dateControllerToCompareWith: fromDate,
                isInitiaDate: false,
                timeControllerToCompareWith: null,
              ),
            ),
          ],
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
    List<PlutoRow> topList = [];
    List<InventoryPerformanceModel> invList = [];
    if (countDec == 0) {
      await inventoryPerformanceController
          .totalSellDic(criteria, isStart: true)
          .then((value) {
        invList = value;
      });
      countDec = 1;
    } else {
      await inventoryPerformanceController.totalSellDic(criteria).then((value) {
        invList = value;
      });
      countDec = 1;
    }
    for (int i = 0; i < invList.length; i++) {
      topList.add(invList[i].toPluto());
    }

    return PlutoLazyPaginationResponse(
      totalPage: 0,
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

    List<PlutoRow> topList = [];

    List<InventoryPerformanceModel> invList = [];
    if (countInc == 0) {
      await inventoryPerformanceController
          .totalSellInc(criteria, isStart: true)
          .then((value) {
        invList = value;
      });
      countInc = 1;
    } else {
      await inventoryPerformanceController.totalSellInc(criteria).then((value) {
        invList = value;
      });
      countInc = 1;
    }
    int totalPage = 1;

    for (int i = 0; i < invList.length; i++) {
      topList.add(invList[i].toPluto());
    }

    return PlutoLazyPaginationResponse(
      totalPage: 0,
      rows: topList,
    );
  }
}
