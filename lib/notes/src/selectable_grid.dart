import 'package:flutter/material.dart';
import 'grid_list.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/responsive/responsive.dart' as responsive;

/// SelectableGrid is a grid view that selectable
/// ```dart
/// SelectableGrid<String>(
///        gap: 50,
///        headerBuilder: () => delta.SearchBox(
///          controller: _searchBoxController,
///        ),
///        items: const ['a', 'b', 'c', 'd', 'e'],
///        selectedItems: const ['b'],
///        builder: (String item, bool isSelected) => Padding(
///          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
///          child: Text(item),
///        ),
///        labelBuilder: (String item, bool isSelected) => const Padding(
///           padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
///     child: Center(child: Text('hello world')),
///   ),
/// ),
/// ```
class SelectableGrid<T> extends GridList<T> {
  /// SelectableGrid is a grid view that selectable
  /// ```dart
  /// SelectableGrid<String>(
  ///        gap: 50,
  ///        headerBuilder: () => delta.SearchBox(
  ///          controller: _searchBoxController,
  ///        ),
  ///        items: const ['a', 'b', 'c', 'd', 'e'],
  ///        selectedItems: const ['b'],
  ///        builder: (String item, bool isSelected) => Padding(
  ///          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
  ///          child: Text(item),
  ///        ),
  ///        labelBuilder: (String item, bool isSelected) => const Padding(
  ///           padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
  ///     child: Center(child: Text('hello world')),
  ///   ),
  /// ),
  /// ```
  const SelectableGrid({
    required List<T> items,
    required List<T> selectedItems,
    required this.builder,
    this.labelBuilder,
    this.checkMode = false,
    this.borderColor,
    this.selectedBorderColor,
    int crossAxisCount = 3,
    final Future<void> Function()? onRefresh,
    final Future<void> Function()? onLoadMore,
    Widget Function()? headerBuilder,
    Widget Function()? footerBuilder,
    void Function(List<T> items)? onItemSelected,
    void Function(List<T> items)? onItemChecked,
    double gap = 80,
    Key? key,
  }) : super(
          items: items,
          selectedItems: selectedItems,
          multiSelect: checkMode,
          crossAxisCount: crossAxisCount,
          onRefresh: onRefresh,
          onLoadMore: onLoadMore,
          headerBuilder: headerBuilder,
          footerBuilder: footerBuilder,
          onItemSelected: onItemSelected,
          onItemChecked: onItemChecked,
          padding: EdgeInsets.zero,
          gap: gap,
          key: key,
        );

  /// builder for build grid item content
  final ItemBuilder<T> builder;

  /// builder for build grid item label
  final ItemBuilder<T>? labelBuilder;

  /// checkMode is true will let user multi select item
  final bool checkMode;

  /// borderColor is item border color
  final Color? borderColor;

  /// borderColor is selected item border color
  final Color? selectedBorderColor;

  /// buildHeader build header
  @override
  Widget buildHeader(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        alignment: Alignment.centerRight,
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) => ConstrainedBox(
                  constraints: responsive.isPhoneDesign ? const BoxConstraints() : const BoxConstraints(maxWidth: 300),
                  child: headerBuilder!(),
                )));
  }

  /// buildFooter build footer
  @override
  Widget buildFooter(BuildContext context) {
    return footerBuilder!();
  }

  /// buildItem build item
  @override
  Widget buildItem(BuildContext context, int itemIndex, T item, bool isSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        checkMode ? buildCheckable(context, item, isSelected) : buildSelectable(context, item, isSelected),
        if (labelBuilder != null) labelBuilder!(item, isSelected),
      ],
    );
  }

  /// buildCheckable build checkable item
  Widget buildCheckable(BuildContext context, T item, bool isSelected) {
    return Stack(
      children: [
        buildSelectable(context, item, isSelected),
        Positioned(
          top: 25,
          left: 35,
          child: Icon(
            isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isSelected
                ? context.themeColor(
                    light: Colors.amber.shade600,
                    dark: Colors.orange.withOpacity(0.5),
                  )
                : context.themeColor(
                    light: Colors.grey.shade300,
                    dark: Colors.grey.shade800,
                  ),
          ),
        ),
      ],
    );
  }

  /// buildCheckable build selectable item
  Widget buildSelectable(BuildContext context, T item, bool isSelected) {
    return Container(
      width: double.infinity,
      margin: isSelected ? const EdgeInsets.fromLTRB(4, 10, 4, 24) : const EdgeInsets.fromLTRB(5, 10, 5, 24),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          width: isSelected ? 2 : 1,
          color: isSelected
              ? selectedBorderColor ??
                  context.themeColor(
                    light: Colors.amber.shade700,
                    dark: Colors.orange.shade200,
                  )
              : borderColor ??
                  context.themeColor(
                    light: Colors.grey.shade300,
                    dark: Colors.grey.shade800,
                  ),
        ),
      ),
      child: builder(item, isSelected),
    );
  }
}
