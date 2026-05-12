import 'package:flutter/material.dart';

import '../../data/models/customer_model.dart';
import '../shared/admin_ui.dart';

class CustomerDetailPage extends StatelessWidget {
  const CustomerDetailPage({super.key, required this.customer});

  final CustomerModel customer;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(customer.fullName),
      content: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _row('Email', customer.email),
            _row('Phone', customer.phone),
            _row('City', customer.city),
            _row('Tier', customer.tier),
            _row('Status', customer.status),
            _row('Orders', '${customer.totalOrders}'),
            _row('Spent', formatCurrency(customer.totalSpent)),
            _row('Joined', formatDate(customer.createdAt)),
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
