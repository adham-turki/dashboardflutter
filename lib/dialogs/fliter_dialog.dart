import 'package:bi_replicate/utils/constants/responsive.dart';
import 'package:bi_replicate/widget/custom_drop_down_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/sales/branch_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../model/sales/search_crit.dart';

class FilterDialog extends StatefulWidget {
  final SearchCriteria filter;
  final List<BranchModel> branches;

  FilterDialog({required this.filter, required this.branches});

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  String _selectedBranch = "";
  String _selectedBranchName = "";
  String _selectedShiftStatus = "";
  TextEditingController _fromDateController = TextEditingController();
  TextEditingController _toDateController = TextEditingController();
  double screenWidth = 0.0;
  double screenHeight = 0.0;

  late AppLocalizations _locale;
  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context)!;
    widget.branches.insert(
        0,
        BranchModel(
            txtCode: "all",
            txtNamee: _locale.localeName == "en" ? "all" : "الكل",
            txtCostcentercode: "",
            txtPrefix: "",
            txtWarehouse: "",
            txtJcode: ""));
    _selectedBranch = widget.filter.branch;
    _selectedShiftStatus = widget.filter.shiftStatus == "0"
        ? "open"
        : widget.filter.shiftStatus == "1"
            ? "closed"
            : _locale.localeName == "en"
                ? "all"
                : "الكل";
    if (widget.branches.isNotEmpty) {
      for (var i = 0; i < widget.branches.length; i++) {
        if (widget.branches[i].txtCode == _selectedBranch) {
          _selectedBranchName = widget.branches[i].txtNamee;
        }
      }
      super.didChangeDependencies();
    }

    @override
    void initState() {
      super.initState();
      print("widget.branches: ${widget.branches.length}");
    }

    _fromDateController = TextEditingController(text: widget.filter.fromDate);
    _toDateController = TextEditingController(text: widget.filter.toDate);
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
      content: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width * 0.3,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: Responsive.isDesktop(context)
                    ? screenWidth * 0.16
                    : screenWidth * 0.76,
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
              SizedBox(
                width: Responsive.isDesktop(context)
                    ? screenWidth * 0.16
                    : screenWidth * 0.76,
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
                    _locale.localeName == "en" ? "all" : "الكل",
                    _locale.opened,
                    _locale.closed
                  ],
                  initialValue: _selectedShiftStatus == ""
                      ? "Select Shift"
                      : _selectedShiftStatus,
                ),
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

              SizedBox(
                width: Responsive.isDesktop(context)
                    ? screenWidth * 0.16
                    : screenWidth * 0.76,
                height: screenHeight * 0.1,
                child: _buildDateField(
                  label: _locale.fromDate,
                  controller: _fromDateController,
                ),
              ),

              SizedBox(
                width: Responsive.isDesktop(context)
                    ? screenWidth * 0.16
                    : screenWidth * 0.76,
                height: screenHeight * 0.1,
                child: _buildDateField(
                  label: _locale.toDate,
                  controller: _toDateController,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                SearchCriteria updatedFilter = SearchCriteria(
                  branch: _selectedBranch,
                  shiftStatus: _selectedShiftStatus == "open"
                      ? "0"
                      : _selectedShiftStatus == "closed"
                          ? "1"
                          : "all",
                  fromDate: _fromDateController.text,
                  toDate: _toDateController.text,
                );
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
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.black54)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            suffixIcon: Icon(Icons.calendar_today, color: Colors.blue),
            filled: true,
            fillColor: Colors.grey[200],
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[400]!),
            ),
          ),
          onTap: () async {
            DateTime? selectedDate = await _selectDate(context);
            if (selectedDate != null) {
              setState(() {
                controller.text = DateFormat('dd/MM/yyyy').format(selectedDate);
              });
            }
          },
          readOnly: true,
        ),
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
