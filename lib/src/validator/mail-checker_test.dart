import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/validator.dart' as validator;

void main() {
  setUp(() async {});

  group('[mail_checker]', () {
    test('should suggest correct domain', () async {
      var suggest = validator.MailChecker(email: "me@hotwail.com").suggest();
      expect(suggest!.full, "me@hotmail.com");

      suggest = validator.MailChecker(email: "me@qql.com").suggest();
      expect(suggest!.full, "me@qq.com");

      suggest = validator.MailChecker(email: "").suggest();
      expect(suggest, null);

      suggest = validator.MailChecker(email: "a").suggest();
      expect(suggest, null);
    });
  });
}
