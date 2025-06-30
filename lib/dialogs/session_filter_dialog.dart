import 'package:bi_replicate/components/custom_date.dart';
import 'package:bi_replicate/provider/dates_provider.dart';
import 'package:bi_replicate/utils/constants/responsive.dart';
import 'package:bi_replicate/utils/func/dates_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SessionFilterDialog extends StatefulWidget {
  const SessionFilterDialog({super.key});

  @override
  State<SessionFilterDialog> createState() => _SessionFilterDialogState();
}

class _SessionFilterDialogState extends State<SessionFilterDialog> {
  double screenWidth = 0.0;
  double screenHeight = 0.0;
  late AppLocalizations _locale;
  TextEditingController _fromDateController = TextEditingController();
  TextEditingController _toDateController = TextEditingController();
  String formattedFromDate = "";
  String formattedToDate = "";
  DateTime now = DateTime.now();

  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context)!;
    formattedFromDate =
        DateFormat('dd/MM/yyyy').format(DateTime(now.year, now.month, 1));

    formattedToDate = DateFormat('dd/MM/yyyy').format(now);
    if (context.read<DatesProvider>().sessionFromDate.isNotEmpty) {
      _fromDateController = TextEditingController(
          text:
              formatDateString(context.read<DatesProvider>().sessionFromDate));
    } else {
      _fromDateController =
          TextEditingController(text: formatDateString(formattedFromDate));
    }
    if (context.read<DatesProvider>().sessionToDate.isNotEmpty) {
      _toDateController = TextEditingController(
          text: formatDateString(context.read<DatesProvider>().sessionToDate));
    } else {
      _toDateController =
          TextEditingController(text: formatDateString(formattedToDate));
    }

    super.didChangeDependencies();
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

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return AlertDialog(
      title: Center(
        child: Text(
          _locale.selectSessionDates,
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
        Consumer<DatesProvider>(
          builder: (context, value, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // value.notify();
                    Navigator.pop(context, false);
                    print("value.date: ${value.sessionFromDate}");
                    print("value.date: ${value.sessionToDate}");
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
                    Navigator.of(context).pop(false);
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
            );
          },
        )
      ],
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
              ],
            ),
          ],
        ),
      ),
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
              ],
            ),
          ],
        ),
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
              ? screenWidth * 0.16
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
                if (label == _locale.fromDate) {
                  context.read<DatesProvider>().setSessionFromDate(
                      DatesController()
                          .slashFormatDate(_fromDateController.text, false));
                } else {
                  context.read<DatesProvider>().setSessionToDate(
                      DatesController()
                          .slashFormatDate(_fromDateController.text, false));
                }
                context.read<DatesProvider>().triggerDateChange();
                // context.read<DatesProvider>().notify();
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
}
