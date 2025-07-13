/*import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:libcli/src/locale.dart';

/// Example widget showing how to use the locale Riverpod provider
class LocaleExample extends ConsumerWidget {
  const LocaleExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the locale provider - this will rebuild when locale changes
    final currentLocale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Locale Example'),
      ),
      body: Column(
        children: [
          Text('Current Locale: ${currentLocale?.toString() ?? 'System Default'}'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              // Example: Change locale to English
              await updateLocale(ref, const Locale('en'));
            },
            child: const Text('Set English'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              // Example: Change locale to Spanish
              await updateLocale(ref, const Locale('es'));
            },
            child: const Text('Set Spanish'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              // Example: Reset to system locale
              await updateLocale(ref, null);
            },
            child: const Text('Reset to System'),
          ),
        ],
      ),
    );
  }
}

/// Example of how to use the locale provider in a regular StatefulWidget
/// by wrapping it with Consumer
class LocaleDisplayWidget extends StatelessWidget {
  const LocaleDisplayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final locale = ref.watch(localeProvider);
        return Text(
          'Current Language: ${locale?.languageCode ?? 'system'}',
          style: Theme.of(context).textTheme.headlineSmall,
        );
      },
    );
  }
}
*/
