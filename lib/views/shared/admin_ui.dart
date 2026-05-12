import 'package:flutter/material.dart';

String formatDate(DateTime? value) {
  if (value == null) {
    return '--';
  }

  final day = value.day.toString().padLeft(2, '0');
  final month = value.month.toString().padLeft(2, '0');
  final year = value.year.toString();
  return '$day/$month/$year';
}

String formatNumber(num value) {
  final isNegative = value < 0;
  final roundedValue = value.abs();
  final hasDecimal = roundedValue % 1 != 0;
  final raw = hasDecimal
      ? roundedValue.toStringAsFixed(2)
      : roundedValue.toStringAsFixed(0);
  final parts = raw.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();

  for (var index = 0; index < whole.length; index++) {
    final reversedIndex = whole.length - index;
    buffer.write(whole[index]);
    if (reversedIndex > 1 && reversedIndex % 3 == 1) {
      buffer.write(',');
    }
  }

  final decimalPart = parts.length > 1 && parts[1] != '00'
      ? '.${parts[1]}'
      : '';
  final prefix = isNegative ? '-' : '';
  return '$prefix${buffer.toString()}$decimalPart';
}

String formatCurrency(num value) {
  return '${formatNumber(value)} VND';
}

class AdminSectionCard extends StatelessWidget {
  const AdminSectionCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class InfoChip extends StatelessWidget {
  const InfoChip({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF64748B))),
          const SizedBox(width: 8),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class StatusPill extends StatelessWidget {
  const StatusPill({
    super.key,
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class Pager extends StatelessWidget {
  const Pager({
    super.key,
    required this.pageText,
    required this.hasPreviousPage,
    required this.hasNextPage,
    required this.onPrevious,
    required this.onNext,
  });

  final String pageText;
  final bool hasPreviousPage;
  final bool hasNextPage;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(pageText, style: const TextStyle(color: Color(0xFF64748B))),
        Row(
          children: [
            OutlinedButton(
              onPressed: hasPreviousPage ? onPrevious : null,
              child: const Text('Previous'),
            ),
            const SizedBox(width: 8),
            FilledButton.tonal(
              onPressed: hasNextPage ? onNext : null,
              child: const Text('Next'),
            ),
          ],
        ),
      ],
    );
  }
}
