import 'package:flutter/widgets.dart';
import 'package:libcli/sys/sys.dart' as sys;
import 'package:libcli/types/types.dart' as types;

/// GeoClient use sys service to get geographic information
class GeoClient {
  /// sessionToken may generate by server, keep search in same session will reduce cost and increase accuracy
  var sessionToken = '';

  /// use sys service to get suggestion
  final sys.SysService sysService = sys.SysService();

  /// autoComplete return suggestion base on input
  ///
  ///     final suggestions = await geoClient.autoComplete(ctx, '165', types.LatLng(33.7338518, -117.7403496));
  ///
  Future<List<sys.GeoSuggestion>> autoComplete(BuildContext ctx, String input, types.LatLng l) async {
    var response = await sysService.send(
      sys.CmdAutoComplete(
        sessionToken: sessionToken,
        input: input,
        lat: l.lat,
        lng: l.lng,
      ),
      builder: () => sys.GeoSuggestions(),
    );

    if (response is sys.GeoSuggestions) {
      sessionToken = response.sessionToken;
      return response.result;
    }
    return [];
  }

  /// getLocation return location on suggestion id
  ///
  ///     final location = await geoClient.getLocation(ctx, suggestion.id);
  ///
  Future<sys.GeoLocation?> getLocation(BuildContext ctx, String suggestionID) async {
    var response = await sysService.send(
      sys.CmdGetLocation(
        sessionToken: sessionToken,
        suggestionID: suggestionID,
      ),
      builder: () => sys.GeoLocation(),
    );

    if (response is sys.GeoLocation) {
      return response;
    }
    return null;
  }

  /// getLocation return location on suggestion id
  ///
  ///     final locations = await geoClient.reverseGeocoding(testing.Context(), types.LatLng(33.7338518, -117.7403496));
  ///
  Future<List<sys.GeoLocation>> reverseGeocoding(BuildContext ctx, types.LatLng l) async {
    var response = await sysService.send(
      sys.CmdReverseGeocoding(
        lat: l.lat,
        lng: l.lng,
      ),
      builder: () => sys.GeoLocations(),
    );

    if (response is sys.GeoLocations) {
      return response.result;
    }
    return [];
  }
}
