import 'package:bi_replicate/components/search_table/table_widget.dart';
import 'package:bi_replicate/controller/vouch_type_controller.dart';
import 'package:bi_replicate/model/settings/setup/account_model.dart';
import 'package:bi_replicate/provider/local_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:bi_replicate/components/search_table/data_row.dart' as data_row;
import 'package:pluto_grid/pluto_grid.dart';

import '../model/vouch_type_model.dart';
import '../utils/constants/colors.dart';
import '../utils/constants/constants.dart';
import '../utils/constants/maps.dart';
import '../utils/constants/responsive.dart';
import '../utils/func/dates_controller.dart';
import '../widget/drop_down/custom_dropdown.dart';
import '../widget/text_field_custom.dart';
import 'custom_date.dart';
import 'date_text_field.dart';
import 'filter_button.dart';
import 'my_image_button.dart';

class SearchComponent extends StatefulWidget {
  final List<AccountModel>? accountsList;
  final List<VouchTypeModel>? voucherTypeList;
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
  SearchComponent(
      {super.key,
      required this.onFilter,
      this.accountsList,
      this.voucherTypeList});

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
  int _counter = 0;
  late Offset position;

  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _textEditingController2 = TextEditingController();
  String _selectedRow = '';
  TextEditingController searchController = TextEditingController();
  bool showTable = false;
  bool showTable2 = false;
  bool isDesktop = false;
  bool _showTable = false;
  List<AccountModel> accounts = [];
  List<AccountModel> accounts1 = [];
  @override
  void initState() {
    position = const Offset(300, 300);
    accounts = widget.accountsList!;
    accounts1 = widget.accountsList!;

    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    VouchTypeController().getAllVouchTypes().then((value) {
      print("value.length: ${value.length}");
    });
    _locale = AppLocalizations.of(context);
    print("_locale.localeName: ${_locale.localeName}");
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
          child: Stack(
            children: [
              SizedBox(
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
                                        "${_locale.fromDate}*",
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
                                            setState(() {
                                              fromDate.text = value;
                                              // getDailySales();
                                            });
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
                                  mainAxisAlignment: MainAxisAlignment.start,
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

                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: (screenWidth / 2.2) / 1.44,
                                          // padding: const EdgeInsets.only(
                                          //     left: 15, right: 15, bottom: 15),
                                          child: TextField(
                                            decoration: InputDecoration(
                                              border:
                                                  OutlineInputBorder(), // Adding border here
                                              hintText: 'Search',
                                              // You can add more styling options here as needed
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                filteredList(value);
                                              });
                                            },
                                            controller: _textEditingController,
                                            onTap: () {
                                              setState(() {
                                                showTable = !showTable;
                                                if (showTable2) {
                                                  showTable2 = !showTable2;
                                                }
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),

                                    // SizedBox(
                                    //   width: (screenWidth / 2.2) / 1.4,
                                    //   height: screenHeight * 0.2,
                                    //   child: Center(
                                    //     child: CustomDropDown(
                                    //       items: widget.accountsList!,
                                    //       showSearchBox: true,
                                    //       hint: selectedFromAccount.isNotEmpty
                                    //           ? selectedFromAccount
                                    //           : _locale.select,
                                    //       label: "",
                                    //       width: isDesktop
                                    //           ? screenWidth *
                                    //               (screenWidth / 2.2) /
                                    //               1.4
                                    //           : screenWidth * .35,
                                    //       height: isDesktop
                                    //           ? screenHeight * 0.4
                                    //           : screenHeight * 0.35,
                                    //       onSearch: (text) {
                                    //         return onSearch(text);
                                    //       },
                                    //       onChanged: (value) {
                                    //         // selectedFromAccount = value.toString();
                                    //         selectedFromAccount =
                                    //             value.codeToString();
                                    //         print(
                                    //             "selectedFromAccount: ${selectedFromAccount}");
                                    //         // fetchData();
                                    //       },
                                    //     ),
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

                                              print(
                                                  'Selected value: $selectedValue');
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
                                      height: screenHeight * 0.2,
                                      child: Center(
                                        child: CustomDropDown(
                                          items: widget.voucherTypeList!,
                                          showSearchBox: true,
                                          hint: selectedVocherType.isNotEmpty
                                              ? selectedVocherType
                                              : _locale.all,
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
                                            return onSearchVouch(text);
                                          },
                                          onChanged: (value) {
                                            // selectedFromAccount = value.toString();
                                            selectedVocherType =
                                                value.codeToString();
                                            print(
                                                "selectedVocherType: ${selectedVocherType}");
                                            // fetchData();
                                          },
                                        ),
                                      ),
                                    )
                                    // SizedBox(
                                    //   width: (screenWidth / 2.2) / 1.4,
                                    //   height: screenHeight * 0.1,
                                    //   child: Center(
                                    //     child: CustomDropDown(
                                    //       label: "",
                                    //       items: [], // Pass an empty list since dummy data is used internally
                                    //       onChanged: (selectedValue) {
                                    //         setState(() {
                                    //           selectedVocherType = selectedValue;

                                    //           print('Selected value: $selectedValue');
                                    //         });
                                    //       },
                                    //       hint: selectedVocherType.isEmpty
                                    //           ? _locale.select
                                    //           : selectedVocherType,
                                    //     ),
                                    //   ),
                                    // )
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
                                        "${_locale.toDate}*",
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
                                            setState(() {
                                              toDateHere.text = value;
                                              // getDailySales();
                                            });
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
                                  mainAxisAlignment: MainAxisAlignment.start,
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
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: (screenWidth / 2.2) /
                                              1.44, // padding: const EdgeInsets.only(
                                          //     left: 15, right: 15, bottom: 15),
                                          child: TextField(
                                            decoration: const InputDecoration(
                                              border:
                                                  OutlineInputBorder(), // Adding border here
                                              hintText: 'Search',
                                              // You can add more styling options here as needed
                                            ),
                                            controller: _textEditingController2,
                                            onChanged: (value) {
                                              setState(() {
                                                filteredList1(value);
                                              });
                                            },
                                            onTap: () {
                                              setState(() {
                                                showTable2 = !showTable2;
                                                if (showTable) {
                                                  showTable = !showTable;
                                                }
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    // SizedBox(
                                    //   width: (screenWidth / 2.2) / 1.4,
                                    //   height: screenHeight * 0.2,
                                    //   child: Center(
                                    //     child: CustomDropDown(
                                    //       items: widget.accountsList!,
                                    //       showSearchBox: true,
                                    //       hint: selectedToAccount.isNotEmpty
                                    //           ? selectedToAccount
                                    //           : _locale.select,
                                    //       label: "",
                                    //       width: isDesktop
                                    //           ? screenWidth *
                                    //               (screenWidth / 2.2) /
                                    //               1.4
                                    //           : screenWidth * .35,
                                    //       height: isDesktop
                                    //           ? screenHeight * 0.4
                                    //           : screenHeight * 0.35,
                                    //       onSearch: (text) {
                                    //         return onSearch(text);
                                    //       },
                                    //       onChanged: (value) {
                                    //         // selectedFromAccount = value.toString();
                                    //         selectedToAccount =
                                    //             value.codeToString();
                                    //         print(
                                    //             "selectedToAccount: ${selectedToAccount}");
                                    //         // fetchData();
                                    //       },
                                    //     ),
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
                                              print(
                                                  'Selected value: $selectedValue');
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
                                        MediaQuery.of(context).size.height *
                                            0.02),
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
                                        MediaQuery.of(context).size.height *
                                            0.014),
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
                                        MediaQuery.of(context).size.height *
                                            0.02),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Positioned(
                left: _locale.localeName == "ar"
                    ? position.dx + 150
                    : position.dx - 200,
                top: position.dy - 20,
                child: Visibility(
                  visible: showTable,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      setState(() {
                        position += details.delta;
                      });
                    },
                    child: _showTableWidget(context),
                  ),
                ),
              ),
              Positioned(
                left: _locale.localeName == "ar"
                    ? position.dx - 200
                    : position.dx + 150,
                top: position.dy - 20,
                child: Visibility(
                  visible: showTable2,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      setState(() {
                        position += details.delta;
                      });
                    },
                    child: _showTableWidget2(context),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  _showTableWidget(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.22,
      height: MediaQuery.of(context).size.height * 0.25,
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TableWidget(
            columnNames: [
              _locale.code,
              _locale.name,
            ],
            rows: [
              for (int i = 0; i < accounts.length; i++)
                data_row.DataRow(
                  values: [
                    accounts[i].txtCode!,
                    accounts[i].txtEnglishName!,
                  ],
                ),
            ],
            onRowSelected: (value1, value2) {
              setState(() {
                selectedFromAccount = value1;
                print(value1);
                print(value2);
                _textEditingController.text = value2;
                showTable = !showTable;
              });
            },
          ),
        ],
      ),
    );
  }

