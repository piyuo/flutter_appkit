import 'package:flutter/material.dart';

typedef void GlobalExceptionHandler(BuildContext context, dynamic e, StackTrace stackTrace);

GlobalExceptionHandler _globalExceptionHandler = (BuildContext context, dynamic e, StackTrace s) {};

void set globalExceptionHandler(GlobalExceptionHandler handler) {
  _globalExceptionHandler = handler;
}

void sendToGlobalExceptionHanlder(
  BuildContext context,
  dynamic e,
  StackTrace stackTrace,
) {
  _globalExceptionHandler(context, e, stackTrace);
}
