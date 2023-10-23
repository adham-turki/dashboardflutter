import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../model/login/users_model.dart';
import '../../service/api_service.dart';
import '../../utils/constants/api_constants.dart';
import '../../utils/constants/values.dart';

class LoginController {
  Future<bool> logInPost(UserModel userModel) async {
    String api = logInApi;
    var response = await ApiService.postRequest(api, userModel.toJson());
    if (response.statusCode == statusOk) {
      String token = response.body.substring(13, response.body.length - 2);

      const storage = FlutterSecureStorage();

      await storage.write(key: 'jwt', value: token);
      return true;
    }

    return false;
  }
}
