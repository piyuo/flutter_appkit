import 'package:flutter/material.dart';
import 'package:libcli/dialog/dialog.dart' as dialog;
import 'package:libcli/delta/delta.dart' as delta;
import 'package:reactive_forms/reactive_forms.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:libcli/auth/auth.dart' as auth;
import 'package:libcli/apollo/apollo.dart' as apollo;
import 'signin_provider.dart';

/// Code is code field name
const pinField = 'code';

enum VerifyStatus { wait, busy, ok }

/// LoginCodeScreenProvider is provider for login code screen
class LoginCodeScreenProvider with ChangeNotifier {
  LoginCodeScreenProvider({
    required this.email,
  });

  /// email that user want to verify
  final String email;

  /// _busy set true when verify pin
  ///
  VerifyStatus _status = VerifyStatus.wait;

  VerifyStatus get status => _status;

  /// formGroup is form data
  final formGroup = fb.group({
    pinField: FormControl<String>(value: null),
  });

  @override
  void dispose() {
    formGroup.dispose();
    super.dispose();
  }

  set status(VerifyStatus value) {
    _status = value;
    notifyListeners();
  }

  /// onResendCode called when user press resend link
  void onResendCode(BuildContext context) async {
    final signupCodeResendEmail = context.i18n.loginCodeScreenResendEmail;
    final resendCommand = auth.ResendPinAction(email: email);
    final response = await auth.AuthService.of(context).send(resendCommand);
    if (isPinSent(response)) {
      dialog.alert(
        signupCodeResendEmail,
        iconBuilder: (context) => const Icon(Icons.outgoing_mail, size: 64),
      );
    }
  }

  /// _getErrorTranslation return error code translation
  String _getErrorTranslation(String error) {
    switch (error) {
      case 'CODE_EXPIRED':
      case 'CODE_INVALID':
        return delta.i18n.loginCodeScreenErrorCodeInvalid;
      case 'CODE_MISMATCH':
        return delta.i18n.loginCodeScreenErrorCodeMismatch;
      case 'NO_CODE':
        return delta.i18n.loginCodeScreenErrorNoCode;
      case 'ENTER_BLOCK_SHORT':
        return delta.i18n.loginCodeScreenErrorEnterBlockShort;
      case 'ENTER_BLOCK_LONG':
        return delta.i18n.loginCodeScreenErrorEnterBlockLong;
      default:
        return error;
    }
  }

  Future<apollo.Session?> onPinSubmit(BuildContext context, String pin) async {
    status = VerifyStatus.busy;
    final response = await auth.AuthService.of(context).send(
      auth.LoginPinAction(email: email, pin: pin),
    );
    status = VerifyStatus.ok;
    if (response is auth.LoginPinResponse) {
      switch (response.result) {
        case auth.LoginPinResponse_Result.RESULT_OK:
          return apollo.Session.fromAccess(response.access);
        case auth.LoginPinResponse_Result.RESULT_WRONG_PIN:
          dialog.alert(_getErrorTranslation('CODE_MISMATCH'), isError: true);
          break;
        case auth.LoginPinResponse_Result.RESULT_EMAIL_NOT_EXISTS:
          dialog.alert(_getErrorTranslation('NO_CODE'), isError: true);
          break;
        default:
          assert(false, 'Unknown error code ${response.result}');
      }
    }
    formGroup.control(pinField).value = null;
    return null;
  }
}

/*
  Future<void> onPinSubmit(String pin, bool Function() isMounted) async {
    status = VerifyStatus.busy;
    final verifyCommand = auth.CmdSignupVerify(email: email, code: formGroup.control(codeField).value);
    final response = await auth.AuthService.of(delta.globalContext).send(verifyCommand);
    if (response is net.Error) {
      status = VerifyStatus.wait;
      dialog.alert(_getErrorTranslation(response.code), isError: true);
      return;
    }

    if (response is net.OK) {
      status = VerifyStatus.ok;
      final mounted = isMounted();
      if (mounted) {
        delta.globalContext.beamToNamed('setup');
      }
    }
  }

 */