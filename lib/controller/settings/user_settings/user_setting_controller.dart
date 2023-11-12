import 'dart:convert';

import 'package:bi_replicate/model/settings/user_settings/user_settings_model.dart';
import 'package:bi_replicate/utils/constants/api_constants.dart';

import '../../../service/api_service.dart';
import '../../../utils/constants/values.dart';

class UserSettingsController {
  List<UserSettingsModel> userSettingsList = [];
  Future getUsersSettings({bool? isStart}) async {
    String api = getUserSettings;
    await ApiService().getRequest(api, isStart: isStart).then((value) {
      if (value.statusCode == statusOk) {
        var jsonData = jsonDecode(utf8.decode(value.bodyBytes));
        for (var elemant in jsonData) {
          userSettingsList.add(UserSettingsModel.fromJson(elemant));
          // userSettingsList[i] = jsonData[i];
        }
      }
    });
    return userSettingsList;
  }

  Future addUserSetting(UserSettingsModel userSettingsModel) async {
    String api = addUserSettings;
    await ApiService()
        .postRequest(api, userSettingsModel.toJson())
        .then((value) {
      if (value.statusCode == 200) {
        return true;
      }
    });
    return false;
  }

  Future updateUserSettings(UserSettingsModel userSettingsModel) async {
    String api = editUserSettings;
    await ApiService()
        .postRequest(api, userSettingsModel.toJson())
        .then((value) {
      if (value.statusCode == 200) {
        return true;
      }
    });
    return false;
  }

  Future deleteUserSetting(UserSettingsModel userSettingsModel) async {
    String api = deleteUserSettings;
    await ApiService()
        .postRequest(api, userSettingsModel.toJson())
        .then((value) {
      if (value.statusCode == 200) {
        return true;
      }
    });
    return false;
  }
}
