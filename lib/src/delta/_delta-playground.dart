import 'package:flutter/material.dart';
import 'package:libcli/custom.dart' as custom;
import 'extensions.dart';
import 'web-image.dart';

class DeltaPlayground extends StatelessWidget {
  final GlobalKey btnMenu = GlobalKey();
  final GlobalKey btnTooltip = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Wrap(
          children: [
            SizedBox(width: 800, height: 400, child: _webImage(context)),
            custom.example(
              context,
              text: 'web-image',
              child: _webImage(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _webImage(BuildContext context) {
    return Container(
        color: context.themeColor(ThemeColor(
          light: Colors.white,
          dark: Colors.black87,
        )),
        height: double.infinity,
        child: Row(
          children: [
            SizedBox(
              width: 300,
              height: 300,
              child: WebImage(
                'https://www.apple.com/v/iphone-12/g/images/overview/design/design_compare_skinny__fhvbipafz2my_large.jpg',
              ),
            ),
            SizedBox(width: 20),
            SizedBox(
              width: 300,
              height: 300,
              child: WebImage(
                'https://not-really-exists',
              ),
            )
          ],
        ));
  }
}
