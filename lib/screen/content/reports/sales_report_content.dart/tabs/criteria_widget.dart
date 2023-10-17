// // ignore_for_file: must_be_immutable
// import 'package:biproject/Models/branch_model.dart';
// import 'package:biproject/component/search_drop_down.dart';
// import 'package:biproject/component/text_field_custom.dart';
// import 'package:flutter/material.dart';
// import '../../../../../components/drop_down/multi_selection_drop_down.dart';
// import '../../../../../components/drop_down/search_drop_down.dart';
// import '../../../../../model/criteria/drop_down_search_criteria.dart';
// import '../../../../../utils/func/dates_controller.dart';
// import '../Models/drop_down_search_criteria.dart';
// import '../controller/dates_controller.dart';
// import '../controller/report_controller.dart';
// import '../provider/sales_search_provider.dart';
// import 'app_utils.dart';
// import 'custom_drop_down.dart';
// import 'date_text_field.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:provider/provider.dart';

// import 'drop_down_search.dart';

// class CriteriaWidget extends StatefulWidget {
//   TextEditingController fromDate;
//   TextEditingController toDate;
//   CriteriaWidget({Key? key, required this.fromDate, required this.toDate})
//       : super(key: key);

//   @override
//   State<CriteriaWidget> createState() => _CriteriaWidgetState();
// }

// class _CriteriaWidgetState extends State<CriteriaWidget> {
//   var utils = Components();

//   // TextEditingController fromDate = TextEditingController();
//   // TextEditingController toDate = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border.all(color: Colors.grey),
//       ),
//       padding: const EdgeInsets.all(10.0),
//       width: MediaQuery.of(context).size.width < 800
//           ? MediaQuery.of(context).size.width * 0.9
//           : MediaQuery.of(context).size.width * 0.85,
//       child: MediaQuery.of(context).size.width < 800
//           ? Column(
//               children: [
//                 LeftWidget(fromDate: widget.fromDate, toDate: widget.toDate),
//                 const SizedBox(
//                   width: 5,
//                 ),
//                 RightWidget(fromDate: widget.fromDate, toDate: widget.toDate),
//               ],
//             )
//           : Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 LeftWidget(fromDate: widget.fromDate, toDate: widget.toDate),
//                 RightWidget(fromDate: widget.fromDate, toDate: widget.toDate),
//               ],
//             ),
//     );
//   }
// }

// class LeftWidget extends StatefulWidget {
//   final TextEditingController fromDate;
//   final TextEditingController toDate;

//   const LeftWidget({Key? key, required this.fromDate, required this.toDate})
//       : super(key: key);

//   @override
//   State<LeftWidget> createState() => _LeftWidgetState();
// }

// class _LeftWidgetState extends State<LeftWidget> {
//   ReportController salesReportController = ReportController();

//   late AppLocalizations _locale;
//   // List<BranchModel> stkCategory1List = [];
//   // List<BranchModel> stkCategory3List = [];
//   // List<BranchModel> customersList = [];
//   // List<BranchModel> stocksList = [];

//   var selectedFromStkCategory1 = "";
//   var selectedToStkCategory1 = "";
//   var selectedFromStkCategory3 = "";
//   var selectedToStkCategory3 = "";
//   var selectedFromCustomers = "";
//   var selectedToCustomers = "";
//   var selectedFromStocks = "";
//   var selectedToStocks = "";

//   var selectedFromStkCategory1Code = "";
//   var selectedToStkCategory1Code = "";
//   var selectedFromStkCategory3Code = "";
//   var selectedToStkCategory3Code = "";
//   var selectedFromCustomersCode = "";
//   var selectedToCustomersCode = "";
//   var selectedFromStocksCode = "";
//   var selectedToStocksCode = "";

//   bool valueMultipleStkCateg1 = false;
//   bool valueMultipleStkCateg3 = false;
//   bool valueMultipleCustomer = false;
//   bool valueMultipleStock = false;
//   bool valueSelectAllStkCateg1 = false;
//   bool valueSelectAllStkCateg3 = false;
//   bool valueSelectAllCustomer = false;
//   bool valueSelectAllStock = false;
//   late SalesCriteraProvider readProvider;

//   @override
//   void didChangeDependencies() {
//     _locale = AppLocalizations.of(context);
//     readProvider = context.read<SalesCriteraProvider>();

//     super.didChangeDependencies();
//   }

//   var utils = Components();
//   Future<void> _showCalendar() async {
//     final DateTime? pickedDate = await showDatePicker(
//         context: context,
//         initialDate: _selectedDate ?? DateTime.now(),
//         firstDate: DateTime(1950),
//         //  : DateTime.now(),
//         lastDate: DateTime(2101));

//     if (pickedDate != null && pickedDate != _selectedDate) {
//       setState(() {
//         _selectedDate = pickedDate;
//         String day = _selectedDate!.day.toString();
//         String month = _selectedDate!.month.toString();

//         if (_selectedDate!.day.toString().length == 1) {
//           day = "0${_selectedDate!.day.toString()}";
//         }
//         if (_selectedDate!.month.toString().length == 1) {
//           month = "0${_selectedDate!.month.toString()}";
//         }
//         widget.fromDate.text = '${_selectedDate!.year.toString()}-$month-$day';
//         print("selected $_selectedDate");
//         print("fromdate ${widget.fromDate.text}");

//         readProvider
//             .setFromDate(DatesController().formatDate(widget.fromDate.text));
//       });
//     }
//   }

//   DateTime? _selectedDate = DateTime.now();
//   DateTime? _selectedDate2 = DateTime.now();
//   Future<void> showCalendar2() async {
//     final DateTime? pickedDate = await showDatePicker(
//         context: context,
//         initialDate: _selectedDate2 ?? DateTime.now(),
//         firstDate: DateTime(1950),
//         //  : DateTime.now(),
//         lastDate: DateTime(2101));

//     if (pickedDate != null && pickedDate != _selectedDate2) {
//       setState(() {
//         _selectedDate2 = pickedDate;
//         String day = _selectedDate2!.day.toString();
//         String month = _selectedDate2!.month.toString();

