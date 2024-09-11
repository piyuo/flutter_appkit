import 'package:flutter/material.dart';
import 'package:libcli/apollo/apollo.dart' as apollo;
import 'package:libcli/permission/permission.dart';
import 'package:libcli/testing/testing.dart' as testing;

main() {
  _checkController.addListener(() {
    debugPrint('check controller:${_checkController.value}');
  });

  apollo.start(
    routes: {
      '/': (context, state, data) => const DeltaExample(),
    },
  );
}

final GlobalKey btnMenu = GlobalKey();

final GlobalKey btnTooltip = GlobalKey();

final GlobalKey btnMenuOnBottom = GlobalKey();

final _checkController = ValueNotifier<bool>(false);

class DeltaExample extends StatelessWidget {
  const DeltaExample({super.key});

  @override
  Widget build(BuildContext context) {
    askPermission(_) {
      return Column(
        children: [
          OutlinedButton(
              child: const Text('get location permission'),
              onPressed: () async {
                final result = await getLocationPermission('to show you nearby places');
                debugPrint(result ? 'got permission' : 'denied');
              }),
          OutlinedButton(
              child: const Text('ask location permission'),
              onPressed: () async {
                askLocationPermission(
                  'to show you nearby places',
                );
              }),
        ],
      );
    }

    mayHaveProblemPermission(_) {
      return Column(
        children: [
          OutlinedButton(
              child: const Text('open settings'),
              onPressed: () async {
                var result = await openSettings();
                debugPrint('settings open:$result');
              }),
          OutlinedButton(
              child: const Text('bluetooth permission'),
              onPressed: () async {
                var result = await bluetooth;
                debugPrint(result ? 'got permission' : 'denied');
              }),
          OutlinedButton(
              child: const Text('camera permission'),
              onPressed: () async {
                var result = await camera;
                debugPrint(result ? 'got permission' : 'denied');
              }),
          OutlinedButton(
              child: const Text('photo permission'),
              onPressed: () async {
                var result = await photo;
                debugPrint(result ? 'got permission' : 'denied');
              }),
          OutlinedButton(
              child: const Text('location permission'),
              onPressed: () async {
                var result = await location;
                debugPrint(result ? 'got permission' : 'denied');
              }),
          OutlinedButton(
              child: const Text('notification permission'),
              onPressed: () async {
                var result = await notification;
                debugPrint(result ? 'got permission' : 'denied');
              }),
          OutlinedButton(
              child: const Text('microphone permission'),
              onPressed: () async {
                var result = await microphone;
                debugPrint(result ? 'got permission' : 'denied');
              }),
        ],
      );
    }

    return testing.ExampleScaffold(
      builder: askPermission,
      buttons: [
        testing.ExampleButton('ask location permission on mobile', builder: askPermission),
        testing.ExampleButton('ask permission', builder: mayHaveProblemPermission),
      ],
    );
  }
}
