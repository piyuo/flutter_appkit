import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/src/command/guard.dart';

void main() {
  setUp(() async {
    guardRecords = [];
  });

  group('[guard]', () {
    test('should pass with record', () async {
      var result = guardCheck(MockGuardCommand().runtimeType, GuardRule());
      expect(result, 0);
      expect(guardRecords.length, 1);
      expect(guardRecords[0].commandType, MockGuardCommand().runtimeType);
    });

    test('should violate rule1', () async {
      var guardRule = GuardRule(
        duration1: Duration(seconds: 5),
        count1: 2,
        duration2: Duration.zero,
        count2: 0,
      );

      var issueA = guardCheck(MockGuardCommand().runtimeType, guardRule);
      expect(issueA, 0);
      var issueB = guardCheck(MockGuardCommand().runtimeType, guardRule);
      expect(issueB, 0);
      var issueC = guardCheck(MockGuardCommand().runtimeType, guardRule);
      expect(issueC, 1);
      expect(guardRecords.length, 2);
    });

    test('should violate rule2', () async {
      var guardRule = GuardRule(
        duration1: Duration.zero,
        count1: 0,
        duration2: Duration(seconds: 10),
        count2: 2,
      );

      var issueA = guardCheck(MockGuardCommand().runtimeType, guardRule);
      expect(issueA, 0);
      var issueB = guardCheck(MockGuardCommand().runtimeType, guardRule);
      expect(issueB, 0);
      var issueC = guardCheck(MockGuardCommand().runtimeType, guardRule);
      expect(issueC, 2);
      expect(guardRecords.length, 2);
    });

    test('should remove unused record', () async {
      var guardRule = GuardRule(
        duration1: Duration(milliseconds: 100),
        count1: 10,
        duration2: Duration.zero,
        count2: 0,
      );

      // 10 command should ok
      for (int i = 0; i < 10; i++) {
        var issue = guardCheck(MockGuardCommand().runtimeType, guardRule);
        expect(issue, 0);
      }
      expect(guardRecords.length, 10);
      // the 11 should violet rule
      var issue = guardCheck(MockGuardCommand().runtimeType, guardRule);
      expect(issue, 1);
      expect(guardRecords.length, 10);

      await Future.delayed(const Duration(milliseconds: 100));
      //after sleep it should be fine
      issue = guardCheck(MockGuardCommand().runtimeType, guardRule);
      expect(issue, 0);
      expect(guardRecords.length, 1);
    });
  });
}

class MockGuardCommand {}
