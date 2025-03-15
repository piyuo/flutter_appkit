import 'package:flutter/widgets.dart';

import 'lib_localization.dart';

extension L10nExtension on BuildContext {
  LibLocalization get l => LibLocalization.of(this);
}
