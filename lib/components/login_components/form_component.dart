import 'package:bi_replicate/utils/constants/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import '../../utils/constants/colors.dart';
import 'login_textfield.dart';

class FormComponent extends StatefulWidget {
  final Function()? onPressed;
  final TextEditingController? aliasName;
  final TextEditingController? userController;
  final TextEditingController? passwordController;
  final Function(String value)? onSubmit;
  const FormComponent({
    super.key,
    this.onPressed,
    this.aliasName,
    this.userController,
    this.passwordController,
    this.onSubmit,
  });

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
    _locale = AppLocalizations.of(context)!;
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    bool isDesktop = Responsive.isDesktop(context);

    Size loginBtn = Size(width * 0.1, width * 0.1);
    return SizedBox(
      height: isDesktop ? width * 0.4 : height * 0.8,
      child: Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            isDesktop ? circleForm() : rectangleForm(),
            isDesktop ? logoutBtn(loginBtn, isDesktop) : Container(),
          ],
        ),
      ),
    );
  }

  SizedBox logoutBtn(Size loginBtn, bool isDesktop) {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            clipBehavior: Clip.hardEdge,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              fixedSize: loginBtn,
              shape: CircleBorder(
                  side: isDesktop
                      ? BorderSide.none
                      : BorderSide(color: Colors.grey.withOpacity(0.5))),
              elevation: 0,
            ),
            onPressed: widget.onPressed,
            child: Text(
              _locale.login,
              style: TextStyle(
                color: primary,
                fontSize: isDesktop ? width * 0.015 : width * 0.05,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding circleForm() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
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
              Directionality(
                textDirection: _locale.localeName == "ar"
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: LoginTextField(
                  hint: _locale.aliasName,
                  controller: widget.aliasName,
                  onSubmitted: (value) {
                    if (widget.onSubmit != null) {
                      widget.onSubmit!(value);
                    }
                  },
                ),
              ),
              Directionality(
                textDirection: _locale.localeName == "ar"
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: LoginTextField(
                  hint: _locale.userName,
                  controller: widget.userController,
                  onSubmitted: (value) {
                    if (widget.onSubmit != null) {
                      widget.onSubmit!(value);
                    }
                  },
                ),
              ),
              Directionality(
                textDirection: _locale.localeName == "ar"
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: LoginTextField(
                  hint: _locale.password,
                  controller: widget.passwordController,
                  obscureText: obscure1,
                  onSubmitted: (value) {
                    if (widget.onSubmit != null) {
                      widget.onSubmit!(value);
                    }
                  },
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
              ),
              const SizedBox(),
              const SizedBox(
                height: 0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget rectangleForm() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: height * 0.6,
            width: width * 0.7,
            decoration: BoxDecoration(
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
              borderRadius: BorderRadius.circular(7),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "BI",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: width * 0.1,
                      fontWeight: FontWeight.bold),
                ),
                Directionality(
                  textDirection: _locale.localeName == "ar"
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  child: LoginTextField(
                    hint: _locale.aliasName,
                    controller: widget.aliasName,
                    onSubmitted: (value) {
                      if (widget.onSubmit != null) {
                        widget.onSubmit!(value);
                      }
                    },
                  ),
                ),
                Directionality(
                  textDirection: _locale.localeName == "ar"
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  child: LoginTextField(
                    hint: _locale.userName,
                    controller: widget.userController,
                    onSubmitted: (value) {
                      if (widget.onSubmit != null) {
                        widget.onSubmit!(value);
                      }
                    },
                  ),
                ),
                Directionality(
                  textDirection: _locale.localeName == "ar"
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  child: LoginTextField(
                    hint: _locale.password,
                    controller: widget.passwordController,
                    obscureText: obscure1,
                    onSubmitted: (value) {
                      if (widget.onSubmit != null) {
                        widget.onSubmit!(value);
                      }
                    },
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
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              clipBehavior: Clip.hardEdge,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                fixedSize: Size(width * 0.7, height * 0.1),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  borderRadius: BorderRadius.circular(7),
                ),
                // elevation: 0,
              ),
              onPressed: widget.onPressed,
              child: Text(
                _locale.login,
                style: TextStyle(
                  color: primary,
                  fontSize: width * 0.05,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
