import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'list_item.dart';

class CheckList<T> extends StatelessWidget {
  const CheckList({
    required this.items,
    required this.controller,
    this.onItemTap,
    this.itemBuilder,
    this.dense = false,
    this.padding,
    this.physics,
    Key? key,
  }) : super(key: key);

  /// controller keep selected item keys
  final ValueNotifier<List<T>> controller;

  /// dense
  final bool dense;

  /// items keep all list item
  final List<ListItem<T>> items;

  /// onItemTap called when user select a item
  final void Function(T)? onItemTap;

  /// textBuilder only build text inside tile
  final ListItemBuilder<T, ListItem>? itemBuilder;

  /// padding default is 5
  final EdgeInsetsGeometry? padding;

  /// physics is list view physics
  final ScrollPhysics? physics;

  Widget _buildItem(BuildContext context, ListItem<T> item, bool selected) {
    if (itemBuilder != null) {
      Widget? widget = itemBuilder!(context, item.key, item, selected);
      if (widget != null) {
        return widget;
      }
    }

    return Row(
      children: [
        if (item.icon != null) Padding(padding: const EdgeInsets.only(right: 14), child: Icon(item.icon)),
        Text(item.title ?? key.toString())
      ],
    );
  }

  /// isSelected return true if item is selected
  bool isSelected(T key) => controller.value.contains(key);

  /// setSelected set item selected
  void setSelected(T key, bool? value) {
    var list = <T>[...controller.value];
    if (value == true) {
      if (!list.contains(key)) {
        list.add(key);
      }
    } else {
      if (list.contains(key)) {
        list.remove(key);
      }
    }
    controller.value = list;
  }

  Widget _buildTile(
    BuildContext context,
    ListItem<T> item,
  ) {
    final key = item.key;
    bool isItemSelected = isSelected(key);

    return ListTile(
      dense: dense,
      selected: isItemSelected,
      contentPadding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
      leading: Checkbox(
        value: isItemSelected,
        onChanged: (bool? value) => setSelected(key, value),
      ),
      onTap: () {
        if (onItemTap != null) {
          onItemTap!(key);
        }
      },
      trailing: onItemTap != null
          ? const Padding(
              padding: EdgeInsets.only(right: 20),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 24,
              ))
          : null,
      title: _buildItem(
        context,
        item,
        isItemSelected,
      ),
      subtitle: item.subtitle != null ? Text(item.subtitle!) : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: controller,
        child: Consumer<ValueNotifier<List<T>>>(builder: (context, _, __) {
          return ListView.separated(
            physics: physics,
            itemCount: items.length,
            shrinkWrap: true,
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 5),
            separatorBuilder: (BuildContext context, int i) => const Divider(height: 1),
            itemBuilder: (BuildContext context, int i) {
              final item = items[i];
              return _buildTile(context, item);
            },
          );
        }));
  }
}
