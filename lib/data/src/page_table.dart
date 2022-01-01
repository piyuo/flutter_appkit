import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:libcli/pb/pb.dart' as pb;
import 'data_source.dart';

/// RowBuilder build table row cells
typedef RowBuilder<T extends pb.Object> = List<DataCell> Function(BuildContext context, T row, int rowIndex);

/// CardBuilder build card for mobile device
typedef CardBuilder<T extends pb.Object> = Widget Function(BuildContext context, T row, int rowIndex);

/// DataRemover remove data, return true if removal success
typedef DataRemover<T extends pb.Object> = Future<bool> Function(BuildContext context, List<T> selectedRows);

class PageTable<T extends pb.Object> extends StatelessWidget {
  const PageTable({
    required this.columns,
    required this.dataSource,
    this.cardHeight,
    this.cardBuilder,
    this.rowHeight,
    this.rowBuilder,
    this.dragStartBehavior = DragStartBehavior.start,
    this.header,
    this.actions = const [],
    this.dataRemover,
    this.availableRowsPerPage = const <int>[10, 20, 50],
    Key? key,
  })  : assert(cardBuilder != null || rowBuilder != null),
        super(key: key);

  final List<DataColumn> columns;

  /// rowHeight is data row height in row layout
  final double? rowHeight;

  /// RowBuilder build cells layout
  final RowBuilder<T>? rowBuilder;

  /// cardHeight is row height in card layout
  final double? cardHeight;

  /// cardBuilder build card layout used in mobile device
  final CardBuilder<T>? cardBuilder;

  final DragStartBehavior dragStartBehavior;

  final DataSource<T> dataSource;

  /// dataRemover call when control need delete data from data source
  final DataRemover<T>? dataRemover;

  /// The table card's optional header.
  ///
  /// This is typically a [Text] widget, but can also be a [Row] of
  /// [TextButton]s. To show icon buttons at the top end side of the table with
  /// a header, set the [actions] property.
  ///
  /// If items in the table are selectable, then, when the selection is not
  /// empty, the header is replaced by a count of the selected items. The
  /// [actions] are still visible when items are selected.
  final Widget? header;

  /// Icon buttons to show at the top end side of the table. The [header] must
  /// not be null to show the actions.
  ///
  /// Typically, the exact actions included in this list will vary based on
  /// whether any rows are selected or not.
  ///
  /// These should be size 24.0 with default padding (8.0).
  final List<Widget> actions;

