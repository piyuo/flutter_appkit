import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:provider/provider.dart';
import 'package:libcli/auth/auth.dart' as auth;
import 'package:libcli/dialog/dialog.dart' as dialog;
import 'package:libcli/apollo/apollo.dart' as apollo;

/// LoginType define the type of login
enum LoginType { apple, google, facebook, email }

/// EMailField is email field name
const emailField = 'email';

class SigninProvider with ChangeNotifier {
  final formGroup = fb.group({
    emailField: [
      '',
      Validators.required,
      Validators.email,
    ],
  });

  @override
  void dispose() {
    formGroup.dispose();
    super.dispose();
  }

  /// of get instance from context
  static SigninProvider of(BuildContext context) {
    return Provider.of<SigninProvider>(context, listen: false);
  }

  /// onSocialLogin is called when the social button is pressed
  Future<apollo.Session?> socialLogin(BuildContext context, LoginType type) async {
    final sessionProvider = apollo.SessionProvider.of(context);
    final aExpired = DateTime.now().add(const Duration(minutes: 300));
    final rExpired = DateTime.now().add(const Duration(minutes: 800));
    final session = apollo.Session(
      accessToken: apollo.Token(
        value: 'access',
        expired: aExpired,
      ),
      refreshToken: apollo.Token(
        value: 'refresh',
        expired: rExpired,
      ),
      args: {
        apollo.kSessionUserNameKey: 'userName1',
      },
    );
    await sessionProvider.login(session);
    return session;
  }

  /// sendVerificationEmail is called when user choose email to login, return true if verification email is sent
  Future<bool> sendVerificationEmail(BuildContext context, String email) async {
    final authService = auth.AuthService.of(context);
    final response = await authService.send(auth.VerifyEmailAction(email: email));
    return isPinSent(response);
  }
}

/// isPinSent return true if pin is sent, otherwise return false and show error dialog
bool isPinSent(response) {
  if (response is auth.SendPinResponse) {
    switch (response.result) {
      case auth.SendPinResponse_Result.RESULT_OK:
        return true;
      case auth.SendPinResponse_Result.RESULT_MAIL_SERVICE_ERROR:
        dialog.alert('Mail service is currently unavailable, please try again later');
        break;
      case auth.SendPinResponse_Result.RESULT_EMAIL_REJECT:
        dialog.alert('Email is rejected');
        break;
      default:
        assert(false, 'Unknown error code ${response.result}');
    }
  }
  return false;
}
