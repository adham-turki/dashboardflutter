import 'package:bi_replicate/components/table_component.dart';
import 'package:bi_replicate/controller/settings/setup/setup_screen_controller.dart';
import 'package:bi_replicate/dialogs/confirm_dialog.dart';
import 'package:bi_replicate/model/settings/setup/account_model.dart';
import 'package:bi_replicate/model/settings/setup/bi_account_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:http/http.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../../utils/constants/responsive.dart';
import 'expenses_account_dropdown_setup_widget.dart';

class ExpensesAccountSetupWidget extends StatefulWidget {
  int? type;
  ExpensesAccountSetupWidget({Key? key, this.type}) : super(key: key);

  @override
  State<ExpensesAccountSetupWidget> createState() =>
      _ExpensesAccountSetupWidgetState();
}

class _ExpensesAccountSetupWidgetState
    extends State<ExpensesAccountSetupWidget> {
  final ScrollController _scrollController = ScrollController();
  List<String>? coloumn;

  late AppLocalizations _locale;
  List<BiAccountModel> cashboxAccounts = [];
  List<BiAccountModel> expensesAccounts = [];
  List<BiAccountModel> receivableAccounts = [];
  List<BiAccountModel> bankAccounts = [];
  List<BiAccountModel> payableAccounts = [];
  List<BiAccountModel> dailySalesCount = [];
  List<BiAccountModel> tempList = [];
  List<String> accountsNameList = [];
  Map<String, dynamic>? accountToAdd;
  List<AccountModel> accountModelList = [];

  bool isFinised = false;

  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context);
    coloumn = [
      "#",
      _locale.accountCode,
      _locale.accountName,
      _locale.delete,
    ];
    getAccountList().then((value) {
      setState(() {});
    });
    switch (widget.type) {
      case 1:
        getExpensesAccounts();
        // Handle the first tab press
        break;
      case 2:
        getCashBoxAccount();
        // Handle the second tab press
        break;
      case 3:
        getReceivableAccounts();
        break;
      case 4:
        getPayableAccounts();

        break;
      case 5:
        getBankAccounts();
        break;
      case 6:
        getDailySalesCount();
        break;
      // Add cases for other tabs as needed
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);

    super.initState();
  }

  @override
  void dispose() {
    // Dispose of the ScrollController to prevent memory leaks
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {}
  }

  double width = 0;
  double height = 0;
  BiAccountModel? biAccModel;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    // double columnNameHeight = 50.0; // Adjust the column name height as needed

    return Stack(
      children: [
        SingleChildScrollView(
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ExpensesAccountDropDown(
                    accountsName: accountsNameList,
                    addAccount: addAccount,
                    type: widget.type,
                  ),
                  SizedBox(
                    height: height * .05,
                  ),
                  SizedBox(
                    width: Responsive.isDesktop(context)
                        ? width * 0.35
                        : width * 0.9,
                    height: height * 0.6,
                    child: isFinised
                        ? TableComponent(
                            key: UniqueKey(),
                            plCols: BiAccountModel.getColumns(
                                context, AppLocalizations.of(context)),
                            polRows: getRows(),
                            footerBuilder:
                                (PlutoGridStateManager stateManager) {
                              return tableFooter();
                            },
                            onSelected: (event) {
                              PlutoRow row = event.row!;
                              biAccModel =
                                  BiAccountModel.fromJson(row.toJson());
                            },
                          )
                        : const Center(
                            child: CupertinoActivityIndicator(
                              radius: 40,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void deleteMethod() {
    BiAccountModel biAccountModel = biAccModel ?? tempList[0];
    showDialog(
        context: context,
        builder: (context) {
          return CustomConfirmDialog(
            confirmMessage: AppLocalizations.of(context).areYouSure,
          );
        }).then((value) {
      if (value) {
        SetupController().deleteBiAccount(biAccountModel).then((value1) {
          if (!value1) {
            _setState(widget.type);
          }
        }).then((value) {});
      }
    });
  }

  Widget tableFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            onPressed: () {
              deleteMethod();
            },
            icon: const Icon(Icons.delete)),
      ],
    );
  }

  List<PlutoRow> getRows() {
    List<BiAccountModel> accountList = tempList;

    List<PlutoRow> topList = [];

    for (int i = 0; i < accountList.length; i++) {
      topList.add(accountList[i].toPluto(i + 1));
    }

    return topList;
  }

  PlutoLazyPagination lazyPaginationFooter(PlutoGridStateManager stateManager) {
    return PlutoLazyPagination(
      initialPage: 1,
      initialFetch: true,
      pageSizeToMove: 1,
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
    List<BiAccountModel> accountList = tempList;

    List<PlutoRow> topList = [];

    for (int i = 0; i < accountList.length; i++) {
      topList.add(accountList[i].toPluto(i + 1));
    }

    return PlutoLazyPaginationResponse(
      totalPage: 1,
      rows: topList,
    );
  }

  Future getExpensesAccounts() async {
    setState(() {
      isFinised = false;
      expensesAccounts = [];
    });
    await SetupController().getBiAccounts().then((value) {
      for (var elemant in value) {
        if (elemant.accountType == 1) {
          expensesAccounts.add(elemant);
        }
      }
    });
    isFinised = true;
    tempList = expensesAccounts;
    setState(() {});
  }

  Future getCashBoxAccount() async {
    setState(() {
      isFinised = false;
      cashboxAccounts = [];
    });
    await SetupController().getBiAccounts().then((value) {
      for (var elemant in value) {
        if (elemant.accountType == 2) {
          cashboxAccounts.add(elemant);
        }
      }
    });
    isFinised = true;

    tempList = cashboxAccounts;
    setState(() {});
  }

  Future getReceivableAccounts() async {
    setState(() {
      isFinised = false;
      receivableAccounts = [];
    });
    await SetupController().getBiAccounts().then((value) {
      for (var elemant in value) {
        if (elemant.accountType == 3) {
          receivableAccounts.add(elemant);
        }
      }
    });
    isFinised = true;

    tempList = receivableAccounts;
    setState(() {});
  }

  Future getPayableAccounts() async {
    setState(() {
      isFinised = false;
      payableAccounts = [];
    });
    await SetupController().getBiAccounts().then((value) {
      for (var elemant in value) {
        if (elemant.accountType == 4) {
          payableAccounts.add(elemant);
        }
      }
    });
    isFinised = true;

    tempList = payableAccounts;

    setState(() {});
  }

  Future getBankAccounts() async {
    setState(() {
      isFinised = false;
      bankAccounts = [];
    });
    await SetupController().getBiAccounts().then((value) {
      for (var elemant in value) {
        if (elemant.accountType == 5) {
          bankAccounts.add(elemant);
        }
      }
    });
    isFinised = true;

    tempList = bankAccounts;
    setState(() {});
  }

  Future getDailySalesCount() async {
    setState(() {
      isFinised = false;
      dailySalesCount = [];
    });
    await SetupController().getBiAccounts().then((value) {
      for (var elemant in value) {
        if (elemant.accountType == 6) {
          dailySalesCount.add(elemant);
        }
      }
    });
    isFinised = true;

    tempList = dailySalesCount;
    setState(() {});
  }

  void _setState(value) {
    isFinised = false;
    if (value == 1) {
      getExpensesAccounts().then((value) {
        getAccountList().then((value) {
          isFinised = true;
        });
      });
    } else if (value == 2) {
      getCashBoxAccount().then((value) {
        getAccountList().then((value) {
          isFinised = true;
        });
      });
    } else if (value == 3) {
      getReceivableAccounts().then((value) {
        getAccountList().then((value) {
          isFinised = true;
        });
      });
    } else if (value == 4) {
      getPayableAccounts().then((value) {
        getAccountList().then((value) {
          isFinised = true;
        });
      });
    } else if (value == 5) {
      getBankAccounts().then((value) {
        getAccountList().then((value) {
          isFinised = true;
        });
      });
    } else if (value == 6) {
      getDailySalesCount().then((value) {
        getAccountList().then((value) {
          isFinised = true;
        });
      });
    }
    setState(() {});
  }

  void addAccount(String name, int id) {
    BiAccountModel account = BiAccountModel(
        account: accountToAdd![name], accountType: id, accountName: name);
    isFinised = false;

    SetupController().addBiAccount(account).then((value) {
      _setState(widget.type);
    });
  }

  Future getAccountList() async {
    accountsNameList = [];
    accountToAdd = <String, dynamic>{};
    await SetupController().getAllAccounts().then((value) {
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
