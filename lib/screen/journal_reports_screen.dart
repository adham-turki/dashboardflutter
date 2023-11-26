import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';
import 'dart:ui';

import 'package:bi_replicate/controller/general_ledger/journal_report_controller.dart';
import 'package:bi_replicate/model/journal_reports_model.dart';
import 'package:bi_replicate/model/new_search_criteria_model.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:excel/excel.dart';
import 'package:file_saver/file_saver.dart';
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
import '../utils/constants/colors.dart';
import '../utils/constants/constants_apis.dart';
import '../utils/constants/maps.dart';
import '../utils/constants/responsive.dart';
import '../widget/text_field_custom.dart';
import 'package:pluto_grid_export/pluto_grid_export.dart' as pluto_grid_export;

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
  Map<String, dynamic>? accountToAdd;
  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context);
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
    getAccountList().then((value) {
      for (var i = 0; i < accountModelList.length; i++) {
        print(
            "accountModelList[i].txtEnglishName: ${accountModelList[i].txtEnglishName}");
        print("accountModelList[i].txtCode: ${accountModelList[i].txtCode}");
      }
    });

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
                    MyImageButton(
                      imagePath: 'assets/images/excel.png',
                      onPressed: () {
                        // exportToCsv();
                        exportToExcel();
                        debugPrint('Excel clicked!');
                      },
                    ),
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

  void exportToExcel() async {
    // Create a new Excel workbook and sheet
    final workbook = Excel.createExcel();
    final sheet = workbook['Sheet1'];
    showLoading(context);
    JournalController()
        .getAllJournalReports(searchCriteriaForExcel!)
        .then((value) async {
      sheet.appendRow([
        _locale.date,
        _locale.voucher,
        _locale.voucherNum,
        _locale.status,
        _locale.account,
        _locale.reference,
        _locale.currency,
        _locale.debit,
        _locale.credit,
        _locale.dibc,
        _locale.cibc,
        _locale.comments,
      ]);
      if (value.isNotEmpty) {
        for (int i = 0; i < value.length; i++) {
          final data = value[i];
          sheet.appendRow([
            data.referDate ?? "",
            data.voucherTypeNameE ?? "",
            data.voucher ?? "",
            data.statusName ?? "",
            data.accName ?? "",
            data.custSupName ?? "",
            data.transCurrency ?? "",
            data.debit,
            data.credit,
            data.debitInBaseCur,
            data.creditInBaseCur,
            data.comments ?? "",
          ]);
        }
        Navigator.pop(context);
        downloadFile(Uint8List.fromList(workbook.encode()!),
            "${_locale.journalReports}.xlsx");
        showSuccesDialog(context);
      } else if (value.isEmpty) {
        showEmptyDialog(context);
      }
    });
  }

  void downloadFile(Uint8List bytes, String fileName) {
    final blob = Blob([bytes]);
    final url = Url.createObjectUrlFromBlob(blob);
    final anchor = AnchorElement(href: url)
      ..download = fileName
      ..click();
  }

  void exportToCsv() async {
    String title = "pluto_grid_export";

    var exported = const Utf8Encoder()
        .convert(pluto_grid_export.PlutoGridExport.exportCSV(stateManager));
    print(exported);

    // use file_saver from pub.dev
    // await FileSaver.instance
    //     .saveFile(name: "$title.csv", bytes: exported, mimeType: MimeType.csv);
  }

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
        vouchType: "-1",
        voucherStatus: selectedVocherType);
    searchCriteriaForExcel = NewSearchCriteria(
        fromAccCode: "",
        fromDate: _fromDate.text,
        fromJCode: selectedFromCode,
        page: "0",
        toAccCode: "",
        toDate: _toDateHere.text,
        toJCode: selectedToCode,
        vouchType: "-1",
        voucherStatus: selectedVocherType);
    List<JournalReportsModel> value =
        await JournalController().getAllJournalReports(searchCriteria!);
    setState(() {
      journalReportsList = value;
      for (int i = 0; i < journalReportsList.length; i++) {
        topList.add(journalReportsList[i].toPluto());
        print(journalReportsList[i].referDate);
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
}
