import '../../../model/settings/setup/bi_account_model.dart';
import 'setup_screen_controller.dart';

Future<List<BiAccountModel>> getPayableAccounts({bool? isStart}) async {
  List<BiAccountModel> payableAccounts = [];

  await SetupController().getBiAccounts(isStart: isStart).then((value) {
    for (var elemant in value) {
      if (elemant.accountType == 4) {
        payableAccounts.add(elemant);
      }
    }
  });
  return payableAccounts;
}

Future<List<BiAccountModel>> getCashBoxAccount({bool? isStart}) async {
  List<BiAccountModel> cashboxAccounts = [];

  await SetupController().getBiAccounts(isStart: isStart).then((value) {
    for (var elemant in value) {
      if (elemant.accountType == 2) {
        cashboxAccounts.add(elemant);
      }
    }
  });

  return cashboxAccounts;
}

Future<List<BiAccountModel>> getExpensesAccounts({bool? isStart}) async {
  List<BiAccountModel> expensesAccounts = [];

  await SetupController().getBiAccounts(isStart: isStart).then((value) {
    for (var elemant in value) {
      if (elemant.accountType == 1) {
        expensesAccounts.add(elemant);
      }
    }
  });
  return expensesAccounts;
}

Future getReceivableAccounts({bool? isStart}) async {
  List<BiAccountModel> receivableAccounts = [];

  await SetupController().getBiAccounts(isStart: isStart).then((value) {
    for (var elemant in value) {
      if (elemant.accountType == 3) {
        receivableAccounts.add(elemant);
      }
    }
  });
  return receivableAccounts;
}
