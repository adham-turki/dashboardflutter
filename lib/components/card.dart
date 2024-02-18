import 'package:bi_replicate/widget/drop_down/custom_dropdown.dart';
import 'package:bi_replicate/widget/drop_down/multi_selection_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../utils/constants/responsive.dart';
import '../utils/constants/styles.dart';

class CardComponent extends StatefulWidget {
  final CustomDropDown fromDropDown;
  final CustomDropDown toDropDown;
  final SimpleDropdownSearch multipleSearch;
  final String title;
  final bool multipleVal;
  final Checkbox multipleCheckBox;
  final Checkbox selectAll;

  const CardComponent(
      {super.key,
      required this.fromDropDown,
      required this.title,
      required this.multipleVal,
      required this.multipleCheckBox,
      required this.selectAll,
      required this.toDropDown,
      required this.multipleSearch});

  @override
  State<CardComponent> createState() => _CardComponentState();
}

class _CardComponentState extends State<CardComponent> {
  late AppLocalizations _locale;
  double width = 0;
  double height = 0;
  bool isDesktop = false;
  // bool isMobile = false;
  bool isMobile = false;
  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context)!;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    isDesktop = Responsive.isDesktop(context);
    // isMobile = Responsive.isMobile(context);
    isMobile = Responsive.isMobile(context);
    return Container(
      width: isDesktop ? width * 0.6 / 2 : width * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(
          color: Colors.grey,
        ),
      ),
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.title,
                style: fourteen500TextStyle(Colors.black),
              ),
            ],
          ),
          widget.multipleVal == false
              ? Row(
                  children: [widget.fromDropDown],
                )
              : Container(),
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              widget.multipleVal == false
                  ? widget.toDropDown
                  : Padding(
                      padding:
                          const EdgeInsets.only(top: 20.0, right: 8, bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              widget.selectAll,
                              SelectableText(
                                maxLines: 1,
                                _locale.selectAll,
                                style: twelve400TextStyle(Colors.black),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * .01,
                          ),
                          widget.multipleSearch,
                        ],
                      ),
                    ),
              SizedBox(
                width: isDesktop ? width * .06 : width * .01,
              ),
              Column(
                children: [
                  SizedBox(
                    height: height * .08,
                  ),
                  Row(
                    children: [
                      widget.multipleCheckBox,
                      SelectableText(
                        maxLines: 1,
                        _locale.multiple,
                        style: twelve400TextStyle(Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
