  // Container(
  //         width: isMobile ? width * 0.9 : width * 0.65 / 2,
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(5.0),
  //           border: Border.all(
  //             color: Colors.grey,
  //           ),
  //         ),
  //         padding: const EdgeInsets.all(10.0),
  //         child: Column(
  //           children: [
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     Text(
              //       _locale.stockCategoryLevel("1"),
              //       style: fourteen500TextStyle(Colors.black),
              //     ),
              //   ],
              // ),
  //             valueMultipleStkCateg1 == false
  //                 ? Row(
  //                     mainAxisAlignment: MainAxisAlignment.end,
  //                     children: [
  //                       CustomDropDown(
  //                         hint: selectedFromStkCategory1.isNotEmpty
  //                             ? selectedFromStkCategory1
  //                             : _locale.select,
  //                         label: _locale.from,
  //                         width: isDesktop ? width * .17 : width * .4,
  //                         onSearch: (text) {
  //                           DropDownSearchCriteria dropDownSearchCriteria =
  //                               getSearchCriteria(text);

  //                           return salesReportController
  //                               .getSalesStkCountCateg1Method(
  //                                   dropDownSearchCriteria.toJson());
  //                         },
  //                         onChanged: (value) {
  //                           setState(() {
  //                             selectedFromStkCategory1 = value.toString();
  //                             selectedFromStkCategory1Code =
  //                                 value.codeToString();
  //                             getCategory1List();
  //                           });
  //                         },
  //                         initialValue: selectedFromStkCategory1.isNotEmpty
  //                             ? selectedFromStkCategory1
  //                             : null,
  //                       )
  //                     ],
  //                   )
  //                 : Padding(
  //                     padding: const EdgeInsets.symmetric(horizontal: 180),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.end,
  //                       children: [
  //                         Checkbox(
  //                             value: valueSelectAllStkCateg1,
  //                             onChanged: (val) {
  //                               valueSelectAllStkCateg1 = val!;
  //                               readProvider.setCheckAllStockCategory1(
  //                                   valueSelectAllStkCateg1);

  //                               readProvider.setCodesStockCategory1([]);

  //                               setState(() {});
  //                             }),
  //                         SelectableText(
  //                           maxLines: 1,
  //                           _locale.selectAll,
  //                           style: twelve400TextStyle(Colors.black),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //             SizedBox(
  //               height: height * .005,
  //             ),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Column(
  //                   children: [
  //                     SizedBox(
  //                       height: valueMultipleStkCateg1 == false
  //                           ? height * .07
  //                           : height * .02,
  //                     ),
  //                     Row(
  //                       // crossAxisAlignment: CrossAxisAlignment.end,
  //                       children: [
  //                         Checkbox(
  //                             value: valueMultipleStkCateg1,
  //                             onChanged: (val) {
  //                               valueMultipleStkCateg1 = val!;
  //                               readProvider.setCheckMultipleStockCategory1(
  //                                   valueMultipleStkCateg1);

  //                               readProvider.setCodesStockCategory1([]);
  //                               readProvider.setStkCat1List([]);
  //                               readProvider.setFromCateg1("");
  //                               readProvider.setToCateg1("");
  //                               selectedFromStkCategory1 = "";
  //                               selectedToStkCategory1 = "";
  //                               setState(() {});
  //                             }),
  //                         SelectableText(
  //                           maxLines: 1,
  //                           _locale.multiple,
  //                           style: twelve400TextStyle(Colors.black),
  //                         ),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //                 Row(
  //                   children: [
  //                     valueMultipleStkCateg1 == false
  //                         ? CustomDropDown(
  //                             hint: selectedToStkCategory1.isNotEmpty
  //                                 ? selectedToStkCategory1
  //                                 : _locale.select,
  //                             label: _locale.to,
  //                             initialValue: selectedToStkCategory1.isNotEmpty
  //                                 ? selectedToStkCategory1
  //                                 : null,
  //                             onChanged: (value) {
  //                               setState(() {
  //                                 selectedToStkCategory1 = value.toString();
  //                                 selectedToStkCategory1Code =
  //                                     value.codeToString();
  //                                 getCategory1List();
  //                               });
  //                             },
  //                             width: isDesktop ? width * .17 : width * .4,
  //                             onSearch: (text) {
  //                               DropDownSearchCriteria dropDownSearchCriteria =
  //                                   getSearchCriteria(text);

  //                               return salesReportController
  //                                   .getSalesStkCountCateg1Method(
  //                                       dropDownSearchCriteria.toJson());
  //                             },
  //                           )
  //                         : SimpleDropdownSearch(
  //                             // list: stkCategory1List,
  //                             enabled: !valueSelectAllStkCateg1,
  //                             hintString: readProvider.getStkCat1List!,

  //                             onChanged: (val) {
  //                               setState(() {
  //                                 readProvider.setCodesStockCategory1(
  //                                     getCodesList(val));
  //                                 readProvider
  //                                     .setStkCat1List(getStringList(val));
  //                               });
  //                             },

  //                             onSearch: (text) {
  //                               DropDownSearchCriteria dropDownSearchCriteria =
  //                                   getSearchCriteria(text);

  //                               return salesReportController
  //                                   .getSalesStkCountCateg1Method(
  //                                       dropDownSearchCriteria.toJson());
  //                             },
  //                           ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),