import 'package:bi_replicate/controller/login/login_controller.dart';
import 'package:bi_replicate/home.dart';
import 'package:bi_replicate/model/login/users_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../Encryption/encryption.dart';
import '../components/login_components/custom_painter.dart';
import '../components/login_components/form_component.dart';
import '../controller/central_api_controller.dart';
import '../controller/error_controller.dart';
import '../utils/constants/encrypt_key.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  double height = 0;
  double width = 0;
  final _keyForm = GlobalKey<FormState>();
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController aliasName = TextEditingController();
  bool loginTemp = false;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Stack(
      children: [
        Container(
          width: width,
          height: height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/images/wallpaper_image.jpg",
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
          ),
        ),
        Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomPaint(
                  size: Size(width * 0.12, height * 0.2),
                  painter: MyPainter(context: context),
                ),
              ],
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FormComponent(
                        aliasName: aliasName,
                        userController: userController,
                        passwordController: passwordController,
                        onPressed: () {
                          if (aliasName.text.isEmpty) {
                            // show dialog missing password
                            ErrorController.openErrorDialog(
                                406, "Missing Alias Name!", context);
                          } else if (userController.text.isEmpty) {
                            // show dialog missing email
                            ErrorController.openErrorDialog(
                                406, "Missing User Name!", context);
                          } else if (passwordController.text.isEmpty) {
                            // show dialog missing password
                            ErrorController.openErrorDialog(
                                406, "Missing Password!", context);
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              },
                            );
                            loadApi();
                          }

                          // if (_keyForm.currentState!.validate()) {
                          //   print("object 22");
                          //   _savingData().then((value) {
                          //     print("object 33");
                          //   });
                          // }
                          // Navigator.push(context, MaterialPageRoute(
                          //   builder: (context) {
                          //     return const HomePage();
                          //   },
                          // ));
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    width: width * 0.04,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ));
  }

  Future<void> _savingData() async {
    final validation = _keyForm.currentState!.validate();
    if (validation) {
      _keyForm.currentState!.save();
    } else {
      return;
    }
  }

  Future loadApi() async {
    await rootBundle
        .loadString("assets/centralApi/central_api.properties")
        .then((value) {
      var url = value.trim();
      CentralApiController().getApi(url, aliasName.text).then((value) {
        if (value == "204") {
          ErrorController.openErrorDialog(406, "Wrong Alias Name!", context);
        } else {
          const storage = FlutterSecureStorage();

          storage.write(key: 'api', value: value).then((value) {
            checkLogIn().then((value) {
              if (value) {
                Navigator.pop(context); // for Circular
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return const HomePage();
                  },
                ));
                // Navigator.pushReplacementNamed(context, mainScreenRoute);
              } else {
                ErrorController.openErrorDialog(
                    406, "Wrong Email or Password!", context);
              }
            });
          });
        }
      });
    });
  }

  checkLogIn() {
    final iv = [0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 0, 1];
    final byteArray =
        Uint8List.fromList(iv.map((bit) => bit == 1 ? 0x01 : 0x00).toList());
    String passEncrypted = Encryption.performAesEncryption(
        passwordController.text, keyEncrypt, byteArray);
    UserModel userModel = UserModel(userController.text, passEncrypted);
    return LoginController().logInPost(userModel);
  }
}
