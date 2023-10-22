import 'package:bi_replicate/components/search_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../controller/settings/setup/setup_screen_controller.dart';
import '../utils/constants/styles.dart';

class ExpensesAccountDropDown extends StatefulWidget {
  List<String> accountsName;
  Function(String, int) addAccount;
  int? type;
  ExpensesAccountDropDown(
      {Key? key,
      required this.accountsName,
      required this.addAccount,
      this.type})
      : super(key: key);

  @override
  State<ExpensesAccountDropDown> createState() =>
      _ExpensesAccountDropDownState();
}

class _ExpensesAccountDropDownState extends State<ExpensesAccountDropDown> {
  // var utils = Components();
  late AppLocalizations _locale;
  List<String> periods = [];
  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context);
    periods = [
      _locale.daily,
      _locale.weekly,
      _locale.monthly,
      _locale.yearly,
    ];
    super.didChangeDependencies();
  }

  var selectedPeriod = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width < 800
          ? MediaQuery.of(context).size.width * 0.9
          : MediaQuery.of(context).size.width * 0.35,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(5.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _locale.addAccount,
                    style: twelve400TextStyle(Colors.black),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomSearchDropDown(
                    hint: _locale.select,
                    width: MediaQuery.of(context).size.width > 800
                        ? MediaQuery.of(context).size.width * .05
                        : MediaQuery.of(context).size.width * .5,
                    onSearch: (text) {
                      return SetupController()
                          .getAccountSearch({"nameCode": text});
                    },
                    onChanged: (value) {
                      setState(() {
                        selectedPeriod = value.toString();
                        widget.addAccount(selectedPeriod, widget.type!);
                        // getCategory1List();
                      });
                    },
                    value: selectedPeriod.isNotEmpty ? selectedPeriod : null,
                  )
                  // CustomDropDown(
                  //   containerWidth:
                  //       MediaQuery.of(context).size.width * 0.22, // edited
                  //   items: widget.accountsName,
                  //   hint: _locale.select,
                  //   value: selectedPeriod.isNotEmpty ? selectedPeriod : null,
                  //   onChanged: (value) {
                  //     setState(() {
                  //       selectedPeriod = value!;
                  //     });
                  //   },
                  // ),
                ],
              ),
              const SizedBox(
                width: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
