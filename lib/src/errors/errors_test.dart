import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:libcli/i18n.dart';
import 'package:libcli/src/dialogs/dialogs.dart';
import 'package:libcli/src/errors/errors.dart';

void main() {
  final GlobalKey keyBtn = GlobalKey();

  setUp(() async {
    initGlobalTranslation('en', 'US');
  });

  Widget createSample({
    required void Function(BuildContext context, Dialogs provider) onPressed,
  }) {
    return CupertinoApp(
      navigatorKey: dialogsNavigatorKey,
      home: Provider(
        create: (_) => Dialogs(),
        child: Consumer<Dialogs>(
          builder: (context, provider, child) => CupertinoButton(
            key: keyBtn,
            child: Text('button'),
            onPressed: () => onPressed(context, provider),
          ),
        ),
      ),
    );
  }

  group('[errors]', () {
    testWidgets('should show alert when catch exception', (WidgetTester tester) async {
      await tester.pumpWidget(
        createSample(onPressed: (context, provider) {
          watch(() => throw Exception('mock exception'));
        }),
      );
      expect(find.byType(CupertinoButton), findsOneWidget);
      await tester.tap(find.byType(CupertinoButton));
      await tester.pumpAndSettle();
      expect(find.byType(CupertinoAlertDialog), findsOneWidget);
    });
  });
}
