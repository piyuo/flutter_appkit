import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/commands/sys/sys.dart' as sys;
import 'package:libcli/types.dart' as types;
import 'package:libcli/locate.dart' as locate;
import 'package:libcli/dialog.dart' as dialog;
import 'package:libcli/i18n.dart' as i18n;
import 'package:libcli/delta.dart' as delta;
import 'search-bar.dart';
import 'search-view.dart';
import 'geo-client.dart';

/// ConfirmButtonProvider control confirm button is visibility
class ConfirmButtonProvider extends types.BoolProvider {
  bool get visible => boolValue;
}

/// MyLocationButtonProvider control my location button visibility
class MyLocationButtonProvider extends types.BoolProvider {
  bool get visible => boolValue;
}

/// MyLocationButtonProvider control my location button visibility
class ShowSearchProvider with ChangeNotifier {
  ShowSearchProvider(BuildContext context, types.Place place) {
    _confirmButtonProvider = ConfirmButtonProvider();
    _myLocationButtonProvider = MyLocationButtonProvider();
    _barProvider = SearchBarProvider(
      confirmButtonProvider: _confirmButtonProvider,
      onUserTyping: (String text) {
        _confirmButtonProvider.setValue(false);
        _selectedLocation = null;
      },
      onQuerySuggestions: (String inputString) async {
        final list = await _geoClient.autoComplete(
          context,
          inputString,
          _deviceLatLng,
        );
        _suggestions = Map.fromIterable(list, key: (i) => i.text, value: (i) => i);
        return list.map((sys.GeoSuggestion suggestion) => suggestion.text).toList();
      },
      onUserSelected: (String text, bool suggestionOrLocation) async {
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
      },
      onClickConfirm: () => _clickConfirm(context),
    );

    _viewProvider = SearchViewProvider(
      confirmButtonProvider: _confirmButtonProvider,
      myLocationButtonProvider: _myLocationButtonProvider,
      onClickMyLocation: (ctx) async {
        if (_locations.length == 0) {
          final list = await _geoClient.reverseGeocoding(ctx, _deviceLatLng);
          _locations = Map.fromIterable(list, key: (i) => i.address, value: (i) => i);
        }

        if (_locations.length == 0) {
          var provider = Provider.of<i18n.I18nProvider>(ctx, listen: false);
          var text = provider.translate('myLocFail');
          dialog.alert(context, text);
          return;
        }

        // debug only 1 location
        //while (_locations.length > 1) _locations.remove(_locations.entries.first.key);

        final firstLocation = _locations.entries.first.value;
        if (_locations.length == 1) {
          _barProvider.setValue(firstLocation.address, []);
          showLocationToConfirm(firstLocation);
          return;
        }
        _barProvider.setValue(
          firstLocation.address,
          _locations.entries.map((e) => e.value).toList(),
        );
      },
      onClickConfirm: () => _clickConfirm(context),
    );

    if (!place.isEmpty) {
      _mapProvider.setValue(place.latlng, true);
    }
    _barProvider.setValue(place.address, []);

    locate.deviceLatLng().then((latlng) {
      if (_stopDeviceLatlng) {
        return;
      }
      _deviceLatLng = latlng;
      if (!_deviceLatLng.isEmpty) {
        _myLocationButtonProvider.setValue(true);
        if (place.isEmpty) {
          _mapProvider.setValue(_deviceLatLng, false);
        }
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _stopDeviceLatlng = true;
    _suggestions.clear();
    _locations.clear();
    super.dispose();
  }

  /// _mapProvider control map value
  locate.MapProvider _mapProvider = locate.mapProvider();

  /// _confirmProvider control confirm button
  late final ConfirmButtonProvider _confirmButtonProvider;

  /// _confirmProvider control confirm button
  late final MyLocationButtonProvider _myLocationButtonProvider;

  /// _barProvider control search bar
  late final SearchBarProvider _barProvider;

  /// _viewProvider control search view
  late final SearchViewProvider _viewProvider;

  /// _geoClient connect to backend service to get suggestion / reverse geocoding...
  final _geoClient = GeoClient();

  /// _suggestions keep all suggestion when user typing in search bar
  var _suggestions = <String, sys.GeoSuggestion>{};

  ///  _locations keep all locations when user click my location button
  var _locations = <String, sys.GeoLocation>{};

  ///  _selectedLocation keep user selected location
  sys.GeoLocation? _selectedLocation;

  // deviceLatLng will be set if user allow get device latlng, otherwise it will be empty
  var _deviceLatLng = types.LatLng.empty;

  // _stopDeviceLatlng prevent get deviceLatlng handling after dispose
  var _stopDeviceLatlng = false;

  /// showLocationToConfirm show location on map let user confirm
  void showLocationToConfirm(sys.GeoLocation loc) {
    _stopDeviceLatlng = true;
    _selectedLocation = loc;
    _mapProvider.setValue(
        types.LatLng(
          _selectedLocation!.lat,
          _selectedLocation!.lng,
        ),
        true);
    _confirmButtonProvider.setValue(true);
  }

  void _clickConfirm(BuildContext context) {
    if (_selectedLocation == null) {
      return;
    }
    Navigator.of(context).pop(types.Place(
      address: _selectedLocation!.address,
      latlng: types.LatLng(
        _selectedLocation!.lat,
        _selectedLocation!.lng,
      ),
      tags: _selectedLocation!.tags,
      country: _selectedLocation!.country,
    ));
  }
}

class ShowSearch extends StatelessWidget {
  const ShowSearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<ShowSearchProvider, i18n.I18nProvider>(
      builder: (context, showSearchProvider, i18nProvider, child) => delta.Await(
        [i18nProvider],
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider.value(
              value: showSearchProvider._mapProvider,
            ),
            ChangeNotifierProvider.value(
              value: showSearchProvider._confirmButtonProvider,
            ),
            ChangeNotifierProvider.value(
              value: showSearchProvider._myLocationButtonProvider,
            ),
            ChangeNotifierProvider.value(
              value: showSearchProvider._barProvider,
            ),
            ChangeNotifierProvider.value(
              value: showSearchProvider._viewProvider,
            ),
          ],
          child: Scaffold(
            /*appBar: TopBar(
              titleSpacing: 0,
              title: SearchBar(),
              elevation: 0,
            ),*/

            appBar: AppBar(
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              title: SearchBar(),
              elevation: 0,
            ),
            body: Column(
              children: const <Widget>[
                Expanded(
                  child: SearchView(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
