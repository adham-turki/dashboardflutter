import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../../utils/constants/responsive.dart';
import '../custom_label.dart';

// ignore: must_be_immutable
class CustomDropDown extends StatefulWidget {
  final String label;
  final double? width;
  final double? padding;
  final Key? customKey;
  final List<dynamic>? items;
  final Function(dynamic value)? onChanged;
  final dynamic initialValue;
  final Function(dynamic)? onValidator;
  final bool? showSearchBox;
  final double? height;
  final String? hint;
  final Future<List<dynamic>> Function(String)? onSearch;

  CustomDropDown({
    Key? key,
    this.width,
    this.initialValue,
    this.onValidator,
    this.items,
    this.padding,
    this.customKey,
    required this.label,
    this.hint,
    this.onChanged,
    this.showSearchBox,
    this.height,
    this.onSearch,
  }) : super(key: key);

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  @override
  Widget build(BuildContext context) {
    double width = widget.width ?? MediaQuery.of(context).size.width * 0.15;
    Key? customKey = widget.customKey;
    double height = widget.height ?? MediaQuery.of(context).size.height * 0.15;

    ///  double padding = widget.padding ?? 8.0;
    String label = widget.label;
    bool showSearchBox = widget.showSearchBox ?? false;
    return Padding(
      key: customKey,
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          label.isNotEmpty
              ? CustomLabel(
                  label: label,
                  width: width,
                )
              : Container(),
          Container(
            color: Colors.white,
            width: width,
            child: DropdownSearch<dynamic>(
              validator: (value) => widget.onValidator == null
                  ? null
                  : widget.onValidator!(value),
              items: widget.items ?? [],
              asyncItems: widget.onSearch,
              dropdownBuilder: _customDropDownPrograms,
              popupProps: PopupProps.menu(
                menuProps: const MenuProps(
                  animationDuration: Duration(milliseconds: 100),
                ),
                showSearchBox: showSearchBox,
                isFilterOnline: showSearchBox,
                constraints: BoxConstraints.tightFor(height: height),
              ),
              onChanged: (dynamic value) {
                widget.onChanged!(value);
              },
              selectedItem: widget.initialValue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _customDropDownPrograms(BuildContext context, dynamic item) {
    double height = MediaQuery.of(context).size.height;
    bool isDesktop = Responsive.isDesktop(context);
    return Container(
        child: (item == null)
            ? Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Text(widget.hint!,
                    // textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: height * .021,
                        color: const Color.fromARGB(235, 158, 158, 158))),
              )
            : Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Text(
                  item.toString(),
                  // textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  style:
                      TextStyle(fontSize: height * .021, color: Colors.black),
                ),
              ));
  }
}
