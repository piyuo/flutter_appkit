import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SidePanelProvider with ChangeNotifier {
  SidePanelProvider();

  bool opened = false;

  void setOpen(bool isOpen) {
    opened = isOpen;
    notifyListeners();
  }
}

class SidePanel extends StatelessWidget {
  SidePanel({
    required this.sideWidget,
    required this.mainWidget,
    required this.sideWidth,
    this.autoHide = false,
    this.roundCorner = true,
  });

  /// sideWidget is the widget place on the side
  final Widget sideWidget;

  /// mainWidget is the main widget
  final Widget mainWidget;

  /// sideWidth define side width
  final double sideWidth;

  /// autoHide is true will auto hide side panel when user click main widget
  final bool autoHide;

  /// roundCorner is true will show round corner on main widget
  final bool roundCorner;

  Widget buildMainWidget(BuildContext context, bool isOpen) {
    return roundCorner && isOpen
        ? Material(
            clipBehavior: Clip.antiAlias,
            elevation: 4,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              bottomLeft: Radius.circular(25),
            )),
            child: mainWidget)
        : mainWidget;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SidePanelProvider>(builder: (context, provide, child) {
      return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment(1, 1), // 10% of the width, so there are ten blinds.
              colors: [
                Colors.green[100]!,
                Colors.green[900]!,
              ], // red to yellow
              tileMode: TileMode.repeated, // repeats the gradient over the canvas
            ),
          ),
          child: Stack(
            children: [
              AnimatedPositioned(
                left: provide.opened ? 0 : -sideWidth,
                right: 0,
                top: 0,
                bottom: 0,
                duration: const Duration(milliseconds: 100),
                child: Row(
                  children: [
                    SizedBox(width: sideWidth, child: sideWidget),
                    Expanded(
                      child: provide.opened & autoHide
                          ? GestureDetector(
                              onTap: () {
                                provide.setOpen(false);
                              },
                              child: AbsorbPointer(
                                child: buildMainWidget(context, provide.opened),
                              ),
                            )
                          : buildMainWidget(context, provide.opened),
                    ),
                  ],
                ),
              ),
            ],
          ));
    });
  }
}
