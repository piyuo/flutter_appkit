import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:libcli/auth/auth.dart' as auth;
import 'package:libcli/dialog/dialog.dart' as dialog;
import 'session_provider.dart';

/// LoginType define the type of login
enum LoginType { apple, google, facebook, email }

/// EMailField is email field name
const emailField = 'email';

/// LoginFormProvider is a provider for login form
class LoginFormProvider with ChangeNotifier {
  @override
  void dispose() {
    formGroup.dispose();
    super.dispose();
  }

  final formGroup = fb.group({
    emailField: [
      '',
      Validators.required,
      Validators.email,
    ],
  });

  /// of get BranchModel from context
  static LoginFormProvider of(BuildContext context) {
    return Provider.of<LoginFormProvider>(context, listen: false);
  }

  /// onSocialLogin is called when the social button is pressed
  Future<Session?> socialLogin(BuildContext context, LoginType type) async {
    final sessionProvider = SessionProvider.of(context);
    final aExpired = DateTime.now().add(const Duration(minutes: 300));
    final rExpired = DateTime.now().add(const Duration(minutes: 800));
    final session = (Session(
      userId: 'user1',
      accessToken: Token(
        value: 'access',
        expired: aExpired,
      ),
      refreshToken: Token(
        value: 'refresh',
        expired: rExpired,
      ),
      args: {
        kSessionUserNameKey: 'userName1',
      },
    ));
    await sessionProvider.login(session);
    return session;
  }

  /// emailLogin is called when user choose email to login, return true if verification email is sent
  Future<bool> emailLogin(BuildContext context, String email) async {
    final authService = auth.AuthService.of(context);
    final response = await authService.send(auth.VerifyEmailAction(email: email));
    if (response is auth.VerifyEmailResponse) {
      switch (response.result) {
        case auth.VerifyEmailResponse_Result.RESULT_OK:
          return true;
        case auth.VerifyEmailResponse_Result.RESULT_EMAIL_INVALID:
          dialog.alert('Email is invalid');
          break;
        case auth.VerifyEmailResponse_Result.RESULT_EMAIL_REJECT:
          dialog.alert('Email is rejected');
          break;
        case auth.VerifyEmailResponse_Result.RESULT_UNSPECIFIED:
          dialog.alert('Unspecified error');
          break;
      }
    }
    return false;
  }
}
