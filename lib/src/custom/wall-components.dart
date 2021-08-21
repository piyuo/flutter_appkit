import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:libcli/delta.dart' as delta;
import 'package:libcli/custom.dart' as custom;

final double elevation = 8;

final shape = RoundedRectangleBorder(
  borderRadius: BorderRadius.all(
    Radius.circular(10),
  ),
  //side: BorderSide(width: 5, color: Colors.green),
);

///tileButton is 8x8 button
custom.Tile tileButton(
  IconData icondata, {
  int x: 8,
  double y: 8,
  String? text,
  String? description,
  void Function()? onTap,
  Color? iconColor,
}) {
  return custom.Tile(
      x: x,
      y: y,
      onTap: onTap,
      builder: (BuildContext context) {
        iconColor = iconColor ?? Theme.of(context).primaryColor;
        return Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Expanded(
                    flex: 50,
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: SizedBox.fromSize(
                        size: Size.fromRadius(200),
                        child: FittedBox(
                          child: Icon(icondata, color: iconColor),
                        ),
                      ),
                    )),
                text != null
                    ? Expanded(
                        flex: 25,
                        child: AutoSizeText(text,
                            maxLines: 1, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      )
                    : SizedBox(),
                description != null
                    ? Expanded(
                        flex: 25,
                        child: AutoSizeText(description,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            )),
                      )
                    : SizedBox(),
              ],
            ));
      });
}

custom.Tile tileLink({
  int x: 8,
  double y: 4,
  String? text,
  String? description,
  void Function()? onTap,
  bool next = false,
  Color? color,
  Color? backgroundColor,
  Color? backgroundColorEnd,
  IconData? iconData,
  Color? iconColor,
  bool cardView = true,
}) {
  return custom.Tile(
    x: x,
    y: y,
    onTap: onTap,
    cardView: cardView,
    builder: (BuildContext context) => Padding(
      padding: EdgeInsets.only(left: 20),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              text != null
                  ? AutoSizeText(text,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ))
                  : SizedBox(),
              description != null
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(description, style: TextStyle(color: color ?? Colors.grey, fontSize: 16)),
                        next ? Icon(delta.CustomIcons.navigateNext, color: color ?? Colors.grey, size: 28) : SizedBox(),
                      ],
                    )
                  : SizedBox(),
            ],
          ),
          iconData != null
              ? Positioned(
                  top: 0,
                  right: 10,
                  bottom: 0,
                  child: Icon(iconData, color: iconColor, size: 48),
                )
              : SizedBox(),
        ],
      ),
    ),
  );
}

custom.Tile tileImage(
  String imageName, {
  int x: 16,
  double y: 16,
  void Function()? onTap,
}) {
  return custom.Tile(
    x: x,
    y: y,
    onTap: onTap,
    builder: (BuildContext context) => Image(
      image: AssetImage(imageName),
//      width: ui.isDesktopLayout(constraints.maxWidth) ? 1024 : constraints.maxWidth,
      fit: BoxFit.cover,
    ),
  );
}

custom.Tile tileCard(
  String text, {
  String? description,
  int x: 16,
  double y: 20,
  void Function()? onTap,
}) {
  return custom.Tile(
      x: x,
      y: y,
      cardView: false,
      builder: (BuildContext context) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 20,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              Expanded(
                flex: 20,
                child: Card(
                  margin: EdgeInsets.only(bottom: 20),
                  elevation: elevation,
                  shape: shape,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Row(
                    children: [
                      Image(
                        image: AssetImage('asset/images/2.webp'),
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('特價套餐ㄧ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                )),
                            Text('特價套餐ㄧ',
                                maxLines: 1,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                )),
                            Text('\$19.99',
                                maxLines: 1,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 20,
                child: Card(
                  margin: EdgeInsets.only(bottom: 20),
                  elevation: elevation,
                  shape: shape,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Row(
                    children: [
                      Image(
                        image: AssetImage('asset/images/2.webp'),
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('特價套餐ㄧ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                )),
                            Text('特價套餐ㄧ',
                                maxLines: 1,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                )),
                            Text('\$19.99',
                                maxLines: 1,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 20,
                child: Card(
                  elevation: elevation,
                  margin: EdgeInsets.only(bottom: 20),
                  shape: shape,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Row(
                    children: [
                      Image(
                        image: AssetImage('asset/images/2.webp'),
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('特價套餐ㄧ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                )),
                            Text('特價套餐ㄧ',
                                maxLines: 1,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                )),
                            Text('\$19.99',
                                maxLines: 1,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 20,
                child: Card(
                  margin: EdgeInsets.only(bottom: 20),
                  elevation: elevation,
                  shape: shape,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Row(
                    children: [
                      Image(
                        image: AssetImage('asset/images/2.webp'),
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('特價套餐ㄧ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                )),
                            Text('特價套餐ㄧ',
                                maxLines: 1,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                )),
                            Text('\$19.99',
                                maxLines: 1,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ));
}

custom.Tile tileBanner(
  String imageName,
  String text, {
  int x: 16,
  double y: 4,
  void Function()? onTap,
}) {
  return custom.Tile(
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
              Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ));
}
