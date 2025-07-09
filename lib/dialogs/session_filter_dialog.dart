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

  // Compact color scheme - matching FilterDialog
  static const Color primaryColor = Color.fromRGBO(82, 151, 176, 1.0);
  static const Color primaryLight = Color.fromRGBO(82, 151, 176, 0.08);
  static const Color primaryDark = Color.fromRGBO(62, 131, 156, 1.0);
  static const Color backgroundColor = Color(0xFFFAFBFC);
  static const Color cardColor = Colors.white;
  static const Color textPrimary = Color(0xFF2D3748);
  static const Color textSecondary = Color(0xFF718096);

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
    
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: Responsive.isDesktop(context) ? 40 : 12,
        vertical: Responsive.isDesktop(context) ? 20 : 10,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: Responsive.isDesktop(context) ? 480 : screenWidth - 24,
          maxHeight: screenHeight * (Responsive.isDesktop(context) ? 0.4 : 0.5),
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
              // Compact Header - matching FilterDialog
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: Responsive.isDesktop(context) ? 12 : 10,
                  horizontal: Responsive.isDesktop(context) ? 16 : 12,
                ),
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
                    Icon(
                      Icons.date_range_outlined, 
                      color: Colors.white, 
                      size: Responsive.isDesktop(context) ? 16 : 14,
                    ),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        _locale.selectSessionDates,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Responsive.isDesktop(context) ? 14 : 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(false),
                      child: Container(
                        padding: EdgeInsets.all(Responsive.isDesktop(context) ? 3 : 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.close, 
                          color: Colors.white, 
                          size: Responsive.isDesktop(context) ? 14 : 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Scrollable Content
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(Responsive.isDesktop(context) ? 12 : 8),
                  child: Responsive.isDesktop(context)
                      ? desktopView(context)
                      : mobileView(context),
                ),
              ),
              
              // Compact Action Buttons - matching FilterDialog
              Container(
                padding: EdgeInsets.fromLTRB(
                  Responsive.isDesktop(context) ? 12 : 8,
                  4,
                  Responsive.isDesktop(context) ? 12 : 8,
                  Responsive.isDesktop(context) ? 12 : 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Consumer<DatesProvider>(
                  builder: (context, value, child) {
                    return Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: Responsive.isDesktop(context) ? 36 : 32,
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
                                  fontSize: Responsive.isDesktop(context) ? 12 : 11,
                                  color: textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 6),
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                            height: Responsive.isDesktop(context) ? 36 : 32,
                            child: ElevatedButton(
                              onPressed: () {
                                // value.notify();
                                Navigator.pop(context, false);
                                print("value.date: ${value.sessionFromDate}");
                                print("value.date: ${value.sessionToDate}");
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
                                  Icon(Icons.check, size: Responsive.isDesktop(context) ? 12 : 10),
                                  SizedBox(width: 3),
                                  Text(
                                    _locale.ok,
                                    style: TextStyle(
                                      fontSize: Responsive.isDesktop(context) ? 12 : 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget desktopView(BuildContext context) {
    return _buildCompactSection(
      title: _locale.sessionDateRange,
      child: Container(
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
      ),
    );
  }

  Widget mobileView(BuildContext context) {
    final isVerySmallScreen = screenWidth < 320;
    
    return _buildCompactSection(
      title: _locale.sessionDateRange,
      child: Container(
        constraints: BoxConstraints(
          minHeight: isVerySmallScreen ? 90 : 100,
          maxHeight: isVerySmallScreen ? 90 : 100,
        ),
        child: Row(
          children: [
            Expanded(
              child: _buildResponsiveDateField(
                _locale.fromDate,
                _fromDateController,
                _toDateController,
                isVerySmallScreen,
              ),
            ),
            SizedBox(width: isVerySmallScreen ? 4 : 6),
            Expanded(
              child: _buildResponsiveDateField(
                _locale.toDate,
                _toDateController,
                _fromDateController,
                isVerySmallScreen,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactSection({required String title, required Widget child}) {
    final isDesktop = Responsive.isDesktop(context);
    final isVerySmallScreen = screenWidth < 320;
    
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
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 8 : (isVerySmallScreen ? 6 : 7),
              vertical: isDesktop ? 4 : 3,
            ),
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
                fontSize: isDesktop ? 10 : (isVerySmallScreen ? 9 : 9.5),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(isDesktop ? 8 : (isVerySmallScreen ? 6 : 7)),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildResponsiveDateField(
    String label, 
    TextEditingController controller, 
    TextEditingController compareController,
    bool isCompact,
  ) {
    final isDesktop = Responsive.isDesktop(context);
    final isVerySmallScreen = screenWidth < 320;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            color: textPrimary,
            fontSize: isDesktop ? 14 : (isVerySmallScreen ? 11 : 12),
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: isDesktop ? 4 : 3),
        Expanded(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: isDesktop ? 32 : (isVerySmallScreen ? 26 : 28),
              minHeight: isDesktop ? 32 : (isVerySmallScreen ? 26 : 28),
            ),
            child: CustomDate(
              readOnly: false,
              height: isDesktop ? 32 : (isVerySmallScreen ? 26 : 28),
              dateWidth: double.infinity,
              label: "",
              dateController: controller,
              lastDate: DateTime.now(),
              isForwardSlashFormat: true,
              dateControllerToCompareWith: compareController,
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
                              .slashFormatDate(_toDateController.text, false));
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
          ),
        ),
      ],
    );
  }
}