import 'dart:convert';

import 'package:bi_replicate/model/settings/user_settings/user_settings_model.dart';
import 'package:bi_replicate/utils/constants/api_constants.dart';
import 'package:http/http.dart';

import '../../../service/api_service.dart';
import '../../../utils/constants/values.dart';

class UsersController {
  List<UsersModel> userSettingsList = [];
  Future getUsersSettings({bool? isStart}) async {
    String api = getUsers;
    await ApiService().getRequest(api, isStart: isStart).then((value) {
      if (value.statusCode == statusOk) {
        var jsonData = jsonDecode(utf8.decode(value.bodyBytes));
        for (var elemant in jsonData) {
          userSettingsList.add(UsersModel.fromJson(elemant));
          // userSettingsList[i] = jsonData[i];
        }
      }
    });
    return userSettingsList;
  }

  Future addUserSetting(UsersModel userSettingsModel) async {
    String api = addUser;
    Response response =
        await ApiService().postRequest(api, userSettingsModel.toJson());
    return response;
  }

  Future updateUserSettings(UsersModel userSettingsModel) async {
    String api = editUser;
    Response response =
        await ApiService().postRequest(api, userSettingsModel.toJson());
    return response;
  }

  Future deleteUserSetting(UsersModel userSettingsModel) async {
    String api = deleteUser;
    Response response =
        await ApiService().postRequest(api, userSettingsModel.toJson());
    return response;
  }
}
