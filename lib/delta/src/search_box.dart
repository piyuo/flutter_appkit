import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:libcli/preferences/preferences.dart' as preferences;
import 'package:provider/provider.dart';
import 'delta.dart';

/// SearchBox is a widget that displays a search box with a selection.
class SearchBox extends StatelessWidget {
  /// ```dart
  /// SearchBox(
  ///   controller: _searchBoxController,
  ///   hintText: 'Search orders/products here',
  ///   onSuggestion: (pattern) async {
  ///     await Future.delayed(const Duration(seconds: 5));
  ///     return [SearchSuggestion('hello', icon: Icons.add), SearchSuggestion('world')];
  ///   },
  /// )),
  ///  ```
  const SearchBox({
    required this.controller,
    required this.focusNode,
    this.onSuggestion,
    this.hintText,
    this.keyboardType,
    this.prefixIcon,
    this.enabled = true,
    this.contentPadding = const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
    this.recentKey,
    this.onSubmitted,
    super.key,
  });

  /// controller is text editing controller for search bar
  final TextEditingController controller;

  /// keyboardType control keyboard input type
  final TextInputType? keyboardType;

  /// recentKey is key to store recent search
  final String? recentKey;

  /// onNeedSuggestion trigger when select a suggestion
  final Future<Iterable<SearchSuggestion>> Function(String)? onSuggestion;

  /// focusNode is control's focus node, we required this to unfocus the control so suggestion box can be closed
  final FocusNode focusNode;

  /// hintText is control's hintText
  final String? hintText;

  /// prefixIcon is control's prefix widget
  final Widget? prefixIcon;

  /// enabled is text filed's enabled
  final bool enabled;

  /// contentPadding is control's content padding
  final EdgeInsetsGeometry? contentPadding;

  /// onSubmitted called when user submit the search text
  final void Function(String)? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: controller, // consumer for redrawing when text changed need show clear button
        child: Consumer<TextEditingController>(
            builder: (context, _, __) => TypeAheadField<SearchSuggestion>(
                textFieldConfiguration: TextFieldConfiguration(
                  enabled: enabled,
                  controller: controller,
                  onSubmitted: (text) {
                    focusNode.unfocus();
                    if (recentKey != null) {
                      preferences.addRecent(recentKey!, text);
                    }
                    onSubmitted?.call(text.trim());
                  },
                  focusNode: focusNode,
                  textInputAction: TextInputAction.search,
                  maxLength: 60,
                  style: DefaultTextStyle.of(context).style.copyWith(
                        overflow: TextOverflow.ellipsis,
                      ),
                  decoration: InputDecoration(
                    contentPadding: contentPadding,
                    isDense: true,
                    counterText: '',
                    prefixIcon: prefixIcon,
                    prefixIconConstraints: const BoxConstraints(minWidth: 42, maxHeight: 31),
                    suffixIconConstraints: const BoxConstraints(minWidth: 42, maxHeight: 31),
                    suffixIcon: controller.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              onSubmitted?.call('');
                              controller.text = '';
                            },
                          )
                        : const Icon(Icons.search),
                    border: OutlineInputBorder(
                      gapPadding: 0,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: hintText,
                  ),
                ),
                loadingBuilder: (_) => const SizedBox(),
                //transitionBuilder: (context, suggestionsBox, controller) => suggestionsBox,
                noItemsFoundBuilder: (_) => const SizedBox(),
                suggestionsCallback: (value) async {
                  if (recentKey != null) {
                    final recent = await preferences.getRecent(recentKey!, input: controller.text);
                    return recent.map((text) => SearchSuggestion(text, icon: Icons.history));
                  }
                  if (onSuggestion == null) {
                    return const [];
                  }
                  return await onSuggestion!(value);
                },
                suggestionsBoxDecoration: SuggestionsBoxDecoration(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(.95),
                  clipBehavior: Clip.antiAlias,
                ),
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    dense: !phoneScreen,
                    title: Text(suggestion.text,
                        style: TextStyle(color: Theme.of(context).colorScheme.onSecondaryContainer)),
                    leading: Icon(suggestion.icon, color: Theme.of(context).colorScheme.onSecondaryContainer),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  onSubmitted?.call(suggestion.text.trim());
                  controller.text = suggestion.text;
                })));
  }
}

/// SearchSuggestion is search box suggestion
class SearchSuggestion {
  /// ```dart
  ///  SearchSuggestion(
  ///      'Inbox',
  ///      icon: Icons.inbox,
  ///    ),
  /// ```
  SearchSuggestion(
    this.text, {
    this.icon,
  });

  /// text to display in the dropdown
  final String text;

  /// icon is the icon of the filter
  final IconData? icon;
}
