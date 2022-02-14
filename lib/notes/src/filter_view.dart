import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'filter.dart';
import 'package:libcli/dialog/dialog.dart' as dialog;

class FilterView<T> extends StatelessWidget {
  /// filterView is a widget that displays a filter
  /// ```dart
  /// FilterView<SampleFilter>(
  ///  onFilterSelected: (value) => debugPrint('$value selected'),
  ///  filters: const [
  ///    Filter<SampleFilter>(
  ///    title: 'Inbox',
  ///      value: SampleFilter.inbox,
  ///      icon: Icons.inbox,
  ///      count: 0,
  ///    ),
  ///  ],
  /// )
  /// ```
  const FilterView({
    required this.filters,
    this.iconColor = Colors.amber,
    this.onFilterSelected,
    Key? key,
  }) : super(key: key);

  /// filters is a list of filters to display.
  final List<Filter<T>> filters;

  /// The color of the icon.
  final Color? iconColor;

  /// onFilterSelected trigger when a filter is selected
  final void Function(T)? onFilterSelected;

  @override
  Widget build(BuildContext context) {
    var children = <dynamic>[];

    final categories = findCategories(filters);
    for (String category in categories) {
      if (category.isNotEmpty) {
        children.add(category);
      }
      children.addAll(filters.where((Filter filter) => filter.category == category));
    }

    return Container(
        color: context.themeColor(light: Colors.grey.shade300, dark: Colors.grey.shade800),
        child: ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: children.length,
          itemBuilder: (BuildContext context, int index) {
            final item = children[index];
            if (item is String) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(15, 20, 0, 10),
                child: Text(
                  item,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              );
            }

            return TextButton(
              onPressed: onFilterSelected != null && !item.selected ? () => onFilterSelected!(item.value) : null,
              style: TextButton.styleFrom(
                primary: Colors.grey,
                backgroundColor: item.selected
                    ? context.themeColor(
                        light: Colors.grey.shade400,
                        dark: Colors.grey.shade700,
                      )
                    : null,
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              ),
              child: Row(
                children: [
                  Icon(item.icon, color: iconColor, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(item.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: item.selected ? Colors.white : null,
                        )),
                  ),
                  if (item.count != null && item.count! > 0)
                    Text(
                      '${item.count}',
                      style: TextStyle(color: item.selected ? Colors.white : Colors.grey),
                    ),
                ],
              ),
            );
          },
        ));
  }
}

/// showFilterView show filter view in side menu
///
/// ```dart
/// showFilterView<SampleFilter>(
///     context,
///     onFilterSelected: (value) => debugPrint('$value selected'),
///     filters: const [
///       Filter<SampleFilter>(
///         title: 'Inbox',
///         value: SampleFilter.inbox,
///         icon: Icons.inbox,
///         count: 0,
///       ),
///     ],
///   )
/// ```
Future<T?> showFilterView<T>(
  BuildContext context, {
  required List<Filter<T>> filters,
  final void Function(T)? onFilterSelected,
}) async {
  return await dialog.showSide<T>(
    context,
    child: FilterView<T>(
      onFilterSelected: onFilterSelected != null
          ? (value) {
              onFilterSelected(value);
              Navigator.of(context).pop();
            }
          : null,
      filters: filters,
    ),
  );
}
