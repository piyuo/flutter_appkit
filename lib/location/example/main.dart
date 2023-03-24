// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/general/general.dart' as general;
import 'package:libcli/testing/testing.dart' as testing;
import 'package:libcli/app/app.dart' as app;
import 'package:libcli/form/form.dart' as form;
//import 'package:libcli/general/general.dart' as general;
import '../location.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// _mapProvider control map value
//final MapProvider _mapProvider = mapProvider();
final countryItems = {
  'en_US': "United States",
  'zh_CN': "China",
  'zh_TW': "Taiwan",
};

final formGroup = fb.group({
  'address': FormControl<general.Place>(
      value: general.Place(
    address: '2141 spectrum, irvine, CA 92618',
    latlng: general.LatLng(33.65352503793474, -117.75017169525502),
    tags: ['spectrum', 'irvine', 'CA'],
    country: 'US',
  )),
  'address2': [
    'room 1',
    Validators.email,
  ],
});

final TextEditingController _textEditingController = TextEditingController();
final FocusNode _focusNode = FocusNode();
final FocusNode _focusNode2 = FocusNode();

main() {
  app.start(
    appName: 'location example',
    routesBuilder: () => {
      '/': (context, state, data) => const LocationExample(),
    },
    theme: theme(),
    darkTheme: darkTheme(),
    builder: () async {
      return [];
      /*
        await _mapProvider.setValue(general.LatLng(49.4540877, -173.7548384), true);
        return [
          ChangeNotifierProvider<MapProvider>.value(
            value: _mapProvider,
          )
        ];*/
    },
  );
}

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
                child: _locateTextField(),
              ),
              testing.ExampleButton(
                label: 'get location',
                builder: () => _getCurrentLocation(),
              ),
              testing.ExampleButton(
                label: 'place',
                builder: () => _place(),
              ),
              testing.ExampleButton(
                label: 'LocateTextField',
                builder: () => _locateTextField(),
              ),
              testing.ExampleButton(
                label: 'map',
                builder: () => _map(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getCurrentLocation() {
    return OutlinedButton(
        child: const Text('get current location'),
        onPressed: () async {
          final latLng = await getCurrentLocation('to get current location');
          latLng != null ? debugPrint('got lat:${latLng.lat}, lng:${latLng.lng}') : debugPrint('permission denied');
        });
  }

  Widget _locateTextField() {
    return Column(children: [
      Container(
        padding: const EdgeInsets.all(20),
        child: LocateTextField(
          reason: 'to get current location',
          controller: _textEditingController,
          focusNode: _focusNode,
          suggestionsBuilder: (TextEditingValue value) {
            return ['aa', 'bb', 'cc'];
          },
          onUseMyLocation: (general.LatLng value) {
            debugPrint('lat:${value.lat}, lng:${value.lng}');
          },
          onSubmitted: (String text) {
            debugPrint('text:$text, controller:${_textEditingController.text}');
          },
        ),
      ),
      OutlinedButton(
        focusNode: _focusNode2,
        onPressed: () {},
        child: const Text('hello'),
      ),
    ]);
  }

  Widget _place() {
    return ReactiveForm(
        formGroup: formGroup,
        child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    PlaceField(
                      formControlName: 'address',
                    ),
                    ReactiveTextField(
                      formControlName: 'address2',
                      decoration: const InputDecoration(
                        hintText: '(Optional) Floor/Room/Building number',
                      ),
                    ),
                    form.p(),
                    OpenInMap(
                      label: 'open in external map',
                      address: '成都市锦江区人民南路二段80号 邮政编码: 610012',
                      latlng: general.LatLng(104.06534639982326, 30.648558245938407),
                    ),
                    form.p(),
                    form.Submit(
                      onSubmit: (context) async => true,
                    ),
                    PlaceField(
                      formControlName: 'address',
                    ),
                    ReactiveTextField(
                      formControlName: 'address2',
                      decoration: const InputDecoration(
                        hintText: '(Optional) Floor/Room/Building number',
                      ),
                    ),
                  ],
                ))));
  }

  // not working, need to fix
  Widget _map() {
    return Consumer<MapProvider>(
      builder: (context, provide, child) => map(),
    );
  }
}

ThemeData? theme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF00677E),
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFFB4EBFF),
      onPrimaryContainer: Color(0xFF001F27),
      secondary: Color(0xFF4C626A),
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFFCEE6F0),
      onSecondaryContainer: Color(0xFF061E25),
      tertiary: Color(0xFF006399),
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFFCDE5FF),
      onTertiaryContainer: Color(0xFF001D32),
      error: Color(0xFFBA1A1A),
      errorContainer: Color(0xFFFFDAD6),
      onError: Color(0xFFFFFFFF),
      onErrorContainer: Color(0xFF410002),
      background: Color(0xFFFBFCFE),
      onBackground: Color(0xFF191C1D),
      surface: Color(0xFFFBFCFE),
      onSurface: Color(0xFF191C1D),
      surfaceVariant: Color(0xFFDBE4E8),
      onSurfaceVariant: Color(0xFF40484B),
      outline: Color(0xFF70787C),
      onInverseSurface: Color(0xFFEFF1F2),
      inverseSurface: Color(0xFF2E3132),
      inversePrimary: Color(0xFF5AD5F9),
      shadow: Color(0xFF000000),
      surfaceTint: Color(0xFF00677E),
      outlineVariant: Color(0xFFBFC8CC),
      scrim: Color(0xFF000000),
    ),
  );
}

ThemeData? darkTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF5AD5F9),
      onPrimary: Color(0xFF003542),
      primaryContainer: Color(0xFF004E5F),
      onPrimaryContainer: Color(0xFFB4EBFF),
      secondary: Color(0xFFB3CAD4),
      onSecondary: Color(0xFF1D333B),
      secondaryContainer: Color(0xFF344A52),
      onSecondaryContainer: Color(0xFFCEE6F0),
      tertiary: Color(0xFF94CCFF),
      onTertiary: Color(0xFF003352),
      tertiaryContainer: Color(0xFF004B74),
      onTertiaryContainer: Color(0xFFCDE5FF),
      error: Color(0xFFFFB4AB),
      errorContainer: Color(0xFF93000A),
      onError: Color(0xFF690005),
      onErrorContainer: Color(0xFFFFDAD6),
      background: Color(0xFF191C1D),
      onBackground: Color(0xFFE1E3E4),
      surface: Color(0xFF191C1D),
      onSurface: Color(0xFFE1E3E4),
      surfaceVariant: Color(0xFF40484B),
      onSurfaceVariant: Color(0xFFBFC8CC),
      outline: Color(0xFF899296),
      onInverseSurface: Color(0xFF191C1D),
      inverseSurface: Color(0xFFE1E3E4),
      inversePrimary: Color(0xFF00677E),
      shadow: Color(0xFF000000),
      surfaceTint: Color(0xFF5AD5F9),
      outlineVariant: Color(0xFF40484B),
      scrim: Color(0xFF000000),
    ),
  );
}
