import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/app/app.dart' as app;

/// LoginType define the type of login
enum LoginType { apple, google, facebook, email }

/// LoginFormProvider is a provider for login form
class LoginFormProvider with ChangeNotifier {
  LoginFormProvider();

  @override
  void dispose() {
    locationController.dispose();
    locationFocusNode.dispose();
    super.dispose();
  }

  final TextEditingController locationController = TextEditingController();

  final FocusNode locationFocusNode = FocusNode();

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
    notifyListeners();
  }
}
