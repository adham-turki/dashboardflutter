import 'dart:convert';
import 'package:bi_replicate/model/branch_model.dart';
import 'package:bi_replicate/service/api_service.dart';
import '../../utils/constants/api_constants.dart';
import '../../utils/constants/values.dart';

class BranchController {
  Future<Map<String, dynamic>> getBranch({bool? isStart}) async {
    var api = getBranchs;
    Map<String, dynamic> branchesMapCurrent = {};

    await ApiService().getRequest(api, isStart: isStart).then((value) {
      if (value.statusCode == statusOk) {
        var jsonData = jsonDecode(utf8.decode(value.bodyBytes));
        for (int i = 0; i < jsonData.length; i++) {
          branchesMapCurrent[jsonData[i]['txtNamee']] = jsonData[i]['txtCode'];
        }
      }
    });

    return branchesMapCurrent;
  }

  Future<List<BranchModel>> getBranchesList({bool? isStart}) async {
    var api = getBranchs;
    List<BranchModel> list = [];

    await ApiService().getRequest(api, isStart: isStart).then((value) {
      if (value.statusCode == statusOk) {
        var jsonData = jsonDecode(utf8.decode(value.bodyBytes));
        for (int i = 0; i < jsonData.length; i++) {
          list.add(BranchModel.fromJson(jsonData[i]));
          print("listttttt: ${list[i].txtCode}");
          print("listttttt1: ${list[i].txtNamee}");
        }
      }
    });

    return list;
  }
}
