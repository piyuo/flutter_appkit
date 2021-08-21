import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:libcli/delta.dart' as delta;

final double elevation = 8;

class Tile extends StatelessWidget {
  /// Tile basic unit is 16
  Tile({
    required this.builder,
    this.x = 16,
    this.y = 16,
    this.cardView = true,
    this.onTap,
  });

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
    final shape = RoundedRectangleBorder(
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
  Wall({
    required this.tiles,
  });

  final List<Tile> tiles;

  int _determineCrossAxisCount(double windowWidth) {
    // -100 make sure when layout change, tile will be big enough
    switch (delta.deviceLayout(windowWidth - 0)) {
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
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
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
