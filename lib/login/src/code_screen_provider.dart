import 'package:flutter/material.dart';
import 'package:libcli/dialog/dialog.dart' as dialog;
import 'package:libcli/delta/delta.dart' as delta;
import 'package:reactive_forms/reactive_forms.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:libcli/auth/auth.dart' as auth;
import 'package:beamer/beamer.dart';

/// Code is code field name
const codeField = 'code';

enum VerifyStatus { wait, busy, ok }

/// CodeScreenProvider is provider for code screen
class CodeScreenProvider with ChangeNotifier {
  CodeScreenProvider({
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
    codeField: FormControl<String>(value: null),
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
    final resendCommand = auth.CmdResendCode(email: email);
    final response = await auth.AuthService.of(context).send(resendCommand);
    if (response is pb.Error) {
      dialog.alert(_getErrorTranslation(response.code), warning: true);
      return;
    }

    dialog.alert(
      signupCodeResendEmail,
      icon: Icons.outgoing_mail,
    );
  }

  /// _getErrorTranslation return error code translation
  String _getErrorTranslation(String error) {
    switch (error) {
      case 'CODE_EXPIRED':
      case 'CODE_INVALID':
        return delta.globalContext.i18n.loginCodeScreenErrorCodeInvalid;
      case 'CODE_MISMATCH':
        return delta.globalContext.i18n.loginCodeScreenErrorCodeMismatch;
      case 'NO_CODE':
        return delta.globalContext.i18n.loginCodeScreenErrorNoCode;
      case 'ENTER_BLOCK_SHORT':
        return delta.globalContext.i18n.loginCodeScreenErrorEnterBlockShort;
      case 'ENTER_BLOCK_LONG':
        return delta.globalContext.i18n.loginCodeScreenErrorEnterBlockLong;
      default:
        return error;
    }
  }

  Future<void> onPinSubmit(String pin, bool Function() isMounted) async {
    status = VerifyStatus.busy;
    final verifyCommand = auth.CmdSignupVerify(email: email, code: formGroup.control(codeField).value);
    final response = await auth.AuthService.of(delta.globalContext).send(verifyCommand);
    if (response is pb.Error) {
      status = VerifyStatus.wait;
      dialog.alert(_getErrorTranslation(response.code), warning: true);
      return;
    }

    if (response is pb.OK) {
      status = VerifyStatus.ok;
      final mounted = isMounted();
      if (mounted) {
        delta.globalContext.beamToNamed('setup');
      }
    }
  }
}
