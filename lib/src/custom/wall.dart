import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:libcli/delta.dart' as delta;
import 'package:auto_size_text/auto_size_text.dart';

const double elevation = 8;

class Tile extends StatelessWidget {
  /// Tile basic unit is 16
  const Tile({
    required this.builder,
    this.x = 8,
    this.y = 8,
    this.cardView = true,
    this.onTap,
    Key? key,
  }) : super(key: key);

  /// The number of cells occupied in the cross axis.
  final int x;

  /// The number of cells occupied in the main axis.
  final double y;

  /// builder to build tile content
  final WidgetBuilder builder;

  /// cardView is true will draw a card around tile
  final bool cardView;

  /// onTap will call when tile has been tapped
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    var borderColor = Theme.of(context).primaryColor.withOpacity(0.9);
    const shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
      //side: BorderSide(width: 5, color: Colors.green),
    );

    var child = cardView
        ? Card(
            elevation: elevation,
            shape: shape,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: builder(context),
          )
        : builder(context);

    return onTap != null
        ? InkWell(
            onTap: onTap,
            child: child,
            customBorder: shape,
            splashColor: borderColor,
          )
        : child;
  }
}

class Wall extends StatelessWidget {
  /// Wall is use 16 unit as single tile, wall size is 16 on phone, 32 on table, 64 on desktop
  const Wall({
    required this.tiles,
    Key? key,
  }) : super(key: key);

  final List<Tile> tiles;

  int _determineCrossAxisCount(double windowWidth) {
    // -100 make sure when layout change, tile will be big enough
    switch (delta.deviceLayout(windowWidth - 200)) {
      case delta.DeviceLayout.phone:
        return 16;
      case delta.DeviceLayout.tablet:
        return 32;
      default:
        return 64;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      int crossAxisCount = _determineCrossAxisCount(constraints.maxWidth);
      var grid = StaggeredGridView.countBuilder(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        shrinkWrap: true,
        controller: ScrollController(), // override default controller, we don't wall scroll
        itemCount: tiles.length,
        itemBuilder: (BuildContext context, int index) => tiles[index],
        staggeredTileBuilder: (int index) {
          var entry = tiles[index];
          int cross = entry.x;
          if (cross == -1) {
            cross = crossAxisCount;
          }
          return StaggeredTile.count(cross, entry.y);
        },
      );

      if (crossAxisCount == 32) {
        // force redraw grid when 32->64
        return Column(children: [grid]);
      }
      return grid;
    });
  }
}

/// buttonTile create button style tile
Tile buttonTile(
  IconData icon, {
  Color? iconColor,
  int x = 8,
  double y = 8,
  String text = '',
  String description = '',
  void Function()? onTap,
}) {
  return Tile(
      x: x,
      y: y,
      onTap: onTap,
      builder: (BuildContext context) {
        iconColor = iconColor ?? Theme.of(context).primaryColor;
        return Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    flex: 55,
                    child: FittedBox(
                      child: Icon(icon, color: iconColor),
                    )),
                Expanded(
                  flex: 45,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      text.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: AutoSizeText(
                                text,
                                maxLines: 1,
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ))
                          : const SizedBox(),
                      description.isNotEmpty
                          ? AutoSizeText(description,
                              maxLines: 1,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ))
                          : const SizedBox(),
                    ],
                  ),
                ),
              ],
            ));
      });
}

Tile imageTile(
  String url, {
  int x: 16,
  double y: 16,
  void Function()? onTap,
}) {
  return Tile(
    x: x,
    y: y,
    onTap: onTap,
    builder: (BuildContext context) => delta.WebImage(url),
  );
}

Tile linkTile({
  int x: 8,
  double y: 4,
  String? text,
  String? description,
  void Function()? onTap,
  Decoration? decoration,
  bool next = false,
  IconData? icon,
  Color? iconColor,
  Color? color,
}) {
  return Tile(
    x: x,
    y: y,
    onTap: onTap,
    builder: (BuildContext context) => Container(
      decoration: decoration,
      padding: const EdgeInsets.only(left: 20),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              text != null
                  ? AutoSizeText(text,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ))
                  : const SizedBox(),
              const SizedBox(height: 5),
              description != null
                  ? Row(
                      children: [
                        AutoSizeText(description, style: TextStyle(color: color ?? Colors.grey, fontSize: 16)),
                        next
                            ? Icon(delta.CustomIcons.navigateNext, color: color ?? Colors.grey, size: 26)
                            : const SizedBox(),
                      ],
                    )
                  : const SizedBox(),
            ],
          ),
          icon != null
              ? Positioned(
                  top: 0,
                  right: 20,
                  bottom: 0,
                  child: Icon(icon, color: iconColor, size: 48),
                )
              : const SizedBox(),
        ],
      ),
    ),
  );
}

const shape = RoundedRectangleBorder(
  borderRadius: BorderRadius.all(
    Radius.circular(10),
  ),
  //side: BorderSide(width: 5, color: Colors.green),
);

Widget listTitle(String title) {
  return Expanded(
    flex: 20,
    child: Container(
      alignment: Alignment.center,
      child: Text(title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          )),
    ),
  );
}

Widget listItem({
  String? imageUrl,
  String title = '',
  String text1 = '',
  String text2 = '',
}) {
  return Expanded(
      flex: 20,
      child: Card(
        margin: const EdgeInsets.only(bottom: 20),
        elevation: elevation,
        shape: shape,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Row(
          children: [
            imageUrl != null
                ? delta.WebImage(
                    imageUrl,
                  )
                : const SizedBox(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )),
                  Text(text1,
                      maxLines: 1,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      )),
                  Text(text2,
                      maxLines: 1,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      )),
                ],
              ),
            ),
          ],
        ),
      ));
}

Tile listTile({
  List<Widget> children = const <Widget>[],
  int x = 16,
  double y = 16,
  void Function()? onTap,
}) {
  return Tile(
      x: x,
      y: y,
      cardView: false,
      builder: (BuildContext context) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          ));
}

Tile tileBanner(
  String imageName,
  String text, {
  int x = 16,
  double y = 4,
  void Function()? onTap,
}) {
  return Tile(
      x: x,
      y: y,
      cardView: false,
      builder: (BuildContext context) => Row(
            children: [
              Image(
                image: AssetImage(imageName),
                //      width: ui.isDesktopLayout(constraints.maxWidth) ? 1024 : constraints.maxWidth,
                fit: BoxFit.cover,
              ),
              Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ));
}
