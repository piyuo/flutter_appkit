// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:provider/provider.dart';
import 'package:libcli/auth/auth.dart' as auth;
import 'package:libcli/dialog/dialog.dart' as dialog;
import 'package:libcli/apollo/apollo.dart' as apollo;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

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

  /// withApple called when user choose apple to login
  Future<bool> withApple() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    print(credential);
    return true;
  }

  /// withGoogle called when user choose google to login
  Future<bool> withGoogle() async {
    GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
    try {
      await googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
    return true;
  }

  /// withFacebook called when user choose facebook to login
  Future<bool> withFacebook() async {
    final LoginResult result =
        await FacebookAuth.instance.login(); // by default we request the email and the public profile

    // loginBehavior is only supported for Android devices, for ios it will be ignored
    // final result = await FacebookAuth.instance.login(
    //   permissions: ['email', 'public_profile', 'user_birthday', 'user_friends', 'user_gender', 'user_link'],
    //   loginBehavior: LoginBehavior
    //       .DIALOG_ONLY, // (only android) show an authentication dialog instead of redirecting to facebook app
    // );

    if (result.status == LoginStatus.success) {
      result.accessToken;
      // get the user data
      // by default we get the userId, email,name and picture
      final userData = await FacebookAuth.instance.getUserData();
      // final userData = await FacebookAuth.instance.getUserData(fields: "email,birthday,friends,gender,link");
      userData;
    } else {
      print(result.status);
      print(result.message);
    }
    return true;
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
