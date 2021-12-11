import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'extensions.dart';

class SearchBox<T> extends StatelessWidget {
  const SearchBox({
    Key? key,
    required this.controller,
    required this.suggestionsCallback,
    this.itemBuilder,
    this.itemToString,
    this.decoration,
    this.hintText,
    this.keyboardType,
    this.focusNode,
  }) : super(key: key);

  /// controller is text editing controller for search bar
  final TextEditingController controller;

  /// keyboardType control keyboard input type
  final TextInputType? keyboardType;

  /// onSuggestionChanged trigger when select a suggestion
  final Future<Iterable<T>> Function(String) suggestionsCallback;

  /// itemBuilder is a function to build suggestion item
  final Widget Function(BuildContext, T)? itemBuilder;

  /// onSuggestionSelected trigger when select a suggestion
  final String Function(T)? itemToString;

  /// focusNode is control's focus node
  final FocusNode? focusNode;

  /// decoration is control's decoration
  final InputDecoration? decoration;

  /// hintText is control's hintText
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    String _suggestionToString(suggestion) => itemToString != null ? itemToString!(suggestion) : suggestion.toString();

    return TypeAheadField<T>(
      textFieldConfiguration: TextFieldConfiguration(
        controller: controller,
        focusNode: focusNode,
        style: DefaultTextStyle.of(context).style.copyWith(fontStyle: FontStyle.italic),
        decoration: decoration ??
            InputDecoration(
              isDense: true,
              prefixIcon: Icon(
                Icons.search,
                color: context.themeColor(light: Colors.grey.shade900, dark: Colors.grey.shade200),
              ),
              prefixIconConstraints: const BoxConstraints(minWidth: 46),
              suffixIcon: Visibility(
                visible: controller.text.isNotEmpty,
                child: InkWell(
                  borderRadius: BorderRadius.circular(25.0),
                  onTap: () => controller.text = '',
                  child: Icon(
                    Icons.close,
                    size: 24,
                    color: context.themeColor(light: Colors.grey.shade900, dark: Colors.grey.shade200),
                  ),
                ),
              ),
              suffixIconConstraints: const BoxConstraints(minWidth: 46),
              border: OutlineInputBorder(
                gapPadding: 0,
                borderRadius: BorderRadius.circular(25.0),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusColor: Colors.grey,
              focusedBorder: OutlineInputBorder(
                gapPadding: 0,
                borderRadius: BorderRadius.circular(25.0),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              contentPadding: const EdgeInsets.only(left: 0, bottom: 10, top: 12, right: 0),
              hintText: hintText,
            ),
      ),
      loadingBuilder: (_) => const SizedBox(),
      suggestionsBoxDecoration: SuggestionsBoxDecoration(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(15.0),
        color: context.themeColor(light: Colors.grey.shade100, dark: Colors.grey.shade800),
      ),
      suggestionsCallback: suggestionsCallback,
      transitionBuilder: (context, suggestionsBox, controller) => suggestionsBox,
      noItemsFoundBuilder: (_) => const SizedBox(),
      itemBuilder: itemBuilder ??
          (context, suggestion) {
            return ListTile(
              contentPadding: const EdgeInsets.only(left: 46),
              title: Text(_suggestionToString(suggestion)),
              shape: Border(
                top: BorderSide(
                  width: 1,
                  color: context.themeColor(
                    dark: Colors.grey.shade800,
                    light: Colors.grey.shade300,
                  ),
                ),
              ),
            );
          },
      onSuggestionSelected: (suggestion) {
        controller.text = _suggestionToString(suggestion);
      },
    );
  }
}
