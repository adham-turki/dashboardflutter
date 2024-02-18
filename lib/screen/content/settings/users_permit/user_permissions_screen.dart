import 'package:bi_replicate/controller/settings/user_settings/user_setting_controller.dart';
import 'package:bi_replicate/model/settings/user_permissions/user_permissions_model.dart';
import 'package:bi_replicate/model/settings/user_permissions/user_permit_criteria_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../../../components/check_box.dart';
import '../../../../components/table_component.dart';
import '../../../../controller/settings/user_permissions/user_permissions_controller.dart';
import '../../../../dialogs/confirm_dialog.dart';
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
  List<UserPermitModel> userPermitsList = [];
  List<PlutoRow> topList = [];
  UserPermitModel? userPermitModel;
  TextEditingController arabicNameController = TextEditingController();
  TextEditingController englishNameController = TextEditingController();
  int allowedValue = 0;
  bool isChecked = false;
  List<UsersModel> searchResults = [];
  @override
  void initState() {
    getAllUsers();
    super.initState();
  }

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
            selectedFromUsers = value.toString();
            selectedFromUsersCode = value.codeToString();
            fetchData();
          },
          initialValue: selectedFromUsers.isNotEmpty ? selectedFromUsers : null,
        ),
        SizedBox(
          height: height * 0.02,
        ),
        SizedBox(
          width: Responsive.isDesktop(context) ? width * 0.7 : width * 0.9,
          height: Responsive.isDesktop(context) ? height * 0.7 : height * 0.7,
          child: TableComponent(
            key: UniqueKey(),
            plCols: UserPermitModel.getColumns(
                context, AppLocalizations.of(context)!),
            polRows: getRows(),
            footerBuilder: (PlutoGridStateManager stateManager) {
              return tableFooter();
            },
            onSelected: (event) {
              PlutoRow row = event.row!;
              UserPermitModel userPermitModel2 =
                  UserPermitModel.fromJson2(row.toJson(), _locale);

              for (var i = 0; i < userPermitsList.length; i++) {
                if (userPermitsList[i].reportNamee ==
                    userPermitModel2.reportNamee) {
                  userPermitModel = userPermitsList[i];
                }
              }
            },
          ),
        )
      ],
    );
  }

  void fetchData() {
    UserPermissionsController()
        .getPermitReportsByCode(selectedFromUsersCode)
        .then((value) {
      setState(() {
        userPermitsList = value;
        topList = getRows();
      });
    });
  }

  List<PlutoRow> getRows() {
    List<UserPermitModel> accountList = userPermitsList;

    List<PlutoRow> topList = [];

    for (int i = 0; i < accountList.length; i++) {
      topList.add(accountList[i].toPluto(i + 1, _locale));
    }

    return topList;
  }

  Future<List<UsersModel>> onSearch(String query) async {
    List<UsersModel> searchResults = [];

    // Replace the following logic with your actual data fetching or search logic
    await Future.delayed(const Duration(seconds: 1)); // Simulating a delay

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

  Widget tableFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
            onPressed: () async {
              // showDialog(
              //   barrierDismissible: false,
              //   context: context,
              //   builder: (context) {
              //     return addDialog();
              //   },
              // );
            },
            icon: const Icon(Icons.add)),
        IconButton(
            onPressed: () {
              UserPermitModel permitModel =
                  userPermitModel ?? userPermitsList[0];
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return editDialog(permitModel);
                },
              );
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

  editDialog(UserPermitModel userPermitModel) {
    allowedValue = userPermitModel.bolAllowed;
    arabicNameController.text = userPermitModel.reportNamea ?? "";
    // passwordController.text = usersModel.password ?? "";
    englishNameController.text = userPermitModel.reportNamee ?? "";
    return AlertDialog(
      title: Text(_locale.editUser),
      content: SizedBox(
        width: width * 0.2,
        height: height * 0.25,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: arabicNameController,
              decoration: InputDecoration(labelText: _locale.reportNamea),
              readOnly: true,
            ),
            TextField(
              controller: englishNameController,
              decoration: InputDecoration(labelText: _locale.reportNamee),
              readOnly: true,
            ),
            PermitCheckbox(
              hint: _locale.allowed,
              allowedValue: allowedValue,
              onChanged: (newValue) {
                setState(() {
                  allowedValue = newValue;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(_locale.cancel),
        ),
        TextButton(
          onPressed: () async {
            UserPermitModel userPermitModell =
                userPermitModel ?? userPermitsList[0];
            UserPermitCriteria userPermitCriteria = UserPermitCriteria(
                txtKey: userPermitModell.key,
                txtUserCode: selectedFromUsersCode,
                txtReportCode: userPermitModell.reportCode,
                bolAllowed: allowedValue);
            UserPermissionsController()
                .editUserPermit(userPermitCriteria)
                .then((value) {
              if (value.statusCode == 200) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return showSuccessDialog(_locale.editedSuccess);
                  },
                ).then((value) {
                  Navigator.pop(context);
                });
                // ErrorController.openErrorDialog(200, _locale.addedSuccess);
                fetchData();
              }
            });
          },
          child: Text(_locale.edit),
        ),
      ],
    );
  }

  void deleteMethod() {
    UserPermitModel userPermitModell = userPermitModel ?? userPermitsList[0];
    UserPermitCriteria userPermitCriteria = UserPermitCriteria(
        txtKey: userPermitModell.key,
        txtUserCode: selectedFromUsersCode,
        txtReportCode: userPermitModell.reportCode,
        bolAllowed: userPermitModell.bolAllowed);
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return CustomConfirmDialog(
            confirmMessage: AppLocalizations.of(context)!.areYouSure,
          );
        }).then((value) {
      if (value) {
        UserPermissionsController()
            .deleteUserPermit(userPermitCriteria)
            .then((value1) {
          if (value1.statusCode == 200) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return showSuccessDialog(_locale.deletedSuccesfully);
              },
            ).then((value) {});
            fetchData();
          }
          // setState(() {});
        }).then((value) {});
      }
    });
  }

  showSuccessDialog(String message) {
    return AlertDialog(
      title: const Text(""),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(_locale.ok),
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
