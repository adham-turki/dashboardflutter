import 'package:bi_replicate/controller/settings/setup/setup_screen_controller.dart';
import 'package:bi_replicate/utils/constants/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../../widget/custom_btn.dart';
import '../../../../../widget/drop_down/custom_dropdown.dart';

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
  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context);

    super.didChangeDependencies();
  }

  var selectedAccount = "";
  double width = 0;
  double height = 0;
  bool isDesktop = false;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    isDesktop = Responsive.isDesktop(context);

    return Container(
      width: isDesktop ? width * 0.35 : width * 0.9,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(5.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomDropDown(
            hint: _locale.select,
            label: _locale.addAccount,
            showSearchBox: true,
            width: isDesktop ? width * .17 : width * .38,
            onSearch: (text) {
              return SetupController().getAccountSearch({"nameCode": text});
            },
            onChanged: (value) {
              setState(() {
                selectedAccount = value.toString();
                // getCategory1List();
              });
            },
            initialValue: selectedAccount.isNotEmpty ? selectedAccount : null,
          ),
          SizedBox(
            width: width * .01,
          ),
          Column(
            children: [
              SizedBox(
                height: height * .06,
              ),
              CustomButton(
                text: _locale.add,
                textColor: Colors.white,
                borderRadius: 5.0,
                onPressed: () {
                  setState(() {
                    widget.addAccount(selectedAccount, widget.type!);
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
