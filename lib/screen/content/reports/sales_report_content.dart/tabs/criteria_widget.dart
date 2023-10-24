// ignore_for_file: must_be_immutable

import 'package:bi_replicate/model/criteria/drop_down_search_criteria.dart';
import 'package:flutter/material.dart';
import '../../../../../components/card.dart';
import '../../../../../controller/reports/report_controller.dart';
import '../../../../../provider/sales_search_provider.dart';
import '../../../../../utils/constants/responsive.dart';
import '../../../../../utils/func/dates_controller.dart';
import '../../../../../widget/custom_date_picker.dart';
import '../../../../../widget/custom_textfield.dart';
import '../../../../../widget/drop_down/custom_dropdown.dart';
import '../../../../../widget/drop_down/multi_selection_drop_down.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class CriteriaWidget extends StatefulWidget {
  const CriteriaWidget({Key? key}) : super(key: key);

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

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
      ),
      padding: const EdgeInsets.all(20.0),
      width: width * 0.7,
      child: isMobile
          ? Column(
              children: [
                const LeftWidget(),
                SizedBox(
                  height: height * .01,
                ),
                const RightWidget(),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                LeftWidget(),
                RightWidget(),
              ],
            ),
    );
  }
}

class LeftWidget extends StatefulWidget {
  const LeftWidget({Key? key}) : super(key: key);

  @override
  State<LeftWidget> createState() => _LeftWidgetState();
}

class _LeftWidgetState extends State<LeftWidget> {
  ReportController salesReportController = ReportController();

