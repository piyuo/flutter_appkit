import 'package:flutter/material.dart';

/// DataLoader load data after last object
/// if T is null mean load row from Beginning
/// if T is not null mean load row after T
typedef DataLoader<T> = Future<List<T>> Function(BuildContext context, T? last, int rowsPerPage);

/// DataRefresher refresh cached rows, return true if cachedRows has reach to end
typedef DataRefresher<T> = Future<RefreshInstruction<T>> Function(BuildContext context, T? first, int rowsPerPage);

/// RefreshInstruction instruct how to refresh rows
class RefreshInstruction<T> {
  RefreshInstruction({
    required this.updated,
    required this.deleted,
  });
  final List<T> updated;
  final List<T> deleted;
  bool get isNotEmpty => updated.isNotEmpty || deleted.isNotEmpty;
}

/// DataRemover remove data, return true if removal success
typedef DataRemover<T> = Future<bool> Function(BuildContext context, List<T> selectedRows);

/// CacheInstruction instruct how to cache data source
class CacheInstruction<T> {
  CacheInstruction({
    required this.status,
    required this.rowsPerPage,
    required this.rows,
  });
  final PagedDataSourceStatus status;
  final int rowsPerPage;
  final List<T> rows;
}

/// DiskCacheWriter write to disk cache
typedef DiskCacheWriter<T> = Future<void> Function(BuildContext context, CacheInstruction<T> instruction);

/// DiskCacheReader read from disk cache
typedef DiskCacheReader<T> = Future<CacheInstruction<T>?> Function(BuildContext context);

/// PagedDataSourceStatus is data source status
enum PagedDataSourceStatus { notLoad, load, end }

/// RowBuilder build table row cells
typedef RowBuilder<T> = List<DataCell> Function(BuildContext context, T row, int rowIndex);

/// CardBuilder build card for mobile device
typedef CardBuilder<T> = Widget Function(BuildContext context, T row, int rowIndex);
