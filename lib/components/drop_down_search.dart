import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class SimpleDropdownSearch extends StatefulWidget {
  final List<dynamic>? list;
  final List<String> hintString;
  final ValueChanged<dynamic> onChanged;
  final bool enabled;
  final Future<List<dynamic>> Function(String)? onSearch;

  const SimpleDropdownSearch(
      {super.key,
      this.list,
      required this.onChanged,
      required this.enabled,
      required this.hintString,
      this.onSearch});

  @override
  State createState() => _SimpleDropdownSearchState();
}

class _SimpleDropdownSearchState extends State<SimpleDropdownSearch> {
  List<String> items = [];
  @override
  void initState() {
    // for (int i = 0; i < widget.list.length; i++) {
    //   items.add(widget.list[i].toString());
    // }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 0.2;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width > 800
              ? MediaQuery.of(context).size.width * .2
              : MediaQuery.of(context).size.width * .4, // height: 100,
          child: DropdownSearch<dynamic>.multiSelection(
              enabled: widget.enabled,
              // mode: Mode.MENU,
              // selectedItems: false,
              // showClearButton: false,
              // items: items,
              asyncItems: widget.onSearch,
              // showSearchBox: true,
              // filterFn: ,
              popupProps: PopupPropsMultiSelection.menu(
                showSearchBox: true,
                isFilterOnline: true,
                constraints: BoxConstraints.tightFor(height: height),
              ),
              selectedItems:
                  widget.enabled == false ? ["0"] : widget.hintString,
              // searchFieldProps: const TextFieldProps(
              //   decoration: InputDecoration(
              //       // suffixIcon: IconButton(
              //       //   icon: const Icon(Icons.clear),
              //       //   onPressed: () {
              //       //     //   _userEditTextController.clear();
              //       //   },
              //       // ),
              //       ),
              // ),
              onChanged: widget.onChanged),
        ),
      ],
    );
  }
}
