import 'dart:convert';

import 'package:bi_replicate/model/settings/user_permissions/user_permissions_model.dart';
import 'package:bi_replicate/model/settings/user_permissions/user_permit_criteria_model.dart';
import 'package:bi_replicate/model/settings/user_settings/user_settings_model.dart';
import 'package:bi_replicate/utils/constants/api_constants.dart';
import 'package:bi_replicate/utils/constants/values.dart';
import 'package:http/http.dart';

import '../../../service/api_service.dart';

class UserPermissionsController {
  List<UserPermitModel> permitList = [];

  Future<List<UserPermitModel>> getPermitReportsByCode(String userCode) async {
    UsersModel usersModel = UsersModel(
        code: userCode, username: "", password: "", activeToken: "", role: "");
    String api = getPermitByUser;

    await ApiService()
        .postRequest(api, usersModel.permitToJson())
        .then((value) {
      if (value.statusCode == statusOk) {
        var jsonData = jsonDecode(utf8.decode(value.bodyBytes));
        for (var permit in jsonData) {
          print(permit);
          permitList.add(UserPermitModel.fromJson(permit));
        }
      }
    });
    return permitList;
  }

  Future addUserPermit(UserPermitCriteria userPermitCriteria) async {
    String api = addPermit;
    Response response =
        await ApiService().postRequest(api, userPermitCriteria.toJson());

    return response;
  }

  Future editUserPermit(UserPermitCriteria userPermitCriteria) async {
    String api = updatePermit;
    Response response =
        await ApiService().postRequest(api, userPermitCriteria.toJson());
    return response;
  }

  Future deleteUserPermit(UserPermitCriteria userPermitCriteria) async {
    String api = deletePermit;
    Response response =
        await ApiService().postRequest(api, userPermitCriteria.toJson());

    return response;
  }
}