  late AppLocalizations _locale;
  // List<BranchModel> stkCategory1List = [];
  // List<BranchModel> stkCategory3List = [];
  // List<BranchModel> customersList = [];
  // List<BranchModel> stocksList = [];

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
  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context);
    readProvider = context.read<SalesCriteraProvider>();
    String todayDate = DatesController().formatDateReverse(
        DatesController().formatDate(DatesController().todayDate()));

    fromDate.text = readProvider.getFromDate!.isNotEmpty
        ? DatesController()
            .formatDateReverse(readProvider.getFromDate.toString())
        : todayDate;

    toDate.text = readProvider.getToDate!.isNotEmpty
        ? DatesController().formatDateReverse(readProvider.getToDate.toString())
        : todayDate;

    context
        .read<SalesCriteraProvider>()
        .setFromDate(DatesController().formatDate(fromDate.text));
    context
        .read<SalesCriteraProvider>()
        .setToDate(DatesController().formatDate(toDate.text));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    isDesktop = Responsive.isDesktop(context);
    // isMobile = Responsive.isMobile(context);
    isMobile = Responsive.isMobile(context);

    selectedFromStkCategory1 = readProvider.getFromCateg1!;

    selectedToStkCategory1 = readProvider.getToCateg1!;

    selectedFromStkCategory3 = readProvider.getFromCateg3!;
    selectedToStkCategory3 = readProvider.getToCateg1!;

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

    return Column(
      children: [
        Container(
          width: isMobile ? width * 0.9 : width * 0.65 / 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(
              color: Colors.grey,
            ),
          ),
          padding: const EdgeInsets.all(2),
          child: isDesktop
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomDatePicker(
                      controller: fromDate,
                      label: _locale.fromDate,
                      date: DateTime.parse(toDate.text),
                      onSelected: (value) {
                        setFromDateController();
                      },
                    ),
                    CustomDatePicker(
                      controller: toDate,
                      date: DateTime.parse(fromDate.text),
                      label: _locale.toDate,
                      onSelected: (value) {
                        setToDateController();
                      },
                    )
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomDatePicker(
                      controller: fromDate,
                      label: _locale.fromDate,
                      date: DateTime.now(),
                      onSelected: (value) {
                        setFromDateController();
                      },
                    ),
                    CustomDatePicker(
                      controller: toDate,
                      date: DateTime.parse(fromDate.text),
                      label: _locale.toDate,
                      onSelected: (value) {
                        setToDateController();
                      },
                    )
                  ],
                ),
        ),
        SizedBox(
          height: height * .01,
        ),
        CardComponent(
          title: _locale.stockCategoryLevel("1"),
          multipleVal: valueMultipleStkCateg1,
          fromDropDown: CustomDropDown(
            hint: selectedFromStkCategory1.isNotEmpty
                ? selectedFromStkCategory1
                : _locale.select,
            label: _locale.from,
            width: isDesktop ? width * .17 : width * .38,
            onSearch: (text) {
              DropDownSearchCriteria dropDownSearchCriteria =
                  getSearchCriteria(text);

              return salesReportController.getSalesStkCountCateg1Method(
                  dropDownSearchCriteria.toJson());
            },
            onChanged: (value) {
              setState(() {
                selectedFromStkCategory1 = value.toString();
                selectedFromStkCategory1Code = value.codeToString();
                getCategory1List();
              });
            },
            initialValue: selectedFromStkCategory1.isNotEmpty
                ? selectedFromStkCategory1
                : null,
          ),
          toDropDown: CustomDropDown(
            hint: selectedToStkCategory1.isNotEmpty
                ? selectedToStkCategory1
                : _locale.select,
            label: _locale.to,
            initialValue: selectedToStkCategory1.isNotEmpty
                ? selectedToStkCategory1
                : null,
            onChanged: (value) {
              setState(() {
                selectedToStkCategory1 = value.toString();
                selectedToStkCategory1Code = value.codeToString();
                getCategory1List();
              });
            },
            width: isDesktop ? width * .17 : width * .38,
            onSearch: (text) {
              DropDownSearchCriteria dropDownSearchCriteria =
                  getSearchCriteria(text);

              return salesReportController.getSalesStkCountCateg1Method(
                  dropDownSearchCriteria.toJson());
            },
          ),
          selectAll: Checkbox(
              value: valueSelectAllStkCateg1,
              onChanged: (val) {
                valueSelectAllStkCateg1 = val!;
                readProvider.setCheckAllStockCategory1(valueSelectAllStkCateg1);

                readProvider.setCodesStockCategory1([]);

                setState(() {});
              }),
          multipleCheckBox: Checkbox(
              value: valueMultipleStkCateg1,
              onChanged: (val) {
                valueMultipleStkCateg1 = val!;
                readProvider
                    .setCheckMultipleStockCategory1(valueMultipleStkCateg1);

                readProvider.setCodesStockCategory1([]);
                readProvider.setStkCat1List([]);
                readProvider.setFromCateg1("");
                readProvider.setToCateg1("");
                selectedFromStkCategory1 = "";
                selectedToStkCategory1 = "";
                setState(() {});
              }),
          multipleSearch: SimpleDropdownSearch(
            // list: stkCategory1List,
            enabled: !valueSelectAllStkCateg1,
            hintString: readProvider.getStkCat1List!,

            onChanged: (val) {
              setState(() {
                readProvider.setCodesStockCategory1(getCodesList(val));
                readProvider.setStkCat1List(getStringList(val));
              });
            },

            onSearch: (text) {
              DropDownSearchCriteria dropDownSearchCriteria =
                  getSearchCriteria(text);

              return salesReportController.getSalesStkCountCateg1Method(
                  dropDownSearchCriteria.toJson());
            },
          ),
        ),
        SizedBox(
          height: height * .01,
        ),
        CardComponent(
          title: _locale.stockCategoryLevel("3"),
          multipleVal: valueMultipleStkCateg3,
          fromDropDown: CustomDropDown(
            hint: selectedFromStkCategory3.isNotEmpty
                ? selectedFromStkCategory3
                : _locale.select,
            initialValue: selectedFromStkCategory3.isNotEmpty
                ? selectedFromStkCategory3
                : null,
            label: _locale.from,
            onChanged: (value) {
              setState(() {
                selectedFromStkCategory3 = value.toString();
                selectedFromStkCategory3Code = value.codeToString();
                getCategory3List();
              });
            },
            width: isDesktop ? width * .17 : width * .38,
            onSearch: (text) {
              DropDownSearchCriteria dropDownSearchCriteria =
                  getSearchCriteria(text);

              return salesReportController.getSalesStkCountCateg3Method(
                  dropDownSearchCriteria.toJson());
            },
          ),
          toDropDown: CustomDropDown(
            hint: selectedToStkCategory3.isNotEmpty
                ? selectedToStkCategory3
                : _locale.select,
            label: _locale.to,
            width: isDesktop ? width * .17 : width * .38,
            onSearch: (text) {
              DropDownSearchCriteria dropDownSearchCriteria =
                  getSearchCriteria(text);

              return salesReportController.getSalesStkCountCateg3Method(
                  dropDownSearchCriteria.toJson());
            },
            initialValue: selectedToStkCategory3.isNotEmpty
                ? selectedToStkCategory3
                : null,
            onChanged: (value) {
              setState(() {
                selectedToStkCategory3 = value.toString();
                selectedToStkCategory3Code = value.codeToString();
                getCategory3List();
              });
            },
          ),
          selectAll: Checkbox(
              value: valueSelectAllStkCateg3,
              onChanged: (val) {
                valueSelectAllStkCateg3 = val!;
                readProvider.setCheckAllStockCategory3(valueSelectAllStkCateg3);

                readProvider.setCodesStockCategory3([]);
                setState(() {});
              }),
          multipleCheckBox: Checkbox(
              value: valueMultipleStkCateg3,
              onChanged: (val) {
                valueMultipleStkCateg3 = val!;
                readProvider
                    .setCheckMultipleStockCategory3(valueMultipleStkCateg3);

                readProvider.setCodesStockCategory3([]);
                readProvider.setStkCat3List([]);
                readProvider.setFromCateg3("");
                readProvider.setToCateg3("");
                selectedFromStkCategory3 = "";
                selectedToStkCategory3 = "";
                setState(() {});
              }),
          multipleSearch: SimpleDropdownSearch(
            // list: stkCategory3List,
            enabled: !valueSelectAllStkCateg3,
            hintString: readProvider.getStkCat3List == null
                ? []
                : readProvider.getStkCat3List!,
            onChanged: (val) {
              setState(() {
                readProvider.setCodesStockCategory3(getCodesList(val));
                readProvider.setStkCat3List(getStringList(val));
              });
            },
            onSearch: (text) {
              DropDownSearchCriteria dropDownSearchCriteria =
                  getSearchCriteria(text);

              return salesReportController.getSalesStkCountCateg3Method(
                  dropDownSearchCriteria.toJson());
            },
          ),
        ),
        SizedBox(
          height: height * .01,
        ),
        CardComponent(
            title: _locale.customer,
            multipleVal: valueMultipleCustomer,
            fromDropDown: CustomDropDown(
              label: _locale.from,
              onSearch: (text) {
                DropDownSearchCriteria dropDownSearchCriteria =
                    getSearchCriteria(text);

                return salesReportController
                    .getSalesCustomersMethod(dropDownSearchCriteria.toJson());
              },
              width: isDesktop ? width * .17 : width * .38,
              hint: selectedFromCustomers.isNotEmpty
                  ? selectedFromCustomers
                  : _locale.select,
              initialValue: selectedFromCustomers.isNotEmpty
                  ? selectedFromCustomers
                  : null,
              onChanged: (value) {
                setState(() {
                  selectedFromCustomers = value.toString();
                  selectedFromCustomersCode = value.codeToString();
                  getCustomerList();
                });
              },
            ),
            toDropDown: CustomDropDown(
              label: _locale.to,
              onSearch: (text) {
                DropDownSearchCriteria dropDownSearchCriteria =
                    getSearchCriteria(text);

                return salesReportController
                    .getSalesCustomersMethod(dropDownSearchCriteria.toJson());
              },
              width: isDesktop ? width * .17 : width * .38,
              hint: selectedToCustomers.isNotEmpty
                  ? selectedToCustomers
                  : _locale.select,
              initialValue:
                  selectedToCustomers.isNotEmpty ? selectedToCustomers : null,
              onChanged: (value) {
                setState(() {
                  selectedToCustomers = value.toString();
                  selectedToCustomersCode = value.codeToString();
                  getCustomerList();
                });
              },
            ),
            selectAll: Checkbox(
                value: valueSelectAllCustomer,
                onChanged: (val) {
                  valueSelectAllCustomer = val!;
                  readProvider.setCheckAllCustomer(valueSelectAllCustomer);

                  readProvider.setCodesCustomer([]);
                  setState(() {});
                }),
            multipleCheckBox: Checkbox(
                value: valueMultipleCustomer,
                onChanged: (val) {
                  valueMultipleCustomer = val!;
                  readProvider.setCheckMultipleCustomer(valueMultipleCustomer);

                  readProvider.setCodesCustomer([]);
                  readProvider.setCustomersList([]);
                  readProvider.setFromCust("");
                  readProvider.setToCust("");
                  selectedFromCustomers = "";
                  selectedToCustomers = "";
                  //    }
                  setState(() {});
                }),
            multipleSearch: SimpleDropdownSearch(
              // list: customersList,
              enabled: !valueSelectAllCustomer,
              hintString: readProvider.getCustomersList == null
                  ? []
                  : readProvider.getCustomersList!,
              onChanged: (val) {
                setState(() {
                  readProvider.setCodesCustomer(getCodesList(val));
                  readProvider.setCustomersList(getStringList(val));
                });
              },
              onSearch: (text) {
                DropDownSearchCriteria dropDownSearchCriteria =
                    getSearchCriteria(text);

                return salesReportController
                    .getSalesCustomersMethod(dropDownSearchCriteria.toJson());
              },
            )),
        SizedBox(
          height: height * .01,
        ),
        CardComponent(
          title: _locale.stock,
          multipleVal: valueMultipleStock,
          fromDropDown: CustomDropDown(
            label: _locale.from,
            onSearch: (text) {
              DropDownSearchCriteria dropDownSearchCriteria =
                  getSearchCriteria(text);

              return salesReportController
                  .getSalesStkMethod(dropDownSearchCriteria.toJson());
            },
            width: isDesktop ? width * .17 : width * .38,
            hint: selectedFromStocks.isNotEmpty
                ? selectedFromStocks
                : _locale.select,
            initialValue:
                selectedFromStocks.isNotEmpty ? selectedFromStocks : null,
            onChanged: (value) {
              setState(() {
                selectedFromStocks = value.toString();
                selectedFromStocksCode = value.codeToString();
                getStockList();
              });
            },
          ),
          toDropDown: CustomDropDown(
            label: _locale.to,
            onSearch: (text) {
              DropDownSearchCriteria dropDownSearchCriteria =
                  getSearchCriteria(text);

              return salesReportController
                  .getSalesStkMethod(dropDownSearchCriteria.toJson());
            },
            width: isDesktop ? width * .17 : width * .38,
            hint:
                selectedToStocks.isNotEmpty ? selectedToStocks : _locale.select,
            initialValue: selectedToStocks.isNotEmpty ? selectedToStocks : null,
            onChanged: (value) {
              setState(() {
                selectedToStocks = value.toString();
                selectedToStocksCode = value.codeToString();
                getStockList();
              });
            },
          ),
          selectAll: Checkbox(
              value: valueSelectAllStock,
              onChanged: (val) {
                valueSelectAllStock = val!;
                readProvider.setCheckAllStock(valueSelectAllStock);
                readProvider.setCodesStock([]);
                setState(() {});
              }),
          multipleCheckBox: Checkbox(
              value: valueMultipleStock,
              onChanged: (val) {
                valueMultipleStock = val!;
                readProvider.setCheckMultipleStock(valueMultipleStock);
                readProvider.setCodesStock([]);
                readProvider.setStockList([]);
                readProvider.setFromStock("");
                readProvider.setToStock("");
                selectedFromStocks = "";
                selectedToStocks = "";
                setState(() {});
              }),
          multipleSearch: SimpleDropdownSearch(
            // list: stocksList,
            enabled: !valueSelectAllStock,
            hintString: readProvider.getStockList == null
                ? []
                : readProvider.getStockList!,
            onChanged: (val) {
              setState(() {
                readProvider.setCodesStock(getCodesList(val));
                readProvider.setStockList(getStringList(val));
              });
            },
            onSearch: (text) {
              DropDownSearchCriteria dropDownSearchCriteria =
                  getSearchCriteria(text);

              return salesReportController
                  .getSalesStkMethod(dropDownSearchCriteria.toJson());
            },
          ),
        ),
      ],
    );
  }

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
    readProvider.setCodesStockCategory1(stringStkCategory1List);
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
    readProvider.setCodesStockCategory3(stringStkCategory3List);
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
    readProvider.setCodesCustomer(stringCustomerList);
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
    readProvider.setCodesStock(stringStockList);
  }

  List<String> getCodesList(List<dynamic> val) {
    List<String> codesString = [];
    for (int i = 0; i < val.length; i++) {
      String newString = (val[i].toString().trim()).replaceAll(" ", "");
      print(newString);
      codesString.add(newString.substring(0, newString.indexOf("-")));
    }
    return codesString;
  }

  List<String> getStringList(List<dynamic> val) {
    List<String> codesString = [];
    for (int i = 0; i < val.length; i++) {
      String newString = (val[i].toString().trim()).replaceAll(" ", "");
      print(newString);
      codesString.add(newString);
    }
    return codesString;
  }

  void setFromDateController() {
    setState(() {
      String fromDateValue = fromDate.text;
      String startDate = DatesController().formatDate(fromDateValue);
      context.read<SalesCriteraProvider>().setFromDate(startDate);
      print("fromProvider ${context.read<SalesCriteraProvider>().getFromDate}");
    });
  }

  void setToDateController() {
    setState(() {
      String toDateValue = toDate.text;
      String endDate = DatesController().formatDate(toDateValue);
      context.read<SalesCriteraProvider>().setToDate(endDate);
      print("toProvider ${context.read<SalesCriteraProvider>().getToDate}");
    });
  }
}

