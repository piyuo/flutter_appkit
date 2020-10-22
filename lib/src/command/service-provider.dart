import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:libcli/command.dart';

/// ServiceProvider provide service
///
class ServiceProvider extends ChangeNotifier {
  /// service instance
  ///
  Service service;

  ServiceProvider(this.service) {
    assert(service != null, 'service must no be null');
  }
}
