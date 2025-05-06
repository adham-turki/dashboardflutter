import 'package:bi_replicate/components/custom_date.dart';
import 'package:bi_replicate/components/table_component.dart';
import 'package:bi_replicate/controller/customer_points_controller.dart';
import 'package:bi_replicate/controller/sales_adminstration/branch_controller.dart';
import 'package:bi_replicate/model/branch_model.dart';
import 'package:bi_replicate/model/criteria/customer_points_crit_model.dart';
import 'package:bi_replicate/model/customers_points_by_branch_model.dart';
import 'package:bi_replicate/provider/dates_provider.dart';
import 'package:bi_replicate/utils/constants/responsive.dart';
import 'package:bi_replicate/utils/constants/styles.dart';
import 'package:bi_replicate/utils/func/dates_controller.dart';
import 'package:bi_replicate/widget/custom_textfield.dart';
import 'package:bi_replicate/widget/test_drop_down.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:provider/provider.dart';

class CustomerPointsByBranchScreen extends StatefulWidget {
  const CustomerPointsByBranchScreen({super.key});

  @override
  State<CustomerPointsByBranchScreen> createState() =>
      _CustomerPointsByBranchScreenState();
}

class _CustomerPointsByBranchScreenState
    extends State<CustomerPointsByBranchScreen> {
  late AppLocalizations _locale;
  double height = 0.0;
  double width = 0.0;
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  TextEditingController numberOfrow = TextEditingController(text: "10");
  String? fromDateValue;
  String? toDateValue;
  CustomerPointsSearchCriteria criteria = CustomerPointsSearchCriteria();
  String todayDate = DatesController().formatDateReverse(
      DatesController().formatDate(DatesController().todayDate()));
  String firstDayOfMonth = DatesController().formatDateReverse(
      DatesController().formatDate(DatesController().currentMonth()));
  List<PlutoRow> polTopRows = [];
  FocusNode focusNode = FocusNode();
  List<BranchModel> branchesList = [];
  List<String> branchesCodes = [];
  List<BranchModel> tempBranches = [];
  List<String> tempBranchesCodes = [];
  bool isDesktop = false;
  bool isMobile = false;
  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context)!;

    super.didChangeDependencies();
  }

  @override
  void initState() {
    focusNode.requestFocus();
    fromDate.text = firstDayOfMonth;
    toDate.text = todayDate;
    fromDate.text = context.read<DatesProvider>().sessionFromDate.isNotEmpty
        ? DatesController()
            .dashFormatDate(context.read<DatesProvider>().sessionFromDate, true)
        : fromDate.text;
    toDate.text = context.read<DatesProvider>().sessionToDate.isNotEmpty
        ? DatesController()
            .dashFormatDate(context.read<DatesProvider>().sessionToDate, true)
        : toDate.text;
    criteria.codesBranch = [];
    criteria.codesCust = [];
    criteria.count = 10;
    criteria.page = 1;
    criteria.fromDate =
        (context.read<DatesProvider>().sessionFromDate.isNotEmpty
            ? DatesController().dashFormatDate(
                context.read<DatesProvider>().sessionFromDate, false)
            : firstDayOfMonth);
    criteria.toDate = (context.read<DatesProvider>().sessionToDate.isNotEmpty
        ? DatesController()
            .dashFormatDate(context.read<DatesProvider>().sessionToDate, false)
        : todayDate);
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
        buildHeaderContent(
            context: context,
            fromDate: fromDate,
            toDate: toDate,
            fromDateLabel: _locale.fromDate,
            toDateLabel: _locale.toDate),
        tableComponent(context),
      ],
    );
  }

  Widget tableComponent(BuildContext context) {
    return SizedBox(
      width: isDesktop ? width * 0.5 : width * 0.9,
      height: height * 0.6,
      child: TableComponent(
        key: UniqueKey(),
        rowHeight: 30,
        plCols: CustomerPointsByBranch.getColumns(
            AppLocalizations.of(context)!, context),
        polRows: polTopRows,
        footerBuilder: (stateManager) {
          return lazyPaginationFooter(stateManager);
        },
      ),
    );
  }

  Widget buildHeaderContent({
    required BuildContext context,
    required TextEditingController fromDate,
    required TextEditingController toDate,
    required String fromDateLabel,
    required String toDateLabel,
  }) {
    return Container(
      width: isDesktop ? width * 0.5 : width * 0.9,
      padding: EdgeInsets.all(width * 0.02),
      margin: EdgeInsets.symmetric(
          vertical: height * 0.01, horizontal: width * 0.02),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black38),
        borderRadius: BorderRadius.circular(5),
        color: const Color.fromARGB(77, 228, 228, 228),
      ),
      child: isDesktop
          ? desktopHeader(fromDate, fromDateLabel, toDate, toDateLabel)
          : mobileHeader(fromDate, fromDateLabel, toDate, toDateLabel),
    );
  }

  Widget desktopHeader(TextEditingController fromDate, String fromDateLabel,
      TextEditingController toDate, String toDateLabel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          width: width * 0.46,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: width * 0.2,
                child: CustomDate(
                  dateController: fromDate,
                  label: fromDateLabel,
                  lastDate: DateTime.now(),
                  minYear: 2000,
                  onValue: (isValid, value) {
                    print("fromDate.text: ${fromDate.text}, $isValid");
                    if (isValid) {
                      fromDate.text = value;
                      setControllerFromDateText();
                    }
                  },
                  dateControllerToCompareWith: toDate,
                  isInitiaDate: true,
                  timeControllerToCompareWith: null,
                ),
              ),
              SizedBox(
                width: width * 0.2,
                child: CustomDate(
                  dateController: toDate,
                  label: toDateLabel,
                  lastDate: DateTime.now(),
                  onValue: (isValid, value) {
                    if (isValid) {
                      toDate.text = value;
                      setControllertoDateText();
                    }
                  },
                  dateControllerToCompareWith: fromDate,
                  isInitiaDate: false,
                  timeControllerToCompareWith: null,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: width * 0.46,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: width * 0.2,
                child: CustomTextField(
                  focusNode: focusNode,
                  controller: numberOfrow,
                  initialValue: numberOfrow.text,
                  label: _locale.numOfResults,
                  onSubmitted: (value) {
                    setState(() {
                      criteria.count = int.parse(numberOfrow.text);
                    });
                  },
                  onChanged: (value) {
                    criteria.count = int.parse(numberOfrow.text);
                  },
                ),
              ),
              SizedBox(
                width: width * 0.2,
                height: 85,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_locale.branch),
                    TestDropdown(
                        isEnabled: true,
                        icon: const Icon(Icons.search),
                        cleanPrevSelectedItem: true,
                        onClearIconPressed: () {
                          branchesList.clear();
                          branchesCodes.clear();
                          tempBranches.clear();
                          tempBranchesCodes.clear();
                          setState(() {});
                        },
                        onItemAddedOrRemoved: (value) {
                          for (int i = 0; i < value.length; i++) {
                            tempBranches.add(value[i]);
                            tempBranchesCodes
                                .add(tempBranches[i].txtCode ?? "");
                          }
                        },
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            print("innnnnnnnnnnn:111");
                            branchesList.clear();
                            branchesCodes.clear();
                            tempBranches.clear();
                            tempBranchesCodes.clear();
                            for (int i = 0; i < value.length; i++) {
                              branchesList.add(value[i]);
                              branchesCodes.add(branchesList[i].txtCode ?? "");
                            }
                            criteria.codesBranch = branchesCodes;
                            setState(() {});
                          } else {
                            print("innnnnnnnnnnn:222");
                            branchesList.clear();
                            branchesCodes.clear();
                            tempBranches.clear();
                            tempBranchesCodes.clear();
                            criteria.codesBranch = [];

                            setState(() {});
                          }
                        },
                        stringValue: branchesList.isEmpty
                            ? "${_locale.select} ${_locale.branch}"
                            : branchesList.map((b) => b.txtNamee).join(', '),
                        borderText: "",
                        showSearchBox: false,
                        onPressed: () {},
                        selectedList: [],
                        onSearch: (text) async {
                          List<BranchModel> value =
                              await BranchController().getBranchesList();
                          print("value1: ${value.length}");
                          value = value
                              .where((branch) => !tempBranches.any(
                                  (temp) => temp.txtCode == branch.txtCode))
                              .toList();
                          print("value1111: ${value.length}");

                          return value;
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget mobileHeader(TextEditingController fromDate, String fromDateLabel,
      TextEditingController toDate, String toDateLabel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          width: width * 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: width * 0.7,
                child: CustomDate(
                  dateController: fromDate,
                  label: fromDateLabel,
                  lastDate: DateTime.now(),
                  minYear: 2000,
                  onValue: (isValid, value) {
                    print("fromDate.text: ${fromDate.text}, $isValid");
                    if (isValid) {
                      fromDate.text = value;
                      setControllerFromDateText();
                    }
                  },
                  dateControllerToCompareWith: toDate,
                  isInitiaDate: true,
                  timeControllerToCompareWith: null,
                ),
              ),
              SizedBox(
                width: width * 0.7,
                child: CustomDate(
                  dateController: toDate,
                  label: toDateLabel,
                  lastDate: DateTime.now(),
                  onValue: (isValid, value) {
                    if (isValid) {
                      toDate.text = value;
                      setControllertoDateText();
                    }
                  },
                  dateControllerToCompareWith: fromDate,
                  isInitiaDate: false,
                  timeControllerToCompareWith: null,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: width * 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: width * 0.7,
                child: CustomTextField(
                  focusNode: focusNode,
                  controller: numberOfrow,
                  initialValue: numberOfrow.text,
                  label: _locale.numOfResults,
                  onSubmitted: (value) {
                    setState(() {
                      criteria.count = int.parse(numberOfrow.text);
                    });
                  },
                  onChanged: (value) {
                    criteria.count = int.parse(numberOfrow.text);
                  },
                ),
              ),
              SizedBox(
                width: width * 0.7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_locale.branch),
                    TestDropdown(
                        isEnabled: true,
                        icon: const Icon(Icons.search),
                        cleanPrevSelectedItem: true,
                        onClearIconPressed: () {
                          branchesList.clear();
                          branchesCodes.clear();
                          tempBranches.clear();
                          tempBranchesCodes.clear();
                          setState(() {});
                        },
                        onItemAddedOrRemoved: (value) {
                          for (int i = 0; i < value.length; i++) {
                            tempBranches.add(value[i]);
                            tempBranchesCodes
                                .add(tempBranches[i].txtCode ?? "");
                          }
                        },
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            print("innnnnnnnnnnn:111");
                            branchesList.clear();
                            branchesCodes.clear();
                            tempBranches.clear();
                            tempBranchesCodes.clear();
                            for (int i = 0; i < value.length; i++) {
                              branchesList.add(value[i]);
                              branchesCodes.add(branchesList[i].txtCode ?? "");
                            }
                            criteria.codesBranch = branchesCodes;
                            setState(() {});
                          } else {
                            print("innnnnnnnnnnn:222");
                            branchesList.clear();
                            branchesCodes.clear();
                            tempBranches.clear();
                            tempBranchesCodes.clear();
                            criteria.codesBranch = [];

                            setState(() {});
                          }
                        },
                        stringValue: branchesList.isEmpty
                            ? "${_locale.select} ${_locale.branch}"
                            : branchesList.map((b) => b.txtNamee).join(', '),
                        borderText: "",
                        showSearchBox: false,
                        onPressed: () {},
                        selectedList: [],
                        onSearch: (text) async {
                          List<BranchModel> value =
                              await BranchController().getBranchesList();
                          print("value1: ${value.length}");
                          value = value
                              .where((branch) => !tempBranches.any(
                                  (temp) => temp.txtCode == branch.txtCode))
                              .toList();
                          print("value1111: ${value.length}");

                          return value;
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget placeholderWidget() {
    return Container(
      width: 100,
      height: 50,
      color: Colors.grey[300],
      child: const Center(child: Text('Replace me')),
    );
  }

  int counter = 0;
  Future<PlutoLazyPaginationResponse> fetch(
      PlutoLazyPaginationRequest request) async {
    counter = 0;
    criteria.fromDate = formatDate(criteria.fromDate);
    criteria.toDate = formatDate(criteria.toDate);
    List<PlutoRow> topList = [];
    List<CustomerPointsByBranch> customersPointsByBranch = [];

    await CustomerPointsController()
        .getCustomerPointsByBranchList(criteria)
        .then((value) {
      print("value.length: ${value.length}");
      customersPointsByBranch = value;
    });

    for (int i = 0; i < customersPointsByBranch.length; i++) {
      topList.add(customersPointsByBranch[i].toPluto(++counter));
    }

    return PlutoLazyPaginationResponse(
      totalPage: 0,
      rows: topList,
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
        return fetch(request);
      },
      stateManager: stateManager,
    );
  }

  void setControllerFromDateText() {
    return setState(() {
      fromDateValue = fromDate.text;
      String startDate = DatesController().formatDate(fromDateValue!);
      criteria.fromDate = startDate;
      print("fromDate.text: ${criteria.fromDate}");
      fetch(PlutoLazyPaginationRequest(page: criteria.page!));
    });
  }

  void setControllertoDateText() {
    return setState(() {
      toDateValue = toDate.text;
      String endDate = DatesController().formatDate(toDateValue!);
      criteria.toDate = endDate;
      fetch(PlutoLazyPaginationRequest(page: criteria.page!));
    });
  }

  String formatDate(dynamic date) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');

    if (date is DateTime) {
      return formatter.format(date);
    }

    if (date is String) {
      // Check if already in correct format (dd-MM-yyyy)
      final RegExp regex = RegExp(r'^\d{2}-\d{2}-\d{4}$');
      if (regex.hasMatch(date)) {
        return date;
      }

      try {
        // Try parsing the string to DateTime
        DateTime parsed = DateTime.parse(date);
        return formatter.format(parsed);
      } catch (e) {
        throw FormatException('Invalid date string: $date');
      }
    }

    throw ArgumentError('Input must be a DateTime or String');
  }
}
