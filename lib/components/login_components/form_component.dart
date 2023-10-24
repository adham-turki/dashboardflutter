import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/local_provider.dart';
import '../../utils/constants/colors.dart';
import '../../widget/language_widget.dart';
import 'login_textfield.dart';

class FormComponent extends StatefulWidget {
  final Function()? onPressed;
  final TextEditingController? aliasName;
  final TextEditingController? userController;
  final TextEditingController? passwordController;
  const FormComponent(
      {super.key,
      this.onPressed,
      this.aliasName,
      this.userController,
      this.passwordController});

  @override
  State<FormComponent> createState() => _FormComponentState();
}

class _FormComponentState extends State<FormComponent> {
  bool obscure1 = true;
  bool obscure2 = true;
  double height = 0;
  double width = 0;
  late AppLocalizations _locale;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _locale = AppLocalizations.of(context);
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    final localeProvider = Provider.of<LocaleProvider>(context);

    return SizedBox(
      height: width * 0.4,
      child: Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Center(
              child: Container(
                width: width * 0.3,
                height: width * 0.3,
                decoration: BoxDecoration(
                  // color: primary,
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(255, 2, 50, 89),
                      Color.fromARGB(255, 6, 88, 155),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      spreadRadius: 1,
                      blurRadius: 20,
                      // offset: Offset(0, 10),
                    ),
                  ],
                  shape: BoxShape.circle,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: width * 0.2,
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "BI",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: width * 0.03,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    LoginTextField(
                      hint: _locale.aliasName,
                      controller: widget.aliasName,
                    ),
                    LoginTextField(
                      hint: _locale.userName,
                      controller: widget.userController,
                    ),
                    LoginTextField(
                      hint: _locale.password,
                      controller: widget.passwordController,
                      obscureText: obscure1,
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
                    const SizedBox(),
                    const SizedBox(
                      height: 0,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    clipBehavior: Clip.hardEdge,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      fixedSize: Size(width * 0.1, width * 0.1),
                      shape: const CircleBorder(),
                      elevation: 0,
                    ),
                    onPressed: widget.onPressed,
                    child: Text(
                      _locale.login,
                      style: TextStyle(
                        color: primary,
                        fontSize: width * 0.015,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
