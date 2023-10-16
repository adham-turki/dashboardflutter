// import 'package:biproject/provider/sales_search_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../controller/dates_controller.dart';
// import 'app_utils.dart';
// import 'custom_drop_down.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// class SetupWidget extends StatefulWidget {
//   final TextEditingController fromDate;
//   final TextEditingController toDate;
//   const SetupWidget({Key? key, required this.fromDate, required this.toDate})
//       : super(key: key);

//   @override
//   State<SetupWidget> createState() => _SetupWidgetState();
// }

// class _SetupWidgetState extends State<SetupWidget> {
//   bool valueAppearBasicUnitEquiv = false;
//   bool valueAppearInactiveStocksForPurchase = false;
//   bool valueRoundingQty = false;
//   bool valueTaxIncluded = false;
//   bool valueUseItemCostPrice = false;
//   bool valueAppearInactiveStocks = false;
//   bool valueAppearLocation = false;
//   bool valueRoundingPrice = false;
//   bool valueAppearDiscount = false;
//   var utils = Components();
//   List<String> viewValues = [];
//   List<String> transactionTypeValues = [];
//   var selectedTransactionTypeValues = "";
//   var selectedViewValues = "";

//   late AppLocalizations _locale;
//   late SalesCriteraProvider readProvider;
//   @override
//   void didChangeDependencies() {
//     _locale = AppLocalizations.of(context);
//     viewValues = [_locale.all, _locale.code, _locale.barCode];
//     transactionTypeValues = [_locale.all, _locale.sales, _locale.returnSales];
//     readProvider = context.read<SalesCriteraProvider>();

//     super.didChangeDependencies();
//   }

