import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../../components/key.dart';
import '../../utils/constants/colors.dart';

// ignore: must_be_immutable
class DropDown extends StatefulWidget {
  double? width;
  double? padding;
  String? bordeText;
  double? height;
  Key? customKey;
  final List<dynamic>? items;
  final ValueChanged<dynamic> onChanged;
  final dynamic initialValue;
  final Function(String)? onValidator;
  final Future<bool?> Function(dynamic)? onBeforeOpening;
  double? heightVal;
  bool? searchBox;
  bool? valSelected;
  dynamic object;
  Color? color;
  String? selectedVal;
  Widget? suffixIcon;
  final Function()? onClearIconPressed;
  final Function()? onPressed;
  Icon? icon;
  final Future<List<dynamic>> Function(String)? onSearch;
  final bool? showBorder;
  bool? isEnabled;
  bool? isMandatory;
  final bool? showClearIcon;

  DropDown(
      {Key? key,
      this.onClearIconPressed,
      this.width,
      this.height,
      this.initialValue,
      this.valSelected,
      this.showClearIcon,
      this.onValidator,
      this.items,
      this.padding,
      this.searchBox,
      this.heightVal,
      this.bordeText,
      this.isMandatory = false,
      this.customKey,
      this.isEnabled,
      required this.onChanged,
      this.object,
      this.selectedVal,
      this.suffixIcon,
      this.onPressed,
      this.onSearch,
      this.icon,
      this.onBeforeOpening,
      this.showBorder,
      this.color})
      : super(key: key);
  @override
  State<DropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<DropDown> {
  FocusNode focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    double width = widget.width ?? MediaQuery.of(context).size.width * 0.15;
    double height = MediaQuery.of(context).size.height * 0.3;
    ClearButtonProps clearButtonProps = ClearButtonProps(
      alignment: Alignment.topCenter,
      isVisible: widget.showClearIcon == true && (widget.valSelected ?? false),
      icon: IconButton(
        iconSize: 18,
        padding: const EdgeInsets.only(bottom: 2, top: 2),
        color: const Color.fromARGB(235, 158, 158, 158),
        onPressed: () {
          if (widget.onClearIconPressed != null) {
            widget.onClearIconPressed!();
          }
          setState(() {});
        },
        icon: const Icon(Icons.close),
      ),
    );
    return Column(
      children: [
        Container(
          color: Colors.white,
          width: widget.width,
          height: widget.height,
          child: DropdownSearch<dynamic>(
            // clearButtonProps: ClearButtonProps(
            //     alignment: Alignment.topCenter,
            //     isVisible: widget.valSelected ?? false,
            //     icon: IconButton(
            //       iconSize: 18,
            //       padding: const EdgeInsets.only(bottom: 2, top: 2),
            //       color: Color.fromARGB(235, 158, 158, 158),
            //       onPressed: () {
            //         // items = [];
            //         if (widget.onClearIconPressed != null) {
            //           widget.onClearIconPressed!();
            //         }
            //         setState(() {});
            //       },
            //       icon: const Icon(Icons.close),
            //     )),
            clearButtonProps: widget.showClearIcon == true
                ? clearButtonProps
                : ClearButtonProps(isVisible: false),
            enabled: widget.isEnabled ?? true,
            validator: (value) =>
                widget.onValidator == null ? null : widget.onValidator!(value),
            items: widget.items ?? [],
            asyncItems: widget.onSearch,
            dropdownButtonProps: widget.icon != null
                ? DropdownButtonProps(
                    padding: const EdgeInsets.only(bottom: 5, top: 3),
                    icon: widget.icon!,
                    onPressed: widget.onPressed ?? () {})
                : const DropdownButtonProps(),
            dropdownDecoratorProps:
                widget.icon != null && widget.valSelected == null
                    ? const DropDownDecoratorProps()
                    : DropDownDecoratorProps(
                        dropdownSearchDecoration: widget.valSelected == false
                            ? InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 68, 67, 67),
                                    width: 0.5,
                                  ),
                                  borderRadius: BorderRadius.circular(1.0),
                                ))
                            : InputDecoration(
                                contentPadding: const EdgeInsets.all(10),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 68, 67, 67),
                                    width: 0.5,
                                  ),
                                  borderRadius: BorderRadius.circular(1.0),
                                ),
                                labelText: widget.bordeText,
                                labelStyle: const TextStyle(
                                  fontSize: 12.0,
                                  color: Color.fromARGB(235, 158, 158, 158),
                                ),
                                alignLabelWithHint: true,
                              ),
                      ),
            dropdownBuilder: _customDropDownPrograms,
            popupProps: PopupProps.menu(
              searchDelay: const Duration(milliseconds: 1),
              showSearchBox: widget.searchBox ?? true,
              isFilterOnline: widget.onSearch != null ? true : false,
              searchFieldProps: TextFieldProps(
                  autofocus: true,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(borderSide: BorderSide()),
                    constraints: BoxConstraints.tightFor(height: height * .18),
                  )),
              constraints:
                  BoxConstraints.tightFor(height: widget.heightVal ?? height),
              itemBuilder: (context, item, isSelected) {
                return ListTile(
                  title: Text(
                    item.toString(),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11, // Set your desired font size here
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                  // Add any other customization for the ListTile here
                );
              },
            ),
            onBeforePopupOpening: widget.onBeforeOpening,
            onChanged: (value) {
              widget.onChanged(value);
              // : widget.onChanged!(value.name);
            },
            selectedItem: widget.initialValue,
          ),
        ),
      ],
    );
  }

  Widget _customDropDownPrograms(BuildContext context, dynamic item) {
    final context = navigatorKey.currentState!.overlay!.context;
    double height = MediaQuery.of(context).size.height;
    double width = widget.width ?? MediaQuery.of(context).size.width * 0.15;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        widget.selectedVal != null
            ? Tooltip(
                message: widget.selectedVal,
                child: Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: SizedBox(
                    width: width * .6,
                    child: Text(
                      widget.selectedVal!,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: height * .018, color: Colors.black),
                    ),
                  ),
                ),
              )
            : item != null
                ? Tooltip(
                    message: item.toString(),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 1.0),
                      child: SizedBox(
                        width: width * .5,
                        child: Text(
                          item.toString(),
                          // textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: height * .018, color: Colors.black),
                        ),
                      ),
                    ),
                  )
                : widget.isMandatory! == false
                    ? Padding(
                        padding: const EdgeInsets.only(right: 1.0),
                        child: Tooltip(
                          message: widget.bordeText!,
                          child: SizedBox(
                            width: width * .6,
                            child: Text(
                              widget.bordeText!,
                              // textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: height * .018,
                                  color:
                                      const Color.fromARGB(235, 158, 158, 158)),
                            ),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(right: 1.0),
                        child: SizedBox(
                          width: width * .6,
                          child: Tooltip(
                            message: widget.bordeText!,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(widget.bordeText!,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: height * .018,
                                        color: Color.fromARGB(
                                            235, 158, 158, 158))),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 3),
                                ),
                                const Text('*',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(235, 199, 52, 52))),
                              ],
                            ),
                          ),
                        ),
                      ),
        widget.icon != null
            ? const Padding(
                padding: EdgeInsets.only(bottom: 8.0, top: 2),
                child: Icon(
                  Icons.arrow_drop_down,
                  color: Color.fromARGB(235, 158, 158, 158),
                ),
              )
            : SizedBox.shrink()
        // IconButton(
        //   padding: const EdgeInsets.only(bottom: 2, top: 2),
        //   icon: const Icon(Icons.close),
        //   onPressed: (() {
        //     if (widget.onClearIconPressed != null) {
        //       print("innCLEEEEEEEAR");
        //       print("innCLEEEEEEEAR");
        //       widget.onChanged(null);
        //       widget.selectedVal = null;
        //       widget.valSelected = false;
        //       if (widget.selectedVal != null) {}
        //       widget.onSearch!("");
        //       widget.onClearIconPressed!();
        //       setState(() {});
        //     }
        //     // setState(() {});
        //   }),
        //   color: const Color.fromARGB(235, 158, 158, 158),
        // )
      ],
    );
  }
}