class RightWidget extends StatefulWidget {
  const RightWidget({Key? key}) : super(key: key);

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
    _locale = AppLocalizations.of(context);
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CardComponent(
          title: _locale.branch,
          multipleVal: valueMultipleBranches,
          fromDropDown: CustomDropDown(
            label: _locale.from,
            width: isDesktop ? width * .17 : width * .38,
            // items: branchesList,
            hint: selectedFromBranches.isNotEmpty
                ? selectedFromBranches
                : _locale.select,
            initialValue:
                selectedFromBranches.isNotEmpty ? selectedFromBranches : null,
            onChanged: (value) {
              setState(() {
                selectedFromBranches = value.toString();
                selectedFromBranchesCode = value.codeToString();
                getBranchList();
              });
            },
            onSearch: (text) {
              DropDownSearchCriteria dropDownSearchCriteria =
                  getSearchCriteria(text);
              return salesReportController
                  .getSalesBranchesMethod(dropDownSearchCriteria.toJson());
            },
          ),
          toDropDown: CustomDropDown(
            label: _locale.to,
            width: isDesktop ? width * .17 : width * .38,
            // items: branchesList,
            hint: selectedToBranches.isNotEmpty
                ? selectedToBranches
                : _locale.select,
            initialValue:
                selectedToBranches.isNotEmpty ? selectedToBranches : null,
            onChanged: (value) {
              setState(() {
                selectedToBranches = value.toString();
                selectedToBranchesCode = value.codeToString();
                getBranchList();
              });
            },
            onSearch: (text) {
              DropDownSearchCriteria dropDownSearchCriteria =
                  getSearchCriteria(text);
              return salesReportController
                  .getSalesBranchesMethod(dropDownSearchCriteria.toJson());
            },
          ),
          selectAll: Checkbox(
              value: valueSelectAllBranches,
              onChanged: (val) {
                valueSelectAllBranches = val!;
                readProvider.setCheckAllBranch(valueSelectAllBranches);

                readProvider.setCodesBranch([]);

                setState(() {});
              }),
          multipleCheckBox: Checkbox(
              value: valueMultipleBranches,
              onChanged: (val) {
                valueMultipleBranches = val!;
                readProvider.setCheckMultipleBranch(valueMultipleBranches);

                readProvider.setCodesBranch([]);
                readProvider.setBranchList([]);
                readProvider.setFromBranch("");
                readProvider.setToBranch("");
                selectedFromBranches = "";
                selectedToBranches = "";
                setState(() {});
              }),
          multipleSearch: SimpleDropdownSearch(
            // list: branchesList,
            enabled: !valueSelectAllBranches,
            hintString: readProvider.getBranchList == null
                ? []
                : readProvider.getBranchList!,
            onChanged: (val) {
              setState(() {
                readProvider.setCodesBranch(getCodesList(val));
                readProvider.setBranchList(getStringList(val));
              });
            },
            onSearch: (text) {
              DropDownSearchCriteria dropDownSearchCriteria =
                  getSearchCriteria(text);
              return salesReportController
                  .getSalesBranchesMethod(dropDownSearchCriteria.toJson());
            },
          ),
        ),
        SizedBox(
          height: height * .01,
        ),
        CardComponent(
          title: _locale.stockCategoryLevel("2"),
          multipleVal: valueMultipleStkCategory2,
          fromDropDown: CustomDropDown(
            label: _locale.from,
            width: isDesktop ? width * .17 : width * .38,
            // items: stkCategory2List,
            hint: selectedFromStkCategory2.isNotEmpty
                ? selectedFromStkCategory2
                : _locale.select,
            initialValue: selectedFromStkCategory2.isNotEmpty
                ? selectedFromStkCategory2
                : null,
            onChanged: (value) {
              setState(() {
                selectedFromStkCategory2 = value.toString();
                selectedFromStkCategory2Code = value.codeToString();
                getCategory2List();
              });
            },
            onSearch: (text) {
              DropDownSearchCriteria dropDownSearchCriteria =
                  getSearchCriteria(text);
              return salesReportController.getSalesStkCountCateg2Method(
                  dropDownSearchCriteria.toJson());
            },
          ),
          toDropDown: CustomDropDown(
            label: _locale.to,
            width: isDesktop ? width * .17 : width * .38,
            hint: selectedToStkCategory2.isNotEmpty
                ? selectedToStkCategory2
                : _locale.select,
            initialValue: selectedToStkCategory2.isNotEmpty
                ? selectedToStkCategory2
                : null,
            onChanged: (value) {
              setState(() {
                selectedToStkCategory2 = value.toString();
                selectedToStkCategory2Code = value.codeToString();
                getCategory2List();
              });
            },
            onSearch: (text) {
              DropDownSearchCriteria dropDownSearchCriteria =
                  getSearchCriteria(text);
              return salesReportController.getSalesStkCountCateg2Method(
                  dropDownSearchCriteria.toJson());
            },
          ),
          selectAll: Checkbox(
              value: valueSelectAllStkCategory2,
              onChanged: (val) {
                valueSelectAllStkCategory2 = val!;
                readProvider
                    .setCheckAllStockCategory2(valueSelectAllStkCategory2);

                readProvider.setCodesStockCategory2([]);

                setState(() {});
              }),
          multipleCheckBox: Checkbox(
              value: valueMultipleStkCategory2,
              onChanged: (val) {
                valueMultipleStkCategory2 = val!;
                readProvider
                    .setCheckMultipleStockCategory2(valueMultipleStkCategory2);

                readProvider.setCodesStockCategory2([]);
                readProvider.setStkCat2List([]);
                readProvider.setFromCateg2("");
                readProvider.setToCateg2("");
                selectedFromStkCategory2 = "";
                selectedToStkCategory2 = "";
                setState(() {});
              }),
          multipleSearch: SimpleDropdownSearch(
            // list: stkCategory2List,
            enabled: !valueSelectAllStkCategory2,
            hintString: readProvider.getStkCat2List == null
                ? []
                : readProvider.getStkCat2List!,
            onChanged: (val) {
              setState(() {
                readProvider.setCodesStockCategory2(getCodesList(val));
                readProvider.setStkCat2List(getStringList(val));
              });
            },
            onSearch: (text) {
              DropDownSearchCriteria dropDownSearchCriteria =
                  getSearchCriteria(text);
              return salesReportController.getSalesStkCountCateg2Method(
                  dropDownSearchCriteria.toJson());
            },
          ),
        ),
        SizedBox(
          height: height * .01,
        ),
        CardComponent(
            title: _locale.supplier(""),
            multipleVal: valueMultipleSupplier,
            fromDropDown: CustomDropDown(
              label: _locale.from,
              width: isDesktop ? width * .17 : width * .38,
              // items: suppliersList,
              hint: selectedFromSupplier.isNotEmpty
                  ? selectedFromSupplier
                  : _locale.select,
              initialValue:
                  selectedFromSupplier.isNotEmpty ? selectedFromSupplier : null,
              onChanged: (value) {
                setState(() {
                  selectedFromSupplier = value.toString();
                  selectedFromSupplierCode = value.codeToString();
                  getSupplierList();
                });
              },
              onSearch: (text) {
                DropDownSearchCriteria dropDownSearchCriteria =
                    getSearchCriteria(text);
                return salesReportController
                    .getSalesSuppliersMethod(dropDownSearchCriteria.toJson());
              },
            ),
            toDropDown: CustomDropDown(
              label: _locale.to,
              width: isDesktop ? width * .17 : width * .38,
              hint: selectedToSupplier.isNotEmpty
                  ? selectedToSupplier
                  : _locale.select,
              initialValue:
                  selectedToSupplier.isNotEmpty ? selectedToSupplier : null,
              onChanged: (value) {
                setState(() {
                  selectedToSupplier = value.toString();
                  selectedToSupplierCode = value.codeToString();
                  getSupplierList();
                });
              },
              onSearch: (text) {
                DropDownSearchCriteria dropDownSearchCriteria =
                    getSearchCriteria(text);
                return salesReportController
                    .getSalesSuppliersMethod(dropDownSearchCriteria.toJson());
              },
            ),
            selectAll: Checkbox(
                value: valueSelectAllSupplier,
                onChanged: (val) {
                  valueSelectAllSupplier = val!;
                  readProvider.setCheckAllSupplier(valueSelectAllSupplier);

                  readProvider.setCodesSupplier([]);
                  setState(() {});
                }),
            multipleCheckBox: Checkbox(
                value: valueMultipleSupplier,
                onChanged: (val) {
                  valueMultipleSupplier = val!;
                  readProvider.setCheckMultipleSupplier(valueMultipleSupplier);

                  readProvider.setCodesSupplier([]);
                  readProvider.setSupplierList([]);
                  readProvider.setFromSupp("");
                  readProvider.setToSupp("");
                  selectedFromSupplier = "";
                  selectedToSupplier = "";
                  setState(() {});
                }),
            multipleSearch: SimpleDropdownSearch(
              // list: suppliersList,
              enabled: !valueSelectAllSupplier,
              hintString: readProvider.getSupplierList == null
                  ? []
                  : readProvider.getSupplierList!,
              onChanged: (val) {
                setState(() {
                  readProvider.setCodesSupplier(getCodesList(val));
                  readProvider.setSupplierList(getStringList(val));
                });
              },
              onSearch: (text) {
                DropDownSearchCriteria dropDownSearchCriteria =
                    getSearchCriteria(text);
                return salesReportController
                    .getSalesSuppliersMethod(dropDownSearchCriteria.toJson());
              },
            )),
        SizedBox(
          height: height * .01,
        ),
        CardComponent(
          title: _locale.customerCategory,
          multipleVal: valueMultipleCustomerCategory,
          fromDropDown: CustomDropDown(
            label: _locale.from,
            width: isDesktop ? width * .17 : width * .38,
            hint: selectedFromCustomerCategory.isNotEmpty
                ? selectedFromCustomerCategory
                : _locale.select,
            initialValue: selectedFromCustomerCategory.isNotEmpty
                ? selectedFromCustomerCategory
                : null,
            onChanged: (value) {
              setState(() {
                selectedFromCustomerCategory = value.toString();
                selectedFromCustomerCategoryCode = value.codeToString();
                getCustomerCategoryList();
              });
            },
            onSearch: (text) {
              DropDownSearchCriteria dropDownSearchCriteria =
                  getSearchCriteria(text);
              return salesReportController.getSalesCustomersCategMethod(
                  dropDownSearchCriteria.toJson());
            },
          ),
          toDropDown: CustomDropDown(
            label: _locale.to,
            width: isDesktop ? width * .17 : width * .38,
            hint: selectedToCustomerCategory.isNotEmpty
                ? selectedToCustomerCategory
                : _locale.select,
            initialValue: selectedToCustomerCategory.isNotEmpty
                ? selectedToCustomerCategory
                : null,
            onChanged: (value) {
              setState(() {
                selectedToCustomerCategory = value.toString();
                selectedToCustomerCategoryCode = value.codeToString();
                getCustomerCategoryList();
              });
            },
            onSearch: (text) {
              DropDownSearchCriteria dropDownSearchCriteria =
                  getSearchCriteria(text);
              return salesReportController.getSalesCustomersCategMethod(
                  dropDownSearchCriteria.toJson());
            },
          ),
          selectAll: Checkbox(
              value: valueSelectAllCustomerCategory,
              onChanged: (val) {
                valueSelectAllCustomerCategory = val!;
                readProvider.setCheckAllCustomerCategory(
                    valueSelectAllCustomerCategory);

                readProvider.setCodesCustomerCategory([]);
                setState(() {});
              }),
          multipleCheckBox: Checkbox(
              value: valueMultipleCustomerCategory,
              onChanged: (val) {
                valueMultipleCustomerCategory = val!;
                readProvider.setCheckMultipleCustomerCategory(
                    valueMultipleCustomerCategory);

                readProvider.setCodesCustomerCategory([]);
                readProvider.setCustCateg([]);
                readProvider.setFromCustCateg("");
                readProvider.setToCustCateg("");
                selectedFromCustomerCategory = "";
                selectedToCustomerCategory = "";
                setState(() {});
              }),
          multipleSearch: SimpleDropdownSearch(
            // list: customerCategoryList,
            enabled: !valueSelectAllCustomerCategory,
            hintString: readProvider.getCustCateg == null
                ? []
                : readProvider.getCustCateg!,
            onChanged: (val) {
              setState(() {
                readProvider.setCodesCustomerCategory(getCodesList(val));
                readProvider.setCustCateg(getStringList(val));
              });
            },
            onSearch: (text) {
              DropDownSearchCriteria dropDownSearchCriteria =
                  getSearchCriteria(text);
              return salesReportController.getSalesCustomersCategMethod(
                  dropDownSearchCriteria.toJson());
            },
          ),
        ),
        SizedBox(
          height: height * .01,
        ),
        Container(
          width: isMobile ? width * 0.9 : width * 0.65 / 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(
              color: Colors.grey,
            ),
          ),
          padding: const EdgeInsets.only(bottom: 8.0),
          child: isDesktop
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextField(
                      width: width * 0.74,
                      label: _locale.campaignNo,
                      controller: campaignNoController,
                      onSubmitted: (text) {
                        readProvider.setCampaignNo(campaignNoController.text);
                      },
                    ),
                    CustomTextField(
                      width: width * 0.74,
                      label: _locale.modelNo,
                      controller: modelNoController,
                      onSubmitted: (text) {
                        readProvider.setModelNo(modelNoController.text);
                      },
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      width: width * 4,
                      label: _locale.campaignNo,
                      controller: campaignNoController,
                      onSubmitted: (text) {
                        readProvider.setCampaignNo(campaignNoController.text);
                      },
                    ),
                    CustomTextField(
                      width: width * 4,
                      label: _locale.modelNo,
                      controller: modelNoController,
                      onSubmitted: (text) {
                        readProvider.setModelNo(modelNoController.text);
                      },
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  DropDownSearchCriteria getSearchCriteria(String text) {
    // String todayDate = DatesController().formatDateReverse(
    //     DatesController().formatDate(DatesController().todayDate()));
    // widget.fromDate.text = readProvider.getFromDate!.isNotEmpty
    //     ? DatesController()
    //         .formatDateReverse(readProvider.getFromDate.toString())
    //     : todayDate;

    // widget.toDate.text = readProvider.getToDate!.isNotEmpty
    //     ? DatesController().formatDateReverse(readProvider.getToDate.toString())
    //     : todayDate;
    DropDownSearchCriteria dropDownSearchCriteria = DropDownSearchCriteria(
        fromDate: DatesController().formatDate(DatesController()
            .formatDateReverse(readProvider.getFromDate.toString())),
        toDate: DatesController().formatDate(DatesController()
            .formatDateReverse(readProvider.getToDate.toString())),
        nameCode: text);
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
    readProvider.setCodesBranch(stringBranchList);
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
    readProvider.setCodesStockCategory2(stringStkCategory2List);
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
    readProvider.setCodesSupplier(stringSupplierList);
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
    readProvider.setCodesCustomerCategory(stringCustomerCategoryList);
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
      print(newString);
      codesString.add(newString);
    }
    return codesString;
  }
}
