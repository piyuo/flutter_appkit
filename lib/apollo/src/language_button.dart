import 'package:flutter/material.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:provider/provider.dart';
import 'package:libcli/global/global.dart' as global;

/// LanguageButton show language pop menu let user change language
class LanguageButton extends StatelessWidget {
  const LanguageButton({
    this.offset = const Offset(50, 58),
    super.key,
  });

  /// offset is offset of pop menu
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    return Consumer<global.LanguageProvider>(builder: (context, languageProvider, _) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: PopupMenuButton<String>(
            splashRadius: 0,
            initialValue: i18n.locale.toString(),
            tooltip: 'Change Language',
            onSelected: (String value) async => await languageProvider.changeLocale(i18n.stringToLocale(value)),
            offset: const Offset(60, 54),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            itemBuilder: (BuildContext context) => i18n.supportedLocales.map(
                  (locale) {
                    return PopupMenuItem<String>(
                      value: locale.toString(),
                      child: ListTile(
                        leading: i18n.locale == locale ? const Icon(Icons.check) : const SizedBox(),
                        title: Text(i18n.lookupLanguage(locale)),
                      ),
                    );
                  },
                ).toList(),
            child: Row(children: [
              const Icon(Icons.language),
              const SizedBox(width: 8),
              Text(i18n.lookupLanguage(i18n.locale)),
              const Icon(Icons.arrow_drop_down),
            ])),
      );
    });
  }
}
