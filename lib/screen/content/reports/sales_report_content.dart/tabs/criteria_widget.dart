// import '../../../../../widget/custom_textfield.dart';
// import '../../../../../widget/drop_down/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../../../components/search_table/date_time_component.dart';

import '../../../../../controller/error_controller.dart';
import '../../../../../controller/reports/report_controller.dart';

import '../../../../../model/criteria/drop_down_search_criteria.dart';
import '../../../../../model/sales_adminstration/branch_model.dart';

import '../../../../../provider/sales_search_provider.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/constants.dart';
import '../../../../../utils/constants/responsive.dart';
import '../../../../../utils/func/converters.dart';
import '../../../../../utils/func/dates_controller.dart';
import '../../../../../widget/custom_textfield2.dart';
import '../../../../../widget/drop_down/drop_down_clear.dart';
import '../../../../../widget/test_drop_down.dart';

class CriteriaWidget extends StatefulWidget {
  final Function(String) onSelectedValueChanged1;
  final Function(String) onSelectedValueChanged2;
  final Function(String) onSelectedValueChanged3;
  final Function(String) onSelectedValueChanged4;
  CriteriaWidget({
    Key? key,
    required this.onSelectedValueChanged1,
    required this.onSelectedValueChanged2,
    required this.onSelectedValueChanged3,
    required this.onSelectedValueChanged4,
  }) : super(key: key);
  double unused = 0;

  @override
  State<CriteriaWidget> createState() => _CriteriaWidgetState();
}

class _CriteriaWidgetState extends State<CriteriaWidget> {
  // TextEditingController fromDate = TextEditingController();
  // TextEditingController toDate = TextEditingController();
  double width = 0;
  double height = 0;
  bool isDesktop = false;
  // bool isMobile = false;
  bool isMobile = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    isDesktop = Responsive.isDesktop(context);
    isMobile = Responsive.isMobile(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
            border: Border.all(color: Colors.grey),
          ),
          padding:
              isDesktop ? const EdgeInsets.all(0) : const EdgeInsets.all(10),
          // width: width * 0.80,
          child: isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LeftWidget(
                        onSelectedValueChanged1: widget.onSelectedValueChanged1,
                        onSelectedValueChanged2: widget.onSelectedValueChanged2,
                        onSelectedValueChanged3: widget.onSelectedValueChanged3,
                        onSelectedValueChanged4:
                            widget.onSelectedValueChanged4),
                    // RightWidget(),
                    // MiddleWidget(),
                  ],
                )
              : Column(
                  children: [
                    LeftWidget(
                        onSelectedValueChanged1: widget.onSelectedValueChanged1,
                        onSelectedValueChanged2: widget.onSelectedValueChanged2,
                        onSelectedValueChanged3: widget.onSelectedValueChanged3,
                        onSelectedValueChanged4:
                            widget.onSelectedValueChanged4),
                    // SizedBox(
                    //   height: height * .01,
                    // ),
                    // RightWidget(),
                    //MiddleWidget(),
                  ],
                )),
    );
  }
}

class LeftWidget extends StatefulWidget {
  final Function(String) onSelectedValueChanged1;
  final Function(String) onSelectedValueChanged2;
  final Function(String) onSelectedValueChanged3;
  final Function(String) onSelectedValueChanged4;
  LeftWidget({
    Key? key,
    required this.onSelectedValueChanged1,
    required this.onSelectedValueChanged2,
    required this.onSelectedValueChanged3,
    required this.onSelectedValueChanged4,
  }) : super(key: key);
  double unused = 0;

  @override
  State<LeftWidget> createState() => _LeftWidgetState();
}

class _LeftWidgetState extends State<LeftWidget> {
  ReportController salesReportController = ReportController();

  late AppLocalizations _locale;

  var selectedFromStkCategory1 = "";
  var selectedToStkCategory1 = "";
  var selectedFromStkCategory3 = "";
  var selectedToStkCategory3 = "";
  var selectedFromCustomers = "";
  var selectedToCustomers = "";
  var selectedFromStocks = "";
  var selectedToStocks = "";

  var selectedFromStkCategory1Code = "";
  var selectedToStkCategory1Code = "";
  var selectedFromStkCategory3Code = "";
  var selectedToStkCategory3Code = "";
  var selectedFromCustomersCode = "";
  var selectedToCustomersCode = "";
  var selectedFromStocksCode = "";
  var selectedToStocksCode = "";

  bool valueMultipleStkCateg1 = false;
  bool valueMultipleStkCateg3 = false;
  bool valueMultipleCustomer = false;
  bool valueMultipleStock = false;
  bool valueSelectAllStkCateg1 = false;
  bool valueSelectAllStkCateg3 = false;
  bool valueSelectAllCustomer = false;
  bool valueSelectAllStock = false;
  late SalesCriteraProvider readProvider;
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  double width = 0;
  double height = 0;
  bool isDesktop = false;
  // bool isMobile = false;
  bool isMobile = false;
  String todayDate = "";
  String currentMonth = "";

  //test dropdown attributes
  String hintStockCatLevel1 = "";
  List<BranchModel> stockCatLevel1Codes = [];
  String hintStockCatLevel3 = "";
  List<BranchModel> stockCatLevel3Codes = [];
  String hintSupplierCategory = "";
  List<BranchModel> supplierCatList = [];
  String hintCustomers = "";
  List<BranchModel> customersList = [];
  String hintCustomersCategory = "";
  List<BranchModel> customersListCategory = [];
  TextEditingController campaignNoController = TextEditingController();
  TextEditingController modelNoController = TextEditingController();

  ///
  String hintBranches = "";
  List<BranchModel> branchesList = [];
  String hinCodesStockCategory2 = "";
  List<BranchModel> stockCatLevel2Codes = [];
  String hintCodeSuppliers = "";
  List<BranchModel> codeSuppliersList = [];
  String hintStock = "";
  List<BranchModel> stockList = [];

