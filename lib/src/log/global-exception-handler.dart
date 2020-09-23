import 'package:flutter/material.dart';

typedef void GlobalExceptionHandler(
    BuildContext context, dynamic e, StackTrace stackTrace,
    {String errorCode});

GlobalExceptionHandler _globalExceptionHandler =
    (BuildContext context, dynamic e, StackTrace s, {String errorCode}) {};

void set globalExceptionHandler(GlobalExceptionHandler handler) {
  _globalExceptionHandler = handler;
}

void sendToGlobalExceptionHanlder(
    BuildContext context, dynamic e, StackTrace stackTrace,
    {String errorCode}) {
  _globalExceptionHandler(context, e, stackTrace, errorCode: errorCode);
}
