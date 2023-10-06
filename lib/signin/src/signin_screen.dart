import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:text_divider/text_divider.dart';
import 'package:libcli/apollo/apollo.dart' as apollo;
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/form/form.dart' as form;
import 'package:universal_platform/universal_platform.dart';
import 'package:beamer/beamer.dart';
import 'signin_provider.dart';
import 'code_view.dart';
import 'signin_button.dart';

/// SigninScreen is a screen for sign in
class SigninScreen extends StatelessWidget {
  const SigninScreen({
    this.redirectTo,
    this.loader = _load,
    this.appBar,
    super.key,
  });

  /// redirectTo is the location to beam to after login, if null, will go back
  final String? redirectTo;

  /// loader is a function that will be called when the screen is loading
  final Future<void> Function(BuildContext) loader;

  /// appBar is the app bar
  final PreferredSizeWidget? appBar;

  /// _load load providers when loading screen show
  static Future<void> _load(BuildContext context) async {
    final languageProvider = apollo.LanguageProvider.of(context);
    final sessionProvider = apollo.SessionProvider.of(context);
    await languageProvider.init();
    await sessionProvider.init();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SigninProvider>(
          create: (_) => SigninProvider(),
        ),
      ],
      child: Consumer<SigninProvider>(
        builder: (context, signinProvider, _) {
          return apollo.FutureLoader(
            loader: () => loader(context),
            builder: (isReady) {
              onSuccessLogin() {
                if (redirectTo != null) {
                  Beamer.of(context).goTo(redirectTo!);
                  return;
                }

                if (kIsWeb) {
                  html.window.history.back();
                  return;
                }
                int count = 0;
                Navigator.of(context).popUntil((_) => count++ >= 2);
              }

              Widget buildSigninButton(ButtonType buttonType, VoidCallback onPressed) => Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: SigninButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    buttonSize: ButtonSize.large,
                    buttonType: buttonType,
                    onPressed: onPressed,
                  ));

              return Scaffold(
                appBar: appBar ??
                    AppBar(
                      centerTitle: true,
                      toolbarHeight: apollo.barHeight,
                      title: const Text('Sign in to continue'),
                    ),
                body: ReactiveForm(
                    formGroup: signinProvider.formGroup,
                    child: SingleChildScrollView(
                        child: Center(
                            child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 320), //SET max width
                      child: Column(children: [
                        if (UniversalPlatform.isIOS ||
                            UniversalPlatform.isMacOS ||
                            UniversalPlatform.isWeb ||
                            UniversalPlatform.isAndroid)
                          buildSigninButton(
                            context.isDark ? ButtonType.appleDark : ButtonType.apple,
                            signinProvider.withApple,
                          ),
                        if (UniversalPlatform.isIOS || UniversalPlatform.isWeb || UniversalPlatform.isAndroid)
                          buildSigninButton(
                            context.isDark ? ButtonType.googleDark : ButtonType.google,
                            signinProvider.withGoogle,
                          ),
                        if (UniversalPlatform.isIOS ||
                            UniversalPlatform.isMacOS ||
                            UniversalPlatform.isWeb ||
                            UniversalPlatform.isAndroid)
                          buildSigninButton(
                            context.isDark ? ButtonType.facebookDark : ButtonType.facebook,
                            signinProvider.withApple,
                          ),
                        const SizedBox(height: 20),
                        TextDivider.horizontal(text: const Text('OR', style: TextStyle(color: Colors.grey))),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
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
                        delta.Mounted(
                            builder: (context, isMounted) => buildSigninButton(
                                ButtonType.mail,
                                () => form.submit(
                                      showDone: false,
                                      formGroup: signinProvider.formGroup,
                                      callback: (_) async {
                                        final email = signinProvider.formGroup.control(emailField).value as String;
                                        final mounted = isMounted();
                                        final ok = await signinProvider.sendVerificationEmail(context, email);
                                        if (ok && mounted) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => CodeView(
                                                  email: email,
                                                  onLogin: (session) async {
                                                    final sessionProvider = apollo.SessionProvider.of(context);
                                                    await sessionProvider.login(session);
                                                    onSuccessLogin();
                                                  },
                                                ),
                                              ));
                                        }
                                        return false;
                                      },
                                    ))),
                      ]),
                    )))),
              );
            },
          );
        },
      ),
    );
  }
}
