import 'package:reactive_forms/reactive_forms.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/google/google.dart' as google;

/// toFormValue convert value to use on form
dynamic toFormValue(dynamic value) {
  if (value is google.Timestamp) {
    return value.toDateTime().toLocal();
  }

  return value;
}

/// toObjectValue convert value to use on object
dynamic toObjectValue(dynamic value) {
  if (value is DateTime) {
    return google.Timestamp.fromDateTime(value.toUtc());
  }

  return value;
}

/// objectToForm convert object to form
void objectToForm(pb.Object obj, FormGroup form) {
  for (final key in form.controls.keys) {
    if (obj.isFieldExists(key)) {
      form.control(key).value = toFormValue(obj[key]);
    }
  }
}

/// formToObject convert form to object
void formToObject(FormGroup form, pb.Object obj) {
  for (final key in form.controls.keys) {
    if (obj.isFieldExists(key)) {
      obj[key] = toObjectValue(form.control(key).value);
    }
  }
}
