import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/utils/mail_checker.dart';

void main() {
  setUp(() async {});

  group('[mail_checker]', () {
    test('should suggest correct domain', () async {
      var suggest = MailChecker("me@hotwail.com").suggest();
      expect(suggest.full, "me@hotmail.com");

      suggest = MailChecker("me@qql.com").suggest();
      expect(suggest.full, "me@qq.com");

      suggest = MailChecker("").suggest();
      expect(suggest, null);

      suggest = MailChecker("a").suggest();
      expect(suggest, null);
    });
  });
}
