import 'package:bi_replicate/widget/text_field_custom_new.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/constants/colors.dart';

/* This TextField Component,
    Supports Email, Password, and defualt TextFields
    Example:
    TextFieldCustomNew(
      text: Text(_locale.userName), -> this is the hint for the Text Field
      obscureText: false, -> if the text is shown or not in the Text Field
      controller: username, -> The controller of the Text Field
    ),
    */

class CustomTextField2 extends StatefulWidget {
  double? padding;
  // String label;
  double? width;
  TextEditingController? controller;
  String? initialValue;
  Function(String value)? onSubmitted;
  Function(String)? onValidator;
  Key? customKey;
  bool? readOnly;
  bool? autoFocus;
  Function(String value)? onChanged;
  FocusNode? focusNode;
  Text? text;
  Function? onSaved;
  Icon? customIcon;
  dynamic customIconSuffix;
  bool? notefield;
  Color? color;
  Function()? onTap;
  TextInputType? keyboardType;
  List<TextInputFormatter>? inputFormatters;
  bool? obscureText;
  int? maxLength;
  InputDecoration? decoration;
  bool? showText;
  bool? enabled;
  bool? isReport;
  bool? isDocReport;

  CustomTextField2(
      {Key? key,
      this.onValidator,
      // required this.label,
      this.controller,
      this.initialValue,
      this.padding,
      this.onSubmitted,
      this.customKey,
      this.width,
      this.readOnly,
      this.autoFocus,
      this.onChanged,
      this.focusNode,
      this.customIcon,
      this.customIconSuffix,
      this.color,
      this.onTap,
      this.onSaved,
      this.keyboardType,
      this.inputFormatters,
      this.text,
      this.notefield,
      this.maxLength,
      this.decoration,
      this.showText,
      this.obscureText,
      this.isReport = false,
      this.isDocReport = false,
      this.enabled})
      : super(key: key);

  @override
  State createState() => _CustomTextField2State();
}

class _CustomTextField2State extends State<CustomTextField2> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.isReport!
          ? MediaQuery.of(context).size.height * 0.045
          : widget.isDocReport!
              ? MediaQuery.of(context).size.height * 0.045
              : MediaQuery.of(context).size.height * 0.03,
      width: widget.isReport!
          ? MediaQuery.of(context).size.width * 0.18
          : widget.isDocReport!
              ? MediaQuery.of(context).size.width * 0.15
              : MediaQuery.of(context).size.width * 0.18,
      child: TextFieldCustomNew(
        controller: widget.controller,
        onChanged: widget.onChanged,
        decoration: widget.decoration ??
            // InputDecoration(
            //   label: Text(
            //     widget.text!.data!,
            //     style: TextStyle(
            //       fontSize: MediaQuery.of(context).size.height * 0.015,
            //       color:
            //           widget.color ?? const Color.fromARGB(255, 114, 119, 123),
            //     ),
            //   ),
            //   labelStyle: TextStyle(
            //     color: widget.color ?? const Color.fromARGB(255, 114, 119, 123),
            //   ),
            //   floatingLabelAlignment: FloatingLabelAlignment.start,
            //   prefixIcon: widget.showText == false ? null : widget.customIcon,
            //   suffixIcon:
            //       widget.showText == true ? null : widget.customIconSuffix,
            //   border: OutlineInputBorder(
            //     borderRadius: BorderRadius.circular(20),
            //   ),
            //   constraints: BoxConstraints.tightFor(
            //     width: MediaQuery.of(context).size.width * 0.007,
            //   ),
            // ),
            InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
              labelText: widget.text!.data!,
              labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
              hintStyle: const TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 68, 67, 67),
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none,
                decorationColor: Colors.transparent,
                decorationStyle: TextDecorationStyle.solid,
                decorationThickness: 1.0,
              ),
              errorStyle: const TextStyle(
                  height: 0, color: Color.fromARGB(255, 207, 95, 4)),
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              errorMaxLines: 1,
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: primary,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(1.0),
              ),
            ),
        inputFormatters: widget.inputFormatters,
        onSaved: (value) => widget.onSaved,
        obscureText: widget.obscureText ?? false,
        initialValue: widget.initialValue,
        maxLength: widget.maxLength,
        readOnly: widget.readOnly ?? false,
        keyboardType: widget.keyboardType,
        onFieldSubmitted: widget.onSubmitted,
        // enabled: widget.enabled ?? true,
      ),
    );
  }

  void _setCursorToEnd() {
    final textLength = widget.controller?.text.length ?? 0;
    widget.controller?.selection = TextSelection.fromPosition(
      TextPosition(offset: textLength),
    );
  }
}
