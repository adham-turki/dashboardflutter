import 'package:flutter/cupertino.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/responsive.dart';

class UserPermitModel {
  final String key;
  final String reportCode;
  final String reportNamee;
  final String reportNamea;
  final int bolAllowed;

  UserPermitModel({
    required this.key,
    required this.reportCode,
    required this.reportNamee,
    required this.reportNamea,
    required this.bolAllowed,
  });
  factory UserPermitModel.fromJson(Map<String, dynamic> json) {
    return UserPermitModel(
      key: json['key'],
      reportCode: json['reportCode'],
      reportNamee: json['reportNamee'],
      reportNamea: json['reportNamea'],
      bolAllowed: json['bolAllowed'],
    );
  }
  factory UserPermitModel.fromJson2(
      Map<String, dynamic> json, AppLocalizations locale) {
    print("hellooooooooo: ${UserPermitModel(
      key: "",
      reportCode: "${json['reportCode']}",
      reportNamee: json['reportNamee'],
      reportNamea: json['reportNamea'],
      bolAllowed: json['bolAllowed'] == locale.allowed ? 1 : 0,
    ).toJson()}");
    return UserPermitModel(
      key: "",
      reportCode: "${json['reportCode']}",
      reportNamee: json['reportNamee'],
      reportNamea: json['reportNamea'],
      bolAllowed: json['bolAllowed'] == locale.allowed ? 1 : 0,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'reportCode': reportCode,
      'reportNamee': reportNamee,
      'reportNamea': reportNamea,
      'bolAllowed': bolAllowed,
    };
  }

  static List<PlutoColumn> getColumns(
      BuildContext context, AppLocalizations localizations) {
    double width = MediaQuery.of(context).size.width;
    bool isDesktop = Responsive.isDesktop(context);

    List<PlutoColumn> list = [
      PlutoColumn(
        title: "#",
        field: "reportCode",
        type: PlutoColumnType.number(),
        width: isDesktop ? width * 0.04 : width * 0.1,
        backgroundColor: colColor,
      ),
      PlutoColumn(
        title: localizations.reportNamee,
        field: "reportNamee",
        type: PlutoColumnType.text(),
        width: isDesktop ? width * 0.24 : width * 0.3,
        backgroundColor: colColor,
      ),
      PlutoColumn(
        title: localizations.reportNamea,
        field: "reportNamea",
        type: PlutoColumnType.text(),
        width: isDesktop ? width * 0.24 : width * 0.3,
        backgroundColor: colColor,
      ),
      PlutoColumn(
        title: localizations.allowed,
        field: "bolAllowed",
        type: PlutoColumnType.text(),
        width: isDesktop ? width * 0.2 : width * 0.2,
        backgroundColor: colColor,
      ),
    ];
    return list;
  }

  PlutoRow toPluto(int dash, AppLocalizations locale) {
    final Map<String, PlutoCell> permits = <String, PlutoCell>{};

    permits['reportCode'] = PlutoCell(value: dash);
    permits['reportNamee'] = PlutoCell(value: reportNamee ?? "");
    permits['reportNamea'] = PlutoCell(value: reportNamea ?? "");
    permits['bolAllowed'] =
        PlutoCell(value: bolAllowed == 0 ? locale.notAllowed : locale.allowed);

    return PlutoRow(cells: permits);
  }
}
