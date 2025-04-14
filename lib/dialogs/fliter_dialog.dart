import 'package:bi_replicate/components/custom_date.dart';
import 'package:bi_replicate/constants/constants.dart';
import 'package:bi_replicate/model/cashier_model.dart';
import 'package:bi_replicate/model/trans_type_constants.dart';
import 'package:bi_replicate/utils/constants/responsive.dart';
import 'package:bi_replicate/utils/func/dates_controller.dart';
import 'package:bi_replicate/widget/custom_drop_down_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/sales/branch_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../model/sales/search_crit.dart';

class FilterDialog extends StatefulWidget {
  final SearchCriteria filter;
  final List<BranchModel> branches;
  final List<CashierModel> cashiers;
  final String hint;

  FilterDialog(
      {required this.filter,
      required this.branches,
      required this.cashiers,
      required this.hint});

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  String _selectedBranch = "";
  String _selectedBranchName = "";
  String _selectedShiftStatus = "";
  String selectedChartType = "";
  String _selectedCashier = "";
  String _selectedCashierCode = "";
  int _selectedTransactionType = -1;
  String _selectedTransactionDesc = "";
  TextEditingController _fromDateController = TextEditingController();
  TextEditingController _toDateController = TextEditingController();
  double screenWidth = 0.0;
  double screenHeight = 0.0;
  List<TransTypeConstants> transTypeList = [];
  late AppLocalizations _locale;
  List<String> charts = [];
  @override
  void didChangeDependencies() {
    _fromDateController =
        TextEditingController(text: formatDateString(widget.filter.fromDate));
    _toDateController =
        TextEditingController(text: formatDateString(widget.filter.toDate));
    print("widget.branches: ${widget.branches.length}");
    _locale = AppLocalizations.of(context)!;
    charts = [
      if (widget.hint != _locale.salesByPaymentTypes) _locale.lineChart,
      _locale.barChart,
      if (widget.hint == _locale.salesByPaymentTypes) _locale.pieChart,
    ];

    transTypeList = [];
    transTypeList = constTransTypeList;
    if (transTypeList.isNotEmpty) {
      if (transTypeList[0].description != _locale.all) {
        transTypeList.insert(
            0, TransTypeConstants(description: _locale.all, id: -1));
      }
    }

    widget.cashiers.insert(
        0,
        CashierModel(
          txtCode: "all",
          txtNamee: _locale.all,
        ));
    widget.branches.insert(
        0,
        BranchModel(
            txtCode: "all",
            txtNamee: _locale.all,
            txtCostcentercode: "",
            txtPrefix: "",
            txtWarehouse: "",
            txtJcode: ""));
    _selectedBranch = widget.filter.branch;
    _selectedShiftStatus = widget.filter.shiftStatus == "0"
        ? _locale.opened
        : widget.filter.shiftStatus == "1"
            ? _locale.closed
            : _locale.all;

    _selectedTransactionDesc = widget.filter.transType == "all"
        ? _locale.all
        : getDescriptionById(int.parse(widget.filter.transType));
    _selectedTransactionType = widget.filter.transType == "all"
        ? -1
        : int.parse(widget.filter.transType);
    _selectedCashier =
        widget.filter.cashier == "all" ? _locale.all : widget.filter.cashier;
    selectedChartType = widget.filter.chartType ?? charts[0];
    if (widget.branches.isNotEmpty) {
      for (var i = 0; i < widget.branches.length; i++) {
        if (widget.branches[i].txtCode == _selectedBranch) {
          _selectedBranchName = widget.branches[i].txtNamee;
        }
      }
      print("formatDateString: ${formatDateString(widget.filter.fromDate)}");
      print("formatDateString:1 ${formatDateString(widget.filter.toDate)}");

      super.didChangeDependencies();
    }
  }

  String formatDateString(String dateString) {
    try {
      // Adjust the input format if needed (e.g., 'dd/MM/yyyy', 'MM-dd-yyyy')
      DateTime dateTime = DateFormat('dd/MM/yyyy').parse(dateString);

      // Convert to 'yyyy-MM-dd'
      return DateFormat('yyyy-MM-dd').format(dateTime);
    } catch (e) {
      return 'Invalid date'; // Handle incorrect formats gracefully
    }
  }

