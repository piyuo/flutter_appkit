import 'package:flutter/material.dart';
import 'package:libcli/types.dart' as types;
import 'package:libcli/form.dart' as form;
import 'package:libcli/i18n.dart' as i18n;
import 'place-field.dart';
import 'open-in-map.dart';

class PlacePlayground extends StatefulWidget {
  @override
  PlacePlaygroundState createState() => PlacePlaygroundState();
}

class PlacePlaygroundState extends State<PlacePlayground> {
  final countryController = TextEditingController();

  final _keyForm = GlobalKey<FormState>();

  final Map countryItems = {
    i18n.en_US: "United States",
    i18n.zh_CN: "China",
    i18n.zh_TW: "Taiwan",
  };

  final addressController = PlaceFieldProvider();

  final address2Controller = TextEditingController();

  final addressWithValueController = PlaceFieldProvider();

  final addressWithValue2Controller = TextEditingController();

  final FocusNode addressFocus = FocusNode();

  final FocusNode address2Focus = FocusNode();

  @override
  void initState() {
    countryController.text = i18n.localeString;
    countryController.addListener(_onCountryChanged);
    addressWithValueController.setPlace(types.Place(
      address: '2141 spectrum, irvine, CA 92618',
      latlng: types.LatLng(33.65352503793474, -117.75017169525502),
      tags: ['spectrum', 'irvine', 'CA'],
      country: 'US',
    ));
    addressWithValue2Controller.text = 'room 1';
    super.initState();
  }

  @override
  void dispose() {
    countryController.removeListener(_onCountryChanged);
    super.dispose();
  }

  /// _onCountryChanged happen when user change country
  void _onCountryChanged() {
    i18n.locale = i18n.stringToLocale(countryController.text);
    i18n.country = i18n.locale.countryCode!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Form(
            key: _keyForm,
            child: SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        form.DropdownField(
                          controller: countryController,
                          items: countryItems,
                          label: 'Country',
                        ),
                        form.p(),
                        PlaceField(
                          controller: addressController,
                          label: 'Address',
                          focusNode: addressFocus,
                          nextFocusNode: address2Focus,
                          require: 'you must input address!',
                        ),
                        form.InputField(
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
                          'Submit form',
                          form: _keyForm,
                          onClick: () async {},
                        ),
                        PlaceField(
                          controller: addressWithValueController,
                          label: 'Address with value',
                        ),
                        form.InputField(
                          controller: addressWithValue2Controller,
                        ),
                      ],
                    )))));
  }
}
