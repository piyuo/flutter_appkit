import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cupertino_listview/cupertino_listview.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/responsive/responsive.dart' as responsive;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:libcli/pb/pb.dart' as pb;
import 'package:split_view/split_view.dart';
import 'data.dart';
import 'data_source.dart';
import 'notes_view_provider.dart';

/// NoteBuilder build note how to show on list and content
typedef NoteBuilder<T extends pb.Object> = Widget Function(BuildContext context, T row, int rowIndex);

/// Section use in list view, define section
class Section<T extends pb.Object> {
  Section({
    required this.name,
    required this.items,
  });

  String name;

  List<T> items;
}

/// SectionBuilder build section from rows
typedef SectionBuilder<T extends pb.Object> = List<Section<T>> Function(BuildContext context, List<T> rows);

class NotesView<T extends pb.Object> extends StatelessWidget {
  const NotesView({
    required this.cardBuilder,
    required this.contentBuilder,
    required this.dataSource,
    this.deleteButtonText,
    this.sectionBuilder,
    Key? key,
  }) : super(key: key);

  /// cardBuilder build card on list
  final NoteBuilder<T> cardBuilder;

  /// contentBuilder build content
  final NoteBuilder<T> contentBuilder;

  /// sectionBuilder use to build section
  final SectionBuilder<T>? sectionBuilder;

  final DataSource<T> dataSource;

  /// deleteButtonText is delete button text
  final String? deleteButtonText;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<delta.TapBreaker>(
            create: (context) => delta.TapBreaker(),
          ),
          ChangeNotifierProvider<delta.RefreshButtonController>(
            create: (context) => delta.RefreshButtonController(),
          ),
          ChangeNotifierProvider<NotesViewProvider>(
            create: (context) => NotesViewProvider(),
          ),
        ],
        child: Consumer3<delta.TapBreaker, delta.RefreshButtonController, NotesViewProvider>(
            builder: (context, breaker, refreshing, provide, _) {
          dataSource.onRefreshBegin = () {
            breaker.setBusy(true);
            refreshing.value = true;
          };
          dataSource.onRefreshEnd = () {
            breaker.setBusy(false);
            refreshing.value = false;
          };
          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _bar(context, breaker),
                  Expanded(
                    child: responsive.isPhoneDesign ? _singleLayout(context) : _sideBySideLayout(context),
                  ),
                ],
              );
            },
          );
        }));
  }

  /// _singleLayout use on phone, it show a single list let user click to enter content
  Widget _singleLayout(BuildContext context) {
    return _buildList(context);
  }

  /// _sideBySideLayout use on not phone, it show a list and content side by side
  Widget _sideBySideLayout(BuildContext context) {
    return SplitView(
      gripColor: context.themeColor(
        light: Colors.grey.shade100,
        dark: Colors.grey[850]!,
      ),
      gripColorActive: context.themeColor(
        light: Colors.grey.shade300,
        dark: Colors.grey.shade800,
      ),
      controller: SplitViewController(weights: [0.35, null]),
      viewMode: SplitViewMode.Horizontal,
      indicator: SplitIndicator(
          viewMode: SplitViewMode.Horizontal,
          color: context.themeColor(
            light: Colors.grey.shade400,
            dark: Colors.grey,
          )),
      activeIndicator: const SplitIndicator(
        viewMode: SplitViewMode.Horizontal,
        isActive: true,
        color: Colors.grey,
      ),
      children: [
        SizedBox(width: 300, child: _buildList(context)),
        const Placeholder(),
        //contentBuilder(context, null, 0),
      ],
      onWeightChanged: (w) => debugPrint("Horizon: $w"),
    );
  }

  List<Section<T>> _sections(BuildContext context) {
    if (sectionBuilder != null) {
      return sectionBuilder!(context, dataSource.pageRows);
    }
    return [Section(name: '', items: dataSource.pageRows)];
  }

  Widget _buildList(BuildContext context) {
    final sections = _sections(context);
    return CupertinoListView.builder(
      sectionCount: sections.length,
      itemInSectionCount: (section) => sections[section].items.length,
      sectionBuilder: (context, sectionPath, _) {
        final section = sections[sectionPath.section];
        return section.name.isEmpty ? const SizedBox() : Text(section.name);
      },
      childBuilder: (context, indexPath) => _buildCard(
        context,
        sections[indexPath.section].items[indexPath.child],
        indexPath.child,
      ),
//      separatorBuilder: (context, indexPath) => Divider(indent: 20.0),
    );
  }

  Widget _buildCard(BuildContext context, T row, int rowIndex) {
    return Card(
        color: Colors.blue,
        margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: cardBuilder(
          context,
          row,
          rowIndex,
        ));
  }

  Widget _bar(BuildContext context, delta.TapBreaker breaker) {
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    var _tails = dataSource.isEmpty
        ? <Widget>[]
        : <Widget>[
            Expanded(
                child: AutoSizeText(
              dataSource.isLoading ? context.i18n.loadingLabel : dataSource.pagingInfo(context),
              maxLines: 2,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
              textAlign: TextAlign.right,
            )),
            const SizedBox(width: 10),
            IconButton(
              iconSize: 32,
              icon: const Icon(Icons.chevron_left),
              padding: EdgeInsets.zero,
              tooltip: localizations.previousPageTooltip,
              onPressed: dataSource.hasPrevPage ? breaker.voidFunc(() => dataSource.prevPage(context)) : null,
            ),
            IconButton(
              iconSize: 32,
              icon: const Icon(Icons.chevron_right),
              padding: EdgeInsets.zero,
              tooltip: localizations.nextPageTooltip,
              onPressed: dataSource.hasNextPage ? breaker.voidFunc(() => dataSource.nextPage(context)) : null,
            ),
            if (responsive.isPhoneDesign) const SizedBox(width: 14),
          ];

    return Row(children: [
      const SizedBox(width: 14),
      delta.RefreshButton(
          onPressed: breaker.futureFunc(
        () => dataSource.refreshData(context),
      )!),
      IconButton(
        iconSize: 28,
        icon: const Icon(Icons.list),
        padding: EdgeInsets.zero,
        onPressed: () {},
      ),
      IconButton(
        iconSize: 24,
        icon: const Icon(Icons.grid_view),
        padding: EdgeInsets.zero,
        onPressed: () {},
      ),
      IconButton(
        iconSize: 24,
        icon: const Icon(Icons.delete),
        padding: EdgeInsets.zero,
        onPressed: () {},
      ),
      const VerticalDivider(
        width: 20,
        thickness: 5,
        color: Colors.red,
      ),
      IconButton(
        iconSize: 24,
        icon: const Icon(Icons.edit),
        padding: EdgeInsets.zero,
        onPressed: () {},
      ),
      IconButton(
        iconSize: 24,
        icon: const Icon(Icons.search),
        padding: EdgeInsets.zero,
        onPressed: () {},
      ),
      const Spacer(),
      ..._tails,
    ]);
  }
}
