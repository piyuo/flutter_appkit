import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SidePanelProvider with ChangeNotifier {
  SidePanelProvider();

  bool opened = false;

  void setOpen(bool isOpen) {
    opened = isOpen;
    notifyListeners();
  }

  void toggle() {
    opened = !opened;
    notifyListeners();
  }
}

class SidePanel extends StatelessWidget {
  SidePanel({
    required this.sideWidget,
    required this.mainWidget,
    required this.sideWidth,
    this.autoHide = false,
    this.decoration,
  });

  /// sideWidget is the widget place on the side
  final Widget sideWidget;

  /// mainWidget is the main widget
  final Widget mainWidget;

  /// sideWidth define side width
  final double sideWidth;

  /// autoHide is true will auto hide side panel when user click main widget
  final bool autoHide;

  /// decoration to paint behind the panel
  final Decoration? decoration;

  Widget _buildMainWidget(BuildContext context, bool isOpen) {
    return isOpen
        ? Material(
            clipBehavior: Clip.antiAlias,
            elevation: 4,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
            )),
            child: mainWidget)
        : mainWidget;
  }

  Widget _buildSideWidget(BuildContext context) {
    return sideWidget;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SidePanelProvider>(builder: (context, provide, child) {
      return SafeArea(
        bottom: false,
        left: false,
        right: false,
        child: Container(
            decoration: decoration,
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
                      SizedBox(
                        width: sideWidth,
                        child: _buildSideWidget(context),
                      ),
                      Expanded(
                        child: provide.opened & autoHide
                            ? GestureDetector(
                                onTap: () {
                                  provide.setOpen(false);
                                },
                                child: AbsorbPointer(
                                  child: _buildMainWidget(context, provide.opened),
                                ),
                              )
                            : _buildMainWidget(context, provide.opened),
                      ),
                    ],
                  ),
                ),
              ],
            )),
      );
    });
  }
}
