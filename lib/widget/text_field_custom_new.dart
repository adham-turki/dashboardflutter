// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/constants/responsive.dart';

class TextFieldCustomNew extends StatefulWidget {
  Text? text;
  ValueChanged<String>? onChanged;
  Function? onSaved;
  TextEditingController? controller;
  Icon? customIcon;
  dynamic customIconSuffix;
  bool? notefield;
  FocusNode? focusNode;
  Color? color;
  Function()? onTap;
  TextInputType? keyboardType;
  List<TextInputFormatter>? inputFormatters;
  Function(String)? onValidator;
  bool? obscureText;
  String? initialValue;
  bool? readOnly;
  int? maxLength;
  InputDecoration? decoration;
  IconButton? testButton;
  bool? showText;
  Function(String)? onFieldSubmitted;
  TextStyle? style;
  int? maxLines;
  // dynamic? pre;
  TextFieldCustomNew(
      {Key? key,
      this.focusNode,
      this.customIcon,
      this.customIconSuffix,
      this.color,
      this.onValidator,
      this.onTap,
      this.onSaved,
      this.keyboardType,
      this.testButton,
      this.inputFormatters,
      this.text,
      this.onChanged,
      this.controller,
      this.initialValue,
      this.notefield,
      this.readOnly,
      this.maxLength,
      this.decoration,
      this.showText,
      this.style,
      this.onFieldSubmitted,
      this.maxLines,
      this.obscureText})
      : super(key: key);

  @override
  State createState() => _TextFieldCustomNewState();
}

class _TextFieldCustomNewState extends State<TextFieldCustomNew> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    bool isDesktop = Responsive.isDesktop(context);
    return SizedBox(
      width: width * .33,
      child: TextFormField(
        onTap: () {
          if (widget.onTap != null) {
            widget.onTap!();
          }
        },
        focusNode: widget.focusNode ?? FocusNode(),
        onFieldSubmitted: (value) {
          if (widget.onFieldSubmitted != null) {
            widget.onFieldSubmitted!(value);
          }
        },
        style: widget.style,
        controller: widget.controller,
        onChanged:
            // (newValue) {
            widget.onChanged,
        // _setCursorToEnd();
        // },
        maxLines: widget.maxLines ?? 1,
        validator: (text) =>
            widget.onValidator == null ? null : widget.onValidator!(text!),
        decoration: widget.decoration ??
            InputDecoration(
              // prefix: widget.pre,
              label: Text(
                widget.text!.data!,
                style: TextStyle(
                  fontSize: isDesktop ? height * 0.016 : height * 0.014,
                  // color:
                  //     widget.color ?? const Color.fromARGB(255, 114, 119, 123),
                ),
              ),
              // labelStyle: TextStyle(
              //   color: widget.color ?? const Color.fromARGB(255, 114, 119, 123),
              // ),
              floatingLabelAlignment: FloatingLabelAlignment.start,
              prefixIcon: widget.showText == false ? null : widget.customIcon,
              suffixIcon:
                  widget.showText == true ? null : widget.customIconSuffix,
              border: const UnderlineInputBorder(
                  // borderSide: BorderSide(color: Colors.red)
                  ),
              //  OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(20),
              // ),
              constraints: BoxConstraints.tightFor(
                width: width * 0.007,
              ),
            ),
        inputFormatters: widget.inputFormatters,
        onSaved: (value) => widget.onSaved,
        obscureText: widget.obscureText ?? false,
        initialValue: widget.initialValue,
        maxLength: widget.maxLength,
        readOnly: widget.readOnly ?? false,
        keyboardType: widget.keyboardType,
      ),
    );
  }

  // void _setCursorToEnd() {
  //   final textLength = widget.controller?.text.length ?? 0;
  //   widget.controller?.selection = TextSelection.fromPosition(
  //     TextPosition(offset: textLength),
  //   );
  // }
}
