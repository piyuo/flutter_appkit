import 'package:libcli/eventbus.dart';

///CInternetRequired  happen when [internet not connected], listener need let user connect to the internet then report back
///
class CInternetRequired extends Contract {}

///CAccessTokenRequired  happen when [service need access token], listener need let user sign in or use refresh token to get access token
///
class CAccessTokenRequired extends Contract {}

///CAccessTokenExpired happen when [access token expired], listener need let user sign in or use refresh token to get access token
///
class CAccessTokenExpired extends Contract {}

///CPaymentTokenRequired happen when [service need payment token], listener need let user sign in immedately
///
class CPaymentTokenRequired extends Contract {}
