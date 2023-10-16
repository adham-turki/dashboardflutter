import 'dart:convert';
import '../../service/Api.dart';
import '../../utils/constants/api_constants.dart';
import '../../utils/constants/values.dart';

class BranchController extends Api {
  Future<Map<String, dynamic>> getBranch() async {
    var api = getBranchs;
    Map<String, dynamic> branchesMapCurrent = {};

    await getMethods(api).then((value) {
      if (value.statusCode == statusOk) {
        var jsonData = jsonDecode(utf8.decode(value.bodyBytes));
        for (int i = 0; i < jsonData.length; i++) {
          branchesMapCurrent[jsonData[i]['txtNamee']] = jsonData[i]['txtCode'];
        }
      }
    });

    return branchesMapCurrent;
  }
}
