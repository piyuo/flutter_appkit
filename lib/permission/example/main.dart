import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/testing/testing.dart' as testing;
import 'package:libcli/app/app.dart' as app;

import '../permission.dart';

main() {
  _checkController.addListener(() {
    debugPrint('check controller:${_checkController.value}');
  });

  app.start(
    appName: 'permission example',
    routesBuilder: () => {
      '/': (context, state, data) => const DeltaExample(),
    },
  );
}

final GlobalKey btnMenu = GlobalKey();

final GlobalKey btnTooltip = GlobalKey();

final GlobalKey btnMenuOnBottom = GlobalKey();

final _checkController = ValueNotifier<bool>(false);

class DeltaExample extends StatelessWidget {
  const DeltaExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: _checkController,
        child: Consumer<ValueNotifier<bool>>(
            builder: (context, model, child) => Scaffold(
                  body: SafeArea(
                    child: Wrap(
                      children: [
                        SizedBox(
                          height: 400,
                          child: _askPermission(context),
                        ),
                        testing.ExampleButton(
                          label: 'ask location permission on mobile',
                          builder: () => _askPermission(context),
                        ),
                        testing.ExampleButton(
                            label: 'ask permission', builder: () => _mayHaveProblemPermission(context)),
                      ],
                    ),
                  ),
                )));
  }

  Widget _askPermission(BuildContext context) {
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

  Widget _mayHaveProblemPermission(BuildContext context) {
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
}
