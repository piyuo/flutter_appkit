import 'package:flutter/material.dart';
import 'package:libcli/dialog/dialog.dart' as dialog;
import 'package:universal_platform/universal_platform.dart';
import 'tag.dart';

class TagView<T> extends StatelessWidget {
  /// TagView is a widget that displays a tag
  /// ```dart
  /// TagView<SampleTag>(
  ///  onTagSelected: (value) => debugPrint('$value selected'),
  ///  tags: const [
  ///    Tag<SampleTag>(
  ///    title: 'Inbox',
  ///      value: SampleTag.inbox,
  ///      icon: Icons.inbox,
  ///      count: 0,
  ///    ),
  ///  ],
  /// )
  /// ```
  const TagView({
    required this.tags,
    this.onTagSelected,
    this.header,
    Key? key,
  }) : super(key: key);

  /// tags is a list of tags to display.
  final List<Tag<T>> tags;

  /// onTagSelected trigger when a tag is selected
  final void Function(T)? onTagSelected;

  /// header on top of the tag view
  final Widget? header;

  @override
  Widget build(BuildContext context) {
    var children = <dynamic>[];

    final categories = findCategories(tags);
    for (String category in categories) {
      if (category.isNotEmpty) {
        children.add(category);
      }
      children.addAll(tags.where((Tag tag) => tag.category == category));
    }
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
        color: colorScheme.surfaceVariant,
        child: SafeArea(
            child: Column(children: [
          if (header != null) header!,
          Expanded(
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
                    style: TextStyle(color: colorScheme.onSurfaceVariant),
                  ),
                );
              }

              return TextButton(
                onPressed: onTagSelected != null && !item.selected ? () => onTagSelected!(item.value) : null,
                style: TextButton.styleFrom(
                  foregroundColor: colorScheme.onSurfaceVariant,
                  backgroundColor: item.selected ? colorScheme.secondary : null,
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                ),
                child: Row(
                  children: [
                    Icon(
                      item.icon,
                      color: item.selected ? colorScheme.onSecondary : colorScheme.inverseSurface,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(item.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: item.selected ? colorScheme.onSecondary : null,
                          )),
                    ),
                    if (item.count != null && item.count! > 0)
                      Text(
                        '${item.count}',
                        style: TextStyle(color: item.selected ? colorScheme.onSecondary : null),
                      ),
                  ],
                ),
              );
            },
          )),
        ])));
  }
}

/// showTagView show tag view in side menu
/// ```dart
/// showTagView<SampleTag>(
///     context,
///     onTagSelected: (value) => debugPrint('$value selected'),
///     tags: const [
///       Tag<SampleTag>(
///         title: 'Inbox',
///         value: SampleTag.inbox,
///         icon: Icons.inbox,
///         count: 0,
///       ),
///     ],
///   )
/// ```
Future<T?> showTagView<T>(
  BuildContext context, {
  required List<Tag<T>> tags,
  void Function(T)? onTagSelected,
  Widget? header,
}) async {
  return await dialog.showSide<T>(
    context,
    child: TagView<T>(
      header: header,
      onTagSelected: onTagSelected != null
          ? (value) {
              onTagSelected(value);
              Navigator.of(context).pop();
            }
          : null,
      tags: tags,
    ),
  );
}
