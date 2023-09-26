import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum ButtonType {
  facebook,
  facebookDark,
  apple,
  appleDark,
  google,
  googleDark,
  mail,
}

enum ImagePosition {
  left,
  right,
}

enum ButtonSize {
  small,
  medium,
  large,
}

/// [SigninButton] is a button can show facebook, apple, google, mail icons.
class SigninButton extends StatelessWidget {
  // required
  /// [buttonType] sets the style and icons of the button.
  final ButtonType buttonType;

  // required
  /// [onPressed] Send a function to trigger the button.
  final VoidCallback? onPressed;

  // not required, default 5.0
  /// [elevation] set the button's elevation value.
  final double elevation;

  // not required, default small
  /// [buttonSize] set the size of the button. (small medium large)
  final ButtonSize buttonSize;

  /// [padding] set the button's padding value.
  final EdgeInsetsGeometry padding;

  // not required, button shape.
  /// [shape] set the button's shape.
  final ShapeBorder? shape;

  // not required, button model.
  /// [mini] It automatically takes value according to the selected constructor.
  final bool mini;

  const SigninButton({
    super.key,
    required this.buttonType,
    required this.onPressed,
    this.buttonSize = ButtonSize.small,
    this.elevation = 5.0,
    this.padding = const EdgeInsets.fromLTRB(12, 12, 5, 12),
    this.shape,
  }) : mini = false;

  const SigninButton.mini({
    super.key,
    required this.buttonType,
    required this.onPressed,
    this.buttonSize = ButtonSize.small,
    this.elevation = 5.0,
    this.padding = const EdgeInsets.all(12),
    this.shape,
  }) : mini = true;

  bool get _enabled => onPressed != null;

  bool get _disabled => !_enabled;

  @override
  Widget build(BuildContext context) {
    double fontSize = 17.0; //large
    double imageSize = !mini ? 32.0 : 38.0;
    double width = 270;
    if (buttonSize == ButtonSize.small) {
      width = 240;
      fontSize = 14.0;
      imageSize = !mini ? 24.0 : 30.0;
    } else if (buttonSize == ButtonSize.medium) {
      width = 250;
      fontSize = 16.0;
      imageSize = !mini ? 28.0 : 34.0;
    }

    final disabledColor = Theme.of(context).disabledColor.withOpacity(0.12);
    final disabledTextColor = Theme.of(context).disabledColor.withOpacity(0.38);

    Widget image = Image.asset(
      'images/${describeEnum(buttonType)}.png',
      package: 'libcli',
      width: imageSize,
      height: imageSize,
    );

    if (_disabled) {
      image = ColorFiltered(
        colorFilter: const ColorFilter.matrix(<double>[
          0.2126, 0.7152, 0.0722, 0, 0, // R1
          0.2126, 0.7152, 0.0722, 0, 0, // R2
          0.2126, 0.7152, 0.0722, 0, 0, // R3
          0, 0, 0, 1, 0, // R4
        ]),
        child: image,
      );
    }

    var btnText = 'Sign in with Mail';
    var btnTextColor = Colors.white;
    var btnColor = const Color(0xFF20639B);

    switch (buttonType) {
      case ButtonType.facebook:
        btnText = 'Sign in with Facebook';
        btnTextColor = Colors.white;
        btnColor = const Color(0xFF1877F2);
        break;

      case ButtonType.facebookDark:
        btnText = 'Sign in with Facebook';
        btnTextColor = Colors.white;
        btnColor = Colors.black;
        break;

      case ButtonType.apple:
        btnText = 'Sign in with Apple';
        btnTextColor = Colors.black;
        btnColor = const Color(0xfff7f7f7);
        break;

      case ButtonType.appleDark:
        btnText = 'Sign in with Apple';
        btnTextColor = Colors.white;
        btnColor = Colors.black;
        break;

      case ButtonType.google:
        btnText = 'Sign in with Google';
        btnTextColor = Colors.black;
        btnColor = const Color(0xfff7f7f7);
        break;

      case ButtonType.googleDark:
        btnText = 'Sign in with Google';
        btnTextColor = Colors.white;
        btnColor = const Color(0xFF4285F4);
        break;
      default:
        break;
    }
    Widget text = Text(
      btnText,
      style: TextStyle(
        fontSize: fontSize,
        color: _enabled ? btnTextColor : disabledTextColor,
      ),
    );

    return !mini
        ? MaterialButton(
            color: btnColor,
            disabledColor: disabledColor,
            shape: shape,
            onPressed: onPressed,
            elevation: elevation,
            minWidth: width,
            child: SizedBox(
              width: width,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: padding,
                    child: image,
                  ),
                  Padding(
                    padding: padding,
                    child: text,
                  ),
                ],
              ),
            ),
          )
        : MaterialButton(
            onPressed: onPressed,
            color: btnColor,
            elevation: elevation,
            padding: padding,
            shape: const CircleBorder(),
            child: image,
          );
  }
}
