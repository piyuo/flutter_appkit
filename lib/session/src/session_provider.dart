import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class SessionProvider with ChangeNotifier {
  SessionProvider();

  String? region;

  String? accessToken;

  DateTime? accessTokenExpired;

  String? refreshToken;

  DateTime? refreshTokenExpired;
}
