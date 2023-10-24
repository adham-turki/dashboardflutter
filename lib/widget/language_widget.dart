import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../provider/local_provider.dart';
import 'circle_flags.dart';

class LanguageWidget extends StatefulWidget {
  final void Function(Locale)? onLocaleChanged;
  final Color color;
  const LanguageWidget({Key? key, this.onLocaleChanged, required this.color})
      : super(key: key);

  @override
  State<LanguageWidget> createState() => _LanguageWidgetState();
}

class _LanguageWidgetState extends State<LanguageWidget> {
  late AppLocalizations _local;
  late LocaleProvider _localeProvider;
  List<Widget> lang = [];
  List<Widget> lang2 = [];

  @override
  void didChangeDependencies() {
    _localeProvider = Provider.of<LocaleProvider>(context);
    _local = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    lang = getWidget(Colors.black);

    String initialFlag;
    if (_localeProvider.locale.languageCode == 'ar') {
      initialFlag = 'ar';
    } else {
      initialFlag = 'en';
    }

    return DropdownButton(
      // style: TextStyle,
      value: initialFlag,
      selectedItemBuilder: (_) {
        return getWidget(widget.color).map((e) => e).toList();
      },
      // icon: const Icon(Icons.arrow_downward),
      items: [
        DropdownMenuItem(value: 'en', child: lang[0]),
        DropdownMenuItem(value: 'ar', child: lang[1]),
      ],
      underline: Container(),

      onChanged: (value) async {
        Locale newLocale = Locale(value!);
        widget.onLocaleChanged!(newLocale);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('selectedLanguage', value);
      },
    );
  }

  List<Widget> getWidget(Color color) {
    return [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CircleFlag(
              'us',
              size: MediaQuery.of(context).size.width > 800
                  ? MediaQuery.of(context).size.height * 0.03
                  : MediaQuery.of(context).size.height * 0.02,
            ),
            const SizedBox(width: 10),
            Text(
              _local.dropLangEN,
              style: TextStyle(
                // backgroundColor: Colors.black,
                color: color,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CircleFlag(
              'ps',
              size: MediaQuery.of(context).size.width > 800
                  ? MediaQuery.of(context).size.height * 0.03
                  : MediaQuery.of(context).size.height * 0.02,
            ),
            const SizedBox(width: 10),
            Text(
              _local.dropLangAR,
              style: TextStyle(
                color: color,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    ];
  }
}
