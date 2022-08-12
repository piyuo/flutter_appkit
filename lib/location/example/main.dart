// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:libcli/testing/testing.dart' as testing;
import 'package:libcli/app/app.dart' as app;
import '../location.dart';

main() => app.start(
      appName: 'location',
      routes: {
        '/': (context, state, data) => const LocationExample(),
      },
    );

class LocationExample extends StatelessWidget {
  const LocationExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Wrap(
            children: [
              Container(
                child: _deviceLatLng(),
              ),
              testing.ExampleButton(
                label: 'get location',
                builder: () => _deviceLatLng(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _deviceLatLng() {
    return OutlinedButton(
        child: const Text('get current location'),
        onPressed: () async {
          final latLng = await deviceLatLng();
          debugPrint('lat:${latLng.lat}, lng:${latLng.lng}');
        });
  }
}
