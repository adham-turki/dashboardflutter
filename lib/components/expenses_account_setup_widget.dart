import 'dart:math';

import 'package:bi_replicate/components/table_component.dart';
import 'package:bi_replicate/model/settings/setup/account_model.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../model/cheques_bank/cheques_model.dart';
import '../model/settings/setup/bi_account_model.dart';
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
              margin: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ExpensesAccountDropDown(
                    accountsName: widget.dropDownData,
                    addAccount: widget.addAccount,
                    type: widget.type,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    height: 1,
                  ),
                  SizedBox(
                    width: width * 0.39,
                    height: height * 0.7,
                    child: TableComponent(
                      key: UniqueKey(),
                      plCols: AccountModel.getColumns(
                          context, AppLocalizations.of(context)),
                      polRows: [],
                      footerBuilder: (stateManager) {
                        return lazyPaginationFooter(stateManager);
                      },
                    ),
                  ),
                  // TopDataRowWidget(
                  //   topDataRow: coloumn!,
                  // ),
                  // const Divider(
                  //   height: 1,
                  // ),
                  // Container(
                  //   height: 450,
                  //   child: ListView.builder(
                  //     controller: _scrollController,
                  //     scrollDirection: Axis.vertical,
                  //     shrinkWrap: true,
                  //     itemCount: widget.list.length,
                  //     itemBuilder: (BuildContext context, int i) {
                  //       return DataRowWidget(
                  //         setState: widget.setState,
                  //         number: i + 1,
                  //         code: widget.list[i].account!,
                  //         name: widget.list[i].accountName!,
                  //         type: widget.list[i].accountType!,
                  //       );
                  //     },
                  //   ),
                  // ),
                  const Divider(
                    height: 1,
                  ),
                  // ListView for the remaining items
                  // ListView.builder(
                  //   shrinkWrap: true,
                  //   itemCount: remainingItems.length,
                  //   itemBuilder: (BuildContext context, int i) {
                  //     return DataRowWidget(
                  //       setState: widget.setState,
                  //       number:
                  //           i + 11, // Adjust numbering for the remaining items
                  //       code: remainingItems[i].account!,
                  //       name: remainingItems[i].accountName!,
                  //       type: remainingItems[i].accountType!,
                  //     );
                  //   },
                  // ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  PlutoLazyPagination lazyPaginationFooter(PlutoGridStateManager stateManager) {
    return PlutoLazyPagination(
      initialPage: 1,
      initialFetch: true,
      pageSizeToMove: null,
      fetchWithSorting: false,
      fetchWithFiltering: false,
      fetch: (request) {
        return Future.delayed(Duration(seconds: 1));
        // return fetch(request);
      },
      stateManager: stateManager,
    );
  }

  // Future<PlutoLazyPaginationResponse> fetch(
  //     PlutoLazyPaginationRequest request) async {
  //   int page = request.page;

  //   //To send the number of page to the JSON Object
  //   criteria.page = page;

  //   List<PlutoRow> topList = [];
  //   print("from date critiria :${criteria.fromDate}");
  //   List<ChequesModel> invList = await controller.getCheques(criteria);

  //   int totalPage = 1;

  //   for (int i = 0; i < invList.length; i++) {
  //     topList.add(invList[i].toPluto());
  //   }

  //   print("topList :${topList.length}");
  //   return PlutoLazyPaginationResponse(
  //     totalPage: totalPage,
  //     rows: topList,
  //   );
  // }

  List<List<String>> getStringList() {
    // print("ListString ${widget.dataInc.length}");
    List<List<String>> stringList = [];

    for (int i = 0; i < widget.list.length; i++) {
      print("ListString ${widget.list.length}");
      List<String> temp = [
        (i + 1).toString(),
        widget.list[i].account.toString(),
        widget.list[i].accountName.toString(),
        widget.list[i].accountType.toString()
      ];
      stringList.add(temp);
    }
    // print("ListStrin ${stringList.length}");
    return stringList;
  }
  // @override
  // Widget build(BuildContext context) {
  //   print(widget.list);
  //   return Stack(
  //     children: [
  //       SingleChildScrollView(
  //         child: Center(
  //           child: Container(
  //             margin: EdgeInsets.all(20),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 ExpensesAccountDropDown(
  //                     accountsName: widget.dropDownData,
  //                     addAccount: widget.addAccount,
  //                     type: widget.type),
  //                 // Text(
  //                 //   _locale.expensesAccounts,
  //                 //   style: utils.eighteen500TextStyle(Colors.black),
  //                 // ),
  //                 const SizedBox(
  //                   height: 10,
  //                 ),
  //                 SizedBox(
  //                   width: MediaQuery.of(context).size.width < 800
  //                       ? MediaQuery.of(context).size.width * 0.9
  //                       : MediaQuery.of(context).size.width * 1.2 / 2,
  //                   child: SingleChildScrollView(
  //                     controller: ScrollController(),
  //                     scrollDirection: Axis.vertical,
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.end,
  //                       children: [
  //                         const Divider(
  //                           height: 1,
  //                         ),
  //                         TopDataRowWidget(
  //                           number: 0,
  //                           code: _locale.accountCode,
  //                           name: _locale.accountName,
  //                         ),
  //                         for (int i = 0; i < widget.list.length; i++)
  //                           DataRowWidget(
  //                             setState: widget.setState,
  //                             number: i + 1,
  //                             code: widget.list[i].account!,
  //                             name: widget.list[i].accountName!,
  //                             type: widget.list[i].accountType!,
  //                           ),
  //                         const Divider(
  //                           height: 1,
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       )
  //     ],
  //   );
  // }
}
