import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:libcli/app/app.dart' as app;
import 'package:libcli/testing/testing.dart' as testing;
import '../layout.dart';

main() => app.start(
      appName: 'layout example',
      routes: (_) => const LayoutExample(),
    );

final sidePanelProvider = SidePanelProvider();

class LayoutExample extends StatelessWidget {
  const LayoutExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(child: _paddingToTablet(context)),
      Wrap(
        children: [
          testing.example(
            context,
            text: 'padding to tablet',
            child: _paddingToTablet(context),
          ),
          testing.example(
            context,
            text: 'layout dynamic bottom side',
            child: _layoutDynamicBottomSide(context),
          ),
          testing.example(
            context,
            text: 'hide in phone',
            child: _hideInPhone(context),
          ),
          testing.example(
            context,
            text: 'sliver scaffold',
            child: _sliverScaffold(context),
            useScaffold: false,
          ),
          testing.example(
            context,
            text: 'wrapped-list-view',
            child: _wrappedListView(context),
          ),
          testing.example(
            context,
            text: 'slideshow',
            child: _slideshow(context),
          ),
          testing.example(
            context,
            text: 'wall',
            child: _wall(context),
          ),
          testing.example(
            context,
            text: 'side panel',
            child: _sidePanel(context),
          ),
          testing.example(
            context,
            text: 'story line',
            child: _storyLine(context),
          ),
        ],
      )
    ]);
  }

  Widget _paddingToTablet(BuildContext context) {
    return Container(
      margin: paddingToTablet(context),
      color: Colors.red,
      height: 200,
    );
  }

  Widget _hideInPhone(BuildContext context) {
    return const HideInPhone(
      child: Text('hide this when in phone layout'),
    );
  }

  Widget _sliverScaffold(BuildContext context) {
    return SliverScaffold(
      padding: const EdgeInsets.all(10),
      appBarPadding: const EdgeInsets.all(10),
      appBar: SliverAppBar(
        pinned: true,
        backgroundColor: Colors.blue.withOpacity(0.5),
      ),
      children: [
        Container(
          height: 200,
          color: Colors.red,
          child: const Text('hello1'),
        ),
        Container(
          height: 200,
          color: Colors.green,
          child: const Text('hello1'),
        ),
        Container(
          height: 200,
          color: Colors.yellow,
          child: const Text('hello3'),
        ),
        Container(
          height: 200,
          color: Colors.orange,
          child: const Text('hello4'),
        ),
      ],
    );
  }

  Widget _layoutDynamicBottomSide(BuildContext context) {
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

  Widget _wrappedListView(BuildContext context) {
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
    return const Slideshow(
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
          Icons.takeout_dining,
          text: 'Take out',
          description: 'my take out order',
          iconColor: Colors.red[700],
        ),
        buttonTile(
          Icons.delivery_dining,
          text: 'Dine in',
          description: 'my dine in order',
          iconColor: Colors.blue[700],
        ),
        buttonTile(
          Icons.qr_code,
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
              stops: const [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
          icon: Icons.place,
          iconColor: Colors.red,
        ),
        imageTile(
          'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/imac-24-touch-id-blue-gallery-1?wid=2000&hei=1536&fmt=jpeg&qlt=95&.v=1617486478000',
          x: 16,
          y: 16,
        ),
        Tile(
          builder: (_) => const SizedBox(),
          onTap: () => debugPrint('1'),
        ),
        Tile(
          x: 8,
          y: 4,
          builder: (_) => const SizedBox(),
        ),
        Tile(
          x: 4,
          y: 8,
          builder: (_) => const SizedBox(),
        ),
      ],
    );
  }

  Widget _sidePanel(BuildContext context) {
    return SizedBox(
        height: 600,
        child: ChangeNotifierProvider<SidePanelProvider>.value(
            value: sidePanelProvider,
            child: Column(
              children: [
                ElevatedButton(
                    child: const Text('toggle'),
                    onPressed: () {
                      sidePanelProvider.setOpen(!sidePanelProvider.opened);
                    }),
                Expanded(
                  child: SidePanel(
                    //autoHide: true,
                    sideWidth: 250,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: const Alignment(1, 1), // 10% of the width, so there are ten blinds.
                        colors: [
                          Colors.green[100]!,
                          Colors.green[900]!,
                        ], // red to yellow
                        tileMode: TileMode.repeated, // repeats the gradient over the canvas
                      ),
                    ),
                    sideWidget: const SizedBox(
                      height: double.infinity,
                      child: Text(
                        'side widget',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                    mainWidget: Scaffold(
                      appBar: AppBar(
                        actions: [
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => Scaffold(
                                        appBar: AppBar(
                                          title: const Text('child window'),
                                        ),
                                        body: const SafeArea(
                                          child: Text('hello'),
                                        )),
                                  ));
                            },
                          ),
                        ],
                      ),
                      body: Container(
                        color: Colors.white,
                        width: double.infinity,
                        height: double.infinity,
                        child: Column(
                          children: [
                            ElevatedButton(
                                child: const Text('test'),
                                onPressed: () {
                                  //print('hello');
                                }),
                            const Text('hello'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )));
  }

  Widget _storyLine(BuildContext context) {
    return StoryLine(
        title: 'Notification',
        subtitle: 'open',
        onPullRefresh: (BuildContext context) async {
          await Future.delayed(const Duration(seconds: 1));
        },
        onLoadMore: (BuildContext context) async {
          await Future.delayed(const Duration(seconds: 1));
        },
        stories: [
          SimpleStory(
            utcDate: DateTime.now().toUtc(),
            icon: Icons.takeout_dining,
            text: 'you have new takeout order',
            title: 'pork rice, beef noddle and more ...',
            color: Colors.red[700]!,
          ),
          SimpleStory(
            utcDate: DateTime.now().toUtc(),
            icon: Icons.bookmark,
            text: 'Someone asking question about',
            title: 'Pork Rice',
            color: Colors.blue[700]!,
          ),
          SimpleStory(
            utcDate: DateTime.now().toUtc(),
            icon: Icons.card_giftcard,
            text: 'Order delivered',
            title: 'pork rice, beef noodle and more',
            color: Colors.green[700]!,
          ),
          //Story(utcDate: DateTime.now().add(Duration(hours: -1)).toUtc(), key: 'order2'),
          //Story(utcDate: DateTime.now().add(Duration(hours: -1)).toUtc(), key: 'order3'),
          //Story(utcDate: DateTime.now().add(Duration(hours: -1)).toUtc(), key: 'order4'),
          //Story(utcDate: DateTime.now().add(Duration(days: -1)).toUtc(), key: 'order5'),
        ],
        builder: SimpleStory.builder);
  }
}
