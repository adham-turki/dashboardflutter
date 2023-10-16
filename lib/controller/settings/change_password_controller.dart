import '../../model/settings/change_password_model.dart';
import '../../service/Api.dart';
import '../../utils/constants/api_constants.dart';
import '../error_controller.dart';

class ChangePasswordController extends Api {
  Future<bool> changePassword(ChangePasswordModel body) async {
    String api = changePasswordApi;
    await postMethods(api, body).then((value) {
      if (value.statusCode == 200) {
        ErrorController.openErrorDialog(200, value.body);

        return true;
      }
    });
    return false;
  }
}
