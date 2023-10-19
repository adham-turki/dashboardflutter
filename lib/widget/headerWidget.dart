import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../components/customCard.dart';

class HeaderWidget extends StatefulWidget {
  const HeaderWidget({super.key});

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  late AppLocalizations _locale;
  // var utils = Components();
  var storage = const FlutterSecureStorage();

  @override
  Future<void> didChangeDependencies() async {
    _locale = AppLocalizations.of(context);
    // String user = "";
    // await storage.read(key: "user").then((value) {
    //   Settings.user = value!;
    // });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CustomCard(
              gradientColor: [Colors.blue, Colors.green],
              title: 'Kiser',
              subtitle: 'Mon-Fri',
              label: 'title11',
              icon: Icons.abc, // Provide the actual path to the icon
            ),
            SizedBox(
              width: 10,
            ),
            CustomCard(
              gradientColor: [Colors.black, Colors.grey],
              title: 'Kiser',
              subtitle: 'Mon-Fri',
              label: 'title11',
              icon: Icons.abc, // Provide the actual path to the icon
            ),
            SizedBox(
              width: 10,
            ),
            CustomCard(
              gradientColor: [Colors.red, Colors.yellow],
              title: 'Kiser',
              subtitle: 'Mon-Fri',
              label: 'title11',
              icon: Icons.abc, // Provide the actual path to the icon
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width < 800
              ? MediaQuery.of(context).size.width * 0.9
              : MediaQuery.of(context).size.width * 0.7,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Row(
              //   children: [
              //     SelectableText(
              //       maxLines: 1,
              //       "${_locale.welcome}:",
              //       style: utils.sixteen500TextStyle(Colors.black),
              //     ),
              //     getUser()
              //   ],
              // ),
              // Row(
              //   children: [
              //     SelectableText(
              //       maxLines: 1,
              //       "${_locale.baseCurrency}:",
              //       style: utils.sixteen500TextStyle(Colors.black),
              //     ),
              //     SelectableText(
              //       maxLines: 1,
              //       " ${_locale.ils}",
              //       style: utils.sixteen500TextStyle(Colors.blue),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ],
    );
  }

  // FutureBuilder getUser() {
  //   return FutureBuilder(
  //     future: storage.read(key: "user").then((value) {
  //       Settings.user = value!;
  //     }),
  //     builder: (context, snapshot) {
  //       return SelectableText(
  //         maxLines: 1,
  //         " ${Settings.user}",
  //         style: utils.sixteen500TextStyle(Colors.blue),
  //       );
  //     },
  //   );
  // }
}
