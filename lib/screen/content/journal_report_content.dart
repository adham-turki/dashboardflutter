import 'package:bi_replicate/components/table_component.dart';

import 'package:bi_replicate/widget/custom_date_picker.dart';
import 'package:bi_replicate/widget/drop_down/custom_dropdown.dart';

import 'package:flutter/material.dart';

import 'package:pluto_grid/pluto_grid.dart';

import '../../model/criteria/journal_report_criteria.dart';
import '../../model/db/general_ledger/journal_report/journal_report_model.dart';

class JournalContent extends StatefulWidget {
  const JournalContent({super.key});

  @override
  State<JournalContent> createState() => _JournalContentState();
}

class _JournalContentState extends State<JournalContent> {
  double width = 0;
  double height = 0;

  // final JournalReport _journalReport = JournalReport();
  // final JournalReportController _journalController = JournalReportController();

  String? statusValue;
  String? voucherTypeValue;
  String? fromJCodeValue;
  String? toJCodeValue;
  String? periodValue;

  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();
  String? fromDateValue;
  String? toDateValue;

  String data = "";

  JournalReportCriteria criteria = JournalReportCriteria(
    fromJCode: "A",
    toJCode: "C",
    fromDate: "2023-5-1",
    toDate: "2023-09-27",
    fromAccCode: "1101010301",
    toAccCode: "1101010301",
  );

  List<PlutoRow> dummyPluto = [
    PlutoRow(cells: {
      'date': PlutoCell(value: "-"),
      'voucher': PlutoCell(value: "-"),
      'voucherLink': PlutoCell(value: "-"),
      'status': PlutoCell(value: "-"),
      'account': PlutoCell(value: "-"),
      'reference': PlutoCell(value: "-"),
      'currencyName': PlutoCell(value: "-"),
      'debit': PlutoCell(value: 0),
      'credit': PlutoCell(value: 0),
      'debitInBase': PlutoCell(value: 0),
      'creditInBase': PlutoCell(value: 0),
      'comments': PlutoCell(value: "-"),
    }),
  ];

  @override
  void initState() {
    setInitialValues();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    List<PlutoColumn> polCols = JournalReport.toPlutoColumn();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          child: SizedBox(
            // height: height * 0.9,
            width: width * 0.76,
            child: Column(
              children: [
                Row(
                  children: [
                    CustomDropDown(
                      label: "Period",
                      items: const [
                        "Last Day",
                        "Last Week",
                        "Last Month",
                        "Last Year",
                        "Previous Month",
                      ],
                      initialValue: "Last Month",
                      hint: "",
                      onChanged: (value) {
                        setState(() {
                          periodValue = value;
                          // _fetchData();
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomDropDown(
                      label: "From Account",
                      hint: "",
                    ),
                    CustomDropDown(
                      label: "To Account",
                      hint: "",
                    ),
                    CustomDatePicker(
                      label: "From Date",
                      controller: _fromDateController,
                      onChanged: (value) {
                        setControllerFromDateText();
                      },
                      onSelected: (value) {
                        setControllerFromDateText();
                      },
                    ),
                    CustomDatePicker(
                      label: "To Date",
                      controller: _toDateController,
                      onChanged: (value) {
                        setState(() {
                          toDateValue = value;
                          // _fetchData();
                        });
                      },
                      onSelected: (value) {
                        setState(() {
                          toDateValue = value;
                          // _fetchData();
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomDropDown(
                      label: "From JCode",
                      items: const [
                        "A",
                      ],
                      initialValue: "A",
                      hint: "",
                      onChanged: (value) {
                        setState(() {
                          fromJCodeValue = value;
                          // _fetchData();
                        });
                      },
                    ),
                    CustomDropDown(
                      label: "To JCode",
                      items: const [
                        "Z",
                      ],
                      initialValue: "Z",
                      hint: "",
                      onChanged: (value) {
                        setState(() {
                          toJCodeValue = value;
                          // _fetchData();
                        });
                      },
                    ),
                    CustomDropDown(
                      label: "Voucher Type",
                      items: const [
                        "All",
                      ],
                      initialValue: "All",
                      hint: "",
                      onChanged: (value) {
                        setState(() {
                          voucherTypeValue = value;
                          // _fetchData();
                        });
                      },
                    ),
                    CustomDropDown(
                      label: "Status",
                      items: const [
                        "ALL(DRAFT, POSTED)",
                        "Draft",
                        "Posted",
                        "Cancelled",
                      ],
                      initialValue: "ALL(DRAFT, POSTED)",
                      hint: "",
                      height: height * 0.18,
                      onChanged: (value) {
                        setState(() {
                          statusValue = value;
                          // _fetchData();
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: width * 0.75,
            height: height * 0.7,
            child: TableComponent(
              plCols: polCols,
              polRows: dummyPluto,
              footerBuilder: (stateManager) {
                return JournalReport.lazyPaginationFooter(stateManager);
              },
              onSelected: (event) {
                setState(() {
                  data = event.row!.cells['account']!.value.toString();
                });
              },
              doubleTab: (event) {
                showDialog(
                    context: context,
                    builder: (builder) {
                      return const AlertDialog(
                        title: Text("ACTION"),
                      );
                    });
              },
              rightClickTap: (event) {
                showDialog(
                    context: context,
                    builder: (builder) {
                      return const AlertDialog(
                        title: Text("ACTION"),
                      );
                    });
              },
              // headerBuilder: (event) {
              //   return headerTableSection(data);
              // },
            ),
          ),
        ),
      ],
    );
  }

  Row headerTableSection(String data) {
    print("object");
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: width * 0.5,
          height: height * 0.03,
          child: Text("Account: $data"),
        ),
        IconButton(
          onPressed: () {
            print("object");
          },
          iconSize: 45,
          icon: const Icon(Icons.print),
        ),
      ],
    );
  }

  void setControllerFromDateText() {
    return setState(() {
      fromDateValue = _fromDateController.text;
      // _fetchData();
    });
  }

  void setInitialValues() {
    fromJCodeValue = "A";
    toJCodeValue = "C";
    setLastMonth();
  }

  void setLastMonth() {
    DateTime currentDate = DateTime.now();
    DateTime lastM =
        DateTime(currentDate.year, currentDate.month - 1, currentDate.day);

    // Handle the case where the current month is January (month 1)
    if (currentDate.month == 1) {
      lastM = DateTime(currentDate.year - 1, 12, currentDate.day);
    }
    int lastDay = lastM.day;
    int lastMonth = lastM.month;
    int lastYear = lastM.year;

    _fromDateController.text = "$lastDay/$lastMonth/$lastYear";

    int nowDay = currentDate.day;
    int nowMonth = currentDate.month;
    int nowYear = currentDate.year;

    _toDateController.text = "$nowDay/$nowMonth/$nowYear";
  }
}
