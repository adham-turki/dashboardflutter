import 'package:bi_replicate/components/table_component.dart';
import 'package:bi_replicate/controller/settings/user_settings/user_setting_controller.dart';
import 'package:bi_replicate/model/settings/user_settings/user_settings_model.dart';
import 'package:bi_replicate/screen/dashboard_content/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../dialogs/confirm_dialog.dart';
import '../../../../utils/constants/responsive.dart';

class UsersContent extends StatefulWidget {
  const UsersContent({super.key});

  @override
  State<UsersContent> createState() => _UsersContentState();
}

class _UsersContentState extends State<UsersContent> {
  List<UsersModel> tempList = [];
  List<UsersModel> usersList = [];
  UsersModel? userModel;

  @override
  void initState() {
    getAllUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: Responsive.isDesktop(context) ? width * 0.6 : width * 0.9,
          height: height * 0.6,
          child: TableComponent(
            key: UniqueKey(),
            plCols:
                UsersModel.getColumns(context, AppLocalizations.of(context)),
            polRows: getRows(),
            footerBuilder: (PlutoGridStateManager stateManager) {
              return tableFooter();
            },
            onSelected: (event) {
              PlutoRow row = event.row!;
              userModel = UsersModel.fromJson(row.toJson());
            },
          ),
        )
      ],
    );
  }

  List<PlutoRow> getRows() {
    List<UsersModel> accountList = tempList;

    List<PlutoRow> topList = [];

    for (int i = 0; i < accountList.length; i++) {
      topList.add(accountList[i].toPluto(i + 1));
    }

    return topList;
  }

  void deleteMethod() {
    UsersModel usersModel = userModel ?? tempList[0];
    showDialog(
        context: context,
        builder: (context) {
          return CustomConfirmDialog(
            confirmMessage: AppLocalizations.of(context).areYouSure,
          );
        }).then((value) {
      if (value) {
        UsersController().deleteUserSetting(usersModel).then((value1) {
          if (!value1) {
            setState(() {});
          }
        }).then((value) {});
      }
    });
  }

  Widget tableFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
            onPressed: () {
              // deleteMethod();
            },
            icon: const Icon(Icons.add)),
        IconButton(
            onPressed: () {
              // deleteMethod();
            },
            icon: const Icon(Icons.edit)),
        IconButton(
            onPressed: () {
              deleteMethod();
            },
            icon: const Icon(Icons.delete)),
      ],
    );
  }

  getAllUsers() {
    UsersController().getUsersSettings().then((value) {
      for (var elemant in value) {
        usersList.add(elemant);
      }
      print("length: ${usersList.length}");
      tempList = usersList;
      setState(() {});
    });
  }
}
