import 'package:bi_replicate/components/search_table/table_widget.dart';
import 'package:bi_replicate/model/settings/setup/account_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:bi_replicate/components/search_table/data_row.dart' as data_row;

import '../utils/constants/colors.dart';
import '../utils/constants/constants.dart';
import '../utils/constants/maps.dart';
import '../utils/constants/responsive.dart';
import '../utils/func/dates_controller.dart';
import '../widget/drop_down/custom_dropdown.dart';
import 'custom_date.dart';
import 'date_text_field.dart';

class SearchComponent extends StatefulWidget {
  final List<AccountModel>? accountsList;
  final Function(
      String selectedPeriod,
      String fromDate,
      String toDate,
      String selectedFromAccount,
      String selectedToAccount,
      String selectedFromCode,
      String selectedToCode,
      String selectedVocherType,
      String selectedStatus) onFilter;
  SearchComponent({super.key, required this.onFilter, this.accountsList});

  @override
  State<SearchComponent> createState() => _SearchComponentState();
}

class _SearchComponentState extends State<SearchComponent> {
  late AppLocalizations _locale;
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDateHere = TextEditingController();
  String selectedPeriod = "";
  String selectedFromAccount = "";
  String selectedToAccount = "";
  String selectedFromCode = "";
  String selectedToCode = "";
  String selectedVocherType = "";
  String selectedStatus = "";
  // int selectedIntStatus = 0;
  List<String> status = [];
  List<String> periods = [];
  double width = 0;
  bool isDesktop = false;
  final TextEditingController _textEditingController = TextEditingController();
  bool _showTable = false;
  String _selectedRow = '';
  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context);
    periods = [
      _locale.daily,
      _locale.weekly,
      _locale.monthly,
      _locale.yearly,
    ];
    status = [
      _locale.all,
      _locale.posted,
      _locale.draft,
      _locale.canceled,
    ];
    fromDate.text = DatesController().todayDate().toString();
    toDateHere.text = DatesController().todayDate().toString();
    selectedFromCode = "A";
    selectedToCode = "Z";
    selectedPeriod = periods[0];
    selectedStatus = status[0];
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width * 0.5;
    final screenHeight = MediaQuery.of(context).size.height * 0.6;
    isDesktop = Responsive.isDesktop(context);
    print("widget.accountsList!: ${widget.accountsList!.length}");
    return AlertDialog(
      content: SizedBox(
          width: screenWidth,
          height: screenHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: screenWidth / 8,
                    height: screenHeight * 0.15,
                  ),
                  SizedBox(
                    width: screenWidth / 3,
                    height: screenHeight * 0.15,
                    child: Center(
                        child: Text(
                      _locale.journalReports,
                      style: TextStyle(
                        fontSize: screenWidth * 0.025,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
                  ),
                  SizedBox(
                    width: screenWidth / 8,
                    height: screenHeight * 0.15,
                    child: Center(
                      child: Image.asset(
                        "assets/images/BG.png",
                        scale: 1,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: screenHeight / 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: screenWidth / 2.2,
                          height: screenHeight * 0.1,
                          child: Row(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                width: (screenWidth / 2.2) / 4.8,
                                height: screenHeight * 0.1,
                                child: Text(
                                  _locale.period,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: screenWidth * 0.014),
                                ),
                              ),
                              SizedBox(
                                width: (screenWidth / 2.2) / 1.4,
                                height: screenHeight * 0.2,
                                child: CustomDropDown(
                                  label: "",
                                  items: periods,
                                  hint: _locale.select,
                                  onChanged: (value) {
                                    setState(() {
                                      checkPeriods(value);
                                      selectedPeriod = value!;
                                    });
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: screenWidth / 2.2,
                          height: screenHeight * 0.1,
                          child: Row(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                width: (screenWidth / 2.2) / 4.8,
                                height: screenHeight * 0.1,
                                child: Text(
                                  _locale.fromDate,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: screenWidth * 0.014),
                                ),
                              ),
                              SizedBox(
                                width: (screenWidth / 2.2) / 1.4,
                                height: screenHeight * 0.1,
                                child: CustomDate(
                                  label: "",
                                  dateController: fromDate,
                                  minYear: 2000,
                                  onValue: (isValid, value) {
                                    if (isValid) {
                                      // setState(() {
                                      //   _fromDateController.text = value;
                                      //   getDailySales();
                                      // });
                                    }
                                  },
                                ),
                              ),
                              // SizedBox(
                              //   width: (screenWidth / 2.2) / 1.4,
                              //   height: screenHeight * 0.1,
                              //   child: Center(
                              //     child: DateField(
                              //         controller: fromDate, isFromTrans: true),
                              //   ),
                              // )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: screenWidth / 2.2,
                          height: screenHeight * 0.1,
                          child: Row(
                            children: [
                              SizedBox(
                                width: (screenWidth / 2.2) / 4.8,
                                height: screenHeight * 0.1,
                                child: Center(
                                  child: Text(
                                    _locale.fromAccount,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: screenWidth * 0.014),
                                  ),
                                ),
                              ),
                              // SizedBox(
                              //   width: (screenWidth / 2.2) / 1.4,
                              //   height: screenHeight * 0.1,
                              //   child: TextField(
                              //     controller: _textEditingController,
                              //     onTap: () {
                              //       setState(() {
                              //         _showTable = !_showTable;
                              //       });
                              //     },
                              //   ),
                              // ),
                              // _showTable
                              //     ? Container(
                              //         color: Colors.red,
                              //         child: TableWidget(
                              //           columnNames: const [
                              //             'Check',
                              //             'Column A',
                              //             'Column B',
                              //             'Column C',
                              //             'Column D',
                              //           ],
                              //           rows: [
                              //             data_row.DataRow(
                              //               values: ['A1', 'B1', 'C1', 'D1'],
                              //               check: true,
                              //             ),
                              //             data_row.DataRow(
                              //               values: ['A2', 'B2', 'C2', 'D2'],
                              //               check: false,
                              //             ),
                              //             data_row.DataRow(
                              //               values: ['A3', 'B3', 'C3', 'D3'],
                              //               check: true,
                              //             ),
                              //             data_row.DataRow(
                              //               values: ['A4', 'B4', 'C4', 'D4'],
                              //               check: false,
                              //             ),
                              //           ],
                              //           onRowSelected: (selectedRow) {
                              //             setState(() {
                              //               _selectedRow = selectedRow;
                              //               _textEditingController.text =
                              //                   _selectedRow;
                              //               _showTable = false;
                              //             });
                              //           },
                              //         ),
                              //       )
                              //     : SizedBox.shrink(),
                              SizedBox(
                                width: (screenWidth / 2.2) / 1.4,
                                height: screenHeight * 0.2,
                                child: Center(
                                  child: CustomDropDown(
                                    items: widget.accountsList!,
                                    showSearchBox: true,
                                    hint: selectedFromAccount.isNotEmpty
                                        ? selectedFromAccount
                                        : _locale.select,
                                    label: "",
                                    width: isDesktop
                                        ? screenWidth *
                                            (screenWidth / 2.2) /
                                            1.4
                                        : screenWidth * .35,
                                    height: isDesktop
                                        ? screenHeight * 0.4
                                        : screenHeight * 0.35,
                                    onSearch: (text) {
                                      return onSearch(text);
                                    },
                                    onChanged: (value) {
                                      // selectedFromAccount = value.toString();
                                      selectedFromAccount =
                                          value.codeToString();
                                      print(
                                          "selectedFromAccount: ${selectedFromAccount}");
                                      // fetchData();
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: screenWidth / 2.2,
                          height: screenHeight * 0.1,
                          child: Row(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                width: (screenWidth / 2.2) / 4.8,
                                height: screenHeight * 0.1,
                                child: Text(
                                  _locale.fromCode,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: screenWidth * 0.014),
                                ),
                              ),
                              SizedBox(
                                width: (screenWidth / 2.2) / 1.4,
                                height: screenHeight * 0.1,
                                child: Center(
                                  child: CustomDropDown(
                                    label: '',
                                    items:
                                        characters, // Pass an empty list since dummy data is used internally
                                    onChanged: (selectedValue) {
                                      setState(() {
                                        selectedFromCode = selectedValue;

                                        print('Selected value: $selectedValue');
                                      });
                                    },
                                    hint: selectedFromCode.isEmpty
                                        ? _locale.select
                                        : selectedFromCode,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: screenWidth / 2.2,
                          height: screenHeight * 0.1,
                          child: Row(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                width: (screenWidth / 2.2) / 4.8,
                                height: screenHeight * 0.1,
                                child: Center(
                                  child: Text(
                                    _locale.voucherType,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: screenWidth * 0.014),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: (screenWidth / 2.2) / 1.4,
                                height: screenHeight * 0.1,
                                child: Center(
                                  child: CustomDropDown(
                                    label: "",
                                    items: [], // Pass an empty list since dummy data is used internally
                                    onChanged: (selectedValue) {
                                      setState(() {
                                        selectedVocherType = selectedValue;

                                        print('Selected value: $selectedValue');
                                      });
                                    },
                                    hint: selectedVocherType.isEmpty
                                        ? _locale.select
                                        : selectedVocherType,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: screenWidth / 2.2,
                          height: screenHeight * 0.1,
                        ),
                        SizedBox(
                          width: screenWidth / 2.2,
                          height: screenHeight * 0.1,
                          child: Row(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                width: (screenWidth / 2.2) / 5.8,
                                height: screenHeight * 0.1,
                                child: Text(
                                  _locale.toDate,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: screenWidth * 0.014),
                                ),
                              ),
                              SizedBox(
                                width: (screenWidth / 2.2) / 1.4,
                                height: screenHeight * 0.1,
                                child: CustomDate(
                                  dateController: toDateHere,
                                  minYear: 2000,
                                  onValue: (isValid, value) {
                                    if (isValid) {
                                      // setState(() {
                                      //   _fromDateController.text = value;
                                      //   getDailySales();
                                      // });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: screenWidth / 2.2,
                          height: screenHeight * 0.1,
                          child: Row(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                width: (screenWidth / 2.2) / 5.8,
                                height: screenHeight * 0.1,
                                child: Text(
                                  _locale.toAccount,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: screenWidth * 0.014),
                                ),
                              ),
                              SizedBox(
                                width: (screenWidth / 2.2) / 1.4,
                                height: screenHeight * 0.2,
                                child: Center(
                                  child: CustomDropDown(
                                    items: widget.accountsList!,
                                    showSearchBox: true,
                                    hint: selectedToAccount.isNotEmpty
                                        ? selectedToAccount
                                        : _locale.select,
                                    label: "",
                                    width: isDesktop
                                        ? screenWidth *
                                            (screenWidth / 2.2) /
                                            1.4
                                        : screenWidth * .35,
                                    height: isDesktop
                                        ? screenHeight * 0.4
                                        : screenHeight * 0.35,
                                    onSearch: (text) {
                                      return onSearch(text);
                                    },
                                    onChanged: (value) {
                                      // selectedFromAccount = value.toString();
                                      selectedToAccount = value.codeToString();
                                      print(
                                          "selectedToAccount: ${selectedToAccount}");
                                      // fetchData();
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: screenWidth / 2.2,
                          height: screenHeight * 0.1,
                          child: Row(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                width: (screenWidth / 2.2) / 5.8,
                                height: screenHeight * 0.1,
                                child: Text(
                                  _locale.toCode,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: screenWidth * 0.014),
                                ),
                              ),
                              SizedBox(
                                width: (screenWidth / 2.2) / 1.4,
                                height: screenHeight * 0.1,
                                child: Center(
                                  child: CustomDropDown(
                                    label: "",
                                    items: characters,
                                    onChanged: (selectedValue) {
                                      setState(() {
                                        selectedToCode = selectedValue;
                                        print('Selected value: $selectedValue');
                                      });
                                    },
                                    hint: selectedToCode.isEmpty
                                        ? _locale.select
                                        : selectedToCode,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: screenWidth / 2.2,
                          height: screenHeight * 0.1,
                          child: Row(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                width: (screenWidth / 2.2) / 5.8,
                                height: screenHeight * 0.1,
                                child: Text(
                                  _locale.status,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: screenWidth * 0.014),
                                ),
                              ),
                              SizedBox(
                                width: (screenWidth / 2.2) / 1.4,
                                height: screenHeight * 0.1,
                                child: Center(
                                  child: CustomDropDown(
                                    label: "",
                                    items: status,
                                    onChanged: (selectedValue) {
                                      setState(() {
                                        selectedStatus = selectedValue;

                                        print("status: ${status}");
                                      });
                                    },
                                    hint: selectedStatus.isEmpty
                                        ? status[0]
                                        : selectedStatus,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: greenStyle(
                      Size(screenWidth * 0.14, screenHeight * 0.1),
                      screenHeight * 0.02,
                    ),
                    onPressed: () {
                      widget.onFilter(
                          selectedPeriod,
                          fromDate.text,
                          toDateHere.text,
                          selectedFromAccount,
                          selectedToAccount,
                          selectedFromCode,
                          selectedToCode,
                          selectedVocherType,
                          selectedStatus);
                      Navigator.pop(context, true);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/check-mark.png',
                          width: 40,
                          height: 40,
                        ),
                        SizedBox(width: 8),
                        Text(
                          _locale.ok,
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.02),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  ElevatedButton(
                    style: blackStyle(
                      Size(screenWidth * 0.2, screenHeight * 0.1),
                      screenHeight * 0.02,
                    ),
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          'assets/images/add-to-favorites.png',
                          width: 28,
                          height: 28,
                        ),
                        SizedBox(width: 8),
                        Text(
                          _locale.addtoFav,
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.014),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  ElevatedButton(
                    style: cancelStyle(
                      Size(screenWidth * 0.14, screenHeight * 0.1),
                      screenHeight * 0.02,
                    ),
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/close.png',
                          width: 30,
                          height: 30,
                        ),
                        SizedBox(width: 8),
                        Text(
                          _locale.cancel,
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.02),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          )),
    );
  }

  void checkPeriods(value) {
    if (value == periods[0]) {
      fromDate.text = DatesController().todayDate().toString();
      toDateHere.text = DatesController().todayDate().toString();
    }
    if (value == periods[1]) {
      fromDate.text = DatesController().currentWeek().toString();
      toDateHere.text = DatesController().todayDate().toString();
    }
    if (value == periods[2]) {
      fromDate.text = DatesController().currentMonth().toString();
      toDateHere.text = DatesController().todayDate().toString();
    }
    if (value == periods[3]) {
      fromDate.text = DatesController().currentYear().toString();
      toDateHere.text = DatesController().todayDate().toString();
    }
  }

  Future<List<AccountModel>> onSearch(String query) async {
    List<AccountModel> searchResults = [];

    await Future.delayed(const Duration(seconds: 1));

    searchResults = widget.accountsList!
        .where((user) =>
            user.txtEnglishName!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return searchResults;
  }
}
