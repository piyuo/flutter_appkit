import 'package:flutter/material.dart';
import 'package:libcli/delta.dart' as delta;
import 'dynamic-bottom-side.dart';
import 'wrapped-list-view.dart';
import 'play.dart';
import 'slideshow.dart';
import 'wall.dart';

class CustomPlayground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Wrap(
            children: [
              SizedBox(
                width: double.infinity,
//              height: 400,
                child: _wall(context),
              ),
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
                text: 'slideshow',
                child: _slideshow(context),
              ),
              example(
                context,
                text: 'wall',
                child: _wall(context),
              ),
            ],
          ),
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

  Widget _slideshow(BuildContext context) {
    return Slideshow(
      urls: [
        'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/imac-24-touch-id-blue-gallery-1?wid=2000&hei=1536&fmt=jpeg&qlt=95&.v=1617486478000',
        'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/imac-24-touch-id-blue-gallery-2?wid=2000&hei=1536&fmt=jpeg&qlt=95&.v=1617741434000',
        'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/imac-24-touch-id-blue-gallery-3?wid=2000&hei=1536&fmt=jpeg&qlt=95&.v=1617741419000',
      ],
    );
  }

  Widget _wall(BuildContext context) {
    return Wall(
      tiles: [
        listTile(
          children: [
            listTitle('Popular'),
            listItem(
              imageUrl:
                  'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/imac-24-touch-id-blue-gallery-1?wid=2000&hei=1536&fmt=jpeg&qlt=95&.v=1617486478000',
              title: 'iMac 1',
              text1: 'first M1 iMac',
              text2: '\$999',
            ),
            listItem(
              imageUrl:
                  'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/imac-24-touch-id-blue-gallery-1?wid=2000&hei=1536&fmt=jpeg&qlt=95&.v=1617486478000',
              title: 'iMac 1',
              text1: 'first M1 iMac',
              text2: '\$999',
            ),
            listItem(
              imageUrl:
                  'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/imac-24-touch-id-blue-gallery-1?wid=2000&hei=1536&fmt=jpeg&qlt=95&.v=1617486478000',
              title: 'iMac 1',
              text1: 'first M1 iMac',
              text2: '\$999',
            ),
          ],
        ),
        buttonTile(
          delta.CustomIcons.takeoutDining,
          text: 'Take out',
          description: 'my take out order',
          iconColor: Colors.red[700],
        ),
        buttonTile(
          delta.CustomIcons.deliveryDining,
          text: 'Dine in',
          description: 'my dine in order',
          iconColor: Colors.blue[700],
        ),
        buttonTile(
          delta.CustomIcons.qrCode,
          x: 6,
          y: 4,
          description: 'QR Code',
          iconColor: Colors.grey,
        ),
        linkTile(
          x: 10,
          text: 'Coupon',
          description: 'check your coupon',
          next: true,
          color: Colors.black,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.green[300]!,
                Colors.yellow[200]!,
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
          icon: delta.CustomIcons.place,
          iconColor: Colors.red,
        ),
        imageTile(
          'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/imac-24-touch-id-blue-gallery-1?wid=2000&hei=1536&fmt=jpeg&qlt=95&.v=1617486478000',
          x: 16,
          y: 16,
        ),
        Tile(
          builder: (_) => SizedBox(),
          onTap: () => print('1'),
        ),
        Tile(
          x: 8,
          y: 4,
          builder: (_) => SizedBox(),
        ),
        Tile(
          x: 4,
          y: 8,
          builder: (_) => SizedBox(),
        ),
      ],
    );
  }
}
