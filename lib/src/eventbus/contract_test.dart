import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/src/eventbus/contract.dart';
import 'package:libcli/src/eventbus/eventbus.dart';

const _here = 'eventbus-contract-test';

main() {
  setUp(() async {
    reset();
  });
  group('[eventbus/contract]', () {
    test('should handle error', () async {
      listen<MockContract>(_here, (_, event) {
        throw 'unhandle exception';
      });
      contract(null, MockContract('c')).then((value) {
        expect(value, false);
      });
    });
  });

  test('should contract', () async {
    var text = '';
    listen<MockContract>(_here, (ctx, event) {
      text = event.text;
      event.complete(true);
    });
    contract(null, MockContract('c')).then((value) {
      expect(value, true);
    });
    expect(text, 'c');
  });
}

class MockContract extends Contract {
  String text;

  MockContract(this.text);
}
