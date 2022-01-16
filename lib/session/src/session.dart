import 'package:flutter/material.dart';
import 'session_provider.dart';

/// getAccessToken return access token if session is valid, it will refresh access token if expired
///
///     final token = await session.getAccessToken(context);
///
Future<String?> getAccessToken(BuildContext context) async => SessionProvider.of(context).getAccessToken(context);
