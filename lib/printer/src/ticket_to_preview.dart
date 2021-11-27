import 'package:flutter/material.dart';
import 'package:libcli/barcode/barcode.dart' as barcode;
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'ticket.dart';

Widget ticketToPreview(BuildContext context, Ticket ticket) {
  List<Widget> list = [];
  for (TicketItem item in ticket.items) {
    list.add(_previewItem(item.qtyAndNameText, item.salesAmountText(ticket.decimalDigits), bold: true));
    for (TicketItem detail in item.detail) {
      list.add(_previewDetail(detail.qtyAndNameText, detail.salesAmountText(ticket.decimalDigits)));
    }
  }

  return Column(children: [
    if (ticket.logo != null) _previewImage(ticket.logo!),
    if (ticket.instruction != null) _previewText(ticket.instruction!, linesAfter: 2),
    if (ticket.title != null) _previewText(ticket.title!, large: true),
    if (ticket.address != null) _previewText(ticket.address!),
    if (ticket.orderNumber != null) _previewText(ticket.orderNumber!, large: true, reverse: true),
    if (ticket.orderDate != null) _previewText(ticket.orderDateText),
    _previewHR(linesAfter: 1),
    if (ticket.orderType != null) _previewText(ticket.orderTypeText(context), linesAfter: 1, large: true, bold: true),
    _previewHR(),
    if (ticket.customerName != null) _previewText(ticket.customerName!),
    if (ticket.pickupTime != null) _previewText(context.i18n.ticketPickup, large: true),
    if (ticket.pickupTime != null) _previewText(ticket.pickupTimeText, large: true),
    if (ticket.itemCount != null) _previewText(ticket.itemCountText(context)),
    if (ticket.notes != null) _previewHR(linesAfter: 1),
    if (ticket.notes != null) _previewText(ticket.notes!, linesAfter: 1),
    _previewHR(),
    ...list,
    _previewHR(),
    if (ticket.subtotal != null) _previewSummary(context.i18n.ticketSubtotal, ticket.subtotalText),
    if (ticket.tax != null) _previewSummary(context.i18n.ticketTax + ' ' + ticket.taxPercentageText, ticket.taxText),
    if (ticket.delivery != null) _previewSummary(context.i18n.ticketOrderDelivery, ticket.deliveryText),
    if (ticket.service != null)
      _previewItem(context.i18n.ticketService + ' ' + ticket.servicePercentageText, ticket.serviceText),
    if (ticket.tip != null) _previewSummary(context.i18n.ticketTip + ' ' + ticket.tipPercentageText, ticket.tipText),
    if (ticket.total != null) _previewSummary(context.i18n.ticketTotal, ticket.totalText, bold: true),
    if (ticket.extraName != null) _previewSummary(ticket.extraName!, ticket.extraValue ?? ''),
    _previewHR(),
    if (ticket.qrMessage != null) _previewText(ticket.qrMessage!),
    if (ticket.qrcode != null) _previewQrcode(ticket.qrcode!),
    if (ticket.message != null) _previewText(ticket.message!, bold: true),
    _previewFeed(2),
  ]);
}

/// mmToDP convert mm to fluter device point
double mmToDP(double mm) => mm * 6.299;

/// _previewLineAfter add empty lines after child
Widget _previewLineAfter({
  required int lines,
  Widget? child,
}) {
  return Padding(
    padding: EdgeInsets.only(bottom: 5 + lines * 20),
    child: child,
  );
}

/// previewHR add line divider
Widget _previewHR({
  int linesAfter = 0,
}) {
  return _previewLineAfter(
      lines: linesAfter,
      child: const Divider(
        height: 2,
        thickness: 2,
        color: Colors.black,
      ));
}

/// _previewImage return image
Widget _previewImage(String imageUrl) {
  return delta.WebImage(imageUrl);
}

/// _previewSummary preview summary items
Widget _previewSummary(
  String left,
  String right, {
  bool large = false,
  bool bold = false,
}) {
  return _previewItem(
    left,
    right,
    large: large,
    bold: bold,
    leftWidth: 5,
    rightWidth: 7,
  );
}

/// _previewItem preview item
Widget _previewItem(
  String left,
  String right, {
  bool large = false,
  bool bold = false,
  int leftWidth = 9,
  int rightWidth = 3,
}) {
  return Row(children: [
    _previewColumn(left, leftWidth, large: large, bold: bold),
    _previewColumn(right, rightWidth, align: TextAlign.right, large: large, bold: bold),
  ]);
}

/// _previewDetail preview detail
Widget _previewDetail(
  String left,
  String right,
) {
  return Row(children: [
    _previewColumn('', 1),
    _previewColumn(left, 8),
    _previewColumn(right, 3, align: TextAlign.right),
  ]);
}

/// previewText return preview text
Widget _previewText(
  String text, {
  int linesAfter = 0,
  bool large = false,
  bool bold = false,
  bool underline = false,
  bool reverse = false,
  TextAlign align = TextAlign.center,
}) {
  return _previewLineAfter(
    lines: linesAfter,
    child: Text(
      text,
      textAlign: align,
      style: TextStyle(
        fontFamily: 'monospace',
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        decoration: underline ? TextDecoration.underline : TextDecoration.none,
        fontSize: large ? 32 : 17,
        color: reverse ? Colors.white : Colors.black,
        backgroundColor: reverse ? Colors.black : null,
      ),
    ),
  );
}

/// _previewColumn add column
Widget _previewColumn(
  String text,
  int width, {
  bool large = false,
  bool bold = false,
  bool underline = false,
  TextAlign align = TextAlign.left,
}) {
  return Expanded(
    flex: width,
    child: Text(
      text,
      textAlign: align,
      style: TextStyle(
        fontFamily: 'monospace',
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        decoration: underline ? TextDecoration.underline : TextDecoration.none,
        fontSize: large ? 32 : 17,
        color: Colors.black,
      ),
    ),
  );
}

/// _previewFeed empty lines
Widget _previewFeed(int count) {
  return _previewLineAfter(lines: count);
}

/// _previewQrcode return qr code
Widget _previewQrcode(String text) {
  return SizedBox(
    height: 140,
    child: barcode.QRCode(
      data: text,
      size: 140,
      advertiseOrReceipt: false,
    ),
  );
}
