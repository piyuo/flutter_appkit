import 'dart:async';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:libcli/utils/utils.dart' as general;
import 'package:libcli/sys/sys.dart' as sys;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'search_confirm.dart';
import 'show_search.dart';

const double _confirmButtonWidth = 75;

/// SearchBarProvider control search bar
class SearchBarProvider with ChangeNotifier {
  SearchBarProvider({
    required this.confirmButtonProvider,
    required this.onUserTyping,
    required this.onQuerySuggestions,
    required this.onUserSelected,
    required this.onClickConfirm,
  }) {
    _addressEditingController.addListener(_onAddressEditing);
    confirmButtonProvider.addListener(_confirmButtonChange);
    _autoCompleteFocus.requestFocus();
  }

  @override
  void dispose() {
    confirmButtonProvider.removeListener(_confirmButtonChange);
    _addressEditingController.removeListener(_onAddressEditing);
    super.dispose();
  }

  void setValue(String address, List<sys.GeoLocation> locations) {
    _options = locations.map((sys.GeoLocation location) => location.address).toList();
    _isOptionsSuggestion = false;
    if (address.isNotEmpty && _addressEditingController.text == address) {
      address = ''; // use empty address so dropdown menu will show
    }
    _lastInputAddress = address;
    _addressEditingController.text = address;
    _autoCompleteEditingController.text = address;
    _autoCompleteFocus.requestFocus();
    onUserTyping(address);
    notifyListeners();
  }

  /// onUserTyping trigger when user typing
  final void Function(String text) onUserTyping;

  /// onUserSelected trigger when user clicked dropdown menu to select suggestion or location
  final Future<void> Function(String, bool) onUserSelected;

  /// onQuerySuggestions return list of suggestion
  final Future<List<String>> Function(String) onQuerySuggestions;

  /// onClickConfirm trigger when user click confirm
  final void Function() onClickConfirm;

  /// confirmButtonProvider control show confirm button
  final ConfirmButtonProvider confirmButtonProvider;

  /// _autoCompleteFocus control auto complete focus
  final FocusNode _autoCompleteFocus = FocusNode();

  /// _autoCompleteFocus control confirm button focus
  final FocusNode _confirmFocus = FocusNode();

  /// keep suggestion or location text
  List<String> _options = [];

  /// _isOptionsSuggestion is true when _options contain suggestion
  bool _isOptionsSuggestion = true;

  String _lastInputAddress = '';

  final _delayedRun = general.DelayedRun();

  /// _textEditingController text edit field controller
  final TextEditingController _addressEditingController = TextEditingController();

  /// _autoCompleteEditingController is a dummy, it control by _addressEditingController
  /// cause autocomplete field don't support future, so we let user edit at _addressEditingController and get options before we change text in _autoCompleteEditingController
  final TextEditingController _autoCompleteEditingController = TextEditingController();

  /// _confirmButtonChange trigger when confirm button need show or hide
  _confirmButtonChange() {
    if (confirmButtonProvider.visible) {
      _confirmFocus.requestFocus();
    }
    notifyListeners();
  }

  /// _setInputText set input text when initState or click my location
  void _setInputText(String text) {
    _lastInputAddress = text;
    _addressEditingController.text = text;
    _addressEditingController.selection =
        TextSelection.fromPosition(TextPosition(offset: _addressEditingController.text.length));
  }

  /// _onDropdownSelected trigger when user click suggestion
  _onDropdownSelected(String selection) {
    _resetSuggestionText();
    _setInputText(selection);
    onUserSelected(selection, _isOptionsSuggestion);
    notifyListeners();
  }

  /// _onTextEditing trigger when type input text
  _onAddressEditing() {
    final inputAddress = _addressEditingController.text.trim();
    if (inputAddress == _lastInputAddress) {
      return; // already handle
    }
    _lastInputAddress = inputAddress;

    if (inputAddress == '') {
      _resetSuggestionText();
      onUserTyping('');
      _autoCompleteEditingController.text = inputAddress;
      notifyListeners();
      return;
    }

    _delayedRun.run(() async {
      _options = await onQuerySuggestions(inputAddress);
      _isOptionsSuggestion = true;
      onUserTyping(inputAddress);
      _autoCompleteEditingController.text = inputAddress;
      notifyListeners();
    });
  }

