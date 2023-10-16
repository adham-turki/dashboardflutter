import '../../../model/settings/setup/bi_account_model.dart';
import 'setup_screen_controller.dart';

Future<List<BiAccountModel>> getPayableAccounts() async {
  List<BiAccountModel> payableAccounts = [];

  await SetupController().getBiAccounts().then((value) {
    for (var elemant in value) {
      if (elemant.accountType == 4) {
        payableAccounts.add(elemant);
      }
    }
  });
  return payableAccounts;
}

Future<List<BiAccountModel>> getCashBoxAccount() async {
  List<BiAccountModel> cashboxAccounts = [];

  await SetupController().getBiAccounts().then((value) {
    for (var elemant in value) {
      if (elemant.accountType == 2) {
        cashboxAccounts.add(elemant);
      }
    }
  });

  return cashboxAccounts;
}

Future<List<BiAccountModel>> getExpensesAccounts() async {
  List<BiAccountModel> expensesAccounts = [];

  await SetupController().getBiAccounts().then((value) {
    for (var elemant in value) {
      if (elemant.accountType == 1) {
        expensesAccounts.add(elemant);
      }
    }
  });
  return expensesAccounts;
}

Future getReceivableAccounts() async {
  List<BiAccountModel> receivableAccounts = [];

  await SetupController().getBiAccounts().then((value) {
    for (var elemant in value) {
      if (elemant.accountType == 3) {
        receivableAccounts.add(elemant);
      }
    }
  });
}
