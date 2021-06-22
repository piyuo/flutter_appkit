import 'dart:async';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:libcli/util.dart' as util;
import 'package:libcli/commands/sys/sys.dart' as sys;
import 'package:libcli/types.dart' as types;
import 'package:libcli/i18n.dart' as i18n;
import 'search-confirm.dart';

const double _confirmButtonWidth = 90;

class SearchBarValue {
  SearchBarValue({
    required this.address,
    this.locations = const [],
  });

  final String address;

  final List<sys.GeoLocation> locations;

  static SearchBarValue empty = SearchBarValue(
    address: "",
  );

  bool get isEmpty => address.isEmpty;
}

class SearchBarValueController extends ValueNotifier<SearchBarValue> {
  SearchBarValueController({SearchBarValue? value}) : super(value ?? SearchBarValue.empty);
}

class SearchBar extends StatefulWidget {
  /// onUserTyping trigger when user typing
  final void Function(String text) onUserTyping;

  /// onUserSelected trigger when user clicked dropdown menu to select suggestion or location
  final Future<void> Function(BuildContext context, String, bool) onUserSelected;

  /// onQuerySuggestions return list of suggestion
  final Future<List<String>> Function(BuildContext context, String) onQuerySuggestions;

  /// controller to control search bar value
  final SearchBarValueController controller;

  /// confirmButtonController control show confirm button
  final types.BoolController confirmButtonController;

  /// onClickConfirm trigger when user click confirm
  final void Function() onClickConfirm;

  SearchBar({
    Key? key,
    required this.controller,
    required this.onUserTyping,
    required this.onQuerySuggestions,
    required this.onUserSelected,
    required this.confirmButtonController,
    required this.onClickConfirm,
  }) : super(key: key);

  @override
  State<SearchBar> createState() => SearchBarState();
}

class SearchBarState extends State<SearchBar> {
  /// _autoCompleteFocus control auto complete focus
  final FocusNode _autoCompleteFocus = FocusNode();

  /// _autoCompleteFocus control confirm button focus
  final FocusNode _confirmFocus = FocusNode();

  /// keep suggestion or location text
  List<String> _options = [];

  /// _isOptionsSuggestion is true when _options contain suggestion
  bool _isOptionsSuggestion = true;

  String _lastTextEditing = '';

  final _delayedRun = util.DelayedRun();

  /// _textEditingController text edit field controller
  final TextEditingController _textEditingController = TextEditingController();

  /// _redrawController control RawAutoComplete redraw
  final TextEditingController _redrawController = TextEditingController();

  /// _showConfirmButton is true will show confirm button
  bool _showConfirmButton = false;

  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(_onTextEditing);
    _setInputText(widget.controller.value.address);
    _redrawController.text = _textEditingController.text;
    widget.confirmButtonController.addListener(_confirmButtonChange);

