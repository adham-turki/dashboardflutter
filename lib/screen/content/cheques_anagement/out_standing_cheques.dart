import 'dart:typed_data';
import 'dart:html' as html;
import 'package:bi_replicate/model/cheques_bank/cheques_model.dart';
import 'package:bi_replicate/model/cheques_bank/cheques_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../../components/custom_date.dart';
import '../../../components/table_component.dart';
import '../../../controller/cheques_management/self_cheques_controller.dart';
import '../../../controller/error_controller.dart';
import '../../../model/criteria/search_criteria.dart';
import '../../../utils/constants/maps.dart';
import '../../../utils/constants/responsive.dart';
import '../../../utils/constants/styles.dart';
import '../../../utils/func/dates_controller.dart';
import '../../../widget/custom_btn.dart';
import '../../../widget/drop_down/custom_dropdown.dart';

class OutStandingChequesContent extends StatefulWidget {
  const OutStandingChequesContent({super.key});

  @override
  State<OutStandingChequesContent> createState() =>
      _OutStandingChequesContentState();
}

class _OutStandingChequesContentState extends State<OutStandingChequesContent> {
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  SelfChequesController controller = SelfChequesController();

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
  String firstDayCurrentMonth = DatesController().formatDateReverse(
      DatesController().formatDate(DatesController().currentMonth()));
  // String netMonth = DatesController().formatDateReverse(DatesController()
  //     .formatDate(DateTime(DatesController().today.year,
  //             DatesController().today.month + 1, DatesController().today.day)
  //         .toString()));
  List<String> columnsName = [];
  List<String> columnsNameMap = [];

  final storage = const FlutterSecureStorage();

  SearchCriteria criteria = SearchCriteria();
  List<PlutoRow> polTopRows = [];
  ChequesResult? reportsResult;

  @override
  void initState() {
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
    fromDate.text = firstDayCurrentMonth;
    toDate.text = todayDate;
    criteria.fromDate = DatesController().formatDate(fromDate.text);
    criteria.toDate = DatesController().formatDate(toDate.text);
    criteria.voucherStatus = -100;
    criteria.rownum = 10;

    reportsResult =
        await controller.getChequeResultMethod(criteria, isStart: true);
    super.didChangeDependencies();
  }

