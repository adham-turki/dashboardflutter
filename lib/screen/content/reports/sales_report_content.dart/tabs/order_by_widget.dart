import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../provider/sales_search_provider.dart';
import '../../../../../utils/constants/responsive.dart';
import '../../../../../utils/func/dates_controller.dart';
import '../../../../../widget/drop_down/custom_dropdown.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrderByWidget extends StatefulWidget {
  final Function(String) onSelectedValueChanged1;
  final Function(String) onSelectedValueChanged2;
  final Function(String) onSelectedValueChanged3;
  final Function(String) onSelectedValueChanged4;
  // final TextEditingController fromDate;
  // final TextEditingController toDate;
  OrderByWidget({
    Key? key,
    required this.onSelectedValueChanged1,
    required this.onSelectedValueChanged2,
    required this.onSelectedValueChanged3,
    required this.onSelectedValueChanged4,
    // required this.fromDate,
    // required this.toDate
  }) : super(key: key);

  @override
  State<OrderByWidget> createState() => _OrderByWidgetState();
}

class _OrderByWidgetState extends State<OrderByWidget> {
  late AppLocalizations _locale;
  List<String> firstList = [];
  late SalesCriteraProvider readProvider;
  var selectedValue1 = "";
  var selectedValue2 = "";
  var selectedValue3 = "";
  var selectedValue4 = "";
  List<int> ordersList = [];
  Map<String, int> ordersMap = {};
  Map<int, String> ordersMap2 = {};
  double width = 0;
  double height = 0;
  bool isDesktop = false;
  bool isMobile = false;
  // bool isMobile = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _locale = AppLocalizations.of(context);
    readProvider = context.read<SalesCriteraProvider>();

    firstList = [
      "",
      _locale.branch,
      _locale.stockCategoryLevel("1"),
      _locale.stockCategoryLevel("2"),
      _locale.stockCategoryLevel("3"),
      _locale.supp,
      _locale.customer,
      _locale.stock,
      _locale.daily,
      _locale.monthly,
      _locale.yearly,
      _locale.brand,
      _locale.invoice
    ];

    ordersMap[""] = 0;
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

    ordersMap2[0] = "";
    ordersMap2[1] = _locale.branch;
    ordersMap2[2] = _locale.stockCategoryLevel("1");
    ordersMap2[3] = _locale.stockCategoryLevel("2");
    ordersMap2[4] = _locale.stockCategoryLevel("3");
    ordersMap2[5] = _locale.supp;
    ordersMap2[6] = _locale.customer;
    ordersMap2[7] = _locale.stock;
    ordersMap2[8] = _locale.daily;
    ordersMap2[9] = _locale.monthly;
    ordersMap2[10] = _locale.yearly;
    ordersMap2[11] = _locale.brand;
    ordersMap2[12] = _locale.invoice;

    print("length  ${ordersList.length}");
  }

  @override
  void initState() {
    // context
    //     .read<SalesCriteraProvider>()
    //     .setFromDate(DatesController().formatDate(widget.fromDate.text));
    // context
    //     .read<SalesCriteraProvider>()
    //     .setToDate(DatesController().formatDate(widget.toDate.text));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    isDesktop = Responsive.isDesktop(context);
    isMobile = Responsive.isMobile(context);

    selectedValue1 = readProvider.getVal1!;
    selectedValue2 = readProvider.getVal2!;
    selectedValue3 = readProvider.getVal3!;
    selectedValue4 = readProvider.getVal4!;
    ordersList = readProvider.getOrders == null ? [] : readProvider.getOrders!;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
      ),
      padding: const EdgeInsets.all(10.0),
      width: width * 0.7,
      child: Column(
        children: [
          CustomDropDown(
            items: firstList,
            label: "",
            width: isDesktop ? null : width * .55,
            onChanged: (value) {
              setState(() {
                selectedValue1 = value!;

                if (ordersMap[selectedValue1] != 0) {
                  if (ordersList.contains(ordersMap[selectedValue1]!) ==
                      false) {
                    ordersList.add(ordersMap[selectedValue1]!);

                    readProvider.setOrders(ordersList);
                  }
                } else {
                  if (readProvider.getVal1 != "") {
                    ordersList.remove(ordersMap[readProvider.getVal1]);
                  }
                }
                readProvider.setVal1(selectedValue1);
                //  readProvider.setIndexMap(0, ordersMap[selectedValue1]!);
                widget.onSelectedValueChanged1(selectedValue1);
              });
            },
          ),
          CustomDropDown(
            label: "",
            width: isDesktop ? null : width * .55,
            items: firstList,
            hint: selectedValue2,
            initialValue: selectedValue2.isNotEmpty ? selectedValue2 : null,
            onChanged: (value) {
              setState(() {
                selectedValue2 = value!;
                if (ordersMap[selectedValue2] != 0) {
                  if (ordersList.contains(ordersMap[selectedValue2]!) ==
                      false) {
                    ordersList.add(ordersMap[selectedValue2]!);
                    readProvider.setOrders(ordersList);
                  }
                } else {
                  if (readProvider.getVal2 != "") {
                    ordersList.remove(ordersMap[readProvider.getVal2]);
                  }
                }

                readProvider.setVal2(selectedValue2);

                widget.onSelectedValueChanged2(selectedValue2);
              });
            },
          ),
          CustomDropDown(
            label: "",
            width: isDesktop ? null : width * .55,
            items: firstList,
            hint: selectedValue3,
            initialValue: selectedValue3.isNotEmpty ? selectedValue3 : null,
            onChanged: (value) {
              setState(() {
                selectedValue3 = value!;
                if (ordersMap[selectedValue3] != 0) {
                  if (ordersList.contains(ordersMap[selectedValue3]!) ==
                      false) {
                    ordersList.add(ordersMap[selectedValue3]!);
                    readProvider.setOrders(ordersList);
                  }
                } else {
                  if (readProvider.getVal3 != "") {
                    ordersList.remove(ordersMap[readProvider.getVal3]);
                  }
                }

                // readProvider.setIndexMap(2, ordersMap[selectedValue3]!);
                readProvider.setVal3(selectedValue3);

                widget.onSelectedValueChanged3(selectedValue3);
              });
            },
          ),
          CustomDropDown(
            label: "",
            width: isDesktop ? null : width * .55,
            items: firstList,
            hint: selectedValue4,
            initialValue: selectedValue4.isNotEmpty ? selectedValue4 : null,
            onChanged: (value) {
              setState(() {
                selectedValue4 = value!;
                if (ordersMap[selectedValue4] != 0) {
                  if (ordersList.contains(ordersMap[selectedValue4]!) ==
                      false) {
                    ordersList.add(ordersMap[selectedValue4]!);
                    readProvider.setOrders(ordersList);
                  }
                } else {
                  if (readProvider.getVal4 != "") {
                    ordersList.remove(ordersMap[readProvider.getVal4]);
                  }
                }

                // readProvider.setIndexMap(3, ordersMap[selectedValue4]!);
                readProvider.setVal4(selectedValue4);

                widget.onSelectedValueChanged4(selectedValue4);
              });
            },
          ),
        ],
      ),
    );
  }
}