  //order by attributes
  List<String> firstList = [];
  var selectedValue1 = "";
  var selectedValue2 = "";
  var selectedValue3 = "";
  var selectedValue4 = "";
  List<int> ordersList = [];
  Map<String, int> ordersMap = {};

  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context)!;
    readProvider = context.read<SalesCriteraProvider>();
    // readProvider.setFromDate(DatesController().formatDate(fromDate.text));
    // readProvider.setToDate(DatesController().formatDate(toDate.text));
    firstList = [
      // "",
      _locale.branch,
      _locale.stockCategoryLevel("1"),
      _locale.stockCategoryLevel("2"),
      _locale.stockCategoryLevel("3"),
      _locale.supp,
      _locale.stock,
      _locale.daily,
      _locale.monthly,
      _locale.yearly,
      _locale.brand,
      _locale.invoice
    ];
    ordersMap[_locale.branch] = 1;
    ordersMap[_locale.stockCategoryLevel("1")] = 2;
    ordersMap[_locale.stockCategoryLevel("2")] = 3;
    ordersMap[_locale.stockCategoryLevel("3")] = 4;
    ordersMap[_locale.supp] = 5;
    ordersMap[_locale.customer] = 6;
    ordersMap[_locale.stock] = 7;
    ordersMap[_locale.daily] = 8;
    ordersMap[_locale.monthly] = 9;
    ordersMap[_locale.yearly] = 10;
    ordersMap[_locale.brand] = 11;
    ordersMap[_locale.invoice] = 12;

    super.didChangeDependencies();
  }

  @override
  void initState() {
    todayDate = context.read<SalesCriteraProvider>().getToDate();
    currentMonth = context.read<SalesCriteraProvider>().getFromDate();
    fromDate.text = currentMonth;
    toDate.text = todayDate;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    isDesktop = Responsive.isDesktop(context);
    isMobile = Responsive.isMobile(context);

    // String todayDate = DatesController().formatDateReverse(
    //     DatesController().formatDate(DatesController().todayDate()));

    // fromDate.text = readProvider.getFromDate!.isNotEmpty
    //     ? DatesController()
    //         .formatDateReverse(readProvider.getFromDate.toString())
    //     : todayDate;

    // toDate.text = readProvider.getToDate!.isNotEmpty
    //     ? DatesController().formatDateReverse(readProvider.getToDate.toString())
    //     : todayDate;

    selectedFromStkCategory1 = readProvider.getFromCateg1!;

    selectedToStkCategory1 = readProvider.getToCateg1!;

    selectedFromStkCategory3 = readProvider.getFromCateg3!;
    selectedToStkCategory3 = readProvider.getToCateg3!;

    selectedFromCustomers = readProvider.getFromCust!;
    selectedToCustomers = readProvider.getToCust!;

    selectedFromStocks = readProvider.getFromstock!;
    selectedToStocks = readProvider.getTostock!;

    valueMultipleStkCateg1 = readProvider.getCheckMultipleStockCategory1!;
    valueMultipleStkCateg3 = readProvider.getCheckMultipleStockCategory3!;

    valueMultipleCustomer = readProvider.getCheckMultipleCustomer!;
    valueMultipleStock = readProvider.getCheckMultipleStock!;

    valueSelectAllStkCateg1 = readProvider.getCheckAllStockCategory1!;
    valueSelectAllStkCateg3 = readProvider.getCheckAllStockCategory3!;
    valueSelectAllCustomer = readProvider.getCheckAllCustomer!;
    valueSelectAllStock = readProvider.getCheckAllStock!;
    modelNoController.text = readProvider.getModelNo!;
    campaignNoController.text = readProvider.getCampaignNo!;
    selectedValue1 = readProvider.getVal1!;
    selectedValue2 = readProvider.getVal2!;
    selectedValue3 = readProvider.getVal3!;
    selectedValue4 = readProvider.getVal4!;
    return Column(
      children: [
        isDesktop ? desktopCritiria(context) : mobileCritiria(context),
      ],
    );
  }

  Column desktopCritiria(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            DateTimeComponent(
              readOnly: false,
              height: height * 0.04,
              dateWidth: width * 0.14,
              label: _locale.fromDate,
              dateController: fromDate,
              dateControllerToCompareWith: null,
              isInitiaDate: true,
              onValue: (isValid, value) {
                if (isValid) {
                  setState(() {
                    fromDate.text = value;
                    setFromDateController();
                    context
                        .read<SalesCriteraProvider>()
                        .setFromDate(fromDate.text);
                  });
                }
              },
              timeControllerToCompareWith: null,
            ),
            SizedBox(
              width: width * 0.0015,
            ),
            DateTimeComponent(
              readOnly: false,
              height: height * 0.04,
              dateWidth: width * 0.14,
              label: _locale.toDate,
              dateController: toDate,
              dateControllerToCompareWith: null,
              isInitiaDate: true,
              onValue: (isValid, value) {
                if (isValid) {
                  setState(() {
                    toDate.text = value;
                    setToDateController();
                    context.read<SalesCriteraProvider>().setToDate(toDate.text);
                  });
                }
              },
              timeControllerToCompareWith: null,
            ),
            SizedBox(
              width: width * 0.0015,
            ),
            //  initialValue: reportsProvider.fromCode!.branchName == null
            //           ? null
            //           : selectedFromCode,
            SizedBox(
              width: width * 0.14,
              height: height * 0.045,
              child: Consumer<SalesCriteraProvider>(
                  builder: (context, value, child) {
                return Tooltip(
                  message: hintStockCatLevel1,
                  child: TestDropdown(
                    cleanPrevSelectedItem: true,
                    isEnabled: true,
                    stringValue: readProvider.codesStockCategory1
                        .map((e) => e.branchName!)
                        .join(', '),
                    // hintStockCatLevel1 ?? _locale.stockCategoryLevel("1"),
                    borderText: _locale.stockCategoryLevel("1"),
                    onClearIconPressed: () {
                      setState(() {
                        stockCatLevel1Codes.clear();
                        hintStockCatLevel1 = "";
                        readProvider.clearCodesStockCategory1();
                      });
                    },
                    onChanged: (val) {
                      stockCatLevel1Codes.clear();
                      for (int i = 0; i < val.length; i++) {
                        stockCatLevel1Codes.add(val[i]);
                      }

                      readProvider.setCodesStockCategory1(stockCatLevel1Codes);
                      if (readProvider.codesStockCategory1.isEmpty) {
                        hintStockCatLevel1 = "";
                      } else {
                        hintStockCatLevel1 = "";

                        hintStockCatLevel1 = readProvider.codesStockCategory1
                            .map((e) => e.branchName!)
                            .join(', ');
                        // Removing the last comma and space if exists
                        if (hintStockCatLevel1.endsWith(', ')) {
                          hintStockCatLevel1 = hintStockCatLevel1.substring(
                              0, hintStockCatLevel1.length - 2);
                        }
                      }

                      setState(() {});
                    },
                    onSearch: (text) async {
                      DropDownSearchCriteria dropDownSearchCriteria =
                          getSearchCriteria(text);
                      List<BranchModel> newList = await salesReportController
                          .getSalesStkCountCateg1Method(dropDownSearchCriteria);

                      return newList;
                    },
                    // bordeText: '',
                  ),
                );
              }),
            ),
            SizedBox(
              width: width * .001,
            ),
            SizedBox(
              width: width * 0.14,
              height: height * 0.045,
              child: Consumer<SalesCriteraProvider>(
                  builder: (context, value, child) {
                return Tooltip(
                  message: hintStockCatLevel3,
                  child: TestDropdown(
                    cleanPrevSelectedItem: true,
                    // icon: const Icon(Icons.search),
                    isEnabled: true,
                    stringValue: readProvider.codesStockCategory3
                        .map((e) => e.branchName!)
                        .join(', '),
                    borderText: _locale.stockCategoryLevel("3"),
                    onClearIconPressed: () {
                      setState(() {
                        stockCatLevel3Codes.clear();
                        hintStockCatLevel3 = "";
                        readProvider.clearCodesStockCategory3();
                      });
                    },
                    onChanged: (val) {
                      stockCatLevel3Codes.clear();
                      for (int i = 0; i < val.length; i++) {
                        stockCatLevel3Codes.add(val[i]);
                      }

                      readProvider.setCodesStockCategory3(stockCatLevel3Codes);
                      if (readProvider.codesStockCategory3.isEmpty) {
                        hintStockCatLevel3 = "";
                      } else {
                        hintStockCatLevel3 = "";

                        hintStockCatLevel3 = readProvider.codesStockCategory3
                            .map((e) => e.branchName!)
                            .join(', ');
                        // Removing the last comma and space if exists
                        if (hintStockCatLevel3.endsWith(', ')) {
                          hintStockCatLevel3 = hintStockCatLevel3.substring(
                              0, hintStockCatLevel3.length - 2);
                        }
                      }

                      setState(() {});
                    },
                    onSearch: (text) async {
                      DropDownSearchCriteria dropDownSearchCriteria =
                          getSearchCriteria(text);
                      List<BranchModel> newList = await salesReportController
                          .getSalesStkCountCateg3Method(dropDownSearchCriteria);

                      return newList;
                    },
                  ),
                );
              }),
            ),
            SizedBox(
              width: width * .001,
            ),
            SizedBox(
              width: width * 0.13,
              height: height * 0.045,
              child: Consumer<SalesCriteraProvider>(
                  builder: (context, value, child) {
                return Tooltip(
                  message: hintCustomers,
                  child: TestDropdown(
                    cleanPrevSelectedItem: true,
                    // icon: const Icon(Icons.search),
                    isEnabled: true,
                    stringValue: readProvider.codesCustomer
                        .map((e) => e.branchName!)
                        .join(', '),
                    borderText: _locale.customer,
                    onClearIconPressed: () {
                      setState(() {
                        customersList.clear();
                        hintCustomers = "";
                        readProvider.clearCodeCustomer();
                      });
                    },
                    onChanged: (val) {
                      customersList.clear();
                      for (int i = 0; i < val.length; i++) {
                        customersList.add(val[i]);
                      }

                      readProvider.setCodesCustomer(customersList);
                      if (readProvider.codesCustomer.isEmpty) {
                        hintCustomers = "";
                      } else {
                        hintCustomers = "";

                        hintCustomers = readProvider.codesCustomer
                            .map((e) => e.branchName!)
                            .join(', ');
                        // Removing the last comma and space if exists
                        if (hintCustomers.endsWith(', ')) {
                          hintCustomers = hintCustomers.substring(
                              0, hintCustomers.length - 2);
                        }
                      }

                      setState(() {});
                    },
                    onSearch: (text) async {
                      DropDownSearchCriteria dropDownSearchCriteria =
                          getSearchCriteria(text);
                      List<BranchModel> newList = await salesReportController
                          .getSalesCustomersMethod(dropDownSearchCriteria);

                      return newList;
                    },
                  ),
                );
              }),
            ),
            SizedBox(
              width: width * .001,
            ),
            SizedBox(
              width: width * 0.13,
              height: height * 0.045,
              child: Consumer<SalesCriteraProvider>(
                  builder: (context, value, child) {
                return Tooltip(
                  message: hintBranches,
                  child: TestDropdown(
                    cleanPrevSelectedItem: true,
                    // icon: const Icon(Icons.search),
                    isEnabled: true,
                    stringValue: readProvider.codesBranch
                        .map((e) => e.branchName!)
                        .join(', '),
                    borderText: _locale.branch,
                    onClearIconPressed: () {
                      setState(() {
                        branchesList.clear();
                        hintBranches = "";
                        readProvider.clearBranches();
                      });
                    },
                    onChanged: (val) {
                      branchesList.clear();
                      for (int i = 0; i < val.length; i++) {
                        branchesList.add(val[i]);
                      }

                      readProvider.setCodesBranch(branchesList);
                      if (readProvider.codesBranch.isEmpty) {
                        hintBranches = "";
                      } else {
                        hintBranches = "";

                        hintBranches = readProvider.codesBranch
                            .map((e) => e.branchName!)
                            .join(', ');
                        // Removing the last comma and space if exists
                        if (hintBranches.endsWith(', ')) {
                          hintBranches = hintBranches.substring(
                              0, hintBranches.length - 2);
                        }
                      }

                      setState(() {});
                    },
                    onSearch: (text) async {
                      DropDownSearchCriteria dropDownSearchCriteria =
                          getSearchCriteria(text);
                      List<BranchModel> newList =
                          await salesReportController.getSalesBranchesMethod(
                              dropDownSearchCriteria.toJsonBranch());

                      return newList;
                    },
                  ),
                );
              }),
            ),
          ],
        ),
        SizedBox(
          height: height * .01,
        ),
        Row(
          children: [
            SizedBox(
              width: width * 0.14,
              height: height * 0.045,
              child: Consumer<SalesCriteraProvider>(
                  builder: (context, value, child) {
                return Tooltip(
                  message: hinCodesStockCategory2,
                  child: TestDropdown(
                    cleanPrevSelectedItem: true,
                    // icon: const Icon(Icons.search),
                    isEnabled: true,
                    stringValue: readProvider.codesStockCategory2
                        .map((e) => e.branchName!)
                        .join(', '),
                    onClearIconPressed: () {
                      setState(() {
                        stockCatLevel2Codes.clear();
                        hinCodesStockCategory2 = "";
                        readProvider.clearCodesStockCategory2();
                      });
                    },
                    onChanged: (val) {
                      stockCatLevel2Codes.clear();
                      for (int i = 0; i < val.length; i++) {
                        stockCatLevel2Codes.add(val[i]);
                      }

                      readProvider.setCodesStockCategory2(stockCatLevel2Codes);
                      if (readProvider.codesStockCategory2.isEmpty) {
                        hinCodesStockCategory2 = "";
                      } else {
                        hinCodesStockCategory2 = "";

                        hinCodesStockCategory2 = readProvider
                            .codesStockCategory2
                            .map((e) => e.branchName!)
                            .join(', ');
                        // Removing the last comma and space if exists
                        if (hinCodesStockCategory2.endsWith(', ')) {
                          hinCodesStockCategory2 = hinCodesStockCategory2
                              .substring(0, hinCodesStockCategory2.length - 2);
                        }
                      }

                      setState(() {});
                    },
                    onSearch: (text) async {
                      DropDownSearchCriteria dropDownSearchCriteria =
                          getSearchCriteria(text);
                      List<BranchModel> newList = await salesReportController
                          .getSalesStkCountCateg2Method(
                              dropDownSearchCriteria.toJsonBranch());

                      return newList;
                    },
                    borderText: _locale.stockCategoryLevel("2"),
                  ),
                );
              }),
            ),
            SizedBox(
              width: width * 0.0015,
            ),
            SizedBox(
              width: width * 0.14,
              height: height * 0.045,
              child: Consumer<SalesCriteraProvider>(
                  builder: (context, value, child) {
                return Tooltip(
                  message: hintCodeSuppliers,
                  child: TestDropdown(
                    cleanPrevSelectedItem: true,
                    // icon: const Icon(Icons.search),
                    isEnabled: true,
                    stringValue: readProvider.codesSupplier
                        .map((e) => e.branchName!)
                        .join(', '),
                    borderText: _locale.supplier(""),
                    onClearIconPressed: () {
                      setState(() {
                        codeSuppliersList.clear();
                        hintCodeSuppliers = "";
                        readProvider.clearCodesSupplier();
                      });
                    },
                    onChanged: (val) {
                      codeSuppliersList.clear();
                      for (int i = 0; i < val.length; i++) {
                        codeSuppliersList.add(val[i]);
                      }

                      readProvider.setCodesSupplier(codeSuppliersList);
                      if (readProvider.codesSupplier.isEmpty) {
                        hintCodeSuppliers = "";
                      } else {
                        hintCodeSuppliers = "";

                        hintCodeSuppliers = readProvider.codesSupplier
                            .map((e) => e.branchName!)
                            .join(', ');
                        // Removing the last comma and space if exists
                        if (hintCodeSuppliers.endsWith(', ')) {
                          hintCodeSuppliers = hintCodeSuppliers.substring(
                              0, hintCodeSuppliers.length - 2);
                        }
                      }

                      setState(() {});
                    },
                    onSearch: (text) async {
                      DropDownSearchCriteria dropDownSearchCriteria =
                          getSearchCriteria(text);
                      List<BranchModel> newList =
                          await salesReportController.getSalesSuppliersMethod(
                              dropDownSearchCriteria.toJsonBranch());

                      return newList;
                    },
                  ),
                );
              }),
            ),
            SizedBox(
              width: width * 0.0015,
            ),
            SizedBox(
              width: width * 0.14,
              height: height * 0.045,
              child: Consumer<SalesCriteraProvider>(
                  builder: (context, value, child) {
                return Tooltip(
                  message: hintCustomersCategory,
                  child: TestDropdown(
                    cleanPrevSelectedItem: true,
                    // icon: const Icon(Icons.search),
                    isEnabled: true,
                    stringValue: readProvider.codesCustomerCategory
                        .map((e) => e.branchName!)
                        .join(', '),
                    borderText: _locale.customerCategory,
                    onClearIconPressed: () {
                      setState(() {
                        customersListCategory.clear();
                        hintCustomersCategory = "";
                        readProvider.clearCodeCustomerCategory();
                      });
                    },
                    onChanged: (val) {
                      customersListCategory.clear();
                      for (int i = 0; i < val.length; i++) {
                        customersListCategory.add(val[i]);
                      }

                      readProvider
                          .setCodesCustomerCategory(customersListCategory);
                      if (readProvider.codesCustomerCategory.isEmpty) {
                        hintCustomersCategory = "";
                      } else {
                        hintCustomersCategory = "";

                        hintCustomersCategory = readProvider
                            .codesCustomerCategory
                            .map((e) => e.branchName!)
                            .join(', ');
                        // Removing the last comma and space if exists
                        if (hintCustomersCategory.endsWith(', ')) {
                          hintCustomersCategory = hintCustomersCategory
                              .substring(0, hintCustomersCategory.length - 2);
                        }
                      }

                      setState(() {});
                    },
                    onSearch: (text) async {
                      DropDownSearchCriteria dropDownSearchCriteria =
                          getSearchCriteria(text);
                      List<BranchModel> newList = await salesReportController
                          .getSalesCustomersCategMethod(dropDownSearchCriteria);

                      return newList;
                    },
                  ),
                );
              }),
            ),
            SizedBox(
              width: width * 0.0015,
            ),
            CustomTextField2(
              // isDocReport: true,
              text: Text(_locale.campaignNo),
              width: width * 0.14,
              // isReport: true,
              // label: _locale.campaignNo,
              controller: campaignNoController,
              onSubmitted: (text) {
                readProvider.setCampaignNo(campaignNoController.text);
              },
              onChanged: (value) {
                readProvider.setCampaignNo(campaignNoController.text);
              },
            ),
            SizedBox(
              width: width * 0.0015,
            ),
            SizedBox(
              width: width * 0.13,
              height: height * 0.045,
              child: Consumer<SalesCriteraProvider>(
                  builder: (context, value, child) {
                return Tooltip(
                  message: hintStock,
                  child: TestDropdown(
                    cleanPrevSelectedItem: true,
                    // icon: const Icon(Icons.search),
                    isEnabled: true,
                    stringValue: readProvider.codesStock
                        .map((e) => e.branchName!)
                        .join(', '),
                    borderText: _locale.stock,
                    onClearIconPressed: () {
                      setState(() {
                        stockList.clear();

                        hintStock = "";
                        readProvider.clearStocks();
                      });
                    },
                    onChanged: (val) {
                      stockList.clear();
                      for (int i = 0; i < val.length; i++) {
                        stockList.add(val[i]);
                      }

                      readProvider.setCodesStock(stockList);
                      if (readProvider.codesStock.isEmpty) {
                        hintStock = "";
                      } else {
                        hintStock = "";

                        hintStock = readProvider.codesStock
                            .map((e) => e.branchName!)
                            .join(', ');
                        // Removing the last comma and space if exists
                        if (hintStock.endsWith(', ')) {
                          hintStock =
                              hintStock.substring(0, hintStock.length - 2);
                        }
                      }

                      setState(() {});
                    },

                    onSearch: (text) {
                      DropDownSearchCriteria dropDownSearchCriteria =
                          getSearchCriteria(text);

                      return salesReportController
                          .getSalesStkMethod(dropDownSearchCriteria.toJson());
                    },
                  ),
                );
              }),
            ),
            SizedBox(
              width: width * 0.0015,
            ),
            CustomTextField2(
              text: Text(_locale.modelNo),
              width: width * 0.13,

              // label: _locale.modelNo,
              controller: modelNoController,
              onSubmitted: (text) {
                readProvider.setModelNo(modelNoController.text);
              },
              onChanged: (value) {
                readProvider.setModelNo(modelNoController.text);
              },
            ),
          ],
        ),
        SizedBox(
          height: height * .01,
        ),
        Row(
          children: [
            // SizedBox(
            //   width: width * 0.0015,
            // ),
            DropDown(
              showClearIcon: true,
              onClearIconPressed: () {
                setState(() {
                  if (selectedValue1.isNotEmpty &&
                      ordersMap[selectedValue1] != null &&
                      ordersMap[selectedValue2] != ordersMap[selectedValue1] &&
                      ordersMap[selectedValue3] != ordersMap[selectedValue1] &&
                      ordersMap[selectedValue4] != ordersMap[selectedValue1]) {
                    ordersList.remove(ordersMap[selectedValue1]);
                    if (readProvider.getOrders != null) {
                      readProvider.getOrders!.remove(ordersMap[selectedValue1]);
                    }
                  }
                  selectedValue1 = "";
                  readProvider.setVal1("");
                  readProvider.setOrders(ordersList);
                  widget.onSelectedValueChanged1("");
                });
              },
              bordeText: _locale.orderBy + " 1",
              items: firstList,
              // label: "",
              width: isDesktop ? width * .14 : width * .35,
              height: isDesktop
                  ? height * 0.045
                  : height * 0.35, // hint: selectedValue1,
              initialValue: selectedValue1.isNotEmpty ? selectedValue1 : null,
              valSelected: selectedValue1 != "",
              onChanged: (value) {
                if (value == null) {
                  setState(() {
                    selectedValue1 = "";

                    readProvider.setVal1(selectedValue1);
                    //  readProvider.setIndexMap(0, ordersMap[selectedValue1]!);
                    widget.onSelectedValueChanged1(selectedValue1);
                  });
                } else {
                  setState(() {
                    // print("valvalvalvalval111 $value");

                    selectedValue1 = value!;
                    // print("valvalvalvalval222 $selectedValue1");
                    // if (ordersMap[selectedValue1] != 0) {
                    //   if (ordersList.contains(ordersMap[selectedValue1]!) ==
                    //       false) {
                    //     ordersList.add(ordersMap[selectedValue1]!);

                    //     readProvider.setOrders(ordersList);
                    //   }
                    // } else {
                    //   if (readProvider.getVal1 != "") {
                    //     ordersList.remove(ordersMap[readProvider.getVal1]);
                    //   }
                    // }
                    readProvider.setVal1(selectedValue1);
                    //  readProvider.setIndexMap(0, ordersMap[selectedValue1]!);
                    widget.onSelectedValueChanged1(selectedValue1);
                  });
                }

                setOrderList();
              },
            ),
            SizedBox(
              width: width * 0.0015,
            ),
            DropDown(
              onClearIconPressed: () {
                setState(() {
                  if (selectedValue2.isNotEmpty &&
                      ordersMap[selectedValue2] != null &&
                      ordersMap[selectedValue1] != ordersMap[selectedValue2] &&
                      ordersMap[selectedValue3] != ordersMap[selectedValue2] &&
                      ordersMap[selectedValue4] != ordersMap[selectedValue2]) {
                    ordersList.remove(ordersMap[selectedValue2]);
                    if (readProvider.getOrders != null) {
                      readProvider.getOrders!.remove(ordersMap[selectedValue2]);
                    }
                  }
                  selectedValue2 = "";
                  readProvider.setVal2("");
                  readProvider.setOrders(ordersList);
                  widget.onSelectedValueChanged2("");
                });
              },
              showClearIcon: true,
              bordeText: _locale.orderBy + " 2",
              // label: "",
              // width: isDesktop ? null : width * .55,
              items: firstList,
              // hint: selectedValue2,
              initialValue: selectedValue2.isNotEmpty ? selectedValue2 : null,
              width: isDesktop ? width * .14 : width * .35,
              height: isDesktop ? height * 0.045 : height * 0.35,
              valSelected: selectedValue2 != "",
              onChanged: (value) {
                if (value == null) {
                  setState(() {
                    selectedValue2 = "";
                    readProvider.setVal2(selectedValue2);
                    widget.onSelectedValueChanged2(selectedValue2);
                  });
                } else {
                  setState(() {
                    selectedValue2 = value!;
                    // if (ordersMap[selectedValue2] != 0) {
                    //   if (ordersList.contains(ordersMap[selectedValue2]!) ==
                    //       false) {
                    //     ordersList.add(ordersMap[selectedValue2]!);
                    //     readProvider.setOrders(ordersList);
                    //   }
                    // } else {
                    //   if (readProvider.getVal2 != "") {
                    //     ordersList.remove(ordersMap[readProvider.getVal2]);
                    //   }
                    // }

                    readProvider.setVal2(selectedValue2);

                    widget.onSelectedValueChanged2(selectedValue2);
                  });
                }
                setOrderList();
              },
            ),
            SizedBox(
              width: width * 0.0015,
            ),
            DropDown(
              showClearIcon: true,

              onClearIconPressed: () {
                setState(() {
                  if (selectedValue3.isNotEmpty &&
                      ordersMap[selectedValue3] != null &&
                      ordersMap[selectedValue1] != ordersMap[selectedValue3] &&
                      ordersMap[selectedValue2] != ordersMap[selectedValue3] &&
                      ordersMap[selectedValue4] != ordersMap[selectedValue3]) {
                    ordersList.remove(ordersMap[selectedValue3]);
                    if (readProvider.getOrders != null) {
                      readProvider.getOrders!.remove(ordersMap[selectedValue3]);
                    }
                  }
                  selectedValue3 = "";
                  readProvider.setVal3("");
                  readProvider.setOrders(ordersList);
                  widget.onSelectedValueChanged3("");
                });
              },
              bordeText: _locale.orderBy + " 3",
              // width: isDesktop ? null : width * .55,
              width: isDesktop ? width * .14 : width * .35,
              height: isDesktop ? height * 0.045 : height * 0.35,
              items: firstList,
              // hint: selectedValue3,
              initialValue: selectedValue3.isNotEmpty ? selectedValue3 : null,
              valSelected: selectedValue3 != "",
              onChanged: (value) {
                if (value == null) {
                  setState(() {
                    selectedValue3 = "";
                    readProvider.setVal3(selectedValue3);
                    widget.onSelectedValueChanged3(selectedValue3);
                  });
                } else {
                  setState(() {
                    selectedValue3 = value!;
                    // if (ordersMap[selectedValue3] != 0) {
                    //   if (ordersList.contains(ordersMap[selectedValue3]!) ==
                    //       false) {
                    //     ordersList.add(ordersMap[selectedValue3]!);
                    //     readProvider.setOrders(ordersList);
                    //   }
                    // } else {
                    //   if (readProvider.getVal3 != "") {
                    //     ordersList.remove(ordersMap[readProvider.getVal3]);
                    //   }
                    // }

                    // readProvider.setIndexMap(2, ordersMap[selectedValue3]!);
                    readProvider.setVal3(selectedValue3);

                    widget.onSelectedValueChanged3(selectedValue3);
                  });
                }
                setOrderList();
              },
            ),
            SizedBox(
              width: width * 0.0015,
            ),
            DropDown(
              showClearIcon: true,

              onClearIconPressed: () {
                setState(() {
                  if (selectedValue4.isNotEmpty &&
                      ordersMap[selectedValue4] != null &&
                      ordersMap[selectedValue1] != ordersMap[selectedValue4] &&
                      ordersMap[selectedValue2] != ordersMap[selectedValue4] &&
                      ordersMap[selectedValue3] != ordersMap[selectedValue4]) {
                    ordersList.remove(ordersMap[selectedValue4]);
                    if (readProvider.getOrders != null) {
                      readProvider.getOrders!.remove(ordersMap[selectedValue4]);
                    }
                  }
                  selectedValue4 = "";
                  readProvider.setVal4("");
                  readProvider.setOrders(ordersList);
                  widget.onSelectedValueChanged4("");
                });
              },
              bordeText: _locale.orderBy + " 4",
              items: firstList,
              // hint: selectedValue4,
              valSelected: selectedValue4 != "",

              initialValue: selectedValue4.isNotEmpty ? selectedValue4 : null,
              width: isDesktop ? width * .14 : width * .35,
              height: isDesktop ? height * 0.045 : height * 0.35,
              onChanged: (value) {
                if (value == null) {
                  setState(() {
                    selectedValue4 = "";
                    readProvider.setVal4(selectedValue4);
                    widget.onSelectedValueChanged4(selectedValue4);
                  });
                } else {
                  setState(() {
                    selectedValue4 = value!;
                    // if (ordersMap[selectedValue4] != 0) {
                    //   if (ordersList.contains(ordersMap[selectedValue4]!) ==
                    //       false) {
                    //     ordersList.add(ordersMap[selectedValue4]!);
                    //     readProvider.setOrders(ordersList);
                    //   }
                    // } else {
                    //   if (readProvider.getVal4 != "") {
                    //     ordersList.remove(ordersMap[readProvider.getVal4]);
                    //   }
                    // }

                    // readProvider.setIndexMap(3, ordersMap[selectedValue4]!);
                    readProvider.setVal4(selectedValue4);

                    widget.onSelectedValueChanged4(selectedValue4);
                  });
                }
                setOrderList();
              },
            ),
          ],
        ),
        SizedBox(
          height: height * .01,
        ),
      ],
    );
  }

  Column mobileCritiria(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            DateTimeComponent(
              readOnly: false,
              dateWidth: isDesktop ? width * .14 : width * .7,
              height: isDesktop ? height * 0.045 : height * 0.045,
              label: _locale.fromDate,
              dateController: fromDate,
              dateControllerToCompareWith: null,
              isInitiaDate: true,
              onValue: (isValid, value) {
                if (isValid) {
                  setState(() {
                    fromDate.text = value;
                    setFromDateController();
                    context
                        .read<SalesCriteraProvider>()
                        .setFromDate(fromDate.text);
                  });
                }
              },
              timeControllerToCompareWith: null,
            ),
            // SizedBox(
            //   width: width * 0.0015,
            // ),
            DateTimeComponent(
              readOnly: false,
              dateWidth: isDesktop ? width * .14 : width * .7,
              height: isDesktop ? height * 0.045 : height * 0.045,
              label: _locale.toDate,
              dateController: toDate,
              dateControllerToCompareWith: null,
              isInitiaDate: true,
              onValue: (isValid, value) {
                if (isValid) {
                  setState(() {
                    toDate.text = value;
                    setToDateController();
                    context.read<SalesCriteraProvider>().setToDate(toDate.text);
                  });
                }
              },
              timeControllerToCompareWith: null,
            ),
          ],
        ),
        SizedBox(
          height: height * .01,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            //  initialValue: reportsProvider.fromCode!.branchName == null
            //           ? null
            //           : selectedFromCode,
            SizedBox(
              width: width * 0.7,
              height: height * 0.045,
              child: Consumer<SalesCriteraProvider>(
                  builder: (context, value, child) {
                return Tooltip(
                  message: hintStockCatLevel1,
                  child: TestDropdown(
                    cleanPrevSelectedItem: true,
                    isEnabled: true,
                    stringValue: readProvider.codesStockCategory1
                        .map((e) => e.branchName!)
                        .join(', '),
                    // hintStockCatLevel1 ?? _locale.stockCategoryLevel("1"),
                    borderText: _locale.stockCategoryLevel("1"),
                    onClearIconPressed: () {
                      setState(() {
                        stockCatLevel1Codes.clear();
                        hintStockCatLevel1 = "";
                        readProvider.clearCodesStockCategory1();
                      });
                    },
                    onChanged: (val) {
                      stockCatLevel1Codes.clear();
                      for (int i = 0; i < val.length; i++) {
                        stockCatLevel1Codes.add(val[i]);
                      }

                      readProvider.setCodesStockCategory1(stockCatLevel1Codes);
                      if (readProvider.codesStockCategory1.isEmpty) {
                        hintStockCatLevel1 = "";
                      } else {
                        hintStockCatLevel1 = "";

                        hintStockCatLevel1 = readProvider.codesStockCategory1
                            .map((e) => e.branchName!)
                            .join(', ');
                        // Removing the last comma and space if exists
                        if (hintStockCatLevel1.endsWith(', ')) {
                          hintStockCatLevel1 = hintStockCatLevel1.substring(
                              0, hintStockCatLevel1.length - 2);
                        }
                      }

                      setState(() {});
                    },
                    onSearch: (text) async {
                      DropDownSearchCriteria dropDownSearchCriteria =
                          getSearchCriteria(text);
                      List<BranchModel> newList = await salesReportController
                          .getSalesStkCountCateg1Method(dropDownSearchCriteria);

                      return newList;
                    },
                    // bordeText: '',
                  ),
                );
              }),
            ),
            SizedBox(
              height: height * .01,
            ),
            SizedBox(
              width: width * 0.7,
              height: height * 0.045,
              child: Consumer<SalesCriteraProvider>(
                  builder: (context, value, child) {
                return Tooltip(
                  message: hintStockCatLevel3,
                  child: TestDropdown(
                    cleanPrevSelectedItem: true,
                    // icon: const Icon(Icons.search),
                    isEnabled: true,
                    stringValue: readProvider.codesStockCategory3
                        .map((e) => e.branchName!)
                        .join(', '),
                    borderText: _locale.stockCategoryLevel("3"),
                    onClearIconPressed: () {
                      setState(() {
                        stockCatLevel3Codes.clear();
                        hintStockCatLevel3 = "";
                        readProvider.clearCodesStockCategory3();
                      });
                    },
                    onChanged: (val) {
                      stockCatLevel3Codes.clear();
                      for (int i = 0; i < val.length; i++) {
                        stockCatLevel3Codes.add(val[i]);
                      }

                      readProvider.setCodesStockCategory3(stockCatLevel3Codes);
                      if (readProvider.codesStockCategory3.isEmpty) {
                        hintStockCatLevel3 = "";
                      } else {
                        hintStockCatLevel3 = "";

                        hintStockCatLevel3 = readProvider.codesStockCategory3
                            .map((e) => e.branchName!)
                            .join(', ');
                        // Removing the last comma and space if exists
                        if (hintStockCatLevel3.endsWith(', ')) {
                          hintStockCatLevel3 = hintStockCatLevel3.substring(
                              0, hintStockCatLevel3.length - 2);
                        }
                      }

                      setState(() {});
                    },
                    onSearch: (text) async {
                      DropDownSearchCriteria dropDownSearchCriteria =
                          getSearchCriteria(text);
                      List<BranchModel> newList = await salesReportController
                          .getSalesStkCountCateg3Method(dropDownSearchCriteria);

                      return newList;
                    },
                  ),
                );
              }),
            ),
          ],
        ),
        SizedBox(
          height: height * .01,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              width: width * 0.7,
              height: height * 0.045,
              child: Consumer<SalesCriteraProvider>(
                  builder: (context, value, child) {
                return Tooltip(
                  message: hintCustomers,
                  child: TestDropdown(
                    cleanPrevSelectedItem: true,
                    // icon: const Icon(Icons.search),
                    isEnabled: true,
                    stringValue: readProvider.codesCustomer
                        .map((e) => e.branchName!)
                        .join(', '),
                    borderText: _locale.customer,
                    onClearIconPressed: () {
                      setState(() {
                        customersList.clear();
                        hintCustomers = "";
                        readProvider.clearCodeCustomer();
                      });
                    },
                    onChanged: (val) {
                      customersList.clear();
                      for (int i = 0; i < val.length; i++) {
                        customersList.add(val[i]);
                      }

                      readProvider.setCodesCustomer(customersList);
                      if (readProvider.codesCustomer.isEmpty) {
                        hintCustomers = "";
                      } else {
                        hintCustomers = "";

                        hintCustomers = readProvider.codesCustomer
                            .map((e) => e.branchName!)
                            .join(', ');
                        // Removing the last comma and space if exists
                        if (hintCustomers.endsWith(', ')) {
                          hintCustomers = hintCustomers.substring(
                              0, hintCustomers.length - 2);
                        }
                      }

                      setState(() {});
                    },
                    onSearch: (text) async {
                      DropDownSearchCriteria dropDownSearchCriteria =
                          getSearchCriteria(text);
                      List<BranchModel> newList = await salesReportController
                          .getSalesCustomersMethod(dropDownSearchCriteria);

                      return newList;
                    },
                  ),
                );
              }),
            ),
            SizedBox(
              height: height * .01,
            ),
            SizedBox(
              width: width * 0.7,
              height: height * 0.045,
              child: Consumer<SalesCriteraProvider>(
                  builder: (context, value, child) {
                return Tooltip(
                  message: hintBranches,
                  child: TestDropdown(
                    cleanPrevSelectedItem: true,
                    // icon: const Icon(Icons.search),
                    isEnabled: true,
                    stringValue: readProvider.codesBranch
                        .map((e) => e.branchName!)
                        .join(', '),
                    borderText: _locale.branch,
                    onClearIconPressed: () {
                      setState(() {
                        branchesList.clear();
                        hintBranches = "";
                        readProvider.clearBranches();
                      });
                    },
                    onChanged: (val) {
                      branchesList.clear();
                      for (int i = 0; i < val.length; i++) {
                        branchesList.add(val[i]);
                      }

                      readProvider.setCodesBranch(branchesList);
                      if (readProvider.codesBranch.isEmpty) {
                        hintBranches = "";
                      } else {
                        hintBranches = "";

                        hintBranches = readProvider.codesBranch
                            .map((e) => e.branchName!)
                            .join(', ');
                        // Removing the last comma and space if exists
                        if (hintBranches.endsWith(', ')) {
                          hintBranches = hintBranches.substring(
                              0, hintBranches.length - 2);
                        }
                      }

                      setState(() {});
                    },
                    onSearch: (text) async {
                      DropDownSearchCriteria dropDownSearchCriteria =
                          getSearchCriteria(text);
                      List<BranchModel> newList =
                          await salesReportController.getSalesBranchesMethod(
                              dropDownSearchCriteria.toJsonBranch());

                      return newList;
                    },
                  ),
                );
              }),
            ),
          ],
        ),
        SizedBox(
          height: height * .01,
        ),
        Column(
          children: [
            SizedBox(
              width: width * 0.7,
              height: height * 0.045,
              child: Consumer<SalesCriteraProvider>(
                  builder: (context, value, child) {
                return Tooltip(
                  message: hinCodesStockCategory2,
                  child: TestDropdown(
                    cleanPrevSelectedItem: true,
                    // icon: const Icon(Icons.search),
                    isEnabled: true,
                    stringValue: readProvider.codesStockCategory2
                        .map((e) => e.branchName!)
                        .join(', '),
                    onClearIconPressed: () {
                      setState(() {
                        stockCatLevel2Codes.clear();
                        hinCodesStockCategory2 = "";
                        readProvider.clearCodesStockCategory2();
                      });
                    },
                    onChanged: (val) {
                      stockCatLevel2Codes.clear();
                      for (int i = 0; i < val.length; i++) {
                        stockCatLevel2Codes.add(val[i]);
                      }

                      readProvider.setCodesStockCategory2(stockCatLevel2Codes);
                      if (readProvider.codesStockCategory2.isEmpty) {
                        hinCodesStockCategory2 = "";
                      } else {
                        hinCodesStockCategory2 = "";

                        hinCodesStockCategory2 = readProvider
                            .codesStockCategory2
                            .map((e) => e.branchName!)
                            .join(', ');
                        // Removing the last comma and space if exists
                        if (hinCodesStockCategory2.endsWith(', ')) {
                          hinCodesStockCategory2 = hinCodesStockCategory2
                              .substring(0, hinCodesStockCategory2.length - 2);
                        }
                      }

                      setState(() {});
                    },
                    onSearch: (text) async {
                      DropDownSearchCriteria dropDownSearchCriteria =
                          getSearchCriteria(text);
                      List<BranchModel> newList = await salesReportController
                          .getSalesStkCountCateg2Method(
                              dropDownSearchCriteria.toJsonBranch());

                      return newList;
                    },
                    borderText: _locale.stockCategoryLevel("2"),
                  ),
                );
              }),
            ),
            SizedBox(
              height: height * .01,
            ),
            SizedBox(
              width: width * 0.7,
              height: height * 0.045,
              child: Consumer<SalesCriteraProvider>(
                  builder: (context, value, child) {
                return Tooltip(
                  message: hintCodeSuppliers,
                  child: TestDropdown(
                    cleanPrevSelectedItem: true,
                    // icon: const Icon(Icons.search),
                    isEnabled: true,
                    stringValue: readProvider.codesSupplier
                        .map((e) => e.branchName!)
                        .join(', '),
                    borderText: _locale.supplier(""),
                    onClearIconPressed: () {
                      setState(() {
                        codeSuppliersList.clear();
                        hintCodeSuppliers = "";
                        readProvider.clearCodesSupplier();
                      });
                    },
                    onChanged: (val) {
                      codeSuppliersList.clear();
                      for (int i = 0; i < val.length; i++) {
                        codeSuppliersList.add(val[i]);
                      }

                      readProvider.setCodesSupplier(codeSuppliersList);
                      if (readProvider.codesSupplier.isEmpty) {
                        hintCodeSuppliers = "";
                      } else {
                        hintCodeSuppliers = "";

                        hintCodeSuppliers = readProvider.codesSupplier
                            .map((e) => e.branchName!)
                            .join(', ');
                        // Removing the last comma and space if exists
                        if (hintCodeSuppliers.endsWith(', ')) {
                          hintCodeSuppliers = hintCodeSuppliers.substring(
                              0, hintCodeSuppliers.length - 2);
                        }
                      }

                      setState(() {});
                    },
                    onSearch: (text) async {
                      DropDownSearchCriteria dropDownSearchCriteria =
                          getSearchCriteria(text);
                      List<BranchModel> newList =
                          await salesReportController.getSalesSuppliersMethod(
                              dropDownSearchCriteria.toJsonBranch());

                      return newList;
                    },
                  ),
                );
              }),
            ),
            SizedBox(
              height: height * .01,
            ),
            SizedBox(
              width: width * 0.7,
              height: height * 0.045,
              child: Consumer<SalesCriteraProvider>(
                  builder: (context, value, child) {
                return Tooltip(
                  message: hintCustomersCategory,
                  child: TestDropdown(
                    cleanPrevSelectedItem: true,
                    // icon: const Icon(Icons.search),
                    isEnabled: true,
                    stringValue: readProvider.codesCustomerCategory
                        .map((e) => e.branchName!)
                        .join(', '),
                    borderText: _locale.customerCategory,
                    onClearIconPressed: () {
                      setState(() {
                        customersListCategory.clear();
                        hintCustomersCategory = "";
                        readProvider.clearCodeCustomerCategory();
                      });
                    },
                    onChanged: (val) {
                      customersListCategory.clear();
                      for (int i = 0; i < val.length; i++) {
                        customersListCategory.add(val[i]);
                      }

                      readProvider
                          .setCodesCustomerCategory(customersListCategory);
                      if (readProvider.codesCustomerCategory.isEmpty) {
                        hintCustomersCategory = "";
                      } else {
                        hintCustomersCategory = "";

                        hintCustomersCategory = readProvider
                            .codesCustomerCategory
                            .map((e) => e.branchName!)
                            .join(', ');
                        // Removing the last comma and space if exists
                        if (hintCustomersCategory.endsWith(', ')) {
                          hintCustomersCategory = hintCustomersCategory
                              .substring(0, hintCustomersCategory.length - 2);
                        }
                      }

                      setState(() {});
                    },
                    onSearch: (text) async {
                      DropDownSearchCriteria dropDownSearchCriteria =
                          getSearchCriteria(text);
                      List<BranchModel> newList = await salesReportController
                          .getSalesCustomersCategMethod(dropDownSearchCriteria);

                      return newList;
                    },
                  ),
                );
              }),
            ),
            SizedBox(
              height: height * .01,
            ),
            CustomTextField2(
              // isDocReport: true,
              text: Text(_locale.campaignNo),
              width: width * 0.7,
              // isReport: true,
              // label: _locale.campaignNo,
              controller: campaignNoController,
              onSubmitted: (text) {
                readProvider.setCampaignNo(campaignNoController.text);
              },
              onChanged: (value) {
                readProvider.setCampaignNo(campaignNoController.text);
              },
            ),
            SizedBox(
              height: height * .01,
            ),
            SizedBox(
              width: width * 0.7,
              height: height * 0.045,
              child: Consumer<SalesCriteraProvider>(
                  builder: (context, value, child) {
                return Tooltip(
                  message: hintStock,
                  child: TestDropdown(
                    cleanPrevSelectedItem: true,
                    // icon: const Icon(Icons.search),
                    isEnabled: true,
                    stringValue: readProvider.codesStock
                        .map((e) => e.branchName!)
                        .join(', '),
                    borderText: _locale.stock,
                    onClearIconPressed: () {
                      setState(() {
                        stockList.clear();

                        hintStock = "";
                        readProvider.clearStocks();
                      });
                    },
                    onChanged: (val) {
                      stockList.clear();
                      for (int i = 0; i < val.length; i++) {
                        stockList.add(val[i]);
                      }

                      readProvider.setCodesStock(stockList);
                      if (readProvider.codesStock.isEmpty) {
                        hintStock = "";
                      } else {
                        hintStock = "";

                        hintStock = readProvider.codesStock
                            .map((e) => e.branchName!)
                            .join(', ');
                        // Removing the last comma and space if exists
                        if (hintStock.endsWith(', ')) {
                          hintStock =
                              hintStock.substring(0, hintStock.length - 2);
                        }
                      }

                      setState(() {});
                    },

                    onSearch: (text) {
                      DropDownSearchCriteria dropDownSearchCriteria =
                          getSearchCriteria(text);

                      return salesReportController
                          .getSalesStkMethod(dropDownSearchCriteria.toJson());
                    },
                  ),
                );
              }),
            ),
            SizedBox(
              height: height * .01,
            ),
            CustomTextField2(
              text: Text(_locale.modelNo),
              width: width * 0.7,

              // label: _locale.modelNo,
              controller: modelNoController,
              onSubmitted: (text) {
                readProvider.setModelNo(modelNoController.text);
              },
              onChanged: (value) {
                readProvider.setModelNo(modelNoController.text);
              },
            ),
          ],
        ),
        SizedBox(
          height: height * .01,
        ),
        Column(
          children: [
            // SizedBox(
            //   width: width * 0.0015,
            // ),
            DropDown(
              showClearIcon: true,
              onClearIconPressed: () {
                setState(() {
                  if (selectedValue1.isNotEmpty &&
                      ordersMap[selectedValue1] != null &&
                      ordersMap[selectedValue2] != ordersMap[selectedValue1] &&
                      ordersMap[selectedValue3] != ordersMap[selectedValue1] &&
                      ordersMap[selectedValue4] != ordersMap[selectedValue1]) {
                    ordersList.remove(ordersMap[selectedValue1]);
                    if (readProvider.getOrders != null) {
                      readProvider.getOrders!.remove(ordersMap[selectedValue1]);
                    }
                  }
                  selectedValue1 = "";
                  readProvider.setVal1("");
                  readProvider.setOrders(ordersList);
                  widget.onSelectedValueChanged1("");
                });
              },
              bordeText: _locale.orderBy + " 1",
              items: firstList,
              // label: "",
              width: isDesktop ? width * .7 : width * .7,
              height: isDesktop
                  ? height * 0.045
                  : height * 0.045, // hint: selectedValue1,
              initialValue: selectedValue1.isNotEmpty ? selectedValue1 : null,
              valSelected: selectedValue1 != "",
              onChanged: (value) {
                if (value == null) {
                  setState(() {
                    selectedValue1 = "";

                    readProvider.setVal1(selectedValue1);
                    //  readProvider.setIndexMap(0, ordersMap[selectedValue1]!);
                    widget.onSelectedValueChanged1(selectedValue1);
                  });
                } else {
                  setState(() {
                    // print("valvalvalvalval111 $value");

                    selectedValue1 = value!;
                    // print("valvalvalvalval222 $selectedValue1");
                    // if (ordersMap[selectedValue1] != 0) {
                    //   if (ordersList.contains(ordersMap[selectedValue1]!) ==
                    //       false) {
                    //     ordersList.add(ordersMap[selectedValue1]!);

                    //     readProvider.setOrders(ordersList);
                    //   }
                    // } else {
                    //   if (readProvider.getVal1 != "") {
                    //     ordersList.remove(ordersMap[readProvider.getVal1]);
                    //   }
                    // }
                    readProvider.setVal1(selectedValue1);
                    //  readProvider.setIndexMap(0, ordersMap[selectedValue1]!);
                    widget.onSelectedValueChanged1(selectedValue1);
                  });
                }

                setOrderList();
              },
            ),
            SizedBox(
              height: height * .01,
            ),
            DropDown(
              width: width * 0.7,

              onClearIconPressed: () {
                setState(() {
                  if (selectedValue2.isNotEmpty &&
                      ordersMap[selectedValue2] != null &&
                      ordersMap[selectedValue1] != ordersMap[selectedValue2] &&
                      ordersMap[selectedValue3] != ordersMap[selectedValue2] &&
                      ordersMap[selectedValue4] != ordersMap[selectedValue2]) {
                    ordersList.remove(ordersMap[selectedValue2]);
                    if (readProvider.getOrders != null) {
                      readProvider.getOrders!.remove(ordersMap[selectedValue2]);
                    }
                  }
                  selectedValue2 = "";
                  readProvider.setVal2("");
                  readProvider.setOrders(ordersList);
                  widget.onSelectedValueChanged2("");
                });
              },
              showClearIcon: true,
              bordeText: _locale.orderBy + " 2",
              // label: "",
              // width: isDesktop ? null : width * .55,
              items: firstList,
              // hint: selectedValue2,
              initialValue: selectedValue2.isNotEmpty ? selectedValue2 : null,
              height: isDesktop ? height * 0.045 : height * 0.045,
              valSelected: selectedValue2 != "",
              onChanged: (value) {
                if (value == null) {
                  setState(() {
                    selectedValue2 = "";
                    readProvider.setVal2(selectedValue2);
                    widget.onSelectedValueChanged2(selectedValue2);
                  });
                } else {
                  setState(() {
                    selectedValue2 = value!;
                    // if (ordersMap[selectedValue2] != 0) {
                    //   if (ordersList.contains(ordersMap[selectedValue2]!) ==
                    //       false) {
                    //     ordersList.add(ordersMap[selectedValue2]!);
                    //     readProvider.setOrders(ordersList);
                    //   }
                    // } else {
                    //   if (readProvider.getVal2 != "") {
                    //     ordersList.remove(ordersMap[readProvider.getVal2]);
                    //   }
                    // }

                    readProvider.setVal2(selectedValue2);

                    widget.onSelectedValueChanged2(selectedValue2);
                  });
                }
                setOrderList();
              },
            ),
            SizedBox(
              height: height * .01,
            ),
            DropDown(
              showClearIcon: true,

              onClearIconPressed: () {
                setState(() {
                  if (selectedValue3.isNotEmpty &&
                      ordersMap[selectedValue3] != null &&
                      ordersMap[selectedValue1] != ordersMap[selectedValue3] &&
                      ordersMap[selectedValue2] != ordersMap[selectedValue3] &&
                      ordersMap[selectedValue4] != ordersMap[selectedValue3]) {
                    ordersList.remove(ordersMap[selectedValue3]);
                    if (readProvider.getOrders != null) {
                      readProvider.getOrders!.remove(ordersMap[selectedValue3]);
                    }
                  }
                  selectedValue3 = "";
                  readProvider.setVal3("");
                  readProvider.setOrders(ordersList);
                  widget.onSelectedValueChanged3("");
                });
              },
              bordeText: _locale.orderBy + " 3",
              // width: isDesktop ? null : width * .55,
              width: width * 0.7,
              height: isDesktop ? height * 0.045 : height * 0.045,
              items: firstList,
              // hint: selectedValue3,
              initialValue: selectedValue3.isNotEmpty ? selectedValue3 : null,
              valSelected: selectedValue3 != "",
              onChanged: (value) {
                if (value == null) {
                  setState(() {
                    selectedValue3 = "";
                    readProvider.setVal3(selectedValue3);
                    widget.onSelectedValueChanged3(selectedValue3);
                  });
                } else {
                  setState(() {
                    selectedValue3 = value!;
                    // if (ordersMap[selectedValue3] != 0) {
                    //   if (ordersList.contains(ordersMap[selectedValue3]!) ==
                    //       false) {
                    //     ordersList.add(ordersMap[selectedValue3]!);
                    //     readProvider.setOrders(ordersList);
                    //   }
                    // } else {
                    //   if (readProvider.getVal3 != "") {
                    //     ordersList.remove(ordersMap[readProvider.getVal3]);
                    //   }
                    // }

                    // readProvider.setIndexMap(2, ordersMap[selectedValue3]!);
                    readProvider.setVal3(selectedValue3);

                    widget.onSelectedValueChanged3(selectedValue3);
                  });
                }
                setOrderList();
              },
            ),
            SizedBox(
              height: height * .01,
            ),
            DropDown(
              showClearIcon: true,

              onClearIconPressed: () {
                setState(() {
                  if (selectedValue4.isNotEmpty &&
                      ordersMap[selectedValue4] != null &&
                      ordersMap[selectedValue1] != ordersMap[selectedValue4] &&
                      ordersMap[selectedValue2] != ordersMap[selectedValue4] &&
                      ordersMap[selectedValue3] != ordersMap[selectedValue4]) {
                    ordersList.remove(ordersMap[selectedValue4]);
                    if (readProvider.getOrders != null) {
                      readProvider.getOrders!.remove(ordersMap[selectedValue4]);
                    }
                  }
                  selectedValue4 = "";
                  readProvider.setVal4("");
                  readProvider.setOrders(ordersList);
                  widget.onSelectedValueChanged4("");
                });
              },
              bordeText: _locale.orderBy + " 4",
              items: firstList,
              // hint: selectedValue4,
              valSelected: selectedValue4 != "",

              initialValue: selectedValue4.isNotEmpty ? selectedValue4 : null,
              width: width * 0.7,

              height: isDesktop ? height * 0.045 : height * 0.045,
              onChanged: (value) {
                if (value == null) {
                  setState(() {
                    selectedValue4 = "";
                    readProvider.setVal4(selectedValue4);
                    widget.onSelectedValueChanged4(selectedValue4);
                  });
                } else {
                  setState(() {
                    selectedValue4 = value!;
                    // if (ordersMap[selectedValue4] != 0) {
                    //   if (ordersList.contains(ordersMap[selectedValue4]!) ==
                    //       false) {
                    //     ordersList.add(ordersMap[selectedValue4]!);
                    //     readProvider.setOrders(ordersList);
                    //   }
                    // } else {
                    //   if (readProvider.getVal4 != "") {
                    //     ordersList.remove(ordersMap[readProvider.getVal4]);
                    //   }
                    // }

                    // readProvider.setIndexMap(3, ordersMap[selectedValue4]!);
                    readProvider.setVal4(selectedValue4);

                    widget.onSelectedValueChanged4(selectedValue4);
                  });
                }
                setOrderList();
              },
            ),
          ],
        ),
        // SizedBox(
        //   height: height * .01,
        // ),
      ],
    );
  }
  //================================================

  DropDownSearchCriteria getSearchCriteria(String text) {
    DropDownSearchCriteria dropDownSearchCriteria = DropDownSearchCriteria(
        fromDate: DatesController().formatDate(fromDate.text),
        toDate: DatesController().formatDate(toDate.text),
        nameCode: text);
    return dropDownSearchCriteria;
  }

  void getCategory1List() {
    List<String> stringStkCategory1List = [];

    if (selectedFromStkCategory1Code.isNotEmpty) {
      stringStkCategory1List.add(selectedFromStkCategory1Code);
    }
    if (selectedToStkCategory1Code.isNotEmpty) {
      stringStkCategory1List.add(selectedToStkCategory1Code);
    }
    readProvider.setFromCateg1(selectedFromStkCategory1);
    readProvider.setToCateg1(selectedToStkCategory1);
    // readProvider.setCodesStockCategory1(stringStkCategory1List);
  }

  void getCategory3List() {
    List<String> stringStkCategory3List = [];

    if (selectedFromStkCategory3Code.isNotEmpty) {
      stringStkCategory3List.add(selectedFromStkCategory3Code);
    }
    if (selectedToStkCategory3Code.isNotEmpty) {
      stringStkCategory3List.add(selectedToStkCategory3Code);
    }
    readProvider.setFromCateg3(selectedFromStkCategory3);
    readProvider.setToCateg3(selectedToStkCategory3);
    // readProvider.setCodesStockCategory3(stringStkCategory3List);
  }

  void getCustomerList() {
    List<String> stringCustomerList = [];

    if (selectedFromCustomersCode.isNotEmpty) {
      stringCustomerList.add(selectedFromCustomersCode);
    }
    if (selectedToCustomersCode.isNotEmpty) {
      stringCustomerList.add(selectedToCustomersCode);
    }
    readProvider.setFromCust(selectedFromCustomers);
    readProvider.setToCust(selectedToCustomers);
    // readProvider.setCodesCustomer(stringCustomerList);
  }

  void getStockList() {
    List<String> stringStockList = [];

    if (selectedFromStocksCode.isNotEmpty) {
      stringStockList.add(selectedFromStocksCode);
    }
    if (selectedToStocksCode.isNotEmpty) {
      stringStockList.add(selectedToStocksCode);
    }
    readProvider.setFromStock(selectedFromStocks);
    readProvider.setToStock(selectedToStocks);
    // readProvider.setCodesStock(stringStockList);
  }

  List<String> getCodesList(List<dynamic> val) {
    List<String> codesString = [];
    for (int i = 0; i < val.length; i++) {
      String newString = (val[i].toString().trim()).replaceAll(" ", "");
      codesString.add(newString.substring(0, newString.indexOf("-")));
    }
    return codesString;
  }

  List<String> getStringList(List<dynamic> val) {
    List<String> codesString = [];
    for (int i = 0; i < val.length; i++) {
      String newString = (val[i].toString().trim()).replaceAll(" ", "");
      codesString.add(newString);
    }
    return codesString;
  }

  void setFromDateController() {
    String fromDateValue = fromDate.text;
    String startDate = DatesController().formatDate(fromDateValue);

    setState(() {
      DateTime from = DateTime.parse(fromDate.text);
      DateTime to = DateTime.parse(toDate.text);

      if (from.isAfter(to)) {
        ErrorController.openErrorDialog(1, _locale.startDateAfterEndDate);
      }
      readProvider.setFromDate(startDate);
    });
  }

  void setToDateController() {
    String toDateValue = toDate.text;
    String endDate = DatesController().formatDate(toDateValue);
    setState(() {
      DateTime from = DateTime.parse(fromDate.text);
      DateTime to = DateTime.parse(toDate.text);

      if (from.isAfter(to)) {
        ErrorController.openErrorDialog(1, _locale.startDateAfterEndDate);
      }
      readProvider.setToDate(endDate);
    });
  }

  DropDownSearchCriteria getSearchCriteriaPage(String text) {
    DropDownSearchCriteria dropDownSearchCriteria = DropDownSearchCriteria(
        fromDate: DatesController().formatDate(DatesController()
            .formatDateReverse(readProvider.getFromDate.toString())),
        toDate: DatesController().formatDate(DatesController()
            .formatDateReverse(readProvider.getToDate.toString())),
        nameCode: text,
        page: 1);
    return dropDownSearchCriteria;
  }

  void setOrderList() {
    ordersList = [];
    Set<int> intMap = {};
    if (ordersMap[readProvider.getVal1] != null) {
      intMap.add(ordersMap[readProvider.getVal1]!);
    }
    if (ordersMap[readProvider.getVal2] != null) {
      intMap.add(ordersMap[readProvider.getVal2]!);
    }
    if (ordersMap[readProvider.getVal3] != null) {
      intMap.add(ordersMap[readProvider.getVal3]!);
    }
    if (ordersMap[readProvider.getVal4] != null) {
      intMap.add(ordersMap[readProvider.getVal4]!);
    }

    intMap.forEach((element) {
      ordersList.add(element);
    });
    readProvider.setOrders(ordersList);
  }
}

