import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:libcli/app/app.dart' as app;
import 'code_screen.dart';

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

  /// onButtonPressed is called when the button is pressed
  void onButtonPressed(BuildContext context, LoginType type) {
    final sessionProvider = app.SessionProvider.of(context);
    final aExpired = DateTime.now().add(const Duration(minutes: 300));
    final rExpired = DateTime.now().add(const Duration(minutes: 800));
    sessionProvider.login((app.Session(
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
        'user': 'user1',
        'img': 'img1',
        'region': 'region1',
      },
    )));
  }

  /// onEmailSignin is called when user choose email to login
  Future<bool> onEmailSignin(BuildContext context) async {
    final email = formGroup.control(emailField).value as String;
    //await Future.delayed(Duration(seconds: 2));
    Navigator.push(context, MaterialPageRoute(builder: (context) => CodeScreen(email: email)));
    return false;
  }
}