//   @override
//   void initState() {
//     context
//         .read<SalesCriteraProvider>()
//         .setFromDate(DatesController().formatDate(widget.fromDate.text));
//     context
//         .read<SalesCriteraProvider>()
//         .setToDate(DatesController().formatDate(widget.toDate.text));
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     valueAppearBasicUnitEquiv = readProvider.getAppearBasicUnitEquiv!;
//     valueAppearInactiveStocksForPurchase =
//         readProvider.getAppearInactiveStocksForPurchase!;
//     valueRoundingQty = readProvider.getRoundingQty!;
//     valueTaxIncluded = readProvider.getTaxIncluded!;
//     valueUseItemCostPrice = readProvider.getUseItemCostPrice!;
//     valueAppearInactiveStocks = readProvider.getAppearInactiveStocks!;
//     valueRoundingPrice = readProvider.getRoundingPrice!;
//     valueAppearDiscount = readProvider.getAppearDiscount!;
//     valueAppearLocation = readProvider.getAppearLocation!;
//     selectedTransactionTypeValues = readProvider.getTransType!;
//     selectedViewValues = readProvider.getViewCodeBarcode!;
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border.all(color: Colors.grey),
//       ),
//       //
//       padding: const EdgeInsets.all(10.0),
//       width: MediaQuery.of(context).size.width < 800
//           ? MediaQuery.of(context).size.width * 0.9
//           : MediaQuery.of(context).size.width * 0.7,
//       height: MediaQuery.of(context).size.height * 0.35,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(
//                 height: 50,
//                 child: Row(
//                   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       _locale.view,
//                       style: utils.twelve400TextStyle(Colors.black),
//                     ),
//                     const SizedBox(
//                       width: 10,
//                     ),
//                     CustomDropDown(
//                       items: viewValues,
//                       hint: viewValues[0],
//                       value: selectedViewValues.isNotEmpty
//                           ? selectedViewValues
//                           : null,
//                       onChanged: (value) {
//                         setState(() {
//                           selectedViewValues = value!;
//                           readProvider.setViewCodeBarcode(selectedViewValues);
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 250,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Checkbox(
//                             value: valueAppearBasicUnitEquiv,
//                             onChanged: (val) {
//                               valueAppearBasicUnitEquiv = val!;
//                               readProvider.setAppearBasicUnitEquiv(
//                                   valueAppearBasicUnitEquiv);
//                               setState(() {});
//                             }),
//                         Text(
//                           MediaQuery.of(context).size.width < 800
//                               ? _locale.appearBasicUnitEquivalenceMobile
//                               : _locale.appearBasicUnitEquivalence,
//                           style: utils.twelve400TextStyle(Colors.black),
//                         ),
//                       ],
//                     ),
//                     Row(
//                       //     mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Checkbox(
//                             value: valueAppearInactiveStocksForPurchase,
//                             onChanged: (val) {
//                               valueAppearInactiveStocksForPurchase = val!;
//                               readProvider.setAppearInactiveStocksForPurchase(
//                                   valueAppearInactiveStocksForPurchase);
//                               setState(() {});
//                             }),
//                         Text(
//                           MediaQuery.of(context).size.width < 800
//                               ? _locale.appearInactiveStocksForPurchaseMobile
//                               : _locale.appearInactiveStocksForPurchase,
//                           style: utils.twelve400TextStyle(Colors.black),
//                         ),
//                       ],
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Checkbox(
//                             value: valueRoundingQty,
//                             onChanged: (val) {
//                               valueRoundingQty = val!;
//                               readProvider.setRoundingQty(valueRoundingQty);
//                               setState(() {});
//                             }),
//                         Text(
//                           _locale.roundingQuntity,
//                           style: utils.twelve400TextStyle(Colors.black),
//                         ),
//                       ],
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Checkbox(
//                             value: valueTaxIncluded,
//                             onChanged: (val) {
//                               valueTaxIncluded = val!;
//                               readProvider.setTaxIncluded(valueTaxIncluded);
//                               setState(() {});
//                             }),
//                         Text(
//                           _locale.taxInclude,
//                           style: utils.twelve400TextStyle(Colors.black),
//                         ),
//                       ],
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Checkbox(
//                             value: valueUseItemCostPrice,
//                             onChanged: (val) {
//                               valueUseItemCostPrice = val!;
//                               readProvider
//                                   .setUseItemCostPrice(valueUseItemCostPrice);
//                               setState(() {});
//                             }),
//                         Text(
//                           _locale.useItemCostPrice,
//                           style: utils.twelve400TextStyle(Colors.black),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(
//                 height: 50,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       _locale.transactionType,
//                       style: utils.twelve400TextStyle(Colors.black),
//                     ),
//                     const SizedBox(
//                       width: 10,
//                     ),
//                     CustomDropDown(
//                       items: transactionTypeValues,
//                       hint: transactionTypeValues[0],
//                       value: selectedTransactionTypeValues.isNotEmpty
//                           ? selectedTransactionTypeValues
//                           : null,
//                       onChanged: (value) {
//                         setState(() {
//                           selectedTransactionTypeValues = value!;
//                           readProvider
//                               .setTransType(selectedTransactionTypeValues);
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 150,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Checkbox(
//                             value: valueAppearInactiveStocks,
//                             onChanged: (val) {
//                               valueAppearInactiveStocks = val!;
//                               readProvider.setAppearInactiveStocks(
//                                   valueAppearInactiveStocks);
//                               setState(() {});
//                             }),
//                         Text(
//                           MediaQuery.of(context).size.width < 800
//                               ? _locale.appearInactiveStocksMobile
//                               : _locale.appearInactiveStocks,
//                           style: utils.twelve400TextStyle(Colors.black),
//                         ),
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         Checkbox(
//                             value: valueAppearLocation,
//                             onChanged: (val) {
//                               valueAppearLocation = val!;
//                               readProvider
//                                   .setAppearLocation(valueAppearLocation);
//                               setState(() {});
//                             }),
//                         Text(
//                           _locale.appearLocation,
//                           style: utils.twelve400TextStyle(Colors.black),
//                         ),
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         Checkbox(
//                             value: valueRoundingPrice,
//                             onChanged: (val) {
//                               valueRoundingPrice = val!;
//                               readProvider.setRoundingPrice(valueRoundingPrice);
//                               setState(() {});
//                             }),
//                         Text(
//                           _locale.roundingPrice,
//                           style: utils.twelve400TextStyle(Colors.black),
//                         ),
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         Checkbox(
//                             value: valueAppearDiscount,
//                             onChanged: (val) {
//                               valueAppearDiscount = val!;
//                               readProvider
//                                   .setAppearDiscount(valueAppearDiscount);
//                               setState(() {});
//                             }),
//                         Text(
//                           _locale.appearDiscount,
//                           style: utils.twelve400TextStyle(Colors.black),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
