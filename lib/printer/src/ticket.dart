import 'package:flutter/material.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;

enum TicketWidth { mm58, mm80 }

CapabilityProfile? _capabilityProfile;

/// _createGenerator create generator to generate ticket
Future<Generator> createGenerator(PaperSize paperSize) async {
  _capabilityProfile ??= await CapabilityProfile.load();
  return Generator(paperSize, _capabilityProfile!, spaceBetweenRows: 0);
}

class TicketItem {
  TicketItem({
    this.qty,
    this.name,
    this.salesAmount,
    this.detail = const [],
  });

  final int? qty;

  final String? name;

  final double? salesAmount;

  final List<TicketItem> detail;

  String get qtyText => qty == null ? '' : '${qty}x';

  String get qtyAndNameText => '$qtyText$name';

  String salesAmountText(int? decimalDigits) => salesAmount != null
      ? i18n.formatCurrency(
          salesAmount,
          decimalDigits: decimalDigits,
        )
      : '';
}

enum OrderType { takeout, delivery, dineIn }

enum TicketType { receipt, receiptCopy, order }

class Ticket {
  Ticket(
    this.type, {
    this.decimalDigits,
    this.instruction,
    this.logo,
    this.title,
    this.address,
    this.orderNumber,
    this.orderDate,
    this.orderType,
    this.customerName,
    this.pickupTime,
    this.itemCount,
    this.notes,
    this.items = const [],
    this.subtotal,
    this.tax,
    this.taxPercentage,
    this.delivery,
    this.service,
    this.servicePercentage,
    this.tip,
    this.tipPercentage,
    this.total,
    this.extraName,
    this.extraValue,
    this.qrMessage,
    this.qrcode,
    this.message,
  });

  final TicketType type;

  final int? decimalDigits;

  final String? instruction;

  final String? logo;

  final String? title;

  final String? address;

  final String? orderNumber;

  final DateTime? orderDate;

  String get orderDateText => orderDate != null ? i18n.formatDate(orderDate!) : '';

  final OrderType? orderType;

  String orderTypeText(BuildContext context) {
    switch (orderType) {
      case OrderType.takeout:
        return context.i18n.ticketOrderTakeout;
      case OrderType.delivery:
        return context.i18n.ticketOrderDelivery;
      case OrderType.dineIn:
        return context.i18n.ticketOrderDineIn;
      default:
        return '';
    }
  }

  final String? customerName;

  final DateTime? pickupTime;

  String get pickupTimeText => pickupTime != null ? i18n.formatTime(pickupTime!) : '';

  final int? itemCount;

  String itemCountText(BuildContext context) =>
      itemCount != null ? context.i18n.ticketItemCount.replace1(itemCount.toString()) : '';

  final String? notes;

  final List<TicketItem> items;

  double? subtotal;

  String get subtotalText => subtotal != null ? i18n.formatCurrency(subtotal, decimalDigits: decimalDigits) : '';

  double? tax;

  String get taxText => tax != null ? i18n.formatCurrency(tax, decimalDigits: decimalDigits) : '';

  /// taxPercentage range 0 - 1
  double? taxPercentage;

  String get taxPercentageText => taxPercentage != null ? i18n.formatPercentage(taxPercentage) : '';

  double? delivery;

  String get deliveryText => delivery != null ? i18n.formatCurrency(delivery, decimalDigits: decimalDigits) : '';

  double? service;

  String get serviceText => service != null ? i18n.formatCurrency(service, decimalDigits: decimalDigits) : '';

  /// servicePercentage range 0 - 1
  double? servicePercentage;

  String get servicePercentageText => servicePercentage != null ? i18n.formatPercentage(servicePercentage) : '';

  double? tip;

  String get tipText => tip != null ? i18n.formatCurrency(tip, decimalDigits: decimalDigits) : '';

  /// tipPercentage range 0 - 1
  double? tipPercentage;

  String get tipPercentageText => tipPercentage != null ? i18n.formatPercentage(tipPercentage) : '';

  double? total;

  String get totalText => total != null ? i18n.formatCurrency(total, decimalDigits: decimalDigits) : '';

  String? extraName;

  String? extraValue;

  String? qrMessage;

  String? qrcode;

  String? message;
}

Ticket testReceipt(BuildContext context) => Ticket(
      TicketType.receipt,
      instruction: context.i18n.testTicketInstruction,
      title: context.i18n.testTicketTitle,
      address: context.i18n.testTicketAddress,
      orderNumber: '1234-567-8901',
      orderDate: DateTime.now(),
      orderType: OrderType.delivery,
      customerName: context.i18n.testTicketCustomerName,
      pickupTime: DateTime.now(),
      notes: context.i18n.testTicketNotes,
      itemCount: 6,
      items: [
        TicketItem(name: context.i18n.testTicketProductName1, qty: 1, salesAmount: 9.99, detail: [
          TicketItem(name: context.i18n.testTicketProductItem1, salesAmount: 2.99),
          TicketItem(name: context.i18n.testTicketProductItem1, qty: 1, salesAmount: 0.99),
        ]),
        TicketItem(name: context.i18n.testTicketProductName2, qty: 1, salesAmount: 9.99),
        TicketItem(name: context.i18n.testTicketProductName3, qty: 3, salesAmount: 7.99),
      ],
      subtotal: 31.95,
      tax: 2.56,
      taxPercentage: 0.08,
      total: 34.51,
      qrMessage: context.i18n.testTicketQRCode,
      qrcode: 'https://piyuo.com',
      message: context.i18n.testTicketMessage,
    );
