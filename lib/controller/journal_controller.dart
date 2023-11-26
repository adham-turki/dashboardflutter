import 'dart:convert';

import '../model/journal_reports_model.dart';
import '../model/new_search_criteria_model.dart';
import 'error_controller.dart';
import 'package:http/http.dart' as http;

class JournalController {
  final String url = "http://167.235.150.228:7001";
  final String getAllJournals = "journalReports/getAll";
  List<JournalReportsModel> journalReportsList = [];

  Future<List<JournalReportsModel>> getAllJournalReports(
      NewSearchCriteria searchCriteria) async {
    var requestUrl = "$url/$getAllJournals";

    var response = await http.post(Uri.parse(requestUrl),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
        },
        body: json.encode(searchCriteria.toJson()));
    print(Uri.parse(requestUrl));
    print(json.encode(searchCriteria.toJson()));
    print(response.statusCode);

    if (response.statusCode != 200) {
      if (response.statusCode == 417 || response.statusCode == 401) {
        ErrorController.openErrorDialog(
          response.statusCode,
          response.body,
        );
      }
    }
    var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
    for (var elemant in jsonData) {
      // print(JournalReportsModel.fromJson(elemant).accCode);
      journalReportsList.add(JournalReportsModel.fromJson(elemant));
    }
    return journalReportsList;
  }
}
