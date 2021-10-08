import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:silkroute/l10n/l10n.dart';
import 'package:silkroute/provider/locale_provider.dart';
import 'package:provider/provider.dart';

class LanguagePickerWidget extends StatefulWidget {
  _LanguagePickerWidgetState createState() => _LanguagePickerWidgetState();
}

class _LanguagePickerWidgetState extends State<LanguagePickerWidget> {
  LocalStorage storage = LocalStorage('organic');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);
    final locale = provider.locale ?? Locale('en');
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 0.5,
        ),
      ),
      width: MediaQuery.of(context).size.width * 0.7,
      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.01),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          isExpanded: true,
          value: locale,
          icon: Icon(Icons.arrow_downward),
          items: L10n.all.map(
            (locale) {
              final flag = L10n.getFlag(locale.languageCode);

              return DropdownMenuItem(
                child: Container(
                  child: Text(
                    flag,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                value: locale,
                onTap: () {
                  final provider =
                      Provider.of<LocaleProvider>(context, listen: false);
                  storage.setItem('language', locale.toString());
                  print("Language -- ${storage.getItem('language')}");
                  provider.setLocale(locale);
                },
              );
            },
          ).toList(),
          onChanged: (_) {},
        ),
      ),
    );
  }
}
