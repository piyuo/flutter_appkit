import 'package:libcli/auth/auth.dart' as auth;
import 'package:libcli/global/global.dart' as global;
import 'package:libcli/net/net.dart' as net;

void mockAuthResponse(auth.AuthService authService) {
  authService.mock = (net.Object action, {net.Builder? builder}) async {
    if (action is auth.VerifyEmailAction) {
      return auth.SendPinResponse(result: auth.SendPinResponse_Result.RESULT_OK);
    }

    if (action is auth.LoginPinAction || action is auth.LoginTokenAction) {
      return auth.LoginPinResponse(
        result: auth.LoginPinResponse_Result.RESULT_OK,
        access: auth.Access(
          state: auth.Access_State.STATE_OK,
          region: auth.Access_Region.REGION_UNSPECIFIED,
          accessToken: 'fakeAccess',
          accessExpire: DateTime.now().add(const Duration(seconds: 300)).timestamp,
          refreshToken: 'fakeRefresh',
          refreshExpire: DateTime.now().add(const Duration(days: 300)).timestamp,
          args: {
            global.kSessionUserNameKey: 'user1',
            global.kSessionUserPhotoKey: 'https://cdn.pixabay.com/photo/2014/04/03/11/56/avatar-312603_640.png',
            'region': 'region1',
          },
        ),
      );
    }

    if (action is auth.ResendPinAction) {
      return auth.SendPinResponse(result: auth.SendPinResponse_Result.RESULT_OK);
    }
    throw Exception('$action is not supported');
  };
}