//============================================================================
class RightWidget extends StatefulWidget {
  RightWidget({Key? key}) : super(key: key);
  double unused = 0;

  @override
  State<RightWidget> createState() => _RightWidgetState();
}

class _RightWidgetState extends State<RightWidget> {
  ReportController salesReportController = ReportController();
  TextEditingController campaignNoController = TextEditingController();
  TextEditingController modelNoController = TextEditingController();

  var selectedFromStkCategory2 = "";
  var selectedToStkCategory2 = "";

  var selectedFromBranches = "";
  var selectedToBranches = "";

  var selectedFromSupplier = "";
  var selectedToSupplier = "";

  var selectedFromCustomerCategory = "";
  var selectedToCustomerCategory = "";

  var selectedFromStkCategory2Code = "";
  var selectedToStkCategory2Code = "";

  var selectedFromBranchesCode = "";
  var selectedToBranchesCode = "";

  var selectedFromSupplierCode = "";
  var selectedToSupplierCode = "";

  var selectedFromCustomerCategoryCode = "";
  var selectedToCustomerCategoryCode = "";

  bool valueMultipleStkCategory2 = false;
  bool valueMultipleBranches = false;
  bool valueMultipleSupplier = false;
  bool valueMultipleCustomerCategory = false;

  bool valueSelectAllStkCategory2 = false;
  bool valueSelectAllBranches = false;
  bool valueSelectAllSupplier = false;
  bool valueSelectAllCustomerCategory = false;

