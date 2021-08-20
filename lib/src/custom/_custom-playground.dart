import 'package:flutter/material.dart';
import 'dynamic-bottom-side.dart';
import 'wrapped-list-view.dart';
import 'web-image.dart';
import 'play.dart';

class CustomPlayground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Wrap(
          children: [
            example(
              context,
              text: 'layout-dynamic-bottom-side',
              child: _layoutDynamicBottomSide(),
            ),
            example(
              context,
              text: 'wrapped-list-view',
              child: _wrappedListView(),
            ),
            example(
              context,
              text: 'web-image',
              child: _webImage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _layoutDynamicBottomSide() {
    return DynamicBottomSide(
      leftBuilder: () => Container(
        color: Colors.red,
        width: 200,
      ),
      centerBuilder: () => Container(color: Colors.yellow),
      sideBuilder: () => Container(
        color: Colors.blue,
        width: 300,
      ),
      bottomBuilder: () => Container(
        color: Colors.green,
        height: 100,
      ),
    );
  }

  Widget _wrappedListView() {
    return WrappedListView(
      children: [
        Wrapped(
          title: Container(
            width: double.infinity,
            height: 80,
            color: Colors.red,
          ),
          children: [
            Container(
              color: Colors.blue,
            ),
            Container(
              color: Colors.yellow,
            ),
            Container(
              color: Colors.green,
            ),
            Container(
              color: Colors.orange,
            ),
          ],
        ),
        Wrapped(
          title: Container(
            width: double.infinity,
            height: 80,
            color: Colors.yellow,
          ),
          children: [
            Container(
              color: Colors.green,
            ),
            Container(
              color: Colors.yellow,
            ),
            Container(
              color: Colors.orange,
            ),
            Container(
              color: Colors.black,
            ),
          ],
        ),
      ],
    );
  }

  Widget _webImage() {
    return Container(
        color: Colors.white,
        height: double.infinity,
        child: Row(
          children: [
            WebImage(
              url:
                  'https://www.apple.com/v/iphone-12/g/images/overview/design/design_compare_skinny__fhvbipafz2my_large.jpg',
              width: 300,
              height: 300,
//              borderColor: Colors.red,
            ),
            SizedBox(width: 20),
            WebImage(
              url: 'https://not-really-exists',
              width: 300,
              height: 300,
            ),
          ],
        ));
  }
}
