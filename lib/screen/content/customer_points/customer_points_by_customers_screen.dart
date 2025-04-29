import 'package:bi_replicate/components/table_component.dart';
import 'package:bi_replicate/controller/customer_points_controller.dart';
import 'package:bi_replicate/model/criteria/customer_points_crit_model.dart';
import 'package:bi_replicate/model/customer_model.dart';
import 'package:bi_replicate/model/customer_points_by_customer.dart';
import 'package:bi_replicate/utils/constants/colors.dart';
import 'package:bi_replicate/utils/constants/responsive.dart';
import 'package:bi_replicate/utils/constants/styles.dart';
import 'package:bi_replicate/widget/custom_textfield.dart';
import 'package:bi_replicate/widget/test_drop_down.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pluto_grid/pluto_grid.dart';

class CustomerPointsByCustomersScreen extends StatefulWidget {
  const CustomerPointsByCustomersScreen({super.key});

  @override
  State<CustomerPointsByCustomersScreen> createState() =>
      _CustomerPointsByCustomersScreenState();
}

class _CustomerPointsByCustomersScreenState
    extends State<CustomerPointsByCustomersScreen> {
  late AppLocalizations _locale;
  double height = 0.0;
  double width = 0.0;
  bool isDesktop = false;
  bool isMobile = false;
  TextEditingController numberOfrow = TextEditingController(text: "10");
  List<PlutoRow> polTopRows = [];
  FocusNode focusNode = FocusNode();
  CustomerPointsSearchCriteria criteria = CustomerPointsSearchCriteria();
  List<CustomerModel> customersList = [];
  List<String> customersCodes = [];
  List<CustomerModel> tempCustomers = [];
  List<String> tempCustomersCodes = [];
  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context)!;

    super.didChangeDependencies();
  }

  @override
  void initState() {
    criteria.codesBranch = [];
    criteria.codesCust = [];
    criteria.count = 10;
    criteria.page = 1;
    criteria.fromDate = "";
    criteria.toDate = "";
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
        buildHeaderContent(),
        SizedBox(
          height: height * 0.02,
        ),
        SizedBox(
          width: isDesktop ? width * 0.8 : width * 0.9,
          child: isDesktop
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        SelectableText(
                          maxLines: 1,
                          _locale.topPoints,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: height * 0.02,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        tableComponentTopPoints(context),
                      ],
                    ),
                    Column(
                      children: [
                        SelectableText(
                          maxLines: 1,
                          _locale.topUsedPoints,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: height * 0.02,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        tableComponentTopUsedPoints(context),
                      ],
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        SelectableText(
                          maxLines: 1,
                          _locale.topPoints,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: height * 0.02,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        tableComponentTopPoints(context),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Column(
                      children: [
                        SelectableText(
                          maxLines: 1,
                          _locale.topUsedPoints,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: height * 0.02,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        tableComponentTopUsedPoints(context),
                      ],
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  Widget buildHeaderContent() {
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
      child: isDesktop ? desktopHeader() : mobileHeader(),
    );
  }

  Widget desktopHeader() {
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
                    Text(_locale.customer),
                    TestDropdown(
                        isEnabled: true,
                        icon: const Icon(Icons.search),
                        cleanPrevSelectedItem: true,
                        onClearIconPressed: () {
                          customersList.clear();
                          customersCodes.clear();
                          tempCustomers.clear();
                          tempCustomersCodes.clear();
                          setState(() {});
                        },
                        onItemAddedOrRemoved: (value) {
                          for (int i = 0; i < value.length; i++) {
                            tempCustomers.add(value[i]);
                            tempCustomersCodes
                                .add(tempCustomers[i].value ?? "");
                          }
                        },
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            customersList.clear();
                            customersCodes.clear();
                            tempCustomers.clear();
                            tempCustomersCodes.clear();
                            for (int i = 0; i < value.length; i++) {
                              customersList.add(value[i]);
                              customersCodes.add(customersList[i].value ?? "");
                            }
                            criteria.codesCust = customersCodes;
                            setState(() {});
                          } else {
                            customersList.clear();
                            customersCodes.clear();
                            tempCustomers.clear();
                            tempCustomersCodes.clear();
                            criteria.codesCust = [];

                            setState(() {});
                          }
                        },
                        stringValue: customersList.isEmpty
                            ? "${_locale.select} ${_locale.customer}"
                            : customersList.map((b) => b.text).join(', '),
                        borderText: "",
                        showSearchBox: true,
                        onPressed: () {},
                        selectedList: [],
                        onSearch: (text) async {
                          List<CustomerModel> value =
                              await CustomerPointsController()
                                  .getCustomers(text);
                          value = value
                              .where((cust) => !tempCustomers
                                  .any((temp) => temp.value == cust.value))
                              .toList();

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

  Widget mobileHeader() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          width: width * 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: width * 0.73,
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
                    Text(_locale.customer),
                    TestDropdown(
                        isEnabled: true,
                        icon: const Icon(Icons.search),
                        cleanPrevSelectedItem: true,
                        onClearIconPressed: () {
                          customersList.clear();
                          customersCodes.clear();
                          tempCustomers.clear();
                          tempCustomersCodes.clear();
                          setState(() {});
                        },
                        onItemAddedOrRemoved: (value) {
                          for (int i = 0; i < value.length; i++) {
                            tempCustomers.add(value[i]);
                            tempCustomersCodes
                                .add(tempCustomers[i].value ?? "");
                          }
                        },
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            customersList.clear();
                            customersCodes.clear();
                            tempCustomers.clear();
                            tempCustomersCodes.clear();
                            for (int i = 0; i < value.length; i++) {
                              customersList.add(value[i]);
                              customersCodes.add(customersList[i].value ?? "");
                            }
                            criteria.codesCust = customersCodes;
                            setState(() {});
                          } else {
                            customersList.clear();
                            customersCodes.clear();
                            tempCustomers.clear();
                            tempCustomersCodes.clear();
                            criteria.codesCust = [];

                            setState(() {});
                          }
                        },
                        stringValue: customersList.isEmpty
                            ? "${_locale.select} ${_locale.customer}"
                            : customersList.map((b) => b.text).join(', '),
                        borderText: "",
                        showSearchBox: true,
                        onPressed: () {},
                        selectedList: [],
                        onSearch: (text) async {
                          List<CustomerModel> value =
                              await CustomerPointsController()
                                  .getCustomers(text);
                          value = value
                              .where((cust) => !tempCustomers
                                  .any((temp) => temp.value == cust.value))
                              .toList();

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

  Widget tableComponentTopUsedPoints(BuildContext context) {
    return SizedBox(
      width: isDesktop ? width * 0.35 : width * 0.9,
      height: height * 0.6,
      child: TableComponent(
        key: UniqueKey(),
        rowHeight: 30,
        plCols: CustomerPointsByCustomerModel.getColumns(
            AppLocalizations.of(context)!, context),
        polRows: polTopRows,
        footerBuilder: (stateManager) {
          return lazyPaginationFooterTopUsedPoints(stateManager);
        },
      ),
    );
  }

  PlutoLazyPagination lazyPaginationFooterTopUsedPoints(
      PlutoGridStateManager stateManager) {
    return PlutoLazyPagination(
      initialPage: 1,
      initialFetch: true,
      pageSizeToMove: null,
      fetchWithSorting: false,
      fetchWithFiltering: false,
      fetch: (request) {
        return fetchTopUsedPoints(request);
      },
      stateManager: stateManager,
    );
  }

  int counterTopUsedPoints = 0;

  Future<PlutoLazyPaginationResponse> fetchTopUsedPoints(
      PlutoLazyPaginationRequest request) async {
    counterTopUsedPoints = 0;

    List<PlutoRow> topList = [];
    List<CustomerPointsByCustomerModel> list = [];

    await CustomerPointsController()
        .getTopUsedPointsCustomerPointsByCustomerList(criteria)
        .then((value) {
      list = value;
    });

    for (int i = 0; i < list.length; i++) {
      topList.add(list[i].toPluto(++counterTopUsedPoints));
    }

    return PlutoLazyPaginationResponse(
      totalPage: 0,
      rows: topList,
    );
  }

  Widget tableComponentTopPoints(BuildContext context) {
    return SizedBox(
      width: isDesktop ? width * 0.35 : width * 0.9,
      height: height * 0.6,
      child: TableComponent(
        key: UniqueKey(),
        rowHeight: 30,
        plCols: CustomerPointsByCustomerModel.getColumns(
            AppLocalizations.of(context)!, context),
        polRows: polTopRows,
        footerBuilder: (stateManager) {
          return lazyPaginationFooterTopPoints(stateManager);
        },
      ),
    );
  }

  PlutoLazyPagination lazyPaginationFooterTopPoints(
      PlutoGridStateManager stateManager) {
    return PlutoLazyPagination(
      initialPage: 1,
      initialFetch: true,
      pageSizeToMove: null,
      fetchWithSorting: false,
      fetchWithFiltering: false,
      fetch: (request) {
        return fetchTopPoints(request);
      },
      stateManager: stateManager,
    );
  }

  int counterTopPoints = 0;

  Future<PlutoLazyPaginationResponse> fetchTopPoints(
      PlutoLazyPaginationRequest request) async {
    counterTopPoints = 0;

    List<PlutoRow> topList = [];
    List<CustomerPointsByCustomerModel> list = [];

    await CustomerPointsController()
        .getTopPointsCustomerPointsByCustomerList(criteria)
        .then((value) {
      list = value;
    });

    for (int i = 0; i < list.length; i++) {
      topList.add(list[i].toPluto(++counterTopPoints));
    }

    return PlutoLazyPaginationResponse(
      totalPage: 0,
      rows: topList,
    );
  }
}
