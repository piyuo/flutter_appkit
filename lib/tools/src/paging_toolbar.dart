import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:libcli/delta/delta.dart' as delta;
import 'toolbar.dart';
import 'tool_button.dart';
import 'tool_spacer.dart';

class PagingToolbarProvider with ChangeNotifier {
  PagingToolbarProvider({
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

/// PagingToolbar is a widget to display data in list or grid view, add tools and paginator
class PagingToolbar extends StatelessWidget {
  const PagingToolbar({
    required this.pagingToolbarProvider,
    required this.onSetRowsPerPage,
    required this.onPreviousPage,
    required this.onNextPage,
    this.actionsAfterSelect,
    this.onSelectAllChanged,
    this.isSelectable = true,
    this.hasPreviousPage = true,
    this.hasNextPage = true,
    this.pageInfo,
    this.leftTools,
    this.child,
    this.onSelectModeChanged,
    this.onCreateNew,
    this.caption,
    this.onRefresh,
    Key? key,
  }) : super(key: key);

  final PagingToolbarProvider pagingToolbarProvider;

  final bool isSelectable;

  /// actions is widgets to do other action
  final List<Widget>? actionsAfterSelect;

  /// onSelectAllChanged is callback when user click select all button, selectAll is true mean user need select all items
  final Function(bool selectAll)? onSelectAllChanged;

  /// leftTools is extra tools on left part on bar
  final List<ToolItem>? leftTools;

  final void Function(int) onSetRowsPerPage;

  final VoidCallback onPreviousPage;

  final VoidCallback onNextPage;

  final bool hasPreviousPage;

  final bool hasNextPage;

  final String? pageInfo;

  final Widget? child; // child is null means data still loading

  final VoidCallback? onSelectModeChanged;

  final VoidCallback? onCreateNew;

  final Widget? caption;

  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => delta.RefreshButtonController(),
            ),
          ],
          child: Consumer<delta.RefreshButtonController>(builder: (context, refreshButtonController, _) {
            selectBar() {
              return Container(
                  color: colorScheme.primaryContainer,
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          pagingToolbarProvider.isAllSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                          color: colorScheme.onPrimaryContainer,
                        ),
                        onPressed: () => onSelectAllChanged?.call(!pagingToolbarProvider.isAllSelected),
                      ),
                      Text(context.i18n.notesItemSelectedLabel.replace1(pagingToolbarProvider.selectedCount.toString()),
                          style: TextStyle(fontSize: 16, color: colorScheme.onPrimaryContainer), maxLines: 1),
                      const Spacer(),
                      if (actionsAfterSelect != null) ...actionsAfterSelect!,
                      TextButton(
                        onPressed: () {
                          pagingToolbarProvider.toggleSelectMode();
                          onSelectModeChanged?.call();
                        },
                        child:
                            Text(context.i18n.closeButtonText, style: TextStyle(color: colorScheme.onPrimaryContainer)),
                      ),
                    ],
                  ));
            }

            touchBottomBarBuilder() {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 18),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: colorScheme.surfaceVariant,
                ),
                child: Row(children: [
                  if (onSelectModeChanged != null)
                    TextButton(
                      onPressed: child != null ? () => onSelectModeChanged!() : null,
                      child: Text(context.i18n.notesSelectButtonLabel),
                    ),
                  pageInfo != null
                      ? Expanded(
                          child: Text(pageInfo!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                              )),
                        )
                      : const Spacer(),
                  if (onCreateNew != null)
                    TextButton(
                      onPressed: child != null ? () => onCreateNew!() : null,
                      child: Text(context.i18n.notesNewButtonLabel),
                    ),
                ]),
              );
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
                              pagingToolbarProvider.toggleSelectMode();
                              onSelectModeChanged?.call();
                            },
                          ),
                        if (leftTools != null) ...leftTools!,
                        ToolSpacer(),
                        ToolButton(
                          label: localizations.previousPageTooltip,
                          icon: Icons.chevron_left,
                          onPressed: hasPreviousPage ? () => onPreviousPage() : null,
                        ),
                        ToolButton(
                          label: localizations.nextPageTooltip,
                          icon: Icons.chevron_right,
                          onPressed: hasNextPage ? () => onNextPage() : null,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

            return Column(
              children: [
                if (context.isPreferMouse) pagingToolbarProvider.isSelectMode ? selectBar() : toolbar(),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: child,
                )),
                if (!context.isPreferMouse) pagingToolbarProvider.isSelectMode ? selectBar() : touchBottomBarBuilder(),
              ],
            );
          }));
    });
  }
}
