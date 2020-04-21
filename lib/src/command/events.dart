import 'package:libcli/eventbus.dart';

/// ENetworkSlow happen when [http post take too long], need let user know their network is slow than usual
///
class ENetworkSlow {}

/// ERefuseInternet happen when [user refuse to  connect] to internet, listener let user know they need connect to then internet
///
class ERefuseInternet {}

/// ERefuseSignin happen when [user refuse to  sign in], let user know they need signin or register account
///
class ERefuseSignin {}
