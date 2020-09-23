import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:libcli/services.dart' as services;
import 'package:libcli/i18n.dart' as i18n;

const _here = 'command_http_header';

Future<Map<String, String>> doRequestHeaders() async {
  Map<String, String> headers = {
    'Content-Type': 'multipart/form-data',
    'accept': '',
  };

  var accessToken = await services.getAccessToken();
  if (accessToken.length > 0) {
    debugPrint('$_here~accessToken=$accessToken');
    headers['Cookie'] = accessToken;
  }
  headers['Accept-Language'] = i18n.localeID;
  return headers;
}

Future<void> doResponseHeaders(Map<String, String> headers) async {
  var c = headers['set-cookie'];
  if (c != null && c.length > 0) {
    debugPrint('$_here~refresh accessToken=$c');
    services.setAccessToken(c);
  }
}
