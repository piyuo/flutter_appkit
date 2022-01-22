import 'package:flutter/material.dart';
import 'package:libcli/pb/src/google/google.dart' as google;
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/cache/cache.dart' as cache;

/// RowBuilder build table row cells
typedef TableBuilder<T extends pb.Object> = List<Widget> Function(BuildContext context, T row, int rowIndex);

/// CardBuilder build card for mobile device
typedef CardBuilder<T extends pb.Object> = Widget Function(BuildContext context, T row, int rowIndex);

/// DataRemover remove data, return true if removal success
typedef DataRemover<T extends pb.Object> = Future<void> Function(BuildContext context, List<String> ids);

/// OnRowTap trigger when user tap on row
typedef OnRowTap<T extends pb.Object> = void Function(BuildContext context, T row, int rowIndex);

/// DataLoader load new data by guide, return null if this data reach to the end.
typedef DataLoader<T> = Future<List<T>?> Function(
    BuildContext context, bool refresh, int limit, google.Timestamp? anchorTime, String? anchorId);

/// DataGetter get data from remote service
typedef DataGetter<T> = Future<T?> Function(BuildContext context, String id);

/// DataSetter set data to remote service
typedef DataSetter<T> = Future<void> Function(BuildContext context, T obj);