  double width = 0;
  String? statusValue;
  String? voucherTypeValue;
  String? periodValue;
  double height = 0;
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
          // height: isDesktop ? height * 0.35 : height * 0.6,
          width: isDesktop ? width * 0.7 : width * 0.9,
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
                    width: isDesktop ? width * 0.7 : width * 0.9,
                    height: height * 0.65,
                    child: TableComponent(
                      key: UniqueKey(),
                      plCols: ChequesModel.getColumns(
                          AppLocalizations.of(context)!,
                          reportsResult,
                          context),
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
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // CustomDropDown(
            //   hint: periods[0],
            //   label: _locale.period,
            //   items: periods,
            //   initialValue: selectedPeriod.isNotEmpty ? selectedPeriod : null,
            //   onChanged: (value) async {
            //     checkPeriods(value);
            //     selectedPeriod = value;
            //     reportsResult =
            //         await controller.getChequeResultMethod(criteria);

            //     setState(() {});
            //   },
            // ),
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
                selectedPeriod = value;
                reportsResult =
                    await controller.getChequeResultMethod(criteria);

                setState(() {});
              },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CustomDate(
              dateController: fromDate,
              label: _locale.fromDate,
              lastDate: DateTime.now(),
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
              lastDate: DateTime.now(),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
              child: SizedBox(
                  width: MediaQuery.of(context).size.width < 800
                      ? MediaQuery.of(context).size.width * 0.6
                      : MediaQuery.of(context).size.width * 0.16,
                  child: CustomButton(
                    text: _locale.exportToExcel,
                    textColor: Colors.white,
                    borderRadius: 5.0,
                    onPressed: () {
                      // DateTime from = DateTime.parse(fromDate.text);
                      // DateTime to = DateTime.parse(toDate.text);

                      // if (from.isAfter(to)) {
                      //   ErrorController.openErrorDialog(
                      //       1, _locale.startDateAfterEndDate);
                      // } else {
                      if (reportsResult!.count == 0) {
                        // ErrorController.openErrorDialog(406, _locale.error406);
                      } else {
                        int status = getVoucherStatus(_locale, selectedStatus);
                        SearchCriteria searchCriteria = SearchCriteria(
                          fromDate: DatesController().formatDate(fromDate.text),
                          toDate: DatesController().formatDate(toDate.text),
                          voucherStatus: status,
                          columns: columnsNameMap,
                          customColumns: columnsNameMap,
                        );
                        SelfChequesController()
                            .exportToExcelApi(searchCriteria)
                            .then((value) {
                          saveExcelFile(value, "${_locale.cheques}.xlsx");
                        });
                      }
                      // }
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
            // CustomDropDown(
            //   hint: periods[0],
            //   label: _locale.period,
            //   items: periods,
            //   width: widthMobile * 0.81,
            //   initialValue: selectedPeriod.isNotEmpty ? selectedPeriod : null,
            //   onChanged: (value) async {
            //     checkPeriods(value);
            //     selectedPeriod = value;
            //     reportsResult =
            //         await controller.getChequeResultMethod(criteria);

            //     setState(() {});
            //   },
            // ),
            CustomDropDown(
              label: _locale.status,
              hint: status[0],
              items: status,
              width: widthMobile * 0.81,
              initialValue: selectedStatus.isNotEmpty ? selectedStatus : null,
              height: height * 0.18,
              onChanged: (value) async {
                selectedStatus = value;
                int status = getVoucherStatus(_locale, selectedStatus);
                criteria.voucherStatus = status;
                selectedPeriod = value;
                reportsResult =
                    await controller.getChequeResultMethod(criteria);

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
              width: widthMobile * 0.81,
              child: CustomDate(
                dateController: fromDate,
                label: _locale.fromDate,
                lastDate: DateTime.now(),
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
                lastDate: DateTime.now(),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
              child: SizedBox(
                  width: MediaQuery.of(context).size.width < 800
                      ? MediaQuery.of(context).size.width * 0.6
                      : MediaQuery.of(context).size.width * 0.16,
                  child: CustomButton(
                    text: _locale.exportToExcel,
                    textColor: Colors.white,
                    borderRadius: 5.0,
                    onPressed: () {
                      DateTime from = DateTime.parse(fromDate.text);
                      DateTime to = DateTime.parse(toDate.text);

                      if (from.isAfter(to)) {
                        ErrorController.openErrorDialog(
                            1, _locale.startDateAfterEndDate);
                      } else {
                        if (reportsResult!.count == 0) {
                          ErrorController.openErrorDialog(
                              406, _locale.error406);
                        } else {
                          int status =
                              getVoucherStatus(_locale, selectedStatus);
                          SearchCriteria searchCriteria = SearchCriteria(
                            fromDate:
                                DatesController().formatDate(fromDate.text),
                            toDate: DatesController().formatDate(toDate.text),
                            voucherStatus: status,
                            columns: columnsNameMap,
                            customColumns: columnsNameMap,
                          );
                          SelfChequesController()
                              .exportToExcelApi(searchCriteria)
                              .then((value) {
                            saveExcelFile(value, "${_locale.cheques}.xlsx");
                          });
                        }
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
    reportsResult = await controller.getChequeResultMethod(criteria);
    return setState(() {
      fetch(PlutoLazyPaginationRequest(page: criteria.page!));
    });
  }

  void setControllertoDateText() async {
    toDateValue = toDate.text;
    String endDate = DatesController().formatDate(toDateValue!);

    criteria.toDate = endDate;
    reportsResult = await controller.getChequeResultMethod(criteria);

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
// Save the CSV string to a file
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

    List<ChequesModel> invList = [];
    if (reportsResult != null && reportsResult!.count != 0) {
      await controller.getCheques(criteria).then((value) {
        invList = value;
      });
    }

    int totalPage =
        reportsResult != null ? (reportsResult!.count! / 10).ceil() : 1;
    print("total: ${totalPage}");
    for (int i = 0; i < invList.length; i++) {
      topList.add(invList[i].toPluto());
    }

    return PlutoLazyPaginationResponse(
      totalPage: 0,
      rows: reportsResult == null ? [] : topList,
    );
  }
}
