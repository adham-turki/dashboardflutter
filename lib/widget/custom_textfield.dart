import 'package:flutter/material.dart';

import '../utils/constants/responsive.dart';
import 'custom_label.dart';

// ignore: must_be_immutable
class CustomTextField extends StatefulWidget {
  String label;
  double? padding;
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
  CustomTextField(
      {Key? key,
      this.onValidator,
      this.controller,
      required this.label,
      this.initialValue,
      this.padding,
      this.onSubmitted,
      this.customKey,
      this.width,
      this.readOnly,
      this.autoFocus,
      this.onChanged,
      this.focusNode})
      : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
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

  bool isDesktop = false;
  bool isMobile = false;

  @override
  Widget build(BuildContext context) {
    double width = widget.width ?? MediaQuery.of(context).size.width;
    String label = widget.label;
    double padding = widget.padding ?? 0.0;
    bool readOnly = widget.readOnly ?? false;
    isDesktop = Responsive.isDesktop(context);
    isMobile = Responsive.isMobile(context);
    Function(String value)? onSubmitted = widget.onSubmitted;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: padding, horizontal: 10),
      child: Column(
        children: [
          CustomLabel(
            label: label,
            width: width * 0.2,
          ),
          SizedBox(
            width: isDesktop ? width * 0.2 : width * 0.7,
            // decoration: BoxDecoration(
            //   color: Colors.white,
            //   borderRadius: BorderRadius.circular(5.0),
            //   border: Border.all(color: Colors.grey), // Border color
            // ),
            child: TextFormField(
              focusNode: widget.focusNode,

              controller: _textEditingController,
              readOnly: readOnly,
              validator: (text) => widget.onValidator == null
                  ? null
                  : widget.onValidator!(text!),
              onFieldSubmitted: onSubmitted,

              decoration: const InputDecoration(
                // label: Text(
                //   hint == '' || hint == null ? "" : hint,
                //   style: TextStyle(
                //     fontSize: MediaQuery.of(context).size.height * 0.017,
                //     color: const Color.fromARGB(255, 69, 67, 67),
                //   ),
                // ),
                floatingLabelAlignment: FloatingLabelAlignment.start,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(7.0),
                    ),
                    borderSide:
                        BorderSide(color: Color.fromARGB(224, 225, 220, 220))),
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
