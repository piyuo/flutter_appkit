import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'tag.dart';
import 'package:libcli/dialog/dialog.dart' as dialog;

Color tagViewBackgroundColor(BuildContext context) =>
    context.themeColor(light: Colors.grey.shade300, dark: Colors.grey.shade900);

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
    this.iconColor = Colors.blueAccent,
    this.onTagSelected,
    this.header,
    Key? key,
  }) : super(key: key);

  /// tags is a list of tags to display.
  final List<Tag<T>> tags;

  /// The color of the icon.
  final Color? iconColor;

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

    return Container(
        color: tagViewBackgroundColor(context),
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
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                );
              }

              return TextButton(
                onPressed: onTagSelected != null && !item.selected ? () => onTagSelected!(item.value) : null,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey,
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
          )),
        ]));
  }
}

/// showTagView show tag view in side menu
///
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
