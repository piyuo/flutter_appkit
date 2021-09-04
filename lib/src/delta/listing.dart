import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'extensions.dart';

class ListingItem<T> {
  ListingItem(
    this.key, {
    this.title,
    this.icon,
    this.subtitle,
  });

  /// key is item key
  final T key;

  /// title is item title, use key to display if title not set
  final String? title;

  /// subtitle is item subtitle
  final String? subtitle;

  /// icon is item icon
  final IconData? icon;
}

enum Shape { round, roundRight }

typedef Widget? ItemBuilder<T>(BuildContext context, T key, String title, bool selected);

class Listing<T> extends StatelessWidget {
  Listing({
    required this.items,
    required this.onItemTap,
    this.itemBuilder,
    this.tileBuilder,
    this.shape,
    this.controller,
    this.selectedTileColor,
    this.selectedFontColor,
    this.fontColor,
    this.dense = false,
    this.padding,
  });

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
  final List<ListingItem> items;

  /// onItemTap called when user select a item
  final void Function(BuildContext, T) onItemTap;

  /// itemBuilder build item in tile
  final ItemBuilder<T>? itemBuilder;

  /// tileBuilder build tile to replace default tile
  final ItemBuilder<T>? tileBuilder;

  /// controller is for item selection control
  final ValueNotifier<T?>? controller;

  /// padding default is 5
  final EdgeInsetsGeometry? padding;

  Color _fontColor(BuildContext context) {
    return fontColor ??
        context.themeColor(
          light: Colors.grey[700]!,
          dark: Colors.grey[200]!,
        );
  }

  Widget _buildItem(BuildContext context, T key, String? text, bool selected) {
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

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ListingProvider>(
        create: (context) => ListingProvider<T>(
              controller: controller,
            ),
        child: Consumer<ListingProvider>(builder: (context, model, child) {
          return ListView.builder(
            itemCount: items.length,
            shrinkWrap: true,
            padding: padding ?? EdgeInsets.symmetric(horizontal: 5),
            itemBuilder: (BuildContext context, int i) {
              final key = items[i].key;
              final title = items[i].title;
              final selected = controller != null ? controller!.value == items[i].key : false;
              if (tileBuilder != null) {
                Widget? widget = tileBuilder!(context, key, title ?? key.toString(), selected);
                if (widget != null) {
                  return widget;
                }
              }

              return ListTile(
                dense: dense,
                shape: shape != null
                    ? RoundedRectangleBorder(
                        borderRadius: shape == Shape.round
                            ? BorderRadius.all(
                                Radius.circular(25),
                              )
                            : BorderRadius.only(
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
                onTap: () {
                  model.itemSelected(context, key);
                  onItemTap(context, key);
                },
                minLeadingWidth: 0,
                contentPadding: EdgeInsets.fromLTRB(25, 0, 0, 0),
                leading: items[i].icon != null
                    ? Icon(
                        items[i].icon,
                        size: 24,
                        color: selected ? selectedFontColor ?? context.invertColor : _fontColor(context),
                      )
                    : null,
                title: _buildItem(
                  context,
                  key,
                  title,
                  selected,
                ),
                subtitle: items[i].subtitle != null ? Text(items[i].subtitle!) : null,
              );
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
