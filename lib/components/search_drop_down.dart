import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomSearchDropDown extends StatefulWidget {
  double? width;
  String hint;
  String? value;
  final ValueChanged<dynamic> onChanged;
  final Future<List<dynamic>> Function(String)? onSearch;

  CustomSearchDropDown(
      {Key? key,
      this.value,
      required this.onChanged,
      required this.hint,
      this.width,
      this.onSearch})
      : super(key: key);
  @override
  State<CustomSearchDropDown> createState() => _CustomSearchDropDownState();
}

class _CustomSearchDropDownState extends State<CustomSearchDropDown> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width > 800
        ? MediaQuery.of(context).size.width * .2
        : MediaQuery.of(context).size.width * .35;

    double height = MediaQuery.of(context).size.width > 800
        ? MediaQuery.of(context).size.height * .05
        : MediaQuery.of(context).size.height * .05;

    // double padding = widget.padding ?? 8.0;
    return Column(
      children: [
        Container(
          color: Colors.white,
          width: width,
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: DropdownSearch<dynamic>(
            asyncItems: widget.onSearch,
            selectedItem: widget.value,
            onChanged: (dynamic newValue) {
              widget.onChanged(newValue);
              widget.value = newValue;
            },
            dropdownBuilder: _customDropDownPrograms,
            popupProps: PopupProps.menu(
              menuProps: const MenuProps(
                animationDuration: Duration(milliseconds: 100),
              ),
              showSearchBox: true,
              isFilterOnline: true,
              constraints: BoxConstraints.tightFor(
                  height: MediaQuery.of(context).size.height * .2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _customDropDownPrograms(BuildContext context, dynamic? item) {
    return Container(
        child: (item == null)
            ? ListTile(
                //    contentPadding: EdgeInsets.only(right: 20, left: 50),
                title: Text(widget.hint,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                        fontSize: 13,
                        color: Color.fromARGB(235, 158, 158, 158))),
              )
            : ListTile(
                //contentPadding: const EdgeInsets.only(right: 230, left: 20),
                title: Text(
                item.toString(),
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13.5, color: Colors.black),
              )));
  }
}
