import 'package:flutter/material.dart';
import 'ticket.dart';
import 'ticket_to_preview.dart';

class TicketPreview extends StatelessWidget {
  const TicketPreview({
    Key? key,
    required this.receipt,
  }) : super(key: key);

  final Ticket receipt;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        // background
        color: Colors.grey[800],
        alignment: Alignment.center,
        child: Container(
          // receipt
          margin: const EdgeInsets.all(20),
          width: mmToDP(58), //mmToDP(58),
          color: Colors.grey[50],
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ticketToPreview(context, receipt),
            //child: Container(height: 100, color: Colors.green),
          ),
        ),
      ),
    );
  }
}
