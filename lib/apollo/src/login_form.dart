import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:sign_button/sign_button.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:text_divider/text_divider.dart';
import 'package:libcli/form/form.dart' as form;
import 'package:libcli/delta/delta.dart' as delta;
import 'login_form_provider.dart';
import 'login_verify_email.dart';
import 'session_provider.dart';

Map<LoginType, ButtonType> _allSocialButton(BuildContext context) => {
      LoginType.apple:
          MediaQuery.of(context).platformBrightness == Brightness.dark ? ButtonType.appleDark : ButtonType.apple,
      LoginType.google:
          MediaQuery.of(context).platformBrightness == Brightness.dark ? ButtonType.googleDark : ButtonType.google,
      LoginType.facebook: ButtonType.facebook,
      LoginType.email: ButtonType.mail,
    };

/// LoginForm is a login form
class LoginForm extends StatelessWidget {
  const LoginForm({
    required this.onLogin,
    super.key,
  });

  /// onLogin is called when login succeeded
  final Function(Session session) onLogin;

  List<LoginType> get _buttons {
    if (UniversalPlatform.isAndroid) {
      return [LoginType.google, LoginType.facebook];
    }
    return [LoginType.apple, LoginType.google, LoginType.facebook];
  }

  @override
  Widget build(BuildContext context) {
    final allButtons = _allSocialButton(context);

    return ChangeNotifierProvider<LoginFormProvider>(
        create: (context) => LoginFormProvider(),
        child: Consumer<LoginFormProvider>(builder: (context, loginFormProvider, child) {
          Widget createSignin(LoginType loginType, ButtonType buttonType, VoidCallback onPressed) => SignInButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: 12,
                width: 260,
                buttonSize: ButtonSize.medium,
                buttonType: buttonType,
                onPressed: onPressed,
              );

          return ReactiveForm(
              formGroup: loginFormProvider.formGroup,
              child: Center(
                  child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 280), //SET max width
                child: Column(children: [
                  ...List.generate(
                    _buttons.length,
                    (int index) {
                      final loginType = _buttons[index];
                      return Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: createSignin(loginType, allButtons[loginType]!, () async {
                          final session = await loginFormProvider.socialLogin(context, loginType);
                          if (session != null) {
                            onLogin(session);
                          }
                        }),
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                  TextDivider.horizontal(text: const Text('OR', style: TextStyle(color: Colors.grey))),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: form.EmailField(
                      formControlName: emailField,
                      decoration: const InputDecoration(
                        labelText: 'Email Address',
                        hintText: 'Enter your email address',
                      ),
                      validationMessages: {
                        ValidationMessage.required: (error) =>
                            'Email Address required', //context.l10n.signupAccountEmailRequired,
                        ValidationMessage.email: (error) =>
                            'Email Address invalid', //context.l10n.signupAccountEmailInvalid
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  delta.Mounted(
                      builder: (
                    context,
                    isMounted,
                  ) =>
                          createSignin(
                              LoginType.email,
                              ButtonType.mail,
                              () => form.submit(
                                    showDone: false,
                                    formGroup: loginFormProvider.formGroup,
                                    callback: (_) async {
                                      final email = loginFormProvider.formGroup.control(emailField).value as String;
                                      final ok = await loginFormProvider.emailLogin(context, email);
                                      final mounted = isMounted();
                                      if (ok && mounted) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => LoginVerifyEmail(email: email),
                                            ));
                                      }
                                      return false;
                                    },
                                  ))),
                ]),
              )));
        }));
  }
}
