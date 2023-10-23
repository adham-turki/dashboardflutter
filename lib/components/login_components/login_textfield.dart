import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LoginTextField extends StatefulWidget {
  String? label;
  double? padding;
  double? width;
  TextEditingController? controller;
  String? initialValue;
  Function(String value)? onSubmitted;
  Function(String)? onValidator;
  Key? customKey;
  bool? readOnly;
  Function(String value)? onChanged;
  String? hint;
  LoginTextField({
    Key? key,
    this.onValidator,
    this.controller,
    this.label,
    this.initialValue,
    this.padding,
    this.onSubmitted,
    this.customKey,
    this.width,
    this.readOnly,
    this.onChanged,
    this.hint,
  }) : super(key: key);

  @override
  State<LoginTextField> createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<LoginTextField> {
  TextEditingController? _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = widget.controller ?? TextEditingController();
    // Set the initial value if it's provided.
    if (widget.initialValue != null) {
      _textEditingController!.text = widget.initialValue!;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = widget.width ?? MediaQuery.of(context).size.width;
    String label = widget.label ?? "";
    double padding = widget.padding ?? 0.0;
    bool readOnly = widget.readOnly ?? false;
    String hint = widget.hint ?? "";
    Function(String value)? onSubmitted = widget.onSubmitted;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: padding, horizontal: 10),
      child: Column(
        children: [
          // CustomLabel(
          //   label: label,
          //   width: width * 0.2,
          // ),
          Container(
            width: width * 0.18,
            // decoration: BoxDecoration(
            //   color: Colors.white,
            //   borderRadius: BorderRadius.circular(7.0),
            //   border: Border.all(color: Colors.grey), // Border color
            //   boxShadow: const [
            //     BoxShadow(
            //       spreadRadius: 1,
            //       blurRadius: 10,
            //     ),
            //   ],
            // ),
            child: TextFormField(
              style: TextStyle(color: Colors.white),
              controller: _textEditingController,
              readOnly: readOnly,
              validator: (text) => widget.onValidator == null
                  ? null
                  : widget.onValidator!(text!),
              onFieldSubmitted: onSubmitted,

              decoration: InputDecoration(
                fillColor: Colors.white,
                hintText: hint,
                hintStyle: TextStyle(
                  color: Colors.white,
                ),
                // labelText: label,
                // labelStyle: TextStyle(
                //     color: Colors.black.withOpacity(0.5),
                //     fontWeight: FontWeight.bold),
                // label: Text(
                //   hint == '' || hint == null ? "" : hint,
                //   style: TextStyle(
                //     fontSize: MediaQuery.of(context).size.height * 0.017,
                //     color: const Color.fromARGB(255, 69, 67, 67),
                //   ),
                // ),
                floatingLabelAlignment: FloatingLabelAlignment.start,
                // border: const UnderlineInputBorder(
                //   borderSide: BorderSide(color: Colors.white),
                // ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                border: const UnderlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(7.0),
                    ),
                    borderSide:
                        BorderSide(color: Color.fromARGB(223, 255, 255, 255))),
              ),

              // decoration: InputDecoration(
              //   contentPadding:
              //       EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              //   border: InputBorder.none, // Remove the default underline
              // ),
              onChanged: (value) {
                if (widget.onChanged != null) {
                  widget.onChanged!(value);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _textEditingController!.dispose();
    }
    super.dispose();
  }
}
