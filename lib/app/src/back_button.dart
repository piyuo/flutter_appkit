import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'page_route.dart';

Widget? backButton(BuildContext context) {
  if (kIsWeb && canPop) {
    return IconButton(
      icon: Icon(openByNewTab ? Icons.close : Icons.arrow_back_ios_new),
      onPressed: () => pop(context),
    );
  }
  return null;
}
