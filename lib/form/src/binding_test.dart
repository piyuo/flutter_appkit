import 'package:flutter_test/flutter_test.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:libcli/sample/sample.dart' as sample;
import 'package:libcli/google/google.dart' as google;
import 'binding.dart';

void main() {
  group('[form_binding]', () {
    test('should convert to form value', () {
      expect(toFormValue('str'), 'str');

      DateTime dateTime = DateTime(2022, 1, 2, 3, 4, 5, 6, 7);
      google.Timestamp timestamp = google.Timestamp.fromDateTime(dateTime.toUtc());
      expect(toFormValue(timestamp), dateTime);
    });

    test('should convert to object value', () {
      expect(toObjectValue('str'), 'str');

      DateTime dateTime = DateTime(2022, 1, 2, 3, 4, 5, 6, 7);
      google.Timestamp timestamp = google.Timestamp.fromDateTime(dateTime.toUtc());
      expect(toObjectValue(dateTime) is google.Timestamp, true);
      expect((toObjectValue(dateTime) as google.Timestamp).toDateTime(), timestamp.toDateTime());
    });

    test('should convert object to form', () {
      final form = fb.group({
        'stringValue': FormControl<String>(value: ''),
        'int32Value': FormControl<int>(value: 0),
        'timestampValue': FormControl<DateTime>(),
      });

      final person = sample.Person();
      person.stringValue = 'ian';
      person.int32Value = 4;
      DateTime dateTime = DateTime(2022, 1, 2, 3, 4, 5, 6, 7);
      person.timestampValue = google.Timestamp.fromDateTime(dateTime.toUtc());

      objectToForm(person, form);
      expect(form.control('stringValue').value, 'ian');
      expect(form.control('int32Value').value, 4);
      expect(form.control('timestampValue').value, dateTime);
    });

    test('should convert form to object', () {
      DateTime dateTime = DateTime(2022, 1, 2, 3, 4, 5, 6, 7);
      google.Timestamp timestamp = google.Timestamp.fromDateTime(dateTime.toUtc());
      final form = fb.group({
        'stringValue': FormControl<String>(value: 'ian'),
        'int32Value': FormControl<int>(value: 4),
        'timestampValue': FormControl<DateTime>(value: dateTime),
      });

      final person = sample.Person();
      formToObject(form, person);
      expect(person.stringValue, 'ian');
      expect(person.int32Value, 4);
      expect(person.timestampValue.toDateTime(), timestamp.toDateTime());
    });
  });
}