    _autoCompleteFocus.requestFocus();
    widget.controller.addListener(_onValueChange);
  }

  @override
  void dispose() {
    widget.confirmButtonController.removeListener(_confirmButtonChange);
    _textEditingController.removeListener(_onTextEditing);
    widget.controller.removeListener(_onValueChange);
    super.dispose();
  }

  /// _confirmButtonChange trigger when confirm button need show or hide
  _confirmButtonChange() {
    setState(() {
      _showConfirmButton = widget.confirmButtonController.value;
      _confirmFocus.requestFocus();
    });
  }

  /// _onValueChange trigger when user press my location
  _onValueChange() {
    final value = widget.controller.value;
    _options = value.locations.map((sys.GeoLocation location) => location.address).toList();
    _isOptionsSuggestion = false;
    setState(() {
      _lastTextEditing = value.address;
      _textEditingController.text = value.address;
      _redrawController.text = value.address;
    });
  }

  /// _setInputText set input text when initState or click my location
  void _setInputText(String text) {
    _lastTextEditing = text;
    _textEditingController.text = text;
    _textEditingController.selection =
        TextSelection.fromPosition(TextPosition(offset: _textEditingController.text.length));
  }

  /// _onDropdownSelected trigger when user click suggestion
  _onDropdownSelected(String selection) {
    _resetSuggestionText();
    setState(() {
      _setInputText(selection);
    });
    widget.onUserSelected(context, selection, _isOptionsSuggestion);
  }

  /// _onTextEditing trigger when type input text
  _onTextEditing() {
    final inputText = _textEditingController.text.trim();
    if (inputText == _lastTextEditing) {
      return; // already handle
    }
    _lastTextEditing = inputText;

    if (inputText == '') {
      _resetSuggestionText();
      setState(() {
        widget.onUserTyping('');
        _redrawController.text = _textEditingController.text;
      });
      return;
    }

    _delayedRun.run(() async {
      _options = await widget.onQuerySuggestions(context, inputText);
      _isOptionsSuggestion = true;
      setState(() {
        widget.onUserTyping(inputText);
        _redrawController.text = inputText;
      });
    });
  }

  /// _resetSuggestionText suggestion action and text
  _resetSuggestionText() {
    _delayedRun.cancel();
    _options = [];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Consumer<i18n.I18nProvider>(
        builder: (context, i18nProvider, child) => Container(
            color: theme.appBarTheme.backgroundColor,
            height: 55,
            child: Stack(
              children: [
                // background
                Container(
                    margin: EdgeInsets.only(right: _showConfirmButton ? _confirmButtonWidth : 0), // for confirm button
                    padding: EdgeInsets.fromLTRB(40, 0, 8, 0),
                    alignment: Alignment.center,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[850] : Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: 38,
                      ),
                    )),
                // input
                RawAutocomplete<String>(
                  focusNode: _autoCompleteFocus,
                  textEditingController: _redrawController,
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    return _options;
                  },
                  onSelected: _onDropdownSelected,
                  fieldViewBuilder: (BuildContext context, TextEditingController textEditingController,
                      FocusNode focusNode, VoidCallback onFieldSubmitted) {
                    return TextFormField(
                      maxLines: 1,
                      style: TextStyle(fontSize: 18),
                      decoration: new InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                            left: 82, bottom: 10, top: 16, right: 22 + (_showConfirmButton ? _confirmButtonWidth : 0)),
                        hintText: i18nProvider.translate('enterAddr'),
                      ),
                      controller: _textEditingController,
                      focusNode: focusNode,
                      onFieldSubmitted: (String value) {
                        onFieldSubmitted();
                      },
                    );
                  },
                  optionsViewBuilder:
                      (BuildContext context, AutocompleteOnSelected<String> onSelected, Iterable<String> noNeed) {
                    return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      itemCount: _options.length,
                      itemBuilder: (BuildContext context, int index) {
                        final String option = _options.elementAt(index);
                        return InkWell(
                          onTap: () => onSelected(option),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isDark ? Colors.grey[850] : Colors.white,
                              border: Border(
                                top: BorderSide(
                                  width: 1,
                                  color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
                                ),
                              ),
                            ),
                            padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                            child: Text(
                              option,
                              maxLines: 1,
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                // back
                Container(
                  alignment: Alignment.centerLeft,
                  child: BackButton(),
                ),
                // search
                Positioned(
                  left: 54,
                  top: 16,
                  child: Icon(
                    Icons.search,
                    color: isDark ? Colors.white60 : Colors.black26,
                  ),
                ),
                //confirm
                _showConfirmButton
                    ? Positioned(
                        right: 10,
                        top: 0,
                        child: Container(
                          height: 55,
                          alignment: Alignment.center,
                          child: confirmButton(context, 80, 34, 12, i18nProvider.translate('confirm'), _confirmFocus,
                              widget.onClickConfirm),
                        ),
                      )
                    : SizedBox(),

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
            )));
  }
}
