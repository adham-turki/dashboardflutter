import 'package:bi_replicate/Encryption/encryption.dart';
import 'package:bi_replicate/provider/dates_provider.dart';
import 'package:bi_replicate/utils/constants/encrypt_key.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/error_controller.dart';
import '../controller/login/login_controller.dart';
import '../model/login/users_model.dart';
import '../utils/constants/colors.dart';
import '../utils/constants/constants.dart';
import '../utils/constants/responsive.dart';

class LoginDialog extends StatefulWidget {
  const LoginDialog({
    super.key,
  });

  @override
  State createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  late AppLocalizations _locale;
  double radius = 7;
  LoginController loginController = LoginController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  bool obsecureText = true;
  Color leftBackColor = const Color.fromRGBO(16, 184, 249, 1);
  Color rightBackColor = const Color.fromRGBO(64, 144, 247, 1);

  @override
  Future<void> didChangeDependencies() async {
    _locale = AppLocalizations.of(context)!;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emailController.text = prefs.getString("userName").toString();
    super.didChangeDependencies();
  }

  // void _handleKey(RawKeyEvent event) {
  //   if (event is RawKeyDownEvent) {
  //     if (event.logicalKey == LogicalKeyboardKey.enter) {
  //       Navigator.pop(context, true);
  //     }
  //   }
  // }

  double dialogWidth = 0;
  double dialogHeight = 0;
  @override
  Widget build(BuildContext context) {
    dialogWidth = MediaQuery.of(context).size.width;
    dialogHeight = MediaQuery.of(context).size.height;
    bool isDesktop = Responsive.isDesktop(context);

    return KeyboardListener(
      focusNode: FocusNode(),
      child: Dialog(
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: SizedBox(
          width: isDesktop ? dialogWidth * 0.37 : dialogWidth * 0.8,
          height: isDesktop ? dialogHeight * 0.85 : dialogHeight * 0.65,
          child: Column(
            children: [
              SizedBox(
                height: isDesktop ? dialogHeight * 0.37 : dialogHeight * 0.25,
                width: double.infinity,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: const BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Color.fromARGB(255, 237, 34, 20)),
                            child: IconButton(
                                onPressed: () async {
                                  context
                                      .read<DatesProvider>()
                                      .setSessionFromDate("");
                                  context
                                      .read<DatesProvider>()
                                      .setSessionToDate("");
                                  GoRouter.of(context).go(loginScreenRoute);
                                },
                                icon: const Icon(
                                  Icons.close_rounded,
                                  color: Colors.white,
                                )),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Image.asset(
                            "assets/images/expired2.png",
                            width: isDesktop
                                ? dialogWidth * 0.08
                                : dialogWidth * 0.4,
                            height: dialogHeight * 0.25,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: dialogHeight * 0.04,
              ),
              loginText(),
              SizedBox(
                height: isDesktop ? dialogHeight * 0.04 : dialogHeight * 0.02,
              ),
              customTextField(
                _locale.userName,
                emailController,
                emailFocus,
                false,
                isDesktop,
              ),
              customTextField(
                _locale.password,
                passwordController,
                passwordFocus,
                true,
                isDesktop,
              ),
              SizedBox(
                height: dialogHeight * 0.05,
              ),
              customSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget loginText() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        _locale.expiredSessionLoginDialog,
        style: TextStyle(
          fontSize: dialogHeight * 0.022,
          shadows: [Shadow(color: Colors.black, offset: Offset(0, -25))],
          color: Colors.transparent,
          decoration: TextDecoration.underline,
          decorationColor: primary,
          decorationThickness: 2,
        ),
      ),
    );
  }

  Widget customTextField(String hint, TextEditingController controller,
      FocusNode focus, bool isPassword, bool isDesktop) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        width: isDesktop ? dialogWidth * 0.3 : dialogWidth * 0.65,
        height: dialogHeight * 0.08,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: TextFormField(
            readOnly: !isPassword,
            autofocus: focus == passwordFocus ? true : false,
            focusNode: focus,
            onFieldSubmitted: (value) {
              if (emailFocus.hasFocus) {
                passwordFocus.requestFocus();
              } else {
                passwordAndEmailCheck();
              }
            },
            controller: controller,
            style: const TextStyle(
              fontSize: 18,
            ),
            obscureText: isPassword ? obsecureText : false,
            decoration: InputDecoration(
              suffixIcon: isPassword
                  ? obsecureText
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              obsecureText = obsecureText ? false : true;
                            });
                          },
                          icon: const Icon(
                            Icons.visibility_off,
                            color: primary,
                            size: 28,
                          ),
                        )
                      : IconButton(
                          onPressed: () {
                            setState(() {
                              obsecureText = obsecureText ? false : true;
                            });
                          },
                          icon: const Icon(
                            Icons.visibility,
                            color: primary,
                            size: 28,
                          ),
                        )
                  : null,
              border: InputBorder.none,
              hintText: hint,
            ),
          ),
        ),
      ),
    );
  }

  Widget customSubmitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: Size(dialogWidth * 0.15, dialogHeight * 0.05),
        backgroundColor: primary,
        foregroundColor: Colors.white,
        textStyle: TextStyle(fontSize: dialogHeight * 0.015),
      ),
      onPressed: () {
        passwordAndEmailCheck();
      },
      child: Center(
        child: Text(
          _locale.signIn,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  passwordAndEmailCheck() {
    if (checkIfEmailEmpty()) {
      ErrorController.openErrorDialog(406, _locale.nameReqField);

      emailFocus.requestFocus();
    } else if (checkIfPasswordEmpty()) {
      ErrorController.openErrorDialog(406, _locale.passReqField);

      passwordFocus.requestFocus();
    } else {
      logIn();
    }
  }

  bool checkIfEmailEmpty() {
    if (emailController.text.isEmpty || emailController.text == "") {
      return true;
    }
    return false;
  }

  bool checkIfPasswordEmpty() {
    if (passwordController.text.isEmpty || passwordController.text == "") {
      return true;
    }
    return false;
  }

  logIn() async {
    final iv = [0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 0, 1];
    final byteArray =
        Uint8List.fromList(iv.map((bit) => bit == 1 ? 0x01 : 0x00).toList());
    String passEncrypted = Encryption.performAesEncryption(
        passwordController.text, keyEncrypt, byteArray);
    UserModel userModel = UserModel(emailController.text, passEncrypted);
    await loginController.logInPost(userModel, _locale).then((value) async {
      if (value) {
        Navigator.pop(context, true);
      }
    });
  }
}
