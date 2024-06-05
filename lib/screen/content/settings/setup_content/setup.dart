import 'package:bi_replicate/screen/content/settings/setup_content/setup_component/expenses_account_setup_widget.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/responsive.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  double height = 0;
  double width = 0;
  bool isDesktop = false;
  //  var utils = Components();
  final dropdownKey = GlobalKey<DropdownButton2State>();
  late AppLocalizations _locale;
  bool isFinised = false;
  // List<String> accountsNameList = [];
  // Map<String, dynamic>? accountToAdd;
  // List<BiAccountModel> cashboxAccounts = [];
  // List<BiAccountModel> expensesAccounts = [];
  // List<BiAccountModel> receivableAccounts = [];
  // List<BiAccountModel> bankAccounts = [];
  // List<BiAccountModel> payableAccounts = [];
  // List<AccountModel> accountModelList = [];
  var selectedPeriod = "";

  var selectedStatus = "";

  final List<double> listOfBalances = [
    100.0,
    150.0,
    120.0,
    200.0,
    180.0,
    250.0
  ];
  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context)!;

    super.didChangeDependencies();
  }

  @override
  void initState() {
    // getExpensesAccounts();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    isDesktop = Responsive.isDesktop(context);
    return DefaultTabController(
      length: 6,
      child: Container(
        margin: const EdgeInsets.only(left: 4, right: 3),
        child: SizedBox(
          // width: width * 0.7,
          child: Column(
            children: [
              isDesktop
                  ? Container(
                      color: primary,
                      height: height * 0.1,
                      child: TabBar(
                        // isScrollable: true,
                        labelStyle: TextStyle(
                          // color: Colors.white,

                          fontSize: isDesktop ? height * .016 : height * .008,
                        ),
                        // labelColor: Colors.black,
                        tabs: [
                          Tab(
                            icon: Icon(
                              Icons.account_balance,
                              color: const Color(0xffe7b84e).withOpacity(0.7),
                            ),
                            child: Text(
                              _locale.expensesAccounts,
                              style: TextStyle(color: Colors.white),
                            ), // Custom tab label
                          ),
                          Tab(
                            icon: Icon(
                              Icons.account_balance,
                              color: const Color(0xffe7b84e).withOpacity(0.7),
                            ),
                            // text: _locale.cachBoxAccounts, // Custom tab label
                            child: Text(
                              _locale.cachBoxAccounts,
                              style: TextStyle(color: Colors.white),
                            ), // C
                          ),
                          Tab(
                            icon: Icon(
                              Icons.account_balance,
                              color: const Color(0xffe7b84e).withOpacity(0.7),
                            ),
                            child: Text(
                              _locale.receivableAccounts,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Tab(
                            icon: Icon(
                              Icons.account_balance,
                              color: const Color(0xffe7b84e).withOpacity(0.7),
                            ),
                            child: Text(
                              _locale.payableAccounts,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Tab(
                            icon: Icon(
                              Icons.account_balance,
                              color: const Color(0xffe7b84e).withOpacity(0.7),
                            ),
                            child: Text(
                              _locale.bankAccounts,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Tab(
                            icon: Icon(
                              Icons.account_balance,
                              color: const Color(0xffe7b84e).withOpacity(0.7),
                            ),
                            child: Text(
                              _locale.dailySalesCount,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],

                        // onTap: (int index) {
                        //   switch (index) {
                        //     case 0:
                        //       getExpensesAccounts();
                        //       // Handle the first tab press
                        //       break;
                        //     case 1:
                        //       getCashBoxAccount();
                        //       // Handle the second tab press
                        //       break;
                        //     case 2:
                        //       getReceivableAccounts();
                        //       break;
                        //     case 3:
                        //       getPayableAccounts();

                        //       break;
                        //     case 4:
                        //       getBankAccounts();
                        //       break;

                        //     // Add cases for other tabs as needed
                        //   }
                        // },
                      ),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        width: width * 1.5,
                        color: primary,
                        height: height * 0.1,
                        child: TabBar(
                          // isScrollable: true,
                          labelStyle: TextStyle(
                            fontSize: isDesktop ? height * .016 : height * .012,
                          ),
                          // labelColor: Colors.black,
                          tabs: [
                            Tab(
                              icon: Icon(
                                Icons.account_balance,
                                color: const Color(0xffe7b84e).withOpacity(0.7),
                              ),
                              text:
                                  _locale.expensesAccounts, // Custom tab label
                            ),
                            Tab(
                              icon: Icon(
                                Icons.account_balance,
                                color: const Color(0xffe7b84e).withOpacity(0.7),
                              ),
                              text: _locale.cachBoxAccounts, // Custom tab label
                            ),
                            Tab(
                              icon: Icon(
                                Icons.account_balance,
                                color: const Color(0xffe7b84e).withOpacity(0.7),
                              ),
                              text: _locale
                                  .receivableAccounts, // Custom tab label
                            ),
                            Tab(
                              icon: Icon(
                                Icons.account_balance,
                                color: const Color(0xffe7b84e).withOpacity(0.7),
                              ),
                              text: _locale.payableAccounts, // Custom tab label
                            ),
                            Tab(
                              icon: Icon(
                                Icons.account_balance,
                                color: const Color(0xffe7b84e).withOpacity(0.7),
                              ),
                              text: _locale.bankAccounts, // Custom tab label
                            ),
                            Tab(
                              icon: Icon(
                                Icons.account_balance,
                                color: const Color(0xffe7b84e).withOpacity(0.7),
                              ),
                              text: _locale.dailySalesCount, // Custom tab label
                            ),
                          ],

                          // onTap: (int index) {
                          //   switch (index) {
                          //     case 0:
                          //       getExpensesAccounts();
                          //       // Handle the first tab press
                          //       break;
                          //     case 1:
                          //       getCashBoxAccount();
                          //       // Handle the second tab press
                          //       break;
                          //     case 2:
                          //       getReceivableAccounts();
                          //       break;
                          //     case 3:
                          //       getPayableAccounts();

                          //       break;
                          //     case 4:
                          //       getBankAccounts();
                          //       break;

                          //     // Add cases for other tabs as needed
                          //   }
                          // },
                        ),
                      ),
                    ),
              SizedBox(
                height: height * 0.85,
                child: TabBarView(
                  children: [
                    ExpensesAccountSetupWidget(
                      // list: expensesAccounts,
                      // dropDownData: accountsNameList,
                      // setState: _setState,
                      // addAccount: addAccount,
                      type: 1,
                    ),

                    ExpensesAccountSetupWidget(
                        // list: cashboxAccounts,
                        // dropDownData: accountsNameList,
                        // setState: _setState,
                        // addAccount: addAccount,
                        type: 2),
                    ExpensesAccountSetupWidget(
                      // list: receivableAccounts,
                      // dropDownData: accountsNameList,
                      // setState: _setState,
                      // addAccount: addAccount,
                      type: 3,
                    ),
                    ExpensesAccountSetupWidget(
                      // list: payableAccounts,
                      // dropDownData: accountsNameList,
                      // setState: _setState,
                      // addAccount: addAccount,
                      type: 4,
                    ),
                    ExpensesAccountSetupWidget(
                      // list: bankAccounts,
                      // dropDownData: accountsNameList,
                      // setState: _setState,
                      // addAccount: addAccount,
                      type: 5,
                    ),
                    ExpensesAccountSetupWidget(
                      // list: bankAccounts,
                      // dropDownData: accountsNameList,
                      // setState: _setState,
                      // addAccount: addAccount,
                      type: 6,
                    )

                    // Add your custom icons and content here
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Future getExpensesAccounts() async {
  //   setState(() {
  //     isFinised = false;
  //     expensesAccounts = [];
  //   });
  //   await SetupController().getBiAccounts().then((value) {
  //     for (var elemant in value) {
  //       if (elemant.accountType == 1) {
  //         expensesAccounts.add(elemant);
  //       }
  //     }
  //   });
  //   isFinised = true;
  //   print("isFinished $isFinised");
  //   setState(() {});
  // }

  // Future getAccountList() async {
  //   accountsNameList = [];
  //   accountToAdd = <String, dynamic>{};
  //   await SetupController().getAllAccounts().then((value) {
  //     accountModelList = value;

  //     for (var elemant in value) {
  //       accountsNameList.add(elemant.txtEnglishName!);
  //     }
  //     for (int i = 0; i < accountModelList.length; i++) {
  //       accountToAdd![accountModelList[i].txtEnglishName!] =
  //           accountModelList[i].txtCode;
  //     }
  //   });

  //   setState(() {});
  // }

  // Future getCashBoxAccount() async {
  //   cashboxAccounts = [];

  //   await SetupController().getBiAccounts().then((value) {
  //     for (var elemant in value) {
  //       if (elemant.accountType == 2) {
  //         cashboxAccounts.add(elemant);
  //       }
  //     }
  //   });
  //   setState(() {});
  // }

  // Future getReceivableAccounts() async {
  //   receivableAccounts = [];

  //   await SetupController().getBiAccounts().then((value) {
  //     for (var elemant in value) {
  //       if (elemant.accountType == 3) {
  //         receivableAccounts.add(elemant);
  //       }
  //     }
  //   });
  //   setState(() {});
  // }

  // Future getPayableAccounts() async {
  //   payableAccounts = [];

  //   await SetupController().getBiAccounts().then((value) {
  //     for (var elemant in value) {
  //       if (elemant.accountType == 4) {
  //         payableAccounts.add(elemant);
  //       }
  //     }
  //   });
  //   setState(() {});
  // }

  // Future getBankAccounts() async {
  //   bankAccounts = [];

  //   await SetupController().getBiAccounts().then((value) {
  //     for (var elemant in value) {
  //       if (elemant.accountType == 5) {
  //         bankAccounts.add(elemant);
  //       }
  //     }
  //   });
  //   setState(() {});
  // }

  // addAccount(String name, int id) {
  //   BiAccountModel account = BiAccountModel(
  //       account: accountToAdd![name], accountType: id, accountName: name);
  //   isFinised = false;

  //   SetupController().addBiAccount(account).then((value) {
  //     if (id == 1) {
  //       getExpensesAccounts().then((value) {
  //         getAccountList().then((value) {
  //           isFinised = true;
  //         });
  //       });
  //     } else if (id == 2) {
  //       getCashBoxAccount().then((value) {
  //         getAccountList().then((value) {
  //           isFinised = true;
  //         });
  //       });
  //     } else if (id == 3) {
  //       getReceivableAccounts().then((value) {
  //         getAccountList().then((value) {
  //           isFinised = true;
  //         });
  //       });
  //     } else if (id == 4) {
  //       getPayableAccounts().then((value) {
  //         getAccountList().then((value) {
  //           isFinised = true;
  //         });
  //       });
  //     } else if (id == 5) {
  //       getBankAccounts().then((value) {
  //         getAccountList().then((value) {
  //           isFinised = true;
  //         });
  //       });
  //     }
  //   });
  //   setState(() {});
  // }

  // showLoading(BuildContext context) {
  //   showDialog(
  //       barrierDismissible: false,
  //       context: context,
  //       builder: (context) {
  //         return Center(
  //             child: Lottie.asset("assets/images/inventory_loading.json",
  //                 width: 250, height: 250));
  //       });
  // }

  // void _setState(value) {
  //   isFinised = false;
  //   if (value == 1) {
  //     getExpensesAccounts().then((value) {
  //       getAccountList().then((value) {
  //         isFinised = true;
  //       });
  //     });
  //   } else if (value == 2) {
  //     getCashBoxAccount().then((value) {
  //       getAccountList().then((value) {
  //         isFinised = true;
  //       });
  //     });
  //   } else if (value == 3) {
  //     getReceivableAccounts().then((value) {
  //       getAccountList().then((value) {
  //         isFinised = true;
  //       });
  //     });
  //   } else if (value == 4) {
  //     getPayableAccounts().then((value) {
  //       getAccountList().then((value) {
  //         isFinised = true;
  //       });
  //     });
  //   } else if (value == 5) {
  //     getBankAccounts().then((value) {
  //       getAccountList().then((value) {
  //         isFinised = true;
  //       });
  //     });
  //   }
  //   setState(() {});
  // }
}
