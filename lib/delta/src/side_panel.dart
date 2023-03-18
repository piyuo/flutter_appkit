import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'delta.dart';

class SidePanelProvider with ChangeNotifier {
  bool? _isPreviousPhone;

  bool? _opened;

  bool? get opened => _opened;

  bool _isSideVisible = false;

  set opened(bool? value) {
    _opened = value;
    notifyListeners();
  }

  void toggle() => opened = !(opened ?? _isSideVisible);

  void trackWidth() {
    if (phoneScreen != _isPreviousPhone) {
      _isPreviousPhone = phoneScreen;
      _opened = null;
    }
  }

  bool get isSideVisible {
    _isSideVisible = _opened ?? !phoneScreen;
    return _isSideVisible;
  }

  bool get isAutoHide => isSideVisible && phoneScreen;

  Widget get leading => IconButton(
        icon: const Icon(Icons.menu),
        onPressed: toggle,
      );
}

class SidePanel extends StatelessWidget {
  const SidePanel({
    required this.sideWidget,
    required this.mainWidget,
    required this.sideWidth,
    this.decoration,
    Key? key,
  }) : super(key: key);

  /// sideWidget is the widget place on the side
  final Widget sideWidget;

  /// mainWidget is the main widget
  final Widget mainWidget;

  /// sideWidth define side width
  final double sideWidth;

  /// decoration to paint behind the panel
  final Decoration? decoration;

  Widget _buildMainWidget(BuildContext context, bool isOpen) {
    return isOpen
        ? Material(
            clipBehavior: Clip.antiAlias,
            elevation: 1,
/*            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
            )),*/
            child: mainWidget)
        : mainWidget;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SidePanelProvider>(builder: (context, provide, child) {
      provide.trackWidth();
      final sideVisible = provide.isSideVisible;
      return SafeArea(
          bottom: false,
          left: false,
          right: false,
          child: Container(
              decoration: decoration,
              child: Stack(
                children: [
                  AnimatedPositioned(
                    left: sideVisible ? 0 : -sideWidth,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    duration: const Duration(milliseconds: 100),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: sideWidth,
                          child: sideWidget,
                        ),
                        Expanded(
                          child: provide.isAutoHide
                              ? GestureDetector(
                                  onTap: () {
                                    provide.opened = false;
                                  },
                                  child: AbsorbPointer(
                                    child: _buildMainWidget(context, sideVisible),
                                  ),
                                )
                              : _buildMainWidget(context, sideVisible),
                        ),
                      ],
                    ),
                  ),
                ],
              )));
    });
  }
}
