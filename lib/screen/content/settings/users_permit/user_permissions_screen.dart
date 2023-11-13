import 'package:bi_replicate/controller/settings/user_settings/user_setting_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../model/settings/user_settings/user_settings_model.dart';
import '../../../../utils/constants/responsive.dart';
import '../../../../widget/drop_down/custom_dropdown.dart';

class UserPermissionsScreen extends StatefulWidget {
  const UserPermissionsScreen({super.key});

  @override
  State<UserPermissionsScreen> createState() => _UserPermissionsScreenState();
}

class _UserPermissionsScreenState extends State<UserPermissionsScreen> {
  late AppLocalizations _locale;
  String selectedFromUsers = "";
  String selectedFromUsersCode = "";
  double width = 0;
  bool isDesktop = false;
  double height = 0;
  List<UsersModel> usersList = [];

  @override
  void initState() {
    getAllUsers();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    isDesktop = Responsive.isDesktop(context);
    return Column(
      children: [
        CustomDropDown(
          items: usersList,
          showSearchBox: true,
          hint:
              selectedFromUsers.isNotEmpty ? selectedFromUsers : _locale.select,
          label: _locale.users,
          width: isDesktop ? width * .14 : width * .35,
          height: isDesktop ? height * 0.4 : height * 0.35,
          // onSearch: (text) {
          //   DropDownSearchCriteria dropDownSearchCriteria =
          //       getSearchCriteria(text);

          //   return salesReportController
          //       .getSalesStkCountCateg1Method(dropDownSearchCriteria.toJson());
          // },
          onChanged: (value) {
            setState(() {
              selectedFromUsers = value.toString();
              selectedFromUsersCode = value.codeToString();
              print(selectedFromUsers);
              print(selectedFromUsersCode);
              // getCategory1List();
            });
          },
          initialValue: selectedFromUsers.isNotEmpty ? selectedFromUsers : null,
        ),
      ],
    );
  }

  getAllUsers() {
    UsersController().getUsersSettings().then((value) {
      setState(() {
        usersList = value;
      });
    });
  }
}