  /// _resetSuggestionText suggestion action and text
  _resetSuggestionText() {
    _delayedRun.cancel();
    _options = [];
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Consumer2<SearchBarProvider, ConfirmButtonProvider>(
        builder: (context, searchBarProvider, confirmButtonProvider, child) => LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) => Container(
                color: theme.appBarTheme.backgroundColor,
                height: kToolbarHeight,
                child: Stack(
                  children: [
                    // background
                    Container(
                        margin: EdgeInsets.only(
                            right: confirmButtonProvider.visible ? _confirmButtonWidth : 0), // for confirm button
                        padding: const EdgeInsets.fromLTRB(40, 0, 8, 0),
                        alignment: Alignment.center,
                        height: kToolbarHeight - 3,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey[850] : Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const SizedBox(
                            width: double.infinity,
                            height: 38,
                          ),
                        )),
                    // input
                    RawAutocomplete<String>(
                      focusNode: searchBarProvider._autoCompleteFocus,
                      textEditingController: searchBarProvider._autoCompleteEditingController,
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        return searchBarProvider._options;
                      },
                      onSelected: searchBarProvider._onDropdownSelected,
                      fieldViewBuilder: (BuildContext context, TextEditingController controller, FocusNode focusNode,
                          VoidCallback onFieldSubmitted) {
                        return TextField(
                          keyboardType: TextInputType.streetAddress,
                          textInputAction: TextInputAction.search,
                          maxLines: 1,
                          style: const TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                                left: 82,
                                bottom: 10,
                                top: 16,
                                right: 22 + (confirmButtonProvider.visible ? _confirmButtonWidth : 0)),
                            hintText: context.i18n.placeEnterAddress,
                          ),
                          controller: searchBarProvider._addressEditingController,
                          focusNode: focusNode,
                          onSubmitted: (_) => onFieldSubmitted(),
                        );
                      },
                      optionsViewBuilder:
                          (BuildContext context, AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
                        return Stack(
                          // put list view inside stack, so we can use Positioned to set width
                          children: [
                            Positioned(
                                top: 7,
                                left: 0,
                                width: constraints.maxWidth,
                                height: 52 * options.length.toDouble(),
                                child: ListView.builder(
                                  padding: const EdgeInsets.all(0),
                                  itemCount: options.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    final String option = options.elementAt(index);
                                    return InkWell(
                                      onTap: () => onSelected(option),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border(
                                            top: BorderSide(
                                              width: 1,
                                              color: Colors.grey.shade200,
                                            ),
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                        child: Text(
                                          option,
                                          maxLines: 1,
                                          style: TextStyle(fontSize: 18, color: Colors.grey[900]),
                                        ),
                                      ),
                                    );
                                  },
                                ))
                          ],
                        );
                      },
                    ),
                    // back
                    Container(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        padding: const EdgeInsets.all(0),
                        icon: const Icon(Icons.arrow_back_ios_new),
                        onPressed: Navigator.of(context).pop,
                      ),
                    ),
                    // search
                    Positioned(
                      left: 54,
                      top: 16,
                      child: Icon(
                        Icons.search,
                        size: 28,
                        color: isDark ? Colors.white60 : Colors.black26,
                      ),
                    ),
                    //confirm
                    confirmButtonProvider.visible
                        ? Positioned(
                            right: 10,
                            top: 0,
                            child: Container(
                              height: 55,
                              alignment: Alignment.center,
                              child: confirmButton(context, 65, 34, 12, context.i18n.placeConfirmAddress,
                                  searchBarProvider._confirmFocus, searchBarProvider.onClickConfirm),
                            ),
                          )
                        : const SizedBox(),

                    /*
            Positioned(
              right: 30,
              top: 7,
              child: GestureDetector(
                onTap: () {
                  reset();
                  _textEditingController.clear();
                },
                child: Icon(
                  Icons.clear_rounded,
                  color: isDark ? Colors.white60 : Colors.black26,
                  //color: Styles.searchIconColor,
                ),
              ),
            ),
          */
                  ],
                ))));
  }
}
