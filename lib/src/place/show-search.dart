import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/commands/sys/sys.dart' as sys;
import 'package:libcli/types.dart' as types;
import 'package:libcli/locate.dart' as locate;
import 'package:libcli/dialog.dart' as dialog;
import 'package:libcli/i18n.dart' as i18n;
import 'package:libcli/module.dart' as module;
import 'search-bar.dart';
import 'search-view.dart';
import 'geo-client.dart';

class ShowSearch extends StatefulWidget {
  ShowSearch({
    required this.place,
    Key? key,
  }) : super(key: key);

  final types.Place place;

  @override
  State<ShowSearch> createState() => ShowSearchState();
}

class ShowSearchState extends State<ShowSearch> {
  /// _geoClient connect to backend service to get suggestion / reverse geocoding...
  final _geoClient = GeoClient();

  /// _barController control search bar
  final _barController = SearchBarValueController();

  /// _mapController control map value
  final _mapController = locate.MapValueController();

  /// _confirmController control confirm button
  final _confirmController = types.BoolController();

  /// _suggestions keep all suggestion when user typing in search bar
  var _suggestions = <String, sys.GeoSuggestion>{};

  ///  _locations keep all locations when user click my location button
  var _locations = <String, sys.GeoLocation>{};

  ///  _selectedLocation keep user selected location
  sys.GeoLocation? _selectedLocation;

  // _showMyLocationButton is true will show my location button
  var _showMyLocationButton = false;

  // deviceLatLng will be set if user allow get device latlng, otherwise it will be empty
  var _deviceLatLng = types.LatLng.empty;

  // _stopDeviceLatlng prevent get deviceLatlng handling after dispose
  var _stopDeviceLatlng = false;

  @override
  void initState() {
    if (!widget.place.isEmpty) {
      _mapController.value = locate.MapValue(latlng: widget.place.latlng, showMarker: true);
    }
    _barController.value = SearchBarValue(address: widget.place.address);
    locate.deviceLatLng().then((latlng) {
      if (_stopDeviceLatlng) {
        return;
      }
      _deviceLatLng = latlng;
      if (!_deviceLatLng.isEmpty) {
        setState(() {
          _showMyLocationButton = true;
          if (widget.place.isEmpty) {
            _mapController.value = locate.MapValue(latlng: _deviceLatLng, showMarker: false);
          }
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _stopDeviceLatlng = true;
    _suggestions.clear();
    _locations.clear();
    super.dispose();
  }

  /// showLocationToConfirm show location on map let user confirm
  void showLocationToConfirm(sys.GeoLocation loc) {
    _stopDeviceLatlng = true;
    _selectedLocation = loc;
    _mapController.value = locate.MapValue(
        showMarker: true,
        latlng: types.LatLng(
          _selectedLocation!.lat,
          _selectedLocation!.lng,
        ));

    _confirmController.value = true;
  }

  void _onBarUserTyping(String text) {
    _confirmController.value = false;
    _selectedLocation = null;
  }

  /// _onBarUserTyping trigger when user typing
  Future<List<String>> _onQuerySuggestions(BuildContext context, String inputString) async {
    final list = await _geoClient.autoComplete(
      context,
      inputString,
      _deviceLatLng,
    );
    _suggestions = Map.fromIterable(list, key: (i) => i.text, value: (i) => i);
    return list.map((sys.GeoSuggestion suggestion) => suggestion.text).toList();
  }

  Future<void> _onBarSelected(BuildContext context, String text, bool suggestionOrLocation) async {
    if (suggestionOrLocation) {
      var suggestion = _suggestions[text];
      final loc = await _geoClient.getLocation(context, suggestion!.id);
      if (loc == null) {
        dialog.alert(context, 'cant get location, please try another address');
        return;
      }
      showLocationToConfirm(loc);
      return;
    }

    //location
    var loc = _locations[text];
    showLocationToConfirm(loc!);
  }

  void _onClickConfirm() {
    if (_selectedLocation == null) {
      return;
    }
    types.Place p = types.Place(
      address: _selectedLocation!.address,
      latlng: types.LatLng(
        _selectedLocation!.lat,
        _selectedLocation!.lng,
      ),
      tags: _selectedLocation!.tags,
    );
    Navigator.of(context).pop(p);
  }

  void _onClickMyLocation(BuildContext context) async {
    if (_locations.length == 0) {
      final list = await _geoClient.reverseGeocoding(context, _deviceLatLng);
      _locations = Map.fromIterable(list, key: (i) => i.address, value: (i) => i);
    }

    if (_locations.length == 0) {
      var provider = Provider.of<i18n.I18nProvider>(context, listen: false);
      var text = provider.translate('myLocFail');
      dialog.alert(context, text);
      return;
    }

    final firstLocation = _locations.entries.first.value;
    if (_locations.length == 1) {
      _barController.value = SearchBarValue(
        address: firstLocation.address,
        locations: [],
      );
      showLocationToConfirm(firstLocation);
      return;
    }

    _barController.value = SearchBarValue(
      address: firstLocation.address,
      locations: _locations.entries.map((e) => e.value).toList(),
    );
  }

//Text('Please enter your address', style: TextStyle(color: Colors.grey))
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => i18n.I18nProvider(
        fileName: 'place',
        package: 'libcli',
      ),
      child: Consumer<i18n.I18nProvider>(
        builder: (context, i18nProvider, child) => module.Await(
          list: [i18nProvider],
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              title: SearchBar(
                controller: _barController,
                confirmButtonController: _confirmController,
                onUserTyping: _onBarUserTyping,
                onQuerySuggestions: _onQuerySuggestions,
                onUserSelected: _onBarSelected,
                onClickConfirm: _onClickConfirm,
              ),
              elevation: 0,
            ),
            body: Column(
              children: <Widget>[
                Expanded(
                  child: SearchView(
                    showMyLocationButton: _showMyLocationButton,
                    mapController: _mapController,
                    confirmButtonController: _confirmController,
                    onClickMyLocation: () => _onClickMyLocation(context),
                    onClickConfirm: _onClickConfirm,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
