import 'dart:convert';

import 'package:bi_replicate/model/settings/user_settings/code_reports_model.dart';
import 'package:http/http.dart';

import '../../../service/api_service.dart';
import '../../../utils/constants/api_constants.dart';
import '../../../utils/constants/values.dart';

class CodeReportsController {
  List<CodeReportsModel> codeReportsList = [];

  Future<List<CodeReportsModel>> getAllCodeReports({bool? isStart}) async {
    String api = getReportCodes;
    await ApiService().getRequest(api, isStart: isStart).then((value) {
      if (value.statusCode == statusOk) {
        var jsonData = jsonDecode(utf8.decode(value.bodyBytes));
        for (var elemant in jsonData) {
          codeReportsList.add(CodeReportsModel.fromJson(elemant));
          // userSettingsList[i] = jsonData[i];
        }
      }
    });

    return codeReportsList;
  }

  Future addCodeReport(CodeReportsModel userSettingsModel) async {
    String api = addReportCodes;
    Response response =
        await ApiService().postRequest(api, userSettingsModel.toJson());
    return response;
  }

  Future editCodeReport(CodeReportsModel userSettingsModel) async {
    String api = updateReportCodes;
    Response response =
        await ApiService().postRequest(api, userSettingsModel.toJson());
    return response;
  }

  Future deleteCodeReport(CodeReportsModel userSettingsModel) async {
    String api = deleteReportCodes;
    Response response =
        await ApiService().postRequest(api, userSettingsModel.toJson());
    return response;
  }
}
