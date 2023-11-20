import 'package:flutter/cupertino.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../utils/constants/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../utils/constants/responsive.dart';

class UsersModel {
  String code;
  String username;
  String password;
  String activeToken;
  String role;

  UsersModel({
    required this.code,
    required this.username,
    required this.password,
    required this.activeToken,
    required this.role,
  });
  String codeToString() {
    return code;
  }

  @override
  String toString() {
    return username;
  }

  factory UsersModel.fromJson(Map<String, dynamic> json) {
    return UsersModel(
      code: json['code'] ?? "",
      username: json['username'] ?? "",
      password: json['password'] ?? "",
      activeToken: json['activeToken'] ?? "",
      role: json['role'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'username': username,
      'password': password,
      'activeToken': activeToken,
      'role': role,
    };
  }

  Map<String, dynamic> permitToJson() {
    return {
      'nameCode': code,
    };
  }

  static List<PlutoColumn> getColumns(
      BuildContext context, AppLocalizations localizations) {
    double width = MediaQuery.of(context).size.width;
    bool isDesktop = Responsive.isDesktop(context);

    List<PlutoColumn> list = [
      // PlutoColumn(
      //   title: "#",
      //   field: "dash",
      //   type: PlutoColumnType.number(),
      //   width: isDesktop ? width * 0.04 : width * 0.1,
      //   backgroundColor: colColor,
      // ),
      PlutoColumn(
        title: localizations.userName,
        field: "username",
        type: PlutoColumnType.text(),
        width: isDesktop ? width * 0.2 : width * 0.45,
        backgroundColor: colColor,
      ),
      PlutoColumn(
        title: localizations.role,
        field: "role",
        type: PlutoColumnType.text(),
        width: isDesktop ? width * 0.2 : width * 0.45,
        backgroundColor: colColor,
      ),
    ];
    return list;
  }

  PlutoRow toPluto(int dash) {
    final Map<String, PlutoCell> salesReport = <String, PlutoCell>{};

    // salesReport['dash'] = PlutoCell(value: dash);
    salesReport['username'] = PlutoCell(value: username ?? "");
    salesReport['role'] = PlutoCell(value: role ?? "");
    // salesReport['accountType'] = PlutoCell(value: accountType ?? "");

    return PlutoRow(cells: salesReport);
  }
}
