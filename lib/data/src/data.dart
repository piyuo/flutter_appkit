import 'package:flutter/material.dart';
import 'package:libcli/pb/pb.dart' as pb;

/// RowBuilder build table row cells
typedef TableBuilder<T extends pb.Object> = List<Widget> Function(BuildContext context, T row, int rowIndex);

/// CardBuilder build card for mobile device
typedef CardBuilder<T extends pb.Object> = Widget Function(BuildContext context, T row, int rowIndex);

/// DataRemover remove data, return true if removal success
typedef DataRemover<T extends pb.Object> = Future<bool> Function(BuildContext context, List<T> selectedRows);

/// OnRowTap trigger when user tap on row
typedef OnRowTap<T extends pb.Object> = void Function(BuildContext context, T row, int rowIndex);
