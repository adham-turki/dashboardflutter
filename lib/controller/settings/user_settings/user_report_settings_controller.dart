import 'dart:convert';

import 'package:bi_replicate/model/settings/user_settings/user_report_settings.dart';
import 'package:bi_replicate/utils/constants/api_constants.dart';
import 'package:http/http.dart';

import '../../../service/api_service.dart';
import '../../../utils/constants/values.dart';

class UserReportSettingsController {
  List<UserReportSettingsModel> userReportSettingsList = [];

  Future<List<UserReportSettingsModel>> getAllUserReportSettings(
      {bool? isStart}) async {
    String api = getUserReportSettings;
    await ApiService().getRequest(api, isStart: isStart).then((value) {
      if (value.statusCode == statusOk) {
        var jsonData = jsonDecode(utf8.decode(value.bodyBytes));
        for (var elemant in jsonData) {
          userReportSettingsList.add(UserReportSettingsModel.fromJson(elemant));
          // userSettingsList[i] = jsonData[i];
        }
      }
    });

    return userReportSettingsList;
  }

  Future addUserReportSetting(UserReportSettingsModel userSettingsModel) async {
    String api = addUserReportSettings;
    Response response =
        await ApiService().postRequest(api, userSettingsModel.toJson());
    return response;
  }

  Future editUserReportSettings(
      UserReportSettingsModel userSettingsModel) async {
    String api = updateUserReportSettings;
    Response response =
        await ApiService().postRequest(api, userSettingsModel.toJson());
    return response;
  }

  Future deleteUserReportSetting(
      UserReportSettingsModel userSettingsModel) async {
    String api = deleteUserReportSettings;
    Response response =
        await ApiService().postRequest(api, userSettingsModel.toJson());
    return response;
  }
}