  late AppLocalizations _locale;
  late SalesCriteraProvider readProvider;
  double width = 0;
  double height = 0;
  bool isDesktop = false;
  // bool isMobile = false;

  bool isMobile = false;

  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context)!;
    readProvider = context.read<SalesCriteraProvider>();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    isDesktop = Responsive.isDesktop(context);
    isMobile = Responsive.isMobile(context);
    // String todayDate = DatesController().formatDateReverse(
    //     DatesController().formatDate(DatesController().todayDate()));
    // widget.fromDate.text = readProvider.getFromDate!.isNotEmpty
    //     ? DatesController()
    //         .formatDateReverse(readProvider.getFromDate.toString())
    //     : todayDate;

    // widget.toDate.text = readProvider.getToDate!.isNotEmpty
    //     ? DatesController().formatDateReverse(readProvider.getToDate.toString())
    //     : todayDate;

    selectedFromStkCategory2 = readProvider.getFromCateg2!;
    selectedToStkCategory2 = readProvider.getToCateg2!;

    selectedFromBranches = readProvider.getFromBranch!;
    selectedToBranches = readProvider.getToBranch!;

    selectedFromSupplier = readProvider.getFromSupp!;
    selectedToSupplier = readProvider.getToSupp!;

    selectedFromCustomerCategory = readProvider.getFromCustCateg!;
    selectedToCustomerCategory = readProvider.getToCustCateg!;
    valueMultipleStkCategory2 = readProvider.getCheckMultipleStockCategory2!;
    valueMultipleBranches = readProvider.getCheckMultipleBranch!;
    valueMultipleSupplier = readProvider.getCheckMultipleSupplier!;
    valueMultipleCustomerCategory =
        readProvider.getCheckMultipleCustomerCategory!;

    valueSelectAllStkCategory2 = readProvider.getCheckAllStockCategory2!;
    valueSelectAllBranches = readProvider.getCheckAllBranch!;
    valueSelectAllSupplier = readProvider.getCheckAllSupplier!;
    valueSelectAllCustomerCategory = readProvider.getCheckAllCustomerCategory!;

    modelNoController.text = readProvider.getModelNo!;
    campaignNoController.text = readProvider.getCampaignNo!;
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.center,

      children: [
        // CardComponent(
        //   // title:
        //   //         _locale.branch,
        //   multipleVal: valueMultipleBranches,
        //   fromDropDown: DropDown(
        //     onClearIconPressed: (() {
        //       selectedFromBranches = "";
        //     }),
        //     bordeText: _locale.branch,
        //     // showSearchBox: true,
        //     // label: _locale.from,
        //     width: isDesktop ? width * .14 : width * .35,
        //     height: isDesktop ? height * 0.045 : height * 0.35,
        //     // items: branchesList,
        //     // hint: selectedFromBranches.isNotEmpty
        //     //     ? selectedFromBranches
        //     //     : _locale.select,
        //     valSelected: selectedFromBranches != "",
        //     initialValue:
        //         selectedFromBranches.isNotEmpty ? selectedFromBranches : null,
        //     onChanged: (value) {
        //       if (value == null) {
        //         selectedFromBranches = "";
        //         selectedFromBranchesCode = "";
        //         getBranchList();
        //       } else {
        //         setState(() {
        //           selectedFromBranches = value.toString();
        //           selectedFromBranchesCode = value.codeToString();
        //           getBranchList();
        //         });
        //       }
        //     },
        //     onSearch: (text) {
        //       DropDownSearchCriteria dropDownSearchCriteria =
        //           getSearchBranches(text);
        //       return salesReportController.getSalesBranchesMethod(
        //           dropDownSearchCriteria.toJsonBranch());
        //     },
        //   ),
        //   toDropDown: DropDown(
        //     bordeText: _locale.branch,
        //     // showSearchBox: true,
        //     // label: _locale.to,
        //     height: isDesktop ? height * 0.045 : height * 0.35,
        //     width: isDesktop ? width * .14 : width * .35,
        //     // items: branchesList,
        //     // hint: selectedToBranches.isNotEmpty
        //     //     ? selectedToBranches
        //     //     : _locale.select,
        //     initialValue:
        //         selectedToBranches.isNotEmpty ? selectedToBranches : null,
        //     valSelected: selectedToBranchesCode != "",
        //     onChanged: (value) {
        //       if (value == null) {
        //         setState(() {
        //           selectedToBranches = "";
        //           selectedToBranchesCode = "";
        //           getBranchList();
        //         });
        //       } else {
        //         setState(() {
        //           selectedToBranches = value.toString();
        //           selectedToBranchesCode = value.codeToString();
        //           getBranchList();
        //         });
        //       }
        //     },
        //     onSearch: (text) {
        //       DropDownSearchCriteria dropDownSearchCriteria =
        //           getSearchBranches(text);
        //       return salesReportController.getSalesBranchesMethod(
        //           dropDownSearchCriteria.toJsonBranch());
        //     },
        //   ),
        //   selectAll: Checkbox(
        //       value: valueSelectAllBranches,
        //       onChanged: (val) {
        //         valueSelectAllBranches = val!;
        //         readProvider.setCheckAllBranch(valueSelectAllBranches);

        //         readProvider.setCodesBranch([]);

        //         setState(() {});
        //       }),
        //   multipleCheckBox: Checkbox(
        //       value: valueMultipleBranches,
        //       onChanged: (val) {
        //         valueMultipleBranches = val!;
        //         readProvider.setCheckMultipleBranch(valueMultipleBranches);

        //         readProvider.setCodesBranch([]);
        //         readProvider.setBranchList([]);
        //         readProvider.setFromBranch("");
        //         readProvider.setToBranch("");
        //         selectedFromBranches = "";
        //         selectedToBranches = "";
        //         setState(() {});
        //       }),
        //   multipleSearch: SimpleDropdownSearch(
        //     // list: branchesList,
        //     enabled: !valueSelectAllBranches,
        //     hintString: readProvider.getBranchList == null
        //         ? []
        //         : readProvider.getBranchList!,
        //     onChanged: (val) {
        //       setState(() {
        //         readProvider.setCodesBranch(getCodesList(val));
        //         readProvider.setBranchList(getStringList(val));
        //       });
        //     },
        //     onSearch: (text) {
        //       DropDownSearchCriteria dropDownSearchCriteria =
        //           getSearchCriteria(text);
        //       return salesReportController
        //           .getSalesBranchesMethod(dropDownSearchCriteria.toJson());
        //     },
        //     bordeText: '',
        //   ),
        // ),

        SizedBox(
          height: height * .01,
        ),
        // CardComponent(
        //   // title:
        //   //     '                                                                   ' +
        //   //         _locale.stockCategoryLevel("2"),
        //   multipleVal: valueMultipleStkCategory2,
        //   fromDropDown: DropDown(
        //     bordeText: _locale.stockCategoryLevel("2"),
        //     // showSearchBox: true,
        //     // label: _locale.from,
        //     width: isDesktop ? width * .14 : width * .35,
        //     height: isDesktop ? height * 0.045 : height * 0.35,
        //     // items: stkCategory2List,
        //     // hint: selectedFromStkCategory2.isNotEmpty
        //     //     ? selectedFromStkCategory2
        //     //     : _locale.select,
        //     initialValue: selectedFromStkCategory2.isNotEmpty
        //         ? selectedFromStkCategory2
        //         : null,
        //     valSelected: selectedFromStkCategory2Code != "",
        //     onChanged: (value) {
        //       if (value == null) {
        //         setState(() {
        //           selectedFromStkCategory2 = "";
        //           selectedFromStkCategory2Code = "";
        //           getCategory2List();
        //         });
        //       } else {
        //         setState(() {
        //           selectedFromStkCategory2 = value.toString();
        //           selectedFromStkCategory2Code = value.codeToString();
        //           getCategory2List();
        //         });
        //       }
        //     },
        //     onSearch: (text) {
        //       DropDownSearchCriteria dropDownSearchCriteria =
        //           getSearchCriteriaPage(text);
        //       return salesReportController.getSalesStkCountCateg2Method(
        //           dropDownSearchCriteria.toJson2());
        //     },
        //   ),
        //   toDropDown: DropDown(
        //     bordeText: _locale.stockCategoryLevel("2"),
        //     // showSearchBox: true,
        //     // label: _locale.to,
        //     height: isDesktop ? height * 0.045 : height * 0.35,
        //     width: isDesktop ? width * .14 : width * .35,
        //     // hint: selectedToStkCategory2.isNotEmpty
        //     //     ? selectedToStkCategory2
        //     //     : _locale.select,
        //     initialValue: selectedToStkCategory2.isNotEmpty
        //         ? selectedToStkCategory2
        //         : null,
        //     valSelected: selectedToStkCategory2Code != "",
        //     onChanged: (value) {
        //       if (value == null) {
        //         setState(() {
        //           selectedToStkCategory2 = "";
        //           selectedToStkCategory2Code = "";
        //           getCategory2List();
        //         });
        //       } else {
        //         setState(() {
        //           selectedToStkCategory2 = value.toString();
        //           selectedToStkCategory2Code = value.codeToString();
        //           getCategory2List();
        //         });
        //       }
        //     },
        //     onSearch: (text) {
        //       DropDownSearchCriteria dropDownSearchCriteria =
        //           getSearchCriteriaPage(text);
        //       return salesReportController.getSalesStkCountCateg2Method(
        //           dropDownSearchCriteria.toJson2());
        //     },
        //   ),
        //   selectAll: Checkbox(
        //       value: valueSelectAllStkCategory2,
        //       onChanged: (val) {
        //         valueSelectAllStkCategory2 = val!;
        //         readProvider
        //             .setCheckAllStockCategory2(valueSelectAllStkCategory2);

        //         readProvider.setCodesStockCategory2([]);

        //         setState(() {});
        //       }),
        //   multipleCheckBox: Checkbox(
        //       value: valueMultipleStkCategory2,
        //       onChanged: (val) {
        //         valueMultipleStkCategory2 = val!;
        //         readProvider
        //             .setCheckMultipleStockCategory2(valueMultipleStkCategory2);

        //         readProvider.setCodesStockCategory2([]);
        //         readProvider.setStkCat2List([]);
        //         readProvider.setFromCateg2("");
        //         readProvider.setToCateg2("");
        //         selectedFromStkCategory2 = "";
        //         selectedToStkCategory2 = "";
        //         setState(() {});
        //       }),
        //   multipleSearch: SimpleDropdownSearch(
        //     // list: stkCategory2List,
        //     enabled: !valueSelectAllStkCategory2,
        //     hintString: readProvider.getStkCat2List == null
        //         ? []
        //         : readProvider.getStkCat2List!,
        //     onChanged: (val) {
        //       setState(() {
        //         // readProvider.setCodesStockCategory2(getCodesList(val));
        //         readProvider.setStkCat2List(getStringList(val));
        //       });
        //     },
        //     onSearch: (text) {
        //       DropDownSearchCriteria dropDownSearchCriteria =
        //           getSearchCriteriaPage(text);
        //       return salesReportController.getSalesStkCountCateg2Method(
        //           dropDownSearchCriteria.toJson2());
        //     },
        //     bordeText: '',
        //   ),
        // ),
        SizedBox(
          height: height * .01,
        ),
        // CardComponent(
        //     // title: _locale.supplier(""),
        //     multipleVal: valueMultipleSupplier,
        //     fromDropDown: DropDown(
        //       bordeText: _locale.supplier(""),
        //       // showSearchBox: true,
        //       // label: _locale.from,
        //       valSelected: selectedFromSupplierCode != "",
        //       width: isDesktop ? width * .14 : width * .35,
        //       height: isDesktop ? height * 0.045 : height * 0.35,
        //       // items: suppliersList,
        //       // hint: selectedFromSupplier.isNotEmpty
        //       //     ? selectedFromSupplier
        //       //     : _locale.select,
        //       initialValue:
        //           selectedFromSupplier.isNotEmpty ? selectedFromSupplier : null,
        //       onChanged: (value) {
        //         if (value == null) {
        //           setState(() {
        //             selectedFromSupplier = "";
        //             selectedFromSupplierCode = "";
        //             getSupplierList();
        //           });
        //         } else {
        //           setState(() {
        //             selectedFromSupplier = value.toString();
        //             selectedFromSupplierCode = value.codeToString();
        //             getSupplierList();
        //           });
        //         }
        //       },
        //       onSearch: (text) {
        //         DropDownSearchCriteria dropDownSearchCriteria =
        //             getSearchBranches(text);
        //         return salesReportController.getSalesSuppliersMethod(
        //             dropDownSearchCriteria.toJsonBranch());
        //       },
        //     ),
        //     toDropDown: DropDown(
        //       bordeText: _locale.supplier(""),
        //       // showSearchBox: true,
        //       // label: _locale.to,
        //       height: isDesktop ? height * 0.045 : height * 0.35,
        //       width: isDesktop ? width * .14 : width * .35,
        //       // hint: selectedToSupplier.isNotEmpty
        //       //     ? selectedToSupplier
        //       //     : _locale.select,
        //       initialValue:
        //           selectedToSupplier.isNotEmpty ? selectedToSupplier : null,
        //       valSelected: selectedToSupplierCode != "",
        //       onChanged: (value) {
        //         if (value == null) {
        //           setState(() {
        //             selectedToSupplier = "";
        //             selectedToSupplierCode = "";
        //             getSupplierList();
        //           });
        //         } else {
        //           setState(() {
        //             selectedToSupplier = value.toString();
        //             selectedToSupplierCode = value.codeToString();
        //             getSupplierList();
        //           });
        //         }
        //       },
        //       onSearch: (text) {
        //         DropDownSearchCriteria dropDownSearchCriteria =
        //             getSearchBranches(text);
        //         return salesReportController.getSalesSuppliersMethod(
        //             dropDownSearchCriteria.toJsonBranch());
        //       },
        //     ),
        //     selectAll: Checkbox(
        //         value: valueSelectAllSupplier,
        //         onChanged: (val) {
        //           valueSelectAllSupplier = val!;
        //           readProvider.setCheckAllSupplier(valueSelectAllSupplier);

        //           readProvider.setCodesSupplier([]);
        //           setState(() {});
        //         }),
        //     multipleCheckBox: Checkbox(
        //         value: valueMultipleSupplier,
        //         onChanged: (val) {
        //           valueMultipleSupplier = val!;
        //           readProvider.setCheckMultipleSupplier(valueMultipleSupplier);

        //           readProvider.setCodesSupplier([]);
        //           readProvider.setSupplierList([]);
        //           readProvider.setFromSupp("");
        //           readProvider.setToSupp("");
        //           selectedFromSupplier = "";
        //           selectedToSupplier = "";
        //           setState(() {});
        //         }),
        //     multipleSearch: SimpleDropdownSearch(
        //       // list: suppliersList,
        //       enabled: !valueSelectAllSupplier,
        //       hintString: readProvider.getSupplierList == null
        //           ? []
        //           : readProvider.getSupplierList!,
        //       onChanged: (val) {
        //         setState(() {
        //           readProvider.setCodesSupplier(getCodesList(val));
        //           readProvider.setSupplierList(getStringList(val));
        //         });
        //       },
        //       onSearch: (text) {
        //         DropDownSearchCriteria dropDownSearchCriteria =
        //             getSearchBranches(text);
        //         return salesReportController.getSalesSuppliersMethod(
        //             dropDownSearchCriteria.toJsonBranch());
        //       },
        //       bordeText: '',
        //     )),
        SizedBox(
          height: height * .01,
        ),
        // CardComponent(
        //   // title: _locale.customerCategory,
        //   multipleVal: valueMultipleCustomerCategory,
        //   fromDropDown: DropDown(
        //     bordeText: _locale.customerCategory,
        //     // showSearchBox: true,
        //     // label: _locale.from,
        //     width: isDesktop ? width * .14 : width * .35,
        //     height: isDesktop ? height * 0.045 : height * 0.35,
        //     // hint: selectedFromCustomerCategory.isNotEmpty
        //     //     ? selectedFromCustomerCategory
        //     //     : _locale.select,
        //     initialValue: selectedFromCustomerCategory.isNotEmpty
        //         ? selectedFromCustomerCategory
        //         : null,
        //     valSelected: selectedFromCustomerCategoryCode != "",
        //     onChanged: (value) {
        //       if (value == null) {
        //         setState(() {
        //           selectedFromCustomerCategory = "";
        //           selectedFromCustomerCategoryCode = "";
        //           getCustomerCategoryList();
        //         });
        //       } else {
        //         setState(() {
        //           selectedFromCustomerCategory = value.toString();
        //           selectedFromCustomerCategoryCode = value.codeToString();
        //           getCustomerCategoryList();
        //         });
        //       }
        //     },
        //     onSearch: (text) {
        //       DropDownSearchCriteria dropDownSearchCriteria =
        //           getSearchBranches(text);
        //       return salesReportController.getSalesCustomersCategMethod(
        //           dropDownSearchCriteria.toJsonBranch());
        //     },
        //   ),
        //   toDropDown: DropDown(
        //     // showBorder: selectedToCustomerCategoryCode != "" ? true : false,
        //     bordeText: _locale.customerCategory,
        //     // showSearchBox: true,
        //     // label: _locale.to,
        //     height: isDesktop ? height * 0.045 : height * 0.35,
        //     width: isDesktop ? width * .14 : width * .35,
        //     // hint: selectedToCustomerCategory.isNotEmpty
        //     //     ? selectedToCustomerCategory
        //     //     : _locale.select,
        //     initialValue: selectedToCustomerCategory.isNotEmpty
        //         ? selectedToCustomerCategory
        //         : null,
        //     valSelected: selectedToCustomerCategoryCode != "",
        //     onChanged: (value) {
        //       if (value == null) {
        //         setState(() {
        //           selectedToCustomerCategory = "";
        //           selectedToCustomerCategoryCode = "";
        //           getCustomerCategoryList();
        //         });
        //       } else {
        //         setState(() {
        //           selectedToCustomerCategory = value.toString();
        //           selectedToCustomerCategoryCode = value.codeToString();
        //           getCustomerCategoryList();
        //         });
        //       }
        //     },
        //     onSearch: (text) {
        //       DropDownSearchCriteria dropDownSearchCriteria =
        //           getSearchBranches(text);
        //       return salesReportController.getSalesCustomersCategMethod(
        //           dropDownSearchCriteria.toJsonBranch());
        //     },
        //   ),
        //   selectAll: Checkbox(
        //       value: valueSelectAllCustomerCategory,
        //       onChanged: (val) {
        //         valueSelectAllCustomerCategory = val!;
        //         readProvider.setCheckAllCustomerCategory(
        //             valueSelectAllCustomerCategory);

        //         readProvider.setCodesCustomerCategory([]);
        //         setState(() {});
        //       }),
        //   multipleCheckBox: Checkbox(
        //       value: valueMultipleCustomerCategory,
        //       onChanged: (val) {
        //         valueMultipleCustomerCategory = val!;
        //         readProvider.setCheckMultipleCustomerCategory(
        //             valueMultipleCustomerCategory);

        //         readProvider.setCodesCustomerCategory([]);
        //         readProvider.setCustCateg([]);
        //         readProvider.setFromCustCateg("");
        //         readProvider.setToCustCateg("");
        //         selectedFromCustomerCategory = "";
        //         selectedToCustomerCategory = "";
        //         setState(() {});
        //       }),
        //   multipleSearch: SimpleDropdownSearch(
        //     // list: customerCategoryList,
        //     enabled: !valueSelectAllCustomerCategory,
        //     hintString: readProvider.getCustCateg == null
        //         ? []
        //         : readProvider.getCustCateg!,
        //     onChanged: (val) {
        //       setState(() {
        //         readProvider.setCodesCustomerCategory(getCodesList(val));
        //         readProvider.setCustCateg(getStringList(val));
        //       });
        //     },
        //     onSearch: (text) {
        //       DropDownSearchCriteria dropDownSearchCriteria =
        //           getSearchBranches(text);
        //       return salesReportController.getSalesCustomersCategMethod(
        //           dropDownSearchCriteria.toJsonBranch());
        //     },
        //     bordeText: '',
        //   ),
        // ),
        SizedBox(
          height: height * .01,
        ),
        // Container(
        //   width: isDesktop ? width * 0.39 : width * 0.9,
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(5.0),
        //     border: Border.all(
        //       color: Colors.grey,
        //     ),
        //   ),
        //   padding: const EdgeInsets.all(5.0),
        //   child: isDesktop
        //       ? Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [
        //             CustomTextField2(
        //               width: width * 0.45,
        //               text: Text(_locale.campaignNo),
        //               controller: campaignNoController,
        //               onSubmitted: (text) {
        //                 readProvider.setCampaignNo(campaignNoController.text);
        //               },
        //               onChanged: (value) {
        //                 readProvider.setCampaignNo(campaignNoController.text);
        //               },
        //             ),
        //             CustomTextField2(
        //               width: width * 0.45,
        //               text: Text(_locale.modelNo),
        //               // text: const Text("model No,"),
        //               controller: modelNoController,
        //               onSubmitted: (text) {
        //                 readProvider.setModelNo(modelNoController.text);
        //               },
        //               onChanged: (value) {
        //                 readProvider.setModelNo(modelNoController.text);
        //               },
        //             ),
        //           ],
        //         )
        //       : Column(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             Padding(
        //               padding: const EdgeInsets.all(2.0),
        //               child: CustomTextField2(
        //                 text: Text(_locale.campaignNo),
        //                 width: width * 0.4,
        //                 // label: _locale.campaignNo,
        //                 controller: campaignNoController,
        //                 onSubmitted: (text) {
        //                   readProvider.setCampaignNo(campaignNoController.text);
        //                 },
        //                 onChanged: (value) {
        //                   readProvider.setCampaignNo(campaignNoController.text);
        //                 },
        //               ),
        //             ),
        //             Padding(
        //               padding: const EdgeInsets.all(2.0),
        //               child: CustomTextField2(
        //                 text: Text(_locale.modelNo),
        //                 width: width * 0.4,
        //                 // label: _locale.modelNo,
        //                 controller: modelNoController,
        //                 onSubmitted: (text) {
        //                   readProvider.setModelNo(modelNoController.text);
        //                 },
        //                 onChanged: (value) {
        //                   readProvider.setModelNo(modelNoController.text);
        //                 },
        //               ),
        //             ),
        //           ],
        //         ),
        // ),
      ],
    );
  }

  DropDownSearchCriteria getSearchCriteria(String text) {
    DropDownSearchCriteria dropDownSearchCriteria = DropDownSearchCriteria(
      fromDate: DatesController().formatDate(DatesController()
          .formatDateReverse(readProvider.getFromDate.toString())),
      toDate: DatesController().formatDate(DatesController()
          .formatDateReverse(readProvider.getToDate.toString())),
      nameCode: text,
    );
    return dropDownSearchCriteria;
  }

  DropDownSearchCriteria getSearchBranches(String text) {
    DropDownSearchCriteria dropDownSearchCriteria = DropDownSearchCriteria(
      nameCode: text,
    );
    return dropDownSearchCriteria;
  }

  DropDownSearchCriteria getSearchCriteriaPage(String text) {
    DropDownSearchCriteria dropDownSearchCriteria = DropDownSearchCriteria(
        fromDate: DatesController().formatDate(DatesController()
            .formatDateReverse(readProvider.getFromDate.toString())),
        toDate: DatesController().formatDate(DatesController()
            .formatDateReverse(readProvider.getToDate.toString())),
        nameCode: text,
        page: 1);
    return dropDownSearchCriteria;
  }

  void getBranchList() {
    List<String> stringBranchList = [];

    if (selectedFromBranchesCode.isNotEmpty) {
      stringBranchList.add(selectedFromBranchesCode);
    }
    if (selectedToBranchesCode.isNotEmpty) {
      stringBranchList.add(selectedToBranchesCode);
    }

    readProvider.setFromBranch(selectedFromBranches);
    readProvider.setToBranch(selectedToBranches);
    // readProvider.setCodesBranch(stringBranchList);
  }

  void getCategory2List() {
    List<String> stringStkCategory2List = [];

    if (selectedFromStkCategory2Code.isNotEmpty) {
      stringStkCategory2List.add(selectedFromStkCategory2Code);
    }
    if (selectedToStkCategory2Code.isNotEmpty) {
      stringStkCategory2List.add(selectedToStkCategory2Code);
    }
    readProvider.setFromCateg2(selectedFromStkCategory2);
    readProvider.setToCateg2(selectedToStkCategory2);
    // readProvider.setCodesStockCategory2(stringStkCategory2List);
  }

  void getSupplierList() {
    List<String> stringSupplierList = [];

    if (selectedFromSupplierCode.isNotEmpty) {
      stringSupplierList.add(selectedFromSupplierCode);
    }
    if (selectedToSupplierCode.isNotEmpty) {
      stringSupplierList.add(selectedToSupplierCode);
    }
    readProvider.setFromSupp(selectedFromSupplier);
    readProvider.setToSupp(selectedToSupplier);
    // readProvider.setCodesSupplier(stringSupplierList);
  }

  void getCustomerCategoryList() {
    List<String> stringCustomerCategoryList = [];

    if (selectedFromCustomerCategoryCode.isNotEmpty) {
      stringCustomerCategoryList.add(selectedFromCustomerCategoryCode);
    }
    if (selectedToCustomerCategoryCode.isNotEmpty) {
      stringCustomerCategoryList.add(selectedToCustomerCategoryCode);
    }
    readProvider.setFromCustCateg(selectedFromCustomerCategory);
    readProvider.setToCustCateg(selectedToCustomerCategory);
    // readProvider.setCodesCustomerCategory(stringCustomerCategoryList);
  }

  List<String> getCodesList(List<dynamic> val) {
    List<String> codesString = [];
    for (int i = 0; i < val.length; i++) {
      String newString = (val[i].toString().trim()).replaceAll(" ", "");
      codesString.add(newString.substring(0, newString.indexOf("-")));
    }
    return codesString;
  }

  List<String> getStringList(List<dynamic> val) {
    List<String> codesString = [];
    for (int i = 0; i < val.length; i++) {
      String newString = (val[i].toString().trim()).replaceAll(" ", "");
      codesString.add(newString);
    }
    return codesString;
  }
}
