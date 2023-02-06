import 'package:flutter_test/flutter_test.dart';
//import 'package:flutter/material.dart';
//import 'package:libcli/form/form.dart' as form;
import 'package:libcli/assets/assets.dart' as asset;
//import 'package:reactive_forms/reactive_forms.dart';
//import 'place_field.dart';
//import 'show_search.dart';

void main() {
  setUp(() {
    // ignore: invalid_use_of_visible_for_testing_member
    asset.mock('{"enterAddr":""}');
  });
/*
  Widget testTarget(FormGroup formGroup) {
    return MaterialApp(
      home: Scaffold(
        body: ReactiveForm(
          formGroup: formGroup,
          child: Column(
            children: [
              PlaceField(
                formControlName: 'place',
              ),
              form.Submit(
                label: 'submit',
                onPressed: () async {},
              ),
            ],
          ),
        ),
      ),
    );
  }
*/
  group('[place_field]', () {
    testWidgets('should show search', (WidgetTester tester) async {
/*      final form = fb.group({
        'email': [''],
      });

      await tester.pumpWidget(testTarget(form));

      // show search
      await tester.tap(find.byType(PlaceField));
      await tester.pumpAndSettle();
      expect(find.byType(ShowSearch), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
*/
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
