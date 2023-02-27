import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:sign_button/sign_button.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'login_form_provider.dart';

Map<LoginType, ButtonType> _allSocialButton(BuildContext context) => {
      LoginType.apple: context.isDark ? ButtonType.appleDark : ButtonType.apple,
      LoginType.google: context.isDark ? ButtonType.googleDark : ButtonType.google,
      LoginType.facebook: ButtonType.facebook,
      LoginType.email: ButtonType.mail,
    };

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  List<LoginType> get _buttons {
    if (UniversalPlatform.isAndroid) {
      return [LoginType.google, LoginType.facebook, LoginType.email];
    }
    return [LoginType.apple, LoginType.google, LoginType.facebook, LoginType.email];
  }

  @override
  Widget build(BuildContext context) {
    final allButtons = _allSocialButton(context);
    return ChangeNotifierProvider<LoginFormProvider>(
        create: (context) => LoginFormProvider(),
        child: Consumer<LoginFormProvider>(
            builder: (context, loginFormProvider, child) => Center(
                    child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 300), //SET max width
                  child: Column(
                      children: List.generate(
                    _buttons.length,
                    (int index) {
                      final type = _buttons[index];
                      return Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: SignInButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: 12,
                              width: 260,
                              buttonSize: ButtonSize.medium,
                              buttonType: allButtons[type]!,
                              onPressed: () => loginFormProvider.onButtonPressed(context, type)));
                    },
                  )),
                ))));
  }
}
