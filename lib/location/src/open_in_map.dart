import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:libcli/general/general.dart' as types;
import 'map.dart';

/// PlaceField let user set his place, it contain address, lat/lng and address tags
class OpenInMap extends StatelessWidget {
  const OpenInMap({
    Key? key,
    required this.latlng,
    required this.address,
    required this.label,
  }) : super(key: key);

  /// latlng is the lat/lng need to open in map
  final types.LatLng latlng;

  /// address is the address need to open in map
  final String address;

  /// label like 'open in external map'
  final String label;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () async {
          var url = mapUrl(address, latlng);
          final uri = Uri.parse(url);
          await launchUrl(uri);
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
