import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'extensions.dart';
import 'package:libcli/responsive/responsive.dart' as responsive;

/// SearchBox is a widget that displays a search box with a selection.
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
class SearchBox extends StatelessWidget {
  /// SearchBox is a widget that displays a search box with a selection.
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
    Key? key,
    required this.controller,
    this.onSuggestion,
    this.hintText,
    this.keyboardType,
    this.focusNode,
    this.prefixIcon,
  }) : super(key: key);

  /// controller is text editing controller for search bar
  final TextEditingController controller;

  /// keyboardType control keyboard input type
  final TextInputType? keyboardType;

  /// onNeedSuggestion trigger when select a suggestion
  final Future<Iterable<SearchSuggestion>> Function(String)? onSuggestion;

  /// focusNode is control's focus node
  final FocusNode? focusNode;

  /// hintText is control's hintText
  final String? hintText;

  /// prefixIcon is control's prefix widget
  final Widget? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: controller,
        child: Consumer<TextEditingController>(
            builder: (context, provide, child) => TypeAheadField<SearchSuggestion>(
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: controller,
                    focusNode: focusNode,
                    maxLength: 60,
                    onEditingComplete: () {
                      debugPrint('onEditingComplete');
                    },
                    style: DefaultTextStyle.of(context).style.copyWith(
                          fontSize: 14,
                          overflow: TextOverflow.ellipsis,
                        ),
                    decoration: InputDecoration(
                      isDense: !responsive.isPhoneDesign,
                      counterText: '',
                      prefixIcon: prefixIcon,
                      prefixIconConstraints: const BoxConstraints(minWidth: 54),
                      suffixIcon: controller.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.close,
                                color: context.themeColor(light: Colors.grey.shade700, dark: Colors.grey.shade300),
                              ),
                              onPressed: () => controller.text = '',
                            )
                          : Icon(
                              Icons.search,
                              color: context.themeColor(light: Colors.grey.shade700, dark: Colors.grey.shade300),
                            ),
                      border: OutlineInputBorder(
                        gapPadding: 0,
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      hintText: hintText,
                    ),
                  ),
                  loadingBuilder: (_) => const SizedBox(),
                  transitionBuilder: (context, suggestionsBox, controller) => suggestionsBox,
                  noItemsFoundBuilder: (_) => const SizedBox(),
                  suggestionsCallback: (value) async {
                    if (onSuggestion == null) {
                      return const [];
                    }
                    return await onSuggestion!(value);
                  },
                  suggestionsBoxDecoration: SuggestionsBoxDecoration(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: context.themeColor(light: Colors.grey.shade400, dark: Colors.grey.shade600),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: context.themeColor(light: Colors.grey.shade100, dark: Colors.grey[850]!),
                    clipBehavior: Clip.antiAlias,
                  ),
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      horizontalTitleGap: 0,
                      dense: !responsive.isPhoneDesign,
                      title: Text(suggestion.label, style: const TextStyle(fontSize: 14)),
                      leading: Icon(suggestion.icon),
                    );
                  },
                  onSuggestionSelected: (suggestion) => controller.text = suggestion.value ?? suggestion.label,
                )));
  }
}

class SearchSuggestion {
  /// SearchSuggestion is search box suggestion
  /// ```dart
  ///  SearchSuggestion(
  ///      'Inbox',
  ///      value:'inbox',
  ///      icon: Icons.inbox,
  ///    ),
  /// ```
  SearchSuggestion(
    this.label, {
    this.value,
    this.icon,
  });

  /// value of selection
  final String? value;

  /// label to display in the dropdown
  final String label;

  /// icon is the icon of the filter
  final IconData? icon;
}
