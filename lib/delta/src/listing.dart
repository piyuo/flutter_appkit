import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'list_item.dart';

enum Shape { round, roundRight }

class Listing<T> extends StatelessWidget {
  const Listing({
    required this.items,
    required this.controller,
    this.onItemTap,
    this.textBuilder,
    this.tileBuilder,
    this.shape,
    this.dense = false,
    this.padding,
    this.physics,
    Key? key,
  }) : super(key: key);

  /// controller is for item selection control, if must be set if you want show selected color
  final ValueNotifier<T?> controller;

  /// dense
  final bool dense;

  /// shape is item shape
  final Shape? shape;

  /// items keep all list item
  final List<dynamic> items;

  /// onItemTap called when user select a item
  final void Function(BuildContext, T)? onItemTap;

  /// textBuilder only build text inside tile
  final ListItemBuilder<T, String>? textBuilder;

  /// tileBuilder build tile to replace default
  final ListItemBuilder<T, dynamic>? tileBuilder;

  /// padding default is 5
  final EdgeInsetsGeometry? padding;

  /// physics is list view physics
  final ScrollPhysics? physics;

  Widget _buildText(BuildContext context, T key, String? text, bool selected) {
    if (textBuilder != null) {
      Widget? widget = textBuilder!(context, key, text ?? key.toString(), selected);
      if (widget != null) {
        return widget;
      }
    }

    return Text(text ?? key.toString(), style: Theme.of(context).textTheme.bodyLarge);
  }

  Widget _buildTile(
    BuildContext context,
    ListItem<T> item, {
    Function()? onTap,
  }) {
    final key = item.key;
    final text = item.title;
    final selected = controller.value == item.key;
    if (tileBuilder != null) {
      Widget? widget = tileBuilder!(context, key, item, selected);
      if (widget != null) {
        return widget;
      }
    }

    return ListTile(
      dense: dense,
      shape: shape != null
          ? RoundedRectangleBorder(
              borderRadius: shape == Shape.round
                  ? const BorderRadius.all(
                      Radius.circular(25),
                    )
                  : const BorderRadius.only(
                      topRight: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ))
          : null,
      selected: selected,
      onTap: onTap,
      minLeadingWidth: 0,
      contentPadding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
      leading: item.icon != null
          ? Icon(
              item.icon,
              size: 24,
              //            color: item.iconColor ?? (selected ? selectedFontColor ?? context.invertedColor : _fontColor(context)),
            )
          : null,
      title: _buildText(
        context,
        key,
        text,
        selected,
      ),
      subtitle: item.subtitle != null ? Text(item.subtitle!) : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: controller,
        child: Consumer<ValueNotifier<T?>>(builder: (context, model, child) {
          return ListView.separated(
            physics: physics,
            itemCount: items.length,
            shrinkWrap: true,
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 5),
            separatorBuilder: (BuildContext context, int i) => const Divider(height: 1),
            itemBuilder: (BuildContext context, int i) {
              final item = items[i];
              if (item is ListItem<T>) {
                return _buildTile(
                  context,
                  item,
                  onTap: () {
                    model.value = item.key;
                    if (onItemTap != null) {
                      onItemTap!(context, item.key);
                    }
                  },
                );
              }
              if (item is Widget) {
                return item;
              }
              assert(false, 'you can only place ListingItem or Widget in items');
              return const SizedBox();
            },
          );
        }));
  }
}
