import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:libcli/delta/delta.dart' as delta;
import 'toolbar.dart';
import 'tool_button.dart';
import 'tool_text.dart';
import 'tool_spacer.dart';

class SelectBarProvider with ChangeNotifier {
  SelectBarProvider({
    this.isSelectMode = false,
    this.selectedCount = 0,
    this.totalCount = -1,
  });

  /// isSelectMode is true if user is selecting items
  bool isSelectMode;

  /// selectedCount used on selectBar is the number of selected items
  int selectedCount;

  int totalCount;

  void toggleSelectMode() {
    isSelectMode = !isSelectMode;
    selectedCount = 0;
    totalCount = -1;
    notifyListeners();
  }

  void setSelectedInfo(int selected, int total) {
    selectedCount = selected;
    totalCount = total;
    notifyListeners();
  }

  /// isAllSelected is true if all items are selected
  bool get isAllSelected => selectedCount == totalCount;
}

/// SelectBar display a toolbar and select bar
class SelectBar extends StatelessWidget {
  const SelectBar({
    required this.selectBarProvider,
    this.actionsAfterSelect,
    this.onSelectAllChanged,
    this.isSelectable = true,
    this.items,
    this.child,
    this.onSelectModeChanged,
    this.onNew,
    this.caption,
    this.onRefresh,
    Key? key,
  }) : super(key: key);

  final SelectBarProvider selectBarProvider;

  final bool isSelectable;

  /// actions is widgets to do other action
  final List<ToolItem>? actionsAfterSelect;

  /// onSelectAllChanged is callback when user click select all button, selectAll is true mean user need select all items
  final Function(bool selectAll)? onSelectAllChanged;

  /// leftTools is extra tools on left part on bar
  final List<ToolItem>? items;

  final VoidCallback? onSelectModeChanged;

  final String? caption;

  final VoidCallback? onNew;

  final Future<void> Function()? onRefresh;

  final Widget? child; // child is null means data still loading

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    //final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => delta.RefreshButtonController(),
            ),
          ],
          child: Consumer<delta.RefreshButtonController>(builder: (context, refreshButtonController, _) {
            selecting() {
              return Material(
                  color: colorScheme.primaryContainer,
                  elevation: 4,
                  child: Toolbar(
                    items: [
                      ToolButton(
                        label: 'Select',
                        icon: selectBarProvider.isAllSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                        onPressed: () => onSelectAllChanged?.call(!selectBarProvider.isAllSelected),
                      ),
                      ToolText(
                        label: context.i18n.notesItemSelectedLabel.replace1(selectBarProvider.selectedCount.toString()),
                      ),
                      ToolSpacer(),
                      if (actionsAfterSelect != null) ...actionsAfterSelect!,
                      ToolButton(
                        label: 'Close',
                        icon: Icons.close,
                        onPressed: () {
                          selectBarProvider.toggleSelectMode();
                          onSelectModeChanged?.call();
                        },
                      ),
                    ],
                  ));
            }

            toolbar() {
              return Row(
                children: [
                  const SizedBox(width: 10),
                  if (onRefresh != null)
                    delta.RefreshButton(
                      onPressed: child != null ? () async => await onRefresh!() : null,
                    ),
                  Expanded(
                    child: Toolbar(
                      items: [
                        if (isSelectable)
                          ToolButton(
                            label: context.i18n.notesSelectButtonLabel,
                            icon: Icons.checklist,
                            onPressed: () {
                              selectBarProvider.toggleSelectMode();
                              onSelectModeChanged?.call();
                            },
                          ),
                        if (items != null) ...items!,
                        ToolSpacer(),
                        if (onNew != null)
                          ToolButton(
                            label: 'New',
                            icon: Icons.edit,
                            onPressed: () {},
                          ),
                      ],
                    ),
                  ),
                ],
              );
            }

            return Column(
              children: [
                selectBarProvider.isSelectMode ? selecting() : toolbar(),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: child,
                )),
              ],
            );
          }));
    });
  }
}
