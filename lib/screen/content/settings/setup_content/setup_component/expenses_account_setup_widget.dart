import 'package:bi_replicate/components/table_component.dart';
import 'package:bi_replicate/controller/settings/setup/setup_screen_controller.dart';
import 'package:bi_replicate/dialogs/confirm_dialog.dart';
import 'package:bi_replicate/model/settings/setup/bi_account_model.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'expenses_account_dropdown_setup_widget.dart';

class ExpensesAccountSetupWidget extends StatefulWidget {
  List<BiAccountModel> list;
  final void Function(int)? setState;
  final void Function(String, int) addAccount;
  List<String> dropDownData;
  int? type;
  ExpensesAccountSetupWidget(
      {Key? key,
      required this.list,
      required this.setState,
      required this.dropDownData,
      required this.addAccount,
      this.type})
      : super(key: key);

  @override
  State<ExpensesAccountSetupWidget> createState() =>
      _ExpensesAccountSetupWidgetState();
}

class _ExpensesAccountSetupWidgetState
    extends State<ExpensesAccountSetupWidget> {
  ScrollController _scrollController = ScrollController();
  List<String>? coloumn;

  late AppLocalizations _locale;
  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context);
    coloumn = [
      "#",
      _locale.accountCode,
      _locale.accountName,
      _locale.delete,
    ];
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);

    // TODO: implement initState
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
        _scrollController.position.maxScrollExtent) {
      // You have reached the end of the list, load more data here if available
      // For example, you can load the next batch of data and update the widget's state
      // setState(() {
      //   // Update the itemCount to display more rows (e.g., additional 10 rows)
      // });
    }
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
                    accountsName: widget.dropDownData,
                    addAccount: widget.addAccount,
                    type: widget.type,
                  ),
                  SizedBox(
                    height: height * .05,
                  ),
                  SizedBox(
                    width: width * 0.35,
                    height: height * 0.7,
                    child: TableComponent(
                      key: UniqueKey(),
                      plCols: BiAccountModel.getColumns(
                          context, AppLocalizations.of(context)),
                      polRows: getRows(),
                      footerBuilder: (PlutoGridStateManager stateManager) {
                        return tableFooter();
                      },
                      onSelected: (event) {
                        PlutoRow row = event.row!;
                        biAccModel = BiAccountModel.fromJson(row.toJson());
                      },
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
    BiAccountModel biAccountModel = biAccModel ?? widget.list[0];
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
            widget.setState!(biAccountModel.accountType!);
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
    List<BiAccountModel> accountList = widget.list;

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
    List<BiAccountModel> accountList = widget.list;

    List<PlutoRow> topList = [];

    for (int i = 0; i < accountList.length; i++) {
      topList.add(accountList[i].toPluto(i + 1));
    }

    print("topList :${topList.length}");
    return PlutoLazyPaginationResponse(
      totalPage: 1,
      rows: topList,
    );
  }
}
