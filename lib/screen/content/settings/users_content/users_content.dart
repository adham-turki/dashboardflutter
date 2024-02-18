import 'dart:typed_data';

import 'package:bi_replicate/components/table_component.dart';
import 'package:bi_replicate/controller/error_controller.dart';
import 'package:bi_replicate/controller/settings/user_settings/user_setting_controller.dart';
import 'package:bi_replicate/model/login/users_model.dart';
import 'package:bi_replicate/model/settings/user_settings/user_settings_model.dart';
import 'package:bi_replicate/screen/dashboard_content/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../Encryption/encryption.dart';
import '../../../../dialogs/confirm_dialog.dart';
import '../../../../utils/constants/encrypt_key.dart';
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
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController editUsernameController = TextEditingController();
  TextEditingController editPasswordController = TextEditingController();
  TextEditingController roleController = TextEditingController();
  TextEditingController editRoleController = TextEditingController();
  late AppLocalizations locale;
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    getAllUsers();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    locale = AppLocalizations.of(context)!;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: Responsive.isDesktop(context) ? width * 0.4 : width * 0.9,
          height: Responsive.isDesktop(context) ? height * 0.7 : height * 0.7,
          child: TableComponent(
            key: UniqueKey(),
            plCols:
                UsersModel.getColumns(context, AppLocalizations.of(context)!),
            polRows: getRows(),
            footerBuilder: (PlutoGridStateManager stateManager) {
              return tableFooter();
            },
            onSelected: (event) {
              PlutoRow row = event.row!;
              userModel = UsersModel.fromJson(row.toJson());
              for (var i = 0; i < tempList.length; i++) {
                if (tempList[i].username == userModel!.username) {
                  userModel = tempList[i];
                }
              }
              print("ssssssssssssss: ${userModel!.toJson()}");
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
        barrierDismissible: false,
        builder: (context) {
          return CustomConfirmDialog(
            confirmMessage: AppLocalizations.of(context)!.areYouSure,
          );
        }).then((value) {
      if (value) {
        UsersController().deleteUserSetting(usersModel).then((value1) {
          if (value1.statusCode == 200) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return showSuccessDialog(locale.deletedSuccesfully);
              },
            ).then((value) {});
            getAllUsers();
          }
          // setState(() {});
        }).then((value) {});
      }
    });
  }

  fetch() {
    setState(() {
      getAllUsers();
    });
  }

  addDialog() {
    return AlertDialog(
      title: Text(locale.addUser),
      content: SizedBox(
        width: width * 0.2,
        height: height * 0.3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: "${locale.userName}*"),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "${locale.password}*"),
            ),
            TextField(
              controller: roleController,
              decoration: InputDecoration(labelText: "${locale.role}*"),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(locale.cancel),
        ),
        TextButton(
          onPressed: () async {
            String? token = await storage.read(key: 'jwt');
            String username = "";
            String password = "";
            String role = "";

            if (usernameController.text.isNotEmpty &&
                passwordController.text.isNotEmpty &&
                roleController.text.isNotEmpty) {
              final iv = [0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 0, 1];
              final byteArray = Uint8List.fromList(
                  iv.map((bit) => bit == 1 ? 0x01 : 0x00).toList());
              String passEncrypted = Encryption.performAesEncryption(
                  passwordController.text, keyEncrypt, byteArray);
              username = usernameController.text;
              password = passEncrypted;
              role = roleController.text;

              UsersModel usersModel = UsersModel(
                  code: createUuid(),
                  username: username,
                  password: password,
                  activeToken: token!,
                  role: role);
              print(usersModel.toJson());
              print(createUuid());
              UsersController().addUserSetting(usersModel).then((value) {
                print(value);
                if (value.statusCode == 200) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return showSuccessDialog(locale.addedSuccess);
                    },
                  ).then((value) {
                    Navigator.pop(context);
                  });

                  getAllUsers();
                }
              });
              // Navigator.of(context).pop();
            } else {
              ErrorController.openErrorDialog(406, locale.allFieldsAreReq);
            }
          },
          child: Text(locale.add),
        ),
      ],
    );
  }

  showSuccessDialog(String message) {
    return AlertDialog(
      title: Text(""),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(locale.ok),
        ),
      ],
    );
  }

  editDialog(UsersModel userModel) {
    print("toJsonnnnnnnnnn: ${userModel.toJson()}");
    editUsernameController.text = userModel.username ?? "";
    // passwordController.text = usersModel.password ?? "";
    editRoleController.text = userModel.role ?? "";
    return AlertDialog(
      title: Text(locale.editUser),
      content: SizedBox(
        width: width * 0.2,
        height: height * 0.3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: editUsernameController,
              decoration: InputDecoration(labelText: "${locale.userName}*"),
            ),
            TextField(
              controller: editPasswordController,
              decoration: InputDecoration(labelText: "${locale.password}*"),
            ),
            TextField(
              controller: editRoleController,
              decoration: InputDecoration(labelText: "${locale.role}*"),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(locale.cancel),
        ),
        TextButton(
          onPressed: () async {
            String? token = await storage.read(key: 'jwt');
            String username = "";
            String password = "";
            String role = "";

            if (editUsernameController.text.isNotEmpty &&
                editRoleController.text.isNotEmpty) {
              if (editPasswordController.text.isNotEmpty) {
                final iv = [0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 0, 1];
                final byteArray = Uint8List.fromList(
                    iv.map((bit) => bit == 1 ? 0x01 : 0x00).toList());
                String passEncrypted = Encryption.performAesEncryption(
                    editPasswordController.text, keyEncrypt, byteArray);
                password = passEncrypted;
              } else if (editPasswordController.text.isEmpty) {
                // password = userModel.password;
              }

              username = editUsernameController.text;
              role = editRoleController.text;

              UsersModel usersModel = UsersModel(
                  code: userModel.code,
                  username: username,
                  password: password,
                  activeToken: userModel.activeToken,
                  role: role);
              print(usersModel.toJson());
              print(createUuid());
              UsersController().updateUserSettings(usersModel).then((value) {
                print(value);
                if (value.statusCode == 200) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return showSuccessDialog(locale.editedSuccess);
                    },
                  ).then((value) {
                    Navigator.pop(context);
                  });
                  // ErrorController.openErrorDialog(200, locale.addedSuccess);
                  getAllUsers();
                }
              });
              // Navigator.of(context).pop();
            } else {
              ErrorController.openErrorDialog(406, locale.allFieldsAreReq);
            }
          },
          child: Text(locale.edit),
        ),
      ],
    );
  }

  Widget tableFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
            onPressed: () async {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return addDialog();
                },
              );
            },
            icon: const Icon(Icons.add)),
        IconButton(
            onPressed: () {
              UsersModel usersModel = userModel ?? tempList[0];
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return editDialog(usersModel);
                },
              );
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
    tempList = [];
    usersList.clear();
    UsersController().getUsersSettings().then((value) {
      for (var elemant in value) {
        usersList.add(elemant);
      }
      print("length: ${usersList.length}");
      tempList = usersList;
      setState(() {});
    });
  }

  String createUuid() {
    var uuid = const Uuid();
    return uuid.v4();
  }
}
