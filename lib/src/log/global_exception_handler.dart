import 'package:flutter/material.dart';

typedef void GlobalExceptionHandler(
    BuildContext context, dynamic e, StackTrace stackTrace,
    {String errorCode});

GlobalExceptionHandler _globalExceptionHandler;

void set globalExceptionHandler(GlobalExceptionHandler handler) {
  _globalExceptionHandler = handler;
}

void sendToGlobalExceptionHanlder(
    BuildContext context, dynamic e, StackTrace stackTrace,
    {String errorCode}) {
  assert(_globalExceptionHandler != null,
      'need set log.globalExceptionHandler first');
  if (_globalExceptionHandler != null) {
    _globalExceptionHandler(context, e, stackTrace, errorCode: errorCode);
  }
}
