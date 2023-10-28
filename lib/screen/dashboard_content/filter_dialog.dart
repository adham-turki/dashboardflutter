import 'package:bi_replicate/provider/dates_provider.dart';
import 'package:bi_replicate/widget/drop_down/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../utils/constants/app_utils.dart';
import '../../utils/constants/responsive.dart';
import '../../utils/func/dates_controller.dart';
import '../../widget/custom_date_picker.dart';

class FilterDialog extends StatefulWidget {
  final Function(String selectedPeriod, String fromDate, String toDate,
      String selectedStatus) onFilter;

  FilterDialog({
    required this.onFilter,
  });

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late AppLocalizations _locale;
  bool isDesktop = false;
  final TextEditingController _fromDateController = TextEditingController();
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
      title: SelectableText("Filter Dialog"),
      content: SizedBox(
        width: width * 0.5,
        height: height * 0.3,
        child: Column(
          children: [
            Row(
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
                CustomDropDown(
                  items: status,
                  label: _locale.status,
                  initialValue: selectedStatus,
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value!;
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomDatePicker(
                  label: _locale.fromDate,
                  date: DateTime.parse(_toDateController.text),
                  controller: _fromDateController,
                  onSelected: (value) {
                    setState(() {
                      _fromDateController.text = value;
                    });
                  },
                ),
                CustomDatePicker(
                  label: _locale.toDate,
                  controller: _toDateController,
                  date: DateTime.parse(_fromDateController.text),
                  onSelected: (value) {
                    setState(() {
                      _toDateController.text = value;
                    });
                  },
                ),
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
              width: width * 0.09,
              onPressed: () {
                widget.onFilter(
                    selectedPeriod,
                    DatesController().formatDate(_fromDateController.text),
                    DatesController().formatDate(_toDateController.text),
                    selectedStatus);
                print("_fromDateController.text :${_fromDateController.text}");
                print("periodd :${selectedPeriod}");
                context
                    .read<DatesProvider>()
                    .setDatesController(_fromDateController, _toDateController);
                Navigator.of(context).pop();
              },
              text: "Filter",
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