  filteredList(String query) {
    accounts = widget.accountsList!;
    accounts = accounts.where((account) {
      return (account.txtCode != null &&
              account.txtCode!.toLowerCase().contains(query.toLowerCase())) ||
          (account.txtEnglishName != null &&
              account.txtEnglishName!
                  .toLowerCase()
                  .contains(query.toLowerCase()));
    }).toList();
    print("accountsList.length: ${accounts.length}");
  }

  filteredList1(String query) {
    accounts1 = widget.accountsList!;
    accounts1 = accounts1.where((account) {
      return (account.txtCode != null &&
              account.txtCode!.toLowerCase().contains(query.toLowerCase())) ||
          (account.txtEnglishName != null &&
              account.txtEnglishName!
                  .toLowerCase()
                  .contains(query.toLowerCase()));
    }).toList();
    print("accountsList.length: ${accounts1.length}");
  }

  _showTableWidget2(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.22,
      height: MediaQuery.of(context).size.height * 0.25,
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TableWidget(
            columnNames: [
              _locale.code,
              _locale.name,
            ],
            rows: [
              for (int i = 0; i < accounts1.length; i++)
                data_row.DataRow(
                  values: [
                    accounts1[i].txtCode!,
                    accounts1[i].txtEnglishName!,
                  ],
                ),
            ],
            onRowSelected: (value1, value2) {
              setState(() {
                selectedToAccount = value1;
                print(value1);
                print(value2);
                _textEditingController2.text = value2;
                showTable2 = !showTable2;
              });
            },
          ),
        ],
      ),
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

    searchResults = accounts
        .where((user) =>
            user.txtEnglishName!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return searchResults;
  }

  Future<List<VouchTypeModel>> onSearchVouch(String query) async {
    List<VouchTypeModel> searchResults = [];

    await Future.delayed(const Duration(seconds: 1));

    searchResults = widget.voucherTypeList!
        .where((user) =>
            user.txtEnglishname.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return searchResults;
  }
}
