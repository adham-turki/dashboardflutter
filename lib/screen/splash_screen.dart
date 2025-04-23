import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SplashScreen extends StatefulWidget {
  bool? isVisible;
  SplashScreen({Key? key, this.isVisible}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: AnimatedOpacity(
          opacity: widget.isVisible! ? 1.0 : 0,
          duration: const Duration(milliseconds: 1200),
          child: SizedBox(
            height: 300,
            width: 300,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Center(child: Image.asset("assets/images/scope_logo.png")),
            ]),
          )),
    );
  }
}
