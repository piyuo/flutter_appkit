import 'package:flutter/material.dart';
import 'package:libcli/types/types.dart' as types;
import 'package:libcli/form/form.dart' as form;
import 'package:libcli/app/app.dart' as app;
import '../src/place_field.dart';
import '../src/open_in_map.dart';

main() => app.start(
      appName: 'place',
      routes: {
        '/': (context, state, data) => const PlaceExample(),
      },
    );

class PlaceExample extends StatefulWidget {
  const PlaceExample({Key? key}) : super(key: key);

  @override
  PlaceExampleState createState() => PlaceExampleState();
}

class PlaceExampleState extends State<PlaceExample> {
  final _keyForm = GlobalKey<FormState>();

  final Map countryItems = {
    'en_US': "United States",
    'zh_CN': "China",
    'zh_TW': "Taiwan",
  };

  final addressController = ValueNotifier<types.Place>(types.Place.empty);

  final address2Controller = TextEditingController();

  final addressWithValueController = ValueNotifier<types.Place>(types.Place.empty);

  final addressWithValue2Controller = TextEditingController();

  final FocusNode addressFocus = FocusNode();

  final FocusNode address2Focus = FocusNode();

  @override
  void initState() {
    addressWithValueController.value = types.Place(
      address: '2141 spectrum, irvine, CA 92618',
      latlng: types.LatLng(33.65352503793474, -117.75017169525502),
      tags: ['spectrum', 'irvine', 'CA'],
      country: 'US',
    );
    addressWithValue2Controller.text = 'room 1';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Form(
            key: _keyForm,
            child: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        PlaceField(
                          key: const Key('test-place'),
                          controller: addressController,
                          label: 'Address',
                          focusNode: addressFocus,
                          nextFocusNode: address2Focus,
                          requiredField: true,
                        ),
                        form.InputField(
                          key: const Key('test-place2'),
                          controller: address2Controller,
                          focusNode: address2Focus,
                          hint: '(Optional) Floor/Room/Building number',
                        ),
                        form.p(),
                        OpenInMap(
                          label: 'open in external map',
                          address: '成都市锦江区人民南路二段80号 邮政编码: 610012',
                          latlng: types.LatLng(104.06534639982326, 30.648558245938407),
                        ),
                        form.p(),
                        form.Submit(
                          key: const Key('submit'),
                          label: 'Submit form',
                          formKey: _keyForm,
                          onPressed: () async {},
                        ),
                        PlaceField(
                          key: const Key('test-place-value'),
                          controller: addressWithValueController,
                          label: 'Address with value',
                        ),
                        form.InputField(
                          key: const Key('test-place2-value'),
                          controller: addressWithValue2Controller,
                        ),
                      ],
                    )))));
  }
}
