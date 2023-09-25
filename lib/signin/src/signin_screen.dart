import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sign_button/sign_button.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:text_divider/text_divider.dart';
import 'package:beamer/beamer.dart';
import 'package:libcli/apollo/apollo.dart' as apollo;
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/form/form.dart' as form;
import 'package:universal_platform/universal_platform.dart';
import 'signin_provider.dart';
import 'code_view.dart';

List<LoginType> get _supportedLoginTypes {
  return [
    if (UniversalPlatform.isIOS || UniversalPlatform.isMacOS || UniversalPlatform.isWeb || UniversalPlatform.isAndroid)
      LoginType.apple,
    if (UniversalPlatform.isIOS || UniversalPlatform.isWeb || UniversalPlatform.isAndroid) LoginType.google,
    if (UniversalPlatform.isIOS || UniversalPlatform.isWeb || UniversalPlatform.isAndroid) LoginType.facebook,
  ];
}

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
      child: Consumer2<apollo.SessionProvider, SigninProvider>(
        builder: (context, sessionProvider, signinProvider, _) {
          return apollo.LoadingScreen(
            future: () => loader(context),
            builder: () {
              final socialButtons = {
                LoginType.apple: MediaQuery.of(context).platformBrightness == Brightness.dark
                    ? ButtonType.appleDark
                    : ButtonType.apple,
                LoginType.google: MediaQuery.of(context).platformBrightness == Brightness.dark
                    ? ButtonType.googleDark
                    : ButtonType.google,
                LoginType.facebook: ButtonType.facebook,
                LoginType.email: ButtonType.mail,
              };

              onSuccessLogin(session) {
                if (redirectTo != null) {
                  Beamer.of(context).beamToNamed(redirectTo!);
                  return;
                }
                if (kIsWeb) {
                  html.window.history.back();
                  return;
                }
                int count = 0;
                Navigator.of(context).popUntil((_) => count++ >= 2);
              }

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

              Widget buildLoginForm() {
                return ReactiveForm(
                    formGroup: signinProvider.formGroup,
                    child: Center(
                        child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 280), //SET max width
                      child: Column(children: [
                        ...List.generate(
                          _supportedLoginTypes.length,
                          (int index) {
                            final loginType = _supportedLoginTypes[index];
                            return Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: createSignin(loginType, socialButtons[loginType]!, () async {
                                final session = await signinProvider.socialLogin(context, loginType);
                                if (session != null) {}
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
                            builder: (context, isMounted) => createSignin(
                                LoginType.email,
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
                                                  onLogin: onSuccessLogin,
                                                ),
                                              ));
                                        }
                                        return false;
                                      },
                                    ))),
                      ]),
                    )));
              }

              return Scaffold(
                appBar: appBar ??
                    AppBar(
                      toolbarHeight: apollo.barHeight,
                      title: const Text('Sign in to continue'),
                    ),
                body: buildLoginForm(),
/*                slivers: [
                  SliverToBoxAdapter(
                    child: buildLoginForm(),
                  ),
                ],*/
              );
            },
          );
        },
      ),
    );
  }
}

/*
              return delta.ResponsiveBarView(
                barBuilder: () => delta.responsiveBar(
                  context,
                  title: const Text('Sign in to continue'),
                  leading: apollo.buildBackButton(),
                ),
/*                slivers: [
                  SliverToBoxAdapter(
                    child: buildLoginForm(),
                  ),
                ],*/
              );
 */