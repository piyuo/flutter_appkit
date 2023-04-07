import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:libcli/base/base.dart' as app;

/// LoginType define the type of login
enum LoginType { apple, google, facebook, email }

/// EMailField is email field name
const emailField = 'email';

/// LoginFormProvider is a provider for login form
class LoginFormProvider with ChangeNotifier {
  LoginFormProvider({
    required this.onLoginSucceeded,
  });

  final VoidCallback onLoginSucceeded;

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
  Future<void> onSocialLogin(BuildContext context, LoginType type) async {
    final sessionProvider = app.SessionProvider.of(context);
    final aExpired = DateTime.now().add(const Duration(minutes: 300));
    final rExpired = DateTime.now().add(const Duration(minutes: 800));
    await sessionProvider.login((app.Session(
      userId: 'user1',
      accessToken: app.Token(
        value: 'access',
        expired: aExpired,
      ),
      refreshToken: app.Token(
        value: 'refresh',
        expired: rExpired,
      ),
      args: {
        app.kSessionUserNameKey: 'userName1',
      },
    )));
    onLoginSucceeded();
  }

  /// onEmailLogin is called when user choose email to login
  Future<void> onEmailLogin(BuildContext context) async {}
}
