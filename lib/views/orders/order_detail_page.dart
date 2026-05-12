import 'package:flutter/material.dart';

import '../../data/models/order_model.dart';
import '../shared/admin_ui.dart';

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Order ${order.orderCode}'),
      content: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _row('Customer', order.customerName),
            _row('Phone', order.customerPhone),
            _row('Payment', order.paymentMethod),
            _row('Status', order.status),
            _row('Items', '${order.itemsCount}'),
            _row('Total', formatCurrency(order.totalAmount)),
            _row('Date', formatDate(order.createdAt)),
            _row('Address', order.shippingAddress),
            _row('Note', order.note.isEmpty ? '--' : order.note),
          ],
        ),
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Color(0xFF1B2430), height: 1.5),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
