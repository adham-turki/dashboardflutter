import 'package:flutter/material.dart';

// Assume _locale is an instance of AppLocalizations

class PermitCheckbox extends StatefulWidget {
  final int allowedValue;
  final Function(int) onChanged;
  final String hint;

  const PermitCheckbox(
      {Key? key,
      required this.allowedValue,
      required this.onChanged,
      required this.hint})
      : super(key: key);

  @override
  _PermitCheckboxState createState() => _PermitCheckboxState();
}

class _PermitCheckboxState extends State<PermitCheckbox> {
  late bool isChecked;

  @override
  void initState() {
    super.initState();
    isChecked = widget.allowedValue == 1;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(widget.hint),
        Checkbox(
          value: isChecked,
          onChanged: (newValue) {
            setState(() {
              isChecked = newValue!;
              int newAllowedValue = isChecked ? 1 : 0;
              widget.onChanged(newAllowedValue);
            });
          },
        ),
      ],
    );
  }
}