//         if (_selectedDate2!.day.toString().length == 1) {
//           day = "0${_selectedDate2!.day.toString()}";
//         }
//         if (_selectedDate2!.month.toString().length == 1) {
//           month = "0${_selectedDate2!.month.toString()}";
//         }
//         widget.toDate.text = '${_selectedDate2!.year.toString()}-$month-$day';
//         readProvider
//             .setToDate(DatesController().formatDate(widget.toDate.text));
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     String todayDate = DatesController().formatDateReverse(
//         DatesController().formatDate(DatesController().todayDate()));
//     String nextMonth = DatesController().formatDateReverse(DatesController()
//         .formatDate(DateTime(DatesController().today.year,
//                 DatesController().today.month + 1, DatesController().today.day)
//             .toString()));
//     widget.fromDate.text = readProvider.getFromDate!.isNotEmpty
//         ? DatesController()
//             .formatDateReverse(readProvider.getFromDate.toString())
//         : todayDate;

//     widget.toDate.text = readProvider.getToDate!.isNotEmpty
//         ? DatesController().formatDateReverse(readProvider.getToDate.toString())
//         : nextMonth;

//     _selectedDate = DateTime.parse(widget.fromDate.text);
//     _selectedDate2 = DateTime.parse(widget.toDate.text);
//     selectedFromStkCategory1 = readProvider.getFromCateg1!;

//     selectedToStkCategory1 = readProvider.getToCateg1!;

//     selectedFromStkCategory3 = readProvider.getFromCateg3!;
//     selectedToStkCategory3 = readProvider.getToCateg1!;

//     selectedFromCustomers = readProvider.getFromCust!;
//     selectedToCustomers = readProvider.getToCust!;

//     selectedFromStocks = readProvider.getFromstock!;
//     selectedToStocks = readProvider.getTostock!;

//     valueMultipleStkCateg1 = readProvider.getCheckMultipleStockCategory1!;
//     valueMultipleStkCateg3 = readProvider.getCheckMultipleStockCategory3!;

//     valueMultipleCustomer = readProvider.getCheckMultipleCustomer!;
//     valueMultipleStock = readProvider.getCheckMultipleStock!;

//     valueSelectAllStkCateg1 = readProvider.getCheckAllStockCategory1!;
//     valueSelectAllStkCateg3 = readProvider.getCheckAllStockCategory3!;
//     valueSelectAllCustomer = readProvider.getCheckAllCustomer!;
//     valueSelectAllStock = readProvider.getCheckAllStock!;
//     print("readProv ${readProvider.getStkCat1List!}");

//     return Column(
//       children: [
//         Container(
//           width: MediaQuery.of(context).size.width < 800
//               ? MediaQuery.of(context).size.width * 0.9
//               : MediaQuery.of(context).size.width * 0.79 / 2.1,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(5.0),
//             border: Border.all(
//               color: Colors.grey,
//             ),
//           ),
//           padding: const EdgeInsets.all(10.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SizedBox(
//                     width: 70,
//                     child: SelectableText(
//                       maxLines: 1,
//                       _locale.fromDate,
//                       style: utils.twelve400TextStyle(Colors.black),
//                     ),
//                   ),
//                   const SizedBox(
//                     width: 5,
//                   ),
//                   MediaQuery.of(context).size.width > 800
//                       ? DateField(
//                           controller: widget.fromDate,
//                           isFromTrans: true,
//                           // onChange: (text) {
//                           //   print("object");
//                           //   String startDate = DatesController()
//                           //       .formatDate(widget.fromDate.text);
//                           //   String endDate = DatesController()
//                           //       .formatDate(widget.toDate.text);

//                           //   readProvider.setFromDate(startDate);
//                           //   readProvider.setToDate(endDate);
//                           // },
//                         )
//                       : GestureDetector(
//                           onTap: () {
//                             _showCalendar();
//                           }, //
//                           child: Container(
//                             height: 30,
//                             width: MediaQuery.of(context).size.width * 0.26,
//                             decoration: BoxDecoration(
//                               color: Colors.grey[200],
//                               borderRadius: BorderRadius.circular(5.0),
//                             ),
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 4, horizontal: 10),
//                             child: Text(
//                               maxLines: 1,
//                               _selectedDate != null
//                                   ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"
//                                   : _locale.select,
//                               style: const TextStyle(color: Colors.black),
//                             ),
//                           ),
//                         ),
//                 ],
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SizedBox(
//                     width: 70,
//                     child: SelectableText(
//                       maxLines: 1,
//                       _locale.toDate,
//                       style: utils.twelve400TextStyle(Colors.black),
//                     ),
//                   ),
//                   const SizedBox(
//                     width: 5,
//                   ),
//                   MediaQuery.of(context).size.width > 800
//                       ? DateField(
//                           controller: widget.toDate,
//                           isFromTrans: true,
//                           // onChange: (text) {
//                           //   String startDate = DatesController()
//                           //       .formatDate(widget.fromDate.text);
//                           //   String endDate = DatesController()
//                           //       .formatDate(widget.toDate.text);

//                           //   readProvider.setFromDate(startDate);
//                           //   readProvider.setToDate(endDate);
//                           // },
//                         )
//                       : GestureDetector(
//                           onTap: () {
//                             showCalendar2();
//                           }, // Show the calendar on tap
//                           child: Container(
//                             height: 30,
//                             width: MediaQuery.of(context).size.width * 0.26,
//                             decoration: BoxDecoration(
//                               color: Colors.grey[200],
//                               borderRadius: BorderRadius.circular(5.0),
//                             ),
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 4, horizontal: 10),
//                             child: Text(
//                               maxLines: 1,
//                               _selectedDate2 != null
//                                   ? "${_selectedDate2!.day}/${_selectedDate2!.month}/${_selectedDate2!.year}"
//                                   : _locale.select,
//                               style: const TextStyle(color: Colors.black),
//                             ),
//                           ),
//                         ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(
//           height: 5,
//         ),
//         Container(
//           width: MediaQuery.of(context).size.width < 800
//               ? MediaQuery.of(context).size.width * 0.9
//               : MediaQuery.of(context).size.width * 0.79 / 2.1,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(5.0),
//             border: Border.all(
//               color: Colors.grey,
//             ),
//           ),
//           padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     _locale.stockCategoryLevel("1"),
//                     style: utils.twelve400TextStyle(Colors.black),
//                   ),
//                   valueMultipleStkCateg1 == false
//                       ? Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               _locale.from,
//                               style: utils.twelve400TextStyle(Colors.black),
//                             ),
//                             const SizedBox(
//                               width: 10,
//                             ),
//                             CustomSearchDropDown(
//                               hint: selectedFromStkCategory1.isNotEmpty
//                                   ? selectedFromStkCategory1
//                                   : _locale.select,
//                               width: MediaQuery.of(context).size.width * .2,
//                               onSearch: (text) {
//                                 DropDownSearchCriteria dropDownSearchCriteria =
//                                     getSearchCriteria(text);

