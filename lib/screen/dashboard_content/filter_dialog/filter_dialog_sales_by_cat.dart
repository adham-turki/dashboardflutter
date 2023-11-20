import 'package:bi_replicate/provider/dates_provider.dart';
import 'package:bi_replicate/widget/drop_down/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../components/custom_date.dart';
import '../../../controller/error_controller.dart';
import '../../../controller/sales_adminstration/branch_controller.dart';
import '../../../utils/constants/app_utils.dart';
import '../../../utils/constants/maps.dart';
import '../../../utils/constants/responsive.dart';
import '../../../utils/func/dates_controller.dart';

class FilterDialogSalesByCategory extends StatefulWidget {
  final Function(
      String selectedPeriod,
      String fromDate,
      String toDate,
      String selectedCategoriesF,
      String selectedBranchCodeF,
      String chart) onFilter;

  FilterDialogSalesByCategory({
    required this.onFilter,
  });

  @override
  _FilterDialogSalesByCategoryState createState() =>
      _FilterDialogSalesByCategoryState();
}

class _FilterDialogSalesByCategoryState
    extends State<FilterDialogSalesByCategory> {
  late AppLocalizations _locale;
  bool isDesktop = false;
  final TextEditingController _fromDateController =
      TextEditingController(text: "29-10-2021");
  final TextEditingController _toDateController = TextEditingController();
  double width = 0;
  double height = 0;
  String todayDate = "";
  String currentMonth = "";
  List<String> periods = [];
  var selectedPeriod = "";
  List<String> categories = [];
  List<String> charts = [];
  var selectedChart = "";

  var selectedCategories = "";
  var selectedBranchCode = "";
  List<String> branches = [];
  var selectedBranch = "";
  BranchController branchController = BranchController();

  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context);

    periods = [
      _locale.daily,
      _locale.weekly,
      _locale.monthly,
      _locale.yearly,
    ];
    categories = [
      _locale.brands,
      _locale.categories("1"),
      _locale.categories("2"),
      _locale.classifications
    ];
    charts = [_locale.lineChart, _locale.pieChart, _locale.barChart];
    selectedChart = charts[2];

    selectedCategories = categories[1];
    branches = [_locale.all];
    selectedBranch = branches[0];
    selectedPeriod = periods[0];
    super.didChangeDependencies();
  }

  @override
  void initState() {
    todayDate = DatesController().formatDateReverse(
        DatesController().formatDate(DatesController().todayDate()));
    currentMonth = DatesController().formatDateReverse(
        DatesController().formatDate(DatesController().twoYearsAgo()));

    _fromDateController.text = currentMonth;
    _toDateController.text = todayDate;

    getBranch(isStart: true);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    isDesktop = Responsive.isDesktop(context);
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      // title: SelectableText(_locale.filter),
      content: SizedBox(
        width: isDesktop ? width * 0.55 : width * 0.7,
        height: isDesktop ? height * 0.37 : null,
        child: SingleChildScrollView(
          child: Column(
            children: [
              isDesktop
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        CustomDropDown(
                          items: categories,
                          label: _locale.byCategory,
                          initialValue: selectedCategories,
                          onChanged: (value) {
                            setState(() {
                              selectedCategories = value!;
                            });
                          },
                        ),
                        CustomDropDown(
                          items: charts,
                          hint: "",
                          label: _locale.chartType,
                          initialValue: selectedChart,
                          onChanged: (value) {
                            setState(() {
                              selectedChart = value!;
                            });
                          },
                        ),
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
                        CustomDropDown(
                          items: categories,
                          width: width,
                          label: _locale.byCategory,
                          initialValue: selectedCategories,
                          onChanged: (value) {
                            setState(() {
                              selectedCategories = value!;
                            });
                          },
                        ),
                      ],
                    ),
              isDesktop
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomDate(
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
                        // SizedBox(
                        //   width: width * 0.01,
                        // ),
                        CustomDate(
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
                        CustomDropDown(
                          items: branches,
                          label: _locale.branch,
                          initialValue: selectedBranch,
                          onChanged: (value) {
                            setState(() {
                              selectedBranch = value.toString();
                              selectedBranchCode =
                                  branchesMap[value.toString()]!;
                            });
                          },
                        ),
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
                        CustomDropDown(
                          items: charts,
                          hint: "",
                          width: width,
                          label: _locale.chartType,
                          initialValue: selectedChart,
                          onChanged: (value) {
                            setState(() {
                              selectedChart = value!;
                            });
                          },
                        ),
                        CustomDropDown(
                          width: width,
                          items: branches,
                          label: _locale.branch,
                          initialValue: selectedBranch,
                          onChanged: (value) {
                            setState(() {
                              selectedBranch = value.toString();
                              selectedBranchCode =
                                  branchesMap[value.toString()]!;
                            });
                          },
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Components().blueButton(
              height: width > 800 ? height * .054 : height * .06,
              fontSize: width > 800 ? height * .0158 : height * .015,
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
                      selectedCategories,
                      selectedBranchCode,
                      selectedChart);

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

  void getBranch({bool? isStart}) async {
    branchController.getBranch(isStart: isStart).then((value) {
      value.forEach((k, v) {
        if (mounted) {
          setState(() {
            branches.add(k);
          });
        }
      });
      setBranchesMap(_locale, value);
    });
  }
}
