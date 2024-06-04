import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../../../components/search_table/date_time_component.dart';
import '../../../../../controller/error_controller.dart';
import '../../../../../controller/reports/report_controller.dart';
import '../../../../../model/criteria/drop_down_search_criteria.dart';
import '../../../../../model/sales_adminstration/branch_model.dart';
import '../../../../../provider/purchase_provider.dart';
import '../../../../../utils/constants/responsive.dart';
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
  var selectedFromSuppCateg = "";
  var selectedToSuppCateg = "";

  var selectedFromStkCategory1Code = "";
  var selectedToStkCategory1Code = "";
  var selectedFromStkCategory3Code = "";
  var selectedToStkCategory3Code = "";
  var selectedFromSuppCategCode = "";
  var selectedToSuppCategCode = "";

  bool valueMultipleStkCateg1 = false;
  bool valueMultipleStkCateg3 = false;
  bool valueMultipleSuppCateg = false;
  bool valueSelectAllStkCateg1 = false;
  bool valueSelectAllStkCateg3 = false;
  bool valueSelectAllSuppCateg = false;
  String hintStockCatLevel1 = "";
  List<BranchModel> stockCatLevel1Codes = [];
  String hintStockCatLevel3 = "";
  List<BranchModel> stockCatLevel3Codes = [];
  String hintSupplierCategory = "";
  List<BranchModel> supplierCatList = [];
  late PurchaseCriteraProvider readProvider;
  ReportController purchaseReportController = ReportController();
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  double width = 0;
  double height = 0;
  bool isDesktop = false;
  // bool isMobile = false;
  bool isMobile = false;
  String todayDate = "";
  String currentMonth = "";

  //right widget
  var selectedFromStkCategory2 = "";
  var selectedToStkCategory2 = "";

  var selectedFromBranches = "";
  var selectedToBranches = "";

  var selectedFromSupplier = "";
  var selectedToSupplier = "";
  var selectedFromStocks = "";
  var selectedToStocks = "";

  var selectedFromStkCategory2Code = "";
  var selectedToStkCategory2Code = "";

  var selectedFromBranchesCode = "";
  var selectedToBranchesCode = "";

  var selectedFromSupplierCode = "";
  var selectedToSupplierCode = "";

  var selectedFromStkCode = "";
  var selectedToStkCode = "";

  var selectedFromStocksCode = "";
  var selectedToStocksCode = "";

  bool valueMultipleStkCategory2 = false;
  bool valueMultipleBranches = false;
  bool valueMultipleSupplier = false;
  bool valueMultipleCustomerCategory = false;
  bool valueMultipleStock = false;

  bool valueSelectAllStkCategory2 = false;
  bool valueSelectAllBranches = false;
  bool valueSelectAllSupplier = false;
  bool valueSelectAllCustomerCategory = false;
  bool valueSelectAllStock = false;
  TextEditingController campaignNoController = TextEditingController();
  TextEditingController modelNoController = TextEditingController();
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
  Map<int, String> ordersMap2 = {};

  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context)!;

    readProvider = context.read<PurchaseCriteraProvider>();
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

    // ordersMap[""] = 0;
    ordersMap[_locale.branch] = 1;
    ordersMap[_locale.stockCategoryLevel("1")] = 2;
    ordersMap[_locale.stockCategoryLevel("2")] = 3;
    ordersMap[_locale.stockCategoryLevel("3")] = 4;
    ordersMap[_locale.supp] = 5;
    ordersMap[_locale.stock] = 6;
    ordersMap[_locale.daily] = 7;
    ordersMap[_locale.monthly] = 8;
    ordersMap[_locale.yearly] = 9;
    ordersMap[_locale.brand] = 10;
    ordersMap[_locale.invoice] = 11;

    super.didChangeDependencies();
  }

  @override
  void initState() {
    todayDate = context.read<PurchaseCriteraProvider>().getToDate();
    currentMonth = context.read<PurchaseCriteraProvider>().getFromDate();
    fromDate.text = currentMonth;
    toDate.text = todayDate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    isDesktop = Responsive.isDesktop(context);
    // isMobile = Responsive.isMobile(context);
    isMobile = Responsive.isMobile(context);

    selectedFromStkCategory2 = readProvider.getFromCateg2!;
    selectedToStkCategory2 = readProvider.getToCateg2!;

    selectedFromBranches = readProvider.getFromBranch!;
    selectedToBranches = readProvider.getToBranch!;

    selectedFromSupplier = readProvider.getFromSupp!;
    selectedToSupplier = readProvider.getToSupp!;

    selectedFromStocks = readProvider.getFromstock!;
    selectedToStocks = readProvider.getTostock!;
    valueMultipleStkCategory2 = readProvider.getCheckMultipleStockCategory2!;
    valueMultipleBranches = readProvider.getCheckMultipleBranch!;
    valueMultipleSupplier = readProvider.getCheckMultipleSupplier!;

    valueMultipleStock = readProvider.getCheckMultipleStock!;

    valueSelectAllStkCategory2 = readProvider.getCheckAllStockCategory2!;
    valueSelectAllBranches = readProvider.getCheckAllBranch!;
    valueSelectAllSupplier = readProvider.getCheckAllSupplier!;
    valueSelectAllStock = readProvider.getCheckAllStock!;
    selectedValue1 = readProvider.getVal1!;
    selectedValue2 = readProvider.getVal2!;
    selectedValue3 = readProvider.getVal3!;
    selectedValue4 = readProvider.getVal4!;
    ordersList = readProvider.getOrders == null ? [] : readProvider.getOrders!;

    String todayDate = DatesController().formatDateReverse(
        DatesController().formatDate(DatesController().todayDate()));
    if (readProvider.isHideFilter == true) {
      readProvider.setFromDate(DatesController().formatDate(fromDate.text));

      readProvider.setToDate(DatesController().formatDate(toDate.text));
    }
    selectedFromStkCategory1 = readProvider.getFromCateg1!;

    selectedToStkCategory1 = readProvider.getToCateg1!;

    selectedFromStkCategory3 = readProvider.getFromCateg3!;
    selectedToStkCategory3 = readProvider.getToCateg3!;

    selectedFromSuppCateg = readProvider.getFromSuppCateg!;
    selectedToSuppCateg = readProvider.getToSuppCateg!;

    valueMultipleStkCateg1 = readProvider.getCheckMultipleStockCategory1!;
    valueMultipleStkCateg3 = readProvider.getCheckMultipleStockCategory3!;
    valueMultipleSuppCateg = readProvider.getCheckMultipleSupplierCategory!;

    valueSelectAllStkCateg1 = readProvider.getCheckAllStockCategory1!;
    valueSelectAllStkCateg3 = readProvider.getCheckAllStockCategory3!;
    valueSelectAllSuppCateg = readProvider.getCheckAllSupplierCategory!;

    modelNoController.text = readProvider.getModelNo!;
    campaignNoController.text = readProvider.getCampaignNo!;
    selectedValue1 = readProvider.getVal1!;
    selectedValue2 = readProvider.getVal2!;
    selectedValue3 = readProvider.getVal3!;
    selectedValue4 = readProvider.getVal4!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            DateTimeComponent(
              readOnly: false,
              height: height * 0.045,
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
                        .read<PurchaseCriteraProvider>()
                        .setFromDate(fromDate.text);
                  });
                }
              },
              timeControllerToCompareWith: null,
            ),
            SizedBox(
              width: width * 0.001,
            ),
            DateTimeComponent(
              readOnly: false,
              height: height * 0.045,
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
                    context
                        .read<PurchaseCriteraProvider>()
                        .setToDate(toDate.text);
                  });
                }
              },
              timeControllerToCompareWith: null,
            ),
            SizedBox(
              width: width * .001,
            ),
            SizedBox(
              width: width * 0.14,
              height: height * 0.045,
              child: Consumer<PurchaseCriteraProvider>(
                  builder: (context, value, child) {
                return Tooltip(
                  message: hintStockCatLevel1,
                  child: TestDropdown(
                    cleanPrevSelectedItem: true,
                    isEnabled: true,
                    stringValue: readProvider.codesStockCategory1
                        .map((e) => e.branchName!)
                        .join(', '),
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
              width: width * 0.001,
            ),
            SizedBox(
              width: width * 0.14,
              height: height * 0.045,
              child: Consumer<PurchaseCriteraProvider>(
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
              width: width * 0.001,
            ),
            SizedBox(
              width: width * 0.13,
              height: height * 0.045,
              child: Consumer<PurchaseCriteraProvider>(
                  builder: (context, value, child) {
                return Tooltip(
                  message: hintSupplierCategory,
                  child: TestDropdown(
                    cleanPrevSelectedItem: true,
                    // icon: const Icon(Icons.search),
                    isEnabled: true,
                    stringValue: readProvider.codesSupplierCategory
                        .map((e) => e.branchName!)
                        .join(', '),
                    borderText: _locale.supplierCategory,
                    onClearIconPressed: () {
                      setState(() {
                        supplierCatList.clear();
                        hintSupplierCategory = "";
                        readProvider.clearSupplierCategory();
                      });
                    },
                    onChanged: (val) {
                      supplierCatList.clear();
                      for (int i = 0; i < val.length; i++) {
                        supplierCatList.add(val[i]);
                      }

                      readProvider.setCodesSupplierCategory(supplierCatList);
                      if (readProvider.codesSupplierCategory.isEmpty) {
                        hintSupplierCategory = "";
                      } else {
                        hintSupplierCategory = "";

                        hintSupplierCategory = readProvider
                            .codesSupplierCategory
                            .map((e) => e.branchName!)
                            .join(', ');
                        // Removing the last comma and space if exists
                        if (hintSupplierCategory.endsWith(', ')) {
                          hintSupplierCategory = hintSupplierCategory.substring(
                              0, hintSupplierCategory.length - 2);
                        }
                      }

                      setState(() {});
                    },
                    onSearch: (text) async {
                      DropDownSearchCriteria dropDownSearchCriteria =
                          getSearchCriteria(text);
                      List<BranchModel> newList = await purchaseReportController
                          .getSalesSuppliersCategMethod(dropDownSearchCriteria);

                      return newList;
                    },
                  ),
                );
              }),
            ),
            SizedBox(
              width: width * 0.001,
            ),
            SizedBox(
              width: width * 0.13,
              height: height * 0.045,
              child: Consumer<PurchaseCriteraProvider>(
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
                          getSearchBranches(text);
                      List<BranchModel> newList =
                          await purchaseReportController.getSalesBranchesMethod(
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
              child: Consumer<PurchaseCriteraProvider>(
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
                          getSearchBranches(text);
                      List<BranchModel> newList = await purchaseReportController
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
              width: width * .001,
            ),
            SizedBox(
              width: width * 0.14,
              height: height * 0.045,
              child: Consumer<PurchaseCriteraProvider>(
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
                          getSearchCriteriaName(text);
                      List<BranchModel> newList = await purchaseReportController
                          .getSalesSuppliersMethod(
                              dropDownSearchCriteria.toJsonBranch());

                      return newList;
                    },
                  ),
                );
              }),
            ),
            SizedBox(
              width: width * 0.001,
            ),
            SizedBox(
              width: width * 0.14,
              height: height * 0.045,
              child: Consumer<PurchaseCriteraProvider>(
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
                    onSearch: (text) async {
                      DropDownSearchCriteria dropDownSearchCriteria =
                          getSearchCriteriaName(text);
                      List<BranchModel> newList =
                          await purchaseReportController.getSalesStkMethod(
                              dropDownSearchCriteria.toJsonBranch());

                      return newList;
                    },
                  ),
                );
              }),
            ),
            SizedBox(
              width: width * 0.001,
            ),
            CustomTextField2(
              // isReport: true,
              width: width * 0.14,
              text: Text(_locale.campaignNo),
              // label: _locale.campaignNo,
              controller: campaignNoController,
              onSubmitted: (text) {
                readProvider.setCampaignNo(campaignNoController.text);
              },
              onChanged: (text) {
                readProvider.setCampaignNo(campaignNoController.text);
              },
            ),
            SizedBox(
              width: width * 0.001,
            ),
            CustomTextField2(
              // isReport: true,
              width: width * 0.13,
              text: Text(_locale.modelNo),
              // label: _locale.modelNo,
              controller: modelNoController,
              onSubmitted: (text) {
                readProvider.setModelNo(modelNoController.text);
              },
              onChanged: (text) {
                readProvider.setModelNo(modelNoController.text);
              },
            ),
            SizedBox(
              width: width * 0.001,
            ),
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
              width: isDesktop ? width * .13 : width * .35,
              height: isDesktop
                  ? height * 0.045
                  : height * 0.35, // hint: selectedValue1,
              initialValue: selectedValue1.isNotEmpty ? selectedValue1 : null,
              valSelected: selectedValue1 != "",
              onChanged: (value) {
                print("insidde on change");
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
          ],
        ),
        SizedBox(
          height: height * .01,
        ),
        Row(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropDown(
                  showClearIcon: true,

                  onClearIconPressed: () {
                    setState(() {
                      if (selectedValue2.isNotEmpty &&
                          ordersMap[selectedValue2] != null &&
                          ordersMap[selectedValue1] !=
                              ordersMap[selectedValue2] &&
                          ordersMap[selectedValue3] !=
                              ordersMap[selectedValue2] &&
                          ordersMap[selectedValue4] !=
                              ordersMap[selectedValue2]) {
                        ordersList.remove(ordersMap[selectedValue2]);
                        if (readProvider.getOrders != null) {
                          readProvider.getOrders!
                              .remove(ordersMap[selectedValue2]);
                        }
                      }
                      selectedValue2 = "";
                      readProvider.setVal2("");
                      readProvider.setOrders(ordersList);
                      widget.onSelectedValueChanged2("");
                    });
                  },
                  bordeText: _locale.orderBy + " 2",
                  // label: "",
                  // width: isDesktop ? null : width * .55,
                  items: firstList,
                  // hint: selectedValue2,
                  initialValue:
                      selectedValue2.isNotEmpty ? selectedValue2 : null,
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
                  width: width * 0.001,
                ),
                DropDown(
                  showClearIcon: true,

                  onClearIconPressed: () {
                    setState(() {
                      if (selectedValue3.isNotEmpty &&
                          ordersMap[selectedValue3] != null &&
                          ordersMap[selectedValue1] !=
                              ordersMap[selectedValue3] &&
                          ordersMap[selectedValue2] !=
                              ordersMap[selectedValue3] &&
                          ordersMap[selectedValue4] !=
                              ordersMap[selectedValue3]) {
                        ordersList.remove(ordersMap[selectedValue3]);
                        if (readProvider.getOrders != null) {
                          readProvider.getOrders!
                              .remove(ordersMap[selectedValue3]);
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
                  initialValue:
                      selectedValue3.isNotEmpty ? selectedValue3 : null,
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
                  width: width * 0.001,
                ),
                DropDown(
                  showClearIcon: true,

                  onClearIconPressed: () {
                    setState(() {
                      if (selectedValue4.isNotEmpty &&
                          ordersMap[selectedValue4] != null &&
                          ordersMap[selectedValue1] !=
                              ordersMap[selectedValue4] &&
                          ordersMap[selectedValue2] !=
                              ordersMap[selectedValue4] &&
                          ordersMap[selectedValue3] !=
                              ordersMap[selectedValue4]) {
                        ordersList.remove(ordersMap[selectedValue4]);
                        if (readProvider.getOrders != null) {
                          readProvider.getOrders!
                              .remove(ordersMap[selectedValue4]);
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

                  initialValue:
                      selectedValue4.isNotEmpty ? selectedValue4 : null,
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
          ],
        ),
        SizedBox(
          height: height * .01,
        ),
      ],
    );
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

  DropDownSearchCriteria getSearchCriteria(String text) {
    DropDownSearchCriteria dropDownSearchCriteria = DropDownSearchCriteria(
        fromDate: DatesController().formatDate(fromDate.text),
        toDate: DatesController().formatDate(toDate.text),
        nameCode: text);
    return dropDownSearchCriteria;
  }

  DropDownSearchCriteria getSearchCriteriaName(String text) {
    DropDownSearchCriteria dropDownSearchCriteria =
        DropDownSearchCriteria(nameCode: text);
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

  void getSuppCategList() {
    List<String> stringSuppCategList = [];

    // for (int i = 0; i < suppCategoryList.length; i++) {
    //   if (suppCategoryList[i].toString() == selectedFromSuppCateg) {
    //     stringSuppCategList.add(suppCategoryList[i].codeToString());
    //   }
    //   if (suppCategoryList[i].toString() == selectedToSuppCateg) {
    //     stringSuppCategList.add(suppCategoryList[i].codeToString());
    //   }
    // }

    if (selectedFromSuppCateg.isNotEmpty) {
      stringSuppCategList.add(selectedFromSuppCategCode);
    }
    if (selectedToSuppCateg.isNotEmpty) {
      stringSuppCategList.add(selectedToSuppCategCode);
    }
    readProvider.setFromSuppCateg(selectedFromSuppCateg);
    readProvider.setToSuppCateg(selectedToSuppCateg);
    // readProvider.setCodesSupplierCategory(stringSuppCategList);
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
  //  DropDownSearchCriteria getSearchCriteriaName(String text) {
  //   DropDownSearchCriteria dropDownSearchCriteria =
  //       DropDownSearchCriteria(nameCode: text);
  //   return dropDownSearchCriteria;
  // }

  // DropDownSearchCriteria getSearchCriteria(String text) {
  //   DropDownSearchCriteria dropDownSearchCriteria = DropDownSearchCriteria(
  //       fromDate: DatesController().formatDate(DatesController()
  //           .formatDateReverse(readProvider.getFromDate.toString())),
  //       toDate: DatesController().formatDate(DatesController()
  //           .formatDateReverse(readProvider.getToDate.toString())),
  //       nameCode: text);
  //   return dropDownSearchCriteria;
  // }

  DropDownSearchCriteria getSearchBranches(String text) {
    DropDownSearchCriteria dropDownSearchCriteria = DropDownSearchCriteria(
      nameCode: text,
    );
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

  // List<String> getCodesList(List<dynamic> val) {
  //   List<String> codesString = [];
  //   for (int i = 0; i < val.length; i++) {
  //     String newString = (val[i].toString().trim()).replaceAll(" ", "");
  //     codesString.add(newString.substring(0, newString.indexOf("-")));
  //   }
  //   return codesString;
  // }

  // List<String> getStringList(List<dynamic> val) {
  //   List<String> codesString = [];
  //   for (int i = 0; i < val.length; i++) {
  //     String newString = (val[i].toString().trim()).replaceAll(" ", "");
  //     codesString.add(newString);
  //   }
  //   return codesString;
  // }

  // DropDownSearchCriteria getSearchCriteriaPage(String text) {
  //   DropDownSearchCriteria dropDownSearchCriteria = DropDownSearchCriteria(
  //       fromDate: DatesController().formatDate(DatesController()
  //           .formatDateReverse(readProvider.getFromDate.toString())),
  //       toDate: DatesController().formatDate(DatesController()
  //           .formatDateReverse(readProvider.getToDate.toString())),
  //       nameCode: text,
  //       page: 1);
  //   return dropDownSearchCriteria;
  // }
}

//==============================================================================
