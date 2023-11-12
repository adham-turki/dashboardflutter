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

  Future addUserSettings() {
    return Future.delayed(Duration.zero);
  }

  Future updateUserSettings() {
    return Future.delayed(Duration.zero);
  }

  Future deleteUserSettings() {
    return Future.delayed(Duration.zero);
  }
}
