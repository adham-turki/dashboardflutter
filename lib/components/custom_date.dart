import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../provider/dates_provider.dart';
import '../utils/constants/responsive.dart';

class CustomDate extends StatefulWidget {
  final String label;
  int? minYear;
  Function(bool isValid, String value)? onValue;
  bool? ddmmyyyy;
  final TextEditingController? dateController;
  String? date;

  CustomDate(
      {super.key,
      required this.label,
      this.onValue,
      this.dateController,
      this.minYear,
      this.ddmmyyyy,
      this.date});

  @override
  State<CustomDate> createState() => _CustomDateState();
}

class _CustomDateState extends State<CustomDate> {
  late AppLocalizations _locale;
  double width = 0;
  double height = 0;
  final MaskTextInputFormatter _maskYear =
      MaskTextInputFormatter(mask: "####", type: MaskAutoCompletionType.eager);
  final MaskTextInputFormatter _maskDayMonth =
      MaskTextInputFormatter(mask: "##", type: MaskAutoCompletionType.eager);

  TextEditingController yearController = TextEditingController();
  TextEditingController monthController = TextEditingController();
  TextEditingController dayController = TextEditingController();

  String yearHint = "YYYY";
  String monthHint = "MM";
  String dayHint = "DD";

  Color borderColor = Colors.grey;
  Color borderErrorColor = Colors.red;
  double borderRadius = 5;

  bool isValid = false;

  String activeDateErrorMessage = "Check Your Input Format!";
  String yearIsGreater = "Year is Wrong";
  String monthIsGreater = "Month is Wrong";
  String dayIsGreater = "Day is Wrong";
  TextEditingController controller = TextEditingController();

  FocusNode yearFocusNode = FocusNode();
  FocusNode monthFocusNode = FocusNode();
  FocusNode dayFocusNode = FocusNode();

  bool dayTemp = true;
  bool monthTemp = true;
  bool yearTemp = true;
  @override
  void initState() {
    setListeners();
    clearDateProvider();
    super.initState();
  }

  clearDateProvider() {
    if (!context.read<DatesProvider>().dayTemp) {
      context.read<DatesProvider>().setDayTemp(true);
    } else if (!context.read<DatesProvider>().monthTemp) {
      context.read<DatesProvider>().setMonthTemp(true);
    } else if (!context.read<DatesProvider>().yearTemp) {
      context.read<DatesProvider>().setYearTemp(true);
    }
  }

  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  splitDate() {
    controller = widget.dateController!;
    print("contttttttttt: ${controller.text}");
    return controller.text.split("-");
  }