  formatDateStringToForwardSlash(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  @override
  void initState() {
    super.initState();
  }

  String getDescriptionById(int id) {
    final item = constTransTypeList.firstWhere(
      (element) => element.id == id,
    );
    return item.description;
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return AlertDialog(
      title: Center(
        child: Text(
          _locale.salesReportsSearch,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      content: Responsive.isDesktop(context)
          ? desktopView(context)
          : mobileView(context),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                SearchCriteria updatedFilter = SearchCriteria(
                    branch: _selectedBranch,
                    shiftStatus: _selectedShiftStatus == _locale.opened
                        ? "0"
                        : _selectedShiftStatus == _locale.closed
                            ? "1"
                            : "all",
                    transType: _selectedTransactionType == -1
                        ? "all"
                        : "$_selectedTransactionType",
                    cashier: _selectedCashierCode == ""
                        ? "all"
                        : _selectedCashierCode == _locale.all
                            ? "all"
                            : _selectedCashierCode,
                    fromDate: formatDateStringToForwardSlash(
                        _fromDateController.text),
                    toDate:
                        formatDateStringToForwardSlash(_toDateController.text),
                    chartType: selectedChartType);
                print("selectedChartType: ${selectedChartType}");
                Navigator.of(context).pop(updatedFilter);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.grey[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                _locale.ok,
                style: TextStyle(fontSize: screenHeight * 0.02),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // Close the dialog without saving
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.grey[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                _locale.cancel,
                style: TextStyle(fontSize: screenHeight * 0.02),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget mobileView(BuildContext context) {
    return Container(
      color: Colors.white,
      // width: MediaQuery.of(context).size.width * 0.3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: screenWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: Responsive.isDesktop(context)
                            ? screenWidth * 0.16
                            : screenWidth * 0.66,
                        height: screenHeight * 0.1,
                        child: _buildDateField(
                            label: _locale.fromDate,
                            controller: _fromDateController,
                            dateControllerToCompareWith: _toDateController),
                      ),
                      SizedBox(
                        width: Responsive.isDesktop(context)
                            ? screenWidth * 0.16
                            : screenWidth * 0.66,
                        height: screenHeight * 0.15,
                        child: _buildDateField(
                            label: _locale.toDate,
                            controller: _toDateController,
                            dateControllerToCompareWith: _fromDateController),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  // height: screenHeight * 0.22,
                  child: Column(
                    mainAxisAlignment: (widget.hint != _locale.salesByHours &&
                            widget.hint != _locale.salesCostBasedStockCat &&
                            widget.hint != _locale.diffClosedCashByShifts &&
                            widget.hint != _locale.diffCashByShifts &&
                            widget.hint != _locale.salesCostBasedBranch)
                        ? MainAxisAlignment.spaceAround
                        : MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: Responsive.isDesktop(context)
                            ? screenWidth * 0.16
                            : screenWidth * 0.66,
                        height: screenHeight * 0.1,
                        child: CustomDropDownSearch(
                          isMandatory: true,
                          bordeText: _locale.selectBranch,
                          onChanged: (value) {
                            setState(() {
                              _selectedBranch = value.txtCode ?? "";
                              _selectedBranchName = value.txtNamee ?? "";
                            });
                            print("_selectedBranch: $_selectedBranch");
                            print("_selectedBranchName: $_selectedBranchName");
                          },
                          items: widget.branches,
                          initialValue: _selectedBranchName == ""
                              ? "Select Branch"
                              : _selectedBranchName,
                        ),
                      ),
                      (widget.hint != _locale.salesByHours &&
                              widget.hint != _locale.salesCostBasedStockCat &&
                              widget.hint != _locale.diffClosedCashByShifts &&
                              widget.hint != _locale.diffCashByShifts &&
                              widget.hint != _locale.salesCostBasedBranch)
                          ? SizedBox(
                              width: Responsive.isDesktop(context)
                                  ? screenWidth * 0.16
                                  : screenWidth * 0.66,
                              height: screenHeight * 0.1,
                              child: CustomDropDownSearch(
                                isMandatory: true,
                                bordeText: _locale.selectShiftType,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedShiftStatus = value;
                                  });
                                },
                                items: <String>[
                                  _locale.all,
                                  _locale.opened,
                                  _locale.closed
                                ],
                                initialValue: _selectedShiftStatus == ""
                                    ? "Select Shift"
                                    : _selectedShiftStatus,
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
                // if (Responsive.isDesktop(context))
                //   SizedBox(
                //     width: screenWidth * 0.01,
                //   ),
                if (Responsive.isDesktop(context))
                  SizedBox(
                    // height: screenHeight * 0.22,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: (widget.hint == _locale.cashierLogs)
                          ? MainAxisAlignment.spaceAround
                          : MainAxisAlignment.center,
                      children: [
                        (widget.hint == _locale.cashierLogs ||
                                widget.hint == _locale.diffClosedCashByShifts ||
                                widget.hint == _locale.diffCashByShifts)
                            ? SizedBox(
                                width: Responsive.isDesktop(context)
                                    ? screenWidth * 0.16
                                    : screenWidth * 0.66,
                                height: screenHeight * 0.1,
                                child: CustomDropDownSearch(
                                  isMandatory: true,
                                  bordeText: _locale.selectCashier,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedCashier = value.txtNamee ?? "";
                                      _selectedCashierCode =
                                          value.txtCode ?? "";
                                    });
                                  },
                                  items: widget.cashiers,
                                  initialValue: _selectedCashier == ""
                                      ? "Select Cashier"
                                      : _selectedCashier,
                                ),
                              )
                            : const SizedBox.shrink(),
                        (widget.hint == _locale.cashierLogs)
                            ? SizedBox(
                                width: Responsive.isDesktop(context)
                                    ? screenWidth * 0.16
                                    : screenWidth * 0.66,
                                height: screenHeight * 0.1,
                                child: CustomDropDownSearch(
                                  isMandatory: true,
                                  bordeText: _locale.selectTransType,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedTransactionType = value.id;
                                      _selectedTransactionDesc =
                                          value.description;
                                    });
                                    print(
                                        "_selectedTransactionType: $_selectedTransactionType");
                                    print(
                                        "_selectedTransactionDesc: $_selectedTransactionDesc");
                                  },
                                  items: transTypeList,
                                  initialValue: _selectedTransactionDesc == ""
                                      ? "Select Transaction Type"
                                      : _selectedTransactionDesc,
                                ),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),
              ],
            ),
            // if (!Responsive.isDesktop(context))
            //   SizedBox(
            //     width: screenWidth * 0.01,
            //   ),
            if (!Responsive.isDesktop(context))
              if (widget.hint == _locale.cashierLogs)
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: Responsive.isDesktop(context)
                          ? screenWidth * 0.16
                          : screenWidth * 0.66,
                      height: screenHeight * 0.1,
                      child: CustomDropDownSearch(
                        isMandatory: true,
                        bordeText: _locale.selectCashier,
                        onChanged: (value) {
                          setState(() {
                            _selectedCashier = value.txtNamee ?? "";
                            _selectedCashierCode = value.txtCode ?? "";
                          });
                        },
                        items: widget.cashiers,
                        initialValue: _selectedCashier == ""
                            ? "Select Cashier"
                            : _selectedCashier,
                      ),
                    ),
                    SizedBox(
                      width: Responsive.isDesktop(context)
                          ? screenWidth * 0.16
                          : screenWidth * 0.66,
                      height: screenHeight * 0.1,
                      child: CustomDropDownSearch(
                        isMandatory: true,
                        bordeText: _locale.selectTransType,
                        onChanged: (value) {
                          setState(() {
                            _selectedTransactionType = value.id;
                            _selectedTransactionDesc = value.description;
                          });
                          print(
                              "_selectedTransactionType: $_selectedTransactionType");
                          print(
                              "_selectedTransactionDesc: $_selectedTransactionDesc");
                        },
                        items: transTypeList,
                        initialValue: _selectedTransactionDesc == ""
                            ? "Select Transaction Type"
                            : _selectedTransactionDesc,
                      ),
                    ),
                  ],
                ),
            if (!Responsive.isDesktop(context))
              if (widget.hint == _locale.diffClosedCashByShifts ||
                  widget.hint == _locale.diffCashByShifts)
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: Responsive.isDesktop(context)
                          ? screenWidth * 0.16
                          : screenWidth * 0.66,
                      height: screenHeight * 0.1,
                      child: CustomDropDownSearch(
                        isMandatory: true,
                        bordeText: _locale.selectCashier,
                        onChanged: (value) {
                          setState(() {
                            _selectedCashier = value.txtNamee ?? "";
                            _selectedCashierCode = value.txtCode ?? "";
                          });
                        },
                        items: widget.cashiers,
                        initialValue: _selectedCashier == ""
                            ? "Select Cashier"
                            : _selectedCashier,
                      ),
                    ),
                  ],
                ),
            // _buildDropdown(
            //   label: 'Branch',
            //   value: _selectedBranch,
            //   items: widget.branches,
            //   onChanged: (dynamic newValue) {
            //     setState(() {
            //       _selectedBranch = newValue!.txtNamee;
            //     });
            //   },
            // ),

            // _buildDropdown(
            //   label: 'Shift Status',
            //   value: _selectedShiftStatus,
            //   items: <String>['all', 'open', 'closed'],
            //   onChanged: (dynamic? newValue) {
            //     setState(() {
            //       _selectedShiftStatus = newValue!;
            //     });
            //   },
            // ),
            if (widget.hint != _locale.salesCostBasedBranch &&
                widget.hint != _locale.salesCostBasedStockCat &&
                widget.hint != _locale.diffClosedCashByShifts &&
                widget.hint != _locale.diffCashByShifts)
              SizedBox(
                width: Responsive.isDesktop(context)
                    ? screenWidth * 0.16
                    : screenWidth * 0.66,
                height: screenHeight * 0.1,
                child: CustomDropDownSearch(
                  isMandatory: true,
                  bordeText: _locale.chartType,
                  onChanged: (value) {
                    setState(() {
                      selectedChartType = value;
                    });
                  },
                  items: charts,
                  initialValue:
                      _selectedBranchName == "" ? charts[0] : selectedChartType,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget desktopView(BuildContext context) {
    return Container(
      color: Colors.white,
      // width: MediaQuery.of(context).size.width * 0.3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: screenWidth * 0.35,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: Responsive.isDesktop(context)
                            ? screenWidth * 0.16
                            : screenWidth * 0.81,
                        height: screenHeight * 0.15,
                        child: _buildDateField(
                            label: _locale.fromDate,
                            controller: _fromDateController,
                            dateControllerToCompareWith: _toDateController),
                      ),
                      SizedBox(
                        width: Responsive.isDesktop(context)
                            ? screenWidth * 0.16
                            : screenWidth * 0.81,
                        height: screenHeight * 0.15,
                        child: _buildDateField(
                            label: _locale.toDate,
                            controller: _toDateController,
                            dateControllerToCompareWith: _fromDateController),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  // height: screenHeight * 0.22,
                  child: Row(
                    mainAxisAlignment: (widget.hint != _locale.salesByHours &&
                            widget.hint != _locale.salesCostBasedStockCat &&
                            widget.hint != _locale.diffClosedCashByShifts &&
                            widget.hint != _locale.diffCashByShifts &&
                            widget.hint != _locale.salesCostBasedBranch)
                        ? MainAxisAlignment.spaceAround
                        : MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: Responsive.isDesktop(context)
                            ? screenWidth * 0.16
                            : screenWidth * 0.6,
                        height: screenHeight * 0.1,
                        child: CustomDropDownSearch(
                          isMandatory: true,
                          bordeText: _locale.selectBranch,
                          onChanged: (value) {
                            setState(() {
                              _selectedBranch = value.txtCode ?? "";
                              _selectedBranchName = value.txtNamee ?? "";
                            });
                            print("_selectedBranch: $_selectedBranch");
                            print("_selectedBranchName: $_selectedBranchName");
                          },
                          items: widget.branches,
                          initialValue: _selectedBranchName == ""
                              ? "Select Branch"
                              : _selectedBranchName,
                        ),
                      ),
                      (widget.hint != _locale.salesByHours &&
                              widget.hint != _locale.salesCostBasedStockCat &&
                              widget.hint != _locale.diffClosedCashByShifts &&
                              widget.hint != _locale.diffCashByShifts &&
                              widget.hint != _locale.salesCostBasedBranch)
                          ? SizedBox(
                              width: Responsive.isDesktop(context)
                                  ? screenWidth * 0.16
                                  : screenWidth * 0.6,
                              height: screenHeight * 0.1,
                              child: CustomDropDownSearch(
                                isMandatory: true,
                                bordeText: _locale.selectShiftType,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedShiftStatus = value;
                                  });
                                },
                                items: <String>[
                                  _locale.all,
                                  _locale.opened,
                                  _locale.closed
                                ],
                                initialValue: _selectedShiftStatus == ""
                                    ? "Select Shift"
                                    : _selectedShiftStatus,
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
                // if (Responsive.isDesktop(context))
                //   SizedBox(
                //     width: screenWidth * 0.01,
                //   ),
                if (Responsive.isDesktop(context))
                  SizedBox(
                    // height: screenHeight * 0.22,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: (widget.hint == _locale.cashierLogs)
                          ? MainAxisAlignment.spaceAround
                          : MainAxisAlignment.center,
                      children: [
                        (widget.hint == _locale.cashierLogs ||
                                widget.hint == _locale.diffClosedCashByShifts ||
                                widget.hint == _locale.diffCashByShifts)
                            ? SizedBox(
                                width: Responsive.isDesktop(context)
                                    ? screenWidth * 0.16
                                    : screenWidth * 0.66,
                                height: screenHeight * 0.1,
                                child: CustomDropDownSearch(
                                  isMandatory: true,
                                  bordeText: _locale.selectCashier,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedCashier = value.txtNamee ?? "";
                                      _selectedCashierCode =
                                          value.txtCode ?? "";
                                    });
                                  },
                                  items: widget.cashiers,
                                  initialValue: _selectedCashier == ""
                                      ? "Select Cashier"
                                      : _selectedCashier,
                                ),
                              )
                            : const SizedBox.shrink(),
                        (widget.hint == _locale.cashierLogs)
                            ? SizedBox(
                                width: Responsive.isDesktop(context)
                                    ? screenWidth * 0.16
                                    : screenWidth * 0.66,
                                height: screenHeight * 0.1,
                                child: CustomDropDownSearch(
                                  isMandatory: true,
                                  bordeText: _locale.selectTransType,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedTransactionType = value.id;
                                      _selectedTransactionDesc =
                                          value.description;
                                    });
                                    print(
                                        "_selectedTransactionType: $_selectedTransactionType");
                                    print(
                                        "_selectedTransactionDesc: $_selectedTransactionDesc");
                                  },
                                  items: transTypeList,
                                  initialValue: _selectedTransactionDesc == ""
                                      ? "Select Transaction Type"
                                      : _selectedTransactionDesc,
                                ),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),
                if (widget.hint != _locale.salesCostBasedBranch &&
                    widget.hint != _locale.salesCostBasedStockCat &&
                    widget.hint != _locale.diffClosedCashByShifts &&
                    widget.hint != _locale.diffCashByShifts)
                  SizedBox(
                    width: Responsive.isDesktop(context)
                        ? screenWidth * 0.16
                        : screenWidth * 0.66,
                    height: screenHeight * 0.1,
                    child: CustomDropDownSearch(
                      isMandatory: true,
                      bordeText: _locale.chartType,
                      onChanged: (value) {
                        setState(() {
                          selectedChartType = value;
                        });
                      },
                      items: charts,
                      initialValue: _selectedBranchName == ""
                          ? charts[0]
                          : selectedChartType,
                    ),
                  ),
              ],
            ),
            // if (!Responsive.isDesktop(context))
            //   SizedBox(
            //     width: screenWidth * 0.01,
            //   ),
            if (!Responsive.isDesktop(context))
              if (widget.hint == _locale.cashierLogs)
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: Responsive.isDesktop(context)
                          ? screenWidth * 0.16
                          : screenWidth * 0.66,
                      height: screenHeight * 0.1,
                      child: CustomDropDownSearch(
                        isMandatory: true,
                        bordeText: _locale.selectCashier,
                        onChanged: (value) {
                          setState(() {
                            _selectedCashier = value.txtNamee ?? "";
                            _selectedCashierCode = value.txtCode ?? "";
                          });
                        },
                        items: widget.cashiers,
                        initialValue: _selectedCashier == ""
                            ? "Select Cashier"
                            : _selectedCashier,
                      ),
                    ),
                    SizedBox(
                      width: Responsive.isDesktop(context)
                          ? screenWidth * 0.16
                          : screenWidth * 0.66,
                      height: screenHeight * 0.1,
                      child: CustomDropDownSearch(
                        isMandatory: true,
                        bordeText: _locale.selectTransType,
                        onChanged: (value) {
                          setState(() {
                            _selectedTransactionType = value.id;
                            _selectedTransactionDesc = value.description;
                          });
                          print(
                              "_selectedTransactionType: $_selectedTransactionType");
                          print(
                              "_selectedTransactionDesc: $_selectedTransactionDesc");
                        },
                        items: transTypeList,
                        initialValue: _selectedTransactionDesc == ""
                            ? "Select Transaction Type"
                            : _selectedTransactionDesc,
                      ),
                    ),
                  ],
                ),
            // _buildDropdown(
            //   label: 'Branch',
            //   value: _selectedBranch,
            //   items: widget.branches,
            //   onChanged: (dynamic newValue) {
            //     setState(() {
            //       _selectedBranch = newValue!.txtNamee;
            //     });
            //   },
            // ),

            // _buildDropdown(
            //   label: 'Shift Status',
            //   value: _selectedShiftStatus,
            //   items: <String>['all', 'open', 'closed'],
            //   onChanged: (dynamic? newValue) {
            //     setState(() {
            //       _selectedShiftStatus = newValue!;
            //     });
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<dynamic> items,
    required Function(dynamic?) onChanged,
  }) {
    print("items: ${items.length}");
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[400]!),
            ),
            child: DropdownButton<dynamic>(
              value: value,
              onChanged: onChanged,
              isExpanded: true,
              underline: SizedBox(),
              items: items.map<DropdownMenuItem<String>>((dynamic value) {
                return DropdownMenuItem<String>(
                  value: value.toString(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(value.toString()),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required TextEditingController controller,
    required TextEditingController dateControllerToCompareWith,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomDate(
          readOnly: false,
          height: screenHeight * 0.04,
          dateWidth: Responsive.isDesktop(context)
              ? screenWidth * 0.14
              : screenWidth * 0.66,
          label: label,
          dateController: controller,
          lastDate: DateTime.now(),
          isForwardSlashFormat: true,
          dateControllerToCompareWith: dateControllerToCompareWith,
          isInitiaDate: label == _locale.fromDate ? true : false,
          onValue: (isValid, value) {
            if (isValid) {
              setState(() {
                controller.text = value;

                print("controller.text: ${controller.text}");
                // setFromDateController();
              });
            }
          },
          timeControllerToCompareWith: null,
        ),
        // TextFormField(
        //   controller: controller,
        //   decoration: InputDecoration(
        //     suffixIcon: Icon(Icons.calendar_today, color: Colors.blue),
        //     filled: true,
        //     fillColor: Colors.grey[200],
        //     contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        //     border: OutlineInputBorder(
        //       borderRadius: BorderRadius.circular(8),
        //       borderSide: BorderSide(color: Colors.grey[400]!),
        //     ),
        //   ),
        //   onTap: () async {
        //     DateTime? selectedDate = await _selectDate(context);
        //     if (selectedDate != null) {
        //       setState(() {
        //         controller.text = DateFormat('dd/MM/yyyy').format(selectedDate);
        //       });
        //     }
        //   },
        //   readOnly: true,
        // ),
      ],
    );
  }

  Future<DateTime?> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    return await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
  }
}
