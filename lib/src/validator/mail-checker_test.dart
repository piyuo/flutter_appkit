import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/validator.dart' as validator;

void main() {
  setUp(() async {});

  group('[mail_checker]', () {
    test('should suggest correct domain', () async {
      var suggest = validator.MailChecker("me@hotwail.com").suggest();
      expect(suggest.full, "me@hotmail.com");

      suggest = validator.MailChecker("me@qql.com").suggest();
      expect(suggest.full, "me@qq.com");

      suggest = validator.MailChecker("").suggest();
      expect(suggest, null);

      suggest = validator.MailChecker("a").suggest();
      expect(suggest, null);
    });
  });
}
