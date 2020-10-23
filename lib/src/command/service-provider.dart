import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// ServiceProvider provide service
///
class ServiceProvider extends ChangeNotifier {
  /// service instance
  ///
  final Map services;

  ServiceProvider(this.services) {
    assert(services != null, 'service must no be null');
    assert(services.length > 0, 'services must have a leat one service');
  }
}
