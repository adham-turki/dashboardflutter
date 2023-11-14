import 'package:bi_replicate/controller/settings/user_settings/user_setting_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../../../components/table_component.dart';
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

  List<UsersModel> searchResults = [];
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
          // items: usersList,
          showSearchBox: true,
          hint:
              selectedFromUsers.isNotEmpty ? selectedFromUsers : _locale.select,
          label: _locale.users,
          width: isDesktop ? width * .14 : width * .35,
          height: isDesktop ? height * 0.4 : height * 0.35,
          onSearch: (text) {
            return onSearch(text);
          },
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
        SizedBox(
          width: Responsive.isDesktop(context) ? width * 0.4 : width * 0.9,
          height: Responsive.isDesktop(context) ? height * 0.7 : height * 0.7,
          child: TableComponent(
            key: UniqueKey(),
            plCols:
                UsersModel.getColumns(context, AppLocalizations.of(context)),
            polRows: [],
            // footerBuilder: (PlutoGridStateManager stateManager) {
            //   return tableFooter();
            // },
            onSelected: (event) {
              PlutoRow row = event.row!;
              // userModel = UsersModel.fromJson(row.toJson());
              // for (var i = 0; i < tempList.length; i++) {
              //   if (tempList[i].username == userModel!.username) {
              //     userModel = tempList[i];
              //   }
              // }
            },
          ),
        )
      ],
    );
  }

  Future<List<UsersModel>> onSearch(String query) async {
    List<UsersModel> searchResults = [];

    // Replace the following logic with your actual data fetching or search logic
    await Future.delayed(Duration(seconds: 1)); // Simulating a delay

    searchResults = usersList
        .where(
            (user) => user.username.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return searchResults;
  }

  void searchUsers(String query) {
    setState(() {
      searchResults = usersList
          .where((user) =>
              user.username.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  getAllUsers() {
    UsersController().getUsersSettings().then((value) {
      setState(() {
        usersList = value;
      });
    });
  }
}
