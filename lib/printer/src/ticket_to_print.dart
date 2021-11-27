import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:image/image.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'ticket.dart';

Future<List<int>> ticketToPrint(BuildContext context, Generator generator, Ticket ticket) async {
  List<int> bytes = [];
  if (ticket.logo != null) {
    await _printImage(generator, ticket.logo!);
  }

  if (ticket.instruction != null) {
    bytes += _printText(generator, ticket.instruction!, linesAfter: 2);
  }

  if (ticket.title != null) {
    bytes += _printText(generator, ticket.title!, large: true);
  }
  if (ticket.address != null) {
    bytes += _printText(generator, ticket.address!);
  }
  if (ticket.orderNumber != null) {
    bytes += _printText(generator, ' ' + ticket.orderNumber! + ' ', reverse: true, large: true, bold: true);
  }
  if (ticket.orderDate != null) {
    bytes += _printText(generator, ticket.orderDateText);
  }
  bytes += generator.hr(linesAfter: 1);
  if (ticket.orderType != null) {
    bytes += _printText(generator, ticket.orderTypeText(context), linesAfter: 1, large: true, bold: true);
  }
  bytes += generator.hr();
  if (ticket.customerName != null) {
    bytes += _printText(generator, ticket.customerName!);
  }
  if (ticket.pickupTime != null) {
    bytes += _printText(generator, context.i18n.ticketPickup, large: true);
  }
  if (ticket.pickupTime != null) {
    bytes += _printText(generator, ticket.pickupTimeText, large: true);
  }
  if (ticket.itemCount != null) {
    bytes += _printText(generator, ticket.itemCountText(context));
  }

  if (ticket.notes != null) {
    bytes += generator.hr(linesAfter: 1);
    bytes += _printText(generator, ticket.notes!, linesAfter: 1);
  }

  bytes += generator.hr();
  for (TicketItem item in ticket.items) {
    bytes += _printItem(generator, item.qtyAndNameText, item.salesAmountText(ticket.decimalDigits), bold: true);
    for (TicketItem detail in item.detail) {
      bytes += _printDetail(generator, detail.qtyAndNameText, detail.salesAmountText(ticket.decimalDigits));
    }
  }
  bytes += generator.hr();

  if (ticket.subtotal != null) {
    bytes += _printSummary(generator, context.i18n.ticketSubtotal, ticket.subtotalText);
  }
  if (ticket.tax != null) {
    bytes += _printSummary(generator, context.i18n.ticketTax + ' ' + ticket.taxPercentageText, ticket.taxText);
  }
  if (ticket.delivery != null) {
    bytes += _printSummary(generator, context.i18n.ticketOrderDelivery, ticket.deliveryText);
  }
  if (ticket.service != null) {
    bytes +=
        _printSummary(generator, context.i18n.ticketService + ' ' + ticket.servicePercentageText, ticket.serviceText);
  }
  if (ticket.tip != null) {
    bytes += _printSummary(generator, context.i18n.ticketTip + ' ' + ticket.tipPercentageText, ticket.tipText);
  }
  if (ticket.total != null) {
    bytes += _printSummary(generator, context.i18n.ticketTotal, ticket.totalText, bold: true);
  }
  if (ticket.extraName != null) {
    bytes += _printSummary(generator, ticket.extraName!, ticket.extraValue ?? '');
  }
  bytes += generator.hr();

  if (ticket.qrMessage != null) {
    bytes += _printText(generator, ticket.qrMessage!);
  }

  if (ticket.qrcode != null) {
    bytes += generator.hr(ch: ' ');
    bytes += generator.qrcode(ticket.qrcode!, size: QRSize.Size8, cor: QRCorrection.Q);
    bytes += generator.hr(ch: ' ');
  }

  if (ticket.message != null) {
    bytes += _printText(generator, ticket.message!, bold: true);
  }

  bytes += generator.feed(2);
  bytes += generator.cut();
  return bytes;
}

// todo: print image not working right now, maybe printer not support
/// printImage print image
Future<List<int>?> _printImage(Generator generator, String url) async {
  if (url.contains('http')) {
    final bytes = await delta.webImageData(url);
    if (bytes != null) {
      final image = decodeImage(bytes);
      if (image != null) {
        final List<int> data = generator.image(image);
        return data;
      }
    }
  }

  final ByteData data = await rootBundle.load(url);
  final Uint8List buf = data.buffer.asUint8List();
  final Image image = decodeImage(buf)!;
  final List<int> bytes = generator.image(image);
  return bytes;
}

/// _printSummary preview summary items
List<int> _printSummary(
  Generator generator,
  String left,
  String right, {
  bool large = false,
  bool bold = false,
}) {
  return _printItem(
    generator,
    left,
    right,
    large: large,
    bold: bold,
    leftWidth: 5,
    rightWidth: 7,
  );
}

/// printItem print image
List<int> _printItem(
  Generator generator,
  String left,
  String right, {
  bool large = false,
  bool bold = false,
  int leftWidth = 9,
  int rightWidth = 3,
}) {
  return generator.row([
    PosColumn(
      containsChinese: true,
      text: left,
      width: leftWidth,
      styles: PosStyles(
        align: PosAlign.left,
        bold: bold,
        height: large ? PosTextSize.size2 : PosTextSize.size1,
        width: large ? PosTextSize.size2 : PosTextSize.size1,
      ),
    ),
    PosColumn(
      text: right,
      width: rightWidth,
      styles: PosStyles(
        align: PosAlign.right,
        bold: bold,
        height: large ? PosTextSize.size2 : PosTextSize.size1,
        width: large ? PosTextSize.size2 : PosTextSize.size1,
      ),
    ),
  ]);
}

List<int> _printDetail(Generator generator, String left, String right) {
  return generator.row([
    PosColumn(
      width: 1,
    ),
    PosColumn(
      containsChinese: true,
      text: left,
      width: 8,
      styles: const PosStyles(
        align: PosAlign.left,
      ),
    ),
    PosColumn(
      text: right,
      width: 3,
      styles: const PosStyles(
        align: PosAlign.right,
      ),
    ),
  ]);
}

/// _printText print text
List<int> _printText(
  Generator generator,
  String text, {
  int linesAfter = 0,
  bool large = false,
  bool bold = false,
  bool reverse = false,
  bool underline = false,
  PosAlign align = PosAlign.center,
}) {
  generator.spaceBetweenRows = 10;
  return generator.text(text,
      containsChinese: true,
      linesAfter: linesAfter,
      styles: PosStyles(
        align: align,
        bold: bold,
        height: large ? PosTextSize.size2 : PosTextSize.size1,
        width: large ? PosTextSize.size2 : PosTextSize.size1,
        reverse: reverse,
        underline: underline,
      ));
}
