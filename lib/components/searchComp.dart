import 'package:bi_replicate/model/settings/setup/account_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../utils/constants/colors.dart';
import '../utils/constants/constants.dart';
import '../utils/constants/maps.dart';
import '../utils/constants/responsive.dart';
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
  double width = 0;
  bool isDesktop = false;

  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context);
    status = [
      _locale.all,
      _locale.posted,
      _locale.draft,
      _locale.canceled,
    ];
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
                      "Journal Report",
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
                                  "Period :",
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
                                  items: [],
                                  initialValue: "Select Period",
                                  onChanged: (value) {
                                    print(value);
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
                                    "From Account:",
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
                                  "From Code:",
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
                                    hint: 'A',
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
                                    "Voucher Type:",
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
                                    hint: 'All',
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
                              // SizedBox(
                              //   width: (screenWidth / 2.2) / 1.4,
                              //   height: screenHeight * 0.1,
                              //   child: Center(
                              //     child: DateField(
                              //         controller: toDateHere,
                              //         isFromTrans: true),
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
                                  "To Account:",
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
                                  "To JCode:",
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
                                    items:
                                        characters, // Pass an empty list since dummy data is used internally
                                    onChanged: (selectedValue) {
                                      setState(() {
                                        selectedToCode = selectedValue;
                                        print('Selected value: $selectedValue');
                                      });
                                    },
                                    hint: 'Z',
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
                                  "Status:",
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
                                    items:
                                        status, // Pass an empty list since dummy data is used internally
                                    onChanged: (selectedValue) {
                                      setState(() {
                                        selectedStatus = selectedValue;

                                        print("status: ${status}");
                                      });
                                    },
                                    hint: 'ALL(DRAFT, POSTED)',
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
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Your image widget goes here
                        Image.asset(
                          'assets/images/check-mark.png',
                          width: 40, // Adjust the width as needed
                          height: 40, // Adjust the height as needed
                        ),

                        SizedBox(
                            width:
                                8), // Add some space between the image and text

                        // Your text widget goes here
                        Text(
                          "OK",
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
                        // Your image widget goes here
                        Image.asset(
                          'assets/images/add-to-favorites.png',
                          width: 28, // Adjust the width as needed
                          height: 28, // Adjust the height as needed
                        ),

                        SizedBox(
                            width:
                                8), // Add some space between the image and text

                        // Your text widget goes here
                        Text(
                          "Add To Favorite",
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
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Your image widget goes here
                        Image.asset(
                          'assets/images/close.png',
                          width: 30, // Adjust the width as needed
                          height: 30, // Adjust the height as needed
                        ),

                        SizedBox(
                            width:
                                8), // Add some space between the image and text

                        // Your text widget goes here
                        Text(
                          "Cancel",
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

  Future<List<AccountModel>> onSearch(String query) async {
    List<AccountModel> searchResults = [];

    // Replace the following logic with your actual data fetching or search logic
    await Future.delayed(const Duration(seconds: 1)); // Simulating a delay

    searchResults = widget.accountsList!
        .where((user) =>
            user.txtEnglishName!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return searchResults;
  }
}
