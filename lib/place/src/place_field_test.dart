import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:libcli/form/form.dart' as form;
import 'package:libcli/types/types.dart' as types;
import 'package:libcli/assets/assets.dart' as asset;
import 'place_field.dart';
import 'show_search.dart';

void main() {
  final _keyForm = GlobalKey<FormState>();

  final placeController = ValueNotifier<types.Place?>(null);

  final place2Controller = TextEditingController();

  final FocusNode placeFocus = FocusNode();

  final FocusNode place2Focus = FocusNode();

  setUp(() {
    // ignore: invalid_use_of_visible_for_testing_member
    asset.mock('{"enterAddr":""}');
  });

  Widget testTarget() {
    return MaterialApp(
      home: Scaffold(
        body: Form(
          key: _keyForm,
          child: Column(
            children: [
              PlaceField(
                key: const Key('test-place'),
                controller: placeController,
                label: 'Address',
                focusNode: placeFocus,
                nextFocusNode: place2Focus,
                requiredField: true,
              ),
              form.InputField(
                key: const Key('test-place2'),
                controller: place2Controller,
                focusNode: place2Focus,
                hint: '(Optional) Floor/Room/Building number',
              ),
              form.Submit(
                key: const Key('submit'),
                label: 'submit',
                formKey: _keyForm,
                onPressed: () async {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  group('[place-field]', () {
    testWidgets('should show search', (WidgetTester tester) async {
      await tester.pumpWidget(testTarget());

      // show search
      await tester.tap(find.byType(PlaceField));
      await tester.pumpAndSettle();
      expect(find.byType(ShowSearch), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);

      // enter address
      //final inputAddress = find.byType(TextField);
      //await tester.enterText(inputAddress, '2141 spectrum');
      //await tester.pumpAndSettle();

      // can't test list view, cause mock http client will not connect to remote server
      //await tester.pump(Duration(seconds: 4));
      //expect(find.byType(ListView), findsOneWidget);
    });
  });
}