//                                 return salesReportController
//                                     .getSalesStkCountCateg1Method(
//                                         dropDownSearchCriteria.toJson());
//                               },
//                               onChanged: (value) {
//                                 setState(() {
//                                   print("val  $value");
//                                   selectedFromStkCategory1 = value.toString();
//                                   selectedFromStkCategory1Code =
//                                       value.codeToString();
//                                   getCategory1List();
//                                 });
//                               },
//                               value: selectedFromStkCategory1.isNotEmpty
//                                   ? selectedFromStkCategory1
//                                   : null,
//                             )
//                             // CustomDropDown(
//                             //   containerWidth:
//                             //       MediaQuery.of(context).size.width * 0.2,
//                             //   items: stkCategory1List,
//                             //   hint: selectedFromStkCategory1.isNotEmpty
//                             //       ? selectedFromStkCategory1
//                             //       : _locale.select,
//                             //   value: selectedFromStkCategory1.isNotEmpty
//                             //       ? selectedFromStkCategory1
//                             //       : null,
//                             //   onChanged: (value) {
//                             //     setState(() {
//                             //       selectedFromStkCategory1 = value!;
//                             //       getCategory1List();
//                             //     });
//                             //   },
//                             // )
//                           ],
//                         )
//                       : Row(
//                           children: [
//                             Checkbox(
//                                 value: valueSelectAllStkCateg1,
//                                 onChanged: (val) {
//                                   valueSelectAllStkCateg1 = val!;
//                                   readProvider.setCheckAllStockCategory1(
//                                       valueSelectAllStkCateg1);
//                                   // if (val) {
//                                   //   readProvider.setCodesStockCategory1(
//                                   //       stkCategory1StringList);
//                                   // } else {
//                                   readProvider.setCodesStockCategory1([]);
//                                   // }
//                                   setState(() {});
//                                 }),
//                             SizedBox(
//                               width: MediaQuery.of(context).size.width * 0.185,
//                               height:
//                                   MediaQuery.of(context).size.height * 0.052,
//                               child: Padding(
//                                 padding: EdgeInsets.only(
//                                     top: MediaQuery.of(context).size.height *
//                                         0.018),
//                                 child: SelectableText(
//                                   maxLines: 1,
//                                   _locale.selectAll,
//                                   style: utils.twelve400TextStyle(Colors.black),
//                                 ),
//                               ),
//                             )
//                           ],
//                         ),
//                 ],
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       Checkbox(
//                           value: valueMultipleStkCateg1,
//                           onChanged: (val) {
//                             valueMultipleStkCateg1 = val!;
//                             readProvider.setCheckMultipleStockCategory1(
//                                 valueMultipleStkCateg1);

//                             readProvider.setCodesStockCategory1([]);
//                             readProvider.setStkCat1List([]);
//                             readProvider.setFromCateg1("");
//                             readProvider.setToCateg1("");
//                             selectedFromStkCategory1 = "";
//                             selectedToStkCategory1 = "";
//                             setState(() {});
//                           }),
//                       Text(
//                         _locale.multiple,
//                         style: utils.twelve400TextStyle(Colors.black),
//                       ),
//                     ],
//                   ),
//                   valueMultipleStkCateg1 == false
//                       ? Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Text(
//                               _locale.to,
//                               style: utils.twelve400TextStyle(Colors.black),
//                             ),
//                             const SizedBox(
//                               width: 5,
//                             ),
//                             CustomSearchDropDown(
//                               hint: selectedToStkCategory1.isNotEmpty
//                                   ? selectedToStkCategory1
//                                   : _locale.select,
//                               value: selectedToStkCategory1.isNotEmpty
//                                   ? selectedToStkCategory1
//                                   : null,
//                               onChanged: (value) {
//                                 setState(() {
//                                   selectedToStkCategory1 = value.toString();
//                                   selectedToStkCategory1Code =
//                                       value.codeToString();
//                                   getCategory1List();
//                                 });
//                               },
//                               width: MediaQuery.of(context).size.width * 0.2,
//                               onSearch: (text) {
//                                 DropDownSearchCriteria dropDownSearchCriteria =
//                                     getSearchCriteria(text);

//                                 return salesReportController
//                                     .getSalesStkCountCateg1Method(
//                                         dropDownSearchCriteria.toJson());
//                               },
//                             )
//                           ],
//                         )
//                       : SimpleDropdownSearch(
//                           // list: stkCategory1List,
//                           enabled: !valueSelectAllStkCateg1,
//                           hintString: readProvider.getStkCat1List!,
//                           onChanged: (val) {
//                             setState(() {
//                               readProvider
//                                   .setCodesStockCategory1(getCodesList(val));
//                               readProvider.setStkCat1List(getStringList(val));
//                               print("readProv ${readProvider.getStkCat1List}");
//                             });
//                           },

//                           onSearch: (text) {
//                             DropDownSearchCriteria dropDownSearchCriteria =
//                                 getSearchCriteria(text);

//                             return salesReportController
//                                 .getSalesStkCountCateg1Method(
//                                     dropDownSearchCriteria.toJson());
//                           },
//                         ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(
//           height: 5,
//         ),
//         Container(
//           width: MediaQuery.of(context).size.width < 800
//               ? MediaQuery.of(context).size.width * 0.9
//               : MediaQuery.of(context).size.width * 0.79 / 2.1,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(5.0),
//             border: Border.all(
//               color: Colors.grey,
//             ),
//           ),
//           padding: const EdgeInsets.all(10.0),
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     _locale.stockCategoryLevel("3"),
//                     style: utils.twelve400TextStyle(Colors.black),
//                   ),
//                   valueMultipleStkCateg3 == false
//                       ? Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Text(
//                               _locale.from,
//                               style: utils.twelve400TextStyle(Colors.black),
//                             ),
//                             const SizedBox(
//                               width: 10,
//                             ),
//                             CustomSearchDropDown(
//                               hint: selectedFromStkCategory3.isNotEmpty
//                                   ? selectedFromStkCategory3
//                                   : _locale.select,
//                               value: selectedFromStkCategory3.isNotEmpty
//                                   ? selectedFromStkCategory3
//                                   : null,
//                               onChanged: (value) {
//                                 setState(() {
//                                   selectedFromStkCategory3 = value.toString();
//                                   selectedFromStkCategory3Code =
//                                       value.codeToString();
//                                   getCategory3List();
//                                 });
//                               },
//                               width: MediaQuery.of(context).size.width * 0.2,
//                               onSearch: (text) {
//                                 DropDownSearchCriteria dropDownSearchCriteria =
//                                     getSearchCriteria(text);

//                                 return salesReportController
//                                     .getSalesStkCountCateg3Method(
//                                         dropDownSearchCriteria.toJson());
//                               },
//                             )
//                             // CustomDropDown(
//                             //   containerWidth:
//                             //       MediaQuery.of(context).size.width * 0.2,
//                             //   items: stkCategory3List,
//                             //   hint: selectedFromStkCategory3.isNotEmpty
//                             //       ? selectedFromStkCategory3
//                             //       : _locale.select,
//                             //   value: selectedFromStkCategory3.isNotEmpty
//                             //       ? selectedFromStkCategory3
//                             //       : null,
//                             //   onChanged: (value) {
//                             //     setState(() {
//                             //       selectedFromStkCategory3 = value!;
//                             //       getCategory3List();
//                             //     });
//                             //   },
//                             // ),
//                           ],
//                         )
//                       : Row(
//                           children: [
//                             Checkbox(
//                                 value: valueSelectAllStkCateg3,
//                                 onChanged: (val) {
//                                   valueSelectAllStkCateg3 = val!;
//                                   readProvider.setCheckAllStockCategory3(
//                                       valueSelectAllStkCateg3);
//                                   // if (val) {
//                                   //   readProvider.setCodesStockCategory3(
//                                   //       stkCategory3StringList);
//                                   // } else {
//                                   readProvider.setCodesStockCategory3([]);
//                                   //   }
//                                   setState(() {});
//                                 }),
//                             SizedBox(
//                               width: MediaQuery.of(context).size.width * 0.185,
//                               height:
//                                   MediaQuery.of(context).size.height * 0.052,
//                               child: Padding(
//                                 padding: EdgeInsets.only(
//                                     top: MediaQuery.of(context).size.height *
//                                         0.018),
//                                 child: SelectableText(
//                                   maxLines: 1,
//                                   _locale.selectAll,
//                                   style: utils.twelve400TextStyle(Colors.black),
//                                 ),
//                               ),
//                             )
//                           ],
//                         ),
//                 ],
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       Checkbox(
//                           value: valueMultipleStkCateg3,
//                           onChanged: (val) {
//                             valueMultipleStkCateg3 = val!;
//                             readProvider.setCheckMultipleStockCategory3(
//                                 valueMultipleStkCateg3);

//                             readProvider.setCodesStockCategory3([]);
//                             readProvider.setStkCat3List([]);
//                             readProvider.setFromCateg3("");
//                             readProvider.setToCateg3("");
//                             selectedFromStkCategory3 = "";
//                             selectedToStkCategory3 = "";
//                             setState(() {});
//                           }),
//                       Text(
//                         _locale.multiple,
//                         style: utils.twelve400TextStyle(Colors.black),
//                       ),
//                     ],
//                   ),
//                   valueMultipleStkCateg3 == false
//                       ? Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Text(
//                               _locale.to,
//                               style: utils.twelve400TextStyle(Colors.black),
//                             ),
//                             const SizedBox(
//                               width: 5,
//                             ),
//                             CustomSearchDropDown(
//                               hint: selectedToStkCategory3.isNotEmpty
//                                   ? selectedToStkCategory3
//                                   : _locale.select,
//                               width: MediaQuery.of(context).size.width * 0.2,
//                               onSearch: (text) {
//                                 DropDownSearchCriteria dropDownSearchCriteria =
//                                     getSearchCriteria(text);

//                                 return salesReportController
//                                     .getSalesStkCountCateg3Method(
//                                         dropDownSearchCriteria.toJson());
//                               },
//                               value: selectedToStkCategory3.isNotEmpty
//                                   ? selectedToStkCategory3
//                                   : null,
//                               onChanged: (value) {
//                                 setState(() {
//                                   selectedToStkCategory3 = value.toString();
//                                   selectedToStkCategory3Code =
//                                       value.codeToString();
//                                   getCategory3List();
//                                 });
//                               },
//                             )
//                             // CustomDropDown(
//                             //   containerWidth:
//                             //       MediaQuery.of(context).size.width * 0.2,
//                             //   items: stkCategory3List,
//                             //   hint: selectedToStkCategory3.isNotEmpty
//                             //       ? selectedToStkCategory3
//                             //       : _locale.select,
//                             //   value: selectedToStkCategory3.isNotEmpty
//                             //       ? selectedToStkCategory3
//                             //       : null,
//                             //   onChanged: (value) {
//                             //     setState(() {
//                             //       selectedToStkCategory3 = value!;
//                             //       getCategory3List();
//                             //     });
//                             //   },
//                             // ),
//                           ],
//                         )
//                       : SimpleDropdownSearch(
//                           // list: stkCategory3List,
//                           enabled: !valueSelectAllStkCateg3,
//                           hintString: readProvider.getStkCat3List == null
//                               ? []
//                               : readProvider.getStkCat3List!,
//                           onChanged: (val) {
//                             setState(() {
//                               readProvider
//                                   .setCodesStockCategory3(getCodesList(val));
//                               readProvider.setStkCat3List(getStringList(val));
//                             });
//                           },
//                           onSearch: (text) {
//                             DropDownSearchCriteria dropDownSearchCriteria =
//                                 getSearchCriteria(text);

//                             return salesReportController
//                                 .getSalesStkCountCateg3Method(
//                                     dropDownSearchCriteria.toJson());
//                           },
//                         ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(
//           height: 5,
//         ),
//         Container(
//           width: MediaQuery.of(context).size.width < 800
//               ? MediaQuery.of(context).size.width * 0.9
//               : MediaQuery.of(context).size.width * 0.79 / 2.1,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(5.0),
//             border: Border.all(
//               color: Colors.grey,
//             ),
//           ),
//           padding: const EdgeInsets.all(10.0),
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     _locale.customer,
//                     style: utils.twelve400TextStyle(Colors.black),
//                   ),
//                   valueMultipleCustomer == false
//                       ? Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Text(
//                               _locale.from,
//                               style: utils.twelve400TextStyle(Colors.black),
//                             ),
//                             const SizedBox(
//                               width: 10,
//                             ),
//                             CustomSearchDropDown(
//                               onSearch: (text) {
//                                 DropDownSearchCriteria dropDownSearchCriteria =
//                                     getSearchCriteria(text);

//                                 return salesReportController
//                                     .getSalesCustomersMethod(
//                                         dropDownSearchCriteria.toJson());
//                               },
//                               width: MediaQuery.of(context).size.width * 0.2,
//                               // items: customersList,
//                               hint: selectedFromCustomers.isNotEmpty
//                                   ? selectedFromCustomers
//                                   : _locale.select,
//                               value: selectedFromCustomers.isNotEmpty
//                                   ? selectedFromCustomers
//                                   : null,
//                               onChanged: (value) {
//                                 setState(() {
//                                   selectedFromCustomers = value.toString();
//                                   selectedFromCustomersCode =
//                                       value.codeToString();
//                                   getCustomerList();
//                                 });
//                               },
//                             ),
//                           ],
//                         )
//                       : Row(
//                           children: [
//                             Checkbox(
//                                 value: valueSelectAllCustomer,
//                                 onChanged: (val) {
//                                   valueSelectAllCustomer = val!;
//                                   readProvider.setCheckAllCustomer(
//                                       valueSelectAllCustomer);
//                                   // if (val) {
//                                   //   readProvider
//                                   //       .setCodesCustomer(customersStringList);
//                                   // } else {
//                                   readProvider.setCodesCustomer([]);
//                                   // }
//                                   setState(() {});
//                                 }),
//                             SizedBox(
//                               width: MediaQuery.of(context).size.width * 0.185,
//                               height:
//                                   MediaQuery.of(context).size.height * 0.052,
//                               child: Padding(
//                                 padding: EdgeInsets.only(
//                                     top: MediaQuery.of(context).size.height *
//                                         0.018),
//                                 child: SelectableText(
//                                   maxLines: 1,
//                                   _locale.selectAll,
//                                   style: utils.twelve400TextStyle(Colors.black),
//                                 ),
//                               ),
//                             )
//                           ],
//                         ),
//                 ],
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       Checkbox(
//                           value: valueMultipleCustomer,
//                           onChanged: (val) {
//                             valueMultipleCustomer = val!;
//                             readProvider.setCheckMultipleCustomer(
//                                 valueMultipleCustomer);

//                             readProvider.setCodesCustomer([]);
//                             readProvider.setCustomersList([]);
//                             readProvider.setFromCust("");
//                             readProvider.setToCust("");
//                             selectedFromCustomers = "";
//                             selectedToCustomers = "";
//                             //    }
//                             setState(() {});
//                           }),
//                       Text(
//                         _locale.multiple,
//                         style: utils.twelve400TextStyle(Colors.black),
//                       ),
//                     ],
//                   ),
//                   valueMultipleCustomer == false
//                       ? Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Text(
//                               _locale.to,
//                               style: utils.twelve400TextStyle(Colors.black),
//                             ),
//                             const SizedBox(
//                               width: 5,
//                             ),
//                             CustomSearchDropDown(
//                               onSearch: (text) {
//                                 DropDownSearchCriteria dropDownSearchCriteria =
//                                     getSearchCriteria(text);

//                                 return salesReportController
//                                     .getSalesCustomersMethod(
//                                         dropDownSearchCriteria.toJson());
//                               },
//                               width: MediaQuery.of(context).size.width * 0.2,
//                               // items: customersList,
//                               hint: selectedToCustomers.isNotEmpty
//                                   ? selectedToCustomers
//                                   : _locale.select,
//                               value: selectedToCustomers.isNotEmpty
//                                   ? selectedToCustomers
//                                   : null,
//                               onChanged: (value) {
//                                 setState(() {
//                                   selectedToCustomers = value.toString();
//                                   selectedToCustomersCode =
//                                       value.codeToString();
//                                   getCustomerList();
//                                 });
//                               },
//                             ),
//                           ],
//                         )
//                       : SimpleDropdownSearch(
//                           // list: customersList,
//                           enabled: !valueSelectAllCustomer,
//                           hintString: readProvider.getCustomersList == null
//                               ? []
//                               : readProvider.getCustomersList!,
//                           onChanged: (val) {
//                             setState(() {
//                               readProvider.setCodesCustomer(getCodesList(val));
//                               readProvider.setCustomersList(getStringList(val));
//                             });
//                           },
//                           onSearch: (text) {
//                             DropDownSearchCriteria dropDownSearchCriteria =
//                                 getSearchCriteria(text);

//                             return salesReportController
//                                 .getSalesCustomersMethod(
//                                     dropDownSearchCriteria.toJson());
//                           },
//                         ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(
//           height: 5,
//         ),
//         Container(
//           width: MediaQuery.of(context).size.width < 800
//               ? MediaQuery.of(context).size.width * 0.9
//               : MediaQuery.of(context).size.width * 0.79 / 2.1,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(5.0),
//             border: Border.all(
//               color: Colors.grey,
//             ),
//           ),
//           padding: const EdgeInsets.all(10.0),
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     _locale.stock,
//                     style: utils.twelve400TextStyle(Colors.black),
//                   ),
//                   valueMultipleStock == false
//                       ? Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Text(
//                               _locale.from,
//                               style: utils.twelve400TextStyle(Colors.black),
//                             ),
//                             const SizedBox(
//                               width: 10,
//                             ),
//                             CustomSearchDropDown(
//                               onSearch: (text) {
//                                 DropDownSearchCriteria dropDownSearchCriteria =
//                                     getSearchCriteria(text);

//                                 return salesReportController.getSalesStkMethod(
//                                     dropDownSearchCriteria.toJson());
//                               },
//                               width: MediaQuery.of(context).size.width * 0.2,
//                               // items: stocksList,
//                               hint: selectedFromStocks.isNotEmpty
//                                   ? selectedFromStocks
//                                   : _locale.select,
//                               value: selectedFromStocks.isNotEmpty
//                                   ? selectedFromStocks
//                                   : null,
//                               onChanged: (value) {
//                                 setState(() {
//                                   selectedFromStocks = value.toString();
//                                   selectedFromStocksCode = value.codeToString();
//                                   getStockList();
//                                 });
//                               },
//                             ),
//                           ],
//                         )
//                       : Row(
//                           children: [
//                             Checkbox(
//                                 value: valueSelectAllStock,
//                                 onChanged: (val) {
//                                   valueSelectAllStock = val!;
//                                   readProvider
//                                       .setCheckAllStock(valueSelectAllStock);
//                                   // if (val) {
//                                   //   readProvider
//                                   //       .setCodesStock(stocksStringList);
//                                   // } else {
//                                   readProvider.setCodesStock([]);
//                                   //  }
//                                   setState(() {});
//                                 }),
//                             SizedBox(
//                               width: MediaQuery.of(context).size.width * 0.185,
//                               height:
//                                   MediaQuery.of(context).size.height * 0.052,
//                               child: Padding(
//                                 padding: EdgeInsets.only(
//                                     top: MediaQuery.of(context).size.height *
//                                         0.018),
//                                 child: SelectableText(
//                                   maxLines: 1,
//                                   _locale.selectAll,
//                                   style: utils.twelve400TextStyle(Colors.black),
//                                 ),
//                               ),
//                             )
//                           ],
//                         ),
//                 ],
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       Checkbox(
//                           value: valueMultipleStock,
//                           onChanged: (val) {
//                             valueMultipleStock = val!;
//                             readProvider
//                                 .setCheckMultipleStock(valueMultipleStock);

//                             readProvider.setCodesStock([]);
//                             readProvider.setStockList([]);
//                             readProvider.setFromStock("");
//                             readProvider.setToStock("");
//                             selectedFromStocks = "";
//                             selectedToStocks = "";
//                             setState(() {});
//                           }),
//                       Text(
//                         _locale.multiple,
//                         style: utils.twelve400TextStyle(Colors.black),
//                       ),
//                     ],
//                   ),
//                   valueMultipleStock == false
//                       ? Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Text(
//                               _locale.to,
//                               style: utils.twelve400TextStyle(Colors.black),
//                             ),
//                             const SizedBox(
//                               width: 5,
//                             ),
//                             CustomSearchDropDown(
//                               onSearch: (text) {
//                                 DropDownSearchCriteria dropDownSearchCriteria =
//                                     getSearchCriteria(text);

//                                 return salesReportController.getSalesStkMethod(
//                                     dropDownSearchCriteria.toJson());
//                               },
//                               width: MediaQuery.of(context).size.width * 0.2,
//                               //items: stocksList,
//                               hint: selectedToStocks.isNotEmpty
//                                   ? selectedToStocks
//                                   : _locale.select,
//                               value: selectedToStocks.isNotEmpty
//                                   ? selectedToStocks
//                                   : null,
//                               onChanged: (value) {
//                                 setState(() {
//                                   selectedToStocks = value.toString();
//                                   selectedToStocksCode = value.codeToString();
//                                   getStockList();
//                                 });
//                               },
//                             ),
//                           ],
//                         )
//                       : SimpleDropdownSearch(
//                           // list: stocksList,
//                           enabled: !valueSelectAllStock,
//                           hintString: readProvider.getStockList == null
//                               ? []
//                               : readProvider.getStockList!,
//                           onChanged: (val) {
//                             setState(() {
//                               readProvider.setCodesStock(getCodesList(val));
//                               readProvider.setStockList(getStringList(val));
//                             });
//                           },
//                           onSearch: (text) {
//                             DropDownSearchCriteria dropDownSearchCriteria =
//                                 getSearchCriteria(text);

//                             return salesReportController.getSalesStkMethod(
//                                 dropDownSearchCriteria.toJson());
//                           },
//                         ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   DropDownSearchCriteria getSearchCriteria(String text) {
//     String todayDate = DatesController().formatDateReverse(
//         DatesController().formatDate(DatesController().todayDate()));
//     widget.fromDate.text = readProvider.getFromDate!.isNotEmpty
//         ? DatesController()
//             .formatDateReverse(readProvider.getFromDate.toString())
//         : todayDate;

//     widget.toDate.text = readProvider.getToDate!.isNotEmpty
//         ? DatesController().formatDateReverse(readProvider.getToDate.toString())
//         : todayDate;
//     DropDownSearchCriteria dropDownSearchCriteria = DropDownSearchCriteria(
//         fromDate: DatesController().formatDate(widget.fromDate.text),
//         toDate: DatesController().formatDate(widget.toDate.text),
//         nameCode: text);
//     return dropDownSearchCriteria;
//   }

//   void getCategory1List() {
//     List<String> stringStkCategory1List = [];

//     if (selectedFromStkCategory1Code.isNotEmpty) {
//       stringStkCategory1List.add(selectedFromStkCategory1Code);
//     }
//     if (selectedToStkCategory1Code.isNotEmpty) {
//       stringStkCategory1List.add(selectedToStkCategory1Code);
//     }
//     readProvider.setFromCateg1(selectedFromStkCategory1);
//     readProvider.setToCateg1(selectedToStkCategory1);
//     readProvider.setCodesStockCategory1(stringStkCategory1List);
//   }

//   void getCategory3List() {
//     List<String> stringStkCategory3List = [];
//     // for (int i = 0; i < stkCategory3List.length; i++) {
//     //   if (stkCategory3List[i].toString() == selectedFromStkCategory3) {

//     //   }
//     //   if (stkCategory3List[i].toString() == selectedToStkCategory3) {

//     //   }
//     // }
//     if (selectedFromStkCategory3Code.isNotEmpty) {
//       stringStkCategory3List.add(selectedFromStkCategory3Code);
//     }
//     if (selectedToStkCategory3Code.isNotEmpty) {
//       stringStkCategory3List.add(selectedToStkCategory3Code);
//     }
//     readProvider.setFromCateg3(selectedFromStkCategory3);
//     readProvider.setToCateg3(selectedToStkCategory3);
//     readProvider.setCodesStockCategory3(stringStkCategory3List);
//   }

//   void getCustomerList() {
//     List<String> stringCustomerList = [];

//     // for (int i = 0; i < customersList.length; i++) {
//     //   if (customersList[i].toString() == selectedFromCustomers) {

//     //   }
//     //   if (customersList[i].toString() == selectedToCustomers) {

//     //   }
//     // }
//     if (selectedFromCustomersCode.isNotEmpty) {
//       stringCustomerList.add(selectedFromCustomersCode);
//     }
//     if (selectedToCustomersCode.isNotEmpty) {
//       stringCustomerList.add(selectedToCustomersCode);
//     }
//     readProvider.setFromCust(selectedFromCustomers);
//     readProvider.setToCust(selectedToCustomers);
//     readProvider.setCodesCustomer(stringCustomerList);
//   }

//   void getStockList() {
//     List<String> stringStockList = [];

//     // for (int i = 0; i < stocksList.length; i++) {
//     //   if (stocksList[i].toString() == selectedFromStocks) {}
//     //   if (stocksList[i].toString() == selectedToStocks) {}
//     // }
//     if (selectedFromStocksCode.isNotEmpty) {
//       stringStockList.add(selectedFromStocksCode);
//     }
//     if (selectedToStocksCode.isNotEmpty) {
//       stringStockList.add(selectedToStocksCode);
//     }
//     readProvider.setFromStock(selectedFromStocks);
//     readProvider.setToStock(selectedToStocks);
//     readProvider.setCodesStock(stringStockList);
//   }

//   List<String> getCodesList(List<dynamic> val) {
//     List<String> codesString = [];
//     for (int i = 0; i < val.length; i++) {
//       String newString = (val[i].toString().trim()).replaceAll(" ", "");
//       print(newString);
//       codesString.add(newString.substring(0, newString.indexOf("-")));
//     }
//     return codesString;
//   }

//   List<String> getStringList(List<dynamic> val) {
//     List<String> codesString = [];
//     for (int i = 0; i < val.length; i++) {
//       String newString = (val[i].toString().trim()).replaceAll(" ", "");
//       print(newString);
//       codesString.add(newString);
//     }
//     return codesString;
//   }
// }

// class RightWidget extends StatefulWidget {
//   final TextEditingController fromDate;
//   final TextEditingController toDate;
//   const RightWidget({Key? key, required this.fromDate, required this.toDate})
//       : super(key: key);

//   @override
//   State<RightWidget> createState() => _RightWidgetState();
// }

// class _RightWidgetState extends State<RightWidget> {
//   ReportController salesReportController = ReportController();
//   TextEditingController campaignNoController = TextEditingController();
//   TextEditingController modelNoController = TextEditingController();

//   // List<BranchModel> stkCategory2List = [];
//   // List<BranchModel> branchesList = [];
//   // List<BranchModel> suppliersList = [];
//   // List<BranchModel> customerCategoryList = [];

//   var selectedFromStkCategory2 = "";
//   var selectedToStkCategory2 = "";

//   var selectedFromBranches = "";
//   var selectedToBranches = "";

//   var selectedFromSupplier = "";
//   var selectedToSupplier = "";

//   var selectedFromCustomerCategory = "";
//   var selectedToCustomerCategory = "";

//   var selectedFromStkCategory2Code = "";
//   var selectedToStkCategory2Code = "";

//   var selectedFromBranchesCode = "";
//   var selectedToBranchesCode = "";

//   var selectedFromSupplierCode = "";
//   var selectedToSupplierCode = "";

//   var selectedFromCustomerCategoryCode = "";
//   var selectedToCustomerCategoryCode = "";
//   var utils = Components();

//   bool valueMultipleStkCategory2 = false;
//   bool valueMultipleBranches = false;
//   bool valueMultipleSupplier = false;
//   bool valueMultipleCustomerCategory = false;

//   bool valueSelectAllStkCategory2 = false;
//   bool valueSelectAllBranches = false;
//   bool valueSelectAllSupplier = false;
//   bool valueSelectAllCustomerCategory = false;

//   late AppLocalizations _locale;
//   late SalesCriteraProvider readProvider;

//   @override
//   void didChangeDependencies() {
//     _locale = AppLocalizations.of(context);
//     readProvider = context.read<SalesCriteraProvider>();

//     super.didChangeDependencies();
//   }

//   @override
//   Widget build(BuildContext context) {
//     String todayDate = DatesController().formatDateReverse(
//         DatesController().formatDate(DatesController().todayDate()));
//     widget.fromDate.text = readProvider.getFromDate!.isNotEmpty
//         ? DatesController()
//             .formatDateReverse(readProvider.getFromDate.toString())
//         : todayDate;

//     widget.toDate.text = readProvider.getToDate!.isNotEmpty
//         ? DatesController().formatDateReverse(readProvider.getToDate.toString())
//         : todayDate;

//     selectedFromStkCategory2 = readProvider.getFromCateg2!;
//     selectedToStkCategory2 = readProvider.getToCateg2!;

//     selectedFromBranches = readProvider.getFromBranch!;
//     selectedToBranches = readProvider.getToBranch!;

//     selectedFromSupplier = readProvider.getFromSupp!;
//     selectedToSupplier = readProvider.getToSupp!;

//     selectedFromCustomerCategory = readProvider.getFromCustCateg!;
//     selectedToCustomerCategory = readProvider.getToCustCateg!;
//     valueMultipleStkCategory2 = readProvider.getCheckMultipleStockCategory2!;
//     valueMultipleBranches = readProvider.getCheckMultipleBranch!;
//     valueMultipleSupplier = readProvider.getCheckMultipleSupplier!;
//     valueMultipleCustomerCategory =
//         readProvider.getCheckMultipleCustomerCategory!;

//     valueSelectAllStkCategory2 = readProvider.getCheckAllStockCategory2!;
//     valueSelectAllBranches = readProvider.getCheckAllBranch!;
//     valueSelectAllSupplier = readProvider.getCheckAllSupplier!;
//     valueSelectAllCustomerCategory = readProvider.getCheckAllCustomerCategory!;

//     modelNoController.text = readProvider.getModelNo!;
//     campaignNoController.text = readProvider.getCampaignNo!;
//     return Column(
//       children: [
//         Container(
//           width: MediaQuery.of(context).size.width < 800
//               ? MediaQuery.of(context).size.width * 0.9
//               : MediaQuery.of(context).size.width * 0.8 / 2.1,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(5.0),
//             border: Border.all(
//               color: Colors.grey,
//             ),
//           ),
//           padding: const EdgeInsets.all(10.0),
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     _locale.branch,
//                     style: utils.twelve400TextStyle(Colors.black),
//                   ),
//                   valueMultipleBranches == false
//                       ? Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Text(
//                               _locale.from,
//                               style: utils.twelve400TextStyle(Colors.black),
//                             ),
//                             const SizedBox(
//                               width: 10,
//                             ),
//                             CustomSearchDropDown(
//                               width: MediaQuery.of(context).size.width * 0.2,
//                               // items: branchesList,
//                               hint: selectedFromBranches.isNotEmpty
//                                   ? selectedFromBranches
//                                   : _locale.select,
//                               value: selectedFromBranches.isNotEmpty
//                                   ? selectedFromBranches
//                                   : null,
//                               onChanged: (value) {
//                                 setState(() {
//                                   selectedFromBranches = value.toString();
//                                   selectedFromBranchesCode =
//                                       value.codeToString();
//                                   getBranchList();
//                                 });
//                               },
//                               onSearch: (text) {
//                                 DropDownSearchCriteria dropDownSearchCriteria =
//                                     getSearchCriteria(text);
//                                 return salesReportController
//                                     .getSalesBranchesMethod(
//                                         dropDownSearchCriteria.toJson());
//                               },
//                             ),
//                           ],
//                         )
//                       : Row(
//                           children: [
//                             Checkbox(
//                                 value: valueSelectAllBranches,
//                                 onChanged: (val) {
//                                   valueSelectAllBranches = val!;
//                                   readProvider.setCheckAllBranch(
//                                       valueSelectAllBranches);
//                                   // if (val) {
//                                   //   readProvider
//                                   //       .setCodesBranch(branchesStringList);
//                                   // } else {
//                                   readProvider.setCodesBranch([]);
//                                   //  }
//                                   setState(() {});
//                                 }),
//                             SizedBox(
//                               width: MediaQuery.of(context).size.width * 0.185,
//                               height:
//                                   MediaQuery.of(context).size.height * 0.052,
//                               child: Padding(
//                                 padding: EdgeInsets.only(
//                                     top: MediaQuery.of(context).size.height *
//                                         0.018),
//                                 child: SelectableText(
//                                   maxLines: 1,
//                                   _locale.selectAll,
//                                   style: utils.twelve400TextStyle(Colors.black),
//                                 ),
//                               ),
//                             )
//                           ],
//                         ),
//                 ],
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       Checkbox(
//                           value: valueMultipleBranches,
//                           onChanged: (val) {
//                             valueMultipleBranches = val!;
//                             readProvider
//                                 .setCheckMultipleBranch(valueMultipleBranches);

//                             readProvider.setCodesBranch([]);
//                             readProvider.setBranchList([]);
//                             readProvider.setFromBranch("");
//                             readProvider.setToBranch("");
//                             selectedFromBranches = "";
//                             selectedToBranches = "";
//                             setState(() {});
//                           }),
//                       Text(
//                         _locale.multiple,
//                         style: utils.twelve400TextStyle(Colors.black),
//                       ),
//                     ],
//                   ),
//                   valueMultipleBranches == false
//                       ? Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Text(
//                               _locale.to,
//                               style: utils.twelve400TextStyle(Colors.black),
//                             ),
//                             const SizedBox(
//                               width: 5,
//                             ),
//                             CustomSearchDropDown(
//                               width: MediaQuery.of(context).size.width * 0.2,
//                               // items: branchesList,
//                               hint: selectedToBranches.isNotEmpty
//                                   ? selectedToBranches
//                                   : _locale.select,
//                               value: selectedToBranches.isNotEmpty
//                                   ? selectedToBranches
//                                   : null,
//                               onChanged: (value) {
//                                 setState(() {
//                                   selectedToBranches = value.toString();
//                                   selectedToBranchesCode = value.codeToString();
//                                   getBranchList();
//                                 });
//                               },
//                               onSearch: (text) {
//                                 DropDownSearchCriteria dropDownSearchCriteria =
//                                     getSearchCriteria(text);
//                                 return salesReportController
//                                     .getSalesBranchesMethod(
//                                         dropDownSearchCriteria.toJson());
//                               },
//                             ),
//                           ],
//                         )
//                       : SimpleDropdownSearch(
//                           // list: branchesList,
//                           enabled: !valueSelectAllBranches,
//                           hintString: readProvider.getBranchList == null
//                               ? []
//                               : readProvider.getBranchList!,
//                           onChanged: (val) {
//                             setState(() {
//                               readProvider.setCodesBranch(getCodesList(val));
//                               readProvider.setBranchList(getStringList(val));
//                             });
//                           },
//                           onSearch: (text) {
//                             DropDownSearchCriteria dropDownSearchCriteria =
//                                 getSearchCriteria(text);
//                             return salesReportController.getSalesBranchesMethod(
//                                 dropDownSearchCriteria.toJson());
//                           },
//                         ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(
//           height: 5,
//         ),
//         Container(
//           width: MediaQuery.of(context).size.width < 800
//               ? MediaQuery.of(context).size.width * 0.9
//               : MediaQuery.of(context).size.width * 0.8 / 2.1,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(5.0),
//             border: Border.all(
//               color: Colors.grey,
//             ),
//           ),
//           padding: const EdgeInsets.all(10.0),
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     _locale.stockCategoryLevel("2"),
//                     style: utils.twelve400TextStyle(Colors.black),
//                   ),
//                   valueMultipleStkCategory2 == false
//                       ? Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Text(
//                               _locale.from,
//                               style: utils.twelve400TextStyle(Colors.black),
//                             ),
//                             const SizedBox(
//                               width: 10,
//                             ),
//                             CustomSearchDropDown(
//                               width: MediaQuery.of(context).size.width * 0.2,
//                               // items: stkCategory2List,
//                               hint: selectedFromStkCategory2.isNotEmpty
//                                   ? selectedFromStkCategory2
//                                   : _locale.select,
//                               value: selectedFromStkCategory2.isNotEmpty
//                                   ? selectedFromStkCategory2
//                                   : null,
//                               onChanged: (value) {
//                                 setState(() {
//                                   selectedFromStkCategory2 = value.toString();
//                                   selectedFromStkCategory2Code =
//                                       value.codeToString();
//                                   getCategory2List();
//                                 });
//                               },
//                               onSearch: (text) {
//                                 DropDownSearchCriteria dropDownSearchCriteria =
//                                     getSearchCriteria(text);
//                                 return salesReportController
//                                     .getSalesStkCountCateg2Method(
//                                         dropDownSearchCriteria.toJson());
//                               },
//                             ),
//                           ],
//                         )
//                       : Row(
//                           children: [
//                             Checkbox(
//                                 value: valueSelectAllStkCategory2,
//                                 onChanged: (val) {
//                                   valueSelectAllStkCategory2 = val!;
//                                   readProvider.setCheckAllStockCategory2(
//                                       valueSelectAllStkCategory2);
//                                   // if (val) {
//                                   //   readProvider.setCodesStockCategory2(
//                                   //       stkCategory2StringList);
//                                   // } else {
//                                   readProvider.setCodesStockCategory2([]);
//                                   //  }
//                                   setState(() {});
//                                 }),
//                             SizedBox(
//                               width: MediaQuery.of(context).size.width * 0.185,
//                               height:
//                                   MediaQuery.of(context).size.height * 0.052,
//                               child: Padding(
//                                 padding: EdgeInsets.only(
//                                     top: MediaQuery.of(context).size.height *
//                                         0.018),
//                                 child: SelectableText(
//                                   maxLines: 1,
//                                   _locale.selectAll,
//                                   style: utils.twelve400TextStyle(Colors.black),
//                                 ),
//                               ),
//                             )
//                           ],
//                         ),
//                 ],
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       Checkbox(
//                           value: valueMultipleStkCategory2,
//                           onChanged: (val) {
//                             valueMultipleStkCategory2 = val!;
//                             readProvider.setCheckMultipleStockCategory2(
//                                 valueMultipleStkCategory2);

//                             readProvider.setCodesStockCategory2([]);
//                             readProvider.setStkCat2List([]);
//                             readProvider.setFromCateg2("");
//                             readProvider.setToCateg2("");
//                             selectedFromStkCategory2 = "";
//                             selectedToStkCategory2 = "";
//                             setState(() {});
//                           }),
//                       Text(
//                         _locale.multiple,
//                         style: utils.twelve400TextStyle(Colors.black),
//                       ),
//                     ],
//                   ),
//                   valueMultipleStkCategory2 == false
//                       ? Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Text(
//                               _locale.to,
//                               style: utils.twelve400TextStyle(Colors.black),
//                             ),
//                             const SizedBox(
//                               width: 5,
//                             ),
//                             CustomSearchDropDown(
//                               width: MediaQuery.of(context).size.width * 0.2,
//                               // items: stkCategory2List,
//                               hint: selectedToStkCategory2.isNotEmpty
//                                   ? selectedToStkCategory2
//                                   : _locale.select,
//                               value: selectedToStkCategory2.isNotEmpty
//                                   ? selectedToStkCategory2
//                                   : null,
//                               onChanged: (value) {
//                                 setState(() {
//                                   selectedToStkCategory2 = value.toString();
//                                   selectedToStkCategory2Code =
//                                       value.codeToString();
//                                   getCategory2List();
//                                 });
//                               },
//                               onSearch: (text) {
//                                 DropDownSearchCriteria dropDownSearchCriteria =
//                                     getSearchCriteria(text);
//                                 return salesReportController
//                                     .getSalesStkCountCateg2Method(
//                                         dropDownSearchCriteria.toJson());
//                               },
//                             ),
//                           ],
//                         )
//                       : SimpleDropdownSearch(
//                           // list: stkCategory2List,
//                           enabled: !valueSelectAllStkCategory2,
//                           hintString: readProvider.getStkCat2List == null
//                               ? []
//                               : readProvider.getStkCat2List!,
//                           onChanged: (val) {
//                             setState(() {
//                               readProvider
//                                   .setCodesStockCategory2(getCodesList(val));
//                               readProvider.setStkCat2List(getStringList(val));
//                             });
//                           },
//                           onSearch: (text) {
//                             DropDownSearchCriteria dropDownSearchCriteria =
//                                 getSearchCriteria(text);
//                             return salesReportController
//                                 .getSalesStkCountCateg2Method(
//                                     dropDownSearchCriteria.toJson());
//                           },
//                         ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(
//           height: 5,
//         ),
//         Container(
//           width: MediaQuery.of(context).size.width < 800
//               ? MediaQuery.of(context).size.width * 0.9
//               : MediaQuery.of(context).size.width * 0.8 / 2.1,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(5.0),
//             border: Border.all(
//               color: Colors.grey,
//             ),
//           ),
//           padding: const EdgeInsets.all(10.0),
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     _locale.supplier(""),
//                     style: utils.twelve400TextStyle(Colors.black),
//                   ),
//                   valueMultipleSupplier == false
//                       ? Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Text(
//                               _locale.from,
//                               style: utils.twelve400TextStyle(Colors.black),
//                             ),
//                             const SizedBox(
//                               width: 10,
//                             ),
//                             CustomSearchDropDown(
//                               width: MediaQuery.of(context).size.width * 0.2,
//                               // items: suppliersList,
//                               hint: selectedFromSupplier.isNotEmpty
//                                   ? selectedFromSupplier
//                                   : _locale.select,
//                               value: selectedFromSupplier.isNotEmpty
//                                   ? selectedFromSupplier
//                                   : null,
//                               onChanged: (value) {
//                                 setState(() {
//                                   selectedFromSupplier = value.toString();
//                                   selectedFromSupplierCode =
//                                       value.codeToString();
//                                   getSupplierList();
//                                 });
//                               },
//                               onSearch: (text) {
//                                 DropDownSearchCriteria dropDownSearchCriteria =
//                                     getSearchCriteria(text);
//                                 return salesReportController
//                                     .getSalesSuppliersMethod(
//                                         dropDownSearchCriteria.toJson());
//                               },
//                             ),
//                           ],
//                         )
//                       : Row(
//                           children: [
//                             Checkbox(
//                                 value: valueSelectAllSupplier,
//                                 onChanged: (val) {
//                                   valueSelectAllSupplier = val!;
//                                   readProvider.setCheckAllSupplier(
//                                       valueSelectAllSupplier);
//                                   // if (val) {
//                                   //   readProvider
//                                   //       .setCodesSupplier(suppliersStringList);
//                                   // } else {
//                                   readProvider.setCodesSupplier([]);
//                                   // }
//                                   setState(() {});
//                                 }),
//                             SizedBox(
//                               width: MediaQuery.of(context).size.width * 0.185,
//                               height:
//                                   MediaQuery.of(context).size.height * 0.052,
//                               child: Padding(
//                                 padding: EdgeInsets.only(
//                                     top: MediaQuery.of(context).size.height *
//                                         0.018),
//                                 child: SelectableText(
//                                   maxLines: 1,
//                                   _locale.selectAll,
//                                   style: utils.twelve400TextStyle(Colors.black),
//                                 ),
//                               ),
//                             )
//                           ],
//                         ),
//                 ],
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       Checkbox(
//                           value: valueMultipleSupplier,
//                           onChanged: (val) {
//                             valueMultipleSupplier = val!;
//                             readProvider.setCheckMultipleSupplier(
//                                 valueMultipleSupplier);

//                             readProvider.setCodesSupplier([]);
//                             readProvider.setSupplierList([]);
//                             readProvider.setFromSupp("");
//                             readProvider.setToSupp("");
//                             selectedFromSupplier = "";
//                             selectedToSupplier = "";
//                             setState(() {});
//                           }),
//                       Text(
//                         _locale.multiple,
//                         style: utils.twelve400TextStyle(Colors.black),
//                       ),
//                     ],
//                   ),
//                   valueMultipleSupplier == false
//                       ? Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Text(
//                               _locale.to,
//                               style: utils.twelve400TextStyle(Colors.black),
//                             ),
//                             const SizedBox(
//                               width: 5,
//                             ),
//                             CustomSearchDropDown(
//                               width: MediaQuery.of(context).size.width * 0.2,
//                               // items: suppliersList,
//                               hint: selectedToSupplier.isNotEmpty
//                                   ? selectedToSupplier
//                                   : _locale.select,
//                               value: selectedToSupplier.isNotEmpty
//                                   ? selectedToSupplier
//                                   : null,
//                               onChanged: (value) {
//                                 setState(() {
//                                   selectedToSupplier = value.toString();
//                                   selectedToSupplierCode = value.codeToString();
//                                   getSupplierList();
//                                 });
//                               },
//                               onSearch: (text) {
//                                 DropDownSearchCriteria dropDownSearchCriteria =
//                                     getSearchCriteria(text);
//                                 return salesReportController
//                                     .getSalesSuppliersMethod(
//                                         dropDownSearchCriteria.toJson());
//                               },
//                             ),
//                           ],
//                         )
//                       : SimpleDropdownSearch(
//                           // list: suppliersList,
//                           enabled: !valueSelectAllSupplier,
//                           hintString: readProvider.getSupplierList == null
//                               ? []
//                               : readProvider.getSupplierList!,
//                           onChanged: (val) {
//                             setState(() {
//                               readProvider.setCodesSupplier(getCodesList(val));
//                               readProvider.setSupplierList(getStringList(val));
//                             });
//                           },
//                           onSearch: (text) {
//                             DropDownSearchCriteria dropDownSearchCriteria =
//                                 getSearchCriteria(text);
//                             return salesReportController
//                                 .getSalesSuppliersMethod(
//                                     dropDownSearchCriteria.toJson());
//                           },
//                         ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(
//           height: 5,
//         ),
//         Container(
//           width: MediaQuery.of(context).size.width < 800
//               ? MediaQuery.of(context).size.width * 0.9
//               : MediaQuery.of(context).size.width * 0.8 / 2.1,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(5.0),
//             border: Border.all(
//               color: Colors.grey,
//             ),
//           ),
//           padding: const EdgeInsets.all(10.0),
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     _locale.customerCategory,
//                     style: utils.twelve400TextStyle(Colors.black),
//                   ),
//                   valueMultipleCustomerCategory == false
//                       ? Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Text(
//                               _locale.from,
//                               style: utils.twelve400TextStyle(Colors.black),
//                             ),
//                             const SizedBox(
//                               width: 10,
//                             ),
//                             CustomSearchDropDown(
//                               width: MediaQuery.of(context).size.width * 0.2,
//                               // items: customerCategoryList,
//                               hint: selectedFromCustomerCategory.isNotEmpty
//                                   ? selectedFromCustomerCategory
//                                   : _locale.select,
//                               value: selectedFromCustomerCategory.isNotEmpty
//                                   ? selectedFromCustomerCategory
//                                   : null,
//                               onChanged: (value) {
//                                 setState(() {
//                                   selectedFromCustomerCategory =
//                                       value.toString();
//                                   selectedFromCustomerCategoryCode =
//                                       value.codeToString();
//                                   getCustomerCategoryList();
//                                 });
//                               },
//                               onSearch: (text) {
//                                 DropDownSearchCriteria dropDownSearchCriteria =
//                                     getSearchCriteria(text);
//                                 return salesReportController
//                                     .getSalesCustomersCategMethod(
//                                         dropDownSearchCriteria.toJson());
//                               },
//                             ),
//                           ],
//                         )
//                       : Row(
//                           children: [
//                             Checkbox(
//                                 value: valueSelectAllCustomerCategory,
//                                 onChanged: (val) {
//                                   valueSelectAllCustomerCategory = val!;
//                                   readProvider.setCheckAllCustomerCategory(
//                                       valueSelectAllCustomerCategory);
//                                   // if (val) {
//                                   //   readProvider.setCodesCustomerCategory(
//                                   //       customerCategoryStringList);
//                                   // } else {
//                                   readProvider.setCodesCustomerCategory([]);
//                                   //   }
//                                   setState(() {});
//                                 }),
//                             SizedBox(
//                               width: MediaQuery.of(context).size.width * 0.185,
//                               height:
//                                   MediaQuery.of(context).size.height * 0.052,
//                               child: Padding(
//                                 padding: EdgeInsets.only(
//                                     top: MediaQuery.of(context).size.height *
//                                         0.018),
//                                 child: SelectableText(
//                                   maxLines: 1,
//                                   _locale.selectAll,
//                                   style: utils.twelve400TextStyle(Colors.black),
//                                 ),
//                               ),
//                             )
//                           ],
//                         ),
//                 ],
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       Checkbox(
//                           value: valueMultipleCustomerCategory,
//                           onChanged: (val) {
//                             valueMultipleCustomerCategory = val!;
//                             readProvider.setCheckMultipleCustomerCategory(
//                                 valueMultipleCustomerCategory);

//                             readProvider.setCodesCustomerCategory([]);
//                             readProvider.setCustCateg([]);
//                             readProvider.setFromCustCateg("");
//                             readProvider.setToCustCateg("");
//                             selectedFromCustomerCategory = "";
//                             selectedToCustomerCategory = "";
//                             setState(() {});
//                           }),
//                       Text(
//                         _locale.multiple,
//                         style: utils.twelve400TextStyle(Colors.black),
//                       ),
//                     ],
//                   ),
//                   valueMultipleCustomerCategory == false
//                       ? Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Text(
//                               _locale.to,
//                               style: utils.twelve400TextStyle(Colors.black),
//                             ),
//                             const SizedBox(
//                               width: 5,
//                             ),
//                             CustomSearchDropDown(
//                               width: MediaQuery.of(context).size.width * 0.2,
//                               // items: customerCategoryList,
//                               hint: selectedToCustomerCategory.isNotEmpty
//                                   ? selectedToCustomerCategory
//                                   : _locale.select,
//                               value: selectedToCustomerCategory.isNotEmpty
//                                   ? selectedToCustomerCategory
//                                   : null,
//                               onChanged: (value) {
//                                 setState(() {
//                                   selectedToCustomerCategory = value.toString();
//                                   selectedToCustomerCategoryCode =
//                                       value.codeToString();
//                                   getCustomerCategoryList();
//                                 });
//                               },
//                               onSearch: (text) {
//                                 DropDownSearchCriteria dropDownSearchCriteria =
//                                     getSearchCriteria(text);
//                                 return salesReportController
//                                     .getSalesCustomersCategMethod(
//                                         dropDownSearchCriteria.toJson());
//                               },
//                             ),
//                           ],
//                         )
//                       : SimpleDropdownSearch(
//                           // list: customerCategoryList,
//                           enabled: !valueSelectAllCustomerCategory,
//                           hintString: readProvider.getCustCateg == null
//                               ? []
//                               : readProvider.getCustCateg!,
//                           onChanged: (val) {
//                             setState(() {
//                               readProvider
//                                   .setCodesCustomerCategory(getCodesList(val));
//                               readProvider.setCustCateg(getStringList(val));
//                             });
//                           },
//                           onSearch: (text) {
//                             DropDownSearchCriteria dropDownSearchCriteria =
//                                 getSearchCriteria(text);
//                             return salesReportController
//                                 .getSalesCustomersCategMethod(
//                                     dropDownSearchCriteria.toJson());
//                           },
//                         ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(
//           height: 5,
//         ),
//         Container(
//           width: MediaQuery.of(context).size.width < 800
//               ? MediaQuery.of(context).size.width * 0.9
//               : MediaQuery.of(context).size.width * 0.8 / 2.1,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(5.0),
//             border: Border.all(
//               color: Colors.grey,
//             ),
//           ),
//           padding: const EdgeInsets.all(10.0),
//           child: Row(
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     _locale.campaignNo,
//                     style: utils.twelve400TextStyle(Colors.black),
//                   ),
//                   const SizedBox(
//                     height: 5,
//                   ),
//                   Container(
//                     height: 30,
//                     width: MediaQuery.of(context).size.width * 0.15,
//                     decoration: BoxDecoration(
//                       color: Colors.grey[200],
//                       borderRadius: BorderRadius.circular(5.0),
//                     ),
//                     padding:
//                         const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
//                     child: TextFieldCustom(
//                       controller: campaignNoController,
//                       onChanged: (text) {
//                         readProvider.setCampaignNo(campaignNoController.text);
//                       },
//                       decoration: const InputDecoration(
//                         border: InputBorder.none,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(
//                 width: 20,
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     _locale.modelNo,
//                     style: utils.twelve400TextStyle(Colors.black),
//                   ),
//                   const SizedBox(
//                     height: 5,
//                   ),
//                   GestureDetector(
//                     child: Container(
//                       height: 30,
//                       width: MediaQuery.of(context).size.width * 0.15,
//                       decoration: BoxDecoration(
//                         color: Colors.grey[200],
//                         borderRadius: BorderRadius.circular(5.0),
//                       ),
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 4, horizontal: 10),
//                       child: TextFieldCustom(
//                         controller: modelNoController,
//                         onChanged: (text) {
//                           print(modelNoController.text);

//                           readProvider.setModelNo(modelNoController.text);
//                           print("provider ${readProvider.getModelNo}");
//                         },
//                         decoration: const InputDecoration(
//                           border: InputBorder.none,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   DropDownSearchCriteria getSearchCriteria(String text) {
//     String todayDate = DatesController().formatDateReverse(
//         DatesController().formatDate(DatesController().todayDate()));
//     widget.fromDate.text = readProvider.getFromDate!.isNotEmpty
//         ? DatesController()
//             .formatDateReverse(readProvider.getFromDate.toString())
//         : todayDate;

//     widget.toDate.text = readProvider.getToDate!.isNotEmpty
//         ? DatesController().formatDateReverse(readProvider.getToDate.toString())
//         : todayDate;
//     DropDownSearchCriteria dropDownSearchCriteria = DropDownSearchCriteria(
//         fromDate: DatesController().formatDate(widget.fromDate.text),
//         toDate: DatesController().formatDate(widget.toDate.text),
//         nameCode: text);
//     return dropDownSearchCriteria;
//   }

//   void getBranchList() {
//     List<String> stringBranchList = [];

//     // for (int i = 0; i < branchesList.length; i++) {
//     //   if (branchesList[i].toString() == selectedFromBranches) {

//     //   }
//     //   if (branchesList[i].toString() == selectedToBranches) {
//     //   }
//     // }
//     if (selectedFromBranchesCode.isNotEmpty) {
//       stringBranchList.add(selectedFromBranchesCode);
//     }
//     if (selectedToBranchesCode.isNotEmpty) {
//       stringBranchList.add(selectedToBranchesCode);
//     }

//     readProvider.setFromBranch(selectedFromBranches);
//     readProvider.setToBranch(selectedToBranches);
//     readProvider.setCodesBranch(stringBranchList);
//   }

//   void getCategory2List() {
//     List<String> stringStkCategory2List = [];

//     // for (int i = 0; i < stkCategory2List.length; i++) {
//     //   if (stkCategory2List[i].toString() == selectedFromStkCategory2) {

//     //   }
//     //   if (stkCategory2List[i].toString() == selectedToStkCategory2) {
//     //   }
//     // }
//     if (selectedFromStkCategory2Code.isNotEmpty) {
//       stringStkCategory2List.add(selectedFromStkCategory2Code);
//     }
//     if (selectedToStkCategory2Code.isNotEmpty) {
//       stringStkCategory2List.add(selectedToStkCategory2Code);
//     }
//     readProvider.setFromCateg2(selectedFromStkCategory2);
//     readProvider.setToCateg2(selectedToStkCategory2);
//     readProvider.setCodesStockCategory2(stringStkCategory2List);
//   }

//   void getSupplierList() {
//     List<String> stringSupplierList = [];
//     // for (int i = 0; i < suppliersList.length; i++) {
//     //   if (suppliersList[i].toString() == selectedFromSupplier) {
//     //   }
//     //   if (suppliersList[i].toString() == selectedToSupplier) {
//     //   }
//     // }
//     if (selectedFromSupplierCode.isNotEmpty) {
//       stringSupplierList.add(selectedFromSupplierCode);
//     }
//     if (selectedToSupplierCode.isNotEmpty) {
//       stringSupplierList.add(selectedToSupplierCode);
//     }
//     readProvider.setFromSupp(selectedFromSupplier);
//     readProvider.setToSupp(selectedToSupplier);
//     readProvider.setCodesSupplier(stringSupplierList);
//   }

//   void getCustomerCategoryList() {
//     List<String> stringCustomerCategoryList = [];

//     // for (int i = 0; i < customerCategoryList.length; i++) {
//     //   if (customerCategoryList[i].toString() == selectedFromCustomerCategory) {
//     //   }
//     //   if (customerCategoryList[i].toString() == selectedToCustomerCategory) {
//     //   }
//     // }
//     if (selectedFromCustomerCategoryCode.isNotEmpty) {
//       stringCustomerCategoryList.add(selectedFromCustomerCategoryCode);
//     }
//     if (selectedToCustomerCategoryCode.isNotEmpty) {
//       stringCustomerCategoryList.add(selectedToCustomerCategoryCode);
//     }
//     readProvider.setFromCustCateg(selectedFromCustomerCategory);
//     readProvider.setToCustCateg(selectedToCustomerCategory);
//     readProvider.setCodesCustomerCategory(stringCustomerCategoryList);
//   }

//   List<String> getCodesList(List<dynamic> val) {
//     List<String> codesString = [];
//     for (int i = 0; i < val.length; i++) {
//       String newString = (val[i].toString().trim()).replaceAll(" ", "");
//       codesString.add(newString.substring(0, newString.indexOf("-")));
//     }
//     return codesString;
//   }

//   List<String> getStringList(List<dynamic> val) {
//     List<String> codesString = [];
//     for (int i = 0; i < val.length; i++) {
//       String newString = (val[i].toString().trim()).replaceAll(" ", "");
//       print(newString);
//       codesString.add(newString);
//     }
//     return codesString;
//   }
// }
