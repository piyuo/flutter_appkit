import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:libcli/types.dart' as types;
import 'package:libcli/locate.dart' as locate;

/// PlaceField let user set his place, it contain address, lat/lng and address tags
class OpenInMap extends StatelessWidget {
  OpenInMap({
    required this.latlng,
    required this.label,
  });

  /// latlng is the lat/lng need to open in map
  final types.LatLng latlng;

  /// label like 'open in external map'
  final String label;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () async {
          var url = locate.mapUrl(latlng);
          await launch(
            url,
            forceSafariVC: false,
          );
        },
        child: Row(children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.blue[800],
              decoration: TextDecoration.underline,
            ),
          ),
        ]));
  }
}
