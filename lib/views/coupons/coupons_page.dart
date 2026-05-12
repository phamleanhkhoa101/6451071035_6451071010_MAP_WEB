import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/coupon_controller.dart';
import '../../data/models/coupon_model.dart';
import '../../data/services/coupon_service.dart';

class CouponsPage extends StatefulWidget {
  const CouponsPage({super.key});

  @override
  State<CouponsPage> createState() => _CouponsPageState();
}

class _CouponsPageState extends State<CouponsPage> {
  final CouponService _service = CouponService();
  StreamSubscription<List<CouponModel>>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = _service.getAll().listen((data) {
      if (!mounted) {
        return;
      }
      context.read<CouponController>().setData(data);
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CouponController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Coupons',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1B2430),
                    ),
                  ),
                ],
              ),
            ),
            FilledButton.icon(
              onPressed: () => _showDialog(context),
              icon: const Icon(Icons.add_rounded),
              label: const Text('ThĂªm mĂ£'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              width: 360,
              child: TextField(
                onChanged: controller.search,
                decoration: InputDecoration(
                  hintText: 'TĂ¬m theo mĂ£ hoáº·c mĂ´ táº£...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            _InfoChip(label: 'Tá»•ng sá»‘', value: '${controller.totalCount}'),
            _InfoChip(label: 'Hiá»ƒn thá»‹', value: '${controller.filteredCount}'),
          ],
        ),
        const SizedBox(height: 20),
        Expanded(
          child: Container(
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
            child: controller.filteredCount == 0
                ? const Center(child: Text('ChÆ°a cĂ³ mĂ£ giáº£m giĂ¡ nĂ o Ä‘á»ƒ hiá»ƒn thá»‹.'))
                : Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: DataTable(
                            headingRowColor: WidgetStateProperty.all(
                              const Color(0xFFF1F5F9),
                            ),
                            columnSpacing: 24,
                            horizontalMargin: 12,
                            columns: const [
                              DataColumn(label: Text('SEQ')),
                              DataColumn(label: Text('MĂ£')),
                              DataColumn(label: Text('Giáº£m')),
                              DataColumn(label: Text('ÄÆ¡n tá»‘i thiá»ƒu')),
                              DataColumn(label: Text('LÆ°á»£t dĂ¹ng')),
                              DataColumn(label: Text('Háº¡n dĂ¹ng')),
                              DataColumn(label: Text('Tráº¡ng thĂ¡i')),
                              DataColumn(label: Text('Thao tĂ¡c')),
                            ],
                            rows: List.generate(controller.paginatedData.length, (
                              index,
                            ) {
                              final item = controller.paginatedData[index];
                              final rowNumber =
                                  (controller.currentPage *
                                      controller.rowsPerPage) +
                                  index +
                                  1;
                              return DataRow(
                                cells: [
                                  DataCell(Text('$rowNumber')),
                                  DataCell(_CouponCodeCell(coupon: item)),
                                  DataCell(Text(_formatDiscount(item))),
                                  DataCell(Text(_formatMoney(item.minOrderValue))),
                                  DataCell(
                                    Text('${item.usedCount}/${item.usageLimit}'),
                                  ),
                                  DataCell(Text(_formatDate(item.endDate))),
                                  DataCell(_StatusBadge(active: item.isActive)),
                                  DataCell(
                                    Wrap(
                                      spacing: 8,
                                      children: [
                                        OutlinedButton(
                                          onPressed: () =>
                                              _showDialog(context, coupon: item),
                                          child: const Text('Sá»­a'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              _confirmDelete(context, item),
                                          child: const Text('XĂ³a'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _Pager(
                        pageText:
                            'Trang ${controller.currentPage + 1}/${controller.totalPages}',
                        hasPreviousPage: controller.hasPreviousPage,
                        hasNextPage: controller.hasNextPage,
                        onPrevious: controller.previousPage,
                        onNext: controller.nextPage,
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Future<void> _confirmDelete(BuildContext context, CouponModel coupon) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('XĂ³a mĂ£ giáº£m giĂ¡'),
        content: Text('Báº¡n cĂ³ cháº¯c muá»‘n xĂ³a "${coupon.code}" khĂ´ng?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Há»§y'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('XĂ³a'),
          ),
        ],
      ),
    );

    if (shouldDelete != true || !context.mounted) {
      return;
    }

    await context.read<CouponController>().delete(coupon.id);
  }

  void _showDialog(BuildContext context, {CouponModel? coupon}) {
    final codeController = TextEditingController(text: coupon?.code ?? '');
    final descriptionController = TextEditingController(
      text: coupon?.description ?? '',
    );
    final discountController = TextEditingController(
      text: _numberText(coupon?.discountValue ?? 0),
    );
    final minOrderController = TextEditingController(
      text: _numberText(coupon?.minOrderValue ?? 0),
    );
    final maxDiscountController = TextEditingController(
      text: _numberText(coupon?.maxDiscountValue ?? 0),
    );
    final usageLimitController = TextEditingController(
      text: '${coupon?.usageLimit ?? 0}',
    );
    final usedCountController = TextEditingController(
      text: '${coupon?.usedCount ?? 0}',
    );
    var discountType = coupon?.discountType ?? 'percent';
    var isActive = coupon?.isActive ?? true;
    DateTime? startDate = coupon?.startDate;
    DateTime? endDate = coupon?.endDate;

    showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setState) => AlertDialog(
          title: Text(coupon == null ? 'ThĂªm mĂ£ giáº£m giĂ¡' : 'Cáº­p nháº­t mĂ£ giáº£m giĂ¡'),
          content: SizedBox(
            width: 480,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: codeController,
                    decoration: const InputDecoration(labelText: 'MĂ£ giáº£m giĂ¡'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descriptionController,
                    maxLines: 2,
                    decoration: const InputDecoration(labelText: 'MĂ´ táº£'),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: discountType,
                    decoration: const InputDecoration(labelText: 'Loáº¡i giáº£m'),
                    items: const [
                      DropdownMenuItem(
                        value: 'percent',
                        child: Text('Pháº§n trÄƒm'),
                      ),
                      DropdownMenuItem(
                        value: 'fixed',
                        child: Text('Sá»‘ tiá»n cá»‘ Ä‘á»‹nh'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => discountType = value);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: discountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'GiĂ¡ trá»‹ giáº£m'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: minOrderController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'GiĂ¡ trá»‹ Ä‘Æ¡n tá»‘i thiá»ƒu'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: maxDiscountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Giáº£m tá»‘i Ä‘a'),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: usageLimitController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Giá»›i háº¡n dĂ¹ng'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: usedCountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'ÄĂ£ dĂ¹ng'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final picked = await _pickDate(
                              dialogContext,
                              startDate ?? DateTime.now(),
                            );
                            if (picked != null) {
                              setState(() => startDate = picked);
                            }
                          },
                          icon: const Icon(Icons.event_rounded),
                          label: Text('Báº¯t Ä‘áº§u: ${_formatDate(startDate)}'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final picked = await _pickDate(
                              dialogContext,
                              endDate ?? DateTime.now(),
                            );
                            if (picked != null) {
                              setState(() => endDate = picked);
                            }
                          },
                          icon: const Icon(Icons.event_available_rounded),
                          label: Text('Káº¿t thĂºc: ${_formatDate(endDate)}'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: isActive,
                    title: const Text('KĂ­ch hoáº¡t'),
                    onChanged: (value) => setState(() => isActive = value),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Há»§y'),
            ),
            FilledButton(
              onPressed: () async {
                final trimmedCode = codeController.text.trim().toUpperCase();
                if (trimmedCode.isEmpty) {
                  return;
                }

                final model = CouponModel(
                  id: coupon?.id ?? '',
                  code: trimmedCode,
                  description: descriptionController.text.trim(),
                  discountType: discountType,
                  discountValue:
                      double.tryParse(discountController.text.trim()) ?? 0,
                  minOrderValue:
                      double.tryParse(minOrderController.text.trim()) ?? 0,
                  maxDiscountValue:
                      double.tryParse(maxDiscountController.text.trim()) ?? 0,
                  usageLimit:
                      int.tryParse(usageLimitController.text.trim()) ?? 0,
                  usedCount: int.tryParse(usedCountController.text.trim()) ?? 0,
                  isActive: isActive,
                  startDate: startDate,
                  endDate: endDate,
                  createdAt: coupon?.createdAt ?? DateTime.now(),
                  updatedAt: DateTime.now(),
                );

                final controller = context.read<CouponController>();
                if (coupon == null) {
                  await controller.create(model);
                } else {
                  await controller.update(model);
                }

                if (!dialogContext.mounted) {
                  return;
                }
                Navigator.of(dialogContext).pop();
              },
              child: Text(coupon == null ? 'ThĂªm' : 'LÆ°u'),
            ),
          ],
        ),
      ),
    );
  }

  Future<DateTime?> _pickDate(BuildContext context, DateTime initialDate) {
    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
  }

  String _formatDiscount(CouponModel coupon) {
    if (coupon.discountType == 'percent') {
      return '${_numberText(coupon.discountValue)}%';
    }
    return _formatMoney(coupon.discountValue);
  }

  String _formatMoney(double value) {
    if (value <= 0) {
      return '--';
    }
    return '${_numberText(value)}Ä‘';
  }

  String _numberText(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(2);
  }

  String _formatDate(DateTime? value) {
    if (value == null) {
      return '--';
    }

    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    final year = value.year.toString();
    return '$day/$month/$year';
  }
}

class _CouponCodeCell extends StatelessWidget {
  const _CouponCodeCell({required this.coupon});

  final CouponModel coupon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            coupon.code,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          Text(
            coupon.description.isEmpty ? 'ChÆ°a cĂ³ mĂ´ táº£' : coupon.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, required this.value});

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

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = active ? const Color(0xFF2E7D32) : const Color(0xFFB71C1C);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        active ? 'Active' : 'Inactive',
        style: TextStyle(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _Pager extends StatelessWidget {
  const _Pager({
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
              child: const Text('TrÆ°á»›c'),
            ),
            const SizedBox(width: 8),
            FilledButton.tonal(
              onPressed: hasNextPage ? onNext : null,
              child: const Text('Sau'),
            ),
          ],
        ),
      ],
    );
  }
}

