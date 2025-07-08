import 'package:bi_replicate/components/custom_date.dart';
import 'package:bi_replicate/constants/constants.dart';
import 'package:bi_replicate/model/cashier_model.dart';
import 'package:bi_replicate/model/computer_model.dart';
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
  List<ComputerModel>? computers;

  FilterDialog(
      {required this.filter,
      required this.branches,
      required this.cashiers,
      required this.hint,
      this.computers});

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
  String selectedComputer = "";

  // Compact color scheme
  static const Color primaryColor = Color.fromRGBO(82, 151, 176, 1.0);
  static const Color primaryLight = Color.fromRGBO(82, 151, 176, 0.08);
  static const Color primaryDark = Color.fromRGBO(62, 131, 156, 1.0);
  static const Color backgroundColor = Color(0xFFFAFBFC);
  static const Color cardColor = Colors.white;
  static const Color textPrimary = Color(0xFF2D3748);
  static const Color textSecondary = Color(0xFF718096);

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

    if ((widget.computers ?? []).isNotEmpty) {
      if ((widget.computers ?? [])[0].computer != "all") {
        widget.computers!.insert(0, ComputerModel(computer: "all"));
      }
    }

    if ((widget.computers ?? []).isNotEmpty) {
      selectedComputer = (widget.computers ?? [])[0].computer ?? "";
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

    selectedComputer = widget.filter.computer ?? "";
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
      DateTime dateTime = DateFormat('dd/MM/yyyy').parse(dateString);
      return DateFormat('yyyy-MM-dd').format(dateTime);
    } catch (e) {
      return 'Invalid date';
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
    
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: Responsive.isDesktop(context) ? 40 : 16,
        vertical: 20,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: Responsive.isDesktop(context) ? 560 : screenWidth - 32,
          maxHeight: screenHeight * 0.75,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Compact Header
              Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, primaryDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.filter_alt_outlined, color: Colors.white, size: 16),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        _locale.salesReportsSearch,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(false),
                      child: Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.close, color: Colors.white, size: 14),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Scrollable Content
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(12),
                  child: Responsive.isDesktop(context)
                      ? desktopView(context)
                      : mobileView(context),
                ),
              ),
              
              // Compact Action Buttons
              Container(
                padding: EdgeInsets.fromLTRB(12, 4, 12, 12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 36,
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.grey[300]!),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Text(
                            _locale.cancel,
                            style: TextStyle(
                              fontSize: 12,
                              color: textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 36,
                        child: ElevatedButton(
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
                                toDate: formatDateStringToForwardSlash(
                                    _toDateController.text),
                                chartType: selectedChartType,
                                computer: selectedComputer == "" ? "all" : selectedComputer);
                            Navigator.of(context).pop(updatedFilter);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.search, size: 12),
                              SizedBox(width: 4),
                              Text(
                                _locale.ok,
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget mobileView(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Date Fields - Responsive
        _buildCompactSection(
          title: "Date Range",
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                constraints: BoxConstraints(
                  minHeight: 100,
                  maxHeight: 100,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildResponsiveDateField(
                        _locale.fromDate,
                        _fromDateController,
                        _toDateController,
                        constraints.maxWidth < 300,
                      ),
                    ),
                    SizedBox(width: constraints.maxWidth < 300 ? 4 : 8),
                    Expanded(
                      child: _buildResponsiveDateField(
                        _locale.toDate,
                        _toDateController,
                        _fromDateController,
                        constraints.maxWidth < 300,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        
        SizedBox(height: 8),
        
        // Branch Selection
        _buildCompactSection(
          title: "Branch & Filters",
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildCompactDropdown(
                CustomDropDownSearch(
                  isMandatory: true,
                  bordeText: _locale.selectBranch,
                  onChanged: (value) {
                    setState(() {
                      _selectedBranch = value.txtCode ?? "";
                      _selectedBranchName = value.txtNamee ?? "";
                    });
                  },
                  items: widget.branches,
                  initialValue: _selectedBranchName.isEmpty ? "Select Branch" : _selectedBranchName,
                ),
              ),
              
              if (_shouldShowShiftStatus()) ...[
                SizedBox(height: 8),
                _buildCompactDropdown(
                  CustomDropDownSearch(
                    isMandatory: true,
                    bordeText: _locale.selectShiftType,
                    onChanged: (value) {
                      setState(() {
                        _selectedShiftStatus = value;
                      });
                    },
                    items: <String>[_locale.all, _locale.opened, _locale.closed],
                    initialValue: _selectedShiftStatus.isEmpty ? "Select Shift" : _selectedShiftStatus,
                  ),
                ),
              ],
              
              if (_shouldShowCashier()) ...[
                SizedBox(height: 8),
                _buildCompactDropdown(
                  CustomDropDownSearch(
                    isMandatory: true,
                    bordeText: _locale.selectCashier,
                    onChanged: (value) {
                      setState(() {
                        _selectedCashier = value.txtNamee ?? "";
                        _selectedCashierCode = value.txtCode ?? "";
                      });
                    },
                    items: widget.cashiers,
                    initialValue: _selectedCashier.isEmpty ? "Select Cashier" : _selectedCashier,
                  ),
                ),
              ],
              
              if (widget.hint == _locale.cashierLogs) ...[
                SizedBox(height: 8),
                _buildCompactDropdown(
                  CustomDropDownSearch(
                    isMandatory: true,
                    bordeText: _locale.selectTransType,
                    onChanged: (value) {
                      setState(() {
                        _selectedTransactionType = value.id;
                        _selectedTransactionDesc = value.description;
                      });
                    },
                    items: transTypeList,
                    initialValue: _selectedTransactionDesc.isEmpty ? "Select Transaction Type" : _selectedTransactionDesc,
                  ),
                ),
              ],
            ],
          ),
        ),
        
        if (_shouldShowChartType() || widget.hint == _locale.salesByComputer) ...[
          SizedBox(height: 8),
          _buildCompactSection(
            title: "Display Options",
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_shouldShowChartType())
                  _buildCompactDropdown(
                    CustomDropDownSearch(
                      isMandatory: true,
                      bordeText: _locale.chartType,
                      onChanged: (value) {
                        setState(() {
                          selectedChartType = value;
                        });
                      },
                      items: charts,
                      initialValue: selectedChartType.isEmpty ? charts[0] : selectedChartType,
                    ),
                  ),
                
                if (widget.hint == _locale.salesByComputer) ...[
                  if (_shouldShowChartType()) SizedBox(height: 8),
                  _buildCompactDropdown(
                    CustomDropDownSearch(
                      isMandatory: true,
                      bordeText: _locale.computers,
                      onChanged: (value) {
                        setState(() {
                          selectedComputer = value.computer;
                        });
                      },
                      items: widget.computers ?? [],
                      initialValue: selectedComputer.isEmpty ? widget.computers![0].computer : selectedComputer,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget desktopView(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Date Fields Row - Responsive
        _buildCompactSection(
          title: "Date Range",
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                constraints: BoxConstraints(
                  minHeight: 100,
                  maxHeight: 100,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildResponsiveDateField(
                        _locale.fromDate,
                        _fromDateController,
                        _toDateController,
                        false,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildResponsiveDateField(
                        _locale.toDate,
                        _toDateController,
                        _fromDateController,
                        false,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        
        SizedBox(height: 8),
        
        // Filters Row
        _buildCompactSection(
          title: "Filters",
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildCompactDropdown(
                      CustomDropDownSearch(
                        isMandatory: true,
                        bordeText: _locale.selectBranch,
                        onChanged: (value) {
                          setState(() {
                            _selectedBranch = value.txtCode ?? "";
                            _selectedBranchName = value.txtNamee ?? "";
                          });
                        },
                        items: widget.branches,
                        initialValue: _selectedBranchName.isEmpty ? "Select Branch" : _selectedBranchName,
                      ),
                    ),
                  ),
                  
                  if (_shouldShowShiftStatus()) ...[
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildCompactDropdown(
                        CustomDropDownSearch(
                          isMandatory: true,
                          bordeText: _locale.selectShiftType,
                          onChanged: (value) {
                            setState(() {
                              _selectedShiftStatus = value;
                            });
                          },
                          items: <String>[_locale.all, _locale.opened, _locale.closed],
                          initialValue: _selectedShiftStatus.isEmpty ? "Select Shift" : _selectedShiftStatus,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              
              if (_shouldShowCashier() || widget.hint == _locale.cashierLogs) ...[
                SizedBox(height: 8),
                Row(
                  children: [
                    if (_shouldShowCashier())
                      Expanded(
                        child: _buildCompactDropdown(
                          CustomDropDownSearch(
                            isMandatory: true,
                            bordeText: _locale.selectCashier,
                            onChanged: (value) {
                              setState(() {
                                _selectedCashier = value.txtNamee ?? "";
                                _selectedCashierCode = value.txtCode ?? "";
                              });
                            },
                            items: widget.cashiers,
                            initialValue: _selectedCashier.isEmpty ? "Select Cashier" : _selectedCashier,
                          ),
                        ),
                      ),
                    
                    if (widget.hint == _locale.cashierLogs) ...[
                      if (_shouldShowCashier()) SizedBox(width: 12),
                      Expanded(
                        child: _buildCompactDropdown(
                          CustomDropDownSearch(
                            isMandatory: true,
                            bordeText: _locale.selectTransType,
                            onChanged: (value) {
                              setState(() {
                                _selectedTransactionType = value.id;
                                _selectedTransactionDesc = value.description;
                              });
                            },
                            items: transTypeList,
                            initialValue: _selectedTransactionDesc.isEmpty ? "Select Transaction Type" : _selectedTransactionDesc,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
        
        if (_shouldShowChartType() || widget.hint == _locale.salesByComputer) ...[
          SizedBox(height: 8),
          _buildCompactSection(
            title: "Display Options",
            child: Row(
              children: [
                if (_shouldShowChartType())
                  Expanded(
                    child: _buildCompactDropdown(
                      CustomDropDownSearch(
                        isMandatory: true,
                        bordeText: _locale.chartType,
                        onChanged: (value) {
                          setState(() {
                            selectedChartType = value;
                          });
                        },
                        items: charts,
                        initialValue: selectedChartType.isEmpty ? charts[0] : selectedChartType,
                      ),
                    ),
                  ),
                
                if (widget.hint == _locale.salesByComputer) ...[
                  if (_shouldShowChartType()) SizedBox(width: 12),
                  Expanded(
                    child: _buildCompactDropdown(
                      CustomDropDownSearch(
                        isMandatory: true,
                        bordeText: _locale.computers,
                        onChanged: (value) {
                          setState(() {
                            selectedComputer = value.computer;
                          });
                        },
                        items: widget.computers ?? [],
                        initialValue: selectedComputer.isEmpty ? widget.computers![0].computer : selectedComputer,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCompactSection({required String title, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: primaryLight,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Text(
              title,
              style: TextStyle(
                color: primaryDark,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildCompactDropdown(Widget child) {
    return SizedBox(height: 36, child: child);
  }

  // New responsive date field method
  Widget _buildResponsiveDateField(
    String label, 
    TextEditingController controller, 
    TextEditingController compareController,
    bool isCompact,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            color: textPrimary,
            fontSize: isCompact ? 12 : 14,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 4),
        Expanded(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: isCompact ? 28 : 32,
              minHeight: isCompact ? 28 : 32,
            ),
            child: CustomDate(
              readOnly: false,
              height: isCompact ? 28 : 32,
              dateWidth: double.infinity,
              label: "",
              dateController: controller,
              lastDate: DateTime.now(),
              isForwardSlashFormat: true,
              dateControllerToCompareWith: compareController,
              isInitiaDate: label == _locale.fromDate,
              onValue: (isValid, value) {
                if (isValid) {
                  setState(() {
                    controller.text = value;
                  });
                }
              },
              timeControllerToCompareWith: null,
            ),
          ),
        ),
      ],
    );
  }

  // Helper methods to reduce code duplication
  bool _shouldShowShiftStatus() {
    return widget.hint != _locale.salesByHours &&
        widget.hint != _locale.salesCostBasedStockCat &&
        widget.hint != _locale.diffClosedCashByShifts &&
        widget.hint != _locale.diffCashByShifts &&
        widget.hint != _locale.salesCostBasedBranch;
  }

  bool _shouldShowCashier() {
    return widget.hint == _locale.cashierLogs ||
        widget.hint == _locale.diffClosedCashByShifts ||
        widget.hint == _locale.diffCashByShifts ||
        widget.hint == _locale.salesByCashier;
  }

  bool _shouldShowChartType() {
    return widget.hint != _locale.salesCostBasedBranch &&
        widget.hint != _locale.salesCostBasedStockCat &&
        widget.hint != _locale.diffClosedCashByShifts &&
        widget.hint != _locale.diffCashByShifts;
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<dynamic> items,
    required Function(dynamic?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: textSecondary)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
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
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
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
