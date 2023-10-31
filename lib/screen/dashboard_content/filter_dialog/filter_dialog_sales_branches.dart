import 'package:bi_replicate/provider/dates_provider.dart';
import 'package:bi_replicate/widget/drop_down/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../components/custom_date.dart';
import '../../../controller/error_controller.dart';
import '../../../utils/constants/app_utils.dart';
import '../../../utils/constants/responsive.dart';
import '../../../utils/func/dates_controller.dart';
import '../../../widget/custom_date_picker.dart';

class FilterDialogSalesByBranches extends StatefulWidget {
  final Function(
    String selectedPeriod,
    String fromDate,
    String toDate,
  ) onFilter;

  FilterDialogSalesByBranches({
    required this.onFilter,
  });

  @override
  _FilterDialogSalesByBranchesState createState() =>
      _FilterDialogSalesByBranchesState();
}

class _FilterDialogSalesByBranchesState
    extends State<FilterDialogSalesByBranches> {
  late AppLocalizations _locale;
  bool isDesktop = false;
  final TextEditingController _fromDateController =
      TextEditingController(text: "29-10-2021");
  final TextEditingController _toDateController = TextEditingController();
  double width = 0;
  double height = 0;
  String todayDate = "";
  List<String> periods = [];
  var selectedPeriod = "";
  List<String> status = [];

  var selectedStatus = "";

  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context);

    status = [
      _locale.all,
      _locale.posted,
      _locale.draft,
      _locale.canceled,
    ];
    periods = [
      _locale.daily,
      _locale.weekly,
      _locale.monthly,
      _locale.yearly,
    ];

    selectedPeriod = periods[0];
    selectedStatus = status[0];
    print("todayDate: $todayDate");
    super.didChangeDependencies();
  }

  @override
  void initState() {
    todayDate = DatesController().formatDateReverse(
        DatesController().formatDate(DatesController().todayDate()));
    _fromDateController.text = todayDate;
    _toDateController.text = todayDate;
    print("fromDate: ${_fromDateController.text}");
    print("periodd :${selectedPeriod}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    isDesktop = Responsive.isDesktop(context);
    return AlertDialog(
      title: SelectableText(_locale.filter),
      content: SizedBox(
        width: isDesktop ? width * 0.5 : width * 0.7,
        height: isDesktop ? height * 0.35 : height * 0.6,
        child: Column(
          children: [
            isDesktop
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomDropDown(
                        items: periods,
                        label: _locale.period,
                        initialValue: selectedPeriod,
                        onChanged: (value) {
                          setState(() {
                            checkPeriods(value);
                            selectedPeriod = value!;
                          });
                        },
                      ),
                      // CustomDropDown(
                      //   items: status,
                      //   label: _locale.status,
                      //   initialValue: selectedStatus,
                      //   onChanged: (value) {
                      //     setState(() {
                      //       selectedStatus = value!;
                      //     });
                      //   },
                      // ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomDropDown(
                        items: periods,
                        label: _locale.period,
                        initialValue: selectedPeriod,
                        width: width,
                        onChanged: (value) {
                          setState(() {
                            checkPeriods(value);
                            selectedPeriod = value!;
                          });
                        },
                      ),
                      // CustomDropDown(
                      //   items: status,
                      //   label: _locale.status,
                      //   initialValue: selectedStatus,
                      //   width: width,
                      //   onChanged: (value) {
                      //     setState(() {
                      //       selectedStatus = value!;
                      //     });
                      //   },
                      // ),
                    ],
                  ),
            isDesktop
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        // height: height * 0.1,
                        width: isDesktop ? width * 0.135 : width * 0.9,
                        child: CustomDate(
                          dateController: _fromDateController,
                          label: _locale.fromDate,
                          minYear: 2000,
                          onValue: (isValid, value) {
                            if (isValid) {
                              setState(() {
                                _fromDateController.text = value;
                                DateTime from =
                                    DateTime.parse(_fromDateController.text);
                                DateTime to =
                                    DateTime.parse(_toDateController.text);

                                if (from.isAfter(to)) {
                                  ErrorController.openErrorDialog(
                                      1, _locale.startDateAfterEndDate);
                                }
                              });
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        width: width * 0.01,
                      ),
                      // CustomDatePicker(
                      //   label: _locale.fromDate,
                      //   date: DateTime.parse(_toDateController.text),
                      //   controller: _fromDateController,
                      //   onSelected: (value) {
                      //     setState(() {
                      //       _fromDateController.text = value;
                      //     });
                      //   },
                      // ),
                      SizedBox(
                        // height: height * 0.1,
                        width: isDesktop ? width * 0.135 : width * 0.9,
                        child: CustomDate(
                          dateController: _toDateController,
                          label: _locale.toDate,
                          minYear: 2000,
                          onValue: (isValid, value) {
                            if (isValid) {
                              setState(() {
                                _toDateController.text = value;
                                DateTime from =
                                    DateTime.parse(_fromDateController.text);
                                DateTime to =
                                    DateTime.parse(_toDateController.text);

                                if (from.isAfter(to)) {
                                  ErrorController.openErrorDialog(
                                      1, _locale.startDateAfterEndDate);
                                }
                              });
                            }
                          },
                        ),
                      ),
                      // CustomDatePicker(
                      //   label: _locale.toDate,
                      //   controller: _toDateController,
                      //   date: DateTime.parse(_fromDateController.text),
                      //   onSelected: (value) {
                      //     setState(() {
                      //       _toDateController.text = value;
                      //     });
                      //   },
                      // ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: height * 0.12,
                        width: isDesktop ? width * 0.135 : width * 0.9,
                        child: CustomDate(
                          dateController: _fromDateController,
                          label: _locale.fromDate,
                          minYear: 2000,
                          onValue: (isValid, value) {
                            if (isValid) {
                              setState(() {
                                _fromDateController.text = value;
                                DateTime from =
                                    DateTime.parse(_fromDateController.text);
                                DateTime to =
                                    DateTime.parse(_toDateController.text);

                                if (from.isAfter(to)) {
                                  ErrorController.openErrorDialog(
                                      1, _locale.startDateAfterEndDate);
                                }
                              });
                            }
                          },
                        ),
                      ),
                      // CustomDatePicker(
                      //   label: _locale.fromDate,
                      //   date: DateTime.parse(_toDateController.text),
                      //   controller: _fromDateController,
                      //   onSelected: (value) {
                      //     setState(() {
                      //       _fromDateController.text = value;
                      //     });
                      //   },
                      // ),
                      SizedBox(
                        height: height * 0.12,
                        width: isDesktop ? width * 0.135 : width * 0.9,
                        child: CustomDate(
                          dateController: _toDateController,
                          label: _locale.toDate,
                          minYear: 2000,
                          onValue: (isValid, value) {
                            if (isValid) {
                              setState(() {
                                _toDateController.text = value;
                                DateTime from =
                                    DateTime.parse(_fromDateController.text);
                                DateTime to =
                                    DateTime.parse(_toDateController.text);

                                if (from.isAfter(to)) {
                                  ErrorController.openErrorDialog(
                                      1, _locale.startDateAfterEndDate);
                                }
                              });
                            }
                          },
                        ),
                      ),
                      // CustomDatePicker(
                      //   label: _locale.toDate,
                      //   controller: _toDateController,
                      //   date: DateTime.parse(_fromDateController.text),
                      //   onSelected: (value) {
                      //     setState(() {
                      //       _toDateController.text = value;
                      //     });
                      //   },
                      // ),
                    ],
                  ),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Components().blueButton(
              height: width > 800 ? height * .05 : height * .06,
              fontSize: width > 800 ? height * .016 : height * .011,
              width: isDesktop ? width * 0.09 : width * 0.25,
              onPressed: () {
                DateTime from = DateTime.parse(_fromDateController.text);
                DateTime to = DateTime.parse(_toDateController.text);

                if (from.isAfter(to)) {
                  ErrorController.openErrorDialog(
                      1, _locale.startDateAfterEndDate);
                } else {
                  widget.onFilter(
                    selectedPeriod,
                    DatesController().formatDate(_fromDateController.text),
                    DatesController().formatDate(_toDateController.text),
                  );
                  print(
                      "_fromDateController.text :${_fromDateController.text}");
                  print("periodd :${selectedPeriod}");
                  context.read<DatesProvider>().setDatesController(
                      _fromDateController, _toDateController);
                  Navigator.of(context).pop();
                }
              },
              text: _locale.filter,
              borderRadius: 0.3,
              textColor: Colors.white,
            ),
          ],
        ),
      ],
    );
  }

  void checkPeriods(value) {
    if (value == periods[0]) {
      _fromDateController.text = DatesController().todayDate().toString();
      _toDateController.text = DatesController().todayDate().toString();
    }
    if (value == periods[1]) {
      _fromDateController.text = DatesController().currentWeek().toString();
      _toDateController.text = DatesController().todayDate().toString();
    }
    if (value == periods[2]) {
      _fromDateController.text = DatesController().currentMonth().toString();
      _toDateController.text = DatesController().todayDate().toString();
    }
    if (value == periods[3]) {
      _fromDateController.text = DatesController().currentYear().toString();
      _toDateController.text = DatesController().todayDate().toString();
    }
  }
}
