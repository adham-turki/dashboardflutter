import 'package:bi_replicate/service/api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../model/api_url.dart';
import '../../model/login/users_model.dart';
import '../../service/api_service.dart';
import '../../utils/constants/api_constants.dart';
import '../../utils/constants/values.dart';
import '../error_controller.dart';

class LoginController {
  Future<bool> logInPost(UserModel userModel) async {
    String api = logInApi;
    var response = await ApiService.postRequest(api, userModel.toJson());
    print("code: ${response.statusCode}");
    print("body: ${response.body}");
    if (response.statusCode == statusOk) {
      String token = response.body.substring(13, response.body.length - 2);

      const storage = FlutterSecureStorage();

      await storage.write(key: 'jwt', value: token);
      return true;
    } else {
      if (response.statusCode == 400 || response.statusCode == 406) {
        // ErrorController.dialogBasedonResponseStatus(Icons.warning,
        //     local.wronUserNameOrPass, local.wrongInput, Colors.red, 400);
      }
      ApiURL().setUrl("");
    }

    return false;
  }
}
