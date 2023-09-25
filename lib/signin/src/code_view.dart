import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:libcli/form/form.dart' as form;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:libcli/apollo/apollo.dart' as apollo;
import 'package:libcli/delta/delta.dart' as delta;
import 'code_view_provider.dart';

/// CodeView enter code to verify email
class CodeView extends StatelessWidget {
  const CodeView({
    required this.onLogin,
    required this.email,
    this.appBar,
    super.key,
  });

  /// email that user want to verify
  final String email;

  /// onLogin is called when login succeeded
  final Function(apollo.Session session) onLogin;

  /// appBar is the app bar
  final PreferredSizeWidget? appBar;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ChangeNotifierProvider<LoginCodeScreenProvider>(
      create: (context) => LoginCodeScreenProvider(email: email),
      child: Scaffold(
        appBar: appBar ??
            AppBar(
              toolbarHeight: apollo.barHeight,
              title: const Text('Verify code'),
            ),
        body: Consumer<LoginCodeScreenProvider>(
          builder: (context, loginCodeScreenProvider, _) {
            final defaultPinTheme = form.PinTheme(
              width: 45,
              height: 45,
              textStyle: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
              decoration: BoxDecoration(
                border: Border.all(color: colorScheme.outline),
                borderRadius: BorderRadius.circular(8),
              ),
            );
            final focusedPinTheme = defaultPinTheme.copyDecorationWith(
              border: Border.all(color: colorScheme.primary, width: 2),
            );
            final submittedPinTheme = defaultPinTheme.copyDecorationWith(
              border: Border.all(color: colorScheme.outline.withOpacity(.8), width: 1),
            );

            return SafeArea(
              right: false,
              bottom: false,
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480), //SET max width
                  child: SingleChildScrollView(
                    child: ReactiveForm(
                      formGroup: loginCodeScreenProvider.formGroup,
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 20),
                          apollo.Hypertext(children: [
                            apollo.Span(text: context.i18n.loginCodeScreenSent),
                            apollo.Bold(text: loginCodeScreenProvider.email),
                            const apollo.Span(text: '  '),
                            apollo.Link(
                                text: context.i18n.loginCodeScreenChange,
                                onPressed: (_, __) {
                                  return Navigator.of(context).pop();
                                }),
                          ]),
                          const SizedBox(height: 10),
                          apollo.Hypertext(children: [
                            apollo.Span(text: context.i18n.loginCodeScreenReceive),
                            apollo.Link(
                              text: context.i18n.loginCodeScreenResend,
                              onPressed: (context, __) => loginCodeScreenProvider.onResendCode(context),
                            ),
                          ]),
                          form.p(),
                          Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 340, minWidth: 320),
                              child: delta.Mounted(
                                  builder: (context, isMounted) => form.FormPinPut<String>(
                                        formControlName: pinField,
                                        length: 6,
                                        autofocus: true,
                                        defaultPinTheme: defaultPinTheme,
                                        focusedPinTheme: focusedPinTheme,
                                        submittedPinTheme: submittedPinTheme,
                                        pinAnimationType: form.PinAnimationType.fade,
                                        showCursor: false,
                                        androidSmsAutofillMethod: form.AndroidSmsAutofillMethod.smsRetrieverApi,
                                        hapticFeedbackType: form.HapticFeedbackType.lightImpact,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                        ],
                                        onCompleted: (pin) async {
                                          final session = await loginCodeScreenProvider.onPinSubmit(context, pin);
                                          if (session != null) {
                                            onLogin(session);
                                          }
                                        },
                                      )),
                            ),
                          ),
                          const SizedBox(height: 10),
                          /*Center(
                            child: Visibility(
                              visible: loginCodeScreenProvider.status != VerifyStatus.wait,
                              child: SizedBox(
                                  width: 58,
                                  height: 58,
                                  child: loginCodeScreenProvider.status == VerifyStatus.busy
                                      ? delta.ballSpinIndicator()
                                      : Icon(
                                          Icons.check_circle,
                                          color: colorScheme.secondary,
                                          size: 42,
                                        )),
                            ),
                          ),*/
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
