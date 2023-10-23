// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldCustom extends StatefulWidget {
  Text? text;
  ValueChanged<String>? onChanged;
  Function? onSaved;
  TextEditingController? controller;
  Icon? customIcon;
  dynamic customIconSuffix;
  bool? notefield;
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
  bool? showText;
  // dynamic? pre;
  TextFieldCustom(
      {Key? key,
      this.customIcon,
      this.customIconSuffix,
      this.color,
      this.onValidator,
      this.onTap,
      this.onSaved,
      this.keyboardType,
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
      // this.pre,
      this.obscureText})
      : super(key: key);

  @override
  State createState() => _TextFieldCustomState();
}

class _TextFieldCustomState extends State<TextFieldCustom> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .33,
      child: TextFormField(
        controller: widget.controller,
        onChanged:
            // (newValue) {
            widget.onChanged,
        // _setCursorToEnd();
        // },
        validator: (text) =>
            widget.onValidator == null ? null : widget.onValidator!(text!),
        decoration: widget.decoration ??
            InputDecoration(
              // prefix: widget.pre,
              label: Text(
                widget.text!.data!,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width > 800
                      ? MediaQuery.of(context).size.height * 0.0165
                      : MediaQuery.of(context).size.height * 0.014,
                  color:
                      widget.color ?? const Color.fromARGB(255, 114, 119, 123),
                ),
              ),
              labelStyle: TextStyle(
                color: widget.color ?? const Color.fromARGB(255, 114, 119, 123),
              ),
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
                width: MediaQuery.of(context).size.width * 0.007,
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
