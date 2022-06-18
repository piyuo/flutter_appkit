import 'package:flutter/material.dart';
import 'package:libcli/types/types.dart' as types;
import 'package:libcli/form/form.dart' as form;
import 'package:libcli/app/app.dart' as app;
import '../src/place_field.dart';
import '../src/open_in_map.dart';
import 'package:reactive_forms/reactive_forms.dart';

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
  final Map countryItems = {
    'en_US': "United States",
    'zh_CN': "China",
    'zh_TW': "Taiwan",
  };

  final formGroup = fb.group({
    'address': FormControl<types.Place>(
        value: types.Place(
      address: '2141 spectrum, irvine, CA 92618',
      latlng: types.LatLng(33.65352503793474, -117.75017169525502),
      tags: ['spectrum', 'irvine', 'CA'],
      country: 'US',
    )),
    'address2': [
      'room 1',
      Validators.email,
    ],
  });

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: ReactiveForm(
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
                          latlng: types.LatLng(104.06534639982326, 30.648558245938407),
                        ),
                        form.p(),
                        form.Submit(
                          label: 'Submit',
                          onSubmit: (context) async {},
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
                    )))));
  }
}
