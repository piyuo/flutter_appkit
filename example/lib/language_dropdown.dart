import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:libcli/libcli.dart' as libcli;

class LanguageDropdown extends ConsumerWidget {
  const LanguageDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayLabels = libcli.localeDisplayLabels;
    final locale = ref.watch(libcli.localeProvider);
    final libcliLocalization = libcli.Localization.of(context);
    return DropdownButton<Locale>(
      alignment: AlignmentDirectional.centerEnd,
      borderRadius: BorderRadius.circular(15),
      dropdownColor: Colors.white,
      underline: const SizedBox(),
      value: locale,
      icon: const Icon(Icons.expand_more, color: Colors.black87),
      menuWidth: 300,
      selectedItemBuilder: (BuildContext context) {
        return [
          Row(
            children: [
              const Icon(Icons.language, size: 22),
              const SizedBox(width: 8),
              Text(libcliLocalization.language, style: const TextStyle(fontSize: 15)),
              const SizedBox(width: 8),
            ],
          ),
          ...displayLabels.entries.map<Widget>((language) {
            return Row(
              children: [
                const Icon(Icons.language, size: 22),
                const SizedBox(width: 8),
                Text(libcliLocalization.language, style: const TextStyle(fontSize: 15)),
                const SizedBox(width: 8),
              ],
            );
          })
        ];
      },
      onChanged: (Locale? newValue) => ref.read(libcli.localeProvider.notifier).set(newValue),
      items: [
        DropdownMenuItem<Locale>(
          value: const Locale(' '),
          child: Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Row(
              children: [
                null == locale ? const Icon(Icons.check, size: 22) : const SizedBox(width: 26),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(libcliLocalization.language, style: const TextStyle(fontSize: 15)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        ...displayLabels.entries.map<DropdownMenuItem<Locale>>((entry) {
          final currentLocaleKey = entry.key;
          final currentLocaleName = entry.value;
          final currentLocaleEngName = libcli.localeEngNames[currentLocaleKey] ?? locale.toString();
          final currentLocale = libcli.localeParseString(currentLocaleKey);
          return DropdownMenuItem<Locale>(
            value: currentLocale,
            child: Padding(
              padding: const EdgeInsets.only(top: 4, left: 4),
              child: Row(
                children: [
                  locale == currentLocale ? const Icon(Icons.check, size: 22) : const SizedBox(width: 26),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(currentLocaleName, style: const TextStyle(fontSize: 15)),
                        Text(currentLocaleEngName, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
