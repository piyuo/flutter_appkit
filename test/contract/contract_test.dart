import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/contract/contract.dart' as contract;
import 'mock_listener.dart';

void main() {
  group('contract', () {
    test('should add remove listener', () {
      MockListener listener = MockListener(true);
      expect(contract.listenerCount(), 0);
      contract.addListener(listener);
      expect(contract.listenerCount(), 1);
      contract.removeListener(listener);
      expect(contract.listenerCount(), 0);
      contract.removeAllListener();
    });

    test('should broadcast event', () {
      MockListener listener = MockListener(true);
      contract.addListener(listener);
      expect(contract.listenerCount(), 1);
      expect(listener.latestEvent, null);

      MockEvent event = MockEvent();
      contract.brodcast(event);
      expect(listener.latestEvent == event, true);
      contract.removeAllListener();
    });

    test('should open contract', () async {
      MockListener listener = MockListener(true);
      contract.addListener(listener);
      expect(contract.listenerCount(), 1);
      expect(listener.latestContract, null);

      MockContract c = MockContract();
      var ok = await contract.open(c);
      expect(listener.latestContract == c, true);
      expect(ok, true);
      contract.removeAllListener();
    });
  });
}
