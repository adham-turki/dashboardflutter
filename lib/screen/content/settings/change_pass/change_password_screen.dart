import 'dart:typed_data';

import 'package:bi_replicate/utils/constants/app_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../../../Encryption/encryption.dart';
import '../../../../controller/error_controller.dart';
import '../../../../controller/settings/change_password_controller.dart';
import '../../../../model/settings/change_password_model.dart';
import '../../../../utils/constants/encrypt_key.dart';
import '../../../../widget/text_field_custom.dart';
import '../../../../utils/constants/styles.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  late AppLocalizations _locale;
  double width = 0;
  double height = 0;
  bool obscure1 = true;
  bool obscure2 = true;
  bool value = false;
  TextEditingController oldPass = TextEditingController();
  TextEditingController newPass = TextEditingController();
  var selectedPeriod = "";
  var selectedChart = "Line Chart";

  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Stack(children: [
      // Image.asset(
      //   'assets/background.png',
      //   fit: BoxFit.fill,
      //   width: double.infinity,
      //   height: double.infinity,
      // ),
      SingleChildScrollView(
        child: Column(
          children: [
            // const SizedBox(
            //   height: 40,
            // ),
            SizedBox(
              width: width < 800 ? width * 0.9 : width * 0.7,
              child: Center(
                child: SelectableText(
                  maxLines: 2,
                  _locale.changePassword,
                  style: twenty600TextStyle(Colors.blue[700]),
                ),
              ),
            ),
            const SizedBox(
              height: 80,
            ),
            Center(
              child: Container(
                width: width < 800 ? width * 0.9 : width * 0.5,
                padding: const EdgeInsets.only(bottom: 30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          TextFieldCustom(
                            obscureText: obscure1,
                            text: Text(_locale.oldPassword),
                            controller: oldPass,
                            customIconSuffix: GestureDetector(
                              onTap: () {
                                obscure1 = !obscure1;
                                setState(() {});
                              },
                              child: Icon(
                                obscure1
                                    ? CupertinoIcons.eye_slash_fill
                                    : CupertinoIcons.eye,
                                color: Colors.grey,
                                size: 20,
                              ),
                            ),
                          ),
                          // utils.roundedBorderLabelTextField(
                          //   obscureText: obscure1,
                          //   hintText: _locale.oldPassword,
                          //   labelText: _locale.oldPassword,
                          // ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFieldCustom(
                            obscureText: obscure2,
                            text: Text(_locale.newPasssword),
                            controller: newPass,
                            customIconSuffix: GestureDetector(
                              onTap: () {
                                obscure2 = !obscure2;
                                setState(() {});
                              },
                              child: Icon(
                                obscure2
                                    ? CupertinoIcons.eye_slash_fill
                                    : CupertinoIcons.eye,
                                color: Colors.grey,
                                size: 20,
                              ),
                            ),
                          ),
                          // utils.roundedBorderLabelTextField(
                          //   obscureText: obscure1,
                          //   hintText: _locale.newPasssword,
                          //   labelText: _locale.newPasssword,
                          // ),
                          const SizedBox(
                            height: 40,
                          ),

                          Components().blueButton(
                            height: width > 800 ? height * .05 : height * .04,
                            fontSize:
                                width > 800 ? height * .016 : height * .011,

                            width: width * 0.2,
                            //height: 40.0,
                            onPressed: () {
                              changePass();
                            },
                            text: _locale.changePassword,
                            borderRadius: 0.3,
                            textColor: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    ]);
  }

  Future changePass() async {
    final iv = [0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 0, 1];
    final byteArray =
        Uint8List.fromList(iv.map((bit) => bit == 1 ? 0x01 : 0x00).toList());
    String oldPassEncrypted =
        Encryption.performAesEncryption(oldPass.text, keyEncrypt, byteArray);
    String newPassEncrypted =
        Encryption.performAesEncryption(newPass.text, keyEncrypt, byteArray);
    ChangePasswordModel changePasswordModel =
        ChangePasswordModel(oldPassEncrypted, newPassEncrypted);
    // print()
    ChangePasswordController()
        .changePassword(changePasswordModel, context)
        .then((value) {
      // if (value) {
      //   ErrorController.openErrorDialog(200, "Done", context);
      // }
    });
  }
}
