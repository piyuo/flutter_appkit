import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:libcli/pb/pb.dart' as pb;
import 'data.dart';
import 'data_source.dart';

enum ColumnWidth { small, regular, large }

class PageColumn extends DataColumn2 {
  /// Creates the configuration for a column of a [DataTable2].
  ///
  /// The [label] argument must not be null.
  const PageColumn(
      {required Widget label,
      String? tooltip,
      bool numeric = false,
      Function(int, bool)? onSort,
      ColumnWidth width = ColumnWidth.regular})
      : super(
          label: label,
          tooltip: tooltip,
          numeric: numeric,
          onSort: onSort,
          size: width == ColumnWidth.regular
              ? ColumnSize.M
              : width == ColumnWidth.small
                  ? ColumnSize.S
                  : ColumnSize.L,
        );
}

class PageTable<T extends pb.Object> extends StatelessWidget {
  const PageTable({
    required this.columns,
    required this.tableBuilder,
    required this.cardBuilder,
    required this.dataSource,
    this.onRowTap,
    this.selectable = true,
    this.cardHeight = 100,
    this.tableRowHeight = 48,
    this.dragStartBehavior = DragStartBehavior.start,
    this.dataRemover,
    this.availableRowsPerPage = const <int>[10, 20, 50],
    this.smallRatio = 0.5,
    this.largeRatio = 2,
    Key? key,
  }) : super(key: key);

  final List<PageColumn> columns;

  /// TableBuilder build table row
  final TableBuilder<T> tableBuilder;

  /// rowHeight is data row height in row layout
  final double tableRowHeight;

  /// cardBuilder build card layout used in mobile device
  final CardBuilder<T> cardBuilder;

  /// onRowTap trigger when user tap on row
  final OnRowTap<T>? onRowTap;

  /// cardHeight is row height in card layout
  final double? cardHeight;

  /// selectable is true if user can select rows
  final bool selectable;

  final DragStartBehavior dragStartBehavior;

  final DataSource<T> dataSource;

  /// dataRemover call when control need delete data from data source
  final DataRemover<T>? dataRemover;

  /// The options to offer for the rowsPerPage.
  ///
  /// The current [_rowsPerPage] must be a value in this list.
  ///
  /// The values in this list should be sorted in ascending order.
  final List<int> availableRowsPerPage;

  final double smallRatio;

