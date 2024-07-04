import 'dart:convert';
// import 'dart:html';
import 'dart:typed_data';
import 'dart:ui';

import 'package:bi_replicate/controller/general_ledger/journal_report_controller.dart';
import 'package:bi_replicate/controller/vouch_type_controller.dart';
import 'package:bi_replicate/model/journal_reports_model.dart';
import 'package:bi_replicate/model/new_search_criteria_model.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:excel/excel.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../components/filter_button.dart';
import '../components/my_image_button.dart';
import '../components/searchComp.dart';
import '../components/table_component.dart';
import '../controller/journal_controller.dart';
import '../controller/settings/setup/setup_screen_controller.dart';
import '../model/settings/setup/account_model.dart';
import '../model/vouch_type_model.dart';
import '../utils/constants/colors.dart';
import '../utils/constants/constants_apis.dart';
import '../utils/constants/maps.dart';
import '../utils/constants/responsive.dart';
import '../widget/check_boxes_dialog.dart';
import '../widget/text_field_custom.dart';

class JournalReportsScreen extends StatefulWidget {
  const JournalReportsScreen({super.key});

  @override
  State<JournalReportsScreen> createState() => _JournalReportsScreenState();
}

class _JournalReportsScreenState extends State<JournalReportsScreen> {
  late AppLocalizations _locale;
  TextEditingController searchController = TextEditingController();
  double width = 0;
  double height = 0;
  bool isDesktop = false;
  bool isMobile = false;
  List<PlutoRow> topList = [];
  List<JournalReportsModel> journalReportsList = [];
  TextEditingController _fromDate = TextEditingController();
  TextEditingController _toDateHere = TextEditingController();
  String selectedPeriod = "";
  String selectedFromAccount = "";
  String selectedToAccount = "";
  String selectedFromCode = "";
  String selectedToCode = "";
  String selectedVocherType = "";
  int selectedStatus = 0;
  String selectedStatusName = "";
  late PlutoGridStateManager stateManager;
  NewSearchCriteria? searchCriteria;
  NewSearchCriteria? searchCriteriaForExcel;
  List<String> accountsNameList = [];
  List<AccountModel> accountModelList = [];
  List<String> vouchTypeNameList = [];
  List<VouchTypeModel> vouchTypeList = [];
  Map<String, dynamic>? accountToAdd;
  Map<String, dynamic>? vouchTypeToAdd;
  bool dateBoolVall = true;
  bool voucherBoolVall = true;
  bool voucherNumBoolVall = true;
  bool statusBoolVall = true;
  bool accountBoolVall = true;
  bool referenceBoolVall = true;
  bool currencyBoolVall = true;
  bool debitBoolVall = true;
  bool cridetBoolVall = true;
  bool dibcBoolVall = true;
  bool cibcBoolVall = true;
  bool commentsBoolVall = true;
  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context)!;
    columns = <PlutoColumn>[
      PlutoColumn(
          // width: 1000,
          title: _locale.date,
          field: 'date',
          type: PlutoColumnType.date(),
          enableRowChecked: true,
          backgroundColor: colColor),
      PlutoColumn(
        title: _locale.voucher,
        field: 'voucher',
        type: PlutoColumnType.text(),
        backgroundColor: colColor,
      ),
      PlutoColumn(
        title: _locale.voucherNum,
        field: 'voucherNum',
        type: PlutoColumnType.text(),
        backgroundColor: colColor,
      ),
      PlutoColumn(
        title: _locale.status,
        field: 'status',
        type: PlutoColumnType.select(<String>[
          'All',
          'Draft',
          'Posted',
        ]),
        backgroundColor: colColor,
      ),
      PlutoColumn(
        title: _locale.account,
        field: 'account',
        type: PlutoColumnType.text(),
        backgroundColor: colColor,
      ),
      PlutoColumn(
        title: _locale.reference,
        field: 'refernce',
        type: PlutoColumnType.text(),
        backgroundColor: colColor,
      ),
      PlutoColumn(
        title: _locale.currency,
        field: 'currency',
        type: PlutoColumnType.select(<String>[
          'ILS ₪',
          'USD',
        ]),
        backgroundColor: colColor,
      ),
      PlutoColumn(
        title: _locale.debit,
        field: 'debit',
        type: PlutoColumnType.currency(),
        backgroundColor: colColor,
      ),
      PlutoColumn(
        title: _locale.credit,
        field: 'credit',
        type: PlutoColumnType.currency(),
        backgroundColor: colColor,
      ),
      PlutoColumn(
        title: _locale.dibc,
        field: 'dibc',
        type: PlutoColumnType.currency(),
        backgroundColor: colColor,
      ),
      PlutoColumn(
        title: _locale.cibc,
        field: 'cibc',
        type: PlutoColumnType.currency(),
        backgroundColor: colColor,
      ),
      PlutoColumn(
        title: _locale.comments,
        field: 'comments',
        type: PlutoColumnType.text(),
        backgroundColor: colColor,
      ),

      // PlutoColumn(
      //   title: 'Total',
      //   field: 'total',
      //   type: PlutoColumnType.currency(),
      //           enableRowChecked: true,

      //   footerRenderer: (rendererContext) {
      //     return PlutoAggregateColumnFooter(
      //       rendererContext: rendererContext,
      //       formatAsCurrency: true,
      //       type: PlutoAggregateColumnType.sum,
      //       alignment: Alignment.center,
      //       titleSpanBuilder: (text) {
      //         return [
      //           const TextSpan(
      //             text: 'Total',
      //             style: TextStyle(color: Colors.red),
      //           ),

      //         ];
      //       },
      //     );
      //   },
      // ),
    ];
    getAccountList().then((value) {});
    getVouchTypeList().then((value) {});
    super.didChangeDependencies();
  }

  @override
  void initState() {
    fetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    isDesktop = Responsive.isDesktop(context);
    isMobile = Responsive.isMobile(context);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          height: MediaQuery.of(context).size.height * 0.09,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${_locale.fromDate}: ${_fromDate.text}"),
                  Text('${_locale.toDate}: ${_toDateHere.text}'),
                  Text(
                    '${_locale.status} : ${selectedStatusName}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline,
                      decorationThickness: 2.0,
                      decorationColor: Colors.black,
                    ),
                  ),
                  Text('                        '),
                  Text('                        '),
                ],
              ),
              const SizedBox(
                width: double.infinity, // Width of the screen
                child: Divider(
                  color: Colors.black, // Color of the line
                  thickness: 1, // Height of the line
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
            ),
          ),
          padding: const EdgeInsets.all(15),
          height: MediaQuery.of(context).size.height * 0.07,
          width: MediaQuery.of(context).size.width * 0.98,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: FilterButton(
                          locale: _locale,
                          onPressed: () {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) => SearchComponent(
                                accountsList: accountModelList,
                                voucherTypeList: vouchTypeList,
                                onFilter: (selectedPeriod,
                                    fromDate,
                                    toDate,
                                    selectedFromAccountt,
                                    selectedToAccountt,
                                    selectedFromCodee,
                                    selectedToCodee,
                                    selectedVocherTypee,
                                    selectedStatuss) {
                                  setState(() {
                                    _fromDate.text = fromDate;
                                    _toDateHere.text = toDate;
                                    selectedFromAccount = selectedFromAccountt;
                                    selectedToAccount = selectedToAccountt;
                                    selectedFromCode = selectedFromCodee;
                                    selectedToCode = selectedToCodee;
                                    selectedVocherType = selectedVocherTypee;
                                    selectedStatusName = selectedStatuss;
                                    selectedStatus = getVoucherStatus(
                                        _locale, selectedStatusName);
                                  });

                                  print("_fromDate.text: $fromDate");
                                  print("_toDateHere.text: $toDate");
                                  print(
                                      "selectedFromAccount: $selectedFromAccountt");
                                  print(
                                      "selectedToAccount: $selectedToAccountt");
                                  print("selectedFromCode: $selectedFromCodee");
                                  print("selectedToCode: $selectedToCodee");
                                  print(
                                      "selectedVocherType: $selectedVocherTypee");
                                  print("selectedStatus: $selectedStatus");
                                  print(
                                      "selectedStatusName: $selectedStatusName");
                                },
                              ),
                            ).then((value) {
                              if (value) {
                                setState(() {
                                  fetch();
                                });
                              }
                            });
                          },
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                    // MyImageButton(imagePath: , onPressed: (){

                    // }),
                  ],
                ),
              ),
              SizedBox(
                child: Row(
                  children: [
                    MyImageButton(
                      imagePath: 'assets/images/whatsapp.png',
                      onPressed: () {
                        debugPrint('Whatsapp clicked!');
                      },
                    ),
                    // MyImageButton(
                    //   imagePath: 'assets/images/excel.png',
                    //   onPressed: () {
                    //     // exportToCsv();
                    //     showDialog(
                    //       context: context,
                    //       builder: (context) {
                    //         return ExportCheckBoxesDialog(
                    //           onFilter: (dateBoolVal,
                    //               voucherBoolVal,
                    //               voucherNumBoolVal,
                    //               statusBoolVal,
                    //               accountBoolVal,
                    //               referenceBoolVal,
                    //               currency,
                    //               debitBoolVal,
                    //               cridetBoolVal,
                    //               dibcBoolVal,
                    //               cibcBoolVal,
                    //               commentsBoolVal) {
                    //             dateBoolVall = dateBoolVal;
                    //             voucherBoolVall = voucherBoolVal;
                    //             voucherNumBoolVall = voucherNumBoolVal;
                    //             statusBoolVall = statusBoolVal;
                    //             accountBoolVall = accountBoolVal;
                    //             referenceBoolVall = referenceBoolVal;
                    //             currencyBoolVall = currency;
                    //             debitBoolVall = debitBoolVal;
                    //             cridetBoolVall = cridetBoolVal;
                    //             dibcBoolVall = dibcBoolVal;
                    //             cibcBoolVall = cibcBoolVal;
                    //             commentsBoolVall = commentsBoolVal;
                    //             print('dateBoolVal: $dateBoolVal');
                    //             print('voucherBoolVal: $voucherBoolVal');
                    //             print('voucherNumBoolVal: $voucherNumBoolVal');
                    //             print('statusBoolVal: $statusBoolVal');
                    //             print('accountBoolVal: $accountBoolVal');
                    //             print('referenceBoolVal: $referenceBoolVal');
                    //             print('currencyBoolVal: $currency');
                    //             print('debitBoolVal: $debitBoolVal');
                    //             print('creditBoolVal: $cridetBoolVall');
                    //             print('dibcBoolVal: $dibcBoolVal');
                    //             print('cibcBoolVal: $cibcBoolVal');
                    //             print('commentsBoolVal: $commentsBoolVal');
                    //           },
                    //         );
                    //       },
                    //     ).then((value) {
                    //       if (value) {
                    //         exportToExcel();
                    //       }
                    //     });
                    //   },
                    // ),
                    MyImageButton(
                      imagePath: 'assets/images/printer.png',
                      onPressed: () {
                        debugPrint('Printer clicked!');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: height * 0.02),
        SizedBox(
          width: isDesktop ? width * 0.8 : width,
          height: height * 0.7,
          child: TableComponent(
            key: UniqueKey(),
            onLoaded: (event) {
              stateManager = event;
            },
            // stateManager: stateManager,
            plCols: columns,
            polRows: topList,
            // footerBuilder: (stateManager) {
            //   return lazyPaginationFooter(stateManager);
            // },
          ),
        ),
      ],
    );
  }

  showSuccesDialog(BuildContext context) {
    CoolAlert.show(
        barrierDismissible: false,
        cancelBtnText: _locale.cancel,
        confirmBtnText: _locale.ok,
        width: MediaQuery.of(context).size.width * 0.3,
        context: context,
        type: CoolAlertType.success,
        title: "",
        widget: Column(
          children: [
            Text(
              _locale.excelExported,
              style: const TextStyle(fontSize: 30),
            ),
            const SizedBox(
              height: 25,
            )
          ],
        ),
        confirmBtnTextStyle: const TextStyle(fontSize: 30, color: Colors.white),
        cancelBtnTextStyle: const TextStyle(fontSize: 30),
        onConfirmBtnTap: () {
          // setState(() {
          //   toContinue = true;
          // });
          Navigator.pop(context);
        });
  }

  showEmptyDialog(BuildContext context) {
    CoolAlert.show(
        barrierDismissible: false,
        cancelBtnText: _locale.cancel,
        confirmBtnText: _locale.ok,
        width: MediaQuery.of(context).size.width * 0.3,
        context: context,
        type: CoolAlertType.warning,
        title: "",
        widget: Column(
          children: [
            Text(
              _locale.noDataAvailable,
              style: const TextStyle(fontSize: 30),
            ),
            const SizedBox(
              height: 25,
            )
          ],
        ),
        confirmBtnTextStyle: const TextStyle(fontSize: 30, color: Colors.white),
        cancelBtnTextStyle: const TextStyle(fontSize: 30),
        onConfirmBtnTap: () {
          // setState(() {
          //   toContinue = true;
          // });
          Navigator.pop(context);
          Navigator.pop(context);
        });
  }

  // void exportToExcel() async {
  //   // Create a new Excel workbook and sheet
  //   final workbook = Excel.createExcel();
  //   final sheet = workbook['Sheet1'];
  //   showLoading(context);
  //   JournalController()
  //       .getAllJournalReports(searchCriteriaForExcel!)
  //       .then((value) async {
  //     sheet.appendRow([
  //       if (dateBoolVall) _locale.date,
  //       if (voucherBoolVall) _locale.voucher,
  //       if (voucherNumBoolVall) _locale.voucherNum,
  //       if (statusBoolVall) _locale.status,
  //       if (accountBoolVall) _locale.account,
  //       if (referenceBoolVall) _locale.reference,
  //       if (currencyBoolVall) _locale.currency,
  //       if (debitBoolVall) _locale.debit,
  //       if (cridetBoolVall) _locale.credit,
  //       if (dibcBoolVall) _locale.dibc,
  //       if (cibcBoolVall) _locale.cibc,
  //       if (commentsBoolVall) _locale.comments,
  //     ]);
  //     if (value.isNotEmpty) {
  //       for (int i = 0; i < value.length; i++) {
  //         final data = value[i];
  //         sheet.appendRow([
  //           if (dateBoolVall) data.referDate ?? "",
  //           if (voucherBoolVall) data.voucherTypeNameE ?? "",
  //           if (voucherNumBoolVall) data.voucher ?? "",
  //           if (statusBoolVall) data.statusName ?? "",
  //           if (accountBoolVall) data.accName ?? "",
  //           if (referenceBoolVall) data.custSupName ?? "",
  //           if (currencyBoolVall) data.transCurrency ?? "",
  //           if (debitBoolVall) data.debit,
  //           if (cridetBoolVall) data.credit,
  //           if (dibcBoolVall) data.debitInBaseCur,
  //           if (cibcBoolVall) data.creditInBaseCur,
  //           if (commentsBoolVall) data.comments ?? "",
  //         ]);
  //       }
  //       Navigator.pop(context);
  //       downloadFile(Uint8List.fromList(workbook.encode()!),
  //           "${_locale.journalReports}.xlsx");
  //       showSuccesDialog(context);
  //     } else if (value.isEmpty) {
  //       showEmptyDialog(context);
  //     }
  //   });
  // }

  // void downloadFile(Uint8List bytes, String fileName) {
  //   final blob = Blob([bytes]);
  //   final url = Url.createObjectUrlFromBlob(blob);
  //   final anchor = AnchorElement(href: url)
  //     ..download = fileName
  //     ..click();
  // }

  // void exportToCsv() async {
  //   String title = "pluto_grid_export";

  //   var pluto_grid_export;
  //   var exported = const Utf8Encoder()
  //       .convert(pluto_grid_export.PlutoGridExport.exportCSV(stateManager));
  //   print(exported);

  //   // use file_saver from pub.dev
  //   // await FileSaver.instance
  //   //     .saveFile(name: "$title.csv", bytes: exported, mimeType: MimeType.csv);
  // }

  fetch() async {
    journalReportsList.clear();
    topList.clear();
    searchCriteria = NewSearchCriteria(
        fromAccCode: selectedFromAccount,
        fromDate: _fromDate.text,
        fromJCode: selectedFromCode,
        page: "0",
        toAccCode: selectedToAccount,
        toDate: _toDateHere.text,
        toJCode: selectedToCode,
        vouchType: selectedVocherType.isEmpty ? "-1" : selectedVocherType,
        voucherStatus: "${selectedStatus}");
    searchCriteriaForExcel = NewSearchCriteria(
        fromAccCode: selectedFromAccount,
        fromDate: _fromDate.text,
        fromJCode: selectedFromCode,
        page: "0",
        toAccCode: selectedToAccount,
        toDate: _toDateHere.text,
        toJCode: selectedToCode,
        vouchType: selectedVocherType.isEmpty ? "-1" : selectedVocherType,
        voucherStatus: "${selectedStatus}");
    List<JournalReportsModel> value =
        await JournalController().getAllJournalReports(searchCriteria!);
    setState(() {
      journalReportsList = value;
      for (int i = 0; i < journalReportsList.length; i++) {
        topList.add(journalReportsList[i].toPluto());
        // print(journalReportsList[i].referDate);
      }
    });
  }

  List<PlutoColumn> columns = [];
  Future getAccountList() async {
    accountsNameList = [];
    accountToAdd = <String, dynamic>{};
    await SetupController().getAllReportAccounts().then((value) {
      accountModelList = value;

      for (var elemant in value) {
        accountsNameList.add(elemant.txtEnglishName!);
      }
      for (int i = 0; i < accountModelList.length; i++) {
        accountToAdd![accountModelList[i].txtEnglishName!] =
            accountModelList[i].txtCode;
      }
    });

    setState(() {});
  }

  Future getVouchTypeList() async {
    vouchTypeNameList = [];
    accountToAdd = <String, dynamic>{};
    await VouchTypeController().getAllVouchTypes().then((value) {
      vouchTypeList = value;

      for (var elemant in value) {
        vouchTypeNameList.add(elemant.txtEnglishname);
      }
      // for (int i = 0; i < vouchTypeList.length; i++) {
      //   vouchTypeToAdd![vouchTypeList[i].txtEnglishname] =
      //       vouchTypeList[i].intVouchtype;
      // }
    });

    setState(() {});
  }
}
