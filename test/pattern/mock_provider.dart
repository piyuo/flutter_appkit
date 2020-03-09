import 'dart:async';
import 'package:libcli/pattern/async_provider.dart';

class MockProvider extends AsyncProvider {
  @override
  Future<void> load() async {
    await Future.delayed(Duration(milliseconds: 1), () {});
  }
}
