import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum _ButtonState { initial, animate, done }

typedef Future<bool> Callback();

class AnimateButton extends StatefulWidget {
  /// sizeLevel is button size level, default is 1
  ///
  final double sizeLevel;

  /// text is button text
  ///
  final String text;

  /// width is button default width
  ///
  final double width;

  /// backgroundColor is button background color
  ///
  final Color? backgroundColor;

  /// onClickStart called when button clicked, return true if data are validated and user can click the button
  ///
  /// onClickStart() -> onClick() -> onClickSuccess()
  ///
  final Callback? onClickStart;

  /// onClick called when onClickStart() return true, return true if click are success
  ///
  /// onClickStart() -> onClick() -> onClickSuccess()
  ///
  final Callback? onClick;

  /// onClickSuccess called when onClick() return true
  ///
  /// onClickStart() -> onClick() -> onClickSuccess()
  ///
  final Function? onClickSuccess;

  /// focusNode is focusNode set to button
  ///
  final FocusNode? focusNode;

  /// form is form key, button will call form.validate() if form is not null
  ///
  final GlobalKey<FormState>? form;

  AnimateButton(
    this.text, {
    this.onClickStart,
    this.onClick,
    this.onClickSuccess,
    this.backgroundColor,
    this.width = 200,
    this.focusNode,
    this.form,
    this.sizeLevel = 1,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => AnimateButtonState(width);
}

class AnimateButtonState extends State<AnimateButton> with TickerProviderStateMixin {
  double _buttonHeight = 44.0;

  double _circleHeight = 32.0;

  bool _disposed = false;

  bool _animatingReveal = false;

  _ButtonState _state = _ButtonState.initial;

  double buttonWidth;

  GlobalKey _globalKey = GlobalKey();

  AnimationController? _controller;

  Animation? _animation;

  AnimateButtonState(this.buttonWidth);

  @override
  void deactivate() {
    //_reset();
    super.deactivate();
  }

  @override
  dispose() {
    _disposed = true;
    _disposeAnimation();
    super.dispose();
  }

  void safeSetState(void Function() fn) {
    if (!_disposed) {
      setState(fn);
    }
  }

  Color backgroundColor(BuildContext context) {
    switch (_state) {
      case _ButtonState.animate:
        return Colors.grey[400]!;
      case _ButtonState.done:
        return Colors.green[400]!;
      default:
        return widget.backgroundColor ?? Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    _buttonHeight = 32.0;
    _circleHeight = 18.0;
    return PhysicalModel(
        color: backgroundColor(context),
        elevation: _calculateElevation(),
        borderRadius: BorderRadius.circular(25.0),
        child: Container(
          key: _globalKey,
          height: _buttonHeight,
          width: buttonWidth,
          child: ElevatedButton(
            focusNode: widget.focusNode,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(backgroundColor(context)),
              padding: MaterialStateProperty.all(EdgeInsets.all(0)),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25 * widget.sizeLevel),
              )),
            ),
            child: _buildButtonChild(),
            onPressed: () => _animateButton(),
          ),
        ));
  }

  _disposeAnimation() {
    _animation = null;
    if (_controller != null) {
      _controller!.dispose();
      _controller = null;
    }
  }

  _beginAnimation(Function() tick) {
    _disposeAnimation();
    _controller = AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller as Animation<double>)
      ..addListener(() => safeSetState(tick));
    _controller!.forward();
  }

  _animateButton() async {
    if (_state != _ButtonState.initial) {
      return;
    }

    if (widget.form != null && !widget.form!.currentState!.validate()) {
      return;
    }

    if (widget.onClickStart != null) {
      var ok = await widget.onClickStart!();
      if (!ok) return;
    }

    if (widget.onClick != null) {
      // no animation in unit test
      if (!kReleaseMode) {
        if (await widget.onClick!()) {
          _onPressedSuccess();
        }
        return;
      }

      double initialWidth = _globalKey.currentContext!.size!.width;
      _beginAnimation(() {
        buttonWidth = initialWidth - ((initialWidth - _buttonHeight) * _animation!.value);
      });
      safeSetState(() => _state = _ButtonState.animate);
      //await new Future.delayed(const Duration(seconds: 60));
      try {
        if (await widget.onClick!()) {
          safeSetState(() {
            _state = _ButtonState.done;
            _animatingReveal = true;
          });
          //delay 0.7 second to display check icon
          await new Future.delayed(const Duration(milliseconds: 500));
          _onPressedSuccess();
          //delay 2 seconds then put button to initial state
          await new Future.delayed(const Duration(seconds: 2));
        }
        reset();
      } on Exception catch (e) {
        reset();
        throw e;
      }
    }
  }

  /// _onPressedSuccess called when widget.onClick() return true
  ///
  _onPressedSuccess() {
    try {
      if (widget.onClickSuccess != null) {
        widget.onClickSuccess!();
      }
    } on Exception catch (e) {
      safeSetState(_reset);
      throw e;
    }
  }

  reset() {
    _beginAnimation(() {
      buttonWidth = widget.width * _animation!.value;
      if (buttonWidth < _buttonHeight) buttonWidth = _buttonHeight;
    });
    safeSetState(_reset);
  }

  Widget _buildButtonChild() {
    if (_state == _ButtonState.initial) {
      return Text(
        widget.text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.white, fontSize: 16.0),
      );
    } else if (_state == _ButtonState.animate) {
      return SizedBox(
        height: _circleHeight,
        width: _circleHeight,
        child: CircularProgressIndicator(
          value: null,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    } else {
      return Icon(
        Icons.check,
        color: Colors.white,
        size: 32,
      );
    }
  }

  double _calculateElevation() {
    if (_animatingReveal) {
      return 0.0;
    } else {
      return 4.0;
    }
  }

  void _reset() {
    buttonWidth = widget.width;
    _animatingReveal = false;
    _state = _ButtonState.initial;
  }
}
