import 'rec_pay__data_model.dart';

class RecPayModel {
  List<RecPayDataModel> payables = [];
  List<RecPayDataModel> receivables = [];
  RecPayModel(this.payables, this.receivables);
  RecPayModel.fromJson(Map<String, dynamic> recPay) {
    List<Map<String, dynamic>> recPayList = [];
    List<dynamic> dynamicList = recPay['payables'];

    for (int i = 0; i < dynamicList.length; i++) {
      recPayList.add(dynamicList[i]);
      payables.add(RecPayDataModel.fromJson(recPayList[i]));
    }

    recPayList = [];
    dynamicList = recPay['receivables'];
    for (int i = 0; i < dynamicList.length; i++) {
      recPayList.add(dynamicList[i]);
      receivables.add(RecPayDataModel.fromJson(recPayList[i]));
    }
  }
}
