import 'package:bi_replicate/model/custom_scroll_behavior.dart';
import 'package:bi_replicate/widget/custom_btn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../utils/constants/responsive.dart';
import 'custom_label.dart';

class CustomDatePicker extends StatefulWidget {
  final String label;
  final double? padding;
  Function(String value)? onSelected;
  Function(String value)? onChanged;
  TextEditingController controller;
  double? width;

  final DateTime date;
  CustomDatePicker(
      {super.key,
      this.padding,
      required this.label,
      this.onChanged,
      this.onSelected,
      required this.controller,
      this.width,
      required this.date});

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late AppLocalizations _locale;
  double width = 0;
  double height = 0;
  bool isVisible = false;

  int dateLimit = 2000;

  final MaskTextInputFormatter _maskTextInputFormatter = MaskTextInputFormatter(
      mask: "####-##-##", type: MaskAutoCompletionType.eager);

  // final TextEditingController controller = TextEditingController();

  bool isDoneDate = false;

  String? errorText;

  Color borderColor = Colors.grey;

  DateTime nowDate = DateTime.now();

  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context)!;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    String label = widget.label;
    double padding = widget.padding ?? 8.0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: padding),
      child: Column(
        children: [
          CustomLabel(
            label: label,
            width: Responsive.isDesktop(context)
                ? widget.width ?? width * 0.15
                : width,
          ),
          Container(
            decoration: const BoxDecoration(color: Colors.white),
            width: Responsive.isDesktop(context)
                ? widget.width ?? width * 0.15
                : width,
            child: TextFormField(
              controller: widget.controller,
              inputFormatters: [_maskTextInputFormatter],
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: borderColor),
                ),
                // errorBorder: OutlineInputBorder(
                //   borderRadius: BorderRadius.circular(5),
                //   borderSide: const BorderSide(color: Colors.red),
                // ),
                // focusedErrorBorder: OutlineInputBorder(
                //   borderRadius: BorderRadius.circular(5),
                //   borderSide: const BorderSide(color: Colors.red),
                // ),
                // errorText: "errorText",
                hintText: "yyyy-mm-dd",
                hintStyle: TextStyle(
                  color: Colors.black.withOpacity(0.5),
                ),
                suffixIcon: getSuffixIcon(),
                suffixIconColor: Colors.grey,
              ),
              style: const TextStyle(color: Colors.black),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: (value) {
                setState(() {
                  bool isValid = checkDateValue();
                  if (isValid) {
                    borderColor = Colors.grey;
                    if (widget.onChanged != null) {
                      FocusScope.of(context).unfocus();
                      widget.controller.text = value;
                      widget.onChanged!(value);
                    }
                  } else {
                    borderColor = Colors.red;
                  }
                });
              },
              // validator: (value) {
              //   bool check = checkDateValue();
              //   if (!check) {
              //     return "";
              //   }
              //   return null;
              // },
            ),
          ),
        ],
      ),
    );
  }

  Widget getSuffixIcon() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () async {
          await selectDate();
          if (widget.onSelected != null) {
            widget.onSelected!(widget.controller.text);
          }
        },
        child: const Icon(
          Icons.date_range_outlined,
        ),
      ),
    );
  }

  Future<DateTime?> openDatePickerDialog() async {
    DateTime? date = DateFormat('yyyy-MM-dd').parse(widget.controller.text);
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (builder) {
          return AlertDialog(
            title: Text(_locale.chooseDate),
            content: SizedBox(
              width: Responsive.isDesktop(context) ? width * 0.25 : width,
              height: height * 0.15,
              child: ScrollConfiguration(
                behavior: CustomScrollBehavior(),
                child: SizedBox(
                  width: width * 0.25,
                  child: CupertinoDatePicker(
                    minimumDate: widget.label == _locale.fromDate
                        ? DateTime(1900)
                        : widget.date,
                    minimumYear: widget.label == _locale.fromDate
                        ? DateTime(1900).year
                        : widget.date!.year,
                    maximumDate: widget.label == _locale.fromDate
                        ? widget.date
                        : nowDate,
                    maximumYear: widget.label == _locale.fromDate
                        ? widget.date!.year
                        : nowDate.year,
                    initialDateTime: date ?? nowDate,
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (DateTime value) {
                      date = value;
                    },
                  ),
                ),
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    text: _locale.submit,
                    textColor: Colors.white,
                    borderRadius: 5.0,
                  ),
                ],
              ),
            ],
          );
        });
    return date;
  }

  Future selectDate() async {
    DateTime? date = await openDatePickerDialog();
    if (date != null) {
      int day = date.day;
      int month = date.month;
      int year = date.year;

      String dayStr = day < 10 ? "0$day" : day.toString();
      String monthStr = month < 10 ? "0$month" : month.toString();

      setState(() {
        widget.controller.text = "$year-$monthStr-$dayStr";
      });
    }
  }

  bool checkDateValue() {
    String value = widget.controller.text;

    try {
      List<String> list = value.split("-");
      int year = int.parse(list[0]);
      int month = int.parse(list[1]);
      int day = int.parse(list[2]);

      int nowYear = nowDate.year;

      if (year <= nowYear && year.toString().length == 4) {
        if (month <= 12) {
          if ((month == 4 || month == 6 || month == 9 || month == 11) &&
              day <= 30) {
            return true;
          } else if (month == 2 && day <= 29) {
            return true;
          } else if (day <= 31) {
            return true;
          }
        }
      }
    } catch (e) {
      return false;
    }
    return false;
  }
}