  final double largeRatio;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    return ChangeNotifierProvider<delta.TapBreaker>(
        create: (context) => delta.TapBreaker(),
        child: Consumer<delta.TapBreaker>(builder: (context, breaker, child) {
          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return isTableLayout
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        if (isTableLayout) buildHeader(context, breaker),
                        Expanded(
                          child: _buildTable(context),
                        ),
                      ],
                    )
                  : _buildCard(
                      context,
                      constraints.maxWidth,
                      breaker,
                    );
            },
          );
        }));
  }

  /// isTableLayout return true if use table layout
  bool get isTableLayout => !delta.isPhoneDesign;

  Widget buildHeader(BuildContext context, delta.TapBreaker breaker) {
    if (dataSource.selectedRows.isNotEmpty) {
      return buildSelectedHeader(context, breaker);
    }
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    var _actions = <Widget>[
      if (isTableLayout) const SizedBox(width: 14),
      IconButton(
        tooltip: context.i18n.refreshButtonText,
        onPressed: breaker.linkVoidFunc(() => dataSource.refresh(context)),
        icon: const Icon(Icons.refresh_rounded),
      ),
      if (isTableLayout) Text(localizations.rowsPerPageTitle, style: const TextStyle(color: Colors.grey, fontSize: 14)),
      if (isTableLayout) const SizedBox(width: 10),
      ConstrainedBox(
        constraints: BoxConstraints(minWidth: isTableLayout ? 54 : 30), // 40.0 for the text, 24.0 for the icon
        child: Align(
          alignment: AlignmentDirectional.centerEnd,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              items: availableRowsPerPage.map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text('$value'),
                );
              }).toList(),
              value: dataSource.rowsPerPage,
              onChanged: breaker.linkValueFunc<int>(
                (int? value) => dataSource.setRowsPerPage(context, value!),
              ),
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
        ),
      ),
    ];

    var _tails = dataSource.isEmpty
        ? <Widget>[]
        : <Widget>[
            Expanded(
                child: AutoSizeText(
              dataSource.isBusy ? context.i18n.loadingLabel : dataSource.pagingInfo(context),
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
              onPressed: dataSource.hasPrevPage ? breaker.linkVoidFunc(() => dataSource.prevPage(context)) : null,
            ),
            IconButton(
              iconSize: 32,
              icon: const Icon(Icons.chevron_right),
              padding: EdgeInsets.zero,
              tooltip: localizations.nextPageTooltip,
              onPressed: dataSource.hasNextPage ? breaker.linkVoidFunc(() => dataSource.nextPage(context)) : null,
            ),
            if (isTableLayout) const SizedBox(width: 14),
          ];
    return styleHeader(context, _actions, _tails);
  }

  Widget buildSelectedHeader(BuildContext context, delta.TapBreaker breaker) {
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    final tails = <Widget>[
      if (dataRemover != null)
        Padding(
            padding: EdgeInsets.only(right: isTableLayout ? 24 : 6),
            child: ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red[600])),
              child: Text(context.i18n.deleteButtonText),
              onPressed: breaker.linkVoidFunc(
                () async => dataSource.deleteSelectedRows(context),
              ),
            )),
    ];
    return styleHeader(
        context,
        [
          SizedBox(width: isTableLayout ? 24 : 6),
          Expanded(
            child: Text(localizations.selectedRowCountTitle(dataSource.selectedRows.length)),
          )
        ],
        tails);
  }

  Widget styleHeader(BuildContext context, List<Widget> leadings, List<Widget> tails) {
    final ThemeData themeData = Theme.of(context);
    return Semantics(
      container: true,
      child: DefaultTextStyle(
        // These typographic styles aren't quite the regular ones. We pick the closest ones from the regular
        // list and then tweak them appropriately.
        // See https://material.io/design/components/data-tables.html#tables-within-cards
        style: dataSource.selectedRows.isNotEmpty
            ? themeData.textTheme.subtitle1!.copyWith(color: themeData.colorScheme.secondary)
            : themeData.textTheme.headline6!.copyWith(fontWeight: FontWeight.w400),
        child: IconTheme.merge(
          data: const IconThemeData(
            opacity: 0.54,
          ),
          child: Ink(
              height: isTableLayout ? 48 : 76,
              color: dataSource.selectedRows.isNotEmpty && isTableLayout ? themeData.secondaryHeaderColor : null,
              child: Row(
                children: [
                  ...leadings,
                  Expanded(child: Row(mainAxisAlignment: MainAxisAlignment.end, children: tails)),
                ],
              )),
        ),
      ),
    );
  }

  /// _buildNoData build no data ui
  Widget _buildNoData(BuildContext context) {
    return SizedBox(
      height: tableRowHeight * 3,
      width: 250,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.wb_cloudy_outlined,
            size: 54,
            color: Colors.grey,
          ),
          Text(context.i18n.noDataLabel,
              style: const TextStyle(
                color: Colors.grey,
              )),
        ],
      ),
    );
  }

  Widget _buildTable(BuildContext context) {
    return DataTable2(
      showBottomBorder: true,
      smRatio: smallRatio,
      lmRatio: largeRatio,
      headingRowHeight: 38,
      columnSpacing: 6,
      dataRowHeight: tableRowHeight,
      headingRowColor: MaterialStateProperty.all(context.themeColor(
        light: Colors.grey.shade100,
        dark: Colors.grey.shade800,
      )),
      columns: columns,
      onSelectAll: (bool? selected) => dataSource.selectRows(selected ?? false),
      empty: _buildNoData(context),
      rows: dataSource.isBusy
          ? List<DataRow>.generate(
              dataSource.rowsPerPage,
              (int position) {
                return DataRow(
                    selected: false,
                    onSelectChanged: selectable ? (bool? selected) {} : null,
                    cells: List<Widget>.generate(
                            columns.length,
                            (_) => Container(
                                  margin: const EdgeInsets.fromLTRB(0, 14, 5, 14),
                                  color: Colors.grey.shade500,
                                ))
                        .map((Widget widget) => DataCell(Shimmer.fromColors(
                              baseColor: Colors.grey.shade500,
                              highlightColor: Colors.grey.shade100,
                              child: widget,
                            )))
                        .toList());
              },
            )
          : List<DataRow>.generate(
              dataSource.pageRows.length,
              (int index) {
                final row = dataSource.pageRows[index];
                return DataRow(
                    selected: dataSource.isRowSelected(row),
                    onSelectChanged: selectable ? (bool? selected) => dataSource.selectRow(row, selected) : null,
                    cells: tableBuilder(context, row, index)
                        .map((Widget widget) => DataCell(
                              widget,
                              onTap: onRowTap != null ? () => onRowTap!(context, row, index) : null,
                            ))
                        .toList());
              },
            ),
    );
  }

  Widget _buildCard(BuildContext context, double maxWidth, delta.TapBreaker breaker) {
    final ThemeData themeData = Theme.of(context);
    return Theme(
        data: Theme.of(context).copyWith(
          dividerColor: context.themeColor(
            light: Colors.white,
            dark: Colors.grey.shade800,
          ),
        ),
        child: DataTable2(
            smRatio: smallRatio,
            lmRatio: largeRatio,
            horizontalMargin: 12,
            dataRowHeight: cardHeight,
            headingRowHeight: 48,
            headingRowColor:
                dataSource.selectedRows.isNotEmpty ? MaterialStateProperty.all(themeData.secondaryHeaderColor) : null,
            columns: [
              DataColumn(label: buildHeader(context, breaker)),
            ],
            onSelectAll: (bool? selected) => dataSource.selectRows(selected ?? false),
            empty: _buildNoData(context),
            rows: dataSource.isBusy
                ? List<DataRow>.generate(
                    dataSource.rowsPerPage,
                    (int position) {
                      return DataRow(
                        selected: false,
                        onSelectChanged: selectable ? (bool? selected) {} : null,
                        cells: [
                          DataCell(Shimmer.fromColors(
                            baseColor: Colors.grey.shade500,
                            highlightColor: Colors.grey.shade100,
                            child: Card(margin: const EdgeInsets.symmetric(vertical: 5), child: Container()),
                          ))
                        ],
                      );
                    },
                  )
                : List<DataRow>.generate(
                    dataSource.pageRows.length,
                    (int index) {
                      final row = dataSource.pageRows[index];
                      return DataRow(
                        selected: dataSource.isRowSelected(row),
                        onSelectChanged: selectable ? (bool? selected) => dataSource.selectRow(row, selected) : null,
                        cells: [
                          DataCell(Card(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              child: SizedBox(
                                  width: maxWidth,
                                  child: cardBuilder(
                                    context,
                                    row,
                                    index,
                                  ))))
                        ],
                      );
                    },
                  )));
  }
}
