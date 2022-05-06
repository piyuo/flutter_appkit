import 'dart:async';
import 'package:flutter/material.dart';

/// SearchTrigger trigger search event when text editing
class SearchTrigger {
  SearchTrigger({
    required this.controller,
    required this.onSearch,
    this.onSearchBegin,
    this.onSearchEnd,
  }) {
    controller.addListener(_callback);
  }

  /// controller is text editing controller
  final TextEditingController controller;

  /// onSearch called when text need to be search
  final void Function(String text) onSearch;

  /// onSearchBegin called when text is editing and search begin
  final VoidCallback? onSearchBegin;

  /// onSearchEnd called when text is clear and search end
  final VoidCallback? onSearchEnd;

  /// _timer is timer to fire search event when text is editing
  Timer? _timer;

  /// _lastText is last text
  String _lastText = '';

  /// dispose controller
  void dispose() {
    controller.removeListener(_callback);
  }

  /// _callback trigger when text editing
  void _callback() {
    if (onSearchBegin != null && _lastText.isEmpty && controller.text.isNotEmpty) {
      onSearchBegin!();
    }
    if (onSearchEnd != null && _lastText.isNotEmpty && controller.text.isEmpty) {
      onSearchEnd!();
    }
    _lastText = controller.text;

    if (_timer != null) {
      _timer!.cancel();
    }

    final searchText = controller.text.trim();
    if (searchText.isNotEmpty) {
      _timer = Timer(const Duration(milliseconds: 700), () {
        _timer = null;
        onSearch(searchText);
      });
    }
  }
}
