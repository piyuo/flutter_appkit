import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'extensions.dart';

class ListingItem<T> {
  ListingItem(
    this.key, {
    this.text,
    this.icon,
    this.title,
  });

  /// key is item key
  final T key;

  /// text is item text, use key to display if text not set
  final String? text;

  /// title is item title
  final String? title;

  /// icon is item icon
  final IconData? icon;
}

enum Shape { round, roundRight }

typedef ItemBuilder<T> = Widget? Function(BuildContext context, T key, String title, bool selected);

class Listing<T> extends StatelessWidget {
  const Listing({
    required this.items,
    required this.controller,
    this.onItemTap,
    this.itemBuilder,
    this.tileBuilder,
    this.shape,
    this.selectedTileColor,
    this.selectedFontColor,
    this.fontColor,
    this.dense = false,
    this.padding,
    this.physics,
    Key? key,
  }) : super(key: key);

  /// controller is for item selection control
  final ValueNotifier<T?> controller;

  /// dense
  final bool dense;

  /// shape is item shape
  final Shape? shape;

  /// selectedTileColor is item tile selected color
  final Color? selectedTileColor;

  /// selectedFontColor is item font selected color
  final Color? selectedFontColor;

  /// fontColor is font default color
  final Color? fontColor;

  /// items keep all list item
  final List<dynamic> items;

  /// onItemTap called when user select a item
  final void Function(BuildContext, T)? onItemTap;

  /// itemBuilder build item in tile
  final ItemBuilder<T>? itemBuilder;

  /// tileBuilder build tile to replace default tile
  final ItemBuilder<T>? tileBuilder;

  /// padding default is 5
  final EdgeInsetsGeometry? padding;

  /// physics is list view physics
  final ScrollPhysics? physics;

  Color _fontColor(BuildContext context) {
    return fontColor ??
        context.themeColor(
          light: Colors.grey[800]!,
          dark: Colors.grey[200]!,
        );
  }

  Widget _buildText(BuildContext context, T key, String? text, bool selected) {
    if (itemBuilder != null) {
      Widget? widget = itemBuilder!(context, key, text ?? key.toString(), selected);
      if (widget != null) {
        return widget;
      }
    }

    return Text(text ?? key.toString(),
        style: TextStyle(
          fontSize: 18,
          color: selected ? selectedFontColor ?? context.invertColor : _fontColor(context),
        ));
  }

  Widget _buildWidget(BuildContext context, ListingItem<T> item, Function()? onTap) {
    final key = item.key;
    final text = item.text;
    final selected = controller.value == item.key;
    if (tileBuilder != null) {
      Widget? widget = tileBuilder!(context, key, text ?? key.toString(), selected);
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
      selectedTileColor: selectedTileColor ??
          context.themeColor(
            light: Colors.grey[300]!,
            dark: Colors.grey[700]!,
          ),
      onTap: onTap,
      minLeadingWidth: 0,
      contentPadding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
      leading: item.icon != null
          ? Icon(
              item.icon,
              size: 24,
              color: selected ? selectedFontColor ?? context.invertColor : _fontColor(context),
            )
          : null,
      title: _buildText(
        context,
        key,
        text,
        selected,
      ),
      subtitle: item.title != null ? Text(item.title!) : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ListingProvider>(
        create: (context) => ListingProvider<T>(
              controller: controller,
            ),
        child: Consumer<ListingProvider>(builder: (context, model, child) {
          return ListView.builder(
            physics: physics,
            itemCount: items.length,
            shrinkWrap: true,
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 5),
            itemBuilder: (BuildContext context, int i) {
              final item = items[i];
              if (item is ListingItem<T>) {
                return _buildWidget(
                  context,
                  item,
                  () {
                    model.itemSelected(context, item.key);
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

class ListingProvider<T> with ChangeNotifier {
  ListingProvider({
    required this.controller,
  });

  /// controller is for item selection control
  final ValueNotifier<T?>? controller;

  void itemSelected(context, T key) {
    if (controller != null) {
      controller!.value = key;
      notifyListeners();
    }
  }
}