  @override
  void dispose() {
    yearFocusNode.dispose();
    monthFocusNode.dispose();
    dayFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    String label = widget.label;

    if (widget.dateController!.text.isNotEmpty) {
      yearController.text = splitDate()[0];
      monthController.text = splitDate()[1];
      dayController.text = splitDate()[2];
    }

    return SizedBox(
      width: width * 0.163,
      child: Column(
        children: [
          Consumer<DatesProvider>(
            builder: (context, value, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  labelMessage(label),
                  !value.getDayTemp() ||
                          !value.getMonthTemp() ||
                          !value.getYearTemp()
                      ? errorMessage(_locale.checkDates)
                      : Container(),
                ],
              );
            },
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: borderColor,
              ),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Row(
              children: [
                getSuffixIcon(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    createDateField(
                        _maskDayMonth, dayController, dayHint, dayFocusNode),
                    dateDivider(),
                    createDateField(_maskDayMonth, monthController, monthHint,
                        monthFocusNode),
                    dateDivider(),
                    createDateField(
                        _maskYear, yearController, yearHint, yearFocusNode),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SizedBox dateDivider() {
    return SizedBox(
      width: width * 0.008,
      child: Transform.rotate(
        angle: 120 * 3.14159265359 / 180,
        child: const Divider(
          thickness: 3,
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget createDateField(MaskTextInputFormatter mask,
      TextEditingController controller, String hint, FocusNode focusNode) {
    return SizedBox(
      width: Responsive.isDesktop(context) ? width * 0.028 : width * 0.1,
      child: TextFormField(
        focusNode: focusNode,
        controller: controller,
        inputFormatters: [mask],
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
        ),
        onTap: () {
          if (hint == dayHint) {
            emptyDateControllers();
          } else if (hint == monthHint) {
            if (monthController.text.isNotEmpty) {
              monthController.clear();
            }
          } else if (hint == yearHint) {
            if (yearController.text.isNotEmpty) {
              yearController.clear();
            }
          }
        },
        onChanged: (value) {
          setRequestNodes(hint);
          if (dayController.text.length == 2 &&
              monthController.text.length == 2 &&
              yearController.text.length == 4) {
            // submitValueDate(focusNode);
          }
        },
        onFieldSubmitted: (value) {
          submitValueDate(focusNode);
        },
      ),
    );
  }

  emptyDateControllers() {
    if (yearController.text.isNotEmpty &&
        monthController.text.isNotEmpty &&
        dayController.text.isNotEmpty) {
      yearController.clear();
      dayController.clear();
      monthController.clear();
    }
    if (yearController.text.isNotEmpty) {
      yearController.clear();
    } else if (dayController.text.isNotEmpty) {
      dayController.clear();
    } else if (monthController.text.isNotEmpty) {
      monthController.clear();
    }
  }

  void submitValueDate(FocusNode focusNode) {
    checkDates();
    if (!isValid) {
      focusNode.requestFocus();
    } else {
      if (widget.onValue != null) {
        // String dateValue = getDateValue();

        widget.onValue!(isValid, getDateValue());
      }
    }
  }

  Widget getSuffixIcon() {
    return Container(
      decoration: BoxDecoration(
          border: Border(
        right: BorderSide(
          color: borderColor,
          width: 1.5,
        ),
      )),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            setDatePickerValues();
          },
          child: const Icon(
            Icons.date_range_outlined,
          ),
        ),
      ),
    );
  }

  bool dateValidation() {
    String yearStr = yearController.text;
    String monthStr = monthController.text;
    String dayStr = dayController.text;

    DateTime dateTime = DateTime.now();

    int yearNow = dateTime.year;
    int monthNow = dateTime.month;
    int dayNow = dateTime.day;

    if (yearStr.isNotEmpty && yearStr.length == 4) {
      int minYear = widget.minYear ?? 2000;
      int year = int.parse(yearStr);
      if (year > yearNow || year < minYear) {
        yearController.text = yearNow.toString();
        return true;
      }
    }

    if (monthStr.isNotEmpty && monthStr.length == 2) {
      int month = int.parse(monthStr);
      int year = int.parse(yearStr);

      if (month > monthNow && year == yearNow) {
        monthController.text = monthNow.toString();
        dayController.text = dayNow.toString();
        return true;
      }
    }

    if (yearStr.length != 4 || monthStr.length != 2 || dayStr.length != 2) {
      return false;
    }

    try {
      int year = int.parse(yearStr);
      int month = int.parse(monthStr);
      int day = int.parse(dayStr);

      if (year <= yearNow && yearStr.length == 4) {
        if (month <= 12) {
          if (dayStr.length == 2) {
            if (day > dayNow && month >= monthNow && year >= yearNow) {
              dayController.text = dayNow.toString();
            }
            if ((month == 4 || month == 6 || month == 9 || month == 11) &&
                day <= 30) {
              return true;
            } else if ((month == 4 ||
                    month == 6 ||
                    month == 9 ||
                    month == 11) &&
                day > 30) {
              dayController.text = 30.toString();
              return true;
            } else if (month == 2 && day <= 29) {
              return true;
            } else if (month == 2 && day > 29) {
              dayController.text = 29.toString();

              return true;
            } else if (day <= 31) {
              return true;
            } else if (day > 31) {
              dayController.text = 31.toString();
              return true;
            }
          }

          //If no condition above true for the day
          // activeDateErrorMessage = dayIsGreater;
        } else {
          // activeDateErrorMessage = monthIsGreater;
          // monthController.text = monthNow.toString();
        }
      } else {
        // yearController.text = yearNow.toString();
        // activeDateErrorMessage = yearIsGreater;
      }
    } catch (e) {
      // String yearStr = yearController.text;
      // String monthStr = monthController.text;
      // String dayStr = dayController.text;

      // print("There was an error with date validation");
    }
    return false;
  }

  Widget errorMessage(String msg) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        msg,
        style: TextStyle(
          fontSize: 10,
          color: borderErrorColor,
        ),
      ),
    );
  }

  Widget labelMessage(String msg) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        msg,
      ),
    );
  }

  void setRequestNodes(String hint) {
    String year = yearController.text;
    String month = monthController.text;
    String day = dayController.text;
    DateTime dateTime = DateTime.now();

    if (hint.compareTo(dayHint) == 0 && day.length == 2) {
      dayController.text = dayController.text;
      if (int.parse(dayController.text) > 31 && dayController.text[0] != "0") {
        context.read<DatesProvider>().setDayTemp(false);
        dayController.text = dateTime.day.toString();
        // dayTemp = false;
        // setState(() {});
      } else {
        // dayController.text = dateTime.day.toString();
        context.read<DatesProvider>().setDayTemp(true);

        // dayTemp = true;
      }
      if (dayTemp) {
        monthFocusNode.requestFocus();
      }
    } else if (hint.compareTo(monthHint) == 0 && day.isNotEmpty) {
      if (month.length == 2) {
        monthController.text = monthController.text;
        if (int.parse(monthController.text) > 12 &&
            monthController.text[0] != "0") {
          // monthTemp = false;
          context.read<DatesProvider>().setMonthTemp(false);
          // setState(() {});

          monthController.text = dateTime.month.toString();
        } else {
          // dayController.text = dateTime.day.toString();
          context.read<DatesProvider>().setMonthTemp(true);

          // monthTemp = true;
        }
        if (monthTemp) {
          yearFocusNode.requestFocus();
        }
      }
    } else {
      if (year.length == 4) {
        yearController.text = yearController.text;
        if (int.parse(yearController.text) > dateTime.year &&
            yearController.text[0] != "0") {
          // yearController.text = dateTime.year.toString();
          // yearTemp = false;
          context.read<DatesProvider>().setYearTemp(false);

          // setState(() {});

          yearController.text = dateTime.year.toString();
        } else {
          // yearController.text = dateTime.year.toString();
          // yearTemp = true;
          context.read<DatesProvider>().setYearTemp(true);
        }
        // yearFocusNode.unfocus();

        isValid = dateValidation();

        // if (isValid && textNotEmpty()) {
        //   if (widget.onValue != null) {
        //     String dateValue = getDateValue();
        //     widget.onValue!(isValid, dateValue);
        //   }
        // }
      }
    }
    //Goes to month after finishing year
    // if (hint.compareTo(yearHint) == 0 && year.length == 4) {
    //   monthFocusNode.requestFocus();
    // } else if (hint.compareTo(monthHint) == 0 && year.isNotEmpty) {
    //   if (month.length == 2) {
    //     dayFocusNode.requestFocus();
    //   }
    // } else if (hint.compareTo(dayHint) == 0 &&
    //     year.isNotEmpty &&
    //     month.isNotEmpty) {
    //   if (day.length == 2) {
    //     dayFocusNode.unfocus();
    //   }
    // }
  }

  void setListeners() {
    yearFocusNode.addListener(() {
      // String year = yearController.text;
      if (!yearFocusNode.hasFocus) {
        // setState(() {
        isValid = dateValidation();
        // if (widget.onValue != null) {
        //   String dateValue = getDateValue();
        //   widget.onValue!(isValid, dateValue);
        // }
        // });
      }

      bool backspaceKeyPressed = false;
      yearFocusNode.onKeyEvent = (node, event) {
        if (event.logicalKey == LogicalKeyboardKey.backspace) {
          if (!backspaceKeyPressed) {
            // Handle the backspace key press here
            yearController.text = "";
            backspaceKeyPressed = true;
          }
          return KeyEventResult.handled;
        } else {
          backspaceKeyPressed = false;
        }
        return KeyEventResult.ignored;
      };
    });

    monthFocusNode.addListener(() {
      String month = monthController.text;
      if (!monthFocusNode.hasFocus) {
        // print(month.length);
        if (month.length == 1) {
          if (month.compareTo("0") == 0) {
            monthController.text = "01";
          } else {
            monthController.text = "0$month";
          }
        } else if (month.compareTo("00") == 0) {
          monthController.text = "01";
        }
        // setState(() {
        isValid = dateValidation();
        // print("object9999999");
        // if (isValid) {
        //   if (widget.onValue != null) {
        //     String dateValue = getDateValue();
        //     widget.onValue!(isValid, dateValue);
        //   }
        // }
        // });
      }
      bool backspaceKeyPressed = false;
      monthFocusNode.onKeyEvent = (node, event) {
        if (event.logicalKey == LogicalKeyboardKey.backspace) {
          if (!backspaceKeyPressed) {
            // Handle the backspace key press here
            monthController.text = "";
            backspaceKeyPressed = true;
          }
          return KeyEventResult.handled;
        } else {
          backspaceKeyPressed = false;
        }
        return KeyEventResult.ignored;
      };
    });

    dayFocusNode.addListener(() {
      String day = dayController.text;
      if (!dayFocusNode.hasFocus) {
        if (day.length == 1) {
          if (day.compareTo("0") == 0) {
            dayController.text = "01";
          } else {
            dayController.text = "0$day";
          }
        } else if (day.compareTo("00") == 0) {
          dayController.text = "01";
        }
        // setState(() {
        isValid = dateValidation();
        // print("object9999999");
        // if (isValid) {
        //   if (widget.onValue != null) {
        //     String dateValue = getDateValue();
        //     widget.onValue!(isValid, dateValue);
        //   }
        // }
        // });
      }
      bool backspaceKeyPressed = false;
      dayFocusNode.onKeyEvent = (node, event) {
        if (event.logicalKey == LogicalKeyboardKey.backspace) {
          if (!backspaceKeyPressed) {
            // Handle the backspace key press here
            dayController.text = "";
            backspaceKeyPressed = true;
          }
          return KeyEventResult.handled;
        } else {
          backspaceKeyPressed = false;
        }
        return KeyEventResult.ignored;
      };
    });
  }

  String getDateValue() {
    String year = yearController.text;
    String month = monthController.text;
    String day = dayController.text;
    String yyyymmddd = "";
    String mmddyyyy = "";
    if (day.length == 1) {
      yyyymmddd = "$year-$month-0$day";
      mmddyyyy = "0$day-$month-$year";
    } else if (month.length == 1) {
      yyyymmddd = "$year-0$month-$day";
      mmddyyyy = "$day-0$month-$year";
    }
    if (day.length == 2 && month.length == 2) {
      yyyymmddd = "$year-$month-$day";
    }

    if (widget.ddmmyyyy != null) {
      if (widget.ddmmyyyy!) {
        return mmddyyyy;
      }
    }
    return yyyymmddd;
  }

  void setDatePickerValues() {
    DateTime dateTime = DateTime.now();
    DateTime firstDate = DateTime(2000);
    showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: firstDate,
      lastDate: dateTime,
    ).then((dateResult) {
      setState(() {
        if (dateResult != null && widget.onValue != null) {
          yearController.text = dateResult.year.toString();
          monthController.text = dateResult.month.toString();
          dayController.text = dateResult.day.toString();
          if (monthController.text.length == 1) {
            monthController.text = "0${monthController.text}";
          }
          if (dayController.text.length == 1) {
            dayController.text = "0${dayController.text}";
          }
          bool isValid = dateValidation();
          if (isValid) {
            context.read<DatesProvider>().setDayTemp(true);
            context.read<DatesProvider>().setMonthTemp(true);
            context.read<DatesProvider>().setYearTemp(true);
            widget.onValue!(true, getDateValue());
          }
        }
      });
    });
  }

  void checkDates() {
    String month = monthController.text;
    if (month.length == 1) {
      monthController.text = "0$month";
    }
    String day = dayController.text;
    if (day.length == 1) {
      dayController.text = "0$day";
    }

    isValid = dateValidation();
  }

  bool textNotEmpty() {
    if (yearController.text.isNotEmpty &&
        monthController.text.isNotEmpty &&
        dayController.text.isNotEmpty) {
      return true;
    }
    return false;
  }
}
