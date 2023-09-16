import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:libcli/form/form.dart' as form;
import 'package:libcli/i18n/i18n.dart' as i18n;
//import 'package:pinput/pin_put/pin_put.dart';
import 'login_verify_email_provider.dart';
import 'hypertext.dart';

/// LoginVerifyEmail verify email by check code is correct
class LoginVerifyEmail extends StatelessWidget {
  const LoginVerifyEmail({required this.email, Key? key}) : super(key: key);

  final String email;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginVerifyEmailProvider>(
      create: (context) => LoginVerifyEmailProvider(email: email),
      child: Scaffold(
        appBar: AppBar(
          //backToRoot: true,
          centerTitle: true,
          title: const Text('Verify code'),
        ),
        body: Consumer<LoginVerifyEmailProvider>(
          builder: (context, model, _) {
            final defaultPinTheme = form.PinTheme(
              width: 45,
              height: 45,
              textStyle: const TextStyle(fontSize: 28, color: Colors.black, fontWeight: FontWeight.w600),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
            );
            final focusedPinTheme = defaultPinTheme.copyDecorationWith(
              border: Border.all(color: Colors.blue, width: 2),
            );
            final submittedPinTheme = defaultPinTheme.copyDecorationWith(
              border: Border.all(color: Colors.grey.shade300, width: 1),
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
                      formGroup: model.formGroup,
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 20),
                          Hypertext(children: [
                            Span(text: context.i18n.loginCodeScreenSent),
                            Bold(text: model.email),
                            const Span(text: '  '),
                            Link(
                                text: context.i18n.loginCodeScreenChange,
                                onPressed: (_, __) {
                                  return Navigator.of(context).pop();
                                }),
                          ]),
                          const SizedBox(height: 10),
                          Hypertext(children: [
                            Span(text: context.i18n.loginCodeScreenReceive),
                            Link(
                              text: context.i18n.loginCodeScreenChange,
                              onPressed: (context, __) => model.onResendCode(context),
                            ),
                          ]),
                          form.p(),
                          Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 340, minWidth: 320),
                              child: form.FormPinPut<String>(
                                  formControlName: codeField,
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
                                  ]),
                            ),
                          ),
                          form.p(),
                          Container(
                            alignment: Alignment.centerRight,
                            child: Visibility(
                                visible: model.status != VerifyStatus.wait,
                                child: model.status == VerifyStatus.busy
                                    ? CircularProgressIndicator(
                                        semanticsLabel: 'Loading',
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[400]!))
                                    : Icon(
                                        Icons.check_circle,
                                        color: Colors.greenAccent[700],
                                        size: 42,
                                      )),
                          ),
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