  /// The options to offer for the rowsPerPage.
  ///
  /// The current [_rowsPerPage] must be a value in this list.
  ///
  /// The values in this list should be sorted in ascending order.
  final List<int> availableRowsPerPage;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    final ThemeData themeData = Theme.of(context);
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);

    return ChangeNotifierProvider<delta.TapBreaker>(
        create: (context) => delta.TapBreaker(),
        child: Consumer<delta.TapBreaker>(builder: (context, breaker, child) {
          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return IntrinsicHeight(
                //semanticContainer: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    if (isTableLayout) buildHeader(context, dataSource, 24, breaker),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      dragStartBehavior: dragStartBehavior,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minWidth: constraints.minWidth),
                        child: isTableLayout
                            ? _buildTable(context, dataSource)
                            : _buildCard(context, dataSource, constraints.maxWidth, breaker),
                      ),
                    ),
                    buildExtraInfo(context, dataSource),
                    buildFooter(context, dataSource, themeData, localizations, constraints, breaker),
                  ],
                ),
              );
            },
          );
        }));
  }

  /// isTableLayout return true if use table layout
  bool get isTableLayout {
    if (rowBuilder != null && cardBuilder != null) {
      return delta.isPhoneDesign ? false : true;
    }
    if (cardBuilder != null) {
      return false;
    }
    return true;
  }

  Widget buildInfo(Widget child) {
    return SizedBox(
      height: 48 * 10,
      child: Center(child: child),
    );
  }

  Widget buildExtraInfo(BuildContext context, DataSource dataSource) {
    return dataSource.isBusy
        ? buildInfo(Text(context.i18n.loadingLabel))
        : buildInfo(
            InkWell(
              child: SizedBox(
                height: 150,
                width: 250,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 54,
                    ),
                    Text(context.i18n.errorTitle),
                    Text(context.i18n.tapToRetryButtonText),
                  ],
                ),
              ),
              // onTap: () => dataSource.loadMoreRow(context),
            ),
          );
  }

  Widget buildFooter(
    BuildContext context,
    DataSource dataSource,
    ThemeData themeData,
    MaterialLocalizations localizations,
    BoxConstraints constraints,
    delta.TapBreaker breaker,
  ) {
    final TextStyle? footerTextStyle = themeData.textTheme.caption;
    final List<Widget> rowsWidgets = <Widget>[];
    if (availableRowsPerPage.isNotEmpty) {
      final List<Widget> _availableRowsPerPage = availableRowsPerPage.map<DropdownMenuItem<int>>((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text('$value'),
        );
      }).toList();
      rowsWidgets.addAll(<Widget>[
        const SizedBox(width: 24.0),
        Text(localizations.rowsPerPageTitle),
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 64.0), // 40.0 for the text, 24.0 for the icon
          child: Align(
            alignment: AlignmentDirectional.centerEnd,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                items: _availableRowsPerPage.cast<DropdownMenuItem<int>>(),
                value: dataSource.rowsPerPage,
                onChanged: breaker.linkValueFunc<int>(
                  (int? value) => dataSource.setRowsPerPage(context, value!),
                ),
                style: footerTextStyle,
                iconSize: 24.0,
              ),
            ),
          ),
        ),
      ]);
    }

    final infoWidgets = <Widget>[
      const SizedBox(width: 24.0),
      dataSource.isBusy
          ? SizedBox(
              width: 64,
              child: LinearProgressIndicator(
                backgroundColor: Colors.grey.shade300,
                color: Colors.grey.shade500,
              ),
            )
          : Text(dataSource.pagingInfo(context)),
    ];

    final pageWidgets = <Widget>[
      const SizedBox(width: 32.0),
      IconButton(
        icon: const Icon(Icons.skip_previous),
        padding: EdgeInsets.zero,
        tooltip: localizations.firstPageTooltip,
        onPressed: dataSource.hasPrevPage ? breaker.linkVoidFunc(() => dataSource.firstPage(context)) : null,
      ),
      IconButton(
        icon: const Icon(Icons.chevron_left),
        padding: EdgeInsets.zero,
        tooltip: localizations.previousPageTooltip,
        onPressed: dataSource.hasPrevPage ? breaker.linkVoidFunc(() => dataSource.prevPage(context)) : null,
      ),
      const SizedBox(width: 24.0),
      IconButton(
        icon: const Icon(Icons.chevron_right),
        padding: EdgeInsets.zero,
        tooltip: localizations.nextPageTooltip,
        onPressed: dataSource.hasNextPage ? breaker.linkVoidFunc(() => dataSource.nextPage(context)) : null,
      ),
      if (dataSource.noMoreData)
        IconButton(
          icon: const Icon(Icons.skip_next),
          padding: EdgeInsets.zero,
          tooltip: localizations.lastPageTooltip,
          onPressed: dataSource.hasLastPage ? breaker.linkVoidFunc(() => dataSource.lastPage(context)) : null,
        ),
      Container(width: 14.0),
    ];

    return DefaultTextStyle(
      style: footerTextStyle!,
      child: IconTheme.merge(
        data: const IconThemeData(
          opacity: 0.54,
        ),
        child: SizedBox(
          height: 56,
          child: constraints.maxWidth > 500
              ? Row(
                  children: [
                    Expanded(
                      child: Row(children: rowsWidgets),
                    ),
                    ...infoWidgets,
                    ...pageWidgets,
                  ],
                )
              : Column(
                  children: [
                    SizedBox(
                      height: 24,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Row(children: infoWidgets),
                          ),
                          ...pageWidgets,
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 24,
                      child: Row(children: rowsWidgets),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context, DataSource<T> dataSource, double paddingLeft, delta.TapBreaker breaker) {
    final ThemeData themeData = Theme.of(context);
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    final List<Widget> headerWidgets = <Widget>[];
    if (dataSource.selectedRows.isEmpty && header != null) {
      headerWidgets.add(Expanded(child: header!));
    } else if (header != null) {
      headerWidgets.add(
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 6),
            child: Text(localizations.selectedRowCountTitle(dataSource.selectedRows.length)),
          ),
        ),
      );
    }

    var _actions = <Widget>[];
    _actions.addAll(actions);
    if (dataRemover != null) {
      _actions.add(!dataSource.selectedRowsIsEmpty
          ? ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red[600])),
              child: Text(context.i18n.deleteButtonText),
              onPressed: breaker.linkVoidFunc(() => dataRemover!(context, dataSource.selectedRows)),
            )
          : IconButton(
              tooltip: context.i18n.deleteButtonText,
              onPressed: null,
              icon: const Icon(
                Icons.delete,
              ),
            ));
    }

    if (dataSource.selectedRowsIsEmpty) {
      _actions.add(
        IconButton(
          tooltip: context.i18n.refreshButtonText,
          onPressed: breaker.linkVoidFunc(() => dataSource.refresh(context)),
          icon: const Icon(Icons.refresh_rounded),
        ),
      );
    }

    if (_actions.isNotEmpty) {
      headerWidgets.addAll(
        _actions.map<Widget>((Widget action) {
          return Padding(
            // 8.0 is the default padding of an icon button
            padding: const EdgeInsetsDirectional.only(start: 24.0 - 8.0 * 2.0),
            child: action,
          );
        }).toList(),
      );
    }
    return headerWidgets.isNotEmpty
        ? Semantics(
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
                  height: 64.0,
                  color: dataSource.selectedRows.isNotEmpty && isTableLayout ? themeData.secondaryHeaderColor : null,
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(start: paddingLeft, end: 14.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: headerWidgets,
                    ),
                  ),
                ),
              ),
            ),
          )
        : const SizedBox();
  }

  List<DataRow> buildRows(BuildContext context, DataSource<T> dataSource, RowBuilder<T> builder) {
    return List<DataRow>.generate(
      dataSource.rows.length,
      (int position) {
        final rowIndex = dataSource.rowIndex(position);
        final row = dataSource.rows[rowIndex];
        return DataRow(
          selected: dataSource.isSelected(rowIndex),
          onSelectChanged: (bool? selected) => dataSource.select(rowIndex, selected),
          cells: builder(context, row, rowIndex),
        );
      },
    );
  }

  Widget _buildTable(BuildContext context, DataSource<T> dataSource) {
    return DataTable(
      dataRowHeight: rowHeight,
      headingRowColor: MaterialStateProperty.all(context.themeColor(
        light: Colors.grey.shade100,
        dark: Colors.grey.shade800,
      )),
      columns: columns,
      onSelectAll: (bool? selected) => dataSource.selectAll(selected),
      rows: buildRows(context, dataSource, rowBuilder!),
    );
  }

  Widget _buildCard(BuildContext context, DataSource<T> dataSource, double maxWidth, delta.TapBreaker breaker) {
    final ThemeData themeData = Theme.of(context);
    double cardWidth = maxWidth - 100;
    return Theme(
        data: Theme.of(context).copyWith(
          dividerColor: context.themeColor(
            light: Colors.white,
            dark: Colors.grey.shade800,
          ),
        ),
        child: DataTable(
          dataRowHeight: cardHeight,
          headingRowColor:
              dataSource.selectedRows.isNotEmpty ? MaterialStateProperty.all(themeData.secondaryHeaderColor) : null,
          columns: [
            DataColumn(
                label: SizedBox(
              width: cardWidth,
              //child: Container(color: Colors.red),
              child: buildHeader(context, dataSource, 0, breaker),
            )),
          ],
          onSelectAll: (bool? selected) => dataSource.selectAll(selected),
          rows: buildRows(
            context,
            dataSource,
            (BuildContext context, T row, int rowIndex) => [
              DataCell(
                ConstrainedBox(
                    constraints: BoxConstraints(minWidth: cardWidth), //SET max width
                    child: cardBuilder!(context, row, rowIndex)),
              )
            ],
          ),
        ));
  }
}
