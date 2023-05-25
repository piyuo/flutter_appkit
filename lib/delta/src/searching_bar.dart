import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/general/general.dart' as general;

typedef SuggestionBuilder = Future<List<String>> Function(String text);

class SearchingBar extends StatelessWidget {
  const SearchingBar({
    Key? key,
    required this.controller,
    this.suggestionBuilder,
    this.onSuggestionChanged,
    this.onTextChanged,
    this.hint,
    this.isDense = true,
    this.keyboardType,
    this.focusNode,
  }) : super(key: key);

  /// controller is text editing controller for search bar
  final TextEditingController controller;

  /// hint for search bar
  final String? hint;

  /// isDense control is search bar show in dense layout, default is true
  final bool isDense;

  /// keyboardType control keyboard input type
  final TextInputType? keyboardType;

  /// suggestionBuilder return suggestion list base on input text
  final SuggestionBuilder? suggestionBuilder;

  /// onSuggestionChanged trigger when select a suggestion
  final general.StringCallback? onSuggestionChanged;

  /// onTextChanged trigger when user change search text
  final general.StringCallback? onTextChanged;

  /// focusNode is search bar focus node
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<_SearchBarProvider>(
        create: (context) => _SearchBarProvider(
              controller: controller,
              suggestionBuilder: suggestionBuilder,
              onTextChanged: onTextChanged,
              focusNode: focusNode,
            ),
        child: Consumer<_SearchBarProvider>(builder: (context, provide, child) {
          return LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) => RawAutocomplete<String>(
                    focusNode: provide._focus,
                    textEditingController: controller,
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      return provide.options;
                    },
                    onSelected: (text) {
                      if (onSuggestionChanged != null) {
                        onSuggestionChanged!(text);
                      }
                      provide.cursorReposition();
                    },
                    fieldViewBuilder: (BuildContext context, TextEditingController controller, FocusNode focusNode2,
                        VoidCallback onFieldSubmitted) {
                      return TextField(
                        keyboardType: keyboardType,
                        textInputAction: TextInputAction.search,
                        maxLines: 1,
                        style: const TextStyle(fontSize: 18),
                        decoration: InputDecoration(
                          isDense: isDense,
                          prefixIcon: const Icon(Icons.search),
                          prefixIconConstraints: BoxConstraints(
                            minWidth: isDense ? 46 : 56,
                          ),
                          suffixIcon: Visibility(
                            visible: provide.text.isNotEmpty,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(25.0),
                              onTap: () => provide._innerController.text = '',
                              child: const Icon(Icons.close, size: 24),
                            ),
                          ),
                          suffixIconConstraints: BoxConstraints(
                            minWidth: isDense ? 46 : 56,
                          ),
                          border: OutlineInputBorder(
                            gapPadding: 0,
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(),
                          ),
                          contentPadding: const EdgeInsets.only(left: 0, bottom: 10, top: 12, right: 0),
                          hintText: hint,
                        ),
                        controller: provide._innerController,
                        focusNode: focusNode2,
                      );
                    },
                    optionsViewBuilder:
                        (BuildContext context, AutocompleteOnSelected<String> onSelected, Iterable<String> _) {
                      final options = provide.options;
                      return Stack(
                        // put list view inside stack, so we can use Positioned to set width
                        children: [
                          Positioned(
                            top: 4,
                            left: 0,
                            width: constraints.maxWidth,
                            height: 52 * options.length.toDouble(),
                            child: Material(
                                clipBehavior: Clip.antiAlias,
                                elevation: 5.0,
                                borderRadius: const BorderRadius.all(Radius.circular(15)),
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: options.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    final String option = options.elementAt(index);
                                    return InkWell(
                                      onTap: () => onSelected(option),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                        child: Text(
                                          option,
                                          maxLines: 1,
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                      ),
                                    );
                                  },
                                )),
                          )
                        ],
                      );
                    },
                  ));
        }));
  }
}

class _SearchBarProvider with ChangeNotifier {
  _SearchBarProvider({
    required this.controller,
    required this.suggestionBuilder,
    required this.onTextChanged,
    required FocusNode? focusNode,
  }) {
    _focus = focusNode ?? FocusNode();
    _focus.addListener(_onFocusChange);
    _innerController.value = controller.value;
    controller.addListener(_onControllerValueChange);
    _innerController.addListener(_onEditing);
  }

  @override
  void dispose() {
    _focus.removeListener(_onFocusChange);
    controller.addListener(_onControllerValueChange);
    _innerController.removeListener(_onEditing);
    super.dispose();
  }

  /// suggestionBuilder return list of suggestion
  final SuggestionBuilder? suggestionBuilder;

  /// options for display
  List<String> options = [];

  /// _previousText is previous typed text
  String _previousText = '';

  /// _suggestionDelay delay show suggestion if user continue change input text
  final _suggestionDelay = general.DelayedRun();

  /// _textChangedDelay delay text changed event if user continue change input text
  final _textChangedDelay = general.DelayedRun();

  /// controller is not map to text field, controller's value is sync to inner controller
  /// cause text field don't support future, so we let user edit at inner controller first then sync to controller
  final TextEditingController controller;

  /// _focus is search bar main focus node
  late final FocusNode _focus;

  /// _innerController text edit field controller
  final TextEditingController _innerController = TextEditingController();

  /// onTextChanged happen when user change search text
  final general.StringCallback? onTextChanged;

  /// text return text field text
  String get text => _innerController.text;

  /// _onFocusChange will pop suggestion if text is empty
  void _onFocusChange() {
    if (_focus.hasFocus && text.isEmpty && suggestionBuilder != null) {
      _suggestionDelay.run(() async {
        options = await suggestionBuilder!('');
        if (options.isNotEmpty) {
          _showSuggestion();
        }
      });
    }
  }

  /// popSuggestion will pop suggestion
  void _showSuggestion() {
    String backup = controller.text;
    _previousText = ' ';
    _redrawText(_previousText);
    _previousText = backup;
    _redrawText(_previousText);
  }

  /// _redrawText redraw text
  void _redrawText(String text) {
    controller.text = text;
    notifyListeners();
  }

  /// _fireTextChanged fire text changed event
  void _fireTextChanged() {
    if (onTextChanged != null) {
      _textChangedDelay.run(() async {
        onTextChanged!(text);
      });
    }
  }

  /// _onControllerValueChange trigger when controller value change
  void _onControllerValueChange() {
    if (controller.text == _previousText) {
      return; // avoid already handle
    }

    _previousText = controller.text;
    _innerController.text = _previousText;
    cursorReposition();
    _fireTextChanged();
  }

  /// _onEditing trigger when user type input text
  void _onEditing() {
    final text = _innerController.text;
    if (text == _previousText) {
      return; // avoid already handle
    }
    _previousText = text;
    _fireTextChanged();
/*
    if (text == '') {
      _resetSuggestion();
      _redrawText(text);
      return;
    }
*/
    if (suggestionBuilder == null) {
      _redrawText(text);
      return;
    }

    _suggestionDelay.run(() async {
      options = await suggestionBuilder!(text);
      _redrawText(text);
    });
  }

/*
  /// resetSuggestion reset suggestion action and text
  void _resetSuggestion() {
    _suggestionDelay.cancel();
    options = [];
  }
*/
  /// reset set text to empty
/*
  void reset() {
    _resetSuggestion();
    _previousText = '';
    controller.text = '';
    _innerController.text = '';
    _focus.unfocus();
  }
*/
  /// cursorReposition move cursor to the ene
  void cursorReposition() {
    _innerController.selection = TextSelection.fromPosition(TextPosition(offset: _innerController.text.length));
  }
}
