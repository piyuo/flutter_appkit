import 'package:flutter/material.dart';
import 'place-field.dart';
import 'package:libcli/types.dart' as types;
import 'package:libcli/env.dart' as env;
import 'package:libcli/form.dart' as form;
import 'package:libcli/i18n.dart' as i18n;

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

  final addressController = types.PlaceController();

  final address2Controller = TextEditingController();

  final FocusNode addressFocus = FocusNode();

  final FocusNode address2Focus = FocusNode();

  PlacePlaygroundState() {
    env.branch = env.BRANCH_MASTER;
  }

  @override
  void initState() {
    countryController.text = i18n.localeString;
    countryController.addListener(_onCountryChanged);
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
                    form.Submit(
                      'Submit form',
                      form: _keyForm,
                      onClick: () async {},
                    ),
                  ],
                ))));
  }
}
